import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../steps/step_celebrate.dart';
import '../steps/step_kvkk.dart';
import '../steps/step_start.dart';
import '../steps/step_profile.dart';
import '../steps/step_permissions.dart';
import 'onboarding_controller.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  int _step = 0;

  // Step 2: Profil
  String _name = '';
  int _height = 0;
  int _weight = 0;
  String _size = '';
  String _style = '';

  // Step 3: Legal
  bool _acceptedTerms = false;
  bool _acceptedPrivacy = false;
  bool _acceptedKvkk = false;

  // Step 4: Permissions (şimdilik UI state)
  bool _cameraAllowed = false;
  bool _notificationsAllowed = false;

  bool _saving = false;

  void _next() {
    setState(() => _step = (_step + 1).clamp(0, 5));
  }

  void _back() {
    if (_step == 0) return;
    setState(() => _step = (_step - 1).clamp(0, 5));
  }

  Future<void> _finish() async {
    if (_saving) return;
    setState(() => _saving = true);

    try {
      final prefs = ref.read(appPrefsProvider);

      await prefs.setDisplayName(_name.trim());
      await prefs.setProfile(
        heightCm: _height,
        weightKg: _weight,
        size: _size,
        style: _style,
      );

      await prefs.setConsents(
        terms: _acceptedTerms,
        privacy: _acceptedPrivacy,
        kvkk: _acceptedKvkk,
      );

      await prefs.setPermissions(
        camera: _cameraAllowed,
        notifications: _notificationsAllowed,
      );

      await prefs.setOnboardingComplete(true);

      if (!mounted) return;
      context.go('/home');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kaydedilemedi: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // İstersen step sayısını burada değiştirirsin
    // 0 Start, 1 Profile, 2 Legal, 3 Permissions, 4 Celebration
    final body = switch (_step) {
      0 => StepStart(onNext: _next),

      1 => StepProfile(
        name: _name,
        heightCm: _height,
        weightKg: _weight,
        size: _size,
        style: _style,
        onName: (v) => setState(() => _name = v),
        onHeight: (v) => setState(() => _height = v),
        onWeight: (v) => setState(() => _weight = v),
        onSize: (v) => setState(() => _size = v),
        onStyle: (v) => setState(() => _style = v),
        onNext: _next,
        onBack: _back,
      ),

      2 => StepLegal(
        acceptedTerms: _acceptedTerms,
        acceptedPrivacy: _acceptedPrivacy,
        acceptedKvkk: _acceptedKvkk,
        onTermsChanged: (v) => setState(() => _acceptedTerms = v),
        onPrivacyChanged: (v) => setState(() => _acceptedPrivacy = v),
        onKvkkChanged: (v) => setState(() => _acceptedKvkk = v),
        onNext: _next,
        onBack: _back,
      ),

      3 => StepPermissions(
        cameraAllowed: _cameraAllowed,
        notificationsAllowed: _notificationsAllowed,
        onCameraChanged: (v) => setState(() => _cameraAllowed = v),
        onNotificationsChanged: (v) => setState(() => _notificationsAllowed = v),
        onNext: _next,
        onBack: _back,
      ),

      4 => StepCelebration(
        onNext: _finish, // burada home’a atacağız
      ),

      _ => StepCelebration(onNext: _finish),
    };

    return Stack(
      children: [
        Scaffold(body: body),
        if (_saving)
          const IgnorePointer(
            child: ColoredBox(
              color: Color(0x66000000),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
