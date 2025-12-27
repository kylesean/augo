import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class ThemePreview extends StatelessWidget {
  final bool isDark;
  final bool isSelected;
  final VoidCallback onTap;
  final String title;

  const ThemePreview({
    super.key,
    required this.isDark,
    required this.isSelected,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colors;

    // Mock theme colors
    final _ThemeColors previewColors = isDark
        ? _DarkThemeColors()
        : _LightThemeColors();

    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? colorScheme.primary : colorScheme.border,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Theme preview area
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: previewColors.background,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mock title bar
                        Container(
                          height: 10,
                          width: 50,
                          decoration: BoxDecoration(
                            color: previewColors.foreground,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Mock content area
                        Container(
                          height: 6,
                          width: 30,
                          decoration: BoxDecoration(
                            color: previewColors.muted,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 2),

                        Container(
                          height: 6,
                          width: 60,
                          decoration: BoxDecoration(
                            color: previewColors.muted,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const Spacer(),

                        // Mock button
                        Container(
                          height: 12,
                          width: 40,
                          decoration: BoxDecoration(
                            color: previewColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Title
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(7),
                    bottomRight: Radius.circular(7),
                  ),
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.typography.sm.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.foreground,
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

abstract class _ThemeColors {
  Color get background;
  Color get foreground;
  Color get muted;
  Color get accent;
}

class _LightThemeColors extends _ThemeColors {
  @override
  Color get background => const Color(0xFFFFFFFF);
  @override
  Color get foreground => const Color(0xFF0F172A);
  @override
  Color get muted => const Color(0xFFF1F5F9);
  @override
  Color get accent => const Color(0xFF0F172A);
}

class _DarkThemeColors extends _ThemeColors {
  @override
  Color get background => const Color(0xFF0F172A);
  @override
  Color get foreground => const Color(0xFFF8FAFC);
  @override
  Color get muted => const Color(0xFF1E293B);
  @override
  Color get accent => const Color(0xFFF8FAFC);
}
