// features/chat/models/message_chunk.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_chunk.freezed.dart';
part 'message_chunk.g.dart';

@freezed
abstract class MessageChunk with _$MessageChunk {
  const factory MessageChunk({
    required String type, // e.g., text / tool_call / image, etc.
    required dynamic content, // content can be String / Map / List, etc.
  }) = _MessageChunk;

  factory MessageChunk.fromJson(Map<String, dynamic> json) =>
      _$MessageChunkFromJson(json);
}
