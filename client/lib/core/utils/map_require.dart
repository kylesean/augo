import 'package:augo/core/network/exceptions/app_exception.dart';

extension RequireField on Map<String, dynamic>? {
  T require<T>(String key) {
    final map = this;
    if (map == null || !map.containsKey(key)) {
      throw BusinessException("Required field missing: $key");
    }
    final value = map[key];
    if (value is! T) {
      throw BusinessException(
        "Field '$key' type error: expected $T, actual ${value.runtimeType}",
      );
    }
    return value;
  }
}
