// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConversationSearchResult {

 String get id; String get title; String get snippet;// Search matched content snippet
 String? get messageId;// Message ID
 DateTime? get createdAt;// Creation time
 DateTime? get updatedAt;// Update time
 List<HighlightRange> get highlights;
/// Create a copy of ConversationSearchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationSearchResultCopyWith<ConversationSearchResult> get copyWith => _$ConversationSearchResultCopyWithImpl<ConversationSearchResult>(this as ConversationSearchResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationSearchResult&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.snippet, snippet) || other.snippet == snippet)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.highlights, highlights));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,snippet,messageId,createdAt,updatedAt,const DeepCollectionEquality().hash(highlights));

@override
String toString() {
  return 'ConversationSearchResult(id: $id, title: $title, snippet: $snippet, messageId: $messageId, createdAt: $createdAt, updatedAt: $updatedAt, highlights: $highlights)';
}


}

/// @nodoc
abstract mixin class $ConversationSearchResultCopyWith<$Res>  {
  factory $ConversationSearchResultCopyWith(ConversationSearchResult value, $Res Function(ConversationSearchResult) _then) = _$ConversationSearchResultCopyWithImpl;
@useResult
$Res call({
 String id, String title, String snippet, String? messageId, DateTime? createdAt, DateTime? updatedAt, List<HighlightRange> highlights
});




}
/// @nodoc
class _$ConversationSearchResultCopyWithImpl<$Res>
    implements $ConversationSearchResultCopyWith<$Res> {
  _$ConversationSearchResultCopyWithImpl(this._self, this._then);

  final ConversationSearchResult _self;
  final $Res Function(ConversationSearchResult) _then;

/// Create a copy of ConversationSearchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? snippet = null,Object? messageId = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? highlights = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,snippet: null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as String,messageId: freezed == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,highlights: null == highlights ? _self.highlights : highlights // ignore: cast_nullable_to_non_nullable
as List<HighlightRange>,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationSearchResult].
extension ConversationSearchResultPatterns on ConversationSearchResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationSearchResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationSearchResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationSearchResult value)  $default,){
final _that = this;
switch (_that) {
case _ConversationSearchResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationSearchResult value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationSearchResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String snippet,  String? messageId,  DateTime? createdAt,  DateTime? updatedAt,  List<HighlightRange> highlights)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationSearchResult() when $default != null:
return $default(_that.id,_that.title,_that.snippet,_that.messageId,_that.createdAt,_that.updatedAt,_that.highlights);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String snippet,  String? messageId,  DateTime? createdAt,  DateTime? updatedAt,  List<HighlightRange> highlights)  $default,) {final _that = this;
switch (_that) {
case _ConversationSearchResult():
return $default(_that.id,_that.title,_that.snippet,_that.messageId,_that.createdAt,_that.updatedAt,_that.highlights);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String snippet,  String? messageId,  DateTime? createdAt,  DateTime? updatedAt,  List<HighlightRange> highlights)?  $default,) {final _that = this;
switch (_that) {
case _ConversationSearchResult() when $default != null:
return $default(_that.id,_that.title,_that.snippet,_that.messageId,_that.createdAt,_that.updatedAt,_that.highlights);case _:
  return null;

}
}

}

/// @nodoc


class _ConversationSearchResult implements ConversationSearchResult {
  const _ConversationSearchResult({required this.id, required this.title, required this.snippet, this.messageId, this.createdAt, this.updatedAt, final  List<HighlightRange> highlights = const []}): _highlights = highlights;
  

@override final  String id;
@override final  String title;
@override final  String snippet;
// Search matched content snippet
@override final  String? messageId;
// Message ID
@override final  DateTime? createdAt;
// Creation time
@override final  DateTime? updatedAt;
// Update time
 final  List<HighlightRange> _highlights;
// Update time
@override@JsonKey() List<HighlightRange> get highlights {
  if (_highlights is EqualUnmodifiableListView) return _highlights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_highlights);
}


/// Create a copy of ConversationSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationSearchResultCopyWith<_ConversationSearchResult> get copyWith => __$ConversationSearchResultCopyWithImpl<_ConversationSearchResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationSearchResult&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.snippet, snippet) || other.snippet == snippet)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._highlights, _highlights));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,snippet,messageId,createdAt,updatedAt,const DeepCollectionEquality().hash(_highlights));

@override
String toString() {
  return 'ConversationSearchResult(id: $id, title: $title, snippet: $snippet, messageId: $messageId, createdAt: $createdAt, updatedAt: $updatedAt, highlights: $highlights)';
}


}

/// @nodoc
abstract mixin class _$ConversationSearchResultCopyWith<$Res> implements $ConversationSearchResultCopyWith<$Res> {
  factory _$ConversationSearchResultCopyWith(_ConversationSearchResult value, $Res Function(_ConversationSearchResult) _then) = __$ConversationSearchResultCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String snippet, String? messageId, DateTime? createdAt, DateTime? updatedAt, List<HighlightRange> highlights
});




}
/// @nodoc
class __$ConversationSearchResultCopyWithImpl<$Res>
    implements _$ConversationSearchResultCopyWith<$Res> {
  __$ConversationSearchResultCopyWithImpl(this._self, this._then);

  final _ConversationSearchResult _self;
  final $Res Function(_ConversationSearchResult) _then;

/// Create a copy of ConversationSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? snippet = null,Object? messageId = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? highlights = null,}) {
  return _then(_ConversationSearchResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,snippet: null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as String,messageId: freezed == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,highlights: null == highlights ? _self._highlights : highlights // ignore: cast_nullable_to_non_nullable
as List<HighlightRange>,
  ));
}


}

/// @nodoc
mixin _$HighlightRange {

 int get start; int get end; String get field;
/// Create a copy of HighlightRange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HighlightRangeCopyWith<HighlightRange> get copyWith => _$HighlightRangeCopyWithImpl<HighlightRange>(this as HighlightRange, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HighlightRange&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.field, field) || other.field == field));
}


@override
int get hashCode => Object.hash(runtimeType,start,end,field);

@override
String toString() {
  return 'HighlightRange(start: $start, end: $end, field: $field)';
}


}

/// @nodoc
abstract mixin class $HighlightRangeCopyWith<$Res>  {
  factory $HighlightRangeCopyWith(HighlightRange value, $Res Function(HighlightRange) _then) = _$HighlightRangeCopyWithImpl;
@useResult
$Res call({
 int start, int end, String field
});




}
/// @nodoc
class _$HighlightRangeCopyWithImpl<$Res>
    implements $HighlightRangeCopyWith<$Res> {
  _$HighlightRangeCopyWithImpl(this._self, this._then);

  final HighlightRange _self;
  final $Res Function(HighlightRange) _then;

/// Create a copy of HighlightRange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = null,Object? field = null,}) {
  return _then(_self.copyWith(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as int,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as int,field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HighlightRange].
extension HighlightRangePatterns on HighlightRange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HighlightRange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HighlightRange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HighlightRange value)  $default,){
final _that = this;
switch (_that) {
case _HighlightRange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HighlightRange value)?  $default,){
final _that = this;
switch (_that) {
case _HighlightRange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int start,  int end,  String field)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HighlightRange() when $default != null:
return $default(_that.start,_that.end,_that.field);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int start,  int end,  String field)  $default,) {final _that = this;
switch (_that) {
case _HighlightRange():
return $default(_that.start,_that.end,_that.field);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int start,  int end,  String field)?  $default,) {final _that = this;
switch (_that) {
case _HighlightRange() when $default != null:
return $default(_that.start,_that.end,_that.field);case _:
  return null;

}
}

}

/// @nodoc


class _HighlightRange implements HighlightRange {
  const _HighlightRange({required this.start, required this.end, required this.field});
  

@override final  int start;
@override final  int end;
@override final  String field;

/// Create a copy of HighlightRange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HighlightRangeCopyWith<_HighlightRange> get copyWith => __$HighlightRangeCopyWithImpl<_HighlightRange>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HighlightRange&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.field, field) || other.field == field));
}


@override
int get hashCode => Object.hash(runtimeType,start,end,field);

@override
String toString() {
  return 'HighlightRange(start: $start, end: $end, field: $field)';
}


}

/// @nodoc
abstract mixin class _$HighlightRangeCopyWith<$Res> implements $HighlightRangeCopyWith<$Res> {
  factory _$HighlightRangeCopyWith(_HighlightRange value, $Res Function(_HighlightRange) _then) = __$HighlightRangeCopyWithImpl;
@override @useResult
$Res call({
 int start, int end, String field
});




}
/// @nodoc
class __$HighlightRangeCopyWithImpl<$Res>
    implements _$HighlightRangeCopyWith<$Res> {
  __$HighlightRangeCopyWithImpl(this._self, this._then);

  final _HighlightRange _self;
  final $Res Function(_HighlightRange) _then;

/// Create a copy of HighlightRange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,Object? field = null,}) {
  return _then(_HighlightRange(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as int,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as int,field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ConversationSearchState {

 SearchMode get mode; String get query; List<ConversationSearchResult> get results; bool get isLoading; String? get error; bool get hasSearched;// Whether a search has been performed
 bool get isFullscreen;
/// Create a copy of ConversationSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationSearchStateCopyWith<ConversationSearchState> get copyWith => _$ConversationSearchStateCopyWithImpl<ConversationSearchState>(this as ConversationSearchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationSearchState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error)&&(identical(other.hasSearched, hasSearched) || other.hasSearched == hasSearched)&&(identical(other.isFullscreen, isFullscreen) || other.isFullscreen == isFullscreen));
}


@override
int get hashCode => Object.hash(runtimeType,mode,query,const DeepCollectionEquality().hash(results),isLoading,error,hasSearched,isFullscreen);

@override
String toString() {
  return 'ConversationSearchState(mode: $mode, query: $query, results: $results, isLoading: $isLoading, error: $error, hasSearched: $hasSearched, isFullscreen: $isFullscreen)';
}


}

/// @nodoc
abstract mixin class $ConversationSearchStateCopyWith<$Res>  {
  factory $ConversationSearchStateCopyWith(ConversationSearchState value, $Res Function(ConversationSearchState) _then) = _$ConversationSearchStateCopyWithImpl;
@useResult
$Res call({
 SearchMode mode, String query, List<ConversationSearchResult> results, bool isLoading, String? error, bool hasSearched, bool isFullscreen
});




}
/// @nodoc
class _$ConversationSearchStateCopyWithImpl<$Res>
    implements $ConversationSearchStateCopyWith<$Res> {
  _$ConversationSearchStateCopyWithImpl(this._self, this._then);

  final ConversationSearchState _self;
  final $Res Function(ConversationSearchState) _then;

/// Create a copy of ConversationSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? query = null,Object? results = null,Object? isLoading = null,Object? error = freezed,Object? hasSearched = null,Object? isFullscreen = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SearchMode,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<ConversationSearchResult>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,hasSearched: null == hasSearched ? _self.hasSearched : hasSearched // ignore: cast_nullable_to_non_nullable
as bool,isFullscreen: null == isFullscreen ? _self.isFullscreen : isFullscreen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationSearchState].
extension ConversationSearchStatePatterns on ConversationSearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationSearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationSearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationSearchState value)  $default,){
final _that = this;
switch (_that) {
case _ConversationSearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationSearchState value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationSearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SearchMode mode,  String query,  List<ConversationSearchResult> results,  bool isLoading,  String? error,  bool hasSearched,  bool isFullscreen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationSearchState() when $default != null:
return $default(_that.mode,_that.query,_that.results,_that.isLoading,_that.error,_that.hasSearched,_that.isFullscreen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SearchMode mode,  String query,  List<ConversationSearchResult> results,  bool isLoading,  String? error,  bool hasSearched,  bool isFullscreen)  $default,) {final _that = this;
switch (_that) {
case _ConversationSearchState():
return $default(_that.mode,_that.query,_that.results,_that.isLoading,_that.error,_that.hasSearched,_that.isFullscreen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SearchMode mode,  String query,  List<ConversationSearchResult> results,  bool isLoading,  String? error,  bool hasSearched,  bool isFullscreen)?  $default,) {final _that = this;
switch (_that) {
case _ConversationSearchState() when $default != null:
return $default(_that.mode,_that.query,_that.results,_that.isLoading,_that.error,_that.hasSearched,_that.isFullscreen);case _:
  return null;

}
}

}

/// @nodoc


class _ConversationSearchState implements ConversationSearchState {
  const _ConversationSearchState({this.mode = SearchMode.normal, this.query = '', final  List<ConversationSearchResult> results = const [], this.isLoading = false, this.error, this.hasSearched = false, this.isFullscreen = false}): _results = results;
  

@override@JsonKey() final  SearchMode mode;
@override@JsonKey() final  String query;
 final  List<ConversationSearchResult> _results;
@override@JsonKey() List<ConversationSearchResult> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@JsonKey() final  bool isLoading;
@override final  String? error;
@override@JsonKey() final  bool hasSearched;
// Whether a search has been performed
@override@JsonKey() final  bool isFullscreen;

/// Create a copy of ConversationSearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationSearchStateCopyWith<_ConversationSearchState> get copyWith => __$ConversationSearchStateCopyWithImpl<_ConversationSearchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationSearchState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error)&&(identical(other.hasSearched, hasSearched) || other.hasSearched == hasSearched)&&(identical(other.isFullscreen, isFullscreen) || other.isFullscreen == isFullscreen));
}


@override
int get hashCode => Object.hash(runtimeType,mode,query,const DeepCollectionEquality().hash(_results),isLoading,error,hasSearched,isFullscreen);

@override
String toString() {
  return 'ConversationSearchState(mode: $mode, query: $query, results: $results, isLoading: $isLoading, error: $error, hasSearched: $hasSearched, isFullscreen: $isFullscreen)';
}


}

/// @nodoc
abstract mixin class _$ConversationSearchStateCopyWith<$Res> implements $ConversationSearchStateCopyWith<$Res> {
  factory _$ConversationSearchStateCopyWith(_ConversationSearchState value, $Res Function(_ConversationSearchState) _then) = __$ConversationSearchStateCopyWithImpl;
@override @useResult
$Res call({
 SearchMode mode, String query, List<ConversationSearchResult> results, bool isLoading, String? error, bool hasSearched, bool isFullscreen
});




}
/// @nodoc
class __$ConversationSearchStateCopyWithImpl<$Res>
    implements _$ConversationSearchStateCopyWith<$Res> {
  __$ConversationSearchStateCopyWithImpl(this._self, this._then);

  final _ConversationSearchState _self;
  final $Res Function(_ConversationSearchState) _then;

/// Create a copy of ConversationSearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? query = null,Object? results = null,Object? isLoading = null,Object? error = freezed,Object? hasSearched = null,Object? isFullscreen = null,}) {
  return _then(_ConversationSearchState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SearchMode,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<ConversationSearchResult>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,hasSearched: null == hasSearched ? _self.hasSearched : hasSearched // ignore: cast_nullable_to_non_nullable
as bool,isFullscreen: null == isFullscreen ? _self.isFullscreen : isFullscreen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
