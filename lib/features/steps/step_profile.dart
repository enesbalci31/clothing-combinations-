import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../onboarding/widgets/ob_field.dart';
import 'step_shell.dart';

class StepProfile extends StatelessWidget {
  const StepProfile({
    super.key,
    required this.name,
    required this.heightCm,
    required this.weightKg,
    required this.size,
    required this.style,
    required this.onName,
    required this.onHeight,
    required this.onWeight,
    required this.onSize,
    required this.onStyle,
    required this.onNext,
    required this.onBack,
  });

  final String name;
  final int heightCm;
  final int weightKg;
  final String size;
  final String style;

  final ValueChanged<String> onName;
  final ValueChanged<int> onHeight;
  final ValueChanged<int> onWeight;
  final ValueChanged<String> onSize;
  final ValueChanged<String> onStyle;

  final VoidCallback onNext;
  final VoidCallback onBack;

  // ✅ Net sınırlar
  static const int _minHeight = 50;
  static const int _maxHeight = 250;
  static const int _minWeight = 20;
  static const int _maxWeight = 200;

  bool get _isValid =>
      name.trim().length >= 2 &&
          heightCm >= _minHeight &&
          heightCm <= _maxHeight &&
          weightKg >= _minWeight &&
          weightKg <= _maxWeight &&
          size.trim().isNotEmpty &&
          style.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    final fieldTheme = Theme.of(context).copyWith(
      inputDecorationTheme: _inputDecorationTheme(),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.white.withValues(alpha: 0.95),
        selectionColor: Colors.white.withValues(alpha: 0.20),
        selectionHandleColor: Colors.white.withValues(alpha: 0.80),
      ),
    );

    return Theme(
      data: fieldTheme,
      child: StepShell(
        gradient: const [
          Color(0xFF0F172A),
          Color(0xFF3B82F6),
          Color(0xFFEC4899),
        ],
        emojis: const ['👕', '📏', '⚖️', '🎯', '✨', '🧥', '🧢'],
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          children: [
            Row(
              children: [
                _IconPillButton(icon: Icons.arrow_back_rounded, onTap: onBack),
                SizedBox(width: 3.w),
                const Expanded(child: _StepProgress(current: 2, total: 4)),
              ],
            ),
            SizedBox(height: 2.4.h),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profilini tanıyalım',
                      style: t.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Beden, boy ve stil bilgilerinle sana daha isabetli öneriler çıkaracağız.',
                      style: t.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.92),
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: 2.2.h),

                    _SectionTitle(title: 'Temel bilgiler'),
                    SizedBox(height: 1.2.h),

                    _GlassCard(
                      child: Column(
                        children: [
                          ObField(
                            emoji: '🙋‍♂️',
                            label: 'Adın',
                            helper: 'Sana kişisel bir deneyim sunmak için.',
                            child: TextFormField(
                              initialValue: name,
                              style: const TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.w700,
                              ),
                              onChanged: onName,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(hintText: ''),
                            ),
                          ),
                          SizedBox(height: 1.6.h),

                          Row(
                            children: [
                              Expanded(
                                child: ObField(
                                  emoji: '📏',
                                  label: 'Boy (cm)',
                                  helper: '$_minHeight–$_maxHeight cm',
                                  child: TextFormField(
                                    initialValue: heightCm == 0 ? '' : '$heightCm',
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                      color: Colors.lightBlue,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    onChanged: (v) => onHeight(int.tryParse(v) ?? 0),
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: ObField(
                                  emoji: '⚖️',
                                  label: 'Kilo (kg)',
                                  helper: '$_minWeight–$_maxWeight kg',
                                  child: TextFormField(
                                    initialValue: weightKg == 0 ? '' : '$weightKg',
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                      color: Colors.lightBlue,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    onChanged: (v) => onWeight(int.tryParse(v) ?? 0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    _SectionTitle(title: 'Stil & beden'),
                    SizedBox(height: 1.2.h),

                    _GlassCard(
                      child: Column(
                        children: [
                          ObField(
                            emoji: '👕',
                            label: 'Beden',
                            helper: 'Önerilerde beden uyumu için.',
                            child: DropdownButtonFormField<String>(
                              value: size.isEmpty ? null : size,
                              items: const ['XS', 'S', 'M', 'L', 'XL', 'XXL']
                                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (v) => onSize(v ?? ''),
                              dropdownColor: Colors.amberAccent,
                              iconEnabledColor: Colors.white.withValues(alpha: 0.90),
                              style: const TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w700),
                              decoration: const InputDecoration(hintText: 'Seç'),
                            ),
                          ),
                          SizedBox(height: 1.6.h),
                          ObField(
                            emoji: '🎯',
                            label: 'Stil',
                            helper: 'Sana uygun tarzı seç.',
                            child: DropdownButtonFormField<String>(
                              value: style.isEmpty ? null : style,
                              items: const ['Street', 'Casual', 'Classic', 'Sport', 'Minimal']
                                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (v) => onStyle(v ?? ''),
                              dropdownColor:Colors.amberAccent,
                              iconEnabledColor: Colors.white.withValues(alpha: 0.90),
                              style: const TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w700),
                              decoration: const InputDecoration(hintText: 'Seç'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    _PreviewCard(name: name, size: size, style: style),

                    SizedBox(height: 1.4.h),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _isValid
                          ? const _HintPill(
                        key: ValueKey('ok'),
                        icon: Icons.check_circle_rounded,
                        text: 'Harika! Devam edebilirsin.',
                      )
                          : _HintPill(
                        key: const ValueKey('need'),
                        icon: Icons.info_rounded,
                        text:
                        'Boy: $_minHeight–$_maxHeight cm, Kilo: $_minWeight–$_maxWeight kg aralığında olmalı.',
                      ),
                    ),

                    SizedBox(height: 2.2.h),
                  ],
                ),
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back_rounded, size: 20),
                      label: const Text('Geri'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.35)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: FilledButton(
                      onPressed: _isValid ? onNext : null,
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      child: const Text('Devam'),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.2.h),
          ],
        ),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme() {
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.22)),
    );

    return InputDecorationTheme(
      filled: true,
      fillColor: Colors.black.withValues(alpha: 0.18),
      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.70)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: baseBorder,
      enabledBorder: baseBorder,
      focusedBorder: baseBorder.copyWith(
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.45)),
      ),
      errorBorder: baseBorder.copyWith(
        borderSide: BorderSide(color: Colors.red.withValues(alpha: 0.70)),
      ),
    );
  }
}

class _RangeInfoButton extends StatelessWidget {
  const _RangeInfoButton({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: title,
      icon: Icon(Icons.info_outline_rounded, color: Colors.white.withValues(alpha: 0.85)),
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ----- UI parçaları (seninki aynı mantık, dokunmadım) -----

class _IconPillButton extends StatelessWidget {
  const _IconPillButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  final int current;
  final int total;
  const _StepProgress({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final active = i < current;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: EdgeInsets.only(right: i == total - 1 ? 0 : 8),
            height: 6,
            decoration: BoxDecoration(
              color: active ? Colors.white : Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        );
      }),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(
          title,
          style: t.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Divider(
            color: Colors.white.withValues(alpha: 0.25),
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.name, required this.size, required this.style});

  final String name;
  final String size;
  final String style;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final safeName = name.trim().isEmpty ? '👋' : name.trim();
    final safeSize = size.isEmpty ? '—' : size;
    final safeStyle = style.isEmpty ? '—' : style;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.16),
            Colors.white.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          const Text('🧥', style: TextStyle(fontSize: 28)),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Merhaba, $safeName',
                  style: t.titleMedium?.copyWith(
                    color: Colors.amberAccent,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 0.6.h),
                Text(
                  'Beden: $safeSize  •  Stil: $safeStyle',
                  style: t.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.90),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HintPill extends StatelessWidget {
  const _HintPill({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.greenAccent.withValues(alpha: 0.92)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: t.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.92),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
