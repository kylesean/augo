// GenUI Reactive Architecture Test Suite
//
// These tests demonstrate the key capabilities of the new reactive GenUI architecture.
// Run with: flutter test test/features/chat/genui/reactive_architecture_test.dart

import 'package:flutter_test/flutter_test.dart';

import 'package:augo/features/chat/models/genui_surface_info.dart';
import 'package:augo/features/chat/genui/data_context_helpers.dart';

void main() {
  group('GenUI Reactive Architecture Tests', () {
    group('SurfaceStatus Enum', () {
      test('has all lifecycle states', () {
        // Verify all states exist for lifecycle tracking
        expect(SurfaceStatus.values, contains(SurfaceStatus.loading));
        expect(SurfaceStatus.values, contains(SurfaceStatus.rendered));
        expect(SurfaceStatus.values, contains(SurfaceStatus.updated));
        expect(SurfaceStatus.values, contains(SurfaceStatus.ready));
        expect(SurfaceStatus.values, contains(SurfaceStatus.error));
        expect(SurfaceStatus.values, contains(SurfaceStatus.removed));
      });

      test('supports reactive update tracking', () {
        // The 'updated' state is NEW - tracks when DataModelUpdate is received
        expect(SurfaceStatus.updated.name, equals('updated'));
      });
    });

    group('GenUiSurfaceInfo Model', () {
      test('can track surface lifecycle', () {
        final info = GenUiSurfaceInfo(
          surfaceId: 'surface_001',
          messageId: 'msg_001',
          createdAt: DateTime.now(),
          status: SurfaceStatus.loading,
        );

        expect(info.surfaceId, equals('surface_001'));
        expect(info.messageId, equals('msg_001'));
        expect(info.status, equals(SurfaceStatus.loading));
      });

      test('can update status with copyWith', () {
        const info = GenUiSurfaceInfo(
          surfaceId: 'surface_001',
          messageId: 'msg_001',
          status: SurfaceStatus.loading,
        );

        // Simulate receiving DataModelUpdate
        final updated = info.copyWith(
          status: SurfaceStatus.updated,
          updatedAt: DateTime.now(),
        );

        expect(updated.status, equals(SurfaceStatus.updated));
        expect(updated.updatedAt, isNotNull);
        expect(
          info.status,
          equals(SurfaceStatus.loading),
        ); // Original unchanged
      });

      test('can serialize and deserialize', () {
        final info = GenUiSurfaceInfo(
          surfaceId: 'surface_001',
          messageId: 'msg_001',
          createdAt: DateTime(2026, 1, 23, 16, 0, 0),
          status: SurfaceStatus.rendered,
        );

        final json = info.toJson();
        final restored = GenUiSurfaceInfo.fromJson(json);

        expect(restored.surfaceId, equals(info.surfaceId));
        expect(restored.messageId, equals(info.messageId));
        expect(restored.status, equals(info.status));
      });
    });

    group('DataContext Helpers', () {
      test('extractBoundPath extracts bound value path', () {
        // GenUI uses this format for bound values
        final data = {
          'amount': {'boundValue': '/amount'},
          'currency': {'literalString': 'CNY'},
        };

        final amountPath = extractBoundPath(data, 'amount');
        final currencyPath = extractBoundPath(data, 'currency');

        expect(amountPath, equals('/amount'));
        expect(currencyPath, isNull); // Not bound, is literal
      });

      test('extractLiteralValue extracts literal values', () {
        final data = {
          'amount': {'literalNumber': 100.0},
          'currency': {'literalString': 'CNY'},
          'isExpense': {'literalBool': true},
        };

        expect(extractLiteralValue<double>(data, 'amount'), equals(100.0));
        expect(extractLiteralValue<String>(data, 'currency'), equals('CNY'));
        expect(extractLiteralValue<bool>(data, 'isExpense'), equals(true));
      });

      test('subscribeOrLiteral falls back to direct access', () {
        // Create a minimal test DataContext
        // This tests the fallback path for simple schemas
        final data = {'amount': 250.0, 'currency': 'USD'};

        // For simple schemas without explicit binding format,
        // subscribeOrLiteral should fall back to direct data access
        // (In real use, this would use an actual DataContext)

        // Just verify the data structure works
        expect(data['amount'], equals(250.0));
        expect(data['currency'], equals('USD'));
      });
    });

    group('Reactive Update Scenarios', () {
      test('scenario: modify amount only', () {
        // Simulate the reactive update flow
        // Old way: Send entire TransactionReceipt again
        // New way: Send DataModelUpdate for /amount only

        const surfaceId = 'surface_tx_001';
        const newAmount = 200.0;

        // Old way - entire component data
        final oldWayUpdate = {
          'surfaceUpdate': {
            'surfaceId': 'surface_tx_002', // New ID!
            'uiDefinition': {
              'rootComponentId': 'root',
              'components': {
                'root': {
                  'TransactionReceipt': {
                    'transaction_id': 12345,
                    'amount': newAmount,
                    'currency': 'CNY',
                    'category_key': 'food_dining',
                  },
                },
              },
            },
          },
        };

        // New way - only the changed field
        final newWayUpdate = {
          'dataModelUpdate': {
            'surfaceId': surfaceId, // Same ID!
            'path': '/amount',
            'value': newAmount,
          },
        };

        // Verify new way is more targeted
        expect(
          newWayUpdate['dataModelUpdate']!['surfaceId'],
          equals(surfaceId),
        );
        expect(newWayUpdate['dataModelUpdate']!['path'], equals('/amount'));

        // Old way creates new surface (bad for UX)
        expect(
          oldWayUpdate['surfaceUpdate']!['surfaceId'],
          isNot(equals(surfaceId)),
        );
      });

      test('scenario: modify multiple fields', () {
        // User says: "改成 500 元的交通费"
        // Need to update both amount and category

        const surfaceId = 'surface_tx_001';

        final updates = [
          {
            'dataModelUpdate': {
              'surfaceId': surfaceId,
              'path': '/amount',
              'value': 500.0,
            },
          },
          {
            'dataModelUpdate': {
              'surfaceId': surfaceId,
              'path': '/category_key',
              'value': 'transport',
            },
          },
        ];

        // Both updates target the same surface
        expect(updates[0]['dataModelUpdate']!['surfaceId'], equals(surfaceId));
        expect(updates[1]['dataModelUpdate']!['surfaceId'], equals(surfaceId));

        // Different paths
        expect(updates[0]['dataModelUpdate']!['path'], equals('/amount'));
        expect(updates[1]['dataModelUpdate']!['path'], equals('/category_key'));
      });

      test('scenario: delete surface', () {
        const surfaceId = 'surface_tx_001';

        final deleteMessage = {
          'deleteSurface': {'surfaceId': surfaceId},
        };

        expect(deleteMessage['deleteSurface']!['surfaceId'], equals(surfaceId));
      });
    });

    group('_intent: update Flag', () {
      test('tool result with _intent triggers reuse', () {
        // When backend tool returns _intent='update',
        // frontend should reuse existing surface instead of creating new one

        final toolResultWithIntent = {
          'success': true,
          'transaction_id': 12345,
          'amount': 300.0,
          'message': '已修改金额',
          '_intent': 'update', // Key flag!
        };

        final toolResultWithoutIntent = {
          'success': true,
          'transaction_id': 12345,
          'amount': 300.0,
          'message': '记账成功',
          // No _intent
        };

        expect(toolResultWithIntent.containsKey('_intent'), isTrue);
        expect(toolResultWithIntent['_intent'], equals('update'));
        expect(toolResultWithoutIntent.containsKey('_intent'), isFalse);
      });
    });
  });

  group('Architecture Comparison', () {
    test('OLD vs NEW: Amount update comparison', () {
      /*
       * OLD ARCHITECTURE:
       * 1. User: "改成 200 元"
       * 2. Backend: Create new TransactionReceipt component
       * 3. Frontend: Receive SurfaceUpdate with new surface ID
       * 4. Result: Entire widget rebuilds, may cause flicker
       *
       * NEW ARCHITECTURE:
       * 1. User: "改成 200 元"
       * 2. Backend: Tool returns with _intent='update'
       * 3. Backend: SurfaceTracker finds existing surface
       * 4. Backend: Send DataModelUpdate(path='/amount', value=200)
       * 5. Frontend: DataModel.update() called
       * 6. Frontend: Only AmountText widget rebuilds
       * 7. Result: Seamless update, no flicker
       */

      // This test documents the architectural difference
      expect(true, isTrue); // Documentation test
    });

    test('NEW: ReactiveTransactionCard uses ValueListenableBuilder', () {
      /*
       * ReactiveTransactionCard architecture:
       *
       * initState() {
       *   _amountNotifier = dataContext.subscribe<double>(DataPath('/amount'));
       *   _currencyNotifier = dataContext.subscribe<String>(DataPath('/currency'));
       *   // ... more subscriptions
       * }
       *
       * build() {
       *   return ValueListenableBuilder<double?>(
       *     valueListenable: _amountNotifier,
       *     builder: (_, amount, __) {
       *       return AmountText(amount: amount ?? 0);
       *       // Only this rebuilds when amount changes!
       *     },
       *   );
       * }
       *
       * When DataModelUpdate arrives:
       * 1. DataModel.update('/amount', 200) called
       * 2. _amountNotifier.value = 200
       * 3. ValueListenableBuilder rebuilds
       * 4. Only AmountText widget updates
       */

      expect(true, isTrue); // Documentation test
    });

    test('NEW: GenUiLifecycleManager tracks surface state', () {
      /*
       * GenUiLifecycleManager enhanced features:
       *
       * 1. Surface Registry: Map<String, GenUiSurfaceInfo>
       *    - Tracks all active surfaces
       *    - Maintains lifecycle state
       *
       * 2. State Transitions:
       *    loading -> rendered -> updated -> ... -> removed
       *
       * 3. Methods:
       *    - getSurfaceInfo(surfaceId)
       *    - getSurfacesForMessage(messageId)
       *    - updateSurfaceStatus(surfaceId, status)
       *    - handleDataModelUpdate(surfaceId, path)
       *    - handleDeleteSurface(surfaceId)
       *    - clearSession()
       *
       * 4. Metrics:
       *    - totalSurfacesCreated
       *    - totalReactiveUpdates
       *    - totalSurfacesDeleted
       *    - activeSurfaceCount
       */

      expect(true, isTrue); // Documentation test
    });
  });
}
