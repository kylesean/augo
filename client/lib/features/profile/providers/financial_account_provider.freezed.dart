// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_account_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FinancialAccountState {

 List<FinancialAccount> get accounts; Decimal? get totalBalance; DateTime? get lastUpdatedAt; bool get isLoading; String? get error;
/// Create a copy of FinancialAccountState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialAccountStateCopyWith<FinancialAccountState> get copyWith => _$FinancialAccountStateCopyWithImpl<FinancialAccountState>(this as FinancialAccountState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialAccountState&&const DeepCollectionEquality().equals(other.accounts, accounts)&&(identical(other.totalBalance, totalBalance) || other.totalBalance == totalBalance)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(accounts),totalBalance,lastUpdatedAt,isLoading,error);

@override
String toString() {
  return 'FinancialAccountState(accounts: $accounts, totalBalance: $totalBalance, lastUpdatedAt: $lastUpdatedAt, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class $FinancialAccountStateCopyWith<$Res>  {
  factory $FinancialAccountStateCopyWith(FinancialAccountState value, $Res Function(FinancialAccountState) _then) = _$FinancialAccountStateCopyWithImpl;
@useResult
$Res call({
 List<FinancialAccount> accounts, Decimal? totalBalance, DateTime? lastUpdatedAt, bool isLoading, String? error
});




}
/// @nodoc
class _$FinancialAccountStateCopyWithImpl<$Res>
    implements $FinancialAccountStateCopyWith<$Res> {
  _$FinancialAccountStateCopyWithImpl(this._self, this._then);

  final FinancialAccountState _self;
  final $Res Function(FinancialAccountState) _then;

/// Create a copy of FinancialAccountState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accounts = null,Object? totalBalance = freezed,Object? lastUpdatedAt = freezed,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
accounts: null == accounts ? _self.accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<FinancialAccount>,totalBalance: freezed == totalBalance ? _self.totalBalance : totalBalance // ignore: cast_nullable_to_non_nullable
as Decimal?,lastUpdatedAt: freezed == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialAccountState].
extension FinancialAccountStatePatterns on FinancialAccountState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialAccountState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialAccountState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialAccountState value)  $default,){
final _that = this;
switch (_that) {
case _FinancialAccountState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialAccountState value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialAccountState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<FinancialAccount> accounts,  Decimal? totalBalance,  DateTime? lastUpdatedAt,  bool isLoading,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialAccountState() when $default != null:
return $default(_that.accounts,_that.totalBalance,_that.lastUpdatedAt,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<FinancialAccount> accounts,  Decimal? totalBalance,  DateTime? lastUpdatedAt,  bool isLoading,  String? error)  $default,) {final _that = this;
switch (_that) {
case _FinancialAccountState():
return $default(_that.accounts,_that.totalBalance,_that.lastUpdatedAt,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<FinancialAccount> accounts,  Decimal? totalBalance,  DateTime? lastUpdatedAt,  bool isLoading,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _FinancialAccountState() when $default != null:
return $default(_that.accounts,_that.totalBalance,_that.lastUpdatedAt,_that.isLoading,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _FinancialAccountState extends FinancialAccountState {
  const _FinancialAccountState({final  List<FinancialAccount> accounts = const [], this.totalBalance, this.lastUpdatedAt, this.isLoading = false, this.error}): _accounts = accounts,super._();
  

 final  List<FinancialAccount> _accounts;
@override@JsonKey() List<FinancialAccount> get accounts {
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accounts);
}

@override final  Decimal? totalBalance;
@override final  DateTime? lastUpdatedAt;
@override@JsonKey() final  bool isLoading;
@override final  String? error;

/// Create a copy of FinancialAccountState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialAccountStateCopyWith<_FinancialAccountState> get copyWith => __$FinancialAccountStateCopyWithImpl<_FinancialAccountState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialAccountState&&const DeepCollectionEquality().equals(other._accounts, _accounts)&&(identical(other.totalBalance, totalBalance) || other.totalBalance == totalBalance)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_accounts),totalBalance,lastUpdatedAt,isLoading,error);

@override
String toString() {
  return 'FinancialAccountState(accounts: $accounts, totalBalance: $totalBalance, lastUpdatedAt: $lastUpdatedAt, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class _$FinancialAccountStateCopyWith<$Res> implements $FinancialAccountStateCopyWith<$Res> {
  factory _$FinancialAccountStateCopyWith(_FinancialAccountState value, $Res Function(_FinancialAccountState) _then) = __$FinancialAccountStateCopyWithImpl;
@override @useResult
$Res call({
 List<FinancialAccount> accounts, Decimal? totalBalance, DateTime? lastUpdatedAt, bool isLoading, String? error
});




}
/// @nodoc
class __$FinancialAccountStateCopyWithImpl<$Res>
    implements _$FinancialAccountStateCopyWith<$Res> {
  __$FinancialAccountStateCopyWithImpl(this._self, this._then);

  final _FinancialAccountState _self;
  final $Res Function(_FinancialAccountState) _then;

/// Create a copy of FinancialAccountState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accounts = null,Object? totalBalance = freezed,Object? lastUpdatedAt = freezed,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_FinancialAccountState(
accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<FinancialAccount>,totalBalance: freezed == totalBalance ? _self.totalBalance : totalBalance // ignore: cast_nullable_to_non_nullable
as Decimal?,lastUpdatedAt: freezed == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
