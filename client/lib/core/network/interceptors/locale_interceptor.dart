import 'package:logging/logging.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:augo/shared/providers/locale_provider.dart';
import 'package:augo/core/constants/api_constants.dart';
import 'package:augo/i18n/strings.g.dart';

/// Language interceptor
/// Automatically adds Accept-Language header to all requests, passing user's current language setting
class LocaleInterceptor extends Interceptor {
  final _logger = Logger('LocaleInterceptor');
  final Ref ref;

  LocaleInterceptor(this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Get current user language setting
    final currentLocale = ref.read(localeProvider);

    // Convert language code to standard Accept-Language format
    final acceptLanguage = _convertToAcceptLanguage(currentLocale);

    // Add Accept-Language header
    options.headers[ApiConstants.acceptLanguageHeader] = acceptLanguage;

    _logger.info(
      'LocaleInterceptor: Added Accept-Language header: $acceptLanguage for path: ${options.path}',
    );

    // Continue request processing
    handler.next(options);
  }

  /// Convert AppLocale to standard Accept-Language format
  ///
  /// Accept-Language standard format:
  /// - 'zh-CN,zh;q=0.9,en;q=0.8' -> Chinese priority, English as fallback
  /// - 'en-US,en;q=0.9,zh;q=0.8' -> English priority, Chinese as fallback
  String _convertToAcceptLanguage(AppLocale locale) {
    switch (locale) {
      case AppLocale.zh:
        // Chinese priority, English as fallback
        return 'zh-CN,zh;q=0.9,en;q=0.8';
      case AppLocale.en:
        // English priority, Chinese as fallback
        return 'en-US,en;q=0.9,zh;q=0.8';
      case AppLocale.ja:
        return 'ja-JP,ja;q=0.9,en;q=0.8';
      case AppLocale.ko:
        return 'ko-KR,ko;q=0.9,en;q=0.8';
      case AppLocale.zhHant:
        return 'zh-TW,zh;q=0.9,en;q=0.8';
    }
  }
}
