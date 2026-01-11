// features/profile/pages/amount_settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:augo/shared/providers/amount_theme_provider.dart';
import 'package:augo/shared/services/toast_service.dart';
import 'package:augo/shared/theme/amount_theme.dart';
import 'package:augo/i18n/strings.g.dart';
import 'dart:async';

class AmountSettingsPage extends ConsumerWidget {
  const AmountSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colors = theme.colors;
    final currentThemeId = ref.watch(amountThemeProvider).themeId;

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
          t.settings.amountDisplayStyle,
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
                t.settings.selectAmountStyle,
                style: theme.typography.sm.copyWith(
                  color: colors.mutedForeground,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Amount theme options in FTileGroup
            FTileGroup(
              children: AmountTheme.availableThemes.map((option) {
                final isSelected = currentThemeId == option.id;

                // Get localized title and subtitle
                String title = option.name;
                String subtitle = option.description;

                if (option.id == 'chinaMarket') {
                  title = t.amountTheme.chinaMarket;
                  subtitle = t.amountTheme.chinaMarketDesc;
                } else if (option.id == 'international') {
                  title = t.amountTheme.international;
                  subtitle = t.amountTheme.internationalDesc;
                } else if (option.id == 'minimalist') {
                  title = t.amountTheme.minimalist;
                  subtitle = t.amountTheme.minimalistDesc;
                } else if (option.id == 'colorBlindFriendly') {
                  title = t.amountTheme.colorBlind;
                  subtitle = t.amountTheme.colorBlindDesc;
                }

                return FTile(
                  title: Text(
                    title,
                    style: theme.typography.base.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected ? colors.primary : colors.foreground,
                    ),
                  ),
                  subtitle: Text(
                    subtitle,
                    style: theme.typography.sm.copyWith(
                      color: colors.mutedForeground,
                    ),
                  ),
                  suffix: isSelected
                      ? Icon(FIcons.check, size: 20, color: colors.primary)
                      : null,
                  onPress: () {
                    unawaited(
                      ref
                          .read(amountThemeProvider.notifier)
                          .setTheme(option.id),
                    );
                    ToastService.success(
                      description: Text(t.settings.appearanceUpdated),
                    );
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),
            // Notice text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.muted.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(FIcons.info, size: 16, color: colors.mutedForeground),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t.settings.amountStyleNotice,
                      style: theme.typography.xs.copyWith(
                        color: colors.mutedForeground,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
