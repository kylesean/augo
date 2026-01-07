// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_conversation_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaginatedConversationState {

 List<ConversationInfo> get conversations; int get currentPage; bool get isLoading; bool get isLoadingMore; bool get hasMore; int get perPage; int get total; bool get isInitialized;// Mark whether list has been initialized and loaded
 String? get error;
/// Create a copy of PaginatedConversationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedConversationStateCopyWith<PaginatedConversationState> get copyWith => _$PaginatedConversationStateCopyWithImpl<PaginatedConversationState>(this as PaginatedConversationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedConversationState&&const DeepCollectionEquality().equals(other.conversations, conversations)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total)&&(identical(other.isInitialized, isInitialized) || other.isInitialized == isInitialized)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(conversations),currentPage,isLoading,isLoadingMore,hasMore,perPage,total,isInitialized,error);

@override
String toString() {
  return 'PaginatedConversationState(conversations: $conversations, currentPage: $currentPage, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasMore: $hasMore, perPage: $perPage, total: $total, isInitialized: $isInitialized, error: $error)';
}


}

/// @nodoc
abstract mixin class $PaginatedConversationStateCopyWith<$Res>  {
  factory $PaginatedConversationStateCopyWith(PaginatedConversationState value, $Res Function(PaginatedConversationState) _then) = _$PaginatedConversationStateCopyWithImpl;
@useResult
$Res call({
 List<ConversationInfo> conversations, int currentPage, bool isLoading, bool isLoadingMore, bool hasMore, int perPage, int total, bool isInitialized, String? error
});




}
/// @nodoc
class _$PaginatedConversationStateCopyWithImpl<$Res>
    implements $PaginatedConversationStateCopyWith<$Res> {
  _$PaginatedConversationStateCopyWithImpl(this._self, this._then);

  final PaginatedConversationState _self;
  final $Res Function(PaginatedConversationState) _then;

/// Create a copy of PaginatedConversationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conversations = null,Object? currentPage = null,Object? isLoading = null,Object? isLoadingMore = null,Object? hasMore = null,Object? perPage = null,Object? total = null,Object? isInitialized = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
conversations: null == conversations ? _self.conversations : conversations // ignore: cast_nullable_to_non_nullable
as List<ConversationInfo>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,isInitialized: null == isInitialized ? _self.isInitialized : isInitialized // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginatedConversationState].
extension PaginatedConversationStatePatterns on PaginatedConversationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedConversationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedConversationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedConversationState value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedConversationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedConversationState value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedConversationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ConversationInfo> conversations,  int currentPage,  bool isLoading,  bool isLoadingMore,  bool hasMore,  int perPage,  int total,  bool isInitialized,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedConversationState() when $default != null:
return $default(_that.conversations,_that.currentPage,_that.isLoading,_that.isLoadingMore,_that.hasMore,_that.perPage,_that.total,_that.isInitialized,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ConversationInfo> conversations,  int currentPage,  bool isLoading,  bool isLoadingMore,  bool hasMore,  int perPage,  int total,  bool isInitialized,  String? error)  $default,) {final _that = this;
switch (_that) {
case _PaginatedConversationState():
return $default(_that.conversations,_that.currentPage,_that.isLoading,_that.isLoadingMore,_that.hasMore,_that.perPage,_that.total,_that.isInitialized,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ConversationInfo> conversations,  int currentPage,  bool isLoading,  bool isLoadingMore,  bool hasMore,  int perPage,  int total,  bool isInitialized,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedConversationState() when $default != null:
return $default(_that.conversations,_that.currentPage,_that.isLoading,_that.isLoadingMore,_that.hasMore,_that.perPage,_that.total,_that.isInitialized,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _PaginatedConversationState implements PaginatedConversationState {
  const _PaginatedConversationState({final  List<ConversationInfo> conversations = const [], this.currentPage = 1, this.isLoading = false, this.isLoadingMore = false, this.hasMore = true, this.perPage = 10, this.total = 0, this.isInitialized = false, this.error}): _conversations = conversations;


 final  List<ConversationInfo> _conversations;
@override@JsonKey() List<ConversationInfo> get conversations {
  if (_conversations is EqualUnmodifiableListView) return _conversations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conversations);
}

@override@JsonKey() final  int currentPage;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  int perPage;
@override@JsonKey() final  int total;
@override@JsonKey() final  bool isInitialized;
// Mark whether list has been initialized and loaded
@override final  String? error;

/// Create a copy of PaginatedConversationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedConversationStateCopyWith<_PaginatedConversationState> get copyWith => __$PaginatedConversationStateCopyWithImpl<_PaginatedConversationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedConversationState&&const DeepCollectionEquality().equals(other._conversations, _conversations)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total)&&(identical(other.isInitialized, isInitialized) || other.isInitialized == isInitialized)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_conversations),currentPage,isLoading,isLoadingMore,hasMore,perPage,total,isInitialized,error);

@override
String toString() {
  return 'PaginatedConversationState(conversations: $conversations, currentPage: $currentPage, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasMore: $hasMore, perPage: $perPage, total: $total, isInitialized: $isInitialized, error: $error)';
}


}

/// @nodoc
abstract mixin class _$PaginatedConversationStateCopyWith<$Res> implements $PaginatedConversationStateCopyWith<$Res> {
  factory _$PaginatedConversationStateCopyWith(_PaginatedConversationState value, $Res Function(_PaginatedConversationState) _then) = __$PaginatedConversationStateCopyWithImpl;
@override @useResult
$Res call({
 List<ConversationInfo> conversations, int currentPage, bool isLoading, bool isLoadingMore, bool hasMore, int perPage, int total, bool isInitialized, String? error
});




}
/// @nodoc
class __$PaginatedConversationStateCopyWithImpl<$Res>
    implements _$PaginatedConversationStateCopyWith<$Res> {
  __$PaginatedConversationStateCopyWithImpl(this._self, this._then);

  final _PaginatedConversationState _self;
  final $Res Function(_PaginatedConversationState) _then;

/// Create a copy of PaginatedConversationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conversations = null,Object? currentPage = null,Object? isLoading = null,Object? isLoadingMore = null,Object? hasMore = null,Object? perPage = null,Object? total = null,Object? isInitialized = null,Object? error = freezed,}) {
  return _then(_PaginatedConversationState(
conversations: null == conversations ? _self._conversations : conversations // ignore: cast_nullable_to_non_nullable
as List<ConversationInfo>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,isInitialized: null == isInitialized ? _self.isInitialized : isInitialized // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
