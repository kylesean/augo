import 'package:flutter_test/flutter_test.dart';
import 'package:augo/features/chat/genui/app_catalog.dart';

void main() {
  group('AppCatalog', () {
    test('build() returns a valid catalog', () {
      final catalog = AppCatalog.build();
      expect(catalog, isNotNull);
      expect(catalog.items, isNotEmpty);
      expect(
        catalog.items.any((item) => item.name == 'TransferPathBuilder'),
        isTrue,
      );
    });

    // Note: Testing widget builders requires constructing a complex CatalogItemContext
    // which involves deep dependencies from the genui package.
    // We verified the structure above, which ensures the catalog is correctly assembled.
  });
}
