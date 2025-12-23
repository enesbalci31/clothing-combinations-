import 'package:flutter/material.dart';

class ResponsiveBody extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  /// Tablet/web için içerik genişliği sınırı
  final double maxWidth;

  const ResponsiveBody({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.maxWidth = 560,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          final target = w > maxWidth ? maxWidth : w;

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: target),
              child: Padding(
                padding: padding,
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}

