import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'shared/prefs.dart';
import 'features/onboarding/onboarding_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sp = await SharedPreferences.getInstance();
  final prefs = AppPrefs(sp);

  runApp(
    ProviderScope(
      overrides: [
        appPrefsProvider.overrideWithValue(prefs),
      ],
      child: const ClothesApp(),
    ),
  );
}

class ClothesApp extends ConsumerWidget {
  const ClothesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          routerConfig: router,
        );
      },
    );
  }
}
