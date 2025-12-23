import 'package:flutter/material.dart';

class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    required this.child,
    this.title,
    this.progress,
    this.onBack,
    this.primaryText = 'Devam',
    this.onPrimary,
    this.secondaryText,
    this.onSecondary,
    this.primaryEnabled = true,
    this.showBack = true,
    this.background,

  });
  final Widget? background;

  final Widget child;
  final String? title;
  final double? progress; // 0..1
  final VoidCallback? onBack;

  final String primaryText;
  final VoidCallback? onPrimary;
  final bool primaryEnabled;

  final String? secondaryText;
  final VoidCallback? onSecondary;

  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
        body: Stack(
            children: [
            // Background
            if (background != null) Positioned.fill(child: background!),

    SafeArea(
    child: Column(

    children: [
            // Top bar (geri + progress)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: [
                  if (showBack)
                    IconButton(
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    )
                  else
                    const SizedBox(width: 48),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null)
                          Text(title!, style: theme.textTheme.titleMedium),
                        if (progress != null) ...[
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: progress!.clamp(0, 1),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content (scroll)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: child,
              ),
            ),

            // Bottom actions (sabit)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: primaryEnabled ? onPrimary : null,
                      child: Text(primaryText),
                    ),
                  ),
                  if (secondaryText != null && onSecondary != null) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: onSecondary,
                        child: Text(secondaryText!),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),


        ]
        ));


  }
}
