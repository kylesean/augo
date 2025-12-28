// features/home/models/transaction_model.dart
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:forui/forui.dart';
import 'package:augo/i18n/strings.g.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

// Transaction type enum
enum TransactionType {
  expense, // Expense
  income, // Income
  transfer, // Transfer
  other,
}

// Shared user information
@freezed
abstract class SharedUserInfo with _$SharedUserInfo {
  const factory SharedUserInfo({
    required String userId,
    required String avatarUrl, // User avatar URL
    String? username, // Optional display name
  }) = _SharedUserInfo;

  factory SharedUserInfo.fromJson(Map<String, dynamic> json) =>
      _$SharedUserInfoFromJson(json);
}

// AccountInfo removed, no longer used

// Financial account information
@freezed
abstract class FinancialAccountInfo with _$FinancialAccountInfo {
  const factory FinancialAccountInfo({
    required String id,
    required String name,
  }) = _FinancialAccountInfo;

  factory FinancialAccountInfo.fromJson(Map<String, dynamic> json) =>
      _$FinancialAccountInfoFromJson(json);
}

@freezed
abstract class SpaceInfo with _$SpaceInfo {
  const factory SpaceInfo({required String id, required String name}) =
      _SpaceInfo;

  factory SpaceInfo.fromJson(Map<String, dynamic> json) =>
      _$SpaceInfoFromJson(json);
}

// Amount display information
@freezed
abstract class AmountDisplay with _$AmountDisplay {
  const factory AmountDisplay({
    required String sign,
    required String value,
    required String currencySymbol,
    required String fullString,
  }) = _AmountDisplay;

  factory AmountDisplay.fromJson(Map<String, dynamic> json) =>
      _$AmountDisplayFromJson(json);
}

// Transaction comment model
@freezed
abstract class TransactionCommentModel with _$TransactionCommentModel {
  const factory TransactionCommentModel({
    required int id,
    required String transactionId,
    required String userUuid,
    String? userName,
    String? userAvatarUrl,
    int? parentCommentId,
    required String commentText,
    @Default([]) List<int> mentionedUserIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TransactionCommentModel;

  factory TransactionCommentModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionCommentModelFromJson(json);

  /// Create comment model from API JSON
  factory TransactionCommentModel.fromApiJson(Map<String, dynamic> json) {
    return TransactionCommentModel(
      id: json['id'] as int,
      transactionId: json['transactionId'] as String,
      userUuid: json['userUuid'] as String,
      userName: json['userName'] as String?,
      userAvatarUrl: json['userAvatarUrl'] as String?,
      parentCommentId: json['parentCommentId'] as int?,
      commentText: json['commentText'] as String,
      mentionedUserIds:
          (json['mentionedUserIds'] as List<dynamic>?)?.cast<int>() ?? [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }
}

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id, // Unique ID
    required TransactionType type, // Transaction type (expense/income/transfer)
    required String category, // Category (e.g., Dining, Transport, Salary)
    String? categoryKey, // Category ID
    String? categoryText, // Server-side localized category name
    required String iconUrl, // Category icon URL (or local path)
    required double amount, // Display amount after conversion
    required DateTime timestamp, // Transaction time
    // Original amount information (historical data, immutable)
    double? amountOriginal, // Original recorded amount
    String? originalCurrency, // Original recorded currency (e.g., USD, CNY)
    String? exchangeRate, // Exchange rate snapshot at time of recording
    // Other fields
    String? description, // Note
    @Default(false) bool isShared,
    @Default([]) List<SharedUserInfo> sharedWith,
    String? paymentMethod,
    String? paymentMethodText, // Server-side localized payment method name
    String? location,
    @Default([]) List<String> tags,
    String? rawInput,
    FinancialAccountInfo? financialAccount,
    AmountDisplay? display,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? photoPath,
    String? geoLocation,
    @Default([]) List<TransactionCommentModel> comments, // Comment list
    // Associated account and space information
    String? sourceAccountId, // Source account ID
    String? targetAccountId, // Target account ID
    @Default([]) List<SpaceInfo> spaces, // Associated shared spaces
    String? sourceThreadId, // Source AI chat session ID for message anchor
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  /// Create TransactionModel from new API response
  ///
  /// API fields (camelCase):
  /// - id, userUuid, type, amount, currency
  /// - categoryKey, rawInput, transactionAt, transactionTimezone
  /// - tags, status, createdAt
  factory TransactionModel.fromApiJson(Map<String, dynamic> json) {
    // Parse transaction type
    TransactionType type;
    final typeStr = json['type'] as String?;
    switch (typeStr?.toUpperCase()) {
      case 'INCOME':
        type = TransactionType.income;
        break;
      case 'EXPENSE':
        type = TransactionType.expense;
        break;
      case 'TRANSFER':
        type = TransactionType.transfer;
        break;
      default:
        type = TransactionType.other;
        break;
    }

    // Parse timestamp (field name changed to transactionAt)
    final transactionAtStr = json['transactionAt'] as String?;
    final timestamp = transactionAtStr != null
        ? DateTime.tryParse(transactionAtStr) ?? DateTime.now()
        : DateTime.now();

    // Parse creation time
    final createdAtStr = json['createdAt'] as String?;
    final createdAt = createdAtStr != null
        ? DateTime.tryParse(createdAtStr)
        : null;

    final rawInput = json['rawInput'] as String?;

    // Parse comment list
    final commentsList = json['comments'] as List<dynamic>?;
    final comments =
        commentsList
            ?.map(
              (c) => TransactionCommentModel.fromApiJson(
                c as Map<String, dynamic>,
              ),
            )
            .toList() ??
        [];

    // Parse amount display info - adding compatibility handling
    final displayJson = json['display'] as Map<String, dynamic>?;
    final display = displayJson != null
        ? AmountDisplay.fromJson(displayJson)
        : null;

    // Parse associated space information
    final spacesList = json['spaces'] as List<dynamic>?;
    final spaces =
        spacesList
            ?.map((s) => SpaceInfo.fromJson(s as Map<String, dynamic>))
            .toList() ??
        [];

    return TransactionModel(
      id: json['id'] as String,
      type: type,
      amount: _parseAmount(json['amount']),
      // Original amount info (historical data, immutable)
      amountOriginal: _parseAmount(json['amountOriginal']),
      originalCurrency: json['originalCurrency'] as String?,
      exchangeRate: json['exchangeRate'] as String?,
      category:
          json['categoryName'] as String? ??
          json['categoryKey'] as String? ??
          t.category.other,
      timestamp: timestamp,
      description: json['description'] as String?,
      paymentMethod: json['currency'] as String?,
      location: json['location'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      isShared: json['isShared'] as bool? ?? false,
      categoryKey: json['categoryKey'] as String?,
      categoryText: json['categoryText'] as String?,
      paymentMethodText: json['paymentMethodText'] as String?,
      display: display,
      iconUrl: '', // Keep default empty string
      rawInput: rawInput,
      financialAccount: null, // Keep default null
      createdAt: createdAt,
      updatedAt: null, // Keep default null
      photoPath: null, // Keep default null
      geoLocation: null, // Keep default null
      sharedWith: [], // Keep default empty list
      comments: comments,
      // Associated account and space
      sourceAccountId: json['sourceAccountId']?.toString(),
      targetAccountId: json['targetAccountId']?.toString(),
      spaces: spaces,
      sourceThreadId: json['sourceThreadId']?.toString(),
    );
  }
}

const Map<String, IconData> lucideIconMap = {
  'shoppingBag': FIcons.shoppingCart,
  'carTaxiFront': FIcons.carTaxiFront,
  'briefcaseMedical': FIcons.briefcaseMedical,
  'housePlus': FIcons.housePlus,
  'libraryBig': FIcons.libraryBig,
  'walletCards': FIcons.walletCards,
  'gift': FIcons.gift,
  'folderSync': FIcons.folderSync,
};
IconData lucideIconFromString(String raw) {
  // Allow "LucideIcons.shoppingCart" or "shoppingCart"
  final key = raw.replaceAll('LucideIcons.', '');
  return lucideIconMap[key] ?? FIcons.shoppingBag;
}

// TransactionType serialization/deserialization
TransactionType _transactionTypeFromString(String typeStr) {
  switch (typeStr.toLowerCase()) {
    case 'income':
      return TransactionType.income;
    case 'expense':
    default:
      return TransactionType.expense;
  }
}

String _transactionTypeToString(TransactionType type) {
  switch (type) {
    case TransactionType.income:
      return 'income';
    case TransactionType.expense:
      return 'expense';
    case TransactionType.transfer:
      return 'transfer';
    case TransactionType.other:
      return 'other';
  }
}

// DateTime serialization/deserialization (only date part, if API needs full timestamp use .toIso8601String())
String _dateTimeToIso8601String(DateTime dt) =>
    dt.toIso8601String(); // API usually expects full ISO string

// Parse amount field, support string and number format
double _parseAmount(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) {
    // Remove potential signs and currency symbols
    final cleanValue = value.replaceAll(RegExp(r'[^\d.-]'), '');
    return double.tryParse(cleanValue) ?? 0.0;
  }
  return 0.0;
}

// If your API returns 0/1 instead of true/false for is_ai_build, you might need a custom fromJson
// bool _boolFromInt(dynamic value) => value == 1 || value == true;
