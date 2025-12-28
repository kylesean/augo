// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SharedUserInfo _$SharedUserInfoFromJson(Map<String, dynamic> json) =>
    _SharedUserInfo(
      userId: json['userId'] as String,
      avatarUrl: json['avatarUrl'] as String,
      username: json['username'] as String?,
    );

Map<String, dynamic> _$SharedUserInfoToJson(_SharedUserInfo instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'avatarUrl': instance.avatarUrl,
      'username': instance.username,
    };

_FinancialAccountInfo _$FinancialAccountInfoFromJson(
  Map<String, dynamic> json,
) => _FinancialAccountInfo(
  id: json['id'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$FinancialAccountInfoToJson(
  _FinancialAccountInfo instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

_SpaceInfo _$SpaceInfoFromJson(Map<String, dynamic> json) =>
    _SpaceInfo(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$SpaceInfoToJson(_SpaceInfo instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_AmountDisplay _$AmountDisplayFromJson(Map<String, dynamic> json) =>
    _AmountDisplay(
      sign: json['sign'] as String,
      value: json['value'] as String,
      currencySymbol: json['currencySymbol'] as String,
      fullString: json['fullString'] as String,
    );

Map<String, dynamic> _$AmountDisplayToJson(_AmountDisplay instance) =>
    <String, dynamic>{
      'sign': instance.sign,
      'value': instance.value,
      'currencySymbol': instance.currencySymbol,
      'fullString': instance.fullString,
    };

_TransactionCommentModel _$TransactionCommentModelFromJson(
  Map<String, dynamic> json,
) => _TransactionCommentModel(
  id: (json['id'] as num).toInt(),
  transactionId: json['transactionId'] as String,
  userUuid: json['userUuid'] as String,
  userName: json['userName'] as String?,
  userAvatarUrl: json['userAvatarUrl'] as String?,
  parentCommentId: (json['parentCommentId'] as num?)?.toInt(),
  commentText: json['commentText'] as String,
  mentionedUserIds:
      (json['mentionedUserIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TransactionCommentModelToJson(
  _TransactionCommentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'transactionId': instance.transactionId,
  'userUuid': instance.userUuid,
  'userName': instance.userName,
  'userAvatarUrl': instance.userAvatarUrl,
  'parentCommentId': instance.parentCommentId,
  'commentText': instance.commentText,
  'mentionedUserIds': instance.mentionedUserIds,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

_TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    _TransactionModel(
      id: json['id'] as String,
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      category: json['category'] as String,
      categoryKey: json['categoryKey'] as String?,
      categoryText: json['categoryText'] as String?,
      iconUrl: json['iconUrl'] as String,
      amount: (json['amount'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      amountOriginal: (json['amountOriginal'] as num?)?.toDouble(),
      originalCurrency: json['originalCurrency'] as String?,
      exchangeRate: json['exchangeRate'] as String?,
      description: json['description'] as String?,
      isShared: json['isShared'] as bool? ?? false,
      sharedWith:
          (json['sharedWith'] as List<dynamic>?)
              ?.map((e) => SharedUserInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      paymentMethod: json['paymentMethod'] as String?,
      paymentMethodText: json['paymentMethodText'] as String?,
      location: json['location'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      rawInput: json['rawInput'] as String?,
      financialAccount: json['financialAccount'] == null
          ? null
          : FinancialAccountInfo.fromJson(
              json['financialAccount'] as Map<String, dynamic>,
            ),
      display: json['display'] == null
          ? null
          : AmountDisplay.fromJson(json['display'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      photoPath: json['photoPath'] as String?,
      geoLocation: json['geoLocation'] as String?,
      comments:
          (json['comments'] as List<dynamic>?)
              ?.map(
                (e) =>
                    TransactionCommentModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      sourceAccountId: json['sourceAccountId'] as String?,
      targetAccountId: json['targetAccountId'] as String?,
      spaces:
          (json['spaces'] as List<dynamic>?)
              ?.map((e) => SpaceInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      sourceThreadId: json['sourceThreadId'] as String?,
    );

Map<String, dynamic> _$TransactionModelToJson(_TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'category': instance.category,
      'categoryKey': instance.categoryKey,
      'categoryText': instance.categoryText,
      'iconUrl': instance.iconUrl,
      'amount': instance.amount,
      'timestamp': instance.timestamp.toIso8601String(),
      'amountOriginal': instance.amountOriginal,
      'originalCurrency': instance.originalCurrency,
      'exchangeRate': instance.exchangeRate,
      'description': instance.description,
      'isShared': instance.isShared,
      'sharedWith': instance.sharedWith,
      'paymentMethod': instance.paymentMethod,
      'paymentMethodText': instance.paymentMethodText,
      'location': instance.location,
      'tags': instance.tags,
      'rawInput': instance.rawInput,
      'financialAccount': instance.financialAccount,
      'display': instance.display,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'photoPath': instance.photoPath,
      'geoLocation': instance.geoLocation,
      'comments': instance.comments,
      'sourceAccountId': instance.sourceAccountId,
      'targetAccountId': instance.targetAccountId,
      'spaces': instance.spaces,
      'sourceThreadId': instance.sourceThreadId,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.expense: 'expense',
  TransactionType.income: 'income',
  TransactionType.transfer: 'transfer',
  TransactionType.other: 'other',
};
