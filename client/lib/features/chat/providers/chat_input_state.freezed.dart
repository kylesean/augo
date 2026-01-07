// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_input_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatInputState {

 String get text;// Current text in the input box
 bool get isListening;// Whether speech recognition is in progress
 bool get isSpeechAvailable;// Whether speech recognition service is available
 bool get isLoadingResponse;// Whether waiting for AI response
 bool get showError;// Whether to show error提示
 String get errorMessage;// Error message content
 HintType get hintType;// Used to control input box hint text type
 List<XFile> get selectedFiles;// List of selected files
 Map<String, bool> get uploadingFiles;
/// Create a copy of ChatInputState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatInputStateCopyWith<ChatInputState> get copyWith => _$ChatInputStateCopyWithImpl<ChatInputState>(this as ChatInputState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatInputState&&(identical(other.text, text) || other.text == text)&&(identical(other.isListening, isListening) || other.isListening == isListening)&&(identical(other.isSpeechAvailable, isSpeechAvailable) || other.isSpeechAvailable == isSpeechAvailable)&&(identical(other.isLoadingResponse, isLoadingResponse) || other.isLoadingResponse == isLoadingResponse)&&(identical(other.showError, showError) || other.showError == showError)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.hintType, hintType) || other.hintType == hintType)&&const DeepCollectionEquality().equals(other.selectedFiles, selectedFiles)&&const DeepCollectionEquality().equals(other.uploadingFiles, uploadingFiles));
}


@override
int get hashCode => Object.hash(runtimeType,text,isListening,isSpeechAvailable,isLoadingResponse,showError,errorMessage,hintType,const DeepCollectionEquality().hash(selectedFiles),const DeepCollectionEquality().hash(uploadingFiles));

@override
String toString() {
  return 'ChatInputState(text: $text, isListening: $isListening, isSpeechAvailable: $isSpeechAvailable, isLoadingResponse: $isLoadingResponse, showError: $showError, errorMessage: $errorMessage, hintType: $hintType, selectedFiles: $selectedFiles, uploadingFiles: $uploadingFiles)';
}


}

/// @nodoc
abstract mixin class $ChatInputStateCopyWith<$Res>  {
  factory $ChatInputStateCopyWith(ChatInputState value, $Res Function(ChatInputState) _then) = _$ChatInputStateCopyWithImpl;
@useResult
$Res call({
 String text, bool isListening, bool isSpeechAvailable, bool isLoadingResponse, bool showError, String errorMessage, HintType hintType, List<XFile> selectedFiles, Map<String, bool> uploadingFiles
});




}
/// @nodoc
class _$ChatInputStateCopyWithImpl<$Res>
    implements $ChatInputStateCopyWith<$Res> {
  _$ChatInputStateCopyWithImpl(this._self, this._then);

  final ChatInputState _self;
  final $Res Function(ChatInputState) _then;

/// Create a copy of ChatInputState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? isListening = null,Object? isSpeechAvailable = null,Object? isLoadingResponse = null,Object? showError = null,Object? errorMessage = null,Object? hintType = null,Object? selectedFiles = null,Object? uploadingFiles = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isListening: null == isListening ? _self.isListening : isListening // ignore: cast_nullable_to_non_nullable
as bool,isSpeechAvailable: null == isSpeechAvailable ? _self.isSpeechAvailable : isSpeechAvailable // ignore: cast_nullable_to_non_nullable
as bool,isLoadingResponse: null == isLoadingResponse ? _self.isLoadingResponse : isLoadingResponse // ignore: cast_nullable_to_non_nullable
as bool,showError: null == showError ? _self.showError : showError // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,hintType: null == hintType ? _self.hintType : hintType // ignore: cast_nullable_to_non_nullable
as HintType,selectedFiles: null == selectedFiles ? _self.selectedFiles : selectedFiles // ignore: cast_nullable_to_non_nullable
as List<XFile>,uploadingFiles: null == uploadingFiles ? _self.uploadingFiles : uploadingFiles // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatInputState].
extension ChatInputStatePatterns on ChatInputState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatInputState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatInputState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatInputState value)  $default,){
final _that = this;
switch (_that) {
case _ChatInputState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatInputState value)?  $default,){
final _that = this;
switch (_that) {
case _ChatInputState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  bool isListening,  bool isSpeechAvailable,  bool isLoadingResponse,  bool showError,  String errorMessage,  HintType hintType,  List<XFile> selectedFiles,  Map<String, bool> uploadingFiles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatInputState() when $default != null:
return $default(_that.text,_that.isListening,_that.isSpeechAvailable,_that.isLoadingResponse,_that.showError,_that.errorMessage,_that.hintType,_that.selectedFiles,_that.uploadingFiles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  bool isListening,  bool isSpeechAvailable,  bool isLoadingResponse,  bool showError,  String errorMessage,  HintType hintType,  List<XFile> selectedFiles,  Map<String, bool> uploadingFiles)  $default,) {final _that = this;
switch (_that) {
case _ChatInputState():
return $default(_that.text,_that.isListening,_that.isSpeechAvailable,_that.isLoadingResponse,_that.showError,_that.errorMessage,_that.hintType,_that.selectedFiles,_that.uploadingFiles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  bool isListening,  bool isSpeechAvailable,  bool isLoadingResponse,  bool showError,  String errorMessage,  HintType hintType,  List<XFile> selectedFiles,  Map<String, bool> uploadingFiles)?  $default,) {final _that = this;
switch (_that) {
case _ChatInputState() when $default != null:
return $default(_that.text,_that.isListening,_that.isSpeechAvailable,_that.isLoadingResponse,_that.showError,_that.errorMessage,_that.hintType,_that.selectedFiles,_that.uploadingFiles);case _:
  return null;

}
}

}

/// @nodoc


class _ChatInputState implements ChatInputState {
  const _ChatInputState({this.text = '', this.isListening = false, this.isSpeechAvailable = false, this.isLoadingResponse = false, this.showError = false, this.errorMessage = '', this.hintType = HintType.normal, final  List<XFile> selectedFiles = const [], final  Map<String, bool> uploadingFiles = const {}}): _selectedFiles = selectedFiles,_uploadingFiles = uploadingFiles;


@override@JsonKey() final  String text;
// Current text in the input box
@override@JsonKey() final  bool isListening;
// Whether speech recognition is in progress
@override@JsonKey() final  bool isSpeechAvailable;
// Whether speech recognition service is available
@override@JsonKey() final  bool isLoadingResponse;
// Whether waiting for AI response
@override@JsonKey() final  bool showError;
// Whether to show error提示
@override@JsonKey() final  String errorMessage;
// Error message content
@override@JsonKey() final  HintType hintType;
// Used to control input box hint text type
 final  List<XFile> _selectedFiles;
// Used to control input box hint text type
@override@JsonKey() List<XFile> get selectedFiles {
  if (_selectedFiles is EqualUnmodifiableListView) return _selectedFiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedFiles);
}

// List of selected files
 final  Map<String, bool> _uploadingFiles;
// List of selected files
@override@JsonKey() Map<String, bool> get uploadingFiles {
  if (_uploadingFiles is EqualUnmodifiableMapView) return _uploadingFiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_uploadingFiles);
}


/// Create a copy of ChatInputState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatInputStateCopyWith<_ChatInputState> get copyWith => __$ChatInputStateCopyWithImpl<_ChatInputState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatInputState&&(identical(other.text, text) || other.text == text)&&(identical(other.isListening, isListening) || other.isListening == isListening)&&(identical(other.isSpeechAvailable, isSpeechAvailable) || other.isSpeechAvailable == isSpeechAvailable)&&(identical(other.isLoadingResponse, isLoadingResponse) || other.isLoadingResponse == isLoadingResponse)&&(identical(other.showError, showError) || other.showError == showError)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.hintType, hintType) || other.hintType == hintType)&&const DeepCollectionEquality().equals(other._selectedFiles, _selectedFiles)&&const DeepCollectionEquality().equals(other._uploadingFiles, _uploadingFiles));
}


@override
int get hashCode => Object.hash(runtimeType,text,isListening,isSpeechAvailable,isLoadingResponse,showError,errorMessage,hintType,const DeepCollectionEquality().hash(_selectedFiles),const DeepCollectionEquality().hash(_uploadingFiles));

@override
String toString() {
  return 'ChatInputState(text: $text, isListening: $isListening, isSpeechAvailable: $isSpeechAvailable, isLoadingResponse: $isLoadingResponse, showError: $showError, errorMessage: $errorMessage, hintType: $hintType, selectedFiles: $selectedFiles, uploadingFiles: $uploadingFiles)';
}


}

/// @nodoc
abstract mixin class _$ChatInputStateCopyWith<$Res> implements $ChatInputStateCopyWith<$Res> {
  factory _$ChatInputStateCopyWith(_ChatInputState value, $Res Function(_ChatInputState) _then) = __$ChatInputStateCopyWithImpl;
@override @useResult
$Res call({
 String text, bool isListening, bool isSpeechAvailable, bool isLoadingResponse, bool showError, String errorMessage, HintType hintType, List<XFile> selectedFiles, Map<String, bool> uploadingFiles
});




}
/// @nodoc
class __$ChatInputStateCopyWithImpl<$Res>
    implements _$ChatInputStateCopyWith<$Res> {
  __$ChatInputStateCopyWithImpl(this._self, this._then);

  final _ChatInputState _self;
  final $Res Function(_ChatInputState) _then;

/// Create a copy of ChatInputState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? isListening = null,Object? isSpeechAvailable = null,Object? isLoadingResponse = null,Object? showError = null,Object? errorMessage = null,Object? hintType = null,Object? selectedFiles = null,Object? uploadingFiles = null,}) {
  return _then(_ChatInputState(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isListening: null == isListening ? _self.isListening : isListening // ignore: cast_nullable_to_non_nullable
as bool,isSpeechAvailable: null == isSpeechAvailable ? _self.isSpeechAvailable : isSpeechAvailable // ignore: cast_nullable_to_non_nullable
as bool,isLoadingResponse: null == isLoadingResponse ? _self.isLoadingResponse : isLoadingResponse // ignore: cast_nullable_to_non_nullable
as bool,showError: null == showError ? _self.showError : showError // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,hintType: null == hintType ? _self.hintType : hintType // ignore: cast_nullable_to_non_nullable
as HintType,selectedFiles: null == selectedFiles ? _self._selectedFiles : selectedFiles // ignore: cast_nullable_to_non_nullable
as List<XFile>,uploadingFiles: null == uploadingFiles ? _self._uploadingFiles : uploadingFiles // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}


}

// dart format on
