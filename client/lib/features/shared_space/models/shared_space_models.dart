import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:decimal/decimal.dart';

part 'shared_space_models.freezed.dart';
part 'shared_space_models.g.dart';

enum MemberRole {
  @JsonValue('OWNER')
  owner,
  @JsonValue('ADMIN')
  admin,
  @JsonValue('MEMBER')
  member,
}

enum InviteStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('ACCEPTED')
  accepted,
  @JsonValue('DECLINED')
  declined,
}

enum NotificationType {
  @JsonValue('space_invite')
  spaceInvite,
  @JsonValue('new_transaction')
  newTransaction,
  @JsonValue('settlement_update')
  settlementUpdate,
  @JsonValue('member_joined')
  memberJoined,
  @JsonValue('member_left')
  memberLeft,
}

@freezed
abstract class SharedSpaceMember with _$SharedSpaceMember {
  const factory SharedSpaceMember({
    required String userId,
    required String username,
    String? avatarUrl,
    @Default(MemberRole.member) MemberRole role,
    DateTime? createdAt,
    String? email,
    @Default(InviteStatus.accepted) InviteStatus status,
    @Default('0.00') String contributionAmount,
  }) = _SharedSpaceMember;

  factory SharedSpaceMember.fromJson(Map<String, dynamic> json) =>
      _$SharedSpaceMemberFromJson(json);
}

@freezed
abstract class SpaceCreator with _$SpaceCreator {
  const factory SpaceCreator({
    required String id,
    required String username,
    String? avatarUrl,
  }) = _SpaceCreator;

  factory SpaceCreator.fromJson(Map<String, dynamic> json) =>
      _$SpaceCreatorFromJson(json);
}

@freezed
abstract class SharedSpace with _$SharedSpace {
  const factory SharedSpace({
    required String id,
    required String name,
    String? description,
    required SpaceCreator creator,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<SharedSpaceMember>? members,
    @Default(0) int transactionCount,
    String? currentInviteCode,
    DateTime? inviteCodeExpiresAt,
    @Default('0.00') String totalExpense,
  }) = _SharedSpace;

  factory SharedSpace.fromJson(Map<String, dynamic> json) =>
      _$SharedSpaceFromJson(json);
}

@freezed
abstract class InviteCode with _$InviteCode {
  const factory InviteCode({
    required String code,
    required String spaceId,
    required String spaceName,
    DateTime? expiresAt,
  }) = _InviteCode;

  factory InviteCode.fromJson(Map<String, dynamic> json) =>
      _$InviteCodeFromJson(json);
}

@freezed
abstract class SettlementItem with _$SettlementItem {
  const factory SettlementItem({
    required String fromUserId,
    required String fromUsername,
    required String toUserId,
    required String toUsername,
    @JsonKey(fromJson: Decimal.parse, toJson: _decimalToString)
    required Decimal amount,
  }) = _SettlementItem;

  factory SettlementItem.fromJson(Map<String, dynamic> json) =>
      _$SettlementItemFromJson(json);
}

@freezed
abstract class Settlement with _$Settlement {
  const factory Settlement({
    required String spaceId,
    required List<SettlementItem> items,
    @JsonKey(fromJson: Decimal.parse, toJson: _decimalToString)
    required Decimal totalAmount,
    required DateTime calculatedAt,
    @Default(false) bool isSettled,
  }) = _Settlement;

  factory Settlement.fromJson(Map<String, dynamic> json) =>
      _$SettlementFromJson(json);
}

@freezed
abstract class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String userId,
    required NotificationType type,
    required String title,
    required String message,
    Map<String, dynamic>? data,
    @Default(false) bool isRead,
    DateTime? createdAt,
    DateTime? readAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

@freezed
abstract class SpaceTransaction with _$SpaceTransaction {
  const factory SpaceTransaction({
    required String id,
    required String type, // EXPENSE, INCOME, TRANSFER
    required String amount,
    @Default('CNY') String currency,
    String? description,
    String? categoryKey,
    @JsonKey(name: 'transactionAt') DateTime? transactionAt,
    @JsonKey(name: 'addedByUsername') String? addedByUsername,
    @JsonKey(name: 'addedAt') DateTime? addedAt,

    Map<String, dynamic>? display,
  }) = _SpaceTransaction;

  factory SpaceTransaction.fromJson(Map<String, dynamic> json) =>
      _$SpaceTransactionFromJson(json);
}

@freezed
abstract class SpaceTransactionListResponse
    with _$SpaceTransactionListResponse {
  const factory SpaceTransactionListResponse({
    required List<SpaceTransaction> transactions,
    required int total,
    required int page,
    required int limit,
  }) = _SpaceTransactionListResponse;

  factory SpaceTransactionListResponse.fromJson(Map<String, dynamic> json) =>
      _$SpaceTransactionListResponseFromJson(json);
}

@freezed
abstract class SharedSpaceListResponse with _$SharedSpaceListResponse {
  const factory SharedSpaceListResponse({
    required List<SharedSpace> spaces,
    required int total,
    required int page,
    required int limit,
  }) = _SharedSpaceListResponse;

  factory SharedSpaceListResponse.fromJson(Map<String, dynamic> json) =>
      _$SharedSpaceListResponseFromJson(json);
}

@freezed
abstract class NotificationListResponse with _$NotificationListResponse {
  const factory NotificationListResponse({
    required List<NotificationModel> notifications,
    required int total,
    required int unreadCount,
    required int page,
    required int limit,
  }) = _NotificationListResponse;

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationListResponseFromJson(json);
}

String _decimalToString(Decimal decimal) => decimal.toString();
