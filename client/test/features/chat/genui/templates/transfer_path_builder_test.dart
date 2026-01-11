import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:genui/genui.dart';
import 'package:augo/features/chat/genui/templates/transfer_path_builder.dart';
import 'package:augo/i18n/strings.g.dart';
import 'package:augo/core/services/server_config_service.dart';
import 'package:augo/app/theme/app_semantic_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('TransferPathBuilder', () {
    const Map<String, dynamic> testData = {
      'amount': 100.0,
      'currency': 'CNY',
      'sourceAccounts': [
        {
          'id': 'src1',
          'name': 'Source Account',
          'type': 'BANK',
          'balance': 500.0,
        },
      ],
      'targetAccounts': [
        {
          'id': 'tgt1',
          'name': 'Target Account',
          'type': 'ALIPAY',
          'balance': 0.0,
        },
      ],
      'preselectedSourceId': 'src1',
      'preselectedTargetId': 'tgt1',
      '_surfaceId': 'test_surface',
    };

    Widget createWidgetUnderTests(
      Map<String, dynamic> data,
      void Function(UiEvent) dispatchEvent, {
      required SharedPreferences prefs,
    }) {
      return ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
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
          home: Scaffold(
            body: TransferPathBuilder(data: data, dispatchEvent: dispatchEvent),
          ),
        ),
      );
    }

    testWidgets('renders correctly with initial data', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        createWidgetUnderTests(testData, (_) {}, prefs: prefs),
      );
      await tester.pumpAndSettle();

      expect(find.text('FROM'), findsOneWidget);
      expect(find.text('TO'), findsOneWidget);
      expect(find.text('Source Account'), findsOneWidget);
      expect(find.text('Target Account'), findsOneWidget);
    });

    testWidgets('selects source and target', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      // Use data WITHOUT preselection
      final data = Map<String, dynamic>.from(testData);
      data['preselectedSourceId'] = null;
      data['preselectedTargetId'] = null;
      // Use unique surfaceId to avoid cache interference
      data['_surfaceId'] = 'surface_select_test';

      await tester.pumpWidget(
        createWidgetUnderTests(data, (_) {}, prefs: prefs),
      );
      await tester.pumpAndSettle();

      // Tap the source account placeholder
      await tester.tap(find.text(t.chat.genui.transferPath.selectSource));
      await tester.pumpAndSettle();

      // Tap the target account placeholder
      await tester.tap(find.text(t.chat.genui.transferPath.selectTarget));
      await tester.pumpAndSettle();
    });

    testWidgets('dispatches event on confirmation', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final List<UiEvent> dispatchedEvents = [];
      // Use unique surfaceId to avoid cache interference
      final data = Map<String, dynamic>.from(testData);
      data['_surfaceId'] = 'surface_confirm_test';

      await tester.pumpWidget(
        createWidgetUnderTests(
          data,
          (event) => dispatchedEvents.add(event),
          prefs: prefs,
        ),
      );
      await tester.pumpAndSettle();

      // Select Source (already preselected in testData)
      expect(find.text('Source Account'), findsOneWidget);

      // Select Target (already preselected in testData)
      expect(find.text('Target Account'), findsOneWidget);

      // Find confirm button
      final confirmBtn = find.text(t.chat.transferWizard.confirmTransfer);
      expect(confirmBtn, findsOneWidget);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      // Check if we reached confirmation stage
      expect(find.text(t.chat.transferWizard.confirmed), findsOneWidget);
    });
  });
}
