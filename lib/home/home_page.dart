import 'package:clothess/home/ui/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/onboarding/onboarding_controller.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_body.dart';
import 'model/home_bottom_navigation_bar.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.read(appPrefsProvider);
    final name = prefs.displayName.isNotEmpty ? prefs.displayName : '👋';

    return AppBackground.onboarding(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: HomeAppBar(name: name),
        body: SafeArea(
          child: HomeBody(
            onTakePhoto: () {
              // TODO: kamera -> ürün/müşteri foto
            },
            onNewRecord: () {
              // TODO: yeni kayıt akışı
            },
            onGoRecords: () {
              // Route tabanlı gidiyoruz:
              context.go('/records');
            },
          ),
        ),
        bottomNavigationBar: HomeBottomNav(
          variant: NavVariant.dark,
          onPlusTap: () {
            // TODO: + butonu ile “Yeni Kayıt” / “Foto Çek”
          },
        ),
      ),
    );
  }
}
