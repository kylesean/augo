// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatHistoryState {

 String? get currentConversationId; String? get currentConversationTitle; bool get isLoadingHistory; List<ChatMessage> get messages; String? get historyError; int get historyCurrentPage;// Current loaded history message page
 bool get historyHasMore;// Whether there are more history messages to load
 bool get isStreamingResponse;
/// Create a copy of ChatHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatHistoryStateCopyWith<ChatHistoryState> get copyWith => _$ChatHistoryStateCopyWithImpl<ChatHistoryState>(this as ChatHistoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatHistoryState&&(identical(other.currentConversationId, currentConversationId) || other.currentConversationId == currentConversationId)&&(identical(other.currentConversationTitle, currentConversationTitle) || other.currentConversationTitle == currentConversationTitle)&&(identical(other.isLoadingHistory, isLoadingHistory) || other.isLoadingHistory == isLoadingHistory)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.historyError, historyError) || other.historyError == historyError)&&(identical(other.historyCurrentPage, historyCurrentPage) || other.historyCurrentPage == historyCurrentPage)&&(identical(other.historyHasMore, historyHasMore) || other.historyHasMore == historyHasMore)&&(identical(other.isStreamingResponse, isStreamingResponse) || other.isStreamingResponse == isStreamingResponse));
}


@override
int get hashCode => Object.hash(runtimeType,currentConversationId,currentConversationTitle,isLoadingHistory,const DeepCollectionEquality().hash(messages),historyError,historyCurrentPage,historyHasMore,isStreamingResponse);

@override
String toString() {
  return 'ChatHistoryState(currentConversationId: $currentConversationId, currentConversationTitle: $currentConversationTitle, isLoadingHistory: $isLoadingHistory, messages: $messages, historyError: $historyError, historyCurrentPage: $historyCurrentPage, historyHasMore: $historyHasMore, isStreamingResponse: $isStreamingResponse)';
}


}

/// @nodoc
abstract mixin class $ChatHistoryStateCopyWith<$Res>  {
  factory $ChatHistoryStateCopyWith(ChatHistoryState value, $Res Function(ChatHistoryState) _then) = _$ChatHistoryStateCopyWithImpl;
@useResult
$Res call({
 String? currentConversationId, String? currentConversationTitle, bool isLoadingHistory, List<ChatMessage> messages, String? historyError, int historyCurrentPage, bool historyHasMore, bool isStreamingResponse
});




}
/// @nodoc
class _$ChatHistoryStateCopyWithImpl<$Res>
    implements $ChatHistoryStateCopyWith<$Res> {
  _$ChatHistoryStateCopyWithImpl(this._self, this._then);

  final ChatHistoryState _self;
  final $Res Function(ChatHistoryState) _then;

/// Create a copy of ChatHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentConversationId = freezed,Object? currentConversationTitle = freezed,Object? isLoadingHistory = null,Object? messages = null,Object? historyError = freezed,Object? historyCurrentPage = null,Object? historyHasMore = null,Object? isStreamingResponse = null,}) {
  return _then(_self.copyWith(
currentConversationId: freezed == currentConversationId ? _self.currentConversationId : currentConversationId // ignore: cast_nullable_to_non_nullable
as String?,currentConversationTitle: freezed == currentConversationTitle ? _self.currentConversationTitle : currentConversationTitle // ignore: cast_nullable_to_non_nullable
as String?,isLoadingHistory: null == isLoadingHistory ? _self.isLoadingHistory : isLoadingHistory // ignore: cast_nullable_to_non_nullable
as bool,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,historyError: freezed == historyError ? _self.historyError : historyError // ignore: cast_nullable_to_non_nullable
as String?,historyCurrentPage: null == historyCurrentPage ? _self.historyCurrentPage : historyCurrentPage // ignore: cast_nullable_to_non_nullable
as int,historyHasMore: null == historyHasMore ? _self.historyHasMore : historyHasMore // ignore: cast_nullable_to_non_nullable
as bool,isStreamingResponse: null == isStreamingResponse ? _self.isStreamingResponse : isStreamingResponse // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatHistoryState].
extension ChatHistoryStatePatterns on ChatHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatHistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatHistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatHistoryState value)  $default,){
final _that = this;
switch (_that) {
case _ChatHistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatHistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _ChatHistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? currentConversationId,  String? currentConversationTitle,  bool isLoadingHistory,  List<ChatMessage> messages,  String? historyError,  int historyCurrentPage,  bool historyHasMore,  bool isStreamingResponse)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatHistoryState() when $default != null:
return $default(_that.currentConversationId,_that.currentConversationTitle,_that.isLoadingHistory,_that.messages,_that.historyError,_that.historyCurrentPage,_that.historyHasMore,_that.isStreamingResponse);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? currentConversationId,  String? currentConversationTitle,  bool isLoadingHistory,  List<ChatMessage> messages,  String? historyError,  int historyCurrentPage,  bool historyHasMore,  bool isStreamingResponse)  $default,) {final _that = this;
switch (_that) {
case _ChatHistoryState():
return $default(_that.currentConversationId,_that.currentConversationTitle,_that.isLoadingHistory,_that.messages,_that.historyError,_that.historyCurrentPage,_that.historyHasMore,_that.isStreamingResponse);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? currentConversationId,  String? currentConversationTitle,  bool isLoadingHistory,  List<ChatMessage> messages,  String? historyError,  int historyCurrentPage,  bool historyHasMore,  bool isStreamingResponse)?  $default,) {final _that = this;
switch (_that) {
case _ChatHistoryState() when $default != null:
return $default(_that.currentConversationId,_that.currentConversationTitle,_that.isLoadingHistory,_that.messages,_that.historyError,_that.historyCurrentPage,_that.historyHasMore,_that.isStreamingResponse);case _:
  return null;

}
}

}

/// @nodoc


class _ChatHistoryState implements ChatHistoryState {
  const _ChatHistoryState({this.currentConversationId, this.currentConversationTitle, this.isLoadingHistory = false, final  List<ChatMessage> messages = const [], this.historyError, this.historyCurrentPage = 1, this.historyHasMore = true, this.isStreamingResponse = false}): _messages = messages;


@override final  String? currentConversationId;
@override final  String? currentConversationTitle;
@override@JsonKey() final  bool isLoadingHistory;
 final  List<ChatMessage> _messages;
@override@JsonKey() List<ChatMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override final  String? historyError;
@override@JsonKey() final  int historyCurrentPage;
// Current loaded history message page
@override@JsonKey() final  bool historyHasMore;
// Whether there are more history messages to load
@override@JsonKey() final  bool isStreamingResponse;

/// Create a copy of ChatHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatHistoryStateCopyWith<_ChatHistoryState> get copyWith => __$ChatHistoryStateCopyWithImpl<_ChatHistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatHistoryState&&(identical(other.currentConversationId, currentConversationId) || other.currentConversationId == currentConversationId)&&(identical(other.currentConversationTitle, currentConversationTitle) || other.currentConversationTitle == currentConversationTitle)&&(identical(other.isLoadingHistory, isLoadingHistory) || other.isLoadingHistory == isLoadingHistory)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.historyError, historyError) || other.historyError == historyError)&&(identical(other.historyCurrentPage, historyCurrentPage) || other.historyCurrentPage == historyCurrentPage)&&(identical(other.historyHasMore, historyHasMore) || other.historyHasMore == historyHasMore)&&(identical(other.isStreamingResponse, isStreamingResponse) || other.isStreamingResponse == isStreamingResponse));
}


@override
int get hashCode => Object.hash(runtimeType,currentConversationId,currentConversationTitle,isLoadingHistory,const DeepCollectionEquality().hash(_messages),historyError,historyCurrentPage,historyHasMore,isStreamingResponse);

@override
String toString() {
  return 'ChatHistoryState(currentConversationId: $currentConversationId, currentConversationTitle: $currentConversationTitle, isLoadingHistory: $isLoadingHistory, messages: $messages, historyError: $historyError, historyCurrentPage: $historyCurrentPage, historyHasMore: $historyHasMore, isStreamingResponse: $isStreamingResponse)';
}


}

/// @nodoc
abstract mixin class _$ChatHistoryStateCopyWith<$Res> implements $ChatHistoryStateCopyWith<$Res> {
  factory _$ChatHistoryStateCopyWith(_ChatHistoryState value, $Res Function(_ChatHistoryState) _then) = __$ChatHistoryStateCopyWithImpl;
@override @useResult
$Res call({
 String? currentConversationId, String? currentConversationTitle, bool isLoadingHistory, List<ChatMessage> messages, String? historyError, int historyCurrentPage, bool historyHasMore, bool isStreamingResponse
});




}
/// @nodoc
class __$ChatHistoryStateCopyWithImpl<$Res>
    implements _$ChatHistoryStateCopyWith<$Res> {
  __$ChatHistoryStateCopyWithImpl(this._self, this._then);

  final _ChatHistoryState _self;
  final $Res Function(_ChatHistoryState) _then;

/// Create a copy of ChatHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentConversationId = freezed,Object? currentConversationTitle = freezed,Object? isLoadingHistory = null,Object? messages = null,Object? historyError = freezed,Object? historyCurrentPage = null,Object? historyHasMore = null,Object? isStreamingResponse = null,}) {
  return _then(_ChatHistoryState(
currentConversationId: freezed == currentConversationId ? _self.currentConversationId : currentConversationId // ignore: cast_nullable_to_non_nullable
as String?,currentConversationTitle: freezed == currentConversationTitle ? _self.currentConversationTitle : currentConversationTitle // ignore: cast_nullable_to_non_nullable
as String?,isLoadingHistory: null == isLoadingHistory ? _self.isLoadingHistory : isLoadingHistory // ignore: cast_nullable_to_non_nullable
as bool,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,historyError: freezed == historyError ? _self.historyError : historyError // ignore: cast_nullable_to_non_nullable
as String?,historyCurrentPage: null == historyCurrentPage ? _self.historyCurrentPage : historyCurrentPage // ignore: cast_nullable_to_non_nullable
as int,historyHasMore: null == historyHasMore ? _self.historyHasMore : historyHasMore // ignore: cast_nullable_to_non_nullable
as bool,isStreamingResponse: null == isStreamingResponse ? _self.isStreamingResponse : isStreamingResponse // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
