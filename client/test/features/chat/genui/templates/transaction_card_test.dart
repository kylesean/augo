import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:augo/features/chat/genui/templates/transaction_card.dart';
import 'package:augo/i18n/strings.g.dart';
import 'package:augo/core/services/server_config_service.dart';
import 'package:augo/features/profile/providers/financial_settings_provider.dart';
import 'package:augo/features/profile/models/financial_settings.dart';
import 'package:augo/app/theme/app_semantic_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('TransactionCard', () {
    Widget createWidgetUnderTests(
      Map<String, dynamic> data, {
      required SharedPreferences prefs,
    }) {
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          financialSettingsProvider.overrideWithValue(
            const FinancialSettingsState(primaryCurrency: 'CNY'),
          ),
        ],
        child: MaterialApp(
          builder: (context, child) {
            final theme = FThemes.zinc.light;
            final extendedTheme = FThemeData(
              colors: theme.colors,
              typography: theme.typography,
              style: theme.style,
              extensions: [AppSemanticColors.light],
            );
            return FTheme(data: extendedTheme, child: child!);
          },
          home: Scaffold(body: TransactionCard(data: data)),
        ),
      );
    }

    testWidgets('renders correctly with full data', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final data = {
        'amount': 258.00,
        'currency': 'CNY',
        'category_key': 'SHOPPING_RETAIL',
        'time': '2023-10-27T19:00:00Z',
        'tags': ['life', 'shopping'],
        'status': 'COMPLETED',
      };

      await tester.pumpWidget(createWidgetUnderTests(data, prefs: prefs));
      await tester.pumpAndSettle();

      expect(find.text(t.chat.genui.transactionCard.title), findsOneWidget);
      expect(find.textContaining('258.00'), findsOneWidget);
      expect(find.text(t.category.shoppingRetail), findsOneWidget);
      expect(find.text('life'), findsOneWidget);
      expect(find.text('shopping'), findsOneWidget);
    });

    testWidgets('handles missing or null data gracefully', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      // Test with minimal/missing data that previously caused crashes
      final data = {
        'amount': null, // Should default to 0.0
        'time': null, // Should default to empty string
        // Other fields missing
      };

      await tester.pumpWidget(createWidgetUnderTests(data, prefs: prefs));
      await tester.pumpAndSettle();

      // Should render without error
      expect(find.text(t.chat.genui.transactionCard.title), findsOneWidget);
      expect(find.byType(TransactionCard), findsOneWidget);

      // Check defaults
      expect(find.textContaining('0.00'), findsOneWidget); // Default amount
      expect(find.text(t.category.others), findsOneWidget); // Default category
      // Time should be empty/hidden
    });
  });
}
