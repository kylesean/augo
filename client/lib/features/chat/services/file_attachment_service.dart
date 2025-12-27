import 'package:logging/logging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/network_client.dart';
import '../../../core/network/exceptions/app_exception.dart';
import '../models/attachment_signed_url_result.dart';
import '../models/chat_message_attachment.dart';

final _logger = Logger('FileAttachmentService');

class FileAttachmentService {
  final NetworkClient _networkClient;

  FileAttachmentService(this._networkClient);

  Future<AttachmentSignedUrlResult> fetchSignedUrls(
    List<ChatMessageAttachment> attachments,
  ) async {
    if (attachments.isEmpty) {
      return AttachmentSignedUrlResult.empty;
    }

    try {
      final response = await _networkClient.request<Map<String, dynamic>>(
        '/files/signed-urls',
        method: HttpMethod.post,
        data: {
          'attachments': attachments
              .map(
                (attachment) => {
                  'attachment_id': attachment.id,
                  'object_key': attachment.filename,
                },
              )
              .toList(),
        },
        fromJsonT: (json) {
          if (json is Map<String, dynamic>) {
            return json;
          }
          throw DataParsingException(
            'API /files/signed-urls returned unexpected payload ${json.runtimeType}',
          );
        },
      );

      return AttachmentSignedUrlResult.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.warning(
        'FileAttachmentService: fetchSignedUrls failed: $e',
        e,
        stackTrace,
      );
      throw NetworkException('Failed to fetch signed URLs: $e');
    }
  }
}

final fileAttachmentServiceProvider = Provider<FileAttachmentService>((ref) {
  final client = ref.watch(networkClientProvider);
  return FileAttachmentService(client);
});
