import '../../i18n/strings.g.dart';
import '../constants/error_codes.dart';

/// Utility class for translating backend error codes to localized messages.
///
/// Uses the generated i18n [t] object to provide localized strings based on
/// specific backend business error codes.
class ErrorTranslator {
  /// Translates a numeric error code from the backend to a localized message.
  ///
  /// [code] The error code returned by the API.
  /// [defaultMessage] The fallback message (e.g., from the backend) if the code is not recognized.
  static String translate(int code, String defaultMessage) {
    final e = t.errorMapping;

    switch (code) {
      // Generic Errors
      case 400:
        return e.generic.badRequest;
      case ErrorCodes.authFailed:
        return e.generic.authFailed;
      case ErrorCodes.permissionDenied:
        return e.generic.permissionDenied;
      case ErrorCodes.notFound:
        return e.generic.notFound;
      case ErrorCodes.serverError:
        return e.generic.serverError;
      case ErrorCodes.systemInvalid:
        return e.generic.systemError;
      case ErrorCodes.validationError:
        return e.generic.validationFailed;

      // Authentication (1000-1012)
      case ErrorCodes.authenticateFailed:
        return e.auth.failed;
      case ErrorCodes.emailWrong:
        return e.auth.emailWrong;
      case ErrorCodes.phoneNumberWrong:
        return e.auth.phoneWrong;
      case ErrorCodes.phoneNumberRegistered:
        return e.auth.phoneRegistered;
      case ErrorCodes.emailRegistered:
        return e.auth.emailRegistered;
      case ErrorCodes.sendCodeFailed:
        return e.auth.sendFailed;
      case ErrorCodes.codeExpired:
        return e.auth.expired;
      case ErrorCodes.codeSendTooFrequently:
        return e.auth.tooFrequent;
      case ErrorCodes.unsupportedCodeType:
        return e.auth.unsupportedType;
      case ErrorCodes.userNotMatchPassword:
        return e.auth.wrongPassword;
      case ErrorCodes.userNotExist:
        return e.auth.userNotFound;
      case ErrorCodes.noPreferencesParams:
        return e.auth.prefsMissing;
      case ErrorCodes.invalidClientTimezone:
        return e.auth.invalidTimezone;

      // Transaction (3000-3004)
      case ErrorCodes.transactionCommentNull:
        return e.transaction.commentEmpty;
      case ErrorCodes.invalidParentCommentId:
        return e.transaction.invalidParent;
      case ErrorCodes.storeCommentFailed:
        return e.transaction.saveFailed;
      case ErrorCodes.deleteCommentFailed:
        return e.transaction.deleteFailed;
      case ErrorCodes.transactionNotExists:
        return e.transaction.notExists;

      // Shared Space (3100-3113)
      case ErrorCodes.sharedSpaceNotExistsOrNoAccess:
        return e.space.notFound;
      case ErrorCodes.noPermissionToInviteMembers:
        return e.space.inviteDenied;
      case ErrorCodes.cannotInviteYourself:
        return e.space.inviteSelf;
      case ErrorCodes.invitationSent:
        return e.space.inviteSent;
      case ErrorCodes.alreadyMemberOrHasBeenInvited:
        return e.space.alreadyMember;
      case ErrorCodes.invalidAction:
        return e.space.invalidAction;
      case ErrorCodes.invitationNotExists:
        return e.space.invitationNotFound;
      case ErrorCodes.onlyOwnerCanDo:
        return e.space.onlyOwner;
      case ErrorCodes.ownerCannotBeRemoved:
        return e.space.ownerNotRemovable;
      case ErrorCodes.memberNotExist:
        return e.space.memberNotFound;
      case ErrorCodes.notMemberInThisSpace:
        return e.space.notMember;
      case ErrorCodes.ownerCannotLeaveDirectly:
        return e.space.ownerCantLeave;
      case ErrorCodes.invalidInvitationCode:
        return e.space.invalidCode;
      case ErrorCodes.invitationCodeExpiredOrLimited:
        return e.space.codeExpired;

      // Recurring (3200-3201)
      case ErrorCodes.invalidRecurrenceRule:
        return e.recurring.invalidRule;
      case ErrorCodes.recurrenceRuleNotFound:
        return e.recurring.ruleNotFound;

      // File Upload (4001-4017)
      case ErrorCodes.noFileUploaded:
        return e.upload.noFile;
      case ErrorCodes.fileTooLarge:
        return e.upload.tooLarge;
      case ErrorCodes.invalidFileType:
        return e.upload.unsupportedType;
      case ErrorCodes.tooManyFiles:
        return e.upload.tooManyFiles;

      // AI/LLM (9000-9004)
      case ErrorCodes.aiContextLimitExceeded:
        return e.ai.contextLimit;
      case ErrorCodes.tokensLimited:
        return e.ai.tokenLimit;
      case ErrorCodes.noUserMessage:
        return e.ai.emptyMessage;

      default:
        return defaultMessage;
    }
  }
}
