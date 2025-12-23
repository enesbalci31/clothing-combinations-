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

class OnboardingController extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    final prefs = ref.read(appPrefsProvider);

    if (prefs.onboardingComplete) {
      return OnboardingState(
        stepIndex: 5,
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

  // --- setters
  void setName(String v) => state = state.copyWith(displayName: v.trim());
  void setHeight(int v) => state = state.copyWith(heightCm: v);
  void setWeight(int v) => state = state.copyWith(weightKg: v);
  void setSize(String v) => state = state.copyWith(size: v);
  void setStyle(String v) => state = state.copyWith(style: v);

  void setConsentTerms(bool v) => state = state.copyWith(consentTerms: v);
  void setConsentPrivacy(bool v) => state = state.copyWith(consentPrivacy: v);
  void setConsentKvkk(bool v) => state = state.copyWith(consentKvkk: v);

  void setWantsNotifications(bool v) => state = state.copyWith(wantsNotifications: v);
  void setWantsCamera(bool v) => state = state.copyWith(wantsCamera: v);

  void back() {
    if (state.isBusy) return;
    if (state.stepIndex == 0) return;
    state = state.copyWith(stepIndex: state.stepIndex - 1);
  }

  // Devam -> validasyon hatası varsa mesaj döner
  String? next() {
    if (state.isBusy) return null;

    final i = state.stepIndex;

    // 0: Start ekranı -> direkt geç
    if (i == 1) {
      // Profil info
      if (state.displayName.isEmpty) return 'Lütfen adını gir';
      if (state.displayName.length < 2) return 'İsim çok kısa';
      if (state.heightCm < 120 || state.heightCm > 230) return 'Boy (cm) 120-230 arası olmalı';
      if (state.weightKg < 35 || state.weightKg > 200) return 'Kilo (kg) 35-200 arası olmalı';
      if (state.size.isEmpty) return 'Lütfen beden seç';
      if (state.style.isEmpty) return 'Lütfen stil seç';
    }

    if (i == 2) {
      // KVKK/Terms
      if (!state.consentsOk) return 'Devam etmek için tüm onayları kabul etmelisin';
    }

    if (i >= 5) return null;

    state = state.copyWith(stepIndex: i + 1);
    return null;
  }

  Future<void> requestCameraIfWanted() async {
    if (!state.wantsCamera) return;

    // Android/iOS kamera izni


    // İstersen burada status’a göre UI mesajı gösterebilirsin (SnackBar)
    // Şimdilik akışı bloklamıyoruz.
    // if (!status.isGranted) ...
  }

  Future<void> completeAndGoLoading() async {
    final prefs = ref.read(appPrefsProvider);

    state = state.copyWith(isBusy: true);

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

    // kısa loading hissi
    await Future<void>.delayed(const Duration(milliseconds: 5000));

    await prefs.setOnboardingComplete(true); // router -> /home
    state = state.copyWith(isBusy: false);
  }
}
