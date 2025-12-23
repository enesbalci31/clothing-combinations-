import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/onboarding/onboarding_controller.dart';
import '../features/onboarding/onboarding_page.dart';
import '../features/splash/splash_view.dart';
import '../home/home_page.dart';
import '../settings/settings_page.dart';

const _kSplash = '/splash';
const _kOnboarding = '/onboarding';
const _kHome = '/home';
const _kSettings = '/settings';

CustomTransitionPage<T> _fadePage<T>({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return FadeTransition(opacity: curved, child: child);
    },
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  final prefs = ref.read(appPrefsProvider);

  return GoRouter(
    // ✅ Uygulama her açılışta önce Flutter Splash görünsün
    initialLocation: _kSplash,

    // ✅ onboardingDone değişirse redirect tekrar çalışsın
    refreshListenable: prefs.onboardingDoneNotifier,

    routes: [
      GoRoute(
        path: _kSplash,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SplashView(),
        ),
      ),

      GoRoute(
        path: _kOnboarding,
        pageBuilder: (context, state) => _fadePage(
          state: state,
          child: const OnboardingPage(),
        ),
      ),
      GoRoute(
        path: _kHome,
        pageBuilder: (context, state) => _fadePage(
          state: state,
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: _kSettings,
        pageBuilder: (context, state) => _fadePage(
          state: state,
          child: const SettingsPage(),
        ),
      ),
    ],

    redirect: (context, state) {
      final done = prefs.onboardingComplete;
      final path = state.uri.path;

      final goingSplash = path == _kSplash;
      final goingOnboarding = path == _kOnboarding;

      // ✅ Splash her zaman serbest (ilk açılışta gösterilecek)
      if (goingSplash) return null;

      // ✅ Onboarding bitmediyse, onboarding dışındaki her şeyi onboarding’e at
      if (!done && !goingOnboarding) return _kOnboarding;

      // ✅ Onboarding bittiyse onboarding’e gidiliyorsa home’a at
      if (done && goingOnboarding) return _kHome;

      return null;
    },
  );
});
