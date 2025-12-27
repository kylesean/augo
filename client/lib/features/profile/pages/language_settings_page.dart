// features/profile/pages/language_settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:augo/shared/providers/locale_provider.dart';
import 'package:augo/shared/services/toast_service.dart';
import 'package:augo/i18n/strings.g.dart';

class LanguageSettingsPage extends ConsumerWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colors = theme.colors;
    final currentLocale = ref.watch(localeProvider);
    final localeNotifier = ref.read(localeProvider.notifier);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(FIcons.chevronLeft, color: colors.foreground),
          onPressed: () => context.pop(),
        ),
        title: Text(
          t.settings.languageSettings,
          style: theme.typography.lg.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.foreground,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Instruction text
            Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
              child: Text(
                t.settings.selectLanguage,
                style: theme.typography.sm.copyWith(
                  color: colors.mutedForeground,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Language options in FTileGroup to match consistency
            FTileGroup(
              children: localeNotifier.supportedLocales.map((locale) {
                final isSelected = locale == currentLocale;
                final displayName = localeNotifier.getLocaleDisplayName(locale);

                return FTile(
                  title: Text(
                    displayName,
                    style: theme.typography.base.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected ? colors.primary : colors.foreground,
                    ),
                  ),
                  suffix: isSelected
                      ? Icon(FIcons.check, size: 20, color: colors.primary)
                      : null,
                  onPress: () => _changeLanguage(context, ref, locale),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _changeLanguage(
    BuildContext context,
    WidgetRef ref,
    AppLocale newLocale,
  ) async {
    final localeNotifier = ref.read(localeProvider.notifier);
    final currentLocale = ref.read(localeProvider);

    if (newLocale == currentLocale) {
      return; // Same language, no change needed
    }

    final success = await localeNotifier.changeLocale(newLocale);

    if (!context.mounted) return;

    if (success) {
      ToastService.success(description: Text(t.settings.languageChanged));
    } else {
      ToastService.showDestructive(description: Text(t.common.error));
    }
  }
}
