import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:dio/dio.dart';

/// Custom SSE client supporting POST requests and intelligent reconnection
///
/// Features:
/// - Supports POST requests with JSON body
/// - Intelligent reconnection mechanism (exponential backoff)
/// - Properly preserves request body for reconnection
/// - Configurable maximum retry attempts
class SseClient {
  final _logger = Logger('SseClient');
  final String url;
  final Map<String, String> headers;
  final Map<String, dynamic>? body;
  final int maxRetries;
  final Duration initialRetryDelay;
  final Dio? _dioOverride;

  Dio? _dio;
  CancelToken? _cancelToken;
  StreamSubscription? _responseSubscription;
  Timer? _retryTimer;
  int _retryCount = 0;
  bool _isClosed = false;
  bool _isConnecting = false;

  final _eventController = StreamController<SseEvent>.broadcast();

  /// SSE event stream
  Stream<SseEvent> get stream => _eventController.stream;

  SseClient({
    required this.url,
    required this.headers,
    this.body,
    this.maxRetries = 3,
    this.initialRetryDelay = const Duration(seconds: 1),
    Dio? dio,
  }) : _dioOverride = dio;

  /// Start connection
  Future<void> connect() async {
    if (_isClosed) return;
    if (_isConnecting) return;

    _isConnecting = true;
    _dio = _dioOverride ?? Dio();
    _cancelToken = CancelToken();

    try {
      _logger.info('SseClient: Connecting to $url');

      final response = await _dio!.post<ResponseBody>(
        url,
        data: body,
        options: Options(
          headers: headers,
          responseType: ResponseType.stream,
          validateStatus: (status) => true,
        ),
        cancelToken: _cancelToken,
      );

      if (_isClosed) {
        return;
      }

      if (response.statusCode != 200) {
        _logger.info('SseClient: HTTP error ${response.statusCode}');
        _handleError('HTTP ${response.statusCode}');
        return;
      }

      // Connection successful, reset retry count
      _retryCount = 0;
      _isConnecting = false;

      _logger.info('SseClient: Connected successfully');

      // Process SSE stream
      _responseSubscription = response.data!.stream
          .cast<List<int>>()
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
            _handleLine,
            onError: (error) {
              if (error is DioException && CancelToken.isCancel(error)) {
                _logger.info('SseClient: Connection cancelled');
                return;
              }
              _logger.info('SseClient: Stream error: $error');
              _handleError(error.toString());
            },
            onDone: () {
              _logger.info('SseClient: Stream done');
              if (!_isClosed) {
                // Stream ended normally, no need to reconnect
                _eventController.add(SseEvent(type: 'done', data: null));
              }
            },
            cancelOnError: false,
          );
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
        _logger.info('SseClient: Connection cancelled during connect');
        return;
      }
      _logger.info('SseClient: Connection error: $e');
      _handleError(e.toString());
    }
  }

  String _currentEventType = '';
  final _dataBuffer = StringBuffer();

  void _handleLine(String line) {
    if (_isClosed) return;

    // SSE format parsing
    if (line.isEmpty) {
      // Empty line indicates event end
      if (_dataBuffer.isNotEmpty) {
        final data = _dataBuffer.toString().trim();
        _eventController.add(
          SseEvent(
            type: _currentEventType.isEmpty ? 'message' : _currentEventType,
            data: data,
          ),
        );
        _dataBuffer.clear();
        _currentEventType = '';
      }
      return;
    }

    if (line.startsWith('event:')) {
      _currentEventType = line.substring(6).trim();
    } else if (line.startsWith('data:')) {
      final data = line.substring(5).trim();
      if (_dataBuffer.isNotEmpty) {
        _dataBuffer.write('\n');
      }
      _dataBuffer.write(data);
    } else if (line.startsWith(':')) {
      // Comment line, ignore
    } else if (line.startsWith('id:')) {
      // Event ID, can be used for reconnection (not implemented)
    } else if (line.startsWith('retry:')) {
      // Reconnection delay (not implemented)
    }
  }

  void _handleError(String error) {
    _isConnecting = false;

    if (_isClosed) return;

    // Check if should retry
    if (_retryCount < maxRetries) {
      _retryCount++;
      final delay = _calculateRetryDelay();
      _logger.info(
        'SseClient: Retry $_retryCount/$maxRetries in ${delay.inSeconds}s',
      );

      _retryTimer = Timer(delay, () {
        if (!_isClosed) {
          _cleanup();
          connect();
        }
      });
    } else {
      _logger.info('SseClient: Max retries reached, giving up');
      _eventController.addError(
        'Connection failed, max retries reached: $error',
      );
      close();
    }
  }

  Duration _calculateRetryDelay() {
    // Exponential backoff: 1s, 2s, 4s...
    return initialRetryDelay * (1 << (_retryCount - 1));
  }

  void _cleanup() {
    _responseSubscription?.cancel();
    _responseSubscription = null;
    _cancelToken?.cancel('reconnect');
    _cancelToken = null;
  }

  /// Close connection
  void close() {
    if (_isClosed) return;
    _isClosed = true;

    _logger.info('SseClient: Closing connection');

    _retryTimer?.cancel();
    _cleanup();

    if (!_eventController.isClosed) {
      _eventController.close();
    }
  }

  /// Whether connection is closed
  bool get isClosed => _isClosed;
}

/// SSE event
class SseEvent {
  final String type;
  final String? data;

  SseEvent({required this.type, this.data});

  @override
  String toString() => 'SseEvent(type: $type, data: $data)';
}
