///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsEn extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEn({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsEn _root = this; // ignore: unused_field

	@override 
	TranslationsEn $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEn(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsCommonEn common = _TranslationsCommonEn._(_root);
	@override late final _TranslationsTimeEn time = _TranslationsTimeEn._(_root);
	@override late final _TranslationsGreetingEn greeting = _TranslationsGreetingEn._(_root);
	@override late final _TranslationsNavigationEn navigation = _TranslationsNavigationEn._(_root);
	@override late final _TranslationsAuthEn auth = _TranslationsAuthEn._(_root);
	@override late final _TranslationsTransactionEn transaction = _TranslationsTransactionEn._(_root);
	@override late final _TranslationsHomeEn home = _TranslationsHomeEn._(_root);
	@override late final _TranslationsCommentEn comment = _TranslationsCommentEn._(_root);
	@override late final _TranslationsCalendarEn calendar = _TranslationsCalendarEn._(_root);
	@override late final _TranslationsCategoryEn category = _TranslationsCategoryEn._(_root);
	@override late final _TranslationsSettingsEn settings = _TranslationsSettingsEn._(_root);
	@override late final _TranslationsAppearanceEn appearance = _TranslationsAppearanceEn._(_root);
	@override late final _TranslationsSpeechEn speech = _TranslationsSpeechEn._(_root);
	@override late final _TranslationsAmountThemeEn amountTheme = _TranslationsAmountThemeEn._(_root);
	@override late final _TranslationsLocaleEn locale = _TranslationsLocaleEn._(_root);
	@override late final _TranslationsBudgetEn budget = _TranslationsBudgetEn._(_root);
	@override late final _TranslationsDateRangeEn dateRange = _TranslationsDateRangeEn._(_root);
	@override late final _TranslationsForecastEn forecast = _TranslationsForecastEn._(_root);
	@override late final _TranslationsChatEn chat = _TranslationsChatEn._(_root);
	@override late final _TranslationsFootprintEn footprint = _TranslationsFootprintEn._(_root);
	@override late final _TranslationsMediaEn media = _TranslationsMediaEn._(_root);
	@override late final _TranslationsErrorEn error = _TranslationsErrorEn._(_root);
	@override late final _TranslationsFontTestEn fontTest = _TranslationsFontTestEn._(_root);
	@override late final _TranslationsWizardEn wizard = _TranslationsWizardEn._(_root);
	@override late final _TranslationsUserEn user = _TranslationsUserEn._(_root);
	@override late final _TranslationsAccountEn account = _TranslationsAccountEn._(_root);
	@override late final _TranslationsFinancialEn financial = _TranslationsFinancialEn._(_root);
	@override late final _TranslationsAppEn app = _TranslationsAppEn._(_root);
	@override late final _TranslationsStatisticsEn statistics = _TranslationsStatisticsEn._(_root);
	@override late final _TranslationsCurrencyEn currency = _TranslationsCurrencyEn._(_root);
	@override late final _TranslationsBudgetSuggestionEn budgetSuggestion = _TranslationsBudgetSuggestionEn._(_root);
	@override late final _TranslationsServerEn server = _TranslationsServerEn._(_root);
	@override late final _TranslationsSharedSpaceEn sharedSpace = _TranslationsSharedSpaceEn._(_root);
	@override late final _TranslationsErrorMappingEn errorMapping = _TranslationsErrorMappingEn._(_root);
}

// Path: common
class _TranslationsCommonEn extends TranslationsCommonZh {
	_TranslationsCommonEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Loading...';
	@override String get error => 'Error';
	@override String get retry => 'Retry';
	@override String get cancel => 'Cancel';
	@override String get confirm => 'Confirm';
	@override String get save => 'Save';
	@override String get delete => 'Delete';
	@override String get edit => 'Edit';
	@override String get add => 'Add';
	@override String get search => 'Search';
	@override String get filter => 'Filter';
	@override String get sort => 'Sort';
	@override String get refresh => 'Refresh';
	@override String get more => 'More';
	@override String get less => 'Less';
	@override String get all => 'All';
	@override String get none => 'None';
	@override String get ok => 'OK';
	@override String get unknown => 'Unknown';
	@override String get noData => 'No Data';
	@override String get loadMore => 'Load More';
	@override String get noMore => 'No More';
	@override String get loadFailed => 'Loading failed';
	@override String get history => 'Transactions';
	@override String get reset => 'Reset';
}

// Path: time
class _TranslationsTimeEn extends TranslationsTimeZh {
	_TranslationsTimeEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get today => 'Today';
	@override String get yesterday => 'Yesterday';
	@override String get dayBeforeYesterday => 'Day Before Yesterday';
	@override String get thisWeek => 'Week';
	@override String get thisMonth => 'Month';
	@override String get thisYear => 'Year';
	@override String get selectDate => 'Select Date';
	@override String get selectTime => 'Select Time';
	@override String get justNow => 'Just now';
	@override String minutesAgo({required Object count}) => '${count}m ago';
	@override String hoursAgo({required Object count}) => '${count}h ago';
	@override String daysAgo({required Object count}) => '${count}d ago';
	@override String weeksAgo({required Object count}) => '${count}w ago';
}

// Path: greeting
class _TranslationsGreetingEn extends TranslationsGreetingZh {
	_TranslationsGreetingEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get morning => 'Good Morning';
	@override String get afternoon => 'Good Afternoon';
	@override String get evening => 'Good Evening';
}

// Path: navigation
class _TranslationsNavigationEn extends TranslationsNavigationZh {
	_TranslationsNavigationEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get home => 'Home';
	@override String get forecast => 'Forecast';
	@override String get footprint => 'Footprint';
	@override String get profile => 'Profile';
}

// Path: auth
class _TranslationsAuthEn extends TranslationsAuthZh {
	_TranslationsAuthEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get login => 'Log In';
	@override String get loggingIn => 'Logging in...';
	@override String get logout => 'Log Out';
	@override String get logoutSuccess => 'Logged out successfully';
	@override String get confirmLogoutTitle => 'Confirm Logout';
	@override String get confirmLogoutContent => 'Are you sure you want to log out?';
	@override String get register => 'Sign Up';
	@override String get registering => 'Signing up...';
	@override String get welcomeBack => 'Welcome Back';
	@override String get loginSuccess => 'Welcome back!';
	@override String get loginFailed => 'Login Failed';
	@override String get pleaseTryAgain => 'Please try again later.';
	@override String get loginSubtitle => 'Log in to continue using Augo';
	@override String get noAccount => 'Don\'t have an account? Sign Up';
	@override String get createAccount => 'Create Your Account';
	@override String get setPassword => 'Set Password';
	@override String get setAccountPassword => 'Set Your Account Password';
	@override String get completeRegistration => 'Complete Registration';
	@override String get registrationSuccess => 'Registration successful!';
	@override String get registrationFailed => 'Registration failed';
	@override late final _TranslationsAuthEmailEn email = _TranslationsAuthEmailEn._(_root);
	@override late final _TranslationsAuthPasswordEn password = _TranslationsAuthPasswordEn._(_root);
	@override late final _TranslationsAuthVerificationCodeEn verificationCode = _TranslationsAuthVerificationCodeEn._(_root);
}

// Path: transaction
class _TranslationsTransactionEn extends TranslationsTransactionZh {
	_TranslationsTransactionEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get expense => 'Expense';
	@override String get income => 'Income';
	@override String get transfer => 'Transfer';
	@override String get amount => 'Amount';
	@override String get category => 'Category';
	@override String get description => 'Description';
	@override String get tags => 'Tags';
	@override String get saveTransaction => 'Save Transaction';
	@override String get pleaseEnterAmount => 'Please enter amount';
	@override String get pleaseSelectCategory => 'Please select category';
	@override String get saveFailed => 'Failed to save';
	@override String get descriptionHint => 'Record details of this transaction...';
	@override String get addCustomTag => 'Add Custom Tag';
	@override String get commonTags => 'Common Tags';
	@override String maxTagsHint({required Object maxTags}) => 'Maximum ${maxTags} tags allowed';
	@override String get noTransactionsFound => 'No transactions found';
	@override String get tryAdjustingSearch => 'Try adjusting search criteria or create new transactions';
	@override String get noDescription => 'No description';
	@override String get payment => 'Payment';
	@override String get account => 'Account';
	@override String get time => 'Time';
	@override String get location => 'Location';
	@override String get transactionDetail => 'Transaction Details';
	@override String get favorite => 'Favorite';
	@override String get confirmDelete => 'Confirm Delete';
	@override String get deleteTransactionConfirm => 'Are you sure you want to delete this transaction? This action cannot be undone.';
	@override String get noActions => 'No actions available';
	@override String get deleted => 'Deleted';
	@override String get deleteFailed => 'Delete failed, please try again';
	@override String get linkedAccount => 'Linked Account';
	@override String get linkedSpace => 'Linked Space';
	@override String get notLinked => 'Not linked';
	@override String get link => 'Link';
	@override String get changeAccount => 'Change Account';
	@override String get addSpace => 'Add Space';
	@override String nSpaces({required Object count}) => '${count} spaces';
	@override String get selectLinkedAccount => 'Select Linked Account';
	@override String get selectLinkedSpace => 'Select Linked Space';
	@override String get noSpacesAvailable => 'No spaces available';
	@override String get linkSuccess => 'Link successful';
	@override String get linkFailed => 'Link failed';
	@override String get rawInput => 'Message';
	@override String get noRawInput => 'No message';
}

// Path: home
class _TranslationsHomeEn extends TranslationsHomeZh {
	_TranslationsHomeEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get totalExpense => 'Total Expense';
	@override String get todayExpense => 'Today\'s';
	@override String get monthExpense => 'This Month\'s';
	@override String yearProgress({required Object year}) => '${year} Progress';
	@override String get amountHidden => '••••••••';
	@override String get loadFailed => 'Load failed';
	@override String get noTransactions => 'No transactions';
	@override String get tryRefresh => 'Pull to refresh';
	@override String get noMoreData => 'No more data';
	@override String get userNotLoggedIn => 'User not logged in';
}

// Path: comment
class _TranslationsCommentEn extends TranslationsCommentZh {
	_TranslationsCommentEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get error => 'Error';
	@override String get commentFailed => 'Comment failed';
	@override String replyToPrefix({required Object name}) => 'Reply to @${name}:';
	@override String get reply => 'Reply';
	@override String get addNote => 'Add a note...';
	@override String get confirmDeleteTitle => 'Confirm Delete';
	@override String get confirmDeleteContent => 'Are you sure you want to delete this comment? This action cannot be undone.';
	@override String get success => 'Success';
	@override String get commentDeleted => 'Comment deleted';
	@override String get deleteFailed => 'Failed to delete';
	@override String get deleteComment => 'Delete Comment';
	@override String get hint => 'Hint';
	@override String get noActions => 'No actions available';
	@override String get note => 'Note';
	@override String get noNote => 'No notes yet';
	@override String get loadFailed => 'Failed to load notes';
}

// Path: calendar
class _TranslationsCalendarEn extends TranslationsCalendarZh {
	_TranslationsCalendarEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Expense Calendar';
	@override late final _TranslationsCalendarWeekdaysEn weekdays = _TranslationsCalendarWeekdaysEn._(_root);
	@override String get loadFailed => 'Failed to load calendar data';
	@override String thisMonth({required Object amount}) => 'Month: ${amount}';
	@override String get counting => 'Counting...';
	@override String get unableToCount => 'Unable to count';
	@override String get trend => 'Trend: ';
	@override String get noTransactionsTitle => 'No transactions on this day';
	@override String get loadTransactionFailed => 'Failed to load transactions';
}

// Path: category
class _TranslationsCategoryEn extends TranslationsCategoryZh {
	_TranslationsCategoryEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get dailyConsumption => 'Daily Expenses';
	@override String get transportation => 'Transportation';
	@override String get healthcare => 'Healthcare';
	@override String get housing => 'Housing & Utilities';
	@override String get education => 'Education';
	@override String get incomeCategory => 'Income';
	@override String get socialGifts => 'Gifts & Donations';
	@override String get moneyTransfer => 'Transfers';
	@override String get other => 'Other';
	@override String get foodDining => 'Food & Dining';
	@override String get shoppingRetail => 'Shopping';
	@override String get housingUtilities => 'Housing & Utilities';
	@override String get personalCare => 'Personal Care';
	@override String get entertainment => 'Entertainment';
	@override String get medicalHealth => 'Medical & Health';
	@override String get insurance => 'Insurance';
	@override String get socialGifting => 'Social & Gifting';
	@override String get financialTax => 'Financial & Tax';
	@override String get others => 'Others';
	@override String get salaryWage => 'Salary';
	@override String get businessTrade => 'Business';
	@override String get investmentReturns => 'Investment Returns';
	@override String get giftBonus => 'Gift & Bonus';
	@override String get refundRebate => 'Refund';
	@override String get generalTransfer => 'Transfer';
	@override String get debtRepayment => 'Debt Repayment';
}

// Path: settings
class _TranslationsSettingsEn extends TranslationsSettingsZh {
	_TranslationsSettingsEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Settings';
	@override String get language => 'Language';
	@override String get languageSettings => 'Language Settings';
	@override String get selectLanguage => 'Select Language';
	@override String get languageChanged => 'Language Changed';
	@override String get restartToApply => 'Restart app to apply changes';
	@override String get theme => 'Theme';
	@override String get darkMode => 'Dark Mode';
	@override String get lightMode => 'Light Mode';
	@override String get systemMode => 'Follow System';
	@override String get developerOptions => 'Developer Options';
	@override String get authDebug => 'Auth Debug';
	@override String get authDebugSubtitle => 'View authentication status and debug info';
	@override String get fontTest => 'Font Test';
	@override String get fontTestSubtitle => 'Test application font display';
	@override String get helpAndFeedback => 'Help & Feedback';
	@override String get helpAndFeedbackSubtitle => 'Get help or provide feedback';
	@override String get aboutApp => 'About';
	@override String get aboutAppSubtitle => 'Version info and developer information';
	@override String currencyChangedRefreshHint({required Object currency}) => 'Switched to ${currency}. New transactions will use this currency.';
	@override String get sharedSpace => 'Shared Space';
	@override String get speechRecognition => 'Speech Recognition';
	@override String get speechRecognitionSubtitle => 'Configure voice input parameters';
	@override String get amountDisplayStyle => 'Amount Display Style';
	@override String get currency => 'Currency';
	@override String get appearance => 'Appearance Settings';
	@override String get appearanceSubtitle => 'Theme mode and color scheme';
	@override String get speechTest => 'Speech Test';
	@override String get speechTestSubtitle => 'Test WebSocket speech connection';
	@override String get userTypeRegular => 'Regular User';
	@override String get selectAmountStyle => 'Select Amount Display Style';
	@override String get amountStyleNotice => 'Note: Amount styles are primarily applied to \'Transactions\' and \'Trends\'. To maintain visual clarity, \'Account Balances\' and \'Asset Summaries\' will remain in neutral colors.';
	@override String get currencyDescription => 'Choose your preferred display currency. All amounts will be displayed in this currency.';
	@override String get editUsername => 'Edit Username';
	@override String get enterUsername => 'Enter username';
	@override String get usernameRequired => 'Username is required';
	@override String get usernameUpdated => 'Username updated';
	@override String get avatarUpdated => 'Avatar updated';
}

// Path: appearance
class _TranslationsAppearanceEn extends TranslationsAppearanceZh {
	_TranslationsAppearanceEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Appearance Settings';
	@override String get themeMode => 'Theme Mode';
	@override String get light => 'Light';
	@override String get dark => 'Dark';
	@override String get system => 'System';
	@override String get colorScheme => 'Color Scheme';
	@override late final _TranslationsAppearancePalettesEn palettes = _TranslationsAppearancePalettesEn._(_root);
}

// Path: speech
class _TranslationsSpeechEn extends TranslationsSpeechZh {
	_TranslationsSpeechEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Speech Recognition Settings';
	@override String get service => 'Speech Recognition Service';
	@override String get systemVoice => 'System Voice';
	@override String get systemVoiceSubtitle => 'Use built-in device service (Recommended)';
	@override String get selfHostedASR => 'Self-hosted ASR';
	@override String get selfHostedASRSubtitle => 'Use WebSocket connection to self-hosted service';
	@override String get serverConfig => 'Server Configuration';
	@override String get serverAddress => 'Server Address';
	@override String get port => 'Port';
	@override String get path => 'Path';
	@override String get saveConfig => 'Save Configuration';
	@override String get info => 'Information';
	@override String get infoContent => '• System Voice: Uses device service, no config needed, faster response\n• Self-hosted ASR: Suitable for custom models or offline scenarios\n\nChanges will take effect next time you use voice input.';
	@override String get enterAddress => 'Please enter server address';
	@override String get enterValidPort => 'Please enter a valid port (1-65535)';
	@override String get configSaved => 'Configuration saved';
}

// Path: amountTheme
class _TranslationsAmountThemeEn extends TranslationsAmountThemeZh {
	_TranslationsAmountThemeEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get chinaMarket => 'China Market Style';
	@override String get chinaMarketDesc => 'Red up, Green/Black down (Recommended)';
	@override String get international => 'International Standard';
	@override String get internationalDesc => 'Green up, Red down';
	@override String get minimalist => 'Minimalist';
	@override String get minimalistDesc => 'Distinguish with symbols only';
	@override String get colorBlind => 'Color Blind Friendly';
	@override String get colorBlindDesc => 'Blue-Orange color scheme';
}

// Path: locale
class _TranslationsLocaleEn extends TranslationsLocaleZh {
	_TranslationsLocaleEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get chinese => 'Simplified Chinese';
	@override String get english => 'English';
	@override String get japanese => 'Japanese';
	@override String get korean => 'Korean';
	@override String get traditionalChinese => 'Traditional Chinese';
}

// Path: budget
class _TranslationsBudgetEn extends TranslationsBudgetZh {
	_TranslationsBudgetEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Budget Management';
	@override String get detail => 'Budget Details';
	@override String get info => 'Budget Info';
	@override String get totalBudget => 'Total Budget';
	@override String get categoryBudget => 'Category Budget';
	@override String get monthlySummary => 'Monthly Budget Summary';
	@override String get used => 'Used';
	@override String get remaining => 'Remaining';
	@override String get overspent => 'Overspent';
	@override String get budget => 'Budget';
	@override String get loadFailed => 'Failed to load';
	@override String get noBudget => 'No budgets yet';
	@override String get createHint => 'Say "Help me set a budget" to your Augo assistant';
	@override String get paused => 'Paused';
	@override String get pause => 'Pause';
	@override String get resume => 'Resume';
	@override String get budgetPaused => 'Budget paused';
	@override String get budgetResumed => 'Budget resumed';
	@override String get operationFailed => 'Operation failed';
	@override String get deleteBudget => 'Delete Budget';
	@override String get deleteConfirm => 'Are you sure you want to delete this budget? This cannot be undone.';
	@override String get type => 'Type';
	@override String get category => 'Category';
	@override String get period => 'Repeat Rule';
	@override String get rollover => 'Rollover';
	@override String get rolloverBalance => 'Rollover Balance';
	@override String get enabled => 'Enabled';
	@override String get disabled => 'Disabled';
	@override String get statusNormal => 'On Track';
	@override String get statusWarning => 'Near Limit';
	@override String get statusOverspent => 'Overspent';
	@override String get statusAchieved => 'Goal Achieved';
	@override String tipNormal({required Object amount}) => '${amount} remaining';
	@override String tipWarning({required Object amount}) => 'Only ${amount} left, be careful';
	@override String tipOverspent({required Object amount}) => 'Overspent by ${amount}';
	@override String get tipAchieved => 'Congratulations on achieving your savings goal!';
	@override String remainingAmount({required Object amount}) => '${amount} remaining';
	@override String overspentAmount({required Object amount}) => 'Overspent ${amount}';
	@override String budgetAmount({required Object amount}) => 'Budget ${amount}';
	@override String get active => 'Active';
	@override String get all => 'All';
	@override String get notFound => 'Budget not found or deleted';
	@override String get setup => 'Budget Setup';
	@override String get settings => 'Budget Settings';
	@override String get setAmount => 'Set Budget Amount';
	@override String get setAmountDesc => 'Set budget amount for each category';
	@override String get monthly => 'Monthly Budget';
	@override String get monthlyDesc => 'Manage expenses monthly, suitable for most users';
	@override String get weekly => 'Weekly Budget';
	@override String get weeklyDesc => 'Manage expenses weekly for finer control';
	@override String get yearly => 'Annual Budget';
	@override String get yearlyDesc => 'Long-term financial planning for major expenses';
	@override String get editBudget => 'Edit Budget';
	@override String get editBudgetDesc => 'Modify budget amounts and categories';
	@override String get reminderSettings => 'Reminder Settings';
	@override String get reminderSettingsDesc => 'Set budget reminders and notifications';
	@override String get report => 'Budget Report';
	@override String get reportDesc => 'View detailed budget analysis reports';
	@override String get welcome => 'Welcome to Budget Feature!';
	@override String get createNewPlan => 'Create New Budget Plan';
	@override String get welcomeDesc => 'Set budgets to better control spending and achieve financial goals. Let\'s start setting up your first budget plan!';
	@override String get createDesc => 'Set budget limits for different spending categories to manage your finances better.';
	@override String get newBudget => 'New Budget';
	@override String get budgetAmountLabel => 'Budget Amount';
	@override String get currency => 'Currency';
	@override String get periodSettings => 'Period Settings';
	@override String get autoGenerateTransactions => 'Automatically generate transactions by rule';
	@override String get cycle => 'Cycle';
	@override String get budgetCategory => 'Budget Category';
	@override String get advancedOptions => 'Advanced Options';
	@override String get periodType => 'Period Type';
	@override String get anchorDay => 'Anchor Day';
	@override String get selectPeriodType => 'Select Period Type';
	@override String get selectAnchorDay => 'Select Anchor Day';
	@override String get rolloverDescription => 'Carry over unused budget to next period';
	@override String get createBudget => 'Create Budget';
	@override String get save => 'Save';
	@override String get pleaseEnterAmount => 'Please enter budget amount';
	@override String get invalidAmount => 'Please enter a valid amount';
	@override String get updateSuccess => 'Budget updated successfully';
	@override String get createSuccess => 'Budget created successfully';
	@override String get deleteSuccess => 'Budget deleted';
	@override String get deleteFailed => 'Delete failed';
	@override String everyMonthDay({required Object day}) => 'Day ${day} of each month';
	@override String get periodWeekly => 'Weekly';
	@override String get periodBiweekly => 'Biweekly';
	@override String get periodMonthly => 'Monthly';
	@override String get periodYearly => 'Yearly';
	@override String get statusActive => 'Active';
	@override String get statusArchived => 'Archived';
	@override String get periodStatusOnTrack => 'On Track';
	@override String get periodStatusWarning => 'Warning';
	@override String get periodStatusExceeded => 'Exceeded';
	@override String get periodStatusAchieved => 'Achieved';
	@override String usedPercent({required Object percent}) => '${percent}% used';
	@override String dayOfMonth({required Object day}) => 'Day ${day}';
	@override String get tenThousandSuffix => '0k';
}

// Path: dateRange
class _TranslationsDateRangeEn extends TranslationsDateRangeZh {
	_TranslationsDateRangeEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get custom => 'Custom';
	@override String get pickerTitle => 'Select Date Range';
	@override String get startDate => 'Start Date';
	@override String get endDate => 'End Date';
	@override String get hint => 'Please select a date range';
}

// Path: forecast
class _TranslationsForecastEn extends TranslationsForecastZh {
	_TranslationsForecastEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Forecast';
	@override String get subtitle => 'AI-powered cash flow predictions based on your financial data';
	@override String get financialNavigator => 'Hello, I\'m your Financial Navigator';
	@override String get financialMapSubtitle => 'In just 3 steps, let\'s map your financial future together';
	@override String get predictCashFlow => 'Predict Cash Flow';
	@override String get predictCashFlowDesc => 'See your daily financial status';
	@override String get aiSmartSuggestions => 'AI Smart Suggestions';
	@override String get aiSmartSuggestionsDesc => 'Personalized financial decision guidance';
	@override String get riskWarning => 'Risk Alerts';
	@override String get riskWarningDesc => 'Detect potential financial risks early';
	@override String get analyzing => 'Analyzing your financial data to generate a 30-day cash flow forecast';
	@override String get analyzePattern => 'Analyzing income & expense patterns';
	@override String get calculateTrend => 'Calculating cash flow trends';
	@override String get generateWarning => 'Generating risk alerts';
	@override String get loadingForecast => 'Loading financial forecast...';
	@override String get todayLabel => 'Today';
	@override String get tomorrowLabel => 'Tomorrow';
	@override String get balanceLabel => 'Balance';
	@override String get noSpecialEvents => 'No special events';
	@override String get financialSafetyLine => 'Financial Safety Net';
	@override String get currentSetting => 'Current Setting';
	@override String get dailySpendingEstimate => 'Daily Spending Estimate';
	@override String get adjustDailySpendingAmount => 'Adjust daily spending forecast amount';
	@override String get tellMeYourSafetyLine => 'What\'s your financial safety threshold?';
	@override String get safetyLineDescription => 'This is the minimum balance you want to maintain. I\'ll alert you when your balance approaches this amount.';
	@override String get dailySpendingQuestion => 'How much do you spend daily?';
	@override String get dailySpendingDescription => 'Including meals, transportation, shopping and other daily expenses\nThis is just an initial estimate - predictions will improve with your actual records';
	@override String get perDay => 'per day';
	@override String get referenceStandard => 'Reference';
	@override String get frugalType => 'Frugal';
	@override String get comfortableType => 'Comfortable';
	@override String get relaxedType => 'Relaxed';
	@override String get frugalAmount => '¥50-100/day';
	@override String get comfortableAmount => '¥100-200/day';
	@override String get relaxedAmount => '¥200-300/day';
	@override late final _TranslationsForecastRecurringTransactionEn recurringTransaction = _TranslationsForecastRecurringTransactionEn._(_root);
}

// Path: chat
class _TranslationsChatEn extends TranslationsChatZh {
	_TranslationsChatEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get newChat => 'New Chat';
	@override String get noMessages => 'No messages to display.';
	@override String get loadingFailed => 'Loading failed';
	@override String get inputMessage => 'Type a message...';
	@override String get aiThinking => 'AI processing...';
	@override String get listening => 'Listening...';
	@override late final _TranslationsChatToolsEn tools = _TranslationsChatToolsEn._(_root);
	@override String get speechNotRecognized => 'Speech not recognized, please try again';
	@override String get currentExpense => 'Session Expense';
	@override String get loadingComponent => 'Loading component...';
	@override String get noHistory => 'No historical sessions';
	@override String get startNewChat => 'Start a new conversation!';
	@override String get searchHint => 'Search conversations';
	@override String get library => 'Library';
	@override String get viewProfile => 'View profile';
	@override String get noRelatedFound => 'No related conversations found';
	@override String get tryOtherKeywords => 'Try searching with other keywords';
	@override String get searchFailed => 'Search failed';
	@override String get deleteConversation => 'Delete Conversation';
	@override String get deleteConversationConfirm => 'Are you sure you want to delete this conversation? This action cannot be undone.';
	@override String get conversationDeleted => 'Conversation deleted';
	@override String get deleteConversationFailed => 'Failed to delete conversation';
	@override late final _TranslationsChatTransferWizardEn transferWizard = _TranslationsChatTransferWizardEn._(_root);
	@override late final _TranslationsChatGenuiEn genui = _TranslationsChatGenuiEn._(_root);
	@override late final _TranslationsChatWelcomeEn welcome = _TranslationsChatWelcomeEn._(_root);
}

// Path: footprint
class _TranslationsFootprintEn extends TranslationsFootprintZh {
	_TranslationsFootprintEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get searchIn => 'Search';
	@override String get searchInAllRecords => 'Search in all records';
}

// Path: media
class _TranslationsMediaEn extends TranslationsMediaZh {
	_TranslationsMediaEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get selectPhotos => 'Select Photos';
	@override String get addFiles => 'Add Files';
	@override String get takePhoto => 'Take Photo';
	@override String get camera => 'Camera';
	@override String get photos => 'Photos';
	@override String get files => 'Files';
	@override String get showAll => 'Show All';
	@override String get allPhotos => 'All Photos';
	@override String get takingPhoto => 'Taking photo...';
	@override String get photoTaken => 'Photo saved';
	@override String get cameraPermissionRequired => 'Camera permission required';
	@override String get fileSizeExceeded => 'File size exceeds 10MB limit';
	@override String get unsupportedFormat => 'Unsupported file format';
	@override String get permissionDenied => 'Photo library access required';
	@override String get storageInsufficient => 'Insufficient storage space';
	@override String get networkError => 'Network connection error';
	@override String get unknownUploadError => 'Unknown error during upload';
}

// Path: error
class _TranslationsErrorEn extends TranslationsErrorZh {
	_TranslationsErrorEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get permissionRequired => 'Permission Required';
	@override String get permissionInstructions => 'Please enable photo library and storage permissions in Settings to select and upload files.';
	@override String get openSettings => 'Open Settings';
	@override String get fileTooLarge => 'File Too Large';
	@override String get fileSizeHint => 'Please select files under 10MB, or compress before uploading.';
	@override String get supportedFormatsHint => 'Supported formats: images (jpg, png, gif), documents (pdf, doc, txt), audio/video files.';
	@override String get storageCleanupHint => 'Please free up storage space and try again, or select smaller files.';
	@override String get networkErrorHint => 'Please check your network connection and try again.';
	@override String get platformNotSupported => 'Platform Not Supported';
	@override String get fileReadError => 'File Read Error';
	@override String get fileReadErrorHint => 'The file may be corrupted or in use. Please select a different file.';
	@override String get validationError => 'File Validation Error';
	@override String get unknownError => 'Unknown Error';
	@override String get unknownErrorHint => 'An unexpected error occurred. Please try again or contact support.';
	@override late final _TranslationsErrorGenuiEn genui = _TranslationsErrorGenuiEn._(_root);
}

// Path: fontTest
class _TranslationsFontTestEn extends TranslationsFontTestZh {
	_TranslationsFontTestEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get page => 'Font Test Page';
	@override String get displayTest => 'Font Display Test';
	@override String get chineseTextTest => 'Chinese Text Test';
	@override String get englishTextTest => 'English Text Test';
	@override String get sample1 => 'This is a sample text for testing font display effects.';
	@override String get sample2 => 'Expense category summary, shopping is highest';
	@override String get sample3 => 'AI assistant provides professional financial analysis services';
	@override String get sample4 => 'Data visualization charts show your spending trends';
	@override String get sample5 => 'WeChat Pay, Alipay, bank cards and other payment methods';
}

// Path: wizard
class _TranslationsWizardEn extends TranslationsWizardZh {
	_TranslationsWizardEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get nextStep => 'Next';
	@override String get previousStep => 'Previous';
	@override String get completeMapping => 'Complete';
}

// Path: user
class _TranslationsUserEn extends TranslationsUserZh {
	_TranslationsUserEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get username => 'Username';
	@override String get defaultEmail => 'user@example.com';
}

// Path: account
class _TranslationsAccountEn extends TranslationsAccountZh {
	_TranslationsAccountEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get editTitle => 'Edit Account';
	@override String get addTitle => 'New Account';
	@override String get selectTypeTitle => 'Select Account Type';
	@override String get nameLabel => 'Account Name';
	@override String get amountLabel => 'Current Balance';
	@override String get currencyLabel => 'Currency';
	@override String get hiddenLabel => 'Hidden';
	@override String get hiddenDesc => 'Hide this account from the list';
	@override String get includeInNetWorthLabel => 'Include in Net Worth';
	@override String get includeInNetWorthDesc => 'Count towards total net worth';
	@override String get nameHint => 'e.g. Salary Card';
	@override String get amountHint => '0.00';
	@override String get deleteAccount => 'Delete Account';
	@override String get deleteConfirm => 'Are you sure you want to delete this account? This cannot be undone.';
	@override String get save => 'Save Changes';
	@override String get assetsCategory => 'Assets';
	@override String get liabilitiesCategory => 'Liabilities/Credit';
	@override String get cash => 'Cash Wallet';
	@override String get deposit => 'Bank Deposit';
	@override String get creditCard => 'Credit Card';
	@override String get investment => 'Investment';
	@override String get eWallet => 'E-Wallet';
	@override String get loan => 'Loan';
	@override String get receivable => 'Receivable';
	@override String get payable => 'Payable';
	@override String get other => 'Other';
	@override late final _TranslationsAccountTypesEn types = _TranslationsAccountTypesEn._(_root);
}

// Path: financial
class _TranslationsFinancialEn extends TranslationsFinancialZh {
	_TranslationsFinancialEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Financial';
	@override String get management => 'Financial Management';
	@override String get netWorth => 'Total Net Worth';
	@override String get assets => 'Total Assets';
	@override String get liabilities => 'Total Liabilities';
	@override String get noAccounts => 'No accounts yet';
	@override String get addFirstAccount => 'Tap the button below to add your first account';
	@override String get assetAccounts => 'Asset Accounts';
	@override String get liabilityAccounts => 'Liability Accounts';
	@override String get selectCurrency => 'Select Currency';
	@override String get cancel => 'Cancel';
	@override String get confirm => 'Confirm';
	@override String get settings => 'Financial Settings';
	@override String get budgetManagement => 'Budget Management';
	@override String get recurringTransactions => 'Recurring Transactions';
	@override String get safetyThreshold => 'Safety Threshold';
	@override String get dailyBurnRate => 'Daily Burn Rate';
	@override String get financialAssistant => 'Financial Assistant';
	@override String get manageFinancialSettings => 'Manage your financial settings';
	@override String get safetyThresholdSettings => 'Safety Threshold Settings';
	@override String get setSafetyThreshold => 'Set your financial safety threshold';
	@override String get safetyThresholdSaved => 'Safety threshold saved';
	@override String get dailyBurnRateSettings => 'Daily Burn Rate';
	@override String get setDailyBurnRate => 'Set your estimated daily spending';
	@override String get dailyBurnRateSaved => 'Daily burn rate saved';
	@override String get saveFailed => 'Save failed';
}

// Path: app
class _TranslationsAppEn extends TranslationsAppZh {
	_TranslationsAppEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get splashTitle => 'Augo: Intelligence that Grows.';
	@override String get splashSubtitle => 'Smart Financial Assistant';
}

// Path: statistics
class _TranslationsStatisticsEn extends TranslationsStatisticsZh {
	_TranslationsStatisticsEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Analysis';
	@override String get analyze => 'Analysis';
	@override String get exportInProgress => 'Export feature coming soon...';
	@override String get ranking => 'Top Spending';
	@override String get noData => 'No data available';
	@override late final _TranslationsStatisticsOverviewEn overview = _TranslationsStatisticsOverviewEn._(_root);
	@override late final _TranslationsStatisticsTrendEn trend = _TranslationsStatisticsTrendEn._(_root);
	@override late final _TranslationsStatisticsAnalysisEn analysis = _TranslationsStatisticsAnalysisEn._(_root);
	@override late final _TranslationsStatisticsFilterEn filter = _TranslationsStatisticsFilterEn._(_root);
	@override late final _TranslationsStatisticsSortEn sort = _TranslationsStatisticsSortEn._(_root);
	@override String get exportList => 'Export List';
	@override late final _TranslationsStatisticsEmptyStateEn emptyState = _TranslationsStatisticsEmptyStateEn._(_root);
	@override String get noMoreData => 'No more data';
}

// Path: currency
class _TranslationsCurrencyEn extends TranslationsCurrencyZh {
	_TranslationsCurrencyEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get cny => 'Chinese Yuan';
	@override String get usd => 'US Dollar';
	@override String get eur => 'Euro';
	@override String get jpy => 'Japanese Yen';
	@override String get gbp => 'British Pound';
	@override String get aud => 'Australian Dollar';
	@override String get cad => 'Canadian Dollar';
	@override String get chf => 'Swiss Franc';
	@override String get rub => 'Russian Ruble';
	@override String get hkd => 'Hong Kong Dollar';
	@override String get twd => 'New Taiwan Dollar';
	@override String get inr => 'Indian Rupee';
}

// Path: budgetSuggestion
class _TranslationsBudgetSuggestionEn extends TranslationsBudgetSuggestionZh {
	_TranslationsBudgetSuggestionEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String highPercentage({required Object category, required Object percentage}) => '${category} accounts for ${percentage}% of spending. Consider setting a budget limit.';
	@override String monthlyIncrease({required Object percentage}) => 'Spending increased by ${percentage}% this month. Needs attention.';
	@override String frequentSmall({required Object category, required Object count}) => '${category} has ${count} small transactions. These might be subscriptions.';
	@override String get financialInsights => 'Financial Insights';
}

// Path: server
class _TranslationsServerEn extends TranslationsServerZh {
	_TranslationsServerEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Connect to Server';
	@override String get subtitle => 'Enter your self-hosted server address or scan the QR code displayed when starting the server';
	@override String get urlLabel => 'Server Address';
	@override String get urlPlaceholder => 'e.g. https://api.example.com or 192.168.1.100:8000';
	@override String get scanQr => 'Scan QR Code';
	@override String get scanQrInstruction => 'Point at the QR code displayed in the server terminal';
	@override String get testConnection => 'Test Connection';
	@override String get connecting => 'Connecting...';
	@override String get connected => 'Connected';
	@override String get connectionFailed => 'Connection Failed';
	@override String get continueToLogin => 'Continue to Login';
	@override String get saveAndReturn => 'Save and Return';
	@override String get serverSettings => 'Server Settings';
	@override String get currentServer => 'Current Server';
	@override String get version => 'Version';
	@override String get environment => 'Environment';
	@override String get changeServer => 'Change Server';
	@override String get changeServerWarning => 'Changing server will log you out. Continue?';
	@override late final _TranslationsServerErrorEn error = _TranslationsServerErrorEn._(_root);
}

// Path: sharedSpace
class _TranslationsSharedSpaceEn extends TranslationsSharedSpaceZh {
	_TranslationsSharedSpaceEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSharedSpaceDashboardEn dashboard = _TranslationsSharedSpaceDashboardEn._(_root);
	@override late final _TranslationsSharedSpaceRolesEn roles = _TranslationsSharedSpaceRolesEn._(_root);
}

// Path: errorMapping
class _TranslationsErrorMappingEn extends TranslationsErrorMappingZh {
	_TranslationsErrorMappingEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsErrorMappingGenericEn generic = _TranslationsErrorMappingGenericEn._(_root);
	@override late final _TranslationsErrorMappingAuthEn auth = _TranslationsErrorMappingAuthEn._(_root);
	@override late final _TranslationsErrorMappingTransactionEn transaction = _TranslationsErrorMappingTransactionEn._(_root);
	@override late final _TranslationsErrorMappingSpaceEn space = _TranslationsErrorMappingSpaceEn._(_root);
	@override late final _TranslationsErrorMappingRecurringEn recurring = _TranslationsErrorMappingRecurringEn._(_root);
	@override late final _TranslationsErrorMappingUploadEn upload = _TranslationsErrorMappingUploadEn._(_root);
	@override late final _TranslationsErrorMappingAiEn ai = _TranslationsErrorMappingAiEn._(_root);
}

// Path: auth.email
class _TranslationsAuthEmailEn extends TranslationsAuthEmailZh {
	_TranslationsAuthEmailEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get label => 'Email';
	@override String get placeholder => 'Enter your email';
	@override String get required => 'Email is required';
	@override String get invalid => 'Please enter a valid email address';
}

// Path: auth.password
class _TranslationsAuthPasswordEn extends TranslationsAuthPasswordZh {
	_TranslationsAuthPasswordEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get label => 'Password';
	@override String get placeholder => 'Enter your password';
	@override String get required => 'Password is required';
	@override String get tooShort => 'Password must be at least 6 characters';
	@override String get mustContainNumbersAndLetters => 'Password must contain both numbers and letters';
	@override String get confirm => 'Confirm Password';
	@override String get confirmPlaceholder => 'Re-enter your password';
	@override String get mismatch => 'Passwords do not match';
}

// Path: auth.verificationCode
class _TranslationsAuthVerificationCodeEn extends TranslationsAuthVerificationCodeZh {
	_TranslationsAuthVerificationCodeEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get label => 'Verification Code';
	@override String get get => 'Get Code';
	@override String get sending => 'Sending...';
	@override String get sent => 'Code sent';
	@override String get sendFailed => 'Failed to send';
	@override String get placeholder => 'Optional for now, enter anything';
	@override String get required => 'Verification code is required';
}

// Path: calendar.weekdays
class _TranslationsCalendarWeekdaysEn extends TranslationsCalendarWeekdaysZh {
	_TranslationsCalendarWeekdaysEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get mon => 'M';
	@override String get tue => 'T';
	@override String get wed => 'W';
	@override String get thu => 'T';
	@override String get fri => 'F';
	@override String get sat => 'S';
	@override String get sun => 'S';
}

// Path: appearance.palettes
class _TranslationsAppearancePalettesEn extends TranslationsAppearancePalettesZh {
	_TranslationsAppearancePalettesEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get zinc => 'Zinc';
	@override String get slate => 'Slate';
	@override String get red => 'Red';
	@override String get rose => 'Rose';
	@override String get orange => 'Orange';
	@override String get green => 'Green';
	@override String get blue => 'Blue';
	@override String get yellow => 'Yellow';
	@override String get violet => 'Violet';
}

// Path: forecast.recurringTransaction
class _TranslationsForecastRecurringTransactionEn extends TranslationsForecastRecurringTransactionZh {
	_TranslationsForecastRecurringTransactionEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Recurring Transactions';
	@override String get all => 'All';
	@override String get expense => 'Expense';
	@override String get income => 'Income';
	@override String get transfer => 'Transfer';
	@override String get noRecurring => 'No recurring transactions';
	@override String get createHint => 'The system will automatically generate transactions after you create recurring rules';
	@override String get create => 'Create Recurring Transaction';
	@override String get edit => 'Edit Recurring Transaction';
	@override String get newTransaction => 'New Recurring Transaction';
	@override String deleteConfirm({required Object name}) => 'Are you sure you want to delete recurring transaction "${name}"? This cannot be undone.';
	@override String activateConfirm({required Object name}) => 'Are you sure you want to activate recurring transaction "${name}"? It will automatically generate transactions.';
	@override String pauseConfirm({required Object name}) => 'Are you sure you want to pause recurring transaction "${name}"? No transactions will be generated while paused.';
	@override String get created => 'Recurring transaction created';
	@override String get updated => 'Recurring transaction updated';
	@override String get activated => 'Activated';
	@override String get paused => 'Paused';
	@override String get nextTime => 'Next';
	@override String get sortByTime => 'Sort by time';
	@override String get allPeriod => 'All recurring';
	@override String periodCount({required Object type, required Object count}) => '${type} recurring (${count})';
	@override String get confirmDelete => 'Confirm Delete';
	@override String get confirmActivate => 'Confirm Activate';
	@override String get confirmPause => 'Confirm Pause';
	@override String get dynamicAmount => 'Est. Avg';
	@override String get dynamicAmountTitle => 'Amount Requires Confirmation';
	@override String get dynamicAmountDescription => 'System will send a reminder on the due date. You need to manually confirm the amount before recording.';
}

// Path: chat.tools
class _TranslationsChatToolsEn extends TranslationsChatToolsZh {
	_TranslationsChatToolsEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get processing => 'Processing...';
	@override String get readFile => 'Reading file...';
	@override String get searchTransactions => 'Searching transactions...';
	@override String get queryBudgetStatus => 'Checking budget...';
	@override String get createBudget => 'Creating budget plan...';
	@override String get getCashFlowAnalysis => 'Analyzing cash flow...';
	@override String get getFinancialHealthScore => 'Calculating financial health score...';
	@override String get getFinancialSummary => 'Generating financial report...';
	@override String get evaluateFinancialHealth => 'Evaluating financial health...';
	@override String get forecastBalance => 'Forecasting future balance...';
	@override String get simulateExpenseImpact => 'Simulating purchase impact...';
	@override String get recordTransactions => 'Recording transactions...';
	@override String get createTransaction => 'Recording transaction...';
	@override String get duckduckgoSearch => 'Searching the web...';
	@override String get executeTransfer => 'Executing transfer...';
	@override String get listDir => 'Browsing directory...';
	@override String get execute => 'Processing...';
	@override String get analyzeFinance => 'Analyzing finances...';
	@override String get forecastFinance => 'Forecasting finances...';
	@override String get analyzeBudget => 'Analyzing budget...';
	@override String get auditAnalysis => 'Running audit analysis...';
	@override String get budgetOps => 'Processing budget...';
	@override String get createSharedTransaction => 'Creating shared expense...';
	@override String get listSpaces => 'Loading shared spaces...';
	@override String get querySpaceSummary => 'Querying space summary...';
	@override String get prepareTransfer => 'Preparing transfer...';
	@override String get unknown => 'Processing request...';
	@override late final _TranslationsChatToolsDoneEn done = _TranslationsChatToolsDoneEn._(_root);
	@override late final _TranslationsChatToolsFailedEn failed = _TranslationsChatToolsFailedEn._(_root);
	@override String get cancelled => 'Cancelled';
}

// Path: chat.transferWizard
class _TranslationsChatTransferWizardEn extends TranslationsChatTransferWizardZh {
	_TranslationsChatTransferWizardEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Transfer Wizard';
	@override String get amount => 'Transfer Amount';
	@override String get amountHint => 'Enter amount';
	@override String get sourceAccount => 'Source Account';
	@override String get targetAccount => 'Target Account';
	@override String get selectAccount => 'Select Account';
	@override String get confirmTransfer => 'Confirm Transfer';
	@override String get confirmed => 'Confirmed';
	@override String get transferSuccess => 'Transfer Successful';
}

// Path: chat.genui
class _TranslationsChatGenuiEn extends TranslationsChatGenuiZh {
	_TranslationsChatGenuiEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsChatGenuiExpenseSummaryEn expenseSummary = _TranslationsChatGenuiExpenseSummaryEn._(_root);
	@override late final _TranslationsChatGenuiTransactionListEn transactionList = _TranslationsChatGenuiTransactionListEn._(_root);
	@override late final _TranslationsChatGenuiTransactionGroupReceiptEn transactionGroupReceipt = _TranslationsChatGenuiTransactionGroupReceiptEn._(_root);
	@override late final _TranslationsChatGenuiBudgetReceiptEn budgetReceipt = _TranslationsChatGenuiBudgetReceiptEn._(_root);
	@override late final _TranslationsChatGenuiBudgetStatusCardEn budgetStatusCard = _TranslationsChatGenuiBudgetStatusCardEn._(_root);
	@override late final _TranslationsChatGenuiCashFlowForecastEn cashFlowForecast = _TranslationsChatGenuiCashFlowForecastEn._(_root);
	@override late final _TranslationsChatGenuiHealthScoreEn healthScore = _TranslationsChatGenuiHealthScoreEn._(_root);
	@override late final _TranslationsChatGenuiSpaceSelectorEn spaceSelector = _TranslationsChatGenuiSpaceSelectorEn._(_root);
	@override late final _TranslationsChatGenuiTransferPathEn transferPath = _TranslationsChatGenuiTransferPathEn._(_root);
	@override late final _TranslationsChatGenuiTransactionCardEn transactionCard = _TranslationsChatGenuiTransactionCardEn._(_root);
	@override late final _TranslationsChatGenuiCashFlowCardEn cashFlowCard = _TranslationsChatGenuiCashFlowCardEn._(_root);
}

// Path: chat.welcome
class _TranslationsChatWelcomeEn extends TranslationsChatWelcomeZh {
	_TranslationsChatWelcomeEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsChatWelcomeMorningEn morning = _TranslationsChatWelcomeMorningEn._(_root);
	@override late final _TranslationsChatWelcomeMiddayEn midday = _TranslationsChatWelcomeMiddayEn._(_root);
	@override late final _TranslationsChatWelcomeAfternoonEn afternoon = _TranslationsChatWelcomeAfternoonEn._(_root);
	@override late final _TranslationsChatWelcomeEveningEn evening = _TranslationsChatWelcomeEveningEn._(_root);
	@override late final _TranslationsChatWelcomeNightEn night = _TranslationsChatWelcomeNightEn._(_root);
}

// Path: error.genui
class _TranslationsErrorGenuiEn extends TranslationsErrorGenuiZh {
	_TranslationsErrorGenuiEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get loadingFailed => 'Component loading failed';
	@override String get schemaFailed => 'Schema validation failed';
	@override String get schemaDescription => 'Component definition does not comply with GenUI specifications, degraded to plain text display';
	@override String get networkError => 'Network error';
	@override String retryStatus({required Object retryCount, required Object maxRetries}) => 'Retried ${retryCount}/${maxRetries} times';
	@override String get maxRetriesReached => 'Maximum retry attempts reached';
}

// Path: account.types
class _TranslationsAccountTypesEn extends TranslationsAccountTypesZh {
	_TranslationsAccountTypesEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get cashTitle => 'Cash';
	@override String get cashSubtitle => 'Physical currency and coins';
	@override String get depositTitle => 'Bank Deposit';
	@override String get depositSubtitle => 'Savings, checking accounts';
	@override String get eMoneyTitle => 'E-Wallet';
	@override String get eMoneySubtitle => 'Digital payment balances';
	@override String get investmentTitle => 'Investment';
	@override String get investmentSubtitle => 'Stocks, funds, bonds, etc.';
	@override String get receivableTitle => 'Receivable';
	@override String get receivableSubtitle => 'Loans to others, pending';
	@override String get receivableHelper => 'Owed to me';
	@override String get creditCardTitle => 'Credit Card';
	@override String get creditCardSubtitle => 'Credit card balances';
	@override String get loanTitle => 'Loan';
	@override String get loanSubtitle => 'Mortgage, auto, personal';
	@override String get payableTitle => 'Payable';
	@override String get payableSubtitle => 'Amounts owed to others';
	@override String get payableHelper => 'I owe';
}

// Path: statistics.overview
class _TranslationsStatisticsOverviewEn extends TranslationsStatisticsOverviewZh {
	_TranslationsStatisticsOverviewEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get balance => 'Total Balance';
	@override String get income => 'Total Income';
	@override String get expense => 'Total Expense';
}

// Path: statistics.trend
class _TranslationsStatisticsTrendEn extends TranslationsStatisticsTrendZh {
	_TranslationsStatisticsTrendEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Trends';
	@override String get expense => 'Expense';
	@override String get income => 'Income';
}

// Path: statistics.analysis
class _TranslationsStatisticsAnalysisEn extends TranslationsStatisticsAnalysisZh {
	_TranslationsStatisticsAnalysisEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Analysis';
	@override String get total => 'Total';
	@override String get breakdown => 'Category Breakdown';
}

// Path: statistics.filter
class _TranslationsStatisticsFilterEn extends TranslationsStatisticsFilterZh {
	_TranslationsStatisticsFilterEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get accountType => 'Account Type';
	@override String get allAccounts => 'All Accounts';
	@override String get apply => 'Apply';
}

// Path: statistics.sort
class _TranslationsStatisticsSortEn extends TranslationsStatisticsSortZh {
	_TranslationsStatisticsSortEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get amount => 'By Amount';
	@override String get date => 'By Time';
}

// Path: statistics.emptyState
class _TranslationsStatisticsEmptyStateEn extends TranslationsStatisticsEmptyStateZh {
	_TranslationsStatisticsEmptyStateEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Unlock Financial Insights';
	@override String get description => 'Your financial report is currently a blank canvas.\nRecord your first transaction and let the data tell your story.';
	@override String get action => 'Record First Transaction';
}

// Path: server.error
class _TranslationsServerErrorEn extends TranslationsServerErrorZh {
	_TranslationsServerErrorEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get urlRequired => 'Server address is required';
	@override String get invalidUrl => 'Invalid URL format';
	@override String get connectionTimeout => 'Connection timed out';
	@override String get connectionRefused => 'Could not connect to server';
	@override String get sslError => 'SSL certificate error';
	@override String get serverError => 'Server error';
}

// Path: sharedSpace.dashboard
class _TranslationsSharedSpaceDashboardEn extends TranslationsSharedSpaceDashboardZh {
	_TranslationsSharedSpaceDashboardEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get cumulativeTotalExpense => 'Cumulative Total Expense';
	@override String get participatingMembers => 'Participating Members';
	@override String membersCount({required Object count}) => '${count} people';
	@override String get averagePerMember => 'Avg per member';
	@override String get spendingDistribution => 'Spending Distribution';
	@override String get realtimeUpdates => 'Real-time updates';
	@override String get paid => 'Paid';
}

// Path: sharedSpace.roles
class _TranslationsSharedSpaceRolesEn extends TranslationsSharedSpaceRolesZh {
	_TranslationsSharedSpaceRolesEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get owner => 'Owner';
	@override String get admin => 'Admin';
	@override String get member => 'Member';
}

// Path: errorMapping.generic
class _TranslationsErrorMappingGenericEn extends TranslationsErrorMappingGenericZh {
	_TranslationsErrorMappingGenericEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get badRequest => 'Bad Request';
	@override String get authFailed => 'Authentication failed, please login again';
	@override String get permissionDenied => 'Permission denied';
	@override String get notFound => 'Resource not found';
	@override String get serverError => 'Internal server error';
	@override String get systemError => 'System error';
	@override String get validationFailed => 'Validation failed';
}

// Path: errorMapping.auth
class _TranslationsErrorMappingAuthEn extends TranslationsErrorMappingAuthZh {
	_TranslationsErrorMappingAuthEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get failed => 'Authentication failed';
	@override String get emailWrong => 'Incorrect email';
	@override String get phoneWrong => 'Incorrect phone number';
	@override String get phoneRegistered => 'Phone number already registered';
	@override String get emailRegistered => 'Email already registered';
	@override String get sendFailed => 'Failed to send verification code';
	@override String get expired => 'Verification code expired';
	@override String get tooFrequent => 'Code sent too frequently';
	@override String get unsupportedType => 'Unsupported code type';
	@override String get wrongPassword => 'Incorrect password';
	@override String get userNotFound => 'User not found';
	@override String get prefsMissing => 'Preference parameters missing';
	@override String get invalidTimezone => 'Invalid client timezone';
}

// Path: errorMapping.transaction
class _TranslationsErrorMappingTransactionEn extends TranslationsErrorMappingTransactionZh {
	_TranslationsErrorMappingTransactionEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get commentEmpty => 'Comment content cannot be empty';
	@override String get invalidParent => 'Invalid parent comment ID';
	@override String get saveFailed => 'Failed to save comment';
	@override String get deleteFailed => 'Failed to delete comment';
	@override String get notExists => 'Transaction does not exist';
}

// Path: errorMapping.space
class _TranslationsErrorMappingSpaceEn extends TranslationsErrorMappingSpaceZh {
	_TranslationsErrorMappingSpaceEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get notFound => 'Shared space not found or access denied';
	@override String get inviteDenied => 'No permission to invite members';
	@override String get inviteSelf => 'Cannot invite yourself';
	@override String get inviteSent => 'Invitation sent';
	@override String get alreadyMember => 'User is already a member or invited';
	@override String get invalidAction => 'Invalid action';
	@override String get invitationNotFound => 'Invitation does not exist';
	@override String get onlyOwner => 'Only owner can perform this action';
	@override String get ownerNotRemovable => 'Owner cannot be removed';
	@override String get memberNotFound => 'Member not found';
	@override String get notMember => 'User is not a member of this space';
	@override String get ownerCantLeave => 'Owner cannot leave directly, please transfer ownership first';
	@override String get invalidCode => 'Invalid invitation code';
	@override String get codeExpired => 'Invitation code expired or usage limit reached';
}

// Path: errorMapping.recurring
class _TranslationsErrorMappingRecurringEn extends TranslationsErrorMappingRecurringZh {
	_TranslationsErrorMappingRecurringEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get invalidRule => 'Invalid recurrence rule';
	@override String get ruleNotFound => 'Recurrence rule not found';
}

// Path: errorMapping.upload
class _TranslationsErrorMappingUploadEn extends TranslationsErrorMappingUploadZh {
	_TranslationsErrorMappingUploadEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get noFile => 'No file uploaded';
	@override String get tooLarge => 'File too large';
	@override String get unsupportedType => 'Unsupported file type';
	@override String get tooManyFiles => 'Too many files';
}

// Path: errorMapping.ai
class _TranslationsErrorMappingAiEn extends TranslationsErrorMappingAiZh {
	_TranslationsErrorMappingAiEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get contextLimit => 'Context limit exceeded';
	@override String get tokenLimit => 'Insufficient tokens';
	@override String get emptyMessage => 'Empty user message';
}

// Path: chat.tools.done
class _TranslationsChatToolsDoneEn extends TranslationsChatToolsDoneZh {
	_TranslationsChatToolsDoneEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get readFile => 'Read file';
	@override String get searchTransactions => 'Searched transactions';
	@override String get queryBudgetStatus => 'Checked budget';
	@override String get createBudget => 'Created budget';
	@override String get getCashFlowAnalysis => 'Analyzed cash flow';
	@override String get getFinancialHealthScore => 'Calculated health score';
	@override String get getFinancialSummary => 'Financial report ready';
	@override String get evaluateFinancialHealth => 'Health evaluation complete';
	@override String get forecastBalance => 'Balance forecast ready';
	@override String get simulateExpenseImpact => 'Impact simulation complete';
	@override String get recordTransactions => 'Recorded transactions';
	@override String get createTransaction => 'Recorded transaction';
	@override String get duckduckgoSearch => 'Searched the web';
	@override String get executeTransfer => 'Transfer complete';
	@override String get listDir => 'Browsed directory';
	@override String get execute => 'Processing complete';
	@override String get analyzeFinance => 'Finance analysis complete';
	@override String get forecastFinance => 'Finance forecast complete';
	@override String get analyzeBudget => 'Budget analysis complete';
	@override String get auditAnalysis => 'Audit analysis complete';
	@override String get budgetOps => 'Budget processing complete';
	@override String get createSharedTransaction => 'Shared expense created';
	@override String get listSpaces => 'Shared spaces loaded';
	@override String get querySpaceSummary => 'Space summary ready';
	@override String get prepareTransfer => 'Transfer ready';
	@override String get unknown => 'Processing complete';
}

// Path: chat.tools.failed
class _TranslationsChatToolsFailedEn extends TranslationsChatToolsFailedZh {
	_TranslationsChatToolsFailedEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get unknown => 'Action failed';
}

// Path: chat.genui.expenseSummary
class _TranslationsChatGenuiExpenseSummaryEn extends TranslationsChatGenuiExpenseSummaryZh {
	_TranslationsChatGenuiExpenseSummaryEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get totalExpense => 'Total Expense';
	@override String get mainExpenses => 'Main Expenses';
	@override String viewAll({required Object count}) => 'View all ${count} transactions';
	@override String get details => 'Transaction Details';
}

// Path: chat.genui.transactionList
class _TranslationsChatGenuiTransactionListEn extends TranslationsChatGenuiTransactionListZh {
	_TranslationsChatGenuiTransactionListEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String searchResults({required Object count}) => 'Search Results (${count})';
	@override String loaded({required Object count}) => 'Loaded ${count}';
	@override String get noResults => 'No transactions found';
	@override String get loadMore => 'Scroll to load more';
	@override String get allLoaded => 'All loaded';
}

// Path: chat.genui.transactionGroupReceipt
class _TranslationsChatGenuiTransactionGroupReceiptEn extends TranslationsChatGenuiTransactionGroupReceiptZh {
	_TranslationsChatGenuiTransactionGroupReceiptEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Successfully';
	@override String count({required Object count}) => '${count} items';
	@override String get total => 'Total';
	@override String get selectAccount => 'Select Account';
	@override String get selectAccountSubtitle => 'This account will be applied to all transactions above';
	@override String associatedAccount({required Object name}) => 'Associated: ${name}';
	@override String get clickToAssociate => 'Click to associate account';
	@override String get associateSuccess => 'Successfully associated account to all transactions';
	@override String associateFailed({required Object error}) => 'Action failed: ${error}';
	@override String get accountAssociation => 'Account';
	@override String get sharedSpace => 'Shared Space';
	@override String get notAssociated => 'Not linked';
	@override String get addSpace => 'Add';
	@override String get selectSpace => 'Select Shared Space';
	@override String get spaceAssociateSuccess => 'Linked to shared space';
	@override String spaceAssociateFailed({required Object error}) => 'Failed to link: ${error}';
	@override String get currencyMismatchTitle => 'Currency Mismatch';
	@override String get currencyMismatchDesc => 'The transaction currency differs from the account currency. The account balance will be deducted at the exchange rate.';
	@override String get transactionAmount => 'Transaction Amount';
	@override String get accountCurrency => 'Account Currency';
	@override String get targetAccount => 'Target Account';
	@override String get currencyMismatchNote => 'Note: Account balance will be converted using current exchange rate';
	@override String get confirmAssociate => 'Confirm';
	@override String spaceCount({required Object count}) => '${count} spaces';
}

// Path: chat.genui.budgetReceipt
class _TranslationsChatGenuiBudgetReceiptEn extends TranslationsChatGenuiBudgetReceiptZh {
	_TranslationsChatGenuiBudgetReceiptEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get newBudget => 'New Budget';
	@override String get budgetCreated => 'Budget Created';
	@override String get rolloverBudget => 'Rollover Budget';
	@override String get createFailed => 'Failed to create budget';
	@override String get thisMonth => 'This Month';
	@override String dateRange({required Object start, required Object startDay, required Object end, required Object endDay}) => '${start}/${startDay} - ${end}/${endDay}';
}

// Path: chat.genui.budgetStatusCard
class _TranslationsChatGenuiBudgetStatusCardEn extends TranslationsChatGenuiBudgetStatusCardZh {
	_TranslationsChatGenuiBudgetStatusCardEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get budget => 'Budget';
	@override String get overview => 'Budget Overview';
	@override String get totalBudget => 'Total Budget';
	@override String spent({required Object amount}) => 'Used ¥${amount}';
	@override String remaining({required Object amount}) => 'Remaining ¥${amount}';
	@override String get exceeded => 'Exceeded';
	@override String get warning => 'Warning';
	@override String get plentiful => 'Healthy';
	@override String get normal => 'Normal';
}

// Path: chat.genui.cashFlowForecast
class _TranslationsChatGenuiCashFlowForecastEn extends TranslationsChatGenuiCashFlowForecastZh {
	_TranslationsChatGenuiCashFlowForecastEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cash Flow Forecast';
	@override String get recurringTransaction => 'Recurring Transaction';
	@override String get recurringIncome => 'Recurring Income';
	@override String get recurringExpense => 'Recurring Expense';
	@override String get recurringTransfer => 'Recurring Transfer';
	@override String nextDays({required Object days}) => 'Next ${days} days';
	@override String get noData => 'No forecast data';
	@override String get summary => 'Forecast Summary';
	@override String get variableExpense => 'Predicted Variable Expense';
	@override String get netChange => 'Est. Net Change';
	@override String get keyEvents => 'Key Events';
	@override String get noSignificantEvents => 'No significant events in forecast period';
	@override String get dateFormat => 'M/d';
}

// Path: chat.genui.healthScore
class _TranslationsChatGenuiHealthScoreEn extends TranslationsChatGenuiHealthScoreZh {
	_TranslationsChatGenuiHealthScoreEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Financial Health';
	@override String get suggestions => 'Suggestions';
	@override String scorePoint({required Object score}) => '${score} pts';
	@override late final _TranslationsChatGenuiHealthScoreStatusEn status = _TranslationsChatGenuiHealthScoreStatusEn._(_root);
}

// Path: chat.genui.spaceSelector
class _TranslationsChatGenuiSpaceSelectorEn extends TranslationsChatGenuiSpaceSelectorZh {
	_TranslationsChatGenuiSpaceSelectorEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get selected => 'Selected';
	@override String get unnamedSpace => 'Unnamed Space';
	@override String get linked => 'Linked';
	@override String get roleOwner => 'Owner';
	@override String get roleAdmin => 'Admin';
	@override String get roleMember => 'Member';
}

// Path: chat.genui.transferPath
class _TranslationsChatGenuiTransferPathEn extends TranslationsChatGenuiTransferPathZh {
	_TranslationsChatGenuiTransferPathEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get selectSource => 'Select Source Account';
	@override String get selectTarget => 'Select Target Account';
	@override String get from => 'From (Source)';
	@override String get to => 'To (Target)';
	@override String get select => 'Select';
	@override String get cancelled => 'Operation Cancelled';
	@override String get loadError => 'Failed to load account data';
	@override String get historyMissing => 'Account info missing in history';
	@override String get amountUnconfirmed => 'Amount Unconfirmed';
	@override String confirmedWithArrow({required Object source, required Object target}) => 'Confirmed: ${source} → ${target}';
	@override String confirmAction({required Object source, required Object target}) => 'Confirm: ${source} → ${target}';
	@override String get pleaseSelectSource => 'Please select source account';
	@override String get pleaseSelectTarget => 'Please select target account';
	@override String get confirmLinks => 'Confirm Transfer Path';
	@override String get linkLocked => 'Path Locked';
	@override String get clickToConfirm => 'Click button below to confirm';
	@override String get reselect => 'Reselect';
	@override String get title => 'Transfer';
	@override String get history => 'History';
	@override String get unknownAccount => 'Unknown Account';
	@override String get confirmed => 'Confirmed';
}

// Path: chat.genui.transactionCard
class _TranslationsChatGenuiTransactionCardEn extends TranslationsChatGenuiTransactionCardZh {
	_TranslationsChatGenuiTransactionCardEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Transaction Successful';
	@override String get associatedAccount => 'Associated Account';
	@override String get notCounted => 'Not counted';
	@override String get modify => 'Modify';
	@override String get associate => 'Associate Account';
	@override String get selectAccount => 'Select Account';
	@override String get noAccount => 'No accounts available, please add one first';
	@override String get missingId => 'Transaction ID missing, cannot update';
	@override String associatedTo({required Object name}) => 'Associated to ${name}';
	@override String updateFailed({required Object error}) => 'Update failed: ${error}';
	@override String get sharedSpace => 'Shared Space';
	@override String get noSpace => 'No shared spaces available';
	@override String get selectSpace => 'Select Shared Space';
	@override String get linkedToSpace => 'Linked to shared space';
}

// Path: chat.genui.cashFlowCard
class _TranslationsChatGenuiCashFlowCardEn extends TranslationsChatGenuiCashFlowCardZh {
	_TranslationsChatGenuiCashFlowCardEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cash Flow Analysis';
	@override String savingsRate({required Object rate}) => 'Savings ${rate}%';
	@override String get totalIncome => 'Total Income';
	@override String get totalExpense => 'Total Expense';
	@override String get essentialExpense => 'Essential';
	@override String get discretionaryExpense => 'Discretionary';
	@override String get aiInsight => 'AI Insight';
}

// Path: chat.welcome.morning
class _TranslationsChatWelcomeMorningEn extends TranslationsChatWelcomeMorningZh {
	_TranslationsChatWelcomeMorningEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'Start your day by tracking';
	@override late final _TranslationsChatWelcomeMorningBreakfastEn breakfast = _TranslationsChatWelcomeMorningBreakfastEn._(_root);
	@override late final _TranslationsChatWelcomeMorningYesterdayReviewEn yesterdayReview = _TranslationsChatWelcomeMorningYesterdayReviewEn._(_root);
	@override late final _TranslationsChatWelcomeMorningTodayBudgetEn todayBudget = _TranslationsChatWelcomeMorningTodayBudgetEn._(_root);
}

// Path: chat.welcome.midday
class _TranslationsChatWelcomeMiddayEn extends TranslationsChatWelcomeMiddayZh {
	_TranslationsChatWelcomeMiddayEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get greeting => 'Good Afternoon';
	@override String get subtitle => 'Quick record during lunch';
	@override late final _TranslationsChatWelcomeMiddayLunchEn lunch = _TranslationsChatWelcomeMiddayLunchEn._(_root);
	@override late final _TranslationsChatWelcomeMiddayWeeklyExpenseEn weeklyExpense = _TranslationsChatWelcomeMiddayWeeklyExpenseEn._(_root);
	@override late final _TranslationsChatWelcomeMiddayCheckBalanceEn checkBalance = _TranslationsChatWelcomeMiddayCheckBalanceEn._(_root);
}

// Path: chat.welcome.afternoon
class _TranslationsChatWelcomeAfternoonEn extends TranslationsChatWelcomeAfternoonZh {
	_TranslationsChatWelcomeAfternoonEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'Tea time, let\'s review finances';
	@override late final _TranslationsChatWelcomeAfternoonQuickRecordEn quickRecord = _TranslationsChatWelcomeAfternoonQuickRecordEn._(_root);
	@override late final _TranslationsChatWelcomeAfternoonAnalyzeSpendingEn analyzeSpending = _TranslationsChatWelcomeAfternoonAnalyzeSpendingEn._(_root);
	@override late final _TranslationsChatWelcomeAfternoonBudgetProgressEn budgetProgress = _TranslationsChatWelcomeAfternoonBudgetProgressEn._(_root);
}

// Path: chat.welcome.evening
class _TranslationsChatWelcomeEveningEn extends TranslationsChatWelcomeEveningZh {
	_TranslationsChatWelcomeEveningEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'End of day, time to balance the books';
	@override late final _TranslationsChatWelcomeEveningDinnerEn dinner = _TranslationsChatWelcomeEveningDinnerEn._(_root);
	@override late final _TranslationsChatWelcomeEveningTodaySummaryEn todaySummary = _TranslationsChatWelcomeEveningTodaySummaryEn._(_root);
	@override late final _TranslationsChatWelcomeEveningTomorrowPlanEn tomorrowPlan = _TranslationsChatWelcomeEveningTomorrowPlanEn._(_root);
}

// Path: chat.welcome.night
class _TranslationsChatWelcomeNightEn extends TranslationsChatWelcomeNightZh {
	_TranslationsChatWelcomeNightEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get greeting => 'Late Night';
	@override String get subtitle => 'Quiet time for financial planning';
	@override late final _TranslationsChatWelcomeNightMakeupRecordEn makeupRecord = _TranslationsChatWelcomeNightMakeupRecordEn._(_root);
	@override late final _TranslationsChatWelcomeNightMonthlyReviewEn monthlyReview = _TranslationsChatWelcomeNightMonthlyReviewEn._(_root);
	@override late final _TranslationsChatWelcomeNightFinancialThinkingEn financialThinking = _TranslationsChatWelcomeNightFinancialThinkingEn._(_root);
}

// Path: chat.genui.healthScore.status
class _TranslationsChatGenuiHealthScoreStatusEn extends TranslationsChatGenuiHealthScoreStatusZh {
	_TranslationsChatGenuiHealthScoreStatusEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get excellent => 'Excellent';
	@override String get good => 'Good';
	@override String get fair => 'Fair';
	@override String get needsImprovement => 'Needs Improvement';
	@override String get poor => 'Poor';
}

// Path: chat.welcome.morning.breakfast
class _TranslationsChatWelcomeMorningBreakfastEn extends TranslationsChatWelcomeMorningBreakfastZh {
	_TranslationsChatWelcomeMorningBreakfastEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Breakfast';
	@override String get prompt => 'Record breakfast expense';
	@override String get description => 'Log today\'s first expense';
}

// Path: chat.welcome.morning.yesterdayReview
class _TranslationsChatWelcomeMorningYesterdayReviewEn extends TranslationsChatWelcomeMorningYesterdayReviewZh {
	_TranslationsChatWelcomeMorningYesterdayReviewEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Yesterday Review';
	@override String get prompt => 'Analyze yesterday\'s spending';
	@override String get description => 'Check how much you spent yesterday';
}

// Path: chat.welcome.morning.todayBudget
class _TranslationsChatWelcomeMorningTodayBudgetEn extends TranslationsChatWelcomeMorningTodayBudgetZh {
	_TranslationsChatWelcomeMorningTodayBudgetEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Today\'s Budget';
	@override String get prompt => 'How much budget left for today';
	@override String get description => 'Plan your spending for today';
}

// Path: chat.welcome.midday.lunch
class _TranslationsChatWelcomeMiddayLunchEn extends TranslationsChatWelcomeMiddayLunchZh {
	_TranslationsChatWelcomeMiddayLunchEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Lunch';
	@override String get prompt => 'Record lunch expense';
	@override String get description => 'Log your lunch spending';
}

// Path: chat.welcome.midday.weeklyExpense
class _TranslationsChatWelcomeMiddayWeeklyExpenseEn extends TranslationsChatWelcomeMiddayWeeklyExpenseZh {
	_TranslationsChatWelcomeMiddayWeeklyExpenseEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Weekly Spending';
	@override String get prompt => 'Analyze this week\'s spending';
	@override String get description => 'See your weekly expenses';
}

// Path: chat.welcome.midday.checkBalance
class _TranslationsChatWelcomeMiddayCheckBalanceEn extends TranslationsChatWelcomeMiddayCheckBalanceZh {
	_TranslationsChatWelcomeMiddayCheckBalanceEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Check Balance';
	@override String get prompt => 'Check my account balance';
	@override String get description => 'View your account balances';
}

// Path: chat.welcome.afternoon.quickRecord
class _TranslationsChatWelcomeAfternoonQuickRecordEn extends TranslationsChatWelcomeAfternoonQuickRecordZh {
	_TranslationsChatWelcomeAfternoonQuickRecordEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Quick Record';
	@override String get prompt => 'Help me record an expense';
	@override String get description => 'Quickly log a transaction';
}

// Path: chat.welcome.afternoon.analyzeSpending
class _TranslationsChatWelcomeAfternoonAnalyzeSpendingEn extends TranslationsChatWelcomeAfternoonAnalyzeSpendingZh {
	_TranslationsChatWelcomeAfternoonAnalyzeSpendingEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Analyze Spending';
	@override String get prompt => 'Analyze this month\'s spending';
	@override String get description => 'View spending trends and breakdown';
}

// Path: chat.welcome.afternoon.budgetProgress
class _TranslationsChatWelcomeAfternoonBudgetProgressEn extends TranslationsChatWelcomeAfternoonBudgetProgressZh {
	_TranslationsChatWelcomeAfternoonBudgetProgressEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Budget Progress';
	@override String get prompt => 'Check budget status';
	@override String get description => 'See how your budget is doing';
}

// Path: chat.welcome.evening.dinner
class _TranslationsChatWelcomeEveningDinnerEn extends TranslationsChatWelcomeEveningDinnerZh {
	_TranslationsChatWelcomeEveningDinnerEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Dinner';
	@override String get prompt => 'Record dinner expense';
	@override String get description => 'Log tonight\'s dinner spending';
}

// Path: chat.welcome.evening.todaySummary
class _TranslationsChatWelcomeEveningTodaySummaryEn extends TranslationsChatWelcomeEveningTodaySummaryZh {
	_TranslationsChatWelcomeEveningTodaySummaryEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Today\'s Summary';
	@override String get prompt => 'Summarize today\'s spending';
	@override String get description => 'See what you spent today';
}

// Path: chat.welcome.evening.tomorrowPlan
class _TranslationsChatWelcomeEveningTomorrowPlanEn extends TranslationsChatWelcomeEveningTomorrowPlanZh {
	_TranslationsChatWelcomeEveningTomorrowPlanEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tomorrow\'s Plan';
	@override String get prompt => 'What fixed expenses tomorrow';
	@override String get description => 'Plan ahead for tomorrow';
}

// Path: chat.welcome.night.makeupRecord
class _TranslationsChatWelcomeNightMakeupRecordEn extends TranslationsChatWelcomeNightMakeupRecordZh {
	_TranslationsChatWelcomeNightMakeupRecordEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Catch Up';
	@override String get prompt => 'Help me log any missed expenses';
	@override String get description => 'Record expenses you forgot today';
}

// Path: chat.welcome.night.monthlyReview
class _TranslationsChatWelcomeNightMonthlyReviewEn extends TranslationsChatWelcomeNightMonthlyReviewZh {
	_TranslationsChatWelcomeNightMonthlyReviewEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Monthly Review';
	@override String get prompt => 'Analyze this month\'s spending';
	@override String get description => 'Review your monthly expenses';
}

// Path: chat.welcome.night.financialThinking
class _TranslationsChatWelcomeNightFinancialThinkingEn extends TranslationsChatWelcomeNightFinancialThinkingZh {
	_TranslationsChatWelcomeNightFinancialThinkingEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Financial Tips';
	@override String get prompt => 'Give me some financial advice';
	@override String get description => 'Get AI-powered financial insights';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEn {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.loading' => 'Loading...',
			'common.error' => 'Error',
			'common.retry' => 'Retry',
			'common.cancel' => 'Cancel',
			'common.confirm' => 'Confirm',
			'common.save' => 'Save',
			'common.delete' => 'Delete',
			'common.edit' => 'Edit',
			'common.add' => 'Add',
			'common.search' => 'Search',
			'common.filter' => 'Filter',
			'common.sort' => 'Sort',
			'common.refresh' => 'Refresh',
			'common.more' => 'More',
			'common.less' => 'Less',
			'common.all' => 'All',
			'common.none' => 'None',
			'common.ok' => 'OK',
			'common.unknown' => 'Unknown',
			'common.noData' => 'No Data',
			'common.loadMore' => 'Load More',
			'common.noMore' => 'No More',
			'common.loadFailed' => 'Loading failed',
			'common.history' => 'Transactions',
			'common.reset' => 'Reset',
			'time.today' => 'Today',
			'time.yesterday' => 'Yesterday',
			'time.dayBeforeYesterday' => 'Day Before Yesterday',
			'time.thisWeek' => 'Week',
			'time.thisMonth' => 'Month',
			'time.thisYear' => 'Year',
			'time.selectDate' => 'Select Date',
			'time.selectTime' => 'Select Time',
			'time.justNow' => 'Just now',
			'time.minutesAgo' => ({required Object count}) => '${count}m ago',
			'time.hoursAgo' => ({required Object count}) => '${count}h ago',
			'time.daysAgo' => ({required Object count}) => '${count}d ago',
			'time.weeksAgo' => ({required Object count}) => '${count}w ago',
			'greeting.morning' => 'Good Morning',
			'greeting.afternoon' => 'Good Afternoon',
			'greeting.evening' => 'Good Evening',
			'navigation.home' => 'Home',
			'navigation.forecast' => 'Forecast',
			'navigation.footprint' => 'Footprint',
			'navigation.profile' => 'Profile',
			'auth.login' => 'Log In',
			'auth.loggingIn' => 'Logging in...',
			'auth.logout' => 'Log Out',
			'auth.logoutSuccess' => 'Logged out successfully',
			'auth.confirmLogoutTitle' => 'Confirm Logout',
			'auth.confirmLogoutContent' => 'Are you sure you want to log out?',
			'auth.register' => 'Sign Up',
			'auth.registering' => 'Signing up...',
			'auth.welcomeBack' => 'Welcome Back',
			'auth.loginSuccess' => 'Welcome back!',
			'auth.loginFailed' => 'Login Failed',
			'auth.pleaseTryAgain' => 'Please try again later.',
			'auth.loginSubtitle' => 'Log in to continue using Augo',
			'auth.noAccount' => 'Don\'t have an account? Sign Up',
			'auth.createAccount' => 'Create Your Account',
			'auth.setPassword' => 'Set Password',
			'auth.setAccountPassword' => 'Set Your Account Password',
			'auth.completeRegistration' => 'Complete Registration',
			'auth.registrationSuccess' => 'Registration successful!',
			'auth.registrationFailed' => 'Registration failed',
			'auth.email.label' => 'Email',
			'auth.email.placeholder' => 'Enter your email',
			'auth.email.required' => 'Email is required',
			'auth.email.invalid' => 'Please enter a valid email address',
			'auth.password.label' => 'Password',
			'auth.password.placeholder' => 'Enter your password',
			'auth.password.required' => 'Password is required',
			'auth.password.tooShort' => 'Password must be at least 6 characters',
			'auth.password.mustContainNumbersAndLetters' => 'Password must contain both numbers and letters',
			'auth.password.confirm' => 'Confirm Password',
			'auth.password.confirmPlaceholder' => 'Re-enter your password',
			'auth.password.mismatch' => 'Passwords do not match',
			'auth.verificationCode.label' => 'Verification Code',
			'auth.verificationCode.get' => 'Get Code',
			'auth.verificationCode.sending' => 'Sending...',
			'auth.verificationCode.sent' => 'Code sent',
			'auth.verificationCode.sendFailed' => 'Failed to send',
			'auth.verificationCode.placeholder' => 'Optional for now, enter anything',
			'auth.verificationCode.required' => 'Verification code is required',
			'transaction.expense' => 'Expense',
			'transaction.income' => 'Income',
			'transaction.transfer' => 'Transfer',
			'transaction.amount' => 'Amount',
			'transaction.category' => 'Category',
			'transaction.description' => 'Description',
			'transaction.tags' => 'Tags',
			'transaction.saveTransaction' => 'Save Transaction',
			'transaction.pleaseEnterAmount' => 'Please enter amount',
			'transaction.pleaseSelectCategory' => 'Please select category',
			'transaction.saveFailed' => 'Failed to save',
			'transaction.descriptionHint' => 'Record details of this transaction...',
			'transaction.addCustomTag' => 'Add Custom Tag',
			'transaction.commonTags' => 'Common Tags',
			'transaction.maxTagsHint' => ({required Object maxTags}) => 'Maximum ${maxTags} tags allowed',
			'transaction.noTransactionsFound' => 'No transactions found',
			'transaction.tryAdjustingSearch' => 'Try adjusting search criteria or create new transactions',
			'transaction.noDescription' => 'No description',
			'transaction.payment' => 'Payment',
			'transaction.account' => 'Account',
			'transaction.time' => 'Time',
			'transaction.location' => 'Location',
			'transaction.transactionDetail' => 'Transaction Details',
			'transaction.favorite' => 'Favorite',
			'transaction.confirmDelete' => 'Confirm Delete',
			'transaction.deleteTransactionConfirm' => 'Are you sure you want to delete this transaction? This action cannot be undone.',
			'transaction.noActions' => 'No actions available',
			'transaction.deleted' => 'Deleted',
			'transaction.deleteFailed' => 'Delete failed, please try again',
			'transaction.linkedAccount' => 'Linked Account',
			'transaction.linkedSpace' => 'Linked Space',
			'transaction.notLinked' => 'Not linked',
			'transaction.link' => 'Link',
			'transaction.changeAccount' => 'Change Account',
			'transaction.addSpace' => 'Add Space',
			'transaction.nSpaces' => ({required Object count}) => '${count} spaces',
			'transaction.selectLinkedAccount' => 'Select Linked Account',
			'transaction.selectLinkedSpace' => 'Select Linked Space',
			'transaction.noSpacesAvailable' => 'No spaces available',
			'transaction.linkSuccess' => 'Link successful',
			'transaction.linkFailed' => 'Link failed',
			'transaction.rawInput' => 'Message',
			'transaction.noRawInput' => 'No message',
			'home.totalExpense' => 'Total Expense',
			'home.todayExpense' => 'Today\'s',
			'home.monthExpense' => 'This Month\'s',
			'home.yearProgress' => ({required Object year}) => '${year} Progress',
			'home.amountHidden' => '••••••••',
			'home.loadFailed' => 'Load failed',
			'home.noTransactions' => 'No transactions',
			'home.tryRefresh' => 'Pull to refresh',
			'home.noMoreData' => 'No more data',
			'home.userNotLoggedIn' => 'User not logged in',
			'comment.error' => 'Error',
			'comment.commentFailed' => 'Comment failed',
			'comment.replyToPrefix' => ({required Object name}) => 'Reply to @${name}:',
			'comment.reply' => 'Reply',
			'comment.addNote' => 'Add a note...',
			'comment.confirmDeleteTitle' => 'Confirm Delete',
			'comment.confirmDeleteContent' => 'Are you sure you want to delete this comment? This action cannot be undone.',
			'comment.success' => 'Success',
			'comment.commentDeleted' => 'Comment deleted',
			'comment.deleteFailed' => 'Failed to delete',
			'comment.deleteComment' => 'Delete Comment',
			'comment.hint' => 'Hint',
			'comment.noActions' => 'No actions available',
			'comment.note' => 'Note',
			'comment.noNote' => 'No notes yet',
			'comment.loadFailed' => 'Failed to load notes',
			'calendar.title' => 'Expense Calendar',
			'calendar.weekdays.mon' => 'M',
			'calendar.weekdays.tue' => 'T',
			'calendar.weekdays.wed' => 'W',
			'calendar.weekdays.thu' => 'T',
			'calendar.weekdays.fri' => 'F',
			'calendar.weekdays.sat' => 'S',
			'calendar.weekdays.sun' => 'S',
			'calendar.loadFailed' => 'Failed to load calendar data',
			'calendar.thisMonth' => ({required Object amount}) => 'Month: ${amount}',
			'calendar.counting' => 'Counting...',
			'calendar.unableToCount' => 'Unable to count',
			'calendar.trend' => 'Trend: ',
			'calendar.noTransactionsTitle' => 'No transactions on this day',
			'calendar.loadTransactionFailed' => 'Failed to load transactions',
			'category.dailyConsumption' => 'Daily Expenses',
			'category.transportation' => 'Transportation',
			'category.healthcare' => 'Healthcare',
			'category.housing' => 'Housing & Utilities',
			'category.education' => 'Education',
			'category.incomeCategory' => 'Income',
			'category.socialGifts' => 'Gifts & Donations',
			'category.moneyTransfer' => 'Transfers',
			'category.other' => 'Other',
			'category.foodDining' => 'Food & Dining',
			'category.shoppingRetail' => 'Shopping',
			'category.housingUtilities' => 'Housing & Utilities',
			'category.personalCare' => 'Personal Care',
			'category.entertainment' => 'Entertainment',
			'category.medicalHealth' => 'Medical & Health',
			'category.insurance' => 'Insurance',
			'category.socialGifting' => 'Social & Gifting',
			'category.financialTax' => 'Financial & Tax',
			'category.others' => 'Others',
			'category.salaryWage' => 'Salary',
			'category.businessTrade' => 'Business',
			'category.investmentReturns' => 'Investment Returns',
			'category.giftBonus' => 'Gift & Bonus',
			'category.refundRebate' => 'Refund',
			'category.generalTransfer' => 'Transfer',
			'category.debtRepayment' => 'Debt Repayment',
			'settings.title' => 'Settings',
			'settings.language' => 'Language',
			'settings.languageSettings' => 'Language Settings',
			'settings.selectLanguage' => 'Select Language',
			'settings.languageChanged' => 'Language Changed',
			'settings.restartToApply' => 'Restart app to apply changes',
			'settings.theme' => 'Theme',
			'settings.darkMode' => 'Dark Mode',
			'settings.lightMode' => 'Light Mode',
			'settings.systemMode' => 'Follow System',
			'settings.developerOptions' => 'Developer Options',
			'settings.authDebug' => 'Auth Debug',
			'settings.authDebugSubtitle' => 'View authentication status and debug info',
			'settings.fontTest' => 'Font Test',
			'settings.fontTestSubtitle' => 'Test application font display',
			'settings.helpAndFeedback' => 'Help & Feedback',
			'settings.helpAndFeedbackSubtitle' => 'Get help or provide feedback',
			'settings.aboutApp' => 'About',
			'settings.aboutAppSubtitle' => 'Version info and developer information',
			'settings.currencyChangedRefreshHint' => ({required Object currency}) => 'Switched to ${currency}. New transactions will use this currency.',
			'settings.sharedSpace' => 'Shared Space',
			'settings.speechRecognition' => 'Speech Recognition',
			'settings.speechRecognitionSubtitle' => 'Configure voice input parameters',
			'settings.amountDisplayStyle' => 'Amount Display Style',
			'settings.currency' => 'Currency',
			'settings.appearance' => 'Appearance Settings',
			'settings.appearanceSubtitle' => 'Theme mode and color scheme',
			'settings.speechTest' => 'Speech Test',
			'settings.speechTestSubtitle' => 'Test WebSocket speech connection',
			'settings.userTypeRegular' => 'Regular User',
			'settings.selectAmountStyle' => 'Select Amount Display Style',
			'settings.amountStyleNotice' => 'Note: Amount styles are primarily applied to \'Transactions\' and \'Trends\'. To maintain visual clarity, \'Account Balances\' and \'Asset Summaries\' will remain in neutral colors.',
			'settings.currencyDescription' => 'Choose your preferred display currency. All amounts will be displayed in this currency.',
			'settings.editUsername' => 'Edit Username',
			'settings.enterUsername' => 'Enter username',
			'settings.usernameRequired' => 'Username is required',
			'settings.usernameUpdated' => 'Username updated',
			'settings.avatarUpdated' => 'Avatar updated',
			'appearance.title' => 'Appearance Settings',
			'appearance.themeMode' => 'Theme Mode',
			'appearance.light' => 'Light',
			'appearance.dark' => 'Dark',
			'appearance.system' => 'System',
			'appearance.colorScheme' => 'Color Scheme',
			'appearance.palettes.zinc' => 'Zinc',
			'appearance.palettes.slate' => 'Slate',
			'appearance.palettes.red' => 'Red',
			'appearance.palettes.rose' => 'Rose',
			'appearance.palettes.orange' => 'Orange',
			'appearance.palettes.green' => 'Green',
			'appearance.palettes.blue' => 'Blue',
			'appearance.palettes.yellow' => 'Yellow',
			'appearance.palettes.violet' => 'Violet',
			'speech.title' => 'Speech Recognition Settings',
			'speech.service' => 'Speech Recognition Service',
			'speech.systemVoice' => 'System Voice',
			'speech.systemVoiceSubtitle' => 'Use built-in device service (Recommended)',
			'speech.selfHostedASR' => 'Self-hosted ASR',
			'speech.selfHostedASRSubtitle' => 'Use WebSocket connection to self-hosted service',
			'speech.serverConfig' => 'Server Configuration',
			'speech.serverAddress' => 'Server Address',
			'speech.port' => 'Port',
			'speech.path' => 'Path',
			'speech.saveConfig' => 'Save Configuration',
			'speech.info' => 'Information',
			'speech.infoContent' => '• System Voice: Uses device service, no config needed, faster response\n• Self-hosted ASR: Suitable for custom models or offline scenarios\n\nChanges will take effect next time you use voice input.',
			'speech.enterAddress' => 'Please enter server address',
			'speech.enterValidPort' => 'Please enter a valid port (1-65535)',
			'speech.configSaved' => 'Configuration saved',
			'amountTheme.chinaMarket' => 'China Market Style',
			'amountTheme.chinaMarketDesc' => 'Red up, Green/Black down (Recommended)',
			'amountTheme.international' => 'International Standard',
			'amountTheme.internationalDesc' => 'Green up, Red down',
			'amountTheme.minimalist' => 'Minimalist',
			'amountTheme.minimalistDesc' => 'Distinguish with symbols only',
			'amountTheme.colorBlind' => 'Color Blind Friendly',
			'amountTheme.colorBlindDesc' => 'Blue-Orange color scheme',
			'locale.chinese' => 'Simplified Chinese',
			'locale.english' => 'English',
			'locale.japanese' => 'Japanese',
			'locale.korean' => 'Korean',
			'locale.traditionalChinese' => 'Traditional Chinese',
			'budget.title' => 'Budget Management',
			'budget.detail' => 'Budget Details',
			'budget.info' => 'Budget Info',
			'budget.totalBudget' => 'Total Budget',
			'budget.categoryBudget' => 'Category Budget',
			'budget.monthlySummary' => 'Monthly Budget Summary',
			'budget.used' => 'Used',
			'budget.remaining' => 'Remaining',
			'budget.overspent' => 'Overspent',
			'budget.budget' => 'Budget',
			'budget.loadFailed' => 'Failed to load',
			'budget.noBudget' => 'No budgets yet',
			'budget.createHint' => 'Say "Help me set a budget" to your Augo assistant',
			'budget.paused' => 'Paused',
			'budget.pause' => 'Pause',
			'budget.resume' => 'Resume',
			'budget.budgetPaused' => 'Budget paused',
			'budget.budgetResumed' => 'Budget resumed',
			'budget.operationFailed' => 'Operation failed',
			'budget.deleteBudget' => 'Delete Budget',
			'budget.deleteConfirm' => 'Are you sure you want to delete this budget? This cannot be undone.',
			'budget.type' => 'Type',
			'budget.category' => 'Category',
			'budget.period' => 'Repeat Rule',
			'budget.rollover' => 'Rollover',
			'budget.rolloverBalance' => 'Rollover Balance',
			'budget.enabled' => 'Enabled',
			'budget.disabled' => 'Disabled',
			'budget.statusNormal' => 'On Track',
			'budget.statusWarning' => 'Near Limit',
			'budget.statusOverspent' => 'Overspent',
			'budget.statusAchieved' => 'Goal Achieved',
			'budget.tipNormal' => ({required Object amount}) => '${amount} remaining',
			'budget.tipWarning' => ({required Object amount}) => 'Only ${amount} left, be careful',
			'budget.tipOverspent' => ({required Object amount}) => 'Overspent by ${amount}',
			'budget.tipAchieved' => 'Congratulations on achieving your savings goal!',
			'budget.remainingAmount' => ({required Object amount}) => '${amount} remaining',
			'budget.overspentAmount' => ({required Object amount}) => 'Overspent ${amount}',
			'budget.budgetAmount' => ({required Object amount}) => 'Budget ${amount}',
			'budget.active' => 'Active',
			'budget.all' => 'All',
			'budget.notFound' => 'Budget not found or deleted',
			'budget.setup' => 'Budget Setup',
			'budget.settings' => 'Budget Settings',
			'budget.setAmount' => 'Set Budget Amount',
			'budget.setAmountDesc' => 'Set budget amount for each category',
			'budget.monthly' => 'Monthly Budget',
			'budget.monthlyDesc' => 'Manage expenses monthly, suitable for most users',
			'budget.weekly' => 'Weekly Budget',
			'budget.weeklyDesc' => 'Manage expenses weekly for finer control',
			'budget.yearly' => 'Annual Budget',
			'budget.yearlyDesc' => 'Long-term financial planning for major expenses',
			'budget.editBudget' => 'Edit Budget',
			'budget.editBudgetDesc' => 'Modify budget amounts and categories',
			'budget.reminderSettings' => 'Reminder Settings',
			'budget.reminderSettingsDesc' => 'Set budget reminders and notifications',
			'budget.report' => 'Budget Report',
			'budget.reportDesc' => 'View detailed budget analysis reports',
			'budget.welcome' => 'Welcome to Budget Feature!',
			'budget.createNewPlan' => 'Create New Budget Plan',
			'budget.welcomeDesc' => 'Set budgets to better control spending and achieve financial goals. Let\'s start setting up your first budget plan!',
			'budget.createDesc' => 'Set budget limits for different spending categories to manage your finances better.',
			'budget.newBudget' => 'New Budget',
			'budget.budgetAmountLabel' => 'Budget Amount',
			'budget.currency' => 'Currency',
			'budget.periodSettings' => 'Period Settings',
			'budget.autoGenerateTransactions' => 'Automatically generate transactions by rule',
			'budget.cycle' => 'Cycle',
			'budget.budgetCategory' => 'Budget Category',
			'budget.advancedOptions' => 'Advanced Options',
			'budget.periodType' => 'Period Type',
			'budget.anchorDay' => 'Anchor Day',
			'budget.selectPeriodType' => 'Select Period Type',
			'budget.selectAnchorDay' => 'Select Anchor Day',
			'budget.rolloverDescription' => 'Carry over unused budget to next period',
			'budget.createBudget' => 'Create Budget',
			'budget.save' => 'Save',
			'budget.pleaseEnterAmount' => 'Please enter budget amount',
			'budget.invalidAmount' => 'Please enter a valid amount',
			'budget.updateSuccess' => 'Budget updated successfully',
			'budget.createSuccess' => 'Budget created successfully',
			'budget.deleteSuccess' => 'Budget deleted',
			'budget.deleteFailed' => 'Delete failed',
			'budget.everyMonthDay' => ({required Object day}) => 'Day ${day} of each month',
			'budget.periodWeekly' => 'Weekly',
			'budget.periodBiweekly' => 'Biweekly',
			'budget.periodMonthly' => 'Monthly',
			'budget.periodYearly' => 'Yearly',
			'budget.statusActive' => 'Active',
			'budget.statusArchived' => 'Archived',
			'budget.periodStatusOnTrack' => 'On Track',
			'budget.periodStatusWarning' => 'Warning',
			'budget.periodStatusExceeded' => 'Exceeded',
			'budget.periodStatusAchieved' => 'Achieved',
			'budget.usedPercent' => ({required Object percent}) => '${percent}% used',
			'budget.dayOfMonth' => ({required Object day}) => 'Day ${day}',
			'budget.tenThousandSuffix' => '0k',
			'dateRange.custom' => 'Custom',
			'dateRange.pickerTitle' => 'Select Date Range',
			'dateRange.startDate' => 'Start Date',
			'dateRange.endDate' => 'End Date',
			'dateRange.hint' => 'Please select a date range',
			'forecast.title' => 'Forecast',
			'forecast.subtitle' => 'AI-powered cash flow predictions based on your financial data',
			'forecast.financialNavigator' => 'Hello, I\'m your Financial Navigator',
			'forecast.financialMapSubtitle' => 'In just 3 steps, let\'s map your financial future together',
			'forecast.predictCashFlow' => 'Predict Cash Flow',
			'forecast.predictCashFlowDesc' => 'See your daily financial status',
			'forecast.aiSmartSuggestions' => 'AI Smart Suggestions',
			'forecast.aiSmartSuggestionsDesc' => 'Personalized financial decision guidance',
			'forecast.riskWarning' => 'Risk Alerts',
			'forecast.riskWarningDesc' => 'Detect potential financial risks early',
			'forecast.analyzing' => 'Analyzing your financial data to generate a 30-day cash flow forecast',
			'forecast.analyzePattern' => 'Analyzing income & expense patterns',
			'forecast.calculateTrend' => 'Calculating cash flow trends',
			'forecast.generateWarning' => 'Generating risk alerts',
			'forecast.loadingForecast' => 'Loading financial forecast...',
			'forecast.todayLabel' => 'Today',
			'forecast.tomorrowLabel' => 'Tomorrow',
			'forecast.balanceLabel' => 'Balance',
			'forecast.noSpecialEvents' => 'No special events',
			'forecast.financialSafetyLine' => 'Financial Safety Net',
			'forecast.currentSetting' => 'Current Setting',
			'forecast.dailySpendingEstimate' => 'Daily Spending Estimate',
			'forecast.adjustDailySpendingAmount' => 'Adjust daily spending forecast amount',
			'forecast.tellMeYourSafetyLine' => 'What\'s your financial safety threshold?',
			'forecast.safetyLineDescription' => 'This is the minimum balance you want to maintain. I\'ll alert you when your balance approaches this amount.',
			'forecast.dailySpendingQuestion' => 'How much do you spend daily?',
			'forecast.dailySpendingDescription' => 'Including meals, transportation, shopping and other daily expenses\nThis is just an initial estimate - predictions will improve with your actual records',
			'forecast.perDay' => 'per day',
			'forecast.referenceStandard' => 'Reference',
			'forecast.frugalType' => 'Frugal',
			'forecast.comfortableType' => 'Comfortable',
			'forecast.relaxedType' => 'Relaxed',
			'forecast.frugalAmount' => '¥50-100/day',
			'forecast.comfortableAmount' => '¥100-200/day',
			'forecast.relaxedAmount' => '¥200-300/day',
			'forecast.recurringTransaction.title' => 'Recurring Transactions',
			'forecast.recurringTransaction.all' => 'All',
			'forecast.recurringTransaction.expense' => 'Expense',
			'forecast.recurringTransaction.income' => 'Income',
			'forecast.recurringTransaction.transfer' => 'Transfer',
			'forecast.recurringTransaction.noRecurring' => 'No recurring transactions',
			'forecast.recurringTransaction.createHint' => 'The system will automatically generate transactions after you create recurring rules',
			'forecast.recurringTransaction.create' => 'Create Recurring Transaction',
			'forecast.recurringTransaction.edit' => 'Edit Recurring Transaction',
			'forecast.recurringTransaction.newTransaction' => 'New Recurring Transaction',
			'forecast.recurringTransaction.deleteConfirm' => ({required Object name}) => 'Are you sure you want to delete recurring transaction "${name}"? This cannot be undone.',
			'forecast.recurringTransaction.activateConfirm' => ({required Object name}) => 'Are you sure you want to activate recurring transaction "${name}"? It will automatically generate transactions.',
			'forecast.recurringTransaction.pauseConfirm' => ({required Object name}) => 'Are you sure you want to pause recurring transaction "${name}"? No transactions will be generated while paused.',
			'forecast.recurringTransaction.created' => 'Recurring transaction created',
			'forecast.recurringTransaction.updated' => 'Recurring transaction updated',
			'forecast.recurringTransaction.activated' => 'Activated',
			'forecast.recurringTransaction.paused' => 'Paused',
			'forecast.recurringTransaction.nextTime' => 'Next',
			'forecast.recurringTransaction.sortByTime' => 'Sort by time',
			'forecast.recurringTransaction.allPeriod' => 'All recurring',
			'forecast.recurringTransaction.periodCount' => ({required Object type, required Object count}) => '${type} recurring (${count})',
			'forecast.recurringTransaction.confirmDelete' => 'Confirm Delete',
			'forecast.recurringTransaction.confirmActivate' => 'Confirm Activate',
			'forecast.recurringTransaction.confirmPause' => 'Confirm Pause',
			'forecast.recurringTransaction.dynamicAmount' => 'Est. Avg',
			'forecast.recurringTransaction.dynamicAmountTitle' => 'Amount Requires Confirmation',
			'forecast.recurringTransaction.dynamicAmountDescription' => 'System will send a reminder on the due date. You need to manually confirm the amount before recording.',
			'chat.newChat' => 'New Chat',
			'chat.noMessages' => 'No messages to display.',
			'chat.loadingFailed' => 'Loading failed',
			'chat.inputMessage' => 'Type a message...',
			'chat.aiThinking' => 'AI processing...',
			'chat.listening' => 'Listening...',
			'chat.tools.processing' => 'Processing...',
			'chat.tools.readFile' => 'Reading file...',
			'chat.tools.searchTransactions' => 'Searching transactions...',
			'chat.tools.queryBudgetStatus' => 'Checking budget...',
			'chat.tools.createBudget' => 'Creating budget plan...',
			'chat.tools.getCashFlowAnalysis' => 'Analyzing cash flow...',
			'chat.tools.getFinancialHealthScore' => 'Calculating financial health score...',
			'chat.tools.getFinancialSummary' => 'Generating financial report...',
			'chat.tools.evaluateFinancialHealth' => 'Evaluating financial health...',
			'chat.tools.forecastBalance' => 'Forecasting future balance...',
			'chat.tools.simulateExpenseImpact' => 'Simulating purchase impact...',
			'chat.tools.recordTransactions' => 'Recording transactions...',
			'chat.tools.createTransaction' => 'Recording transaction...',
			'chat.tools.duckduckgoSearch' => 'Searching the web...',
			'chat.tools.executeTransfer' => 'Executing transfer...',
			'chat.tools.listDir' => 'Browsing directory...',
			'chat.tools.execute' => 'Processing...',
			'chat.tools.analyzeFinance' => 'Analyzing finances...',
			'chat.tools.forecastFinance' => 'Forecasting finances...',
			'chat.tools.analyzeBudget' => 'Analyzing budget...',
			'chat.tools.auditAnalysis' => 'Running audit analysis...',
			'chat.tools.budgetOps' => 'Processing budget...',
			'chat.tools.createSharedTransaction' => 'Creating shared expense...',
			'chat.tools.listSpaces' => 'Loading shared spaces...',
			'chat.tools.querySpaceSummary' => 'Querying space summary...',
			'chat.tools.prepareTransfer' => 'Preparing transfer...',
			'chat.tools.unknown' => 'Processing request...',
			'chat.tools.done.readFile' => 'Read file',
			'chat.tools.done.searchTransactions' => 'Searched transactions',
			'chat.tools.done.queryBudgetStatus' => 'Checked budget',
			'chat.tools.done.createBudget' => 'Created budget',
			'chat.tools.done.getCashFlowAnalysis' => 'Analyzed cash flow',
			'chat.tools.done.getFinancialHealthScore' => 'Calculated health score',
			'chat.tools.done.getFinancialSummary' => 'Financial report ready',
			'chat.tools.done.evaluateFinancialHealth' => 'Health evaluation complete',
			'chat.tools.done.forecastBalance' => 'Balance forecast ready',
			'chat.tools.done.simulateExpenseImpact' => 'Impact simulation complete',
			'chat.tools.done.recordTransactions' => 'Recorded transactions',
			'chat.tools.done.createTransaction' => 'Recorded transaction',
			'chat.tools.done.duckduckgoSearch' => 'Searched the web',
			'chat.tools.done.executeTransfer' => 'Transfer complete',
			'chat.tools.done.listDir' => 'Browsed directory',
			'chat.tools.done.execute' => 'Processing complete',
			'chat.tools.done.analyzeFinance' => 'Finance analysis complete',
			'chat.tools.done.forecastFinance' => 'Finance forecast complete',
			'chat.tools.done.analyzeBudget' => 'Budget analysis complete',
			'chat.tools.done.auditAnalysis' => 'Audit analysis complete',
			'chat.tools.done.budgetOps' => 'Budget processing complete',
			'chat.tools.done.createSharedTransaction' => 'Shared expense created',
			'chat.tools.done.listSpaces' => 'Shared spaces loaded',
			'chat.tools.done.querySpaceSummary' => 'Space summary ready',
			'chat.tools.done.prepareTransfer' => 'Transfer ready',
			'chat.tools.done.unknown' => 'Processing complete',
			'chat.tools.failed.unknown' => 'Action failed',
			'chat.tools.cancelled' => 'Cancelled',
			'chat.speechNotRecognized' => 'Speech not recognized, please try again',
			'chat.currentExpense' => 'Session Expense',
			'chat.loadingComponent' => 'Loading component...',
			'chat.noHistory' => 'No historical sessions',
			'chat.startNewChat' => 'Start a new conversation!',
			'chat.searchHint' => 'Search conversations',
			'chat.library' => 'Library',
			'chat.viewProfile' => 'View profile',
			'chat.noRelatedFound' => 'No related conversations found',
			'chat.tryOtherKeywords' => 'Try searching with other keywords',
			'chat.searchFailed' => 'Search failed',
			_ => null,
		} ?? switch (path) {
			'chat.deleteConversation' => 'Delete Conversation',
			'chat.deleteConversationConfirm' => 'Are you sure you want to delete this conversation? This action cannot be undone.',
			'chat.conversationDeleted' => 'Conversation deleted',
			'chat.deleteConversationFailed' => 'Failed to delete conversation',
			'chat.transferWizard.title' => 'Transfer Wizard',
			'chat.transferWizard.amount' => 'Transfer Amount',
			'chat.transferWizard.amountHint' => 'Enter amount',
			'chat.transferWizard.sourceAccount' => 'Source Account',
			'chat.transferWizard.targetAccount' => 'Target Account',
			'chat.transferWizard.selectAccount' => 'Select Account',
			'chat.transferWizard.confirmTransfer' => 'Confirm Transfer',
			'chat.transferWizard.confirmed' => 'Confirmed',
			'chat.transferWizard.transferSuccess' => 'Transfer Successful',
			'chat.genui.expenseSummary.totalExpense' => 'Total Expense',
			'chat.genui.expenseSummary.mainExpenses' => 'Main Expenses',
			'chat.genui.expenseSummary.viewAll' => ({required Object count}) => 'View all ${count} transactions',
			'chat.genui.expenseSummary.details' => 'Transaction Details',
			'chat.genui.transactionList.searchResults' => ({required Object count}) => 'Search Results (${count})',
			'chat.genui.transactionList.loaded' => ({required Object count}) => 'Loaded ${count}',
			'chat.genui.transactionList.noResults' => 'No transactions found',
			'chat.genui.transactionList.loadMore' => 'Scroll to load more',
			'chat.genui.transactionList.allLoaded' => 'All loaded',
			'chat.genui.transactionGroupReceipt.title' => 'Successfully',
			'chat.genui.transactionGroupReceipt.count' => ({required Object count}) => '${count} items',
			'chat.genui.transactionGroupReceipt.total' => 'Total',
			'chat.genui.transactionGroupReceipt.selectAccount' => 'Select Account',
			'chat.genui.transactionGroupReceipt.selectAccountSubtitle' => 'This account will be applied to all transactions above',
			'chat.genui.transactionGroupReceipt.associatedAccount' => ({required Object name}) => 'Associated: ${name}',
			'chat.genui.transactionGroupReceipt.clickToAssociate' => 'Click to associate account',
			'chat.genui.transactionGroupReceipt.associateSuccess' => 'Successfully associated account to all transactions',
			'chat.genui.transactionGroupReceipt.associateFailed' => ({required Object error}) => 'Action failed: ${error}',
			'chat.genui.transactionGroupReceipt.accountAssociation' => 'Account',
			'chat.genui.transactionGroupReceipt.sharedSpace' => 'Shared Space',
			'chat.genui.transactionGroupReceipt.notAssociated' => 'Not linked',
			'chat.genui.transactionGroupReceipt.addSpace' => 'Add',
			'chat.genui.transactionGroupReceipt.selectSpace' => 'Select Shared Space',
			'chat.genui.transactionGroupReceipt.spaceAssociateSuccess' => 'Linked to shared space',
			'chat.genui.transactionGroupReceipt.spaceAssociateFailed' => ({required Object error}) => 'Failed to link: ${error}',
			'chat.genui.transactionGroupReceipt.currencyMismatchTitle' => 'Currency Mismatch',
			'chat.genui.transactionGroupReceipt.currencyMismatchDesc' => 'The transaction currency differs from the account currency. The account balance will be deducted at the exchange rate.',
			'chat.genui.transactionGroupReceipt.transactionAmount' => 'Transaction Amount',
			'chat.genui.transactionGroupReceipt.accountCurrency' => 'Account Currency',
			'chat.genui.transactionGroupReceipt.targetAccount' => 'Target Account',
			'chat.genui.transactionGroupReceipt.currencyMismatchNote' => 'Note: Account balance will be converted using current exchange rate',
			'chat.genui.transactionGroupReceipt.confirmAssociate' => 'Confirm',
			'chat.genui.transactionGroupReceipt.spaceCount' => ({required Object count}) => '${count} spaces',
			'chat.genui.budgetReceipt.newBudget' => 'New Budget',
			'chat.genui.budgetReceipt.budgetCreated' => 'Budget Created',
			'chat.genui.budgetReceipt.rolloverBudget' => 'Rollover Budget',
			'chat.genui.budgetReceipt.createFailed' => 'Failed to create budget',
			'chat.genui.budgetReceipt.thisMonth' => 'This Month',
			'chat.genui.budgetReceipt.dateRange' => ({required Object start, required Object startDay, required Object end, required Object endDay}) => '${start}/${startDay} - ${end}/${endDay}',
			'chat.genui.budgetStatusCard.budget' => 'Budget',
			'chat.genui.budgetStatusCard.overview' => 'Budget Overview',
			'chat.genui.budgetStatusCard.totalBudget' => 'Total Budget',
			'chat.genui.budgetStatusCard.spent' => ({required Object amount}) => 'Used ¥${amount}',
			'chat.genui.budgetStatusCard.remaining' => ({required Object amount}) => 'Remaining ¥${amount}',
			'chat.genui.budgetStatusCard.exceeded' => 'Exceeded',
			'chat.genui.budgetStatusCard.warning' => 'Warning',
			'chat.genui.budgetStatusCard.plentiful' => 'Healthy',
			'chat.genui.budgetStatusCard.normal' => 'Normal',
			'chat.genui.cashFlowForecast.title' => 'Cash Flow Forecast',
			'chat.genui.cashFlowForecast.recurringTransaction' => 'Recurring Transaction',
			'chat.genui.cashFlowForecast.recurringIncome' => 'Recurring Income',
			'chat.genui.cashFlowForecast.recurringExpense' => 'Recurring Expense',
			'chat.genui.cashFlowForecast.recurringTransfer' => 'Recurring Transfer',
			'chat.genui.cashFlowForecast.nextDays' => ({required Object days}) => 'Next ${days} days',
			'chat.genui.cashFlowForecast.noData' => 'No forecast data',
			'chat.genui.cashFlowForecast.summary' => 'Forecast Summary',
			'chat.genui.cashFlowForecast.variableExpense' => 'Predicted Variable Expense',
			'chat.genui.cashFlowForecast.netChange' => 'Est. Net Change',
			'chat.genui.cashFlowForecast.keyEvents' => 'Key Events',
			'chat.genui.cashFlowForecast.noSignificantEvents' => 'No significant events in forecast period',
			'chat.genui.cashFlowForecast.dateFormat' => 'M/d',
			'chat.genui.healthScore.title' => 'Financial Health',
			'chat.genui.healthScore.suggestions' => 'Suggestions',
			'chat.genui.healthScore.scorePoint' => ({required Object score}) => '${score} pts',
			'chat.genui.healthScore.status.excellent' => 'Excellent',
			'chat.genui.healthScore.status.good' => 'Good',
			'chat.genui.healthScore.status.fair' => 'Fair',
			'chat.genui.healthScore.status.needsImprovement' => 'Needs Improvement',
			'chat.genui.healthScore.status.poor' => 'Poor',
			'chat.genui.spaceSelector.selected' => 'Selected',
			'chat.genui.spaceSelector.unnamedSpace' => 'Unnamed Space',
			'chat.genui.spaceSelector.linked' => 'Linked',
			'chat.genui.spaceSelector.roleOwner' => 'Owner',
			'chat.genui.spaceSelector.roleAdmin' => 'Admin',
			'chat.genui.spaceSelector.roleMember' => 'Member',
			'chat.genui.transferPath.selectSource' => 'Select Source Account',
			'chat.genui.transferPath.selectTarget' => 'Select Target Account',
			'chat.genui.transferPath.from' => 'From (Source)',
			'chat.genui.transferPath.to' => 'To (Target)',
			'chat.genui.transferPath.select' => 'Select',
			'chat.genui.transferPath.cancelled' => 'Operation Cancelled',
			'chat.genui.transferPath.loadError' => 'Failed to load account data',
			'chat.genui.transferPath.historyMissing' => 'Account info missing in history',
			'chat.genui.transferPath.amountUnconfirmed' => 'Amount Unconfirmed',
			'chat.genui.transferPath.confirmedWithArrow' => ({required Object source, required Object target}) => 'Confirmed: ${source} → ${target}',
			'chat.genui.transferPath.confirmAction' => ({required Object source, required Object target}) => 'Confirm: ${source} → ${target}',
			'chat.genui.transferPath.pleaseSelectSource' => 'Please select source account',
			'chat.genui.transferPath.pleaseSelectTarget' => 'Please select target account',
			'chat.genui.transferPath.confirmLinks' => 'Confirm Transfer Path',
			'chat.genui.transferPath.linkLocked' => 'Path Locked',
			'chat.genui.transferPath.clickToConfirm' => 'Click button below to confirm',
			'chat.genui.transferPath.reselect' => 'Reselect',
			'chat.genui.transferPath.title' => 'Transfer',
			'chat.genui.transferPath.history' => 'History',
			'chat.genui.transferPath.unknownAccount' => 'Unknown Account',
			'chat.genui.transferPath.confirmed' => 'Confirmed',
			'chat.genui.transactionCard.title' => 'Transaction Successful',
			'chat.genui.transactionCard.associatedAccount' => 'Associated Account',
			'chat.genui.transactionCard.notCounted' => 'Not counted',
			'chat.genui.transactionCard.modify' => 'Modify',
			'chat.genui.transactionCard.associate' => 'Associate Account',
			'chat.genui.transactionCard.selectAccount' => 'Select Account',
			'chat.genui.transactionCard.noAccount' => 'No accounts available, please add one first',
			'chat.genui.transactionCard.missingId' => 'Transaction ID missing, cannot update',
			'chat.genui.transactionCard.associatedTo' => ({required Object name}) => 'Associated to ${name}',
			'chat.genui.transactionCard.updateFailed' => ({required Object error}) => 'Update failed: ${error}',
			'chat.genui.transactionCard.sharedSpace' => 'Shared Space',
			'chat.genui.transactionCard.noSpace' => 'No shared spaces available',
			'chat.genui.transactionCard.selectSpace' => 'Select Shared Space',
			'chat.genui.transactionCard.linkedToSpace' => 'Linked to shared space',
			'chat.genui.cashFlowCard.title' => 'Cash Flow Analysis',
			'chat.genui.cashFlowCard.savingsRate' => ({required Object rate}) => 'Savings ${rate}%',
			'chat.genui.cashFlowCard.totalIncome' => 'Total Income',
			'chat.genui.cashFlowCard.totalExpense' => 'Total Expense',
			'chat.genui.cashFlowCard.essentialExpense' => 'Essential',
			'chat.genui.cashFlowCard.discretionaryExpense' => 'Discretionary',
			'chat.genui.cashFlowCard.aiInsight' => 'AI Insight',
			'chat.welcome.morning.subtitle' => 'Start your day by tracking',
			'chat.welcome.morning.breakfast.title' => 'Breakfast',
			'chat.welcome.morning.breakfast.prompt' => 'Record breakfast expense',
			'chat.welcome.morning.breakfast.description' => 'Log today\'s first expense',
			'chat.welcome.morning.yesterdayReview.title' => 'Yesterday Review',
			'chat.welcome.morning.yesterdayReview.prompt' => 'Analyze yesterday\'s spending',
			'chat.welcome.morning.yesterdayReview.description' => 'Check how much you spent yesterday',
			'chat.welcome.morning.todayBudget.title' => 'Today\'s Budget',
			'chat.welcome.morning.todayBudget.prompt' => 'How much budget left for today',
			'chat.welcome.morning.todayBudget.description' => 'Plan your spending for today',
			'chat.welcome.midday.greeting' => 'Good Afternoon',
			'chat.welcome.midday.subtitle' => 'Quick record during lunch',
			'chat.welcome.midday.lunch.title' => 'Lunch',
			'chat.welcome.midday.lunch.prompt' => 'Record lunch expense',
			'chat.welcome.midday.lunch.description' => 'Log your lunch spending',
			'chat.welcome.midday.weeklyExpense.title' => 'Weekly Spending',
			'chat.welcome.midday.weeklyExpense.prompt' => 'Analyze this week\'s spending',
			'chat.welcome.midday.weeklyExpense.description' => 'See your weekly expenses',
			'chat.welcome.midday.checkBalance.title' => 'Check Balance',
			'chat.welcome.midday.checkBalance.prompt' => 'Check my account balance',
			'chat.welcome.midday.checkBalance.description' => 'View your account balances',
			'chat.welcome.afternoon.subtitle' => 'Tea time, let\'s review finances',
			'chat.welcome.afternoon.quickRecord.title' => 'Quick Record',
			'chat.welcome.afternoon.quickRecord.prompt' => 'Help me record an expense',
			'chat.welcome.afternoon.quickRecord.description' => 'Quickly log a transaction',
			'chat.welcome.afternoon.analyzeSpending.title' => 'Analyze Spending',
			'chat.welcome.afternoon.analyzeSpending.prompt' => 'Analyze this month\'s spending',
			'chat.welcome.afternoon.analyzeSpending.description' => 'View spending trends and breakdown',
			'chat.welcome.afternoon.budgetProgress.title' => 'Budget Progress',
			'chat.welcome.afternoon.budgetProgress.prompt' => 'Check budget status',
			'chat.welcome.afternoon.budgetProgress.description' => 'See how your budget is doing',
			'chat.welcome.evening.subtitle' => 'End of day, time to balance the books',
			'chat.welcome.evening.dinner.title' => 'Dinner',
			'chat.welcome.evening.dinner.prompt' => 'Record dinner expense',
			'chat.welcome.evening.dinner.description' => 'Log tonight\'s dinner spending',
			'chat.welcome.evening.todaySummary.title' => 'Today\'s Summary',
			'chat.welcome.evening.todaySummary.prompt' => 'Summarize today\'s spending',
			'chat.welcome.evening.todaySummary.description' => 'See what you spent today',
			'chat.welcome.evening.tomorrowPlan.title' => 'Tomorrow\'s Plan',
			'chat.welcome.evening.tomorrowPlan.prompt' => 'What fixed expenses tomorrow',
			'chat.welcome.evening.tomorrowPlan.description' => 'Plan ahead for tomorrow',
			'chat.welcome.night.greeting' => 'Late Night',
			'chat.welcome.night.subtitle' => 'Quiet time for financial planning',
			'chat.welcome.night.makeupRecord.title' => 'Catch Up',
			'chat.welcome.night.makeupRecord.prompt' => 'Help me log any missed expenses',
			'chat.welcome.night.makeupRecord.description' => 'Record expenses you forgot today',
			'chat.welcome.night.monthlyReview.title' => 'Monthly Review',
			'chat.welcome.night.monthlyReview.prompt' => 'Analyze this month\'s spending',
			'chat.welcome.night.monthlyReview.description' => 'Review your monthly expenses',
			'chat.welcome.night.financialThinking.title' => 'Financial Tips',
			'chat.welcome.night.financialThinking.prompt' => 'Give me some financial advice',
			'chat.welcome.night.financialThinking.description' => 'Get AI-powered financial insights',
			'footprint.searchIn' => 'Search',
			'footprint.searchInAllRecords' => 'Search in all records',
			'media.selectPhotos' => 'Select Photos',
			'media.addFiles' => 'Add Files',
			'media.takePhoto' => 'Take Photo',
			'media.camera' => 'Camera',
			'media.photos' => 'Photos',
			'media.files' => 'Files',
			'media.showAll' => 'Show All',
			'media.allPhotos' => 'All Photos',
			'media.takingPhoto' => 'Taking photo...',
			'media.photoTaken' => 'Photo saved',
			'media.cameraPermissionRequired' => 'Camera permission required',
			'media.fileSizeExceeded' => 'File size exceeds 10MB limit',
			'media.unsupportedFormat' => 'Unsupported file format',
			'media.permissionDenied' => 'Photo library access required',
			'media.storageInsufficient' => 'Insufficient storage space',
			'media.networkError' => 'Network connection error',
			'media.unknownUploadError' => 'Unknown error during upload',
			'error.permissionRequired' => 'Permission Required',
			'error.permissionInstructions' => 'Please enable photo library and storage permissions in Settings to select and upload files.',
			'error.openSettings' => 'Open Settings',
			'error.fileTooLarge' => 'File Too Large',
			'error.fileSizeHint' => 'Please select files under 10MB, or compress before uploading.',
			'error.supportedFormatsHint' => 'Supported formats: images (jpg, png, gif), documents (pdf, doc, txt), audio/video files.',
			'error.storageCleanupHint' => 'Please free up storage space and try again, or select smaller files.',
			'error.networkErrorHint' => 'Please check your network connection and try again.',
			'error.platformNotSupported' => 'Platform Not Supported',
			'error.fileReadError' => 'File Read Error',
			'error.fileReadErrorHint' => 'The file may be corrupted or in use. Please select a different file.',
			'error.validationError' => 'File Validation Error',
			'error.unknownError' => 'Unknown Error',
			'error.unknownErrorHint' => 'An unexpected error occurred. Please try again or contact support.',
			'error.genui.loadingFailed' => 'Component loading failed',
			'error.genui.schemaFailed' => 'Schema validation failed',
			'error.genui.schemaDescription' => 'Component definition does not comply with GenUI specifications, degraded to plain text display',
			'error.genui.networkError' => 'Network error',
			'error.genui.retryStatus' => ({required Object retryCount, required Object maxRetries}) => 'Retried ${retryCount}/${maxRetries} times',
			'error.genui.maxRetriesReached' => 'Maximum retry attempts reached',
			'fontTest.page' => 'Font Test Page',
			'fontTest.displayTest' => 'Font Display Test',
			'fontTest.chineseTextTest' => 'Chinese Text Test',
			'fontTest.englishTextTest' => 'English Text Test',
			'fontTest.sample1' => 'This is a sample text for testing font display effects.',
			'fontTest.sample2' => 'Expense category summary, shopping is highest',
			'fontTest.sample3' => 'AI assistant provides professional financial analysis services',
			'fontTest.sample4' => 'Data visualization charts show your spending trends',
			'fontTest.sample5' => 'WeChat Pay, Alipay, bank cards and other payment methods',
			'wizard.nextStep' => 'Next',
			'wizard.previousStep' => 'Previous',
			'wizard.completeMapping' => 'Complete',
			'user.username' => 'Username',
			'user.defaultEmail' => 'user@example.com',
			'account.editTitle' => 'Edit Account',
			'account.addTitle' => 'New Account',
			'account.selectTypeTitle' => 'Select Account Type',
			'account.nameLabel' => 'Account Name',
			'account.amountLabel' => 'Current Balance',
			'account.currencyLabel' => 'Currency',
			'account.hiddenLabel' => 'Hidden',
			'account.hiddenDesc' => 'Hide this account from the list',
			'account.includeInNetWorthLabel' => 'Include in Net Worth',
			'account.includeInNetWorthDesc' => 'Count towards total net worth',
			'account.nameHint' => 'e.g. Salary Card',
			'account.amountHint' => '0.00',
			'account.deleteAccount' => 'Delete Account',
			'account.deleteConfirm' => 'Are you sure you want to delete this account? This cannot be undone.',
			'account.save' => 'Save Changes',
			'account.assetsCategory' => 'Assets',
			'account.liabilitiesCategory' => 'Liabilities/Credit',
			'account.cash' => 'Cash Wallet',
			'account.deposit' => 'Bank Deposit',
			'account.creditCard' => 'Credit Card',
			'account.investment' => 'Investment',
			'account.eWallet' => 'E-Wallet',
			'account.loan' => 'Loan',
			'account.receivable' => 'Receivable',
			'account.payable' => 'Payable',
			'account.other' => 'Other',
			'account.types.cashTitle' => 'Cash',
			'account.types.cashSubtitle' => 'Physical currency and coins',
			'account.types.depositTitle' => 'Bank Deposit',
			'account.types.depositSubtitle' => 'Savings, checking accounts',
			'account.types.eMoneyTitle' => 'E-Wallet',
			'account.types.eMoneySubtitle' => 'Digital payment balances',
			'account.types.investmentTitle' => 'Investment',
			'account.types.investmentSubtitle' => 'Stocks, funds, bonds, etc.',
			'account.types.receivableTitle' => 'Receivable',
			'account.types.receivableSubtitle' => 'Loans to others, pending',
			'account.types.receivableHelper' => 'Owed to me',
			'account.types.creditCardTitle' => 'Credit Card',
			'account.types.creditCardSubtitle' => 'Credit card balances',
			'account.types.loanTitle' => 'Loan',
			'account.types.loanSubtitle' => 'Mortgage, auto, personal',
			'account.types.payableTitle' => 'Payable',
			'account.types.payableSubtitle' => 'Amounts owed to others',
			'account.types.payableHelper' => 'I owe',
			'financial.title' => 'Financial',
			'financial.management' => 'Financial Management',
			'financial.netWorth' => 'Total Net Worth',
			'financial.assets' => 'Total Assets',
			'financial.liabilities' => 'Total Liabilities',
			'financial.noAccounts' => 'No accounts yet',
			'financial.addFirstAccount' => 'Tap the button below to add your first account',
			'financial.assetAccounts' => 'Asset Accounts',
			'financial.liabilityAccounts' => 'Liability Accounts',
			'financial.selectCurrency' => 'Select Currency',
			'financial.cancel' => 'Cancel',
			'financial.confirm' => 'Confirm',
			'financial.settings' => 'Financial Settings',
			'financial.budgetManagement' => 'Budget Management',
			'financial.recurringTransactions' => 'Recurring Transactions',
			'financial.safetyThreshold' => 'Safety Threshold',
			'financial.dailyBurnRate' => 'Daily Burn Rate',
			'financial.financialAssistant' => 'Financial Assistant',
			'financial.manageFinancialSettings' => 'Manage your financial settings',
			'financial.safetyThresholdSettings' => 'Safety Threshold Settings',
			'financial.setSafetyThreshold' => 'Set your financial safety threshold',
			'financial.safetyThresholdSaved' => 'Safety threshold saved',
			'financial.dailyBurnRateSettings' => 'Daily Burn Rate',
			'financial.setDailyBurnRate' => 'Set your estimated daily spending',
			'financial.dailyBurnRateSaved' => 'Daily burn rate saved',
			'financial.saveFailed' => 'Save failed',
			'app.splashTitle' => 'Augo: Intelligence that Grows.',
			'app.splashSubtitle' => 'Smart Financial Assistant',
			'statistics.title' => 'Analysis',
			'statistics.analyze' => 'Analysis',
			'statistics.exportInProgress' => 'Export feature coming soon...',
			'statistics.ranking' => 'Top Spending',
			'statistics.noData' => 'No data available',
			'statistics.overview.balance' => 'Total Balance',
			'statistics.overview.income' => 'Total Income',
			'statistics.overview.expense' => 'Total Expense',
			'statistics.trend.title' => 'Trends',
			'statistics.trend.expense' => 'Expense',
			'statistics.trend.income' => 'Income',
			'statistics.analysis.title' => 'Analysis',
			'statistics.analysis.total' => 'Total',
			'statistics.analysis.breakdown' => 'Category Breakdown',
			'statistics.filter.accountType' => 'Account Type',
			'statistics.filter.allAccounts' => 'All Accounts',
			'statistics.filter.apply' => 'Apply',
			'statistics.sort.amount' => 'By Amount',
			'statistics.sort.date' => 'By Time',
			'statistics.exportList' => 'Export List',
			'statistics.emptyState.title' => 'Unlock Financial Insights',
			'statistics.emptyState.description' => 'Your financial report is currently a blank canvas.\nRecord your first transaction and let the data tell your story.',
			'statistics.emptyState.action' => 'Record First Transaction',
			'statistics.noMoreData' => 'No more data',
			'currency.cny' => 'Chinese Yuan',
			'currency.usd' => 'US Dollar',
			'currency.eur' => 'Euro',
			'currency.jpy' => 'Japanese Yen',
			'currency.gbp' => 'British Pound',
			'currency.aud' => 'Australian Dollar',
			'currency.cad' => 'Canadian Dollar',
			'currency.chf' => 'Swiss Franc',
			'currency.rub' => 'Russian Ruble',
			'currency.hkd' => 'Hong Kong Dollar',
			'currency.twd' => 'New Taiwan Dollar',
			'currency.inr' => 'Indian Rupee',
			'budgetSuggestion.highPercentage' => ({required Object category, required Object percentage}) => '${category} accounts for ${percentage}% of spending. Consider setting a budget limit.',
			'budgetSuggestion.monthlyIncrease' => ({required Object percentage}) => 'Spending increased by ${percentage}% this month. Needs attention.',
			'budgetSuggestion.frequentSmall' => ({required Object category, required Object count}) => '${category} has ${count} small transactions. These might be subscriptions.',
			'budgetSuggestion.financialInsights' => 'Financial Insights',
			'server.title' => 'Connect to Server',
			'server.subtitle' => 'Enter your self-hosted server address or scan the QR code displayed when starting the server',
			'server.urlLabel' => 'Server Address',
			'server.urlPlaceholder' => 'e.g. https://api.example.com or 192.168.1.100:8000',
			'server.scanQr' => 'Scan QR Code',
			'server.scanQrInstruction' => 'Point at the QR code displayed in the server terminal',
			'server.testConnection' => 'Test Connection',
			'server.connecting' => 'Connecting...',
			'server.connected' => 'Connected',
			'server.connectionFailed' => 'Connection Failed',
			'server.continueToLogin' => 'Continue to Login',
			'server.saveAndReturn' => 'Save and Return',
			'server.serverSettings' => 'Server Settings',
			'server.currentServer' => 'Current Server',
			'server.version' => 'Version',
			'server.environment' => 'Environment',
			'server.changeServer' => 'Change Server',
			'server.changeServerWarning' => 'Changing server will log you out. Continue?',
			'server.error.urlRequired' => 'Server address is required',
			'server.error.invalidUrl' => 'Invalid URL format',
			'server.error.connectionTimeout' => 'Connection timed out',
			'server.error.connectionRefused' => 'Could not connect to server',
			'server.error.sslError' => 'SSL certificate error',
			'server.error.serverError' => 'Server error',
			'sharedSpace.dashboard.cumulativeTotalExpense' => 'Cumulative Total Expense',
			'sharedSpace.dashboard.participatingMembers' => 'Participating Members',
			'sharedSpace.dashboard.membersCount' => ({required Object count}) => '${count} people',
			'sharedSpace.dashboard.averagePerMember' => 'Avg per member',
			'sharedSpace.dashboard.spendingDistribution' => 'Spending Distribution',
			'sharedSpace.dashboard.realtimeUpdates' => 'Real-time updates',
			'sharedSpace.dashboard.paid' => 'Paid',
			'sharedSpace.roles.owner' => 'Owner',
			'sharedSpace.roles.admin' => 'Admin',
			'sharedSpace.roles.member' => 'Member',
			'errorMapping.generic.badRequest' => 'Bad Request',
			'errorMapping.generic.authFailed' => 'Authentication failed, please login again',
			'errorMapping.generic.permissionDenied' => 'Permission denied',
			'errorMapping.generic.notFound' => 'Resource not found',
			'errorMapping.generic.serverError' => 'Internal server error',
			'errorMapping.generic.systemError' => 'System error',
			'errorMapping.generic.validationFailed' => 'Validation failed',
			'errorMapping.auth.failed' => 'Authentication failed',
			'errorMapping.auth.emailWrong' => 'Incorrect email',
			'errorMapping.auth.phoneWrong' => 'Incorrect phone number',
			'errorMapping.auth.phoneRegistered' => 'Phone number already registered',
			'errorMapping.auth.emailRegistered' => 'Email already registered',
			'errorMapping.auth.sendFailed' => 'Failed to send verification code',
			'errorMapping.auth.expired' => 'Verification code expired',
			'errorMapping.auth.tooFrequent' => 'Code sent too frequently',
			'errorMapping.auth.unsupportedType' => 'Unsupported code type',
			'errorMapping.auth.wrongPassword' => 'Incorrect password',
			'errorMapping.auth.userNotFound' => 'User not found',
			'errorMapping.auth.prefsMissing' => 'Preference parameters missing',
			'errorMapping.auth.invalidTimezone' => 'Invalid client timezone',
			'errorMapping.transaction.commentEmpty' => 'Comment content cannot be empty',
			'errorMapping.transaction.invalidParent' => 'Invalid parent comment ID',
			'errorMapping.transaction.saveFailed' => 'Failed to save comment',
			'errorMapping.transaction.deleteFailed' => 'Failed to delete comment',
			'errorMapping.transaction.notExists' => 'Transaction does not exist',
			'errorMapping.space.notFound' => 'Shared space not found or access denied',
			'errorMapping.space.inviteDenied' => 'No permission to invite members',
			'errorMapping.space.inviteSelf' => 'Cannot invite yourself',
			'errorMapping.space.inviteSent' => 'Invitation sent',
			'errorMapping.space.alreadyMember' => 'User is already a member or invited',
			'errorMapping.space.invalidAction' => 'Invalid action',
			'errorMapping.space.invitationNotFound' => 'Invitation does not exist',
			'errorMapping.space.onlyOwner' => 'Only owner can perform this action',
			'errorMapping.space.ownerNotRemovable' => 'Owner cannot be removed',
			'errorMapping.space.memberNotFound' => 'Member not found',
			'errorMapping.space.notMember' => 'User is not a member of this space',
			'errorMapping.space.ownerCantLeave' => 'Owner cannot leave directly, please transfer ownership first',
			'errorMapping.space.invalidCode' => 'Invalid invitation code',
			'errorMapping.space.codeExpired' => 'Invitation code expired or usage limit reached',
			'errorMapping.recurring.invalidRule' => 'Invalid recurrence rule',
			'errorMapping.recurring.ruleNotFound' => 'Recurrence rule not found',
			'errorMapping.upload.noFile' => 'No file uploaded',
			'errorMapping.upload.tooLarge' => 'File too large',
			'errorMapping.upload.unsupportedType' => 'Unsupported file type',
			'errorMapping.upload.tooManyFiles' => 'Too many files',
			'errorMapping.ai.contextLimit' => 'Context limit exceeded',
			'errorMapping.ai.tokenLimit' => 'Insufficient tokens',
			'errorMapping.ai.emptyMessage' => 'Empty user message',
			_ => null,
		};
	}
}
