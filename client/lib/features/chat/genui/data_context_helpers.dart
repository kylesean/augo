// GenUI DataContext Helpers
//
// Provides utility functions and patterns for using GenUI's reactive
// DataContext binding in widget builders.
//
// Usage:
// In your CatalogItem.widgetBuilder:
//   final amountNotifier = subscribeToField<double>(
//     context.dataContext,
//     context.data,
//     'amount',
//   );
//   return ValueListenableBuilder<double?>(
//     valueListenable: amountNotifier,
//     builder: (_, amount, __) => AmountDisplay(amount: amount ?? 0),
//   );

import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';

/// Extension on DataContext for easier field subscriptions
extension DataContextExtensions on DataContext {
  /// Subscribe to a string field with path resolution
  ValueNotifier<String?> subscribeString(String fieldPath) {
    return subscribe<String>(DataPath(fieldPath));
  }

  /// Subscribe to a double/number field with path resolution
  ValueNotifier<double?> subscribeDouble(String fieldPath) {
    return subscribe<double>(DataPath(fieldPath));
  }

  /// Subscribe to an int field with path resolution
  ValueNotifier<int?> subscribeInt(String fieldPath) {
    return subscribe<int>(DataPath(fieldPath));
  }

  /// Subscribe to a bool field with path resolution
  ValueNotifier<bool?> subscribeBool(String fieldPath) {
    return subscribe<bool>(DataPath(fieldPath));
  }

  /// Subscribe to a list field with path resolution
  ValueNotifier<List<Object?>?> subscribeList(String fieldPath) {
    return subscribe<List<Object?>>(DataPath(fieldPath));
  }

  /// Subscribe to a map field with path resolution
  ValueNotifier<Map<String, Object?>?> subscribeMap(String fieldPath) {
    return subscribe<Map<String, Object?>>(DataPath(fieldPath));
  }

  /// Get a static value without subscription (for initial/fallback values)
  T? getField<T>(String fieldPath) {
    return getValue<T>(DataPath(fieldPath));
  }
}

/// Helper to create a bound value path from component data
///
/// GenUI uses a specific format for bound values:
/// {
///   "amount": {"boundValue": "/amount"}  // bound to DataModel
///   "currency": {"literalString": "CNY"} // literal value
/// }
///
/// This helper extracts the path from the bound value format.
String? extractBoundPath(Object? data, String fieldName) {
  if (data is! Map<String, dynamic>) return null;

  final fieldData = data[fieldName];
  if (fieldData is! Map<String, dynamic>) return null;

  // Check for boundValue format
  if (fieldData.containsKey('boundValue')) {
    return fieldData['boundValue'] as String?;
  }

  return null;
}

/// Helper to extract literal value from component data
T? extractLiteralValue<T>(Object? data, String fieldName) {
  if (data is! Map<String, dynamic>) return null;

  final fieldData = data[fieldName];
  if (fieldData is! Map<String, dynamic>) return null;

  // Check literal value formats
  if (fieldData.containsKey('literalString')) {
    return fieldData['literalString'] as T?;
  }
  if (fieldData.containsKey('literalNumber')) {
    return fieldData['literalNumber'] as T?;
  }
  if (fieldData.containsKey('literalBool')) {
    return fieldData['literalBool'] as T?;
  }

  return null;
}

/// Smart subscription helper that handles both bound and literal values
///
/// If the field is bound (has boundValue), subscribes to DataModel.
/// If the field is literal, returns a constant ValueNotifier.
/// Falls back to direct data access for simple schemas.
ValueNotifier<T?> subscribeOrLiteral<T>({
  required DataContext dataContext,
  required Object? data,
  required String fieldName,
  T? defaultValue,
}) {
  // Try bound value first
  final boundPath = extractBoundPath(data, fieldName);
  if (boundPath != null) {
    return dataContext.subscribe<T>(DataPath(boundPath));
  }

  // Try literal value
  final literalValue = extractLiteralValue<T>(data, fieldName);
  if (literalValue != null) {
    return ValueNotifier<T?>(literalValue);
  }

  // Fall back to direct data access (for simple schemas without explicit binding)
  if (data is Map<String, dynamic> && data.containsKey(fieldName)) {
    final directValue = data[fieldName];
    if (directValue is T) {
      return ValueNotifier<T?>(directValue);
    }
  }

  // Return default
  return ValueNotifier<T?>(defaultValue);
}
