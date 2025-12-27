import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:augo/features/profile/providers/financial_settings_provider.dart';
import '../atoms/atoms.dart';

class StatCard extends ConsumerWidget {
  /// Card title
  final String title;

  /// Numeric value to display
  final num value;

  /// Optional subtitle (e.g., trend description)
  final String? subtitle;

  /// Leading icon
  final IconData? icon;

  /// Accent color for icon and indicators
  final Color? color;

  /// Currency code for formatting
  final String? currency;

  /// Whether to format value as currency
  final bool isCurrency;

  /// Optional progress value (0.0 to 1.0)
  final double? progress;

  /// Trend direction: positive, negative, or null
  final bool? trendUp;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.color,
    this.currency,
    this.isCurrency = true,
    this.progress,
    this.trendUp,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colors = theme.colors;
    final accentColor = color ?? colors.primary;

    final financialSettings = ref.watch(financialSettingsProvider);
    final displayCurrency = currency ?? financialSettings.primaryCurrency;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with icon and title
          Row(
            children: [
              if (icon != null) IconBadge(icon: icon!, size: 36),
              if (icon != null) const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.typography.sm.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
              ),
              if (trendUp != null)
                Icon(
                  trendUp! ? FIcons.trendingUp : FIcons.trendingDown,
                  color: trendUp! ? colors.primary : colors.destructive,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Value display
          if (isCurrency)
            AmountDisplay(
              amount: value,
              currency: displayCurrency,
              style: theme.typography.xl2.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.foreground,
              ),
            )
          else
            Text(
              value.toString(),
              style: theme.typography.xl2.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.foreground,
              ),
            ),

          // Subtitle
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: theme.typography.xs.copyWith(
                color: trendUp != null
                    ? (trendUp! ? colors.primary : colors.destructive)
                    : colors.mutedForeground,
              ),
            ),
          ],

          // Progress bar
          if (progress != null) ...[
            const SizedBox(height: 12),
            ProgressIndicatorBar(
              value: progress!,
              color: accentColor,
              height: 6,
            ),
          ],
        ],
      ),
    );
  }
}
