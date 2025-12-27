// features/chat/widgets/media_upload_test_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/media_upload_button.dart';
import '../providers/chat_input_provider.dart';
import '../models/message_attachments.dart';

/// 测试页面，用于验证媒体上传功能
class MediaUploadTestPage extends ConsumerWidget {
  const MediaUploadTestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testProvider = chatInputProvider((
      String text, {
      List<PendingMessageAttachment>? attachments,
    }) async {
      // 测试用的空实现
    });

    return Scaffold(
      appBar: AppBar(title: const Text('媒体上传测试')),
      body: Center(
        child: MediaUploadButton(
          enabled: true,
          chatInputProvider: testProvider,
        ),
      ),
    );
  }
}
