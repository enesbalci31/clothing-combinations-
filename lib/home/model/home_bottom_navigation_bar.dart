import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({
    super.key,
    this.variant = NavVariant.dark,
    this.onPlusTap,
  });

  final NavVariant variant;
  final VoidCallback? onPlusTap;

  /// + buton hariç item listesi.
  /// Buraya ekleyip çıkarabilirsin.
  static const items = <NavItem>[
    NavItem(
      route: '/home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Ana',
    ),
    NavItem(
      route: '/records',
      icon: Icons.list_alt_outlined,
      activeIcon: Icons.list_alt,
      label: 'Kayıtlar',
    ),
    NavItem(
      route: '/profile',
      icon: Icons.person_outline,

      activeIcon: Icons.person,
      label: 'Profil',
    ),
    // ÖRNEK EKLEME:
     NavItem(route: '/settings', icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'Ayarlar'),
  ];

  int _indexFromLocation(String path) {
    final i = items.indexWhere((e) => path.startsWith(e.route));
    return i < 0 ? 0 : i;
  }

  void _go(BuildContext context, int index) {
    final route = items[index].route;
    final current = GoRouterState.of(context).uri.path;
    if (current.startsWith(route)) return;
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final selectedIndex = _indexFromLocation(path);

    final style = variant.style;

    // Ortadaki + buton, menüyü 2ye böldüğü için:
    final leftCount = (items.length / 2).floor();
    final left = items.take(leftCount).toList();
    final right = items.skip(leftCount).toList();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 15, 2, 10),
        child: SizedBox(
          height: 75,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Alt bar (notch’lu)
              Positioned.fill(
                child: ClipPath(
                  clipper: _NotchClipper(notchRadius: 30, notchWidth: 78),
                  child: Container(
                    decoration: BoxDecoration(
                      color: style.barColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amberAccent.withValues(alpha: 0.18),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // SOL ikonlar
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(left.length, (i) {
                              final realIndex = i;
                              final isSelected = selectedIndex == realIndex;
                              final item = left[i];
                              return _NavIconButton(
                                selected: isSelected,
                                icon: isSelected ? item.activeIcon : item.icon,
                                activeColor: style.activeColor,
                                inactiveColor: style.inactiveColor,
                                onTap: () => _go(context, realIndex),
                              );
                            }),
                          ),
                        ),

                        // NOTCH boşluğu (orta)
                        const SizedBox(width: 50),

                        // SAĞ ikonlar
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(right.length, (i) {
                              final realIndex = left.length + i;
                              final isSelected = selectedIndex == realIndex;
                              final item = right[i];
                              return _NavIconButton(
                                selected: isSelected,
                                icon: isSelected ? item.activeIcon : item.icon,
                                activeColor: style.activeColor,
                                inactiveColor: style.inactiveColor,
                                onTap: () => _go(context, realIndex),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Ortadaki + buton (floating)
              Positioned(
                top: -20,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: onPlusTap,
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: style.plusColor,
                        boxShadow: [
                          BoxShadow(
                            color: style.plusColor.withValues(alpha: 0.35),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(Icons.add, color: style.plusIconColor, size: 40),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final String route;
  final IconData icon;
  final IconData activeIcon;
  final String label; // İstersen tooltip için kullanırsın
  const NavItem({
    required this.route,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

enum NavVariant { dark, light }

extension on NavVariant {
  _NavStyle get style {
    switch (this) {
      case NavVariant.light:
        return const _NavStyle(
          barColor: Colors.white,
          activeColor: Color(0xFF6D28D9), // mor
          inactiveColor: Colors.white, // koyu
          plusColor: Color(0xFF6D28D9),
          plusIconColor: Colors.white,
        );
      case NavVariant.dark:
        return const _NavStyle(
          barColor: Colors.amberAccent, // koyu
          activeColor: Color(0xFF8B5CF6), // mor
          inactiveColor: Colors.deepPurple, // gri
          plusColor: Color(0xFF8B5CF6),
          plusIconColor: Colors.white,
        );
    }
  }
}

class _NavStyle {
  final Color barColor;
  final Color activeColor;
  final Color inactiveColor;
  final Color plusColor;
  final Color plusIconColor;
  const _NavStyle({
    required this.barColor,
    required this.activeColor,
    required this.inactiveColor,
    required this.plusColor,
    required this.plusIconColor,
  });
}

class _NavIconButton extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavIconButton({
    required this.selected,
    required this.icon,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? activeColor : inactiveColor;

    return InkResponse(
      onTap: onTap,
      radius: 28,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutBack,
        scale: selected ? 1.12 : 1.0,
        child: Icon(icon, color: color, size: 29),
      ),
    );
  }
}

/// Ortası oyuk “U” çentik için clipper
class _NotchClipper extends CustomClipper<Path> {
  _NotchClipper({required this.notchRadius, required this.notchWidth});

  final double notchRadius;
  final double notchWidth;

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    final center = w / 2;
    final notchHalf = notchWidth / 2;

    final path = Path();

    // sol üst
    path.moveTo(0, 0);
    // çentiğin sol başlangıcı
    path.lineTo(center - notchHalf, 0);

    // çentik (U şekli)
    path.quadraticBezierTo(
      center - notchHalf + 10,
      0,
      center - notchHalf + 16,
      14,
    );
    path.arcToPoint(
      Offset(center + notchHalf - 16, 14),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );
    path.quadraticBezierTo(
      center + notchHalf - 10,
      0,
      center + notchHalf,
      0,
    );

    // sağ üst
    path.lineTo(w, 0);
    // sağ alt
    path.lineTo(w, h);
    // sol alt
    path.lineTo(0, h);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant _NotchClipper oldClipper) {
    return oldClipper.notchRadius != notchRadius ||
        oldClipper.notchWidth != notchWidth;
  }
}
