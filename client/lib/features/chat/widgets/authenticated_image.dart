// features/chat/widgets/authenticated_image.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'dart:async';

import '../../../core/storage/secure_storage_service.dart';
import '../../../core/constants/api_constants.dart';

/// 带认证的图片加载组件
/// 自动携带 JWT token 请求图片
class AuthenticatedImage extends ConsumerStatefulWidget {
  final String attachmentId;
  final BoxFit fit;
  final Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const AuthenticatedImage({
    super.key,
    required this.attachmentId,
    this.fit = BoxFit.cover,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  ConsumerState<AuthenticatedImage> createState() => _AuthenticatedImageState();
}

class _AuthenticatedImageState extends ConsumerState<AuthenticatedImage> {
  Uint8List? _imageBytes;
  bool _isLoading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_loadImage());
  }

  @override
  void didUpdateWidget(covariant AuthenticatedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.attachmentId != widget.attachmentId) {
      unawaited(_loadImage());
    }
  }

  Future<void> _loadImage() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _imageBytes = null;
    });

    try {
      final storageService = ref.read(secureStorageServiceProvider);
      final token = await storageService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('未找到认证令牌');
      }

      final dio = Dio();
      final apiConstants = ref.read(apiConstantsProvider);
      final url = '${apiConstants.baseUrl}/files/view/${widget.attachmentId}';

      final response = await dio.get<List<int>>(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
        ),
      );

      if (!mounted) return;

      if (response.data != null) {
        setState(() {
          _imageBytes = Uint8List.fromList(response.data!);
          _isLoading = false;
        });
      } else {
        throw Exception('图片数据为空');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      if (widget.loadingBuilder != null) {
        return widget.loadingBuilder!(context, Container(), null);
      }
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(context, _error!, null);
      }
      return Center(
        child: Icon(
          Icons.error_outline,
          color: Theme.of(context).colorScheme.error,
        ),
      );
    }

    if (_imageBytes == null) {
      return const SizedBox.shrink();
    }

    return Image.memory(_imageBytes!, fit: widget.fit, gaplessPlayback: true);
  }
}

/// 带认证的网络图片 Provider
/// 用于缓存已加载的图片数据
final authenticatedImageProvider = FutureProvider.family<Uint8List, String>((
  ref,
  attachmentId,
) async {
  final storageService = ref.watch(secureStorageServiceProvider);
  final token = await storageService.getToken();

  if (token == null || token.isEmpty) {
    throw Exception('未找到认证令牌');
  }

  final dio = Dio();
  final apiConstants = ref.watch(apiConstantsProvider);
  final url = '${apiConstants.baseUrl}/files/view/$attachmentId';

  final response = await dio.get<List<int>>(
    url,
    options: Options(
      headers: {'Authorization': 'Bearer $token'},
      responseType: ResponseType.bytes,
    ),
  );

  if (response.data == null) {
    throw Exception('图片数据为空');
  }

  return Uint8List.fromList(response.data!);
});
