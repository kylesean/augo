import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:augo/features/chat/genui/templates/transaction_card.dart';

void main() {
  group('TransactionCard', () {
    Widget createWidgetUnderTests(Map<String, dynamic> data) {
      return MaterialApp(
        builder: (context, child) =>
            FTheme(data: FThemes.zinc.light, child: child!),
        home: Scaffold(body: TransactionCard(data: data)),
      );
    }

    testWidgets('renders correctly with full data', (
      WidgetTester tester,
    ) async {
      final data = {
        'amount': 258.00,
        'currency': 'CNY',
        'merchant': 'Walmart',
        'category': 'Shopping',
        'category_key': 'SHOPPING_RETAIL',
        'time': '2023-10-27T19:00:00Z',
        'payment_method': 'Credit Card',
        'location': 'Beijing',
        'tags': ['life', 'shopping'],
        'status': 'COMPLETED',
      };

      await tester.pumpWidget(createWidgetUnderTests(data));

      expect(find.text('Walmart'), findsOneWidget);
      expect(find.text('258.00'), findsOneWidget);
      expect(find.text('Shopping'), findsOneWidget);
      expect(find.text('Credit Card'), findsOneWidget);
      expect(find.text('Beijing'), findsOneWidget);
      expect(find.text('#life'), findsOneWidget);
    });

    testWidgets('handles missing or null data gracefully', (
      WidgetTester tester,
    ) async {
      // Test with minimal/missing data that previously caused crashes
      final data = {
        'amount': null, // Should default to 0.0
        'time': null, // Should default to empty string
        // Other fields missing
      };

      await tester.pumpWidget(createWidgetUnderTests(data));

      // Should render without error
      expect(find.byType(TransactionCard), findsOneWidget);

      // Check defaults
      expect(find.text('0.00'), findsOneWidget); // Default amount
      expect(find.text('未知商户'), findsOneWidget); // Default merchant
      // Time should be empty/hidden
    });
  });
}
