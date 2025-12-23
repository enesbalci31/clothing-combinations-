import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../onboarding/onboarding_controller.dart';

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

    // ✅ Native splash sonrası ilk frame gelir gelmez yönlendir
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _goNext();
    });
  }

  void _goNext() {
    if (!mounted || _navigated) return;
    _navigated = true;

    final prefs = ref.read(appPrefsProvider);
    context.go(prefs.onboardingComplete ? '/home' : '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Bu ekran pratikte 1 frame görünüp çıkacak (köprü ekran)
    // Beyaz flash olmasın diye arka planı koyu tutuyoruz.
    return const Scaffold(
      backgroundColor: Color(0xFF0F172A),
      body: SizedBox.expand(),
    );
  }
}
