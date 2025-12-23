// lib/features/splash/splash_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/onboarding_controller.dart';

const _kOnboarding = '/onboarding';
const _kHome = '/home';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    // İlk frame sonrası navigate (context güvenli)
    WidgetsBinding.instance.addPostFrameCallback((_) => _goNext());
  }

  void _goNext() {
    if (_navigated || !mounted) return;
    _navigated = true;

    final prefs = ref.read(appPrefsProvider);
    final target = prefs.onboardingComplete ? _kHome : _kOnboarding;

    // replace: splash stack'te kalmasın
    context.go(target);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
