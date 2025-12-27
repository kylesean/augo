class ErrorCodes {
  // Success
  static const int success = 0;

  // Generic errors
  static const int serverError = 500;
  static const int systemInvalid = 501;
  static const int validationError = 999;
  static const int notFound = 404;
  static const int permissionDenied = 403;
  static const int authFailed = 401;

  // Authentication errors (1000-1012)
  static const int authenticateFailed = 1000;
  static const int emailWrong = 1001;
  static const int phoneNumberWrong = 1002;
  static const int phoneNumberRegistered = 1003;
  static const int emailRegistered = 1004;
  static const int sendCodeFailed = 1005;
  static const int codeExpired = 1006;
  static const int codeSendTooFrequently = 1007;
  static const int unsupportedCodeType = 1008;
  static const int userNotMatchPassword = 1009;
  static const int userNotExist = 1010;
  static const int noPreferencesParams = 1011;
  static const int invalidClientTimezone = 1012;

  // Transaction errors (3000-3018)
  static const int transactionCommentNull = 3000;
  static const int invalidParentCommentId = 3001;
  static const int storeCommentFailed = 3002;
  static const int deleteCommentFailed = 3003;
  static const int transactionNotExists = 3004;

  // Shared space errors (3100-3118)
  static const int sharedSpaceNotExistsOrNoAccess = 3100;
  static const int noPermissionToInviteMembers = 3101;
  static const int cannotInviteYourself = 3102;
  static const int invitationSent = 3103;
  static const int alreadyMemberOrHasBeenInvited = 3104;
  static const int invalidAction = 3105;
  static const int invitationNotExists = 3106;
  static const int onlyOwnerCanDo = 3107;
  static const int ownerCannotBeRemoved = 3108;
  static const int memberNotExist = 3109;
  static const int notMemberInThisSpace = 3110;
  static const int ownerCannotLeaveDirectly = 3111;
  static const int invalidInvitationCode = 3112;
  static const int invitationCodeExpiredOrLimited = 3113;

  // Recurring transaction errors (3200-3201)
  static const int invalidRecurrenceRule = 3200;
  static const int recurrenceRuleNotFound = 3201;

  // File upload errors (4001-4017)
  static const int noFileUploaded = 4001;
  static const int invalidFileUploaded = 4002;
  static const int fileTooLarge = 4003;
  static const int invalidFileType = 4004;
  static const int invalidMimeType = 4005;
  static const int invalidImageContent = 4006;
  static const int imageTooWide = 4007;
  static const int imageTooHigh = 4008;
  static const int tooManyFiles = 4009;
  static const int totalSizeTooLarge = 4010;
  static const int fileReadError = 4011;
  static const int filesystemError = 4012;
  static const int uploadVerificationFailed = 4013;
  static const int uploadAllFailed = 4014;
  static const int invalidImageUrls = 4015;
  static const int fileNotFound = 4016;
  static const int imageCompressionFailed = 4017;

  // AI/LLM errors (9000-9004)
  static const int aiContextLimitExceeded = 9000;
  static const int conversationIdInvalid = 9001;
  static const int conversationIdNotOwner = 9002;
  static const int tokensLimited = 9003;
  static const int noUserMessage = 9004;
}
