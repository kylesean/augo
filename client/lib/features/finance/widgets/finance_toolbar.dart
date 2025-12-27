import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:animate_do/animate_do.dart';
import '../../../i18n/strings.g.dart';

class ForecastToolbar extends ConsumerWidget {
  const ForecastToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colorScheme = theme.colors;

    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.forecast.title,
              style: theme.typography.xl2.copyWith(
                color: colorScheme.foreground,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              t.forecast.subtitle,
              style: theme.typography.base.copyWith(
                color: colorScheme.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
