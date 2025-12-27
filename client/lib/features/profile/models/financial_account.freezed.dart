// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountDisplay {

 String get sign; String get value; String get valueFormatted; String get currencySymbol; String get fullString;
/// Create a copy of AccountDisplay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountDisplayCopyWith<AccountDisplay> get copyWith => _$AccountDisplayCopyWithImpl<AccountDisplay>(this as AccountDisplay, _$identity);

  /// Serializes this AccountDisplay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountDisplay&&(identical(other.sign, sign) || other.sign == sign)&&(identical(other.value, value) || other.value == value)&&(identical(other.valueFormatted, valueFormatted) || other.valueFormatted == valueFormatted)&&(identical(other.currencySymbol, currencySymbol) || other.currencySymbol == currencySymbol)&&(identical(other.fullString, fullString) || other.fullString == fullString));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sign,value,valueFormatted,currencySymbol,fullString);

@override
String toString() {
  return 'AccountDisplay(sign: $sign, value: $value, valueFormatted: $valueFormatted, currencySymbol: $currencySymbol, fullString: $fullString)';
}


}

/// @nodoc
abstract mixin class $AccountDisplayCopyWith<$Res>  {
  factory $AccountDisplayCopyWith(AccountDisplay value, $Res Function(AccountDisplay) _then) = _$AccountDisplayCopyWithImpl;
@useResult
$Res call({
 String sign, String value, String valueFormatted, String currencySymbol, String fullString
});




}
/// @nodoc
class _$AccountDisplayCopyWithImpl<$Res>
    implements $AccountDisplayCopyWith<$Res> {
  _$AccountDisplayCopyWithImpl(this._self, this._then);

  final AccountDisplay _self;
  final $Res Function(AccountDisplay) _then;

/// Create a copy of AccountDisplay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sign = null,Object? value = null,Object? valueFormatted = null,Object? currencySymbol = null,Object? fullString = null,}) {
  return _then(_self.copyWith(
sign: null == sign ? _self.sign : sign // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,valueFormatted: null == valueFormatted ? _self.valueFormatted : valueFormatted // ignore: cast_nullable_to_non_nullable
as String,currencySymbol: null == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String,fullString: null == fullString ? _self.fullString : fullString // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountDisplay].
extension AccountDisplayPatterns on AccountDisplay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountDisplay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountDisplay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountDisplay value)  $default,){
final _that = this;
switch (_that) {
case _AccountDisplay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountDisplay value)?  $default,){
final _that = this;
switch (_that) {
case _AccountDisplay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sign,  String value,  String valueFormatted,  String currencySymbol,  String fullString)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountDisplay() when $default != null:
return $default(_that.sign,_that.value,_that.valueFormatted,_that.currencySymbol,_that.fullString);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sign,  String value,  String valueFormatted,  String currencySymbol,  String fullString)  $default,) {final _that = this;
switch (_that) {
case _AccountDisplay():
return $default(_that.sign,_that.value,_that.valueFormatted,_that.currencySymbol,_that.fullString);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sign,  String value,  String valueFormatted,  String currencySymbol,  String fullString)?  $default,) {final _that = this;
switch (_that) {
case _AccountDisplay() when $default != null:
return $default(_that.sign,_that.value,_that.valueFormatted,_that.currencySymbol,_that.fullString);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountDisplay implements AccountDisplay {
  const _AccountDisplay({required this.sign, required this.value, required this.valueFormatted, required this.currencySymbol, required this.fullString});
  factory _AccountDisplay.fromJson(Map<String, dynamic> json) => _$AccountDisplayFromJson(json);

@override final  String sign;
@override final  String value;
@override final  String valueFormatted;
@override final  String currencySymbol;
@override final  String fullString;

/// Create a copy of AccountDisplay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountDisplayCopyWith<_AccountDisplay> get copyWith => __$AccountDisplayCopyWithImpl<_AccountDisplay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountDisplayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountDisplay&&(identical(other.sign, sign) || other.sign == sign)&&(identical(other.value, value) || other.value == value)&&(identical(other.valueFormatted, valueFormatted) || other.valueFormatted == valueFormatted)&&(identical(other.currencySymbol, currencySymbol) || other.currencySymbol == currencySymbol)&&(identical(other.fullString, fullString) || other.fullString == fullString));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sign,value,valueFormatted,currencySymbol,fullString);

@override
String toString() {
  return 'AccountDisplay(sign: $sign, value: $value, valueFormatted: $valueFormatted, currencySymbol: $currencySymbol, fullString: $fullString)';
}


}

/// @nodoc
abstract mixin class _$AccountDisplayCopyWith<$Res> implements $AccountDisplayCopyWith<$Res> {
  factory _$AccountDisplayCopyWith(_AccountDisplay value, $Res Function(_AccountDisplay) _then) = __$AccountDisplayCopyWithImpl;
@override @useResult
$Res call({
 String sign, String value, String valueFormatted, String currencySymbol, String fullString
});




}
/// @nodoc
class __$AccountDisplayCopyWithImpl<$Res>
    implements _$AccountDisplayCopyWith<$Res> {
  __$AccountDisplayCopyWithImpl(this._self, this._then);

  final _AccountDisplay _self;
  final $Res Function(_AccountDisplay) _then;

/// Create a copy of AccountDisplay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sign = null,Object? value = null,Object? valueFormatted = null,Object? currencySymbol = null,Object? fullString = null,}) {
  return _then(_AccountDisplay(
sign: null == sign ? _self.sign : sign // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,valueFormatted: null == valueFormatted ? _self.valueFormatted : valueFormatted // ignore: cast_nullable_to_non_nullable
as String,currencySymbol: null == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String,fullString: null == fullString ? _self.fullString : fullString // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$FinancialAccount {

/// Account ID (UUID from backend)
 String? get id;/// Account name
 String get name;/// Account nature: ASSET or LIABILITY
 FinancialNature get nature;/// Account type: CASH, DEPOSIT, E_MONEY etc.
 FinancialAccountType? get type;/// Currency code (Default: CNY)
 String get currencyCode;/// Initial balance
@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson) Decimal get initialBalance;/// Current balance
@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonOrZero) Decimal? get currentBalance;/// Whether to include in net worth
 bool get includeInNetWorth;/// Whether to include in daily cash flow forecast (Liquidity tag)
 bool get includeInCashFlow;/// Display info (optional, used for cross-currency summary display)
 AccountDisplay? get display;/// Account status
 AccountStatus get status;/// Creation time (ISO 8601 string)
 String? get createdAt;/// Update time (ISO 8601 string)
 String? get updatedAt;
/// Create a copy of FinancialAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialAccountCopyWith<FinancialAccount> get copyWith => _$FinancialAccountCopyWithImpl<FinancialAccount>(this as FinancialAccount, _$identity);

  /// Serializes this FinancialAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nature, nature) || other.nature == nature)&&(identical(other.type, type) || other.type == type)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.initialBalance, initialBalance) || other.initialBalance == initialBalance)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance)&&(identical(other.includeInNetWorth, includeInNetWorth) || other.includeInNetWorth == includeInNetWorth)&&(identical(other.includeInCashFlow, includeInCashFlow) || other.includeInCashFlow == includeInCashFlow)&&(identical(other.display, display) || other.display == display)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nature,type,currencyCode,initialBalance,currentBalance,includeInNetWorth,includeInCashFlow,display,status,createdAt,updatedAt);

@override
String toString() {
  return 'FinancialAccount(id: $id, name: $name, nature: $nature, type: $type, currencyCode: $currencyCode, initialBalance: $initialBalance, currentBalance: $currentBalance, includeInNetWorth: $includeInNetWorth, includeInCashFlow: $includeInCashFlow, display: $display, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $FinancialAccountCopyWith<$Res>  {
  factory $FinancialAccountCopyWith(FinancialAccount value, $Res Function(FinancialAccount) _then) = _$FinancialAccountCopyWithImpl;
@useResult
$Res call({
 String? id, String name, FinancialNature nature, FinancialAccountType? type, String currencyCode,@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson) Decimal initialBalance,@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonOrZero) Decimal? currentBalance, bool includeInNetWorth, bool includeInCashFlow, AccountDisplay? display, AccountStatus status, String? createdAt, String? updatedAt
});


$AccountDisplayCopyWith<$Res>? get display;

}
/// @nodoc
class _$FinancialAccountCopyWithImpl<$Res>
    implements $FinancialAccountCopyWith<$Res> {
  _$FinancialAccountCopyWithImpl(this._self, this._then);

  final FinancialAccount _self;
  final $Res Function(FinancialAccount) _then;

/// Create a copy of FinancialAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? nature = null,Object? type = freezed,Object? currencyCode = null,Object? initialBalance = null,Object? currentBalance = freezed,Object? includeInNetWorth = null,Object? includeInCashFlow = null,Object? display = freezed,Object? status = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nature: null == nature ? _self.nature : nature // ignore: cast_nullable_to_non_nullable
as FinancialNature,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FinancialAccountType?,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,initialBalance: null == initialBalance ? _self.initialBalance : initialBalance // ignore: cast_nullable_to_non_nullable
as Decimal,currentBalance: freezed == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as Decimal?,includeInNetWorth: null == includeInNetWorth ? _self.includeInNetWorth : includeInNetWorth // ignore: cast_nullable_to_non_nullable
as bool,includeInCashFlow: null == includeInCashFlow ? _self.includeInCashFlow : includeInCashFlow // ignore: cast_nullable_to_non_nullable
as bool,display: freezed == display ? _self.display : display // ignore: cast_nullable_to_non_nullable
as AccountDisplay?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of FinancialAccount
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountDisplayCopyWith<$Res>? get display {
    if (_self.display == null) {
    return null;
  }

  return $AccountDisplayCopyWith<$Res>(_self.display!, (value) {
    return _then(_self.copyWith(display: value));
  });
}
}


/// Adds pattern-matching-related methods to [FinancialAccount].
extension FinancialAccountPatterns on FinancialAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialAccount value)  $default,){
final _that = this;
switch (_that) {
case _FinancialAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialAccount value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String name,  FinancialNature nature,  FinancialAccountType? type,  String currencyCode, @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)  Decimal initialBalance, @JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonOrZero)  Decimal? currentBalance,  bool includeInNetWorth,  bool includeInCashFlow,  AccountDisplay? display,  AccountStatus status,  String? createdAt,  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialAccount() when $default != null:
return $default(_that.id,_that.name,_that.nature,_that.type,_that.currencyCode,_that.initialBalance,_that.currentBalance,_that.includeInNetWorth,_that.includeInCashFlow,_that.display,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String name,  FinancialNature nature,  FinancialAccountType? type,  String currencyCode, @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)  Decimal initialBalance, @JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonOrZero)  Decimal? currentBalance,  bool includeInNetWorth,  bool includeInCashFlow,  AccountDisplay? display,  AccountStatus status,  String? createdAt,  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FinancialAccount():
return $default(_that.id,_that.name,_that.nature,_that.type,_that.currencyCode,_that.initialBalance,_that.currentBalance,_that.includeInNetWorth,_that.includeInCashFlow,_that.display,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String name,  FinancialNature nature,  FinancialAccountType? type,  String currencyCode, @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)  Decimal initialBalance, @JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonOrZero)  Decimal? currentBalance,  bool includeInNetWorth,  bool includeInCashFlow,  AccountDisplay? display,  AccountStatus status,  String? createdAt,  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FinancialAccount() when $default != null:
return $default(_that.id,_that.name,_that.nature,_that.type,_that.currencyCode,_that.initialBalance,_that.currentBalance,_that.includeInNetWorth,_that.includeInCashFlow,_that.display,_that.status,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinancialAccount implements FinancialAccount {
  const _FinancialAccount({this.id, required this.name, required this.nature, this.type, this.currencyCode = 'CNY', @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson) required this.initialBalance, @JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonOrZero) this.currentBalance, this.includeInNetWorth = true, this.includeInCashFlow = false, this.display, this.status = AccountStatus.active, this.createdAt, this.updatedAt});
  factory _FinancialAccount.fromJson(Map<String, dynamic> json) => _$FinancialAccountFromJson(json);

/// Account ID (UUID from backend)
@override final  String? id;
/// Account name
@override final  String name;
/// Account nature: ASSET or LIABILITY
@override final  FinancialNature nature;
/// Account type: CASH, DEPOSIT, E_MONEY etc.
@override final  FinancialAccountType? type;
/// Currency code (Default: CNY)
@override@JsonKey() final  String currencyCode;
/// Initial balance
@override@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson) final  Decimal initialBalance;
/// Current balance
@override@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonOrZero) final  Decimal? currentBalance;
/// Whether to include in net worth
@override@JsonKey() final  bool includeInNetWorth;
/// Whether to include in daily cash flow forecast (Liquidity tag)
@override@JsonKey() final  bool includeInCashFlow;
/// Display info (optional, used for cross-currency summary display)
@override final  AccountDisplay? display;
/// Account status
@override@JsonKey() final  AccountStatus status;
/// Creation time (ISO 8601 string)
@override final  String? createdAt;
/// Update time (ISO 8601 string)
@override final  String? updatedAt;

/// Create a copy of FinancialAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialAccountCopyWith<_FinancialAccount> get copyWith => __$FinancialAccountCopyWithImpl<_FinancialAccount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinancialAccountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nature, nature) || other.nature == nature)&&(identical(other.type, type) || other.type == type)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.initialBalance, initialBalance) || other.initialBalance == initialBalance)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance)&&(identical(other.includeInNetWorth, includeInNetWorth) || other.includeInNetWorth == includeInNetWorth)&&(identical(other.includeInCashFlow, includeInCashFlow) || other.includeInCashFlow == includeInCashFlow)&&(identical(other.display, display) || other.display == display)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nature,type,currencyCode,initialBalance,currentBalance,includeInNetWorth,includeInCashFlow,display,status,createdAt,updatedAt);

@override
String toString() {
  return 'FinancialAccount(id: $id, name: $name, nature: $nature, type: $type, currencyCode: $currencyCode, initialBalance: $initialBalance, currentBalance: $currentBalance, includeInNetWorth: $includeInNetWorth, includeInCashFlow: $includeInCashFlow, display: $display, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FinancialAccountCopyWith<$Res> implements $FinancialAccountCopyWith<$Res> {
  factory _$FinancialAccountCopyWith(_FinancialAccount value, $Res Function(_FinancialAccount) _then) = __$FinancialAccountCopyWithImpl;
@override @useResult
$Res call({
 String? id, String name, FinancialNature nature, FinancialAccountType? type, String currencyCode,@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson) Decimal initialBalance,@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonOrZero) Decimal? currentBalance, bool includeInNetWorth, bool includeInCashFlow, AccountDisplay? display, AccountStatus status, String? createdAt, String? updatedAt
});


@override $AccountDisplayCopyWith<$Res>? get display;

}
/// @nodoc
class __$FinancialAccountCopyWithImpl<$Res>
    implements _$FinancialAccountCopyWith<$Res> {
  __$FinancialAccountCopyWithImpl(this._self, this._then);

  final _FinancialAccount _self;
  final $Res Function(_FinancialAccount) _then;

/// Create a copy of FinancialAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? nature = null,Object? type = freezed,Object? currencyCode = null,Object? initialBalance = null,Object? currentBalance = freezed,Object? includeInNetWorth = null,Object? includeInCashFlow = null,Object? display = freezed,Object? status = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_FinancialAccount(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nature: null == nature ? _self.nature : nature // ignore: cast_nullable_to_non_nullable
as FinancialNature,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FinancialAccountType?,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,initialBalance: null == initialBalance ? _self.initialBalance : initialBalance // ignore: cast_nullable_to_non_nullable
as Decimal,currentBalance: freezed == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as Decimal?,includeInNetWorth: null == includeInNetWorth ? _self.includeInNetWorth : includeInNetWorth // ignore: cast_nullable_to_non_nullable
as bool,includeInCashFlow: null == includeInCashFlow ? _self.includeInCashFlow : includeInCashFlow // ignore: cast_nullable_to_non_nullable
as bool,display: freezed == display ? _self.display : display // ignore: cast_nullable_to_non_nullable
as AccountDisplay?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of FinancialAccount
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountDisplayCopyWith<$Res>? get display {
    if (_self.display == null) {
    return null;
  }

  return $AccountDisplayCopyWith<$Res>(_self.display!, (value) {
    return _then(_self.copyWith(display: value));
  });
}
}


/// @nodoc
mixin _$FinancialAccountSummary {

@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson) Decimal get totalBalance; DateTime get lastUpdatedAt;
/// Create a copy of FinancialAccountSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialAccountSummaryCopyWith<FinancialAccountSummary> get copyWith => _$FinancialAccountSummaryCopyWithImpl<FinancialAccountSummary>(this as FinancialAccountSummary, _$identity);

  /// Serializes this FinancialAccountSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialAccountSummary&&(identical(other.totalBalance, totalBalance) || other.totalBalance == totalBalance)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalBalance,lastUpdatedAt);

@override
String toString() {
  return 'FinancialAccountSummary(totalBalance: $totalBalance, lastUpdatedAt: $lastUpdatedAt)';
}


}

/// @nodoc
abstract mixin class $FinancialAccountSummaryCopyWith<$Res>  {
  factory $FinancialAccountSummaryCopyWith(FinancialAccountSummary value, $Res Function(FinancialAccountSummary) _then) = _$FinancialAccountSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson) Decimal totalBalance, DateTime lastUpdatedAt
});




}
/// @nodoc
class _$FinancialAccountSummaryCopyWithImpl<$Res>
    implements $FinancialAccountSummaryCopyWith<$Res> {
  _$FinancialAccountSummaryCopyWithImpl(this._self, this._then);

  final FinancialAccountSummary _self;
  final $Res Function(FinancialAccountSummary) _then;

/// Create a copy of FinancialAccountSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalBalance = null,Object? lastUpdatedAt = null,}) {
  return _then(_self.copyWith(
totalBalance: null == totalBalance ? _self.totalBalance : totalBalance // ignore: cast_nullable_to_non_nullable
as Decimal,lastUpdatedAt: null == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialAccountSummary].
extension FinancialAccountSummaryPatterns on FinancialAccountSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialAccountSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialAccountSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialAccountSummary value)  $default,){
final _that = this;
switch (_that) {
case _FinancialAccountSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialAccountSummary value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialAccountSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)  Decimal totalBalance,  DateTime lastUpdatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialAccountSummary() when $default != null:
return $default(_that.totalBalance,_that.lastUpdatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)  Decimal totalBalance,  DateTime lastUpdatedAt)  $default,) {final _that = this;
switch (_that) {
case _FinancialAccountSummary():
return $default(_that.totalBalance,_that.lastUpdatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)  Decimal totalBalance,  DateTime lastUpdatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FinancialAccountSummary() when $default != null:
return $default(_that.totalBalance,_that.lastUpdatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinancialAccountSummary implements FinancialAccountSummary {
  const _FinancialAccountSummary({@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson) required this.totalBalance, required this.lastUpdatedAt});
  factory _FinancialAccountSummary.fromJson(Map<String, dynamic> json) => _$FinancialAccountSummaryFromJson(json);

@override@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson) final  Decimal totalBalance;
@override final  DateTime lastUpdatedAt;

/// Create a copy of FinancialAccountSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialAccountSummaryCopyWith<_FinancialAccountSummary> get copyWith => __$FinancialAccountSummaryCopyWithImpl<_FinancialAccountSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinancialAccountSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialAccountSummary&&(identical(other.totalBalance, totalBalance) || other.totalBalance == totalBalance)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalBalance,lastUpdatedAt);

@override
String toString() {
  return 'FinancialAccountSummary(totalBalance: $totalBalance, lastUpdatedAt: $lastUpdatedAt)';
}


}

/// @nodoc
abstract mixin class _$FinancialAccountSummaryCopyWith<$Res> implements $FinancialAccountSummaryCopyWith<$Res> {
  factory _$FinancialAccountSummaryCopyWith(_FinancialAccountSummary value, $Res Function(_FinancialAccountSummary) _then) = __$FinancialAccountSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson) Decimal totalBalance, DateTime lastUpdatedAt
});




}
/// @nodoc
class __$FinancialAccountSummaryCopyWithImpl<$Res>
    implements _$FinancialAccountSummaryCopyWith<$Res> {
  __$FinancialAccountSummaryCopyWithImpl(this._self, this._then);

  final _FinancialAccountSummary _self;
  final $Res Function(_FinancialAccountSummary) _then;

/// Create a copy of FinancialAccountSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalBalance = null,Object? lastUpdatedAt = null,}) {
  return _then(_FinancialAccountSummary(
totalBalance: null == totalBalance ? _self.totalBalance : totalBalance // ignore: cast_nullable_to_non_nullable
as Decimal,lastUpdatedAt: null == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$FinancialAccountResponse {

 List<FinancialAccount> get accounts;@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJson) Decimal get totalBalance; String get lastUpdatedAt;
/// Create a copy of FinancialAccountResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialAccountResponseCopyWith<FinancialAccountResponse> get copyWith => _$FinancialAccountResponseCopyWithImpl<FinancialAccountResponse>(this as FinancialAccountResponse, _$identity);

  /// Serializes this FinancialAccountResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialAccountResponse&&const DeepCollectionEquality().equals(other.accounts, accounts)&&(identical(other.totalBalance, totalBalance) || other.totalBalance == totalBalance)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(accounts),totalBalance,lastUpdatedAt);

@override
String toString() {
  return 'FinancialAccountResponse(accounts: $accounts, totalBalance: $totalBalance, lastUpdatedAt: $lastUpdatedAt)';
}


}

/// @nodoc
abstract mixin class $FinancialAccountResponseCopyWith<$Res>  {
  factory $FinancialAccountResponseCopyWith(FinancialAccountResponse value, $Res Function(FinancialAccountResponse) _then) = _$FinancialAccountResponseCopyWithImpl;
@useResult
$Res call({
 List<FinancialAccount> accounts,@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJson) Decimal totalBalance, String lastUpdatedAt
});




}
/// @nodoc
class _$FinancialAccountResponseCopyWithImpl<$Res>
    implements $FinancialAccountResponseCopyWith<$Res> {
  _$FinancialAccountResponseCopyWithImpl(this._self, this._then);

  final FinancialAccountResponse _self;
  final $Res Function(FinancialAccountResponse) _then;

/// Create a copy of FinancialAccountResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accounts = null,Object? totalBalance = null,Object? lastUpdatedAt = null,}) {
  return _then(_self.copyWith(
accounts: null == accounts ? _self.accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<FinancialAccount>,totalBalance: null == totalBalance ? _self.totalBalance : totalBalance // ignore: cast_nullable_to_non_nullable
as Decimal,lastUpdatedAt: null == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialAccountResponse].
extension FinancialAccountResponsePatterns on FinancialAccountResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialAccountResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialAccountResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialAccountResponse value)  $default,){
final _that = this;
switch (_that) {
case _FinancialAccountResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialAccountResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialAccountResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<FinancialAccount> accounts, @JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJson)  Decimal totalBalance,  String lastUpdatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialAccountResponse() when $default != null:
return $default(_that.accounts,_that.totalBalance,_that.lastUpdatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<FinancialAccount> accounts, @JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJson)  Decimal totalBalance,  String lastUpdatedAt)  $default,) {final _that = this;
switch (_that) {
case _FinancialAccountResponse():
return $default(_that.accounts,_that.totalBalance,_that.lastUpdatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<FinancialAccount> accounts, @JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJson)  Decimal totalBalance,  String lastUpdatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FinancialAccountResponse() when $default != null:
return $default(_that.accounts,_that.totalBalance,_that.lastUpdatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinancialAccountResponse implements FinancialAccountResponse {
  const _FinancialAccountResponse({final  List<FinancialAccount> accounts = const [], @JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJson) required this.totalBalance, this.lastUpdatedAt = ''}): _accounts = accounts;
  factory _FinancialAccountResponse.fromJson(Map<String, dynamic> json) => _$FinancialAccountResponseFromJson(json);

 final  List<FinancialAccount> _accounts;
@override@JsonKey() List<FinancialAccount> get accounts {
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accounts);
}

@override@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJson) final  Decimal totalBalance;
@override@JsonKey() final  String lastUpdatedAt;

/// Create a copy of FinancialAccountResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialAccountResponseCopyWith<_FinancialAccountResponse> get copyWith => __$FinancialAccountResponseCopyWithImpl<_FinancialAccountResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinancialAccountResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialAccountResponse&&const DeepCollectionEquality().equals(other._accounts, _accounts)&&(identical(other.totalBalance, totalBalance) || other.totalBalance == totalBalance)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_accounts),totalBalance,lastUpdatedAt);

@override
String toString() {
  return 'FinancialAccountResponse(accounts: $accounts, totalBalance: $totalBalance, lastUpdatedAt: $lastUpdatedAt)';
}


}

/// @nodoc
abstract mixin class _$FinancialAccountResponseCopyWith<$Res> implements $FinancialAccountResponseCopyWith<$Res> {
  factory _$FinancialAccountResponseCopyWith(_FinancialAccountResponse value, $Res Function(_FinancialAccountResponse) _then) = __$FinancialAccountResponseCopyWithImpl;
@override @useResult
$Res call({
 List<FinancialAccount> accounts,@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJson) Decimal totalBalance, String lastUpdatedAt
});




}
/// @nodoc
class __$FinancialAccountResponseCopyWithImpl<$Res>
    implements _$FinancialAccountResponseCopyWith<$Res> {
  __$FinancialAccountResponseCopyWithImpl(this._self, this._then);

  final _FinancialAccountResponse _self;
  final $Res Function(_FinancialAccountResponse) _then;

/// Create a copy of FinancialAccountResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accounts = null,Object? totalBalance = null,Object? lastUpdatedAt = null,}) {
  return _then(_FinancialAccountResponse(
accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<FinancialAccount>,totalBalance: null == totalBalance ? _self.totalBalance : totalBalance // ignore: cast_nullable_to_non_nullable
as Decimal,lastUpdatedAt: null == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$FinancialAccountRequest {

 List<FinancialAccount> get accounts;
/// Create a copy of FinancialAccountRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialAccountRequestCopyWith<FinancialAccountRequest> get copyWith => _$FinancialAccountRequestCopyWithImpl<FinancialAccountRequest>(this as FinancialAccountRequest, _$identity);

  /// Serializes this FinancialAccountRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialAccountRequest&&const DeepCollectionEquality().equals(other.accounts, accounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(accounts));

@override
String toString() {
  return 'FinancialAccountRequest(accounts: $accounts)';
}


}

/// @nodoc
abstract mixin class $FinancialAccountRequestCopyWith<$Res>  {
  factory $FinancialAccountRequestCopyWith(FinancialAccountRequest value, $Res Function(FinancialAccountRequest) _then) = _$FinancialAccountRequestCopyWithImpl;
@useResult
$Res call({
 List<FinancialAccount> accounts
});




}
/// @nodoc
class _$FinancialAccountRequestCopyWithImpl<$Res>
    implements $FinancialAccountRequestCopyWith<$Res> {
  _$FinancialAccountRequestCopyWithImpl(this._self, this._then);

  final FinancialAccountRequest _self;
  final $Res Function(FinancialAccountRequest) _then;

/// Create a copy of FinancialAccountRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accounts = null,}) {
  return _then(_self.copyWith(
accounts: null == accounts ? _self.accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<FinancialAccount>,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialAccountRequest].
extension FinancialAccountRequestPatterns on FinancialAccountRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialAccountRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialAccountRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialAccountRequest value)  $default,){
final _that = this;
switch (_that) {
case _FinancialAccountRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialAccountRequest value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialAccountRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<FinancialAccount> accounts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialAccountRequest() when $default != null:
return $default(_that.accounts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<FinancialAccount> accounts)  $default,) {final _that = this;
switch (_that) {
case _FinancialAccountRequest():
return $default(_that.accounts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<FinancialAccount> accounts)?  $default,) {final _that = this;
switch (_that) {
case _FinancialAccountRequest() when $default != null:
return $default(_that.accounts);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _FinancialAccountRequest implements FinancialAccountRequest {
  const _FinancialAccountRequest({required final  List<FinancialAccount> accounts}): _accounts = accounts;
  factory _FinancialAccountRequest.fromJson(Map<String, dynamic> json) => _$FinancialAccountRequestFromJson(json);

 final  List<FinancialAccount> _accounts;
@override List<FinancialAccount> get accounts {
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accounts);
}


/// Create a copy of FinancialAccountRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialAccountRequestCopyWith<_FinancialAccountRequest> get copyWith => __$FinancialAccountRequestCopyWithImpl<_FinancialAccountRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinancialAccountRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialAccountRequest&&const DeepCollectionEquality().equals(other._accounts, _accounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_accounts));

@override
String toString() {
  return 'FinancialAccountRequest(accounts: $accounts)';
}


}

/// @nodoc
abstract mixin class _$FinancialAccountRequestCopyWith<$Res> implements $FinancialAccountRequestCopyWith<$Res> {
  factory _$FinancialAccountRequestCopyWith(_FinancialAccountRequest value, $Res Function(_FinancialAccountRequest) _then) = __$FinancialAccountRequestCopyWithImpl;
@override @useResult
$Res call({
 List<FinancialAccount> accounts
});




}
/// @nodoc
class __$FinancialAccountRequestCopyWithImpl<$Res>
    implements _$FinancialAccountRequestCopyWith<$Res> {
  __$FinancialAccountRequestCopyWithImpl(this._self, this._then);

  final _FinancialAccountRequest _self;
  final $Res Function(_FinancialAccountRequest) _then;

/// Create a copy of FinancialAccountRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accounts = null,}) {
  return _then(_FinancialAccountRequest(
accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<FinancialAccount>,
  ));
}


}

// dart format on
