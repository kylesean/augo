// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMessage {

@JsonKey(defaultValue: '') String get id;@JsonKey(fromJson: _senderFromJson, toJson: _senderToJson, readValue: _readSenderValue) MessageSender get sender;@JsonKey(fromJson: _dateTimeNullableFromJson, toJson: _dateTimeNullableToJson) DateTime? get timestamp; String get content;@JsonKey(name: 'messageType') MessageType get messageType;@JsonKey(name: 'feedbackStatus') AIFeedbackStatus get feedbackStatus;@JsonKey(name: 'streamingStatus') StreamingStatus get streamingStatus;@JsonKey(name: 'isTyping') bool get isTyping;// conversationId exists in each message from API response, can be added
@JsonKey(name: 'conversationId') String? get conversationId;// GenUI surface IDs
@JsonKey(name: 'surfaceIds') List<String> get surfaceIds;// Tool calls made by AI (from history)
@JsonKey(name: 'toolCalls', fromJson: _toolCallsFromJson, toJson: _toolCallsToJson) List<ToolCallInfo> get toolCalls;// UI components for GenUI rendering (from history)
@JsonKey(name: 'uiComponents', fromJson: _uiComponentsFromJson, toJson: _uiComponentsToJson) List<UIComponentInfo> get uiComponents;// Unified content parts (Text, ToolCall, or UIComponent)
// This allows interleaving text and tools in order.
@JsonKey(name: 'fullContent', fromJson: _fullContentFromJson, toJson: _fullContentToJson, readValue: _readFullContentValue) List<MessageContentPart> get fullContent;@JsonKey(name: 'attachments', fromJson: _attachmentsFromJson, toJson: _attachmentsToJson) List<ChatMessageAttachment> get attachments;// Media file data (attachments in user messages)
@JsonKey(name: 'mediaFiles', fromJson: _mediaFilesFromJson, toJson: _mediaFilesToJson) List<DataUriFile> get mediaFiles;
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<ChatMessage> get copyWith => _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.content, content) || other.content == content)&&(identical(other.messageType, messageType) || other.messageType == messageType)&&(identical(other.feedbackStatus, feedbackStatus) || other.feedbackStatus == feedbackStatus)&&(identical(other.streamingStatus, streamingStatus) || other.streamingStatus == streamingStatus)&&(identical(other.isTyping, isTyping) || other.isTyping == isTyping)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&const DeepCollectionEquality().equals(other.surfaceIds, surfaceIds)&&const DeepCollectionEquality().equals(other.toolCalls, toolCalls)&&const DeepCollectionEquality().equals(other.uiComponents, uiComponents)&&const DeepCollectionEquality().equals(other.fullContent, fullContent)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&const DeepCollectionEquality().equals(other.mediaFiles, mediaFiles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sender,timestamp,content,messageType,feedbackStatus,streamingStatus,isTyping,conversationId,const DeepCollectionEquality().hash(surfaceIds),const DeepCollectionEquality().hash(toolCalls),const DeepCollectionEquality().hash(uiComponents),const DeepCollectionEquality().hash(fullContent),const DeepCollectionEquality().hash(attachments),const DeepCollectionEquality().hash(mediaFiles));

@override
String toString() {
  return 'ChatMessage(id: $id, sender: $sender, timestamp: $timestamp, content: $content, messageType: $messageType, feedbackStatus: $feedbackStatus, streamingStatus: $streamingStatus, isTyping: $isTyping, conversationId: $conversationId, surfaceIds: $surfaceIds, toolCalls: $toolCalls, uiComponents: $uiComponents, fullContent: $fullContent, attachments: $attachments, mediaFiles: $mediaFiles)';
}


}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res>  {
  factory $ChatMessageCopyWith(ChatMessage value, $Res Function(ChatMessage) _then) = _$ChatMessageCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(fromJson: _senderFromJson, toJson: _senderToJson, readValue: _readSenderValue) MessageSender sender,@JsonKey(fromJson: _dateTimeNullableFromJson, toJson: _dateTimeNullableToJson) DateTime? timestamp, String content,@JsonKey(name: 'messageType') MessageType messageType,@JsonKey(name: 'feedbackStatus') AIFeedbackStatus feedbackStatus,@JsonKey(name: 'streamingStatus') StreamingStatus streamingStatus,@JsonKey(name: 'isTyping') bool isTyping,@JsonKey(name: 'conversationId') String? conversationId,@JsonKey(name: 'surfaceIds') List<String> surfaceIds,@JsonKey(name: 'toolCalls', fromJson: _toolCallsFromJson, toJson: _toolCallsToJson) List<ToolCallInfo> toolCalls,@JsonKey(name: 'uiComponents', fromJson: _uiComponentsFromJson, toJson: _uiComponentsToJson) List<UIComponentInfo> uiComponents,@JsonKey(name: 'fullContent', fromJson: _fullContentFromJson, toJson: _fullContentToJson, readValue: _readFullContentValue) List<MessageContentPart> fullContent,@JsonKey(name: 'attachments', fromJson: _attachmentsFromJson, toJson: _attachmentsToJson) List<ChatMessageAttachment> attachments,@JsonKey(name: 'mediaFiles', fromJson: _mediaFilesFromJson, toJson: _mediaFilesToJson) List<DataUriFile> mediaFiles
});




}
/// @nodoc
class _$ChatMessageCopyWithImpl<$Res>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sender = null,Object? timestamp = freezed,Object? content = null,Object? messageType = null,Object? feedbackStatus = null,Object? streamingStatus = null,Object? isTyping = null,Object? conversationId = freezed,Object? surfaceIds = null,Object? toolCalls = null,Object? uiComponents = null,Object? fullContent = null,Object? attachments = null,Object? mediaFiles = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as MessageSender,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as MessageType,feedbackStatus: null == feedbackStatus ? _self.feedbackStatus : feedbackStatus // ignore: cast_nullable_to_non_nullable
as AIFeedbackStatus,streamingStatus: null == streamingStatus ? _self.streamingStatus : streamingStatus // ignore: cast_nullable_to_non_nullable
as StreamingStatus,isTyping: null == isTyping ? _self.isTyping : isTyping // ignore: cast_nullable_to_non_nullable
as bool,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,surfaceIds: null == surfaceIds ? _self.surfaceIds : surfaceIds // ignore: cast_nullable_to_non_nullable
as List<String>,toolCalls: null == toolCalls ? _self.toolCalls : toolCalls // ignore: cast_nullable_to_non_nullable
as List<ToolCallInfo>,uiComponents: null == uiComponents ? _self.uiComponents : uiComponents // ignore: cast_nullable_to_non_nullable
as List<UIComponentInfo>,fullContent: null == fullContent ? _self.fullContent : fullContent // ignore: cast_nullable_to_non_nullable
as List<MessageContentPart>,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ChatMessageAttachment>,mediaFiles: null == mediaFiles ? _self.mediaFiles : mediaFiles // ignore: cast_nullable_to_non_nullable
as List<DataUriFile>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(fromJson: _senderFromJson, toJson: _senderToJson, readValue: _readSenderValue)  MessageSender sender, @JsonKey(fromJson: _dateTimeNullableFromJson, toJson: _dateTimeNullableToJson)  DateTime? timestamp,  String content, @JsonKey(name: 'messageType')  MessageType messageType, @JsonKey(name: 'feedbackStatus')  AIFeedbackStatus feedbackStatus, @JsonKey(name: 'streamingStatus')  StreamingStatus streamingStatus, @JsonKey(name: 'isTyping')  bool isTyping, @JsonKey(name: 'conversationId')  String? conversationId, @JsonKey(name: 'surfaceIds')  List<String> surfaceIds, @JsonKey(name: 'toolCalls', fromJson: _toolCallsFromJson, toJson: _toolCallsToJson)  List<ToolCallInfo> toolCalls, @JsonKey(name: 'uiComponents', fromJson: _uiComponentsFromJson, toJson: _uiComponentsToJson)  List<UIComponentInfo> uiComponents, @JsonKey(name: 'fullContent', fromJson: _fullContentFromJson, toJson: _fullContentToJson, readValue: _readFullContentValue)  List<MessageContentPart> fullContent, @JsonKey(name: 'attachments', fromJson: _attachmentsFromJson, toJson: _attachmentsToJson)  List<ChatMessageAttachment> attachments, @JsonKey(name: 'mediaFiles', fromJson: _mediaFilesFromJson, toJson: _mediaFilesToJson)  List<DataUriFile> mediaFiles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.sender,_that.timestamp,_that.content,_that.messageType,_that.feedbackStatus,_that.streamingStatus,_that.isTyping,_that.conversationId,_that.surfaceIds,_that.toolCalls,_that.uiComponents,_that.fullContent,_that.attachments,_that.mediaFiles);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(fromJson: _senderFromJson, toJson: _senderToJson, readValue: _readSenderValue)  MessageSender sender, @JsonKey(fromJson: _dateTimeNullableFromJson, toJson: _dateTimeNullableToJson)  DateTime? timestamp,  String content, @JsonKey(name: 'messageType')  MessageType messageType, @JsonKey(name: 'feedbackStatus')  AIFeedbackStatus feedbackStatus, @JsonKey(name: 'streamingStatus')  StreamingStatus streamingStatus, @JsonKey(name: 'isTyping')  bool isTyping, @JsonKey(name: 'conversationId')  String? conversationId, @JsonKey(name: 'surfaceIds')  List<String> surfaceIds, @JsonKey(name: 'toolCalls', fromJson: _toolCallsFromJson, toJson: _toolCallsToJson)  List<ToolCallInfo> toolCalls, @JsonKey(name: 'uiComponents', fromJson: _uiComponentsFromJson, toJson: _uiComponentsToJson)  List<UIComponentInfo> uiComponents, @JsonKey(name: 'fullContent', fromJson: _fullContentFromJson, toJson: _fullContentToJson, readValue: _readFullContentValue)  List<MessageContentPart> fullContent, @JsonKey(name: 'attachments', fromJson: _attachmentsFromJson, toJson: _attachmentsToJson)  List<ChatMessageAttachment> attachments, @JsonKey(name: 'mediaFiles', fromJson: _mediaFilesFromJson, toJson: _mediaFilesToJson)  List<DataUriFile> mediaFiles)  $default,) {final _that = this;
switch (_that) {
case _ChatMessage():
return $default(_that.id,_that.sender,_that.timestamp,_that.content,_that.messageType,_that.feedbackStatus,_that.streamingStatus,_that.isTyping,_that.conversationId,_that.surfaceIds,_that.toolCalls,_that.uiComponents,_that.fullContent,_that.attachments,_that.mediaFiles);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String id, @JsonKey(fromJson: _senderFromJson, toJson: _senderToJson, readValue: _readSenderValue)  MessageSender sender, @JsonKey(fromJson: _dateTimeNullableFromJson, toJson: _dateTimeNullableToJson)  DateTime? timestamp,  String content, @JsonKey(name: 'messageType')  MessageType messageType, @JsonKey(name: 'feedbackStatus')  AIFeedbackStatus feedbackStatus, @JsonKey(name: 'streamingStatus')  StreamingStatus streamingStatus, @JsonKey(name: 'isTyping')  bool isTyping, @JsonKey(name: 'conversationId')  String? conversationId, @JsonKey(name: 'surfaceIds')  List<String> surfaceIds, @JsonKey(name: 'toolCalls', fromJson: _toolCallsFromJson, toJson: _toolCallsToJson)  List<ToolCallInfo> toolCalls, @JsonKey(name: 'uiComponents', fromJson: _uiComponentsFromJson, toJson: _uiComponentsToJson)  List<UIComponentInfo> uiComponents, @JsonKey(name: 'fullContent', fromJson: _fullContentFromJson, toJson: _fullContentToJson, readValue: _readFullContentValue)  List<MessageContentPart> fullContent, @JsonKey(name: 'attachments', fromJson: _attachmentsFromJson, toJson: _attachmentsToJson)  List<ChatMessageAttachment> attachments, @JsonKey(name: 'mediaFiles', fromJson: _mediaFilesFromJson, toJson: _mediaFilesToJson)  List<DataUriFile> mediaFiles)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.sender,_that.timestamp,_that.content,_that.messageType,_that.feedbackStatus,_that.streamingStatus,_that.isTyping,_that.conversationId,_that.surfaceIds,_that.toolCalls,_that.uiComponents,_that.fullContent,_that.attachments,_that.mediaFiles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessage implements ChatMessage {
  const _ChatMessage({@JsonKey(defaultValue: '') required this.id, @JsonKey(fromJson: _senderFromJson, toJson: _senderToJson, readValue: _readSenderValue) required this.sender, @JsonKey(fromJson: _dateTimeNullableFromJson, toJson: _dateTimeNullableToJson) this.timestamp, this.content = "", @JsonKey(name: 'messageType') this.messageType = MessageType.text, @JsonKey(name: 'feedbackStatus') this.feedbackStatus = AIFeedbackStatus.none, @JsonKey(name: 'streamingStatus') this.streamingStatus = StreamingStatus.none, @JsonKey(name: 'isTyping') this.isTyping = false, @JsonKey(name: 'conversationId') this.conversationId, @JsonKey(name: 'surfaceIds') final  List<String> surfaceIds = const [], @JsonKey(name: 'toolCalls', fromJson: _toolCallsFromJson, toJson: _toolCallsToJson) final  List<ToolCallInfo> toolCalls = const [], @JsonKey(name: 'uiComponents', fromJson: _uiComponentsFromJson, toJson: _uiComponentsToJson) final  List<UIComponentInfo> uiComponents = const [], @JsonKey(name: 'fullContent', fromJson: _fullContentFromJson, toJson: _fullContentToJson, readValue: _readFullContentValue) final  List<MessageContentPart> fullContent = const [], @JsonKey(name: 'attachments', fromJson: _attachmentsFromJson, toJson: _attachmentsToJson) final  List<ChatMessageAttachment> attachments = const [], @JsonKey(name: 'mediaFiles', fromJson: _mediaFilesFromJson, toJson: _mediaFilesToJson) final  List<DataUriFile> mediaFiles = const []}): _surfaceIds = surfaceIds,_toolCalls = toolCalls,_uiComponents = uiComponents,_fullContent = fullContent,_attachments = attachments,_mediaFiles = mediaFiles;
  factory _ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

@override@JsonKey(defaultValue: '') final  String id;
@override@JsonKey(fromJson: _senderFromJson, toJson: _senderToJson, readValue: _readSenderValue) final  MessageSender sender;
@override@JsonKey(fromJson: _dateTimeNullableFromJson, toJson: _dateTimeNullableToJson) final  DateTime? timestamp;
@override@JsonKey() final  String content;
@override@JsonKey(name: 'messageType') final  MessageType messageType;
@override@JsonKey(name: 'feedbackStatus') final  AIFeedbackStatus feedbackStatus;
@override@JsonKey(name: 'streamingStatus') final  StreamingStatus streamingStatus;
@override@JsonKey(name: 'isTyping') final  bool isTyping;
// conversationId exists in each message from API response, can be added
@override@JsonKey(name: 'conversationId') final  String? conversationId;
// GenUI surface IDs
 final  List<String> _surfaceIds;
// GenUI surface IDs
@override@JsonKey(name: 'surfaceIds') List<String> get surfaceIds {
  if (_surfaceIds is EqualUnmodifiableListView) return _surfaceIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_surfaceIds);
}

// Tool calls made by AI (from history)
 final  List<ToolCallInfo> _toolCalls;
// Tool calls made by AI (from history)
@override@JsonKey(name: 'toolCalls', fromJson: _toolCallsFromJson, toJson: _toolCallsToJson) List<ToolCallInfo> get toolCalls {
  if (_toolCalls is EqualUnmodifiableListView) return _toolCalls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_toolCalls);
}

// UI components for GenUI rendering (from history)
 final  List<UIComponentInfo> _uiComponents;
// UI components for GenUI rendering (from history)
@override@JsonKey(name: 'uiComponents', fromJson: _uiComponentsFromJson, toJson: _uiComponentsToJson) List<UIComponentInfo> get uiComponents {
  if (_uiComponents is EqualUnmodifiableListView) return _uiComponents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uiComponents);
}

// Unified content parts (Text, ToolCall, or UIComponent)
// This allows interleaving text and tools in order.
 final  List<MessageContentPart> _fullContent;
// Unified content parts (Text, ToolCall, or UIComponent)
// This allows interleaving text and tools in order.
@override@JsonKey(name: 'fullContent', fromJson: _fullContentFromJson, toJson: _fullContentToJson, readValue: _readFullContentValue) List<MessageContentPart> get fullContent {
  if (_fullContent is EqualUnmodifiableListView) return _fullContent;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fullContent);
}

 final  List<ChatMessageAttachment> _attachments;
@override@JsonKey(name: 'attachments', fromJson: _attachmentsFromJson, toJson: _attachmentsToJson) List<ChatMessageAttachment> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}

// Media file data (attachments in user messages)
 final  List<DataUriFile> _mediaFiles;
// Media file data (attachments in user messages)
@override@JsonKey(name: 'mediaFiles', fromJson: _mediaFilesFromJson, toJson: _mediaFilesToJson) List<DataUriFile> get mediaFiles {
  if (_mediaFiles is EqualUnmodifiableListView) return _mediaFiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mediaFiles);
}


/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageCopyWith<_ChatMessage> get copyWith => __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.content, content) || other.content == content)&&(identical(other.messageType, messageType) || other.messageType == messageType)&&(identical(other.feedbackStatus, feedbackStatus) || other.feedbackStatus == feedbackStatus)&&(identical(other.streamingStatus, streamingStatus) || other.streamingStatus == streamingStatus)&&(identical(other.isTyping, isTyping) || other.isTyping == isTyping)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&const DeepCollectionEquality().equals(other._surfaceIds, _surfaceIds)&&const DeepCollectionEquality().equals(other._toolCalls, _toolCalls)&&const DeepCollectionEquality().equals(other._uiComponents, _uiComponents)&&const DeepCollectionEquality().equals(other._fullContent, _fullContent)&&const DeepCollectionEquality().equals(other._attachments, _attachments)&&const DeepCollectionEquality().equals(other._mediaFiles, _mediaFiles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sender,timestamp,content,messageType,feedbackStatus,streamingStatus,isTyping,conversationId,const DeepCollectionEquality().hash(_surfaceIds),const DeepCollectionEquality().hash(_toolCalls),const DeepCollectionEquality().hash(_uiComponents),const DeepCollectionEquality().hash(_fullContent),const DeepCollectionEquality().hash(_attachments),const DeepCollectionEquality().hash(_mediaFiles));

@override
String toString() {
  return 'ChatMessage(id: $id, sender: $sender, timestamp: $timestamp, content: $content, messageType: $messageType, feedbackStatus: $feedbackStatus, streamingStatus: $streamingStatus, isTyping: $isTyping, conversationId: $conversationId, surfaceIds: $surfaceIds, toolCalls: $toolCalls, uiComponents: $uiComponents, fullContent: $fullContent, attachments: $attachments, mediaFiles: $mediaFiles)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(_ChatMessage value, $Res Function(_ChatMessage) _then) = __$ChatMessageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(fromJson: _senderFromJson, toJson: _senderToJson, readValue: _readSenderValue) MessageSender sender,@JsonKey(fromJson: _dateTimeNullableFromJson, toJson: _dateTimeNullableToJson) DateTime? timestamp, String content,@JsonKey(name: 'messageType') MessageType messageType,@JsonKey(name: 'feedbackStatus') AIFeedbackStatus feedbackStatus,@JsonKey(name: 'streamingStatus') StreamingStatus streamingStatus,@JsonKey(name: 'isTyping') bool isTyping,@JsonKey(name: 'conversationId') String? conversationId,@JsonKey(name: 'surfaceIds') List<String> surfaceIds,@JsonKey(name: 'toolCalls', fromJson: _toolCallsFromJson, toJson: _toolCallsToJson) List<ToolCallInfo> toolCalls,@JsonKey(name: 'uiComponents', fromJson: _uiComponentsFromJson, toJson: _uiComponentsToJson) List<UIComponentInfo> uiComponents,@JsonKey(name: 'fullContent', fromJson: _fullContentFromJson, toJson: _fullContentToJson, readValue: _readFullContentValue) List<MessageContentPart> fullContent,@JsonKey(name: 'attachments', fromJson: _attachmentsFromJson, toJson: _attachmentsToJson) List<ChatMessageAttachment> attachments,@JsonKey(name: 'mediaFiles', fromJson: _mediaFilesFromJson, toJson: _mediaFilesToJson) List<DataUriFile> mediaFiles
});




}
/// @nodoc
class __$ChatMessageCopyWithImpl<$Res>
    implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sender = null,Object? timestamp = freezed,Object? content = null,Object? messageType = null,Object? feedbackStatus = null,Object? streamingStatus = null,Object? isTyping = null,Object? conversationId = freezed,Object? surfaceIds = null,Object? toolCalls = null,Object? uiComponents = null,Object? fullContent = null,Object? attachments = null,Object? mediaFiles = null,}) {
  return _then(_ChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as MessageSender,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as MessageType,feedbackStatus: null == feedbackStatus ? _self.feedbackStatus : feedbackStatus // ignore: cast_nullable_to_non_nullable
as AIFeedbackStatus,streamingStatus: null == streamingStatus ? _self.streamingStatus : streamingStatus // ignore: cast_nullable_to_non_nullable
as StreamingStatus,isTyping: null == isTyping ? _self.isTyping : isTyping // ignore: cast_nullable_to_non_nullable
as bool,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,surfaceIds: null == surfaceIds ? _self._surfaceIds : surfaceIds // ignore: cast_nullable_to_non_nullable
as List<String>,toolCalls: null == toolCalls ? _self._toolCalls : toolCalls // ignore: cast_nullable_to_non_nullable
as List<ToolCallInfo>,uiComponents: null == uiComponents ? _self._uiComponents : uiComponents // ignore: cast_nullable_to_non_nullable
as List<UIComponentInfo>,fullContent: null == fullContent ? _self._fullContent : fullContent // ignore: cast_nullable_to_non_nullable
as List<MessageContentPart>,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ChatMessageAttachment>,mediaFiles: null == mediaFiles ? _self._mediaFiles : mediaFiles // ignore: cast_nullable_to_non_nullable
as List<DataUriFile>,
  ));
}


}

// dart format on
