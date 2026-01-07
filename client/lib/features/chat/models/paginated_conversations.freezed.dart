// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_conversations.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConversationMeta {

 int get currentPage; int get lastPage; int get perPage; int get total; bool get hasMore;
/// Create a copy of ConversationMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationMetaCopyWith<ConversationMeta> get copyWith => _$ConversationMetaCopyWithImpl<ConversationMeta>(this as ConversationMeta, _$identity);

  /// Serializes this ConversationMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationMeta&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,lastPage,perPage,total,hasMore);

@override
String toString() {
  return 'ConversationMeta(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $ConversationMetaCopyWith<$Res>  {
  factory $ConversationMetaCopyWith(ConversationMeta value, $Res Function(ConversationMeta) _then) = _$ConversationMetaCopyWithImpl;
@useResult
$Res call({
 int currentPage, int lastPage, int perPage, int total, bool hasMore
});




}
/// @nodoc
class _$ConversationMetaCopyWithImpl<$Res>
    implements $ConversationMetaCopyWith<$Res> {
  _$ConversationMetaCopyWithImpl(this._self, this._then);

  final ConversationMeta _self;
  final $Res Function(ConversationMeta) _then;

/// Create a copy of ConversationMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentPage = null,Object? lastPage = null,Object? perPage = null,Object? total = null,Object? hasMore = null,}) {
  return _then(_self.copyWith(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationMeta].
extension ConversationMetaPatterns on ConversationMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationMeta value)  $default,){
final _that = this;
switch (_that) {
case _ConversationMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationMeta value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentPage,  int lastPage,  int perPage,  int total,  bool hasMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationMeta() when $default != null:
return $default(_that.currentPage,_that.lastPage,_that.perPage,_that.total,_that.hasMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentPage,  int lastPage,  int perPage,  int total,  bool hasMore)  $default,) {final _that = this;
switch (_that) {
case _ConversationMeta():
return $default(_that.currentPage,_that.lastPage,_that.perPage,_that.total,_that.hasMore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentPage,  int lastPage,  int perPage,  int total,  bool hasMore)?  $default,) {final _that = this;
switch (_that) {
case _ConversationMeta() when $default != null:
return $default(_that.currentPage,_that.lastPage,_that.perPage,_that.total,_that.hasMore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationMeta implements ConversationMeta {
  const _ConversationMeta({required this.currentPage, required this.lastPage, required this.perPage, required this.total, required this.hasMore});
  factory _ConversationMeta.fromJson(Map<String, dynamic> json) => _$ConversationMetaFromJson(json);

@override final  int currentPage;
@override final  int lastPage;
@override final  int perPage;
@override final  int total;
@override final  bool hasMore;

/// Create a copy of ConversationMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationMetaCopyWith<_ConversationMeta> get copyWith => __$ConversationMetaCopyWithImpl<_ConversationMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationMetaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationMeta&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.total, total) || other.total == total)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,lastPage,perPage,total,hasMore);

@override
String toString() {
  return 'ConversationMeta(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$ConversationMetaCopyWith<$Res> implements $ConversationMetaCopyWith<$Res> {
  factory _$ConversationMetaCopyWith(_ConversationMeta value, $Res Function(_ConversationMeta) _then) = __$ConversationMetaCopyWithImpl;
@override @useResult
$Res call({
 int currentPage, int lastPage, int perPage, int total, bool hasMore
});




}
/// @nodoc
class __$ConversationMetaCopyWithImpl<$Res>
    implements _$ConversationMetaCopyWith<$Res> {
  __$ConversationMetaCopyWithImpl(this._self, this._then);

  final _ConversationMeta _self;
  final $Res Function(_ConversationMeta) _then;

/// Create a copy of ConversationMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPage = null,Object? lastPage = null,Object? perPage = null,Object? total = null,Object? hasMore = null,}) {
  return _then(_ConversationMeta(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PaginatedConversations {

 List<ConversationInfo> get data; ConversationMeta get meta;
/// Create a copy of PaginatedConversations
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedConversationsCopyWith<PaginatedConversations> get copyWith => _$PaginatedConversationsCopyWithImpl<PaginatedConversations>(this as PaginatedConversations, _$identity);

  /// Serializes this PaginatedConversations to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedConversations&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),meta);

@override
String toString() {
  return 'PaginatedConversations(data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $PaginatedConversationsCopyWith<$Res>  {
  factory $PaginatedConversationsCopyWith(PaginatedConversations value, $Res Function(PaginatedConversations) _then) = _$PaginatedConversationsCopyWithImpl;
@useResult
$Res call({
 List<ConversationInfo> data, ConversationMeta meta
});


$ConversationMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$PaginatedConversationsCopyWithImpl<$Res>
    implements $PaginatedConversationsCopyWith<$Res> {
  _$PaginatedConversationsCopyWithImpl(this._self, this._then);

  final PaginatedConversations _self;
  final $Res Function(PaginatedConversations) _then;

/// Create a copy of PaginatedConversations
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? meta = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<ConversationInfo>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ConversationMeta,
  ));
}
/// Create a copy of PaginatedConversations
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationMetaCopyWith<$Res> get meta {

  return $ConversationMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaginatedConversations].
extension PaginatedConversationsPatterns on PaginatedConversations {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedConversations value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedConversations() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedConversations value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedConversations():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedConversations value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedConversations() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ConversationInfo> data,  ConversationMeta meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedConversations() when $default != null:
return $default(_that.data,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ConversationInfo> data,  ConversationMeta meta)  $default,) {final _that = this;
switch (_that) {
case _PaginatedConversations():
return $default(_that.data,_that.meta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ConversationInfo> data,  ConversationMeta meta)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedConversations() when $default != null:
return $default(_that.data,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaginatedConversations implements PaginatedConversations {
  const _PaginatedConversations({required final  List<ConversationInfo> data, required this.meta}): _data = data;
  factory _PaginatedConversations.fromJson(Map<String, dynamic> json) => _$PaginatedConversationsFromJson(json);

 final  List<ConversationInfo> _data;
@override List<ConversationInfo> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  ConversationMeta meta;

/// Create a copy of PaginatedConversations
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedConversationsCopyWith<_PaginatedConversations> get copyWith => __$PaginatedConversationsCopyWithImpl<_PaginatedConversations>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaginatedConversationsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedConversations&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),meta);

@override
String toString() {
  return 'PaginatedConversations(data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$PaginatedConversationsCopyWith<$Res> implements $PaginatedConversationsCopyWith<$Res> {
  factory _$PaginatedConversationsCopyWith(_PaginatedConversations value, $Res Function(_PaginatedConversations) _then) = __$PaginatedConversationsCopyWithImpl;
@override @useResult
$Res call({
 List<ConversationInfo> data, ConversationMeta meta
});


@override $ConversationMetaCopyWith<$Res> get meta;

}
/// @nodoc
class __$PaginatedConversationsCopyWithImpl<$Res>
    implements _$PaginatedConversationsCopyWith<$Res> {
  __$PaginatedConversationsCopyWithImpl(this._self, this._then);

  final _PaginatedConversations _self;
  final $Res Function(_PaginatedConversations) _then;

/// Create a copy of PaginatedConversations
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? meta = null,}) {
  return _then(_PaginatedConversations(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<ConversationInfo>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ConversationMeta,
  ));
}

/// Create a copy of PaginatedConversations
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationMetaCopyWith<$Res> get meta {

  return $ConversationMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

// dart format on
