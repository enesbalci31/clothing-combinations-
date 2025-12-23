class OnboardingState {
  final int stepIndex; // 0..5
  final bool isBusy;

  final String displayName;

  final int heightCm;
  final int weightKg;
  final String size;
  final String style;

  final bool consentTerms;
  final bool consentPrivacy;
  final bool consentKvkk;

  final bool wantsNotifications; // UI seçimi
  final bool wantsCamera;        // UI seçimi

  const OnboardingState({
    required this.stepIndex,
    required this.isBusy,
    required this.displayName,
    required this.heightCm,
    required this.weightKg,
    required this.size,
    required this.style,
    required this.consentTerms,
    required this.consentPrivacy,
    required this.consentKvkk,
    required this.wantsNotifications,
    required this.wantsCamera,
  });

  bool get consentsOk => consentTerms && consentPrivacy && consentKvkk;

  OnboardingState copyWith({
    int? stepIndex,
    bool? isBusy,
    String? displayName,
    int? heightCm,
    int? weightKg,
    String? size,
    String? style,
    bool? consentTerms,
    bool? consentPrivacy,
    bool? consentKvkk,
    bool? wantsNotifications,
    bool? wantsCamera,
  }) {
    return OnboardingState(
      stepIndex: stepIndex ?? this.stepIndex,
      isBusy: isBusy ?? this.isBusy,
      displayName: displayName ?? this.displayName,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      size: size ?? this.size,
      style: style ?? this.style,
      consentTerms: consentTerms ?? this.consentTerms,
      consentPrivacy: consentPrivacy ?? this.consentPrivacy,
      consentKvkk: consentKvkk ?? this.consentKvkk,
      wantsNotifications: wantsNotifications ?? this.wantsNotifications,
      wantsCamera: wantsCamera ?? this.wantsCamera,
    );
  }

  static const empty = OnboardingState(
    stepIndex: 0,
    isBusy: false,
    displayName: '',
    heightCm: 0,
    weightKg: 0,
    size: '',
    style: '',
    consentTerms: false,
    consentPrivacy: false,
    consentKvkk: false,
    wantsNotifications: false,
    wantsCamera: true,
  );
}
