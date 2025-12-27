import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import '../../../app/theme/app_theme_palette.dart';
import '../../../app/theme/theme_palette_provider.dart';
import '../../../app/theme/theme_provider.dart';
import '../../../app/theme/theme_notifier.dart';
import 'package:augo/i18n/strings.g.dart';
import 'package:augo/shared/services/toast_service.dart';
import '../widgets/theme_preview.dart';

class AppearanceSettingsPage extends ConsumerWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colors = theme.colors;
    final currentThemeMode = ref.watch(themeProvider);
    final selectedPalette = ref.watch(themePaletteProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(FIcons.chevronLeft, color: colors.foreground),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          t.appearance.title,
          style: theme.typography.xl.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.foreground,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.appearance.themeMode,
              style: theme.typography.base.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ThemePreview(
                  isDark: false,
                  isSelected: currentThemeMode == ThemeMode.light,
                  title: t.appearance.light,
                  onTap: () {
                    ref
                        .read(themeProvider.notifier)
                        .setTheme(AppThemeMode.light);
                    ToastService.success(
                      description: Text(t.settings.appearanceUpdated),
                    );
                  },
                ),
                const SizedBox(width: 8),
                ThemePreview(
                  isDark: true,
                  isSelected: currentThemeMode == ThemeMode.dark,
                  title: t.appearance.dark,
                  onTap: () {
                    ref
                        .read(themeProvider.notifier)
                        .setTheme(AppThemeMode.dark);
                    ToastService.success(
                      description: Text(t.settings.appearanceUpdated),
                    );
                  },
                ),
                const SizedBox(width: 8),
                ThemePreview(
                  isDark:
                      MediaQuery.of(context).platformBrightness ==
                      Brightness.dark,
                  isSelected: currentThemeMode == ThemeMode.system,
                  title: t.appearance.system,
                  onTap: () {
                    ref
                        .read(themeProvider.notifier)
                        .setTheme(AppThemeMode.system);
                    ToastService.success(
                      description: Text(t.settings.appearanceUpdated),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              t.appearance.colorScheme,
              style: theme.typography.base.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.foreground,
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
                        onTap: () {
                          ref
                              .read(themePaletteProvider.notifier)
                              .setPalette(palette);
                          ToastService.success(
                            description: Text(t.settings.appearanceUpdated),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
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
