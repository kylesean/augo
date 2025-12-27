import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:genui/genui.dart';
import 'package:augo/features/chat/genui/templates/transfer_path_builder.dart';

void main() {
  group('TransferPathBuilder', () {
    const Map<String, dynamic> testData = {
      'amount': 100.0,
      'currency': 'CNY',
      'source_accounts': [
        {
          'id': 'src1',
          'name': 'Source Account',
          'type': 'BANK',
          'balance': 500.0,
        },
      ],
      'target_accounts': [
        {
          'id': 'tgt1',
          'name': 'Target Account',
          'type': 'ALIPAY',
          'balance': 0.0,
        },
      ],
      '_surfaceId': 'test_surface',
    };

    Widget createWidgetUnderTests(
      Map<String, dynamic> data,
      void Function(UiEvent) dispatchEvent,
    ) {
      return MaterialApp(
        builder: (context, child) =>
            FTheme(data: FThemes.zinc.light, child: child!),
        home: Scaffold(
          body: TransferPathBuilder(data: data, dispatchEvent: dispatchEvent),
        ),
      );
    }

    testWidgets('renders correctly with initial data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTests(testData, (_) {}));

      expect(find.text('构建交易链路'), findsOneWidget);
      expect(find.text('选择付款方式'), findsOneWidget);
      expect(find.text('Source Account'), findsWidgets); // Likely in list
      expect(
        find.text('CNY100.00'),
        findsOneWidget,
      ); // Amount in header (formatted)
    });

    testWidgets('selects source and auto-advances to target', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTests(testData, (_) {}));

      // Tap the source account in the list
      await tester.tap(find.text('Source Account').last);
      await tester.pumpAndSettle();

      // Check if title changed to Select Target
      expect(find.text('选择收款账户'), findsOneWidget);
      expect(find.text('Target Account'), findsOneWidget);
    });

    testWidgets('dispatches event on confirmation', (
      WidgetTester tester,
    ) async {
      List<UiEvent> dispatchedEvents = [];

      await tester.pumpWidget(
        createWidgetUnderTests(
          testData,
          (event) => dispatchedEvents.add(event),
        ),
      );

      // Select Source
      await tester.tap(find.text('Source Account').last);
      await tester.pumpAndSettle();

      // Select Target
      await tester.tap(find.text('Target Account').last);
      await tester.pumpAndSettle();

      // Finds '确认转账链路' button (first confirm)
      expect(find.text('确认转账链路'), findsOneWidget);
      await tester.tap(find.text('确认转账链路'));
      await tester.pumpAndSettle();

      // Check if we reached confirmation stage
      expect(find.text('链路已锁定'), findsOneWidget);

      // Finds '确认：Source Account → Target Account' (final confirm)
      // We use a finder that looks for the button text
      final confirmButtonFinder = find.textContaining('确认：');
      expect(confirmButtonFinder, findsOneWidget);

      await tester.tap(confirmButtonFinder);
      await tester.pumpAndSettle();

      expect(dispatchedEvents.length, 1);
      final event = dispatchedEvents.first as UserActionEvent;
      expect(event.name, 'transfer_path_confirmed');
      expect(event.context['source_account_id'], 'src1');
      expect(event.context['target_account_id'], 'tgt1');

      // Ensure all animations are settled
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
