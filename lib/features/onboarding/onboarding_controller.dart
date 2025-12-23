import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/prefs.dart';
import 'onboarding_state.dart';

final appPrefsProvider = Provider<AppPrefs>((ref) {
  throw UnimplementedError('AppPrefs must be overridden in main.dart');
});

final onboardingControllerProvider =
NotifierProvider<OnboardingController, OnboardingState>(
  OnboardingController.new,
);

enum OnboardingStep { start, profile, legal, permissions, review, done }

extension OnboardingStepX on OnboardingStep {
  int get index => switch (this) {
    OnboardingStep.start => 0,
    OnboardingStep.profile => 1,
    OnboardingStep.legal => 2,
    OnboardingStep.permissions => 3,
    OnboardingStep.review => 4,
    OnboardingStep.done => 5,
  };

  static OnboardingStep fromIndex(int i) {
    return switch (i) {
      0 => OnboardingStep.start,
      1 => OnboardingStep.profile,
      2 => OnboardingStep.legal,
      3 => OnboardingStep.permissions,
      4 => OnboardingStep.review,
      _ => OnboardingStep.done,
    };
  }
}

class OnboardingController extends Notifier<OnboardingState> {
  static const _loadingDelay = Duration(milliseconds: 700);

  @override
  OnboardingState build() {
    final prefs = ref.read(appPrefsProvider);

    if (prefs.onboardingComplete) {
      return OnboardingState(
        stepIndex: OnboardingStep.done.index,
        isBusy: false,
        displayName: prefs.displayName,
        heightCm: prefs.heightCm,
        weightKg: prefs.weightKg,
        size: prefs.size,
        style: prefs.style,
        consentTerms: prefs.consentTerms,
        consentPrivacy: prefs.consentPrivacy,
        consentKvkk: prefs.consentKvkk,
        wantsNotifications: false,
        wantsCamera: true,
      );
    }

    return OnboardingState.empty;
  }

  // ---- computed
  OnboardingStep get step => OnboardingStepX.fromIndex(state.stepIndex);

  bool get canGoBack => !state.isBusy && state.stepIndex > OnboardingStep.start.index;

  bool get canGoNext => !state.isBusy && validateCurrentStep() == null;

  // ---- setters
  void setName(String v) => _set(state.copyWith(displayName: v.trim()));
  void setHeight(int v) => _set(state.copyWith(heightCm: v));
  void setWeight(int v) => _set(state.copyWith(weightKg: v));
  void setSize(String v) => _set(state.copyWith(size: v));
  void setStyle(String v) => _set(state.copyWith(style: v));

  void setConsentTerms(bool v) => _set(state.copyWith(consentTerms: v));
  void setConsentPrivacy(bool v) => _set(state.copyWith(consentPrivacy: v));
  void setConsentKvkk(bool v) => _set(state.copyWith(consentKvkk: v));

  void setWantsNotifications(bool v) => _set(state.copyWith(wantsNotifications: v));
  void setWantsCamera(bool v) => _set(state.copyWith(wantsCamera: v));

  // ---- navigation
  void back() {
    if (!canGoBack) return;
    _set(state.copyWith(stepIndex: state.stepIndex - 1));
  }

  /// Devam basılınca:
  /// - valid değilse hata mesajı döner
  /// - validse bir sonraki adıma geçer ve null döner
  String? next() {
    if (state.isBusy) return null;

    final err = validateCurrentStep();
    if (err != null) return err;

    if (state.stepIndex >= OnboardingStep.done.index) return null;

    _set(state.copyWith(stepIndex: state.stepIndex + 1));
    return null;
  }

  /// Step bazlı validasyon tek yerde
  String? validateCurrentStep() => _validate(step);

  String? _validate(OnboardingStep s) {
    switch (s) {
      case OnboardingStep.start:
        return null;

      case OnboardingStep.profile:
        final name = state.displayName.trim();
        if (name.isEmpty) return 'Lütfen adını gir';
        if (name.length < 2) return 'İsim çok kısa';
        if (state.heightCm < 120 || state.heightCm > 230) return 'Boy (cm) 120-230 arası olmalı';
        if (state.weightKg < 35 || state.weightKg > 200) return 'Kilo (kg) 35-200 arası olmalı';
        if (state.size.isEmpty) return 'Lütfen beden seç';
        if (state.style.isEmpty) return 'Lütfen stil seç';
        return null;

      case OnboardingStep.legal:
        if (!state.consentsOk) return 'Devam etmek için tüm onayları kabul etmelisin';
        return null;

      case OnboardingStep.permissions:

        return null;

      case OnboardingStep.review:
      // Son kontrol ekranın varsa buraya doğrulama eklenir.
        return null;

      case OnboardingStep.done:
        return null;
    }
  }

  /// Permission istekleri burada
  Future<void> requestCameraIfWanted() async {
    if (!state.wantsCamera) return;
    // permission_handler entegrasyonu burada:
    // final status = await Permission.camera.request();
  }

  Future<void> completeAndGoLoading() async {
    if (state.isBusy) return;

    // Son bir güvenlik: legal kabul edilmemişse bitirtme
    if (!state.consentsOk) return;

    final prefs = ref.read(appPrefsProvider);

    _set(state.copyWith(isBusy: true));
    try {
      await prefs.setDisplayName(state.displayName);
      await prefs.setProfile(
        heightCm: state.heightCm,
        weightKg: state.weightKg,
        size: state.size,
        style: state.style,
      );
      await prefs.setConsents(
        terms: state.consentTerms,
        privacy: state.consentPrivacy,
        kvkk: state.consentKvkk,
      );

      await Future<void>.delayed(_loadingDelay);

      await prefs.setOnboardingComplete(true);
      _set(state.copyWith(isBusy: false, stepIndex: OnboardingStep.done.index));
    } catch (_) {
      _set(state.copyWith(isBusy: false));
      rethrow;
    }
  }

  void _set(OnboardingState newState) {
    if (identical(state, newState)) return;
    state = newState;
  }
}
