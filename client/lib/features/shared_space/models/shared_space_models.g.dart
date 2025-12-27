// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_space_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SharedSpaceMember _$SharedSpaceMemberFromJson(Map<String, dynamic> json) =>
    _SharedSpaceMember(
      userId: json['userId'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      role:
          $enumDecodeNullable(_$MemberRoleEnumMap, json['role']) ??
          MemberRole.member,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      email: json['email'] as String?,
      status:
          $enumDecodeNullable(_$InviteStatusEnumMap, json['status']) ??
          InviteStatus.accepted,
      contributionAmount: json['contributionAmount'] as String? ?? '0.00',
    );

Map<String, dynamic> _$SharedSpaceMemberToJson(_SharedSpaceMember instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'avatarUrl': instance.avatarUrl,
      'role': _$MemberRoleEnumMap[instance.role]!,
      'createdAt': instance.createdAt?.toIso8601String(),
      'email': instance.email,
      'status': _$InviteStatusEnumMap[instance.status]!,
      'contributionAmount': instance.contributionAmount,
    };

const _$MemberRoleEnumMap = {
  MemberRole.owner: 'OWNER',
  MemberRole.admin: 'ADMIN',
  MemberRole.member: 'MEMBER',
};

const _$InviteStatusEnumMap = {
  InviteStatus.pending: 'PENDING',
  InviteStatus.accepted: 'ACCEPTED',
  InviteStatus.declined: 'DECLINED',
};

_SpaceCreator _$SpaceCreatorFromJson(Map<String, dynamic> json) =>
    _SpaceCreator(
      id: json['id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$SpaceCreatorToJson(_SpaceCreator instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'avatarUrl': instance.avatarUrl,
    };

_SharedSpace _$SharedSpaceFromJson(Map<String, dynamic> json) => _SharedSpace(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  creator: SpaceCreator.fromJson(json['creator'] as Map<String, dynamic>),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  members: (json['members'] as List<dynamic>?)
      ?.map((e) => SharedSpaceMember.fromJson(e as Map<String, dynamic>))
      .toList(),
  transactionCount: (json['transactionCount'] as num?)?.toInt() ?? 0,
  currentInviteCode: json['currentInviteCode'] as String?,
  inviteCodeExpiresAt: json['inviteCodeExpiresAt'] == null
      ? null
      : DateTime.parse(json['inviteCodeExpiresAt'] as String),
  totalExpense: json['totalExpense'] as String? ?? '0.00',
);

Map<String, dynamic> _$SharedSpaceToJson(_SharedSpace instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'creator': instance.creator,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'members': instance.members,
      'transactionCount': instance.transactionCount,
      'currentInviteCode': instance.currentInviteCode,
      'inviteCodeExpiresAt': instance.inviteCodeExpiresAt?.toIso8601String(),
      'totalExpense': instance.totalExpense,
    };

_InviteCode _$InviteCodeFromJson(Map<String, dynamic> json) => _InviteCode(
  code: json['code'] as String,
  spaceId: json['spaceId'] as String,
  spaceName: json['spaceName'] as String,
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$InviteCodeToJson(_InviteCode instance) =>
    <String, dynamic>{
      'code': instance.code,
      'spaceId': instance.spaceId,
      'spaceName': instance.spaceName,
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };

_SettlementItem _$SettlementItemFromJson(Map<String, dynamic> json) =>
    _SettlementItem(
      fromUserId: json['fromUserId'] as String,
      fromUsername: json['fromUsername'] as String,
      toUserId: json['toUserId'] as String,
      toUsername: json['toUsername'] as String,
      amount: Decimal.parse(json['amount'] as String),
    );

Map<String, dynamic> _$SettlementItemToJson(_SettlementItem instance) =>
    <String, dynamic>{
      'fromUserId': instance.fromUserId,
      'fromUsername': instance.fromUsername,
      'toUserId': instance.toUserId,
      'toUsername': instance.toUsername,
      'amount': _decimalToString(instance.amount),
    };

_Settlement _$SettlementFromJson(Map<String, dynamic> json) => _Settlement(
  spaceId: json['spaceId'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => SettlementItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalAmount: Decimal.parse(json['totalAmount'] as String),
  calculatedAt: DateTime.parse(json['calculatedAt'] as String),
  isSettled: json['isSettled'] as bool? ?? false,
);

Map<String, dynamic> _$SettlementToJson(_Settlement instance) =>
    <String, dynamic>{
      'spaceId': instance.spaceId,
      'items': instance.items,
      'totalAmount': _decimalToString(instance.totalAmount),
      'calculatedAt': instance.calculatedAt.toIso8601String(),
      'isSettled': instance.isSettled,
    };

_NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    _NotificationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      title: json['title'] as String,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
    );

Map<String, dynamic> _$NotificationModelToJson(_NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'title': instance.title,
      'message': instance.message,
      'data': instance.data,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt?.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.spaceInvite: 'space_invite',
  NotificationType.newTransaction: 'new_transaction',
  NotificationType.settlementUpdate: 'settlement_update',
  NotificationType.memberJoined: 'member_joined',
  NotificationType.memberLeft: 'member_left',
};

_SpaceTransaction _$SpaceTransactionFromJson(Map<String, dynamic> json) =>
    _SpaceTransaction(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: json['amount'] as String,
      currency: json['currency'] as String? ?? 'CNY',
      description: json['description'] as String?,
      categoryKey: json['categoryKey'] as String?,
      transactionAt: json['transactionAt'] == null
          ? null
          : DateTime.parse(json['transactionAt'] as String),
      addedByUsername: json['addedByUsername'] as String?,
      addedAt: json['addedAt'] == null
          ? null
          : DateTime.parse(json['addedAt'] as String),
      display: json['display'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$SpaceTransactionToJson(_SpaceTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'amount': instance.amount,
      'currency': instance.currency,
      'description': instance.description,
      'categoryKey': instance.categoryKey,
      'transactionAt': instance.transactionAt?.toIso8601String(),
      'addedByUsername': instance.addedByUsername,
      'addedAt': instance.addedAt?.toIso8601String(),
      'display': instance.display,
    };

_SpaceTransactionListResponse _$SpaceTransactionListResponseFromJson(
  Map<String, dynamic> json,
) => _SpaceTransactionListResponse(
  transactions: (json['transactions'] as List<dynamic>)
      .map((e) => SpaceTransaction.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$SpaceTransactionListResponseToJson(
  _SpaceTransactionListResponse instance,
) => <String, dynamic>{
  'transactions': instance.transactions,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
};

_SharedSpaceListResponse _$SharedSpaceListResponseFromJson(
  Map<String, dynamic> json,
) => _SharedSpaceListResponse(
  spaces: (json['spaces'] as List<dynamic>)
      .map((e) => SharedSpace.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$SharedSpaceListResponseToJson(
  _SharedSpaceListResponse instance,
) => <String, dynamic>{
  'spaces': instance.spaces,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
};

_NotificationListResponse _$NotificationListResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationListResponse(
  notifications: (json['notifications'] as List<dynamic>)
      .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  unreadCount: (json['unreadCount'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$NotificationListResponseToJson(
  _NotificationListResponse instance,
) => <String, dynamic>{
  'notifications': instance.notifications,
  'total': instance.total,
  'unreadCount': instance.unreadCount,
  'page': instance.page,
  'limit': instance.limit,
};
