import 'package:freezed_annotation/freezed_annotation.dart';
import 'tool_call_info.dart';

part 'message_content_part.freezed.dart';
part 'message_content_part.g.dart';

@freezed
sealed class MessageContentPart with _$MessageContentPart {
  @FreezedUnionValue('text')
  const factory MessageContentPart.text({required String text}) = TextPart;

  @FreezedUnionValue('tool_call')
  const factory MessageContentPart.toolCall({required ToolCallInfo toolCall}) =
      ToolCallPart;

  @FreezedUnionValue('ui_component')
  const factory MessageContentPart.uiComponent({
    required UIComponentInfo component,
  }) = UIComponentPart;

  factory MessageContentPart.fromJson(Map<String, dynamic> json) =>
      _$MessageContentPartFromJson(json);
}
