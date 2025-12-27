// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_view_currency_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountViewCurrencyState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountViewCurrencyState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountViewCurrencyState()';
}


}

/// @nodoc
class $AccountViewCurrencyStateCopyWith<$Res>  {
$AccountViewCurrencyStateCopyWith(AccountViewCurrencyState _, $Res Function(AccountViewCurrencyState) __);
}


/// Adds pattern-matching-related methods to [AccountViewCurrencyState].
extension AccountViewCurrencyStatePatterns on AccountViewCurrencyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AccountViewCurrencyGlobal value)?  global,TResult Function( AccountViewCurrencyTemporary value)?  temporary,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AccountViewCurrencyGlobal() when global != null:
return global(_that);case AccountViewCurrencyTemporary() when temporary != null:
return temporary(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AccountViewCurrencyGlobal value)  global,required TResult Function( AccountViewCurrencyTemporary value)  temporary,}){
final _that = this;
switch (_that) {
case AccountViewCurrencyGlobal():
return global(_that);case AccountViewCurrencyTemporary():
return temporary(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AccountViewCurrencyGlobal value)?  global,TResult? Function( AccountViewCurrencyTemporary value)?  temporary,}){
final _that = this;
switch (_that) {
case AccountViewCurrencyGlobal() when global != null:
return global(_that);case AccountViewCurrencyTemporary() when temporary != null:
return temporary(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  global,TResult Function( String currency)?  temporary,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AccountViewCurrencyGlobal() when global != null:
return global();case AccountViewCurrencyTemporary() when temporary != null:
return temporary(_that.currency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  global,required TResult Function( String currency)  temporary,}) {final _that = this;
switch (_that) {
case AccountViewCurrencyGlobal():
return global();case AccountViewCurrencyTemporary():
return temporary(_that.currency);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  global,TResult? Function( String currency)?  temporary,}) {final _that = this;
switch (_that) {
case AccountViewCurrencyGlobal() when global != null:
return global();case AccountViewCurrencyTemporary() when temporary != null:
return temporary(_that.currency);case _:
  return null;

}
}

}

/// @nodoc


class AccountViewCurrencyGlobal implements AccountViewCurrencyState {
  const AccountViewCurrencyGlobal();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountViewCurrencyGlobal);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountViewCurrencyState.global()';
}


}




/// @nodoc


class AccountViewCurrencyTemporary implements AccountViewCurrencyState {
  const AccountViewCurrencyTemporary(this.currency);
  

 final  String currency;

/// Create a copy of AccountViewCurrencyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountViewCurrencyTemporaryCopyWith<AccountViewCurrencyTemporary> get copyWith => _$AccountViewCurrencyTemporaryCopyWithImpl<AccountViewCurrencyTemporary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountViewCurrencyTemporary&&(identical(other.currency, currency) || other.currency == currency));
}


@override
int get hashCode => Object.hash(runtimeType,currency);

@override
String toString() {
  return 'AccountViewCurrencyState.temporary(currency: $currency)';
}


}

/// @nodoc
abstract mixin class $AccountViewCurrencyTemporaryCopyWith<$Res> implements $AccountViewCurrencyStateCopyWith<$Res> {
  factory $AccountViewCurrencyTemporaryCopyWith(AccountViewCurrencyTemporary value, $Res Function(AccountViewCurrencyTemporary) _then) = _$AccountViewCurrencyTemporaryCopyWithImpl;
@useResult
$Res call({
 String currency
});




}
/// @nodoc
class _$AccountViewCurrencyTemporaryCopyWithImpl<$Res>
    implements $AccountViewCurrencyTemporaryCopyWith<$Res> {
  _$AccountViewCurrencyTemporaryCopyWithImpl(this._self, this._then);

  final AccountViewCurrencyTemporary _self;
  final $Res Function(AccountViewCurrencyTemporary) _then;

/// Create a copy of AccountViewCurrencyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? currency = null,}) {
  return _then(AccountViewCurrencyTemporary(
null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
