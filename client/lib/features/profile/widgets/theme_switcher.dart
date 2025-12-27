import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import '../../../app/theme/theme_notifier.dart';
import '../../../app/theme/app_theme_palette.dart';
import '../../../app/theme/theme_palette_provider.dart';
import '../../../app/theme/theme_provider.dart';
import 'package:augo/i18n/strings.g.dart';
import 'theme_preview.dart';

class ThemeSwitcher extends ConsumerWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final selectedPalette = ref.watch(themePaletteProvider);
    final theme = context.theme;
    final colorScheme = theme.colors;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette_outlined,
                  size: 20,
                  color: colorScheme.foreground,
                ),
                const SizedBox(width: 8),
                Text(t.appearance.title, style: theme.typography.lg),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ThemePreview(
                  isDark: false,
                  isSelected: currentTheme == ThemeMode.light,
                  title: t.appearance.light,
                  onTap: () {
                    ref
                        .read(themeProvider.notifier)
                        .setTheme(AppThemeMode.light);
                  },
                ),
                const SizedBox(width: 8),
                ThemePreview(
                  isDark: true,
                  isSelected: currentTheme == ThemeMode.dark,
                  title: t.appearance.dark,
                  onTap: () {
                    ref
                        .read(themeProvider.notifier)
                        .setTheme(AppThemeMode.dark);
                  },
                ),
                const SizedBox(width: 8),
                ThemePreview(
                  isDark:
                      MediaQuery.of(context).platformBrightness ==
                      Brightness.dark,
                  isSelected: currentTheme == ThemeMode.system,
                  title: t.appearance.system,
                  onTap: () {
                    ref
                        .read(themeProvider.notifier)
                        .setTheme(AppThemeMode.system);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.muted.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _getCurrentThemeIcon(currentTheme),
                    size: 16,
                    color: colorScheme.mutedForeground,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Current Theme: ${_getCurrentThemeName(currentTheme)}',
                    style: theme.typography.sm.copyWith(
                      color: colorScheme.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              t.appearance.colorScheme,
              style: theme.typography.base.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.foreground,
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                // Three per row, 8px spacing
                const spacing = 8.0;
                final itemWidth = (constraints.maxWidth - spacing * 2) / 3;
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (final palette in AppThemePalette.values)
                      _PaletteOption(
                        palette: palette,
                        isSelected: palette == selectedPalette,
                        width: itemWidth,
                        onTap: () => ref
                            .read(themePaletteProvider.notifier)
                            .setPalette(palette),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCurrentThemeIcon(ThemeMode currentTheme) {
    switch (currentTheme) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  String _getCurrentThemeName(ThemeMode currentTheme) {
    switch (currentTheme) {
      case ThemeMode.light:
        return t.appearance.light;
      case ThemeMode.dark:
        return t.appearance.dark;
      case ThemeMode.system:
        return t.appearance.system;
    }
  }
}

class _PaletteOption extends StatelessWidget {
  const _PaletteOption({
    required this.palette,
    required this.isSelected,
    required this.onTap,
    this.width,
  });

  final AppThemePalette palette;
  final bool isSelected;
  final VoidCallback onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final lightTheme = palette.resolveBaseTheme(Brightness.light);
    final darkTheme = palette.resolveBaseTheme(Brightness.dark);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width ?? 100,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colors.secondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: isSelected ? 1.6 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : const [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: palette.swatchColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    palette.label,
                    style: theme.typography.sm.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.foreground,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, size: 16, color: colors.primary),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 28,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      lightTheme.colors.primary,
                      darkTheme.colors.primary,
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Light / Dark',
              style: theme.typography.xs.copyWith(
                color: colors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
