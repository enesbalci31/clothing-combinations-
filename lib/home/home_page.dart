import 'package:clothess/home/widgets/home_app_bar.dart';
import 'package:clothess/home/widgets/home_body.dart';
import 'package:clothess/home/widgets/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/ui/app_background.dart';
import '../features/onboarding/onboarding_controller.dart';


class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final prefs = ref.read(appPrefsProvider);
    final name = prefs.displayName.isNotEmpty ? prefs.displayName : '👋';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: HomeAppBar(name: name),
      body: AppBackground.onboarding(
        child: SafeArea(
          child: IndexedStack(
            index: _tabIndex,
            children: [
              HomeBody(
                onTakePhoto: () {
                  // TODO: kamera -> ürün/müşteri foto
                },
                onNewRecord: () {
                  // TODO: yeni kayıt akışı
                },
                onGoRecords: () => setState(() => _tabIndex = 1),
              ),
              const RecordsPlaceholder(),
              const ProfilePlaceholder(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        index: _tabIndex,
        onChanged: (i) => setState(() => _tabIndex = i),
      ),
    );
  }
}
