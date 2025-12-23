import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static const _kOnboardingComplete = 'onboarding_complete';

  static const _kDisplayName = 'display_name';
  static const _kConsentTerms = 'consent_terms';
  static const _kConsentPrivacy = 'consent_privacy';
  static const _kConsentKvkk = 'consent_kvkk';

  // Profil (kıyafet uygulaması için)
  static const _kHeightCm = 'profile_height_cm';
  static const _kWeightKg = 'profile_weight_kg';
  static const _kSize = 'profile_size'; // XS,S,M,L,XL...
  static const _kStyle = 'profile_style'; // casual, street, classic...
  static const _kPermCamera = 'perm_camera';
  static const _kPermNotifications = 'perm_notifications';

  Future<void> setPermissions({
    required bool camera,
    required bool notifications,
  }) async {
    await _sp.setBool(_kPermCamera, camera);
    await _sp.setBool(_kPermNotifications, notifications);
  }
  bool get permCamera => _sp.getBool(_kPermCamera) ?? false;
  bool get permNotifications => _sp.getBool(_kPermNotifications) ?? false;


  final SharedPreferences _sp;

  final ValueNotifier<bool> onboardingDoneNotifier;

  AppPrefs(this._sp)
      : onboardingDoneNotifier =
  ValueNotifier<bool>(_sp.getBool(_kOnboardingComplete) ?? false);

  bool get onboardingComplete => onboardingDoneNotifier.value;

  String get displayName => _sp.getString(_kDisplayName) ?? '';
  bool get consentTerms => _sp.getBool(_kConsentTerms) ?? false;
  bool get consentPrivacy => _sp.getBool(_kConsentPrivacy) ?? false;
  bool get consentKvkk => _sp.getBool(_kConsentKvkk) ?? false;

  int get heightCm => _sp.getInt(_kHeightCm) ?? 0;
  int get weightKg => _sp.getInt(_kWeightKg) ?? 0;
  String get size => _sp.getString(_kSize) ?? '';
  String get style => _sp.getString(_kStyle) ?? '';

  Future<void> setDisplayName(String v) async => _sp.setString(_kDisplayName, v);

  Future<void> setConsents({
    required bool terms,
    required bool privacy,
    required bool kvkk,
  }) async {
    await _sp.setBool(_kConsentTerms, terms);
    await _sp.setBool(_kConsentPrivacy, privacy);
    await _sp.setBool(_kConsentKvkk, kvkk);
  }

  Future<void> setProfile({
    required int heightCm,
    required int weightKg,
    required String size,
    required String style,
  }) async {
    await _sp.setInt(_kHeightCm, heightCm);
    await _sp.setInt(_kWeightKg, weightKg);
    await _sp.setString(_kSize, size);
    await _sp.setString(_kStyle, style);
  }

  Future<void> setOnboardingComplete(bool v) async {
    await _sp.setBool(_kOnboardingComplete, v);
    onboardingDoneNotifier.value = v; // router refresh
  }
}
