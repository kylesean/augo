// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_feed_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionFeedState {

 List<TransactionModel> get transactions; bool get isLoadingMore; bool get hasReachedMax; int get currentPage; String? get errorMessage;
/// Create a copy of TransactionFeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionFeedStateCopyWith<TransactionFeedState> get copyWith => _$TransactionFeedStateCopyWithImpl<TransactionFeedState>(this as TransactionFeedState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionFeedState&&const DeepCollectionEquality().equals(other.transactions, transactions)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(transactions),isLoadingMore,hasReachedMax,currentPage,errorMessage);

@override
String toString() {
  return 'TransactionFeedState(transactions: $transactions, isLoadingMore: $isLoadingMore, hasReachedMax: $hasReachedMax, currentPage: $currentPage, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $TransactionFeedStateCopyWith<$Res>  {
  factory $TransactionFeedStateCopyWith(TransactionFeedState value, $Res Function(TransactionFeedState) _then) = _$TransactionFeedStateCopyWithImpl;
@useResult
$Res call({
 List<TransactionModel> transactions, bool isLoadingMore, bool hasReachedMax, int currentPage, String? errorMessage
});




}
/// @nodoc
class _$TransactionFeedStateCopyWithImpl<$Res>
    implements $TransactionFeedStateCopyWith<$Res> {
  _$TransactionFeedStateCopyWithImpl(this._self, this._then);

  final TransactionFeedState _self;
  final $Res Function(TransactionFeedState) _then;

/// Create a copy of TransactionFeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transactions = null,Object? isLoadingMore = null,Object? hasReachedMax = null,Object? currentPage = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<TransactionModel>,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionFeedState].
extension TransactionFeedStatePatterns on TransactionFeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionFeedState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionFeedState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionFeedState value)  $default,){
final _that = this;
switch (_that) {
case _TransactionFeedState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionFeedState value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionFeedState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TransactionModel> transactions,  bool isLoadingMore,  bool hasReachedMax,  int currentPage,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionFeedState() when $default != null:
return $default(_that.transactions,_that.isLoadingMore,_that.hasReachedMax,_that.currentPage,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TransactionModel> transactions,  bool isLoadingMore,  bool hasReachedMax,  int currentPage,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _TransactionFeedState():
return $default(_that.transactions,_that.isLoadingMore,_that.hasReachedMax,_that.currentPage,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TransactionModel> transactions,  bool isLoadingMore,  bool hasReachedMax,  int currentPage,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _TransactionFeedState() when $default != null:
return $default(_that.transactions,_that.isLoadingMore,_that.hasReachedMax,_that.currentPage,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionFeedState implements TransactionFeedState {
  const _TransactionFeedState({final  List<TransactionModel> transactions = const [], this.isLoadingMore = false, this.hasReachedMax = false, this.currentPage = 1, this.errorMessage}): _transactions = transactions;


 final  List<TransactionModel> _transactions;
@override@JsonKey() List<TransactionModel> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool hasReachedMax;
@override@JsonKey() final  int currentPage;
@override final  String? errorMessage;

/// Create a copy of TransactionFeedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionFeedStateCopyWith<_TransactionFeedState> get copyWith => __$TransactionFeedStateCopyWithImpl<_TransactionFeedState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionFeedState&&const DeepCollectionEquality().equals(other._transactions, _transactions)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_transactions),isLoadingMore,hasReachedMax,currentPage,errorMessage);

@override
String toString() {
  return 'TransactionFeedState(transactions: $transactions, isLoadingMore: $isLoadingMore, hasReachedMax: $hasReachedMax, currentPage: $currentPage, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$TransactionFeedStateCopyWith<$Res> implements $TransactionFeedStateCopyWith<$Res> {
  factory _$TransactionFeedStateCopyWith(_TransactionFeedState value, $Res Function(_TransactionFeedState) _then) = __$TransactionFeedStateCopyWithImpl;
@override @useResult
$Res call({
 List<TransactionModel> transactions, bool isLoadingMore, bool hasReachedMax, int currentPage, String? errorMessage
});




}
/// @nodoc
class __$TransactionFeedStateCopyWithImpl<$Res>
    implements _$TransactionFeedStateCopyWith<$Res> {
  __$TransactionFeedStateCopyWithImpl(this._self, this._then);

  final _TransactionFeedState _self;
  final $Res Function(_TransactionFeedState) _then;

/// Create a copy of TransactionFeedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transactions = null,Object? isLoadingMore = null,Object? hasReachedMax = null,Object? currentPage = null,Object? errorMessage = freezed,}) {
  return _then(_TransactionFeedState(
transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<TransactionModel>,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
