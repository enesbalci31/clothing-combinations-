import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  const HomeAppBar({super.key, required this.name});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Hoş geldin, $name',
        style: t.titleLarge?.copyWith(color: Colors.white),
      ),
      actions: [
        IconButton(
          tooltip: 'Profil',
          onPressed: () {
            // TODO: Profil route/sekme
          },
          icon: const Icon(Icons.person_outline, color: Colors.white),
        ),
      ],
    );
  }
}
