///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsCommonEn common = TranslationsCommonEn._(_root);
	late final TranslationsTimeEn time = TranslationsTimeEn._(_root);
	late final TranslationsGreetingEn greeting = TranslationsGreetingEn._(_root);
	late final TranslationsNavigationEn navigation = TranslationsNavigationEn._(_root);
	late final TranslationsAuthEn auth = TranslationsAuthEn._(_root);
	late final TranslationsTransactionEn transaction = TranslationsTransactionEn._(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn._(_root);
	late final TranslationsCommentEn comment = TranslationsCommentEn._(_root);
	late final TranslationsCalendarEn calendar = TranslationsCalendarEn._(_root);
	late final TranslationsCategoryEn category = TranslationsCategoryEn._(_root);
	late final TranslationsSettingsEn settings = TranslationsSettingsEn._(_root);
	late final TranslationsAppearanceEn appearance = TranslationsAppearanceEn._(_root);
	late final TranslationsSpeechEn speech = TranslationsSpeechEn._(_root);
	late final TranslationsAmountThemeEn amountTheme = TranslationsAmountThemeEn._(_root);
	late final TranslationsLocaleEn locale = TranslationsLocaleEn._(_root);
	late final TranslationsBudgetEn budget = TranslationsBudgetEn._(_root);
	late final TranslationsDateRangeEn dateRange = TranslationsDateRangeEn._(_root);
	late final TranslationsForecastEn forecast = TranslationsForecastEn._(_root);
	late final TranslationsChatEn chat = TranslationsChatEn._(_root);
	late final TranslationsFootprintEn footprint = TranslationsFootprintEn._(_root);
	late final TranslationsMediaEn media = TranslationsMediaEn._(_root);
	late final TranslationsErrorEn error = TranslationsErrorEn._(_root);
	late final TranslationsFontTestEn fontTest = TranslationsFontTestEn._(_root);
	late final TranslationsWizardEn wizard = TranslationsWizardEn._(_root);
	late final TranslationsUserEn user = TranslationsUserEn._(_root);
	late final TranslationsAccountEn account = TranslationsAccountEn._(_root);
	late final TranslationsFinancialEn financial = TranslationsFinancialEn._(_root);
	late final TranslationsAppEn app = TranslationsAppEn._(_root);
	late final TranslationsStatisticsEn statistics = TranslationsStatisticsEn._(_root);
	late final TranslationsCurrencyEn currency = TranslationsCurrencyEn._(_root);
	late final TranslationsBudgetSuggestionEn budgetSuggestion = TranslationsBudgetSuggestionEn._(_root);
	late final TranslationsServerEn server = TranslationsServerEn._(_root);
	late final TranslationsSharedSpaceEn sharedSpace = TranslationsSharedSpaceEn._(_root);
	late final TranslationsErrorMappingEn errorMapping = TranslationsErrorMappingEn._(_root);
}

// Path: common
class TranslationsCommonEn {
	TranslationsCommonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'Error'
	String get error => 'Error';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Add'
	String get add => 'Add';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'Filter'
	String get filter => 'Filter';

	/// en: 'Sort'
	String get sort => 'Sort';

	/// en: 'Refresh'
	String get refresh => 'Refresh';

	/// en: 'More'
	String get more => 'More';

	/// en: 'Less'
	String get less => 'Less';

	/// en: 'All'
	String get all => 'All';

	/// en: 'None'
	String get none => 'None';

	/// en: 'OK'
	String get ok => 'OK';

	/// en: 'Unknown'
	String get unknown => 'Unknown';

	/// en: 'No Data'
	String get noData => 'No Data';

	/// en: 'Load More'
	String get loadMore => 'Load More';

	/// en: 'No More'
	String get noMore => 'No More';

	/// en: 'Loading failed'
	String get loadFailed => 'Loading failed';

	/// en: 'Transactions'
	String get history => 'Transactions';

	/// en: 'Reset'
	String get reset => 'Reset';
}

// Path: time
class TranslationsTimeEn {
	TranslationsTimeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Today'
	String get today => 'Today';

	/// en: 'Yesterday'
	String get yesterday => 'Yesterday';

	/// en: 'Day Before Yesterday'
	String get dayBeforeYesterday => 'Day Before Yesterday';

	/// en: 'Week'
	String get thisWeek => 'Week';

	/// en: 'Month'
	String get thisMonth => 'Month';

	/// en: 'Year'
	String get thisYear => 'Year';

	/// en: 'Select Date'
	String get selectDate => 'Select Date';

	/// en: 'Select Time'
	String get selectTime => 'Select Time';

	/// en: 'Just now'
	String get justNow => 'Just now';

	/// en: '${count}m ago'
	String minutesAgo({required Object count}) => '${count}m ago';

	/// en: '${count}h ago'
	String hoursAgo({required Object count}) => '${count}h ago';

	/// en: '${count}d ago'
	String daysAgo({required Object count}) => '${count}d ago';

	/// en: '${count}w ago'
	String weeksAgo({required Object count}) => '${count}w ago';
}

// Path: greeting
class TranslationsGreetingEn {
	TranslationsGreetingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Good Morning'
	String get morning => 'Good Morning';

	/// en: 'Good Afternoon'
	String get afternoon => 'Good Afternoon';

	/// en: 'Good Evening'
	String get evening => 'Good Evening';
}

// Path: navigation
class TranslationsNavigationEn {
	TranslationsNavigationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Forecast'
	String get forecast => 'Forecast';

	/// en: 'Footprint'
	String get footprint => 'Footprint';

	/// en: 'Profile'
	String get profile => 'Profile';
}

// Path: auth
class TranslationsAuthEn {
	TranslationsAuthEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Log In'
	String get login => 'Log In';

	/// en: 'Logging in...'
	String get loggingIn => 'Logging in...';

	/// en: 'Log Out'
	String get logout => 'Log Out';

	/// en: 'Logged out successfully'
	String get logoutSuccess => 'Logged out successfully';

	/// en: 'Confirm Logout'
	String get confirmLogoutTitle => 'Confirm Logout';

	/// en: 'Are you sure you want to log out?'
	String get confirmLogoutContent => 'Are you sure you want to log out?';

	/// en: 'Sign Up'
	String get register => 'Sign Up';

	/// en: 'Signing up...'
	String get registering => 'Signing up...';

	/// en: 'Welcome Back'
	String get welcomeBack => 'Welcome Back';

	/// en: 'Welcome back!'
	String get loginSuccess => 'Welcome back!';

	/// en: 'Login Failed'
	String get loginFailed => 'Login Failed';

	/// en: 'Please try again later.'
	String get pleaseTryAgain => 'Please try again later.';

	/// en: 'Log in to continue using Augo'
	String get loginSubtitle => 'Log in to continue using Augo';

	/// en: 'Don't have an account? Sign Up'
	String get noAccount => 'Don\'t have an account? Sign Up';

	/// en: 'Create Your Account'
	String get createAccount => 'Create Your Account';

	/// en: 'Set Password'
	String get setPassword => 'Set Password';

	/// en: 'Set Your Account Password'
	String get setAccountPassword => 'Set Your Account Password';

	/// en: 'Complete Registration'
	String get completeRegistration => 'Complete Registration';

	/// en: 'Registration successful!'
	String get registrationSuccess => 'Registration successful!';

	/// en: 'Registration failed'
	String get registrationFailed => 'Registration failed';

	late final TranslationsAuthEmailEn email = TranslationsAuthEmailEn._(_root);
	late final TranslationsAuthPasswordEn password = TranslationsAuthPasswordEn._(_root);
	late final TranslationsAuthVerificationCodeEn verificationCode = TranslationsAuthVerificationCodeEn._(_root);
}

// Path: transaction
class TranslationsTransactionEn {
	TranslationsTransactionEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Expense'
	String get expense => 'Expense';

	/// en: 'Income'
	String get income => 'Income';

	/// en: 'Transfer'
	String get transfer => 'Transfer';

	/// en: 'Amount'
	String get amount => 'Amount';

	/// en: 'Category'
	String get category => 'Category';

	/// en: 'Description'
	String get description => 'Description';

	/// en: 'Tags'
	String get tags => 'Tags';

	/// en: 'Save Transaction'
	String get saveTransaction => 'Save Transaction';

	/// en: 'Please enter amount'
	String get pleaseEnterAmount => 'Please enter amount';

	/// en: 'Please select category'
	String get pleaseSelectCategory => 'Please select category';

	/// en: 'Failed to save'
	String get saveFailed => 'Failed to save';

	/// en: 'Record details of this transaction...'
	String get descriptionHint => 'Record details of this transaction...';

	/// en: 'Add Custom Tag'
	String get addCustomTag => 'Add Custom Tag';

	/// en: 'Common Tags'
	String get commonTags => 'Common Tags';

	/// en: 'Maximum $maxTags tags allowed'
	String maxTagsHint({required Object maxTags}) => 'Maximum ${maxTags} tags allowed';

	/// en: 'No transactions found'
	String get noTransactionsFound => 'No transactions found';

	/// en: 'Try adjusting search criteria or create new transactions'
	String get tryAdjustingSearch => 'Try adjusting search criteria or create new transactions';

	/// en: 'No description'
	String get noDescription => 'No description';

	/// en: 'Payment'
	String get payment => 'Payment';

	/// en: 'Account'
	String get account => 'Account';

	/// en: 'Time'
	String get time => 'Time';

	/// en: 'Location'
	String get location => 'Location';

	/// en: 'Transaction Details'
	String get transactionDetail => 'Transaction Details';

	/// en: 'Favorite'
	String get favorite => 'Favorite';

	/// en: 'Confirm Delete'
	String get confirmDelete => 'Confirm Delete';

	/// en: 'Are you sure you want to delete this transaction? This action cannot be undone.'
	String get deleteTransactionConfirm => 'Are you sure you want to delete this transaction? This action cannot be undone.';

	/// en: 'No actions available'
	String get noActions => 'No actions available';

	/// en: 'Deleted'
	String get deleted => 'Deleted';

	/// en: 'Delete failed, please try again'
	String get deleteFailed => 'Delete failed, please try again';

	/// en: 'Linked Account'
	String get linkedAccount => 'Linked Account';

	/// en: 'Linked Space'
	String get linkedSpace => 'Linked Space';

	/// en: 'Not linked'
	String get notLinked => 'Not linked';

	/// en: 'Link'
	String get link => 'Link';

	/// en: 'Change Account'
	String get changeAccount => 'Change Account';

	/// en: 'Add Space'
	String get addSpace => 'Add Space';

	/// en: '$count spaces'
	String nSpaces({required Object count}) => '${count} spaces';

	/// en: 'Select Linked Account'
	String get selectLinkedAccount => 'Select Linked Account';

	/// en: 'Select Linked Space'
	String get selectLinkedSpace => 'Select Linked Space';

	/// en: 'No spaces available'
	String get noSpacesAvailable => 'No spaces available';

	/// en: 'Link successful'
	String get linkSuccess => 'Link successful';

	/// en: 'Link failed'
	String get linkFailed => 'Link failed';

	/// en: 'Message'
	String get rawInput => 'Message';

	/// en: 'No message'
	String get noRawInput => 'No message';
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Total Expense'
	String get totalExpense => 'Total Expense';

	/// en: 'Today's'
	String get todayExpense => 'Today\'s';

	/// en: 'This Month's'
	String get monthExpense => 'This Month\'s';

	/// en: '$year Progress'
	String yearProgress({required Object year}) => '${year} Progress';

	/// en: '••••••••'
	String get amountHidden => '••••••••';

	/// en: 'Load failed'
	String get loadFailed => 'Load failed';

	/// en: 'No transactions'
	String get noTransactions => 'No transactions';

	/// en: 'Pull to refresh'
	String get tryRefresh => 'Pull to refresh';

	/// en: 'No more data'
	String get noMoreData => 'No more data';

	/// en: 'User not logged in'
	String get userNotLoggedIn => 'User not logged in';
}

// Path: comment
class TranslationsCommentEn {
	TranslationsCommentEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Error'
	String get error => 'Error';

	/// en: 'Comment failed'
	String get commentFailed => 'Comment failed';

	/// en: 'Reply to @$name:'
	String replyToPrefix({required Object name}) => 'Reply to @${name}:';

	/// en: 'Reply'
	String get reply => 'Reply';

	/// en: 'Add a note...'
	String get addNote => 'Add a note...';

	/// en: 'Confirm Delete'
	String get confirmDeleteTitle => 'Confirm Delete';

	/// en: 'Are you sure you want to delete this comment? This action cannot be undone.'
	String get confirmDeleteContent => 'Are you sure you want to delete this comment? This action cannot be undone.';

	/// en: 'Success'
	String get success => 'Success';

	/// en: 'Comment deleted'
	String get commentDeleted => 'Comment deleted';

	/// en: 'Failed to delete'
	String get deleteFailed => 'Failed to delete';

	/// en: 'Delete Comment'
	String get deleteComment => 'Delete Comment';

	/// en: 'Hint'
	String get hint => 'Hint';

	/// en: 'No actions available'
	String get noActions => 'No actions available';

	/// en: 'Note'
	String get note => 'Note';

	/// en: 'No notes yet'
	String get noNote => 'No notes yet';

	/// en: 'Failed to load notes'
	String get loadFailed => 'Failed to load notes';
}

// Path: calendar
class TranslationsCalendarEn {
	TranslationsCalendarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Expense Calendar'
	String get title => 'Expense Calendar';

	late final TranslationsCalendarWeekdaysEn weekdays = TranslationsCalendarWeekdaysEn._(_root);

	/// en: 'Failed to load calendar data'
	String get loadFailed => 'Failed to load calendar data';

	/// en: 'Month: $amount'
	String thisMonth({required Object amount}) => 'Month: ${amount}';

	/// en: 'Counting...'
	String get counting => 'Counting...';

	/// en: 'Unable to count'
	String get unableToCount => 'Unable to count';

	/// en: 'Trend: '
	String get trend => 'Trend: ';

	/// en: 'No transactions on this day'
	String get noTransactionsTitle => 'No transactions on this day';

	/// en: 'Failed to load transactions'
	String get loadTransactionFailed => 'Failed to load transactions';
}

// Path: category
class TranslationsCategoryEn {
	TranslationsCategoryEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Daily Expenses'
	String get dailyConsumption => 'Daily Expenses';

	/// en: 'Transportation'
	String get transportation => 'Transportation';

	/// en: 'Healthcare'
	String get healthcare => 'Healthcare';

	/// en: 'Housing & Utilities'
	String get housing => 'Housing & Utilities';

	/// en: 'Education'
	String get education => 'Education';

	/// en: 'Income'
	String get incomeCategory => 'Income';

	/// en: 'Gifts & Donations'
	String get socialGifts => 'Gifts & Donations';

	/// en: 'Transfers'
	String get moneyTransfer => 'Transfers';

	/// en: 'Other'
	String get other => 'Other';

	/// en: 'Food & Dining'
	String get foodDining => 'Food & Dining';

	/// en: 'Shopping'
	String get shoppingRetail => 'Shopping';

	/// en: 'Housing & Utilities'
	String get housingUtilities => 'Housing & Utilities';

	/// en: 'Personal Care'
	String get personalCare => 'Personal Care';

	/// en: 'Entertainment'
	String get entertainment => 'Entertainment';

	/// en: 'Medical & Health'
	String get medicalHealth => 'Medical & Health';

	/// en: 'Insurance'
	String get insurance => 'Insurance';

	/// en: 'Social & Gifting'
	String get socialGifting => 'Social & Gifting';

	/// en: 'Financial & Tax'
	String get financialTax => 'Financial & Tax';

	/// en: 'Others'
	String get others => 'Others';

	/// en: 'Salary'
	String get salaryWage => 'Salary';

	/// en: 'Business'
	String get businessTrade => 'Business';

	/// en: 'Investment Returns'
	String get investmentReturns => 'Investment Returns';

	/// en: 'Gift & Bonus'
	String get giftBonus => 'Gift & Bonus';

	/// en: 'Refund'
	String get refundRebate => 'Refund';

	/// en: 'Transfer'
	String get generalTransfer => 'Transfer';

	/// en: 'Debt Repayment'
	String get debtRepayment => 'Debt Repayment';
}

// Path: settings
class TranslationsSettingsEn {
	TranslationsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Language Settings'
	String get languageSettings => 'Language Settings';

	/// en: 'Select Language'
	String get selectLanguage => 'Select Language';

	/// en: 'Language Changed'
	String get languageChanged => 'Language Changed';

	/// en: 'Restart app to apply changes'
	String get restartToApply => 'Restart app to apply changes';

	/// en: 'Theme'
	String get theme => 'Theme';

	/// en: 'Dark Mode'
	String get darkMode => 'Dark Mode';

	/// en: 'Light Mode'
	String get lightMode => 'Light Mode';

	/// en: 'Follow System'
	String get systemMode => 'Follow System';

	/// en: 'Developer Options'
	String get developerOptions => 'Developer Options';

	/// en: 'Auth Debug'
	String get authDebug => 'Auth Debug';

	/// en: 'View authentication status and debug info'
	String get authDebugSubtitle => 'View authentication status and debug info';

	/// en: 'Font Test'
	String get fontTest => 'Font Test';

	/// en: 'Test application font display'
	String get fontTestSubtitle => 'Test application font display';

	/// en: 'Help & Feedback'
	String get helpAndFeedback => 'Help & Feedback';

	/// en: 'Get help or provide feedback'
	String get helpAndFeedbackSubtitle => 'Get help or provide feedback';

	/// en: 'About'
	String get aboutApp => 'About';

	/// en: 'Version info and developer information'
	String get aboutAppSubtitle => 'Version info and developer information';

	/// en: 'Switched to $currency. New transactions will use this currency.'
	String currencyChangedRefreshHint({required Object currency}) => 'Switched to ${currency}. New transactions will use this currency.';

	/// en: 'Shared Space'
	String get sharedSpace => 'Shared Space';

	/// en: 'Speech Recognition'
	String get speechRecognition => 'Speech Recognition';

	/// en: 'Configure voice input parameters'
	String get speechRecognitionSubtitle => 'Configure voice input parameters';

	/// en: 'Amount Display Style'
	String get amountDisplayStyle => 'Amount Display Style';

	/// en: 'Currency'
	String get currency => 'Currency';

	/// en: 'Appearance Settings'
	String get appearance => 'Appearance Settings';

	/// en: 'Theme mode and color scheme'
	String get appearanceSubtitle => 'Theme mode and color scheme';

	/// en: 'Speech Test'
	String get speechTest => 'Speech Test';

	/// en: 'Test WebSocket speech connection'
	String get speechTestSubtitle => 'Test WebSocket speech connection';

	/// en: 'Regular User'
	String get userTypeRegular => 'Regular User';

	/// en: 'Select Amount Display Style'
	String get selectAmountStyle => 'Select Amount Display Style';

	/// en: 'Note: Amount styles are primarily applied to 'Transactions' and 'Trends'. To maintain visual clarity, 'Account Balances' and 'Asset Summaries' will remain in neutral colors.'
	String get amountStyleNotice => 'Note: Amount styles are primarily applied to \'Transactions\' and \'Trends\'. To maintain visual clarity, \'Account Balances\' and \'Asset Summaries\' will remain in neutral colors.';

	/// en: 'Choose your preferred display currency. All amounts will be displayed in this currency.'
	String get currencyDescription => 'Choose your preferred display currency. All amounts will be displayed in this currency.';

	/// en: 'Edit Username'
	String get editUsername => 'Edit Username';

	/// en: 'Enter username'
	String get enterUsername => 'Enter username';

	/// en: 'Username is required'
	String get usernameRequired => 'Username is required';

	/// en: 'Username updated'
	String get usernameUpdated => 'Username updated';

	/// en: 'Avatar updated'
	String get avatarUpdated => 'Avatar updated';
}

// Path: appearance
class TranslationsAppearanceEn {
	TranslationsAppearanceEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Appearance Settings'
	String get title => 'Appearance Settings';

	/// en: 'Theme Mode'
	String get themeMode => 'Theme Mode';

	/// en: 'Light'
	String get light => 'Light';

	/// en: 'Dark'
	String get dark => 'Dark';

	/// en: 'System'
	String get system => 'System';

	/// en: 'Color Scheme'
	String get colorScheme => 'Color Scheme';

	late final TranslationsAppearancePalettesEn palettes = TranslationsAppearancePalettesEn._(_root);
}

// Path: speech
class TranslationsSpeechEn {
	TranslationsSpeechEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Speech Recognition Settings'
	String get title => 'Speech Recognition Settings';

	/// en: 'Speech Recognition Service'
	String get service => 'Speech Recognition Service';

	/// en: 'System Voice'
	String get systemVoice => 'System Voice';

	/// en: 'Use built-in device service (Recommended)'
	String get systemVoiceSubtitle => 'Use built-in device service (Recommended)';

	/// en: 'Self-hosted ASR'
	String get selfHostedASR => 'Self-hosted ASR';

	/// en: 'Use WebSocket connection to self-hosted service'
	String get selfHostedASRSubtitle => 'Use WebSocket connection to self-hosted service';

	/// en: 'Server Configuration'
	String get serverConfig => 'Server Configuration';

	/// en: 'Server Address'
	String get serverAddress => 'Server Address';

	/// en: 'Port'
	String get port => 'Port';

	/// en: 'Path'
	String get path => 'Path';

	/// en: 'Save Configuration'
	String get saveConfig => 'Save Configuration';

	/// en: 'Information'
	String get info => 'Information';

	/// en: '• System Voice: Uses device service, no config needed, faster response • Self-hosted ASR: Suitable for custom models or offline scenarios Changes will take effect next time you use voice input.'
	String get infoContent => '• System Voice: Uses device service, no config needed, faster response\n• Self-hosted ASR: Suitable for custom models or offline scenarios\n\nChanges will take effect next time you use voice input.';

	/// en: 'Please enter server address'
	String get enterAddress => 'Please enter server address';

	/// en: 'Please enter a valid port (1-65535)'
	String get enterValidPort => 'Please enter a valid port (1-65535)';

	/// en: 'Configuration saved'
	String get configSaved => 'Configuration saved';
}

// Path: amountTheme
class TranslationsAmountThemeEn {
	TranslationsAmountThemeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'China Market Style'
	String get chinaMarket => 'China Market Style';

	/// en: 'Red up, Green/Black down (Recommended)'
	String get chinaMarketDesc => 'Red up, Green/Black down (Recommended)';

	/// en: 'International Standard'
	String get international => 'International Standard';

	/// en: 'Green up, Red down'
	String get internationalDesc => 'Green up, Red down';

	/// en: 'Minimalist'
	String get minimalist => 'Minimalist';

	/// en: 'Distinguish with symbols only'
	String get minimalistDesc => 'Distinguish with symbols only';

	/// en: 'Color Blind Friendly'
	String get colorBlind => 'Color Blind Friendly';

	/// en: 'Blue-Orange color scheme'
	String get colorBlindDesc => 'Blue-Orange color scheme';
}

// Path: locale
class TranslationsLocaleEn {
	TranslationsLocaleEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Simplified Chinese'
	String get chinese => 'Simplified Chinese';

	/// en: 'English'
	String get english => 'English';

	/// en: 'Japanese'
	String get japanese => 'Japanese';

	/// en: 'Korean'
	String get korean => 'Korean';

	/// en: 'Traditional Chinese'
	String get traditionalChinese => 'Traditional Chinese';
}

// Path: budget
class TranslationsBudgetEn {
	TranslationsBudgetEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Budget Management'
	String get title => 'Budget Management';

	/// en: 'Budget Details'
	String get detail => 'Budget Details';

	/// en: 'Budget Info'
	String get info => 'Budget Info';

	/// en: 'Total Budget'
	String get totalBudget => 'Total Budget';

	/// en: 'Category Budget'
	String get categoryBudget => 'Category Budget';

	/// en: 'Monthly Budget Summary'
	String get monthlySummary => 'Monthly Budget Summary';

	/// en: 'Used'
	String get used => 'Used';

	/// en: 'Remaining'
	String get remaining => 'Remaining';

	/// en: 'Overspent'
	String get overspent => 'Overspent';

	/// en: 'Budget'
	String get budget => 'Budget';

	/// en: 'Failed to load'
	String get loadFailed => 'Failed to load';

	/// en: 'No budgets yet'
	String get noBudget => 'No budgets yet';

	/// en: 'Say "Help me set a budget" to your Augo assistant'
	String get createHint => 'Say "Help me set a budget" to your Augo assistant';

	/// en: 'Paused'
	String get paused => 'Paused';

	/// en: 'Pause'
	String get pause => 'Pause';

	/// en: 'Resume'
	String get resume => 'Resume';

	/// en: 'Budget paused'
	String get budgetPaused => 'Budget paused';

	/// en: 'Budget resumed'
	String get budgetResumed => 'Budget resumed';

	/// en: 'Operation failed'
	String get operationFailed => 'Operation failed';

	/// en: 'Delete Budget'
	String get deleteBudget => 'Delete Budget';

	/// en: 'Are you sure you want to delete this budget? This cannot be undone.'
	String get deleteConfirm => 'Are you sure you want to delete this budget? This cannot be undone.';

	/// en: 'Type'
	String get type => 'Type';

	/// en: 'Category'
	String get category => 'Category';

	/// en: 'Repeat Rule'
	String get period => 'Repeat Rule';

	/// en: 'Rollover'
	String get rollover => 'Rollover';

	/// en: 'Rollover Balance'
	String get rolloverBalance => 'Rollover Balance';

	/// en: 'Enabled'
	String get enabled => 'Enabled';

	/// en: 'Disabled'
	String get disabled => 'Disabled';

	/// en: 'On Track'
	String get statusNormal => 'On Track';

	/// en: 'Near Limit'
	String get statusWarning => 'Near Limit';

	/// en: 'Overspent'
	String get statusOverspent => 'Overspent';

	/// en: 'Goal Achieved'
	String get statusAchieved => 'Goal Achieved';

	/// en: '$amount remaining'
	String tipNormal({required Object amount}) => '${amount} remaining';

	/// en: 'Only $amount left, be careful'
	String tipWarning({required Object amount}) => 'Only ${amount} left, be careful';

	/// en: 'Overspent by $amount'
	String tipOverspent({required Object amount}) => 'Overspent by ${amount}';

	/// en: 'Congratulations on achieving your savings goal!'
	String get tipAchieved => 'Congratulations on achieving your savings goal!';

	/// en: '$amount remaining'
	String remainingAmount({required Object amount}) => '${amount} remaining';

	/// en: 'Overspent $amount'
	String overspentAmount({required Object amount}) => 'Overspent ${amount}';

	/// en: 'Budget $amount'
	String budgetAmount({required Object amount}) => 'Budget ${amount}';

	/// en: 'Active'
	String get active => 'Active';

	/// en: 'All'
	String get all => 'All';

	/// en: 'Budget not found or deleted'
	String get notFound => 'Budget not found or deleted';

	/// en: 'Budget Setup'
	String get setup => 'Budget Setup';

	/// en: 'Budget Settings'
	String get settings => 'Budget Settings';

	/// en: 'Set Budget Amount'
	String get setAmount => 'Set Budget Amount';

	/// en: 'Set budget amount for each category'
	String get setAmountDesc => 'Set budget amount for each category';

	/// en: 'Monthly Budget'
	String get monthly => 'Monthly Budget';

	/// en: 'Manage expenses monthly, suitable for most users'
	String get monthlyDesc => 'Manage expenses monthly, suitable for most users';

	/// en: 'Weekly Budget'
	String get weekly => 'Weekly Budget';

	/// en: 'Manage expenses weekly for finer control'
	String get weeklyDesc => 'Manage expenses weekly for finer control';

	/// en: 'Annual Budget'
	String get yearly => 'Annual Budget';

	/// en: 'Long-term financial planning for major expenses'
	String get yearlyDesc => 'Long-term financial planning for major expenses';

	/// en: 'Edit Budget'
	String get editBudget => 'Edit Budget';

	/// en: 'Modify budget amounts and categories'
	String get editBudgetDesc => 'Modify budget amounts and categories';

	/// en: 'Reminder Settings'
	String get reminderSettings => 'Reminder Settings';

	/// en: 'Set budget reminders and notifications'
	String get reminderSettingsDesc => 'Set budget reminders and notifications';

	/// en: 'Budget Report'
	String get report => 'Budget Report';

	/// en: 'View detailed budget analysis reports'
	String get reportDesc => 'View detailed budget analysis reports';

	/// en: 'Welcome to Budget Feature!'
	String get welcome => 'Welcome to Budget Feature!';

	/// en: 'Create New Budget Plan'
	String get createNewPlan => 'Create New Budget Plan';

	/// en: 'Set budgets to better control spending and achieve financial goals. Let's start setting up your first budget plan!'
	String get welcomeDesc => 'Set budgets to better control spending and achieve financial goals. Let\'s start setting up your first budget plan!';

	/// en: 'Set budget limits for different spending categories to manage your finances better.'
	String get createDesc => 'Set budget limits for different spending categories to manage your finances better.';

	/// en: 'New Budget'
	String get newBudget => 'New Budget';

	/// en: 'Budget Amount'
	String get budgetAmountLabel => 'Budget Amount';

	/// en: 'Currency'
	String get currency => 'Currency';

	/// en: 'Period Settings'
	String get periodSettings => 'Period Settings';

	/// en: 'Automatically generate transactions by rule'
	String get autoGenerateTransactions => 'Automatically generate transactions by rule';

	/// en: 'Cycle'
	String get cycle => 'Cycle';

	/// en: 'Budget Category'
	String get budgetCategory => 'Budget Category';

	/// en: 'Advanced Options'
	String get advancedOptions => 'Advanced Options';

	/// en: 'Period Type'
	String get periodType => 'Period Type';

	/// en: 'Anchor Day'
	String get anchorDay => 'Anchor Day';

	/// en: 'Select Period Type'
	String get selectPeriodType => 'Select Period Type';

	/// en: 'Select Anchor Day'
	String get selectAnchorDay => 'Select Anchor Day';

	/// en: 'Carry over unused budget to next period'
	String get rolloverDescription => 'Carry over unused budget to next period';

	/// en: 'Create Budget'
	String get createBudget => 'Create Budget';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Please enter budget amount'
	String get pleaseEnterAmount => 'Please enter budget amount';

	/// en: 'Please enter a valid amount'
	String get invalidAmount => 'Please enter a valid amount';

	/// en: 'Budget updated successfully'
	String get updateSuccess => 'Budget updated successfully';

	/// en: 'Budget created successfully'
	String get createSuccess => 'Budget created successfully';

	/// en: 'Budget deleted'
	String get deleteSuccess => 'Budget deleted';

	/// en: 'Delete failed'
	String get deleteFailed => 'Delete failed';

	/// en: 'Day $day of each month'
	String everyMonthDay({required Object day}) => 'Day ${day} of each month';

	/// en: 'Weekly'
	String get periodWeekly => 'Weekly';

	/// en: 'Biweekly'
	String get periodBiweekly => 'Biweekly';

	/// en: 'Monthly'
	String get periodMonthly => 'Monthly';

	/// en: 'Yearly'
	String get periodYearly => 'Yearly';

	/// en: 'Active'
	String get statusActive => 'Active';

	/// en: 'Archived'
	String get statusArchived => 'Archived';

	/// en: 'On Track'
	String get periodStatusOnTrack => 'On Track';

	/// en: 'Warning'
	String get periodStatusWarning => 'Warning';

	/// en: 'Exceeded'
	String get periodStatusExceeded => 'Exceeded';

	/// en: 'Achieved'
	String get periodStatusAchieved => 'Achieved';

	/// en: '$percent% used'
	String usedPercent({required Object percent}) => '${percent}% used';

	/// en: 'Day $day'
	String dayOfMonth({required Object day}) => 'Day ${day}';

	/// en: '0k'
	String get tenThousandSuffix => '0k';
}

// Path: dateRange
class TranslationsDateRangeEn {
	TranslationsDateRangeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Custom'
	String get custom => 'Custom';

	/// en: 'Select Date Range'
	String get pickerTitle => 'Select Date Range';

	/// en: 'Start Date'
	String get startDate => 'Start Date';

	/// en: 'End Date'
	String get endDate => 'End Date';

	/// en: 'Please select a date range'
	String get hint => 'Please select a date range';
}

// Path: forecast
class TranslationsForecastEn {
	TranslationsForecastEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Forecast'
	String get title => 'Forecast';

	/// en: 'AI-powered cash flow predictions based on your financial data'
	String get subtitle => 'AI-powered cash flow predictions based on your financial data';

	/// en: 'Hello, I'm your Financial Navigator'
	String get financialNavigator => 'Hello, I\'m your Financial Navigator';

	/// en: 'In just 3 steps, let's map your financial future together'
	String get financialMapSubtitle => 'In just 3 steps, let\'s map your financial future together';

	/// en: 'Predict Cash Flow'
	String get predictCashFlow => 'Predict Cash Flow';

	/// en: 'See your daily financial status'
	String get predictCashFlowDesc => 'See your daily financial status';

	/// en: 'AI Smart Suggestions'
	String get aiSmartSuggestions => 'AI Smart Suggestions';

	/// en: 'Personalized financial decision guidance'
	String get aiSmartSuggestionsDesc => 'Personalized financial decision guidance';

	/// en: 'Risk Alerts'
	String get riskWarning => 'Risk Alerts';

	/// en: 'Detect potential financial risks early'
	String get riskWarningDesc => 'Detect potential financial risks early';

	/// en: 'Analyzing your financial data to generate a 30-day cash flow forecast'
	String get analyzing => 'Analyzing your financial data to generate a 30-day cash flow forecast';

	/// en: 'Analyzing income & expense patterns'
	String get analyzePattern => 'Analyzing income & expense patterns';

	/// en: 'Calculating cash flow trends'
	String get calculateTrend => 'Calculating cash flow trends';

	/// en: 'Generating risk alerts'
	String get generateWarning => 'Generating risk alerts';

	/// en: 'Loading financial forecast...'
	String get loadingForecast => 'Loading financial forecast...';

	/// en: 'Today'
	String get todayLabel => 'Today';

	/// en: 'Tomorrow'
	String get tomorrowLabel => 'Tomorrow';

	/// en: 'Balance'
	String get balanceLabel => 'Balance';

	/// en: 'No special events'
	String get noSpecialEvents => 'No special events';

	/// en: 'Financial Safety Net'
	String get financialSafetyLine => 'Financial Safety Net';

	/// en: 'Current Setting'
	String get currentSetting => 'Current Setting';

	/// en: 'Daily Spending Estimate'
	String get dailySpendingEstimate => 'Daily Spending Estimate';

	/// en: 'Adjust daily spending forecast amount'
	String get adjustDailySpendingAmount => 'Adjust daily spending forecast amount';

	/// en: 'What's your financial safety threshold?'
	String get tellMeYourSafetyLine => 'What\'s your financial safety threshold?';

	/// en: 'This is the minimum balance you want to maintain. I'll alert you when your balance approaches this amount.'
	String get safetyLineDescription => 'This is the minimum balance you want to maintain. I\'ll alert you when your balance approaches this amount.';

	/// en: 'How much do you spend daily?'
	String get dailySpendingQuestion => 'How much do you spend daily?';

	/// en: 'Including meals, transportation, shopping and other daily expenses This is just an initial estimate - predictions will improve with your actual records'
	String get dailySpendingDescription => 'Including meals, transportation, shopping and other daily expenses\nThis is just an initial estimate - predictions will improve with your actual records';

	/// en: 'per day'
	String get perDay => 'per day';

	/// en: 'Reference'
	String get referenceStandard => 'Reference';

	/// en: 'Frugal'
	String get frugalType => 'Frugal';

	/// en: 'Comfortable'
	String get comfortableType => 'Comfortable';

	/// en: 'Relaxed'
	String get relaxedType => 'Relaxed';

	/// en: '¥50-100/day'
	String get frugalAmount => '¥50-100/day';

	/// en: '¥100-200/day'
	String get comfortableAmount => '¥100-200/day';

	/// en: '¥200-300/day'
	String get relaxedAmount => '¥200-300/day';

	late final TranslationsForecastRecurringTransactionEn recurringTransaction = TranslationsForecastRecurringTransactionEn._(_root);
}

// Path: chat
class TranslationsChatEn {
	TranslationsChatEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'New Chat'
	String get newChat => 'New Chat';

	/// en: 'No messages to display.'
	String get noMessages => 'No messages to display.';

	/// en: 'Loading failed'
	String get loadingFailed => 'Loading failed';

	/// en: 'Type a message...'
	String get inputMessage => 'Type a message...';

	/// en: 'AI processing...'
	String get aiThinking => 'AI processing...';

	/// en: 'Listening...'
	String get listening => 'Listening...';

	late final TranslationsChatToolsEn tools = TranslationsChatToolsEn._(_root);

	/// en: 'Speech not recognized, please try again'
	String get speechNotRecognized => 'Speech not recognized, please try again';

	/// en: 'Session Expense'
	String get currentExpense => 'Session Expense';

	/// en: 'Loading component...'
	String get loadingComponent => 'Loading component...';

	/// en: 'No historical sessions'
	String get noHistory => 'No historical sessions';

	/// en: 'Start a new conversation!'
	String get startNewChat => 'Start a new conversation!';

	/// en: 'Search conversations'
	String get searchHint => 'Search conversations';

	/// en: 'Library'
	String get library => 'Library';

	/// en: 'View profile'
	String get viewProfile => 'View profile';

	/// en: 'No related conversations found'
	String get noRelatedFound => 'No related conversations found';

	/// en: 'Try searching with other keywords'
	String get tryOtherKeywords => 'Try searching with other keywords';

	/// en: 'Search failed'
	String get searchFailed => 'Search failed';

	/// en: 'Delete Conversation'
	String get deleteConversation => 'Delete Conversation';

	/// en: 'Are you sure you want to delete this conversation? This action cannot be undone.'
	String get deleteConversationConfirm => 'Are you sure you want to delete this conversation? This action cannot be undone.';

	/// en: 'Conversation deleted'
	String get conversationDeleted => 'Conversation deleted';

	/// en: 'Failed to delete conversation'
	String get deleteConversationFailed => 'Failed to delete conversation';

	late final TranslationsChatTransferWizardEn transferWizard = TranslationsChatTransferWizardEn._(_root);
	late final TranslationsChatGenuiEn genui = TranslationsChatGenuiEn._(_root);
	late final TranslationsChatWelcomeEn welcome = TranslationsChatWelcomeEn._(_root);
}

// Path: footprint
class TranslationsFootprintEn {
	TranslationsFootprintEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Search'
	String get searchIn => 'Search';

	/// en: 'Search in all records'
	String get searchInAllRecords => 'Search in all records';
}

// Path: media
class TranslationsMediaEn {
	TranslationsMediaEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Select Photos'
	String get selectPhotos => 'Select Photos';

	/// en: 'Add Files'
	String get addFiles => 'Add Files';

	/// en: 'Take Photo'
	String get takePhoto => 'Take Photo';

	/// en: 'Camera'
	String get camera => 'Camera';

	/// en: 'Photos'
	String get photos => 'Photos';

	/// en: 'Files'
	String get files => 'Files';

	/// en: 'Show All'
	String get showAll => 'Show All';

	/// en: 'All Photos'
	String get allPhotos => 'All Photos';

	/// en: 'Taking photo...'
	String get takingPhoto => 'Taking photo...';

	/// en: 'Photo saved'
	String get photoTaken => 'Photo saved';

	/// en: 'Camera permission required'
	String get cameraPermissionRequired => 'Camera permission required';

	/// en: 'File size exceeds 10MB limit'
	String get fileSizeExceeded => 'File size exceeds 10MB limit';

	/// en: 'Unsupported file format'
	String get unsupportedFormat => 'Unsupported file format';

	/// en: 'Photo library access required'
	String get permissionDenied => 'Photo library access required';

	/// en: 'Insufficient storage space'
	String get storageInsufficient => 'Insufficient storage space';

	/// en: 'Network connection error'
	String get networkError => 'Network connection error';

	/// en: 'Unknown error during upload'
	String get unknownUploadError => 'Unknown error during upload';
}

// Path: error
class TranslationsErrorEn {
	TranslationsErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Permission Required'
	String get permissionRequired => 'Permission Required';

	/// en: 'Please enable photo library and storage permissions in Settings to select and upload files.'
	String get permissionInstructions => 'Please enable photo library and storage permissions in Settings to select and upload files.';

	/// en: 'Open Settings'
	String get openSettings => 'Open Settings';

	/// en: 'File Too Large'
	String get fileTooLarge => 'File Too Large';

	/// en: 'Please select files under 10MB, or compress before uploading.'
	String get fileSizeHint => 'Please select files under 10MB, or compress before uploading.';

	/// en: 'Supported formats: images (jpg, png, gif), documents (pdf, doc, txt), audio/video files.'
	String get supportedFormatsHint => 'Supported formats: images (jpg, png, gif), documents (pdf, doc, txt), audio/video files.';

	/// en: 'Please free up storage space and try again, or select smaller files.'
	String get storageCleanupHint => 'Please free up storage space and try again, or select smaller files.';

	/// en: 'Please check your network connection and try again.'
	String get networkErrorHint => 'Please check your network connection and try again.';

	/// en: 'Platform Not Supported'
	String get platformNotSupported => 'Platform Not Supported';

	/// en: 'File Read Error'
	String get fileReadError => 'File Read Error';

	/// en: 'The file may be corrupted or in use. Please select a different file.'
	String get fileReadErrorHint => 'The file may be corrupted or in use. Please select a different file.';

	/// en: 'File Validation Error'
	String get validationError => 'File Validation Error';

	/// en: 'Unknown Error'
	String get unknownError => 'Unknown Error';

	/// en: 'An unexpected error occurred. Please try again or contact support.'
	String get unknownErrorHint => 'An unexpected error occurred. Please try again or contact support.';

	late final TranslationsErrorGenuiEn genui = TranslationsErrorGenuiEn._(_root);
}

// Path: fontTest
class TranslationsFontTestEn {
	TranslationsFontTestEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Font Test Page'
	String get page => 'Font Test Page';

	/// en: 'Font Display Test'
	String get displayTest => 'Font Display Test';

	/// en: 'Chinese Text Test'
	String get chineseTextTest => 'Chinese Text Test';

	/// en: 'English Text Test'
	String get englishTextTest => 'English Text Test';

	/// en: 'This is a sample text for testing font display effects.'
	String get sample1 => 'This is a sample text for testing font display effects.';

	/// en: 'Expense category summary, shopping is highest'
	String get sample2 => 'Expense category summary, shopping is highest';

	/// en: 'AI assistant provides professional financial analysis services'
	String get sample3 => 'AI assistant provides professional financial analysis services';

	/// en: 'Data visualization charts show your spending trends'
	String get sample4 => 'Data visualization charts show your spending trends';

	/// en: 'WeChat Pay, Alipay, bank cards and other payment methods'
	String get sample5 => 'WeChat Pay, Alipay, bank cards and other payment methods';
}

// Path: wizard
class TranslationsWizardEn {
	TranslationsWizardEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Next'
	String get nextStep => 'Next';

	/// en: 'Previous'
	String get previousStep => 'Previous';

	/// en: 'Complete'
	String get completeMapping => 'Complete';
}

// Path: user
class TranslationsUserEn {
	TranslationsUserEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Username'
	String get username => 'Username';

	/// en: 'user@example.com'
	String get defaultEmail => 'user@example.com';
}

// Path: account
class TranslationsAccountEn {
	TranslationsAccountEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Edit Account'
	String get editTitle => 'Edit Account';

	/// en: 'New Account'
	String get addTitle => 'New Account';

	/// en: 'Select Account Type'
	String get selectTypeTitle => 'Select Account Type';

	/// en: 'Account Name'
	String get nameLabel => 'Account Name';

	/// en: 'Current Balance'
	String get amountLabel => 'Current Balance';

	/// en: 'Currency'
	String get currencyLabel => 'Currency';

	/// en: 'Hidden'
	String get hiddenLabel => 'Hidden';

	/// en: 'Hide this account from the list'
	String get hiddenDesc => 'Hide this account from the list';

	/// en: 'Include in Net Worth'
	String get includeInNetWorthLabel => 'Include in Net Worth';

	/// en: 'Count towards total net worth'
	String get includeInNetWorthDesc => 'Count towards total net worth';

	/// en: 'e.g. Salary Card'
	String get nameHint => 'e.g. Salary Card';

	/// en: '0.00'
	String get amountHint => '0.00';

	/// en: 'Delete Account'
	String get deleteAccount => 'Delete Account';

	/// en: 'Are you sure you want to delete this account? This cannot be undone.'
	String get deleteConfirm => 'Are you sure you want to delete this account? This cannot be undone.';

	/// en: 'Save Changes'
	String get save => 'Save Changes';

	/// en: 'Assets'
	String get assetsCategory => 'Assets';

	/// en: 'Liabilities/Credit'
	String get liabilitiesCategory => 'Liabilities/Credit';

	/// en: 'Cash Wallet'
	String get cash => 'Cash Wallet';

	/// en: 'Bank Deposit'
	String get deposit => 'Bank Deposit';

	/// en: 'Credit Card'
	String get creditCard => 'Credit Card';

	/// en: 'Investment'
	String get investment => 'Investment';

	/// en: 'E-Wallet'
	String get eWallet => 'E-Wallet';

	/// en: 'Loan'
	String get loan => 'Loan';

	/// en: 'Receivable'
	String get receivable => 'Receivable';

	/// en: 'Payable'
	String get payable => 'Payable';

	/// en: 'Other'
	String get other => 'Other';

	late final TranslationsAccountTypesEn types = TranslationsAccountTypesEn._(_root);
}

// Path: financial
class TranslationsFinancialEn {
	TranslationsFinancialEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Financial'
	String get title => 'Financial';

	/// en: 'Financial Management'
	String get management => 'Financial Management';

	/// en: 'Total Net Worth'
	String get netWorth => 'Total Net Worth';

	/// en: 'Total Assets'
	String get assets => 'Total Assets';

	/// en: 'Total Liabilities'
	String get liabilities => 'Total Liabilities';

	/// en: 'No accounts yet'
	String get noAccounts => 'No accounts yet';

	/// en: 'Tap the button below to add your first account'
	String get addFirstAccount => 'Tap the button below to add your first account';

	/// en: 'Asset Accounts'
	String get assetAccounts => 'Asset Accounts';

	/// en: 'Liability Accounts'
	String get liabilityAccounts => 'Liability Accounts';

	/// en: 'Select Currency'
	String get selectCurrency => 'Select Currency';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Financial Settings'
	String get settings => 'Financial Settings';

	/// en: 'Budget Management'
	String get budgetManagement => 'Budget Management';

	/// en: 'Recurring Transactions'
	String get recurringTransactions => 'Recurring Transactions';

	/// en: 'Safety Threshold'
	String get safetyThreshold => 'Safety Threshold';

	/// en: 'Daily Burn Rate'
	String get dailyBurnRate => 'Daily Burn Rate';

	/// en: 'Financial Assistant'
	String get financialAssistant => 'Financial Assistant';

	/// en: 'Manage your financial settings'
	String get manageFinancialSettings => 'Manage your financial settings';

	/// en: 'Safety Threshold Settings'
	String get safetyThresholdSettings => 'Safety Threshold Settings';

	/// en: 'Set your financial safety threshold'
	String get setSafetyThreshold => 'Set your financial safety threshold';

	/// en: 'Safety threshold saved'
	String get safetyThresholdSaved => 'Safety threshold saved';

	/// en: 'Daily Burn Rate'
	String get dailyBurnRateSettings => 'Daily Burn Rate';

	/// en: 'Set your estimated daily spending'
	String get setDailyBurnRate => 'Set your estimated daily spending';

	/// en: 'Daily burn rate saved'
	String get dailyBurnRateSaved => 'Daily burn rate saved';

	/// en: 'Save failed'
	String get saveFailed => 'Save failed';
}

// Path: app
class TranslationsAppEn {
	TranslationsAppEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Augo: Intelligence that Grows.'
	String get splashTitle => 'Augo: Intelligence that Grows.';

	/// en: 'Smart Financial Assistant'
	String get splashSubtitle => 'Smart Financial Assistant';
}

// Path: statistics
class TranslationsStatisticsEn {
	TranslationsStatisticsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Analysis'
	String get title => 'Analysis';

	/// en: 'Analysis'
	String get analyze => 'Analysis';

	/// en: 'Export feature coming soon...'
	String get exportInProgress => 'Export feature coming soon...';

	/// en: 'Top Spending'
	String get ranking => 'Top Spending';

	/// en: 'No data available'
	String get noData => 'No data available';

	late final TranslationsStatisticsOverviewEn overview = TranslationsStatisticsOverviewEn._(_root);
	late final TranslationsStatisticsTrendEn trend = TranslationsStatisticsTrendEn._(_root);
	late final TranslationsStatisticsAnalysisEn analysis = TranslationsStatisticsAnalysisEn._(_root);
	late final TranslationsStatisticsFilterEn filter = TranslationsStatisticsFilterEn._(_root);
	late final TranslationsStatisticsSortEn sort = TranslationsStatisticsSortEn._(_root);

	/// en: 'Export List'
	String get exportList => 'Export List';

	late final TranslationsStatisticsEmptyStateEn emptyState = TranslationsStatisticsEmptyStateEn._(_root);

	/// en: 'No more data'
	String get noMoreData => 'No more data';
}

// Path: currency
class TranslationsCurrencyEn {
	TranslationsCurrencyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Chinese Yuan'
	String get cny => 'Chinese Yuan';

	/// en: 'US Dollar'
	String get usd => 'US Dollar';

	/// en: 'Euro'
	String get eur => 'Euro';

	/// en: 'Japanese Yen'
	String get jpy => 'Japanese Yen';

	/// en: 'British Pound'
	String get gbp => 'British Pound';

	/// en: 'Australian Dollar'
	String get aud => 'Australian Dollar';

	/// en: 'Canadian Dollar'
	String get cad => 'Canadian Dollar';

	/// en: 'Swiss Franc'
	String get chf => 'Swiss Franc';

	/// en: 'Russian Ruble'
	String get rub => 'Russian Ruble';

	/// en: 'Hong Kong Dollar'
	String get hkd => 'Hong Kong Dollar';

	/// en: 'New Taiwan Dollar'
	String get twd => 'New Taiwan Dollar';

	/// en: 'Indian Rupee'
	String get inr => 'Indian Rupee';
}

// Path: budgetSuggestion
class TranslationsBudgetSuggestionEn {
	TranslationsBudgetSuggestionEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '$category accounts for $percentage% of spending. Consider setting a budget limit.'
	String highPercentage({required Object category, required Object percentage}) => '${category} accounts for ${percentage}% of spending. Consider setting a budget limit.';

	/// en: 'Spending increased by $percentage% this month. Needs attention.'
	String monthlyIncrease({required Object percentage}) => 'Spending increased by ${percentage}% this month. Needs attention.';

	/// en: '$category has $count small transactions. These might be subscriptions.'
	String frequentSmall({required Object category, required Object count}) => '${category} has ${count} small transactions. These might be subscriptions.';

	/// en: 'Financial Insights'
	String get financialInsights => 'Financial Insights';
}

// Path: server
class TranslationsServerEn {
	TranslationsServerEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Connect to Server'
	String get title => 'Connect to Server';

	/// en: 'Enter your self-hosted server address or scan the QR code displayed when starting the server'
	String get subtitle => 'Enter your self-hosted server address or scan the QR code displayed when starting the server';

	/// en: 'Server Address'
	String get urlLabel => 'Server Address';

	/// en: 'e.g. https://api.example.com or 192.168.1.100:8000'
	String get urlPlaceholder => 'e.g. https://api.example.com or 192.168.1.100:8000';

	/// en: 'Scan QR Code'
	String get scanQr => 'Scan QR Code';

	/// en: 'Point at the QR code displayed in the server terminal'
	String get scanQrInstruction => 'Point at the QR code displayed in the server terminal';

	/// en: 'Test Connection'
	String get testConnection => 'Test Connection';

	/// en: 'Connecting...'
	String get connecting => 'Connecting...';

	/// en: 'Connected'
	String get connected => 'Connected';

	/// en: 'Connection Failed'
	String get connectionFailed => 'Connection Failed';

	/// en: 'Continue to Login'
	String get continueToLogin => 'Continue to Login';

	/// en: 'Save and Return'
	String get saveAndReturn => 'Save and Return';

	/// en: 'Server Settings'
	String get serverSettings => 'Server Settings';

	/// en: 'Current Server'
	String get currentServer => 'Current Server';

	/// en: 'Version'
	String get version => 'Version';

	/// en: 'Environment'
	String get environment => 'Environment';

	/// en: 'Change Server'
	String get changeServer => 'Change Server';

	/// en: 'Changing server will log you out. Continue?'
	String get changeServerWarning => 'Changing server will log you out. Continue?';

	late final TranslationsServerErrorEn error = TranslationsServerErrorEn._(_root);
}

// Path: sharedSpace
class TranslationsSharedSpaceEn {
	TranslationsSharedSpaceEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsSharedSpaceDashboardEn dashboard = TranslationsSharedSpaceDashboardEn._(_root);
	late final TranslationsSharedSpaceRolesEn roles = TranslationsSharedSpaceRolesEn._(_root);
}

// Path: errorMapping
class TranslationsErrorMappingEn {
	TranslationsErrorMappingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsErrorMappingGenericEn generic = TranslationsErrorMappingGenericEn._(_root);
	late final TranslationsErrorMappingAuthEn auth = TranslationsErrorMappingAuthEn._(_root);
	late final TranslationsErrorMappingTransactionEn transaction = TranslationsErrorMappingTransactionEn._(_root);
	late final TranslationsErrorMappingSpaceEn space = TranslationsErrorMappingSpaceEn._(_root);
	late final TranslationsErrorMappingRecurringEn recurring = TranslationsErrorMappingRecurringEn._(_root);
	late final TranslationsErrorMappingUploadEn upload = TranslationsErrorMappingUploadEn._(_root);
	late final TranslationsErrorMappingAiEn ai = TranslationsErrorMappingAiEn._(_root);
}

// Path: auth.email
class TranslationsAuthEmailEn {
	TranslationsAuthEmailEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Email'
	String get label => 'Email';

	/// en: 'Enter your email'
	String get placeholder => 'Enter your email';

	/// en: 'Email is required'
	String get required => 'Email is required';

	/// en: 'Please enter a valid email address'
	String get invalid => 'Please enter a valid email address';
}

// Path: auth.password
class TranslationsAuthPasswordEn {
	TranslationsAuthPasswordEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Password'
	String get label => 'Password';

	/// en: 'Enter your password'
	String get placeholder => 'Enter your password';

	/// en: 'Password is required'
	String get required => 'Password is required';

	/// en: 'Password must be at least 6 characters'
	String get tooShort => 'Password must be at least 6 characters';

	/// en: 'Password must contain both numbers and letters'
	String get mustContainNumbersAndLetters => 'Password must contain both numbers and letters';

	/// en: 'Confirm Password'
	String get confirm => 'Confirm Password';

	/// en: 'Re-enter your password'
	String get confirmPlaceholder => 'Re-enter your password';

	/// en: 'Passwords do not match'
	String get mismatch => 'Passwords do not match';
}

// Path: auth.verificationCode
class TranslationsAuthVerificationCodeEn {
	TranslationsAuthVerificationCodeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Verification Code'
	String get label => 'Verification Code';

	/// en: 'Get Code'
	String get get => 'Get Code';

	/// en: 'Sending...'
	String get sending => 'Sending...';

	/// en: 'Code sent'
	String get sent => 'Code sent';

	/// en: 'Failed to send'
	String get sendFailed => 'Failed to send';

	/// en: 'Optional for now, enter anything'
	String get placeholder => 'Optional for now, enter anything';

	/// en: 'Verification code is required'
	String get required => 'Verification code is required';
}

// Path: calendar.weekdays
class TranslationsCalendarWeekdaysEn {
	TranslationsCalendarWeekdaysEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'M'
	String get mon => 'M';

	/// en: 'T'
	String get tue => 'T';

	/// en: 'W'
	String get wed => 'W';

	/// en: 'T'
	String get thu => 'T';

	/// en: 'F'
	String get fri => 'F';

	/// en: 'S'
	String get sat => 'S';

	/// en: 'S'
	String get sun => 'S';
}

// Path: appearance.palettes
class TranslationsAppearancePalettesEn {
	TranslationsAppearancePalettesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Zinc'
	String get zinc => 'Zinc';

	/// en: 'Slate'
	String get slate => 'Slate';

	/// en: 'Red'
	String get red => 'Red';

	/// en: 'Rose'
	String get rose => 'Rose';

	/// en: 'Orange'
	String get orange => 'Orange';

	/// en: 'Green'
	String get green => 'Green';

	/// en: 'Blue'
	String get blue => 'Blue';

	/// en: 'Yellow'
	String get yellow => 'Yellow';

	/// en: 'Violet'
	String get violet => 'Violet';
}

// Path: forecast.recurringTransaction
class TranslationsForecastRecurringTransactionEn {
	TranslationsForecastRecurringTransactionEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Recurring Transactions'
	String get title => 'Recurring Transactions';

	/// en: 'All'
	String get all => 'All';

	/// en: 'Expense'
	String get expense => 'Expense';

	/// en: 'Income'
	String get income => 'Income';

	/// en: 'Transfer'
	String get transfer => 'Transfer';

	/// en: 'No recurring transactions'
	String get noRecurring => 'No recurring transactions';

	/// en: 'The system will automatically generate transactions after you create recurring rules'
	String get createHint => 'The system will automatically generate transactions after you create recurring rules';

	/// en: 'Create Recurring Transaction'
	String get create => 'Create Recurring Transaction';

	/// en: 'Edit Recurring Transaction'
	String get edit => 'Edit Recurring Transaction';

	/// en: 'New Recurring Transaction'
	String get newTransaction => 'New Recurring Transaction';

	/// en: 'Are you sure you want to delete recurring transaction "$name"? This cannot be undone.'
	String deleteConfirm({required Object name}) => 'Are you sure you want to delete recurring transaction "${name}"? This cannot be undone.';

	/// en: 'Are you sure you want to activate recurring transaction "$name"? It will automatically generate transactions.'
	String activateConfirm({required Object name}) => 'Are you sure you want to activate recurring transaction "${name}"? It will automatically generate transactions.';

	/// en: 'Are you sure you want to pause recurring transaction "$name"? No transactions will be generated while paused.'
	String pauseConfirm({required Object name}) => 'Are you sure you want to pause recurring transaction "${name}"? No transactions will be generated while paused.';

	/// en: 'Recurring transaction created'
	String get created => 'Recurring transaction created';

	/// en: 'Recurring transaction updated'
	String get updated => 'Recurring transaction updated';

	/// en: 'Activated'
	String get activated => 'Activated';

	/// en: 'Paused'
	String get paused => 'Paused';

	/// en: 'Next'
	String get nextTime => 'Next';

	/// en: 'Sort by time'
	String get sortByTime => 'Sort by time';

	/// en: 'All recurring'
	String get allPeriod => 'All recurring';

	/// en: '$type recurring ($count)'
	String periodCount({required Object type, required Object count}) => '${type} recurring (${count})';

	/// en: 'Confirm Delete'
	String get confirmDelete => 'Confirm Delete';

	/// en: 'Confirm Activate'
	String get confirmActivate => 'Confirm Activate';

	/// en: 'Confirm Pause'
	String get confirmPause => 'Confirm Pause';

	/// en: 'Est. Avg'
	String get dynamicAmount => 'Est. Avg';

	/// en: 'Amount Requires Confirmation'
	String get dynamicAmountTitle => 'Amount Requires Confirmation';

	/// en: 'System will send a reminder on the due date. You need to manually confirm the amount before recording.'
	String get dynamicAmountDescription => 'System will send a reminder on the due date. You need to manually confirm the amount before recording.';
}

// Path: chat.tools
class TranslationsChatToolsEn {
	TranslationsChatToolsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Processing...'
	String get processing => 'Processing...';

	/// en: 'Reading file...'
	String get read_file => 'Reading file...';

	/// en: 'Searching transactions...'
	String get search_transactions => 'Searching transactions...';

	/// en: 'Checking budget...'
	String get query_budget_status => 'Checking budget...';

	/// en: 'Creating budget plan...'
	String get create_budget => 'Creating budget plan...';

	/// en: 'Analyzing cash flow...'
	String get get_cash_flow_analysis => 'Analyzing cash flow...';

	/// en: 'Calculating financial health score...'
	String get get_financial_health_score => 'Calculating financial health score...';

	/// en: 'Generating financial report...'
	String get get_financial_summary => 'Generating financial report...';

	/// en: 'Evaluating financial health...'
	String get evaluate_financial_health => 'Evaluating financial health...';

	/// en: 'Forecasting future balance...'
	String get forecast_balance => 'Forecasting future balance...';

	/// en: 'Simulating purchase impact...'
	String get simulate_expense_impact => 'Simulating purchase impact...';

	/// en: 'Recording transactions...'
	String get record_transactions => 'Recording transactions...';

	/// en: 'Recording transaction...'
	String get create_transaction => 'Recording transaction...';

	/// en: 'Searching the web...'
	String get duckduckgo_search => 'Searching the web...';

	/// en: 'Executing transfer...'
	String get execute_transfer => 'Executing transfer...';

	/// en: 'Browsing directory...'
	String get list_dir => 'Browsing directory...';

	/// en: 'Processing...'
	String get execute => 'Processing...';

	/// en: 'Analyzing finances...'
	String get analyze_finance => 'Analyzing finances...';

	/// en: 'Forecasting finances...'
	String get forecast_finance => 'Forecasting finances...';

	/// en: 'Analyzing budget...'
	String get analyze_budget => 'Analyzing budget...';

	/// en: 'Running audit analysis...'
	String get audit_analysis => 'Running audit analysis...';

	/// en: 'Processing budget...'
	String get budget_ops => 'Processing budget...';

	/// en: 'Creating shared expense...'
	String get create_shared_transaction => 'Creating shared expense...';

	/// en: 'Loading shared spaces...'
	String get list_spaces => 'Loading shared spaces...';

	/// en: 'Querying space summary...'
	String get query_space_summary => 'Querying space summary...';

	/// en: 'Preparing transfer...'
	String get prepare_transfer => 'Preparing transfer...';

	/// en: 'Processing request...'
	String get unknown => 'Processing request...';

	late final TranslationsChatToolsDoneEn done = TranslationsChatToolsDoneEn._(_root);
	late final TranslationsChatToolsFailedEn failed = TranslationsChatToolsFailedEn._(_root);

	/// en: 'Cancelled'
	String get cancelled => 'Cancelled';
}

// Path: chat.transferWizard
class TranslationsChatTransferWizardEn {
	TranslationsChatTransferWizardEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Transfer Wizard'
	String get title => 'Transfer Wizard';

	/// en: 'Transfer Amount'
	String get amount => 'Transfer Amount';

	/// en: 'Enter amount'
	String get amountHint => 'Enter amount';

	/// en: 'Source Account'
	String get sourceAccount => 'Source Account';

	/// en: 'Target Account'
	String get targetAccount => 'Target Account';

	/// en: 'Select Account'
	String get selectAccount => 'Select Account';

	/// en: 'Confirm Transfer'
	String get confirmTransfer => 'Confirm Transfer';

	/// en: 'Confirmed'
	String get confirmed => 'Confirmed';

	/// en: 'Transfer Successful'
	String get transferSuccess => 'Transfer Successful';
}

// Path: chat.genui
class TranslationsChatGenuiEn {
	TranslationsChatGenuiEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsChatGenuiExpenseSummaryEn expenseSummary = TranslationsChatGenuiExpenseSummaryEn._(_root);
	late final TranslationsChatGenuiTransactionListEn transactionList = TranslationsChatGenuiTransactionListEn._(_root);
	late final TranslationsChatGenuiTransactionGroupReceiptEn transactionGroupReceipt = TranslationsChatGenuiTransactionGroupReceiptEn._(_root);
	late final TranslationsChatGenuiBudgetReceiptEn budgetReceipt = TranslationsChatGenuiBudgetReceiptEn._(_root);
	late final TranslationsChatGenuiBudgetStatusCardEn budgetStatusCard = TranslationsChatGenuiBudgetStatusCardEn._(_root);
	late final TranslationsChatGenuiCashFlowForecastEn cashFlowForecast = TranslationsChatGenuiCashFlowForecastEn._(_root);
	late final TranslationsChatGenuiHealthScoreEn healthScore = TranslationsChatGenuiHealthScoreEn._(_root);
	late final TranslationsChatGenuiSpaceSelectorEn spaceSelector = TranslationsChatGenuiSpaceSelectorEn._(_root);
	late final TranslationsChatGenuiTransferPathEn transferPath = TranslationsChatGenuiTransferPathEn._(_root);
	late final TranslationsChatGenuiTransactionCardEn transactionCard = TranslationsChatGenuiTransactionCardEn._(_root);
	late final TranslationsChatGenuiCashFlowCardEn cashFlowCard = TranslationsChatGenuiCashFlowCardEn._(_root);
}

// Path: chat.welcome
class TranslationsChatWelcomeEn {
	TranslationsChatWelcomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsChatWelcomeMorningEn morning = TranslationsChatWelcomeMorningEn._(_root);
	late final TranslationsChatWelcomeMiddayEn midday = TranslationsChatWelcomeMiddayEn._(_root);
	late final TranslationsChatWelcomeAfternoonEn afternoon = TranslationsChatWelcomeAfternoonEn._(_root);
	late final TranslationsChatWelcomeEveningEn evening = TranslationsChatWelcomeEveningEn._(_root);
	late final TranslationsChatWelcomeNightEn night = TranslationsChatWelcomeNightEn._(_root);
}

// Path: error.genui
class TranslationsErrorGenuiEn {
	TranslationsErrorGenuiEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Component loading failed'
	String get loadingFailed => 'Component loading failed';

	/// en: 'Schema validation failed'
	String get schemaFailed => 'Schema validation failed';

	/// en: 'Component definition does not comply with GenUI specifications, degraded to plain text display'
	String get schemaDescription => 'Component definition does not comply with GenUI specifications, degraded to plain text display';

	/// en: 'Network error'
	String get networkError => 'Network error';

	/// en: 'Retried $retryCount/$maxRetries times'
	String retryStatus({required Object retryCount, required Object maxRetries}) => 'Retried ${retryCount}/${maxRetries} times';

	/// en: 'Maximum retry attempts reached'
	String get maxRetriesReached => 'Maximum retry attempts reached';
}

// Path: account.types
class TranslationsAccountTypesEn {
	TranslationsAccountTypesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cash'
	String get cashTitle => 'Cash';

	/// en: 'Physical currency and coins'
	String get cashSubtitle => 'Physical currency and coins';

	/// en: 'Bank Deposit'
	String get depositTitle => 'Bank Deposit';

	/// en: 'Savings, checking accounts'
	String get depositSubtitle => 'Savings, checking accounts';

	/// en: 'E-Wallet'
	String get eMoneyTitle => 'E-Wallet';

	/// en: 'Digital payment balances'
	String get eMoneySubtitle => 'Digital payment balances';

	/// en: 'Investment'
	String get investmentTitle => 'Investment';

	/// en: 'Stocks, funds, bonds, etc.'
	String get investmentSubtitle => 'Stocks, funds, bonds, etc.';

	/// en: 'Receivable'
	String get receivableTitle => 'Receivable';

	/// en: 'Loans to others, pending'
	String get receivableSubtitle => 'Loans to others, pending';

	/// en: 'Owed to me'
	String get receivableHelper => 'Owed to me';

	/// en: 'Credit Card'
	String get creditCardTitle => 'Credit Card';

	/// en: 'Credit card balances'
	String get creditCardSubtitle => 'Credit card balances';

	/// en: 'Loan'
	String get loanTitle => 'Loan';

	/// en: 'Mortgage, auto, personal'
	String get loanSubtitle => 'Mortgage, auto, personal';

	/// en: 'Payable'
	String get payableTitle => 'Payable';

	/// en: 'Amounts owed to others'
	String get payableSubtitle => 'Amounts owed to others';

	/// en: 'I owe'
	String get payableHelper => 'I owe';
}

// Path: statistics.overview
class TranslationsStatisticsOverviewEn {
	TranslationsStatisticsOverviewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Total Balance'
	String get balance => 'Total Balance';

	/// en: 'Total Income'
	String get income => 'Total Income';

	/// en: 'Total Expense'
	String get expense => 'Total Expense';
}

// Path: statistics.trend
class TranslationsStatisticsTrendEn {
	TranslationsStatisticsTrendEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Trends'
	String get title => 'Trends';

	/// en: 'Expense'
	String get expense => 'Expense';

	/// en: 'Income'
	String get income => 'Income';
}

// Path: statistics.analysis
class TranslationsStatisticsAnalysisEn {
	TranslationsStatisticsAnalysisEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Analysis'
	String get title => 'Analysis';

	/// en: 'Total'
	String get total => 'Total';

	/// en: 'Category Breakdown'
	String get breakdown => 'Category Breakdown';
}

// Path: statistics.filter
class TranslationsStatisticsFilterEn {
	TranslationsStatisticsFilterEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Account Type'
	String get accountType => 'Account Type';

	/// en: 'All Accounts'
	String get allAccounts => 'All Accounts';

	/// en: 'Apply'
	String get apply => 'Apply';
}

// Path: statistics.sort
class TranslationsStatisticsSortEn {
	TranslationsStatisticsSortEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'By Amount'
	String get amount => 'By Amount';

	/// en: 'By Time'
	String get date => 'By Time';
}

// Path: statistics.emptyState
class TranslationsStatisticsEmptyStateEn {
	TranslationsStatisticsEmptyStateEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Unlock Financial Insights'
	String get title => 'Unlock Financial Insights';

	/// en: 'Your financial report is currently a blank canvas. Record your first transaction and let the data tell your story.'
	String get description => 'Your financial report is currently a blank canvas.\nRecord your first transaction and let the data tell your story.';

	/// en: 'Record First Transaction'
	String get action => 'Record First Transaction';
}

// Path: server.error
class TranslationsServerErrorEn {
	TranslationsServerErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Server address is required'
	String get urlRequired => 'Server address is required';

	/// en: 'Invalid URL format'
	String get invalidUrl => 'Invalid URL format';

	/// en: 'Connection timed out'
	String get connectionTimeout => 'Connection timed out';

	/// en: 'Could not connect to server'
	String get connectionRefused => 'Could not connect to server';

	/// en: 'SSL certificate error'
	String get sslError => 'SSL certificate error';

	/// en: 'Server error'
	String get serverError => 'Server error';
}

// Path: sharedSpace.dashboard
class TranslationsSharedSpaceDashboardEn {
	TranslationsSharedSpaceDashboardEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cumulative Total Expense'
	String get cumulativeTotalExpense => 'Cumulative Total Expense';

	/// en: 'Participating Members'
	String get participatingMembers => 'Participating Members';

	/// en: '$count people'
	String membersCount({required Object count}) => '${count} people';

	/// en: 'Avg per member'
	String get averagePerMember => 'Avg per member';

	/// en: 'Spending Distribution'
	String get spendingDistribution => 'Spending Distribution';

	/// en: 'Real-time updates'
	String get realtimeUpdates => 'Real-time updates';

	/// en: 'Paid'
	String get paid => 'Paid';
}

// Path: sharedSpace.roles
class TranslationsSharedSpaceRolesEn {
	TranslationsSharedSpaceRolesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Owner'
	String get owner => 'Owner';

	/// en: 'Admin'
	String get admin => 'Admin';

	/// en: 'Member'
	String get member => 'Member';
}

// Path: errorMapping.generic
class TranslationsErrorMappingGenericEn {
	TranslationsErrorMappingGenericEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Bad Request'
	String get badRequest => 'Bad Request';

	/// en: 'Authentication failed, please login again'
	String get authFailed => 'Authentication failed, please login again';

	/// en: 'Permission denied'
	String get permissionDenied => 'Permission denied';

	/// en: 'Resource not found'
	String get notFound => 'Resource not found';

	/// en: 'Internal server error'
	String get serverError => 'Internal server error';

	/// en: 'System error'
	String get systemError => 'System error';

	/// en: 'Validation failed'
	String get validationFailed => 'Validation failed';
}

// Path: errorMapping.auth
class TranslationsErrorMappingAuthEn {
	TranslationsErrorMappingAuthEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Authentication failed'
	String get failed => 'Authentication failed';

	/// en: 'Incorrect email'
	String get emailWrong => 'Incorrect email';

	/// en: 'Incorrect phone number'
	String get phoneWrong => 'Incorrect phone number';

	/// en: 'Phone number already registered'
	String get phoneRegistered => 'Phone number already registered';

	/// en: 'Email already registered'
	String get emailRegistered => 'Email already registered';

	/// en: 'Failed to send verification code'
	String get sendFailed => 'Failed to send verification code';

	/// en: 'Verification code expired'
	String get expired => 'Verification code expired';

	/// en: 'Code sent too frequently'
	String get tooFrequent => 'Code sent too frequently';

	/// en: 'Unsupported code type'
	String get unsupportedType => 'Unsupported code type';

	/// en: 'Incorrect password'
	String get wrongPassword => 'Incorrect password';

	/// en: 'User not found'
	String get userNotFound => 'User not found';

	/// en: 'Preference parameters missing'
	String get prefsMissing => 'Preference parameters missing';

	/// en: 'Invalid client timezone'
	String get invalidTimezone => 'Invalid client timezone';
}

// Path: errorMapping.transaction
class TranslationsErrorMappingTransactionEn {
	TranslationsErrorMappingTransactionEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Comment content cannot be empty'
	String get commentEmpty => 'Comment content cannot be empty';

	/// en: 'Invalid parent comment ID'
	String get invalidParent => 'Invalid parent comment ID';

	/// en: 'Failed to save comment'
	String get saveFailed => 'Failed to save comment';

	/// en: 'Failed to delete comment'
	String get deleteFailed => 'Failed to delete comment';

	/// en: 'Transaction does not exist'
	String get notExists => 'Transaction does not exist';
}

// Path: errorMapping.space
class TranslationsErrorMappingSpaceEn {
	TranslationsErrorMappingSpaceEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Shared space not found or access denied'
	String get notFound => 'Shared space not found or access denied';

	/// en: 'No permission to invite members'
	String get inviteDenied => 'No permission to invite members';

	/// en: 'Cannot invite yourself'
	String get inviteSelf => 'Cannot invite yourself';

	/// en: 'Invitation sent'
	String get inviteSent => 'Invitation sent';

	/// en: 'User is already a member or invited'
	String get alreadyMember => 'User is already a member or invited';

	/// en: 'Invalid action'
	String get invalidAction => 'Invalid action';

	/// en: 'Invitation does not exist'
	String get invitationNotFound => 'Invitation does not exist';

	/// en: 'Only owner can perform this action'
	String get onlyOwner => 'Only owner can perform this action';

	/// en: 'Owner cannot be removed'
	String get ownerNotRemovable => 'Owner cannot be removed';

	/// en: 'Member not found'
	String get memberNotFound => 'Member not found';

	/// en: 'User is not a member of this space'
	String get notMember => 'User is not a member of this space';

	/// en: 'Owner cannot leave directly, please transfer ownership first'
	String get ownerCantLeave => 'Owner cannot leave directly, please transfer ownership first';

	/// en: 'Invalid invitation code'
	String get invalidCode => 'Invalid invitation code';

	/// en: 'Invitation code expired or usage limit reached'
	String get codeExpired => 'Invitation code expired or usage limit reached';
}

// Path: errorMapping.recurring
class TranslationsErrorMappingRecurringEn {
	TranslationsErrorMappingRecurringEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Invalid recurrence rule'
	String get invalidRule => 'Invalid recurrence rule';

	/// en: 'Recurrence rule not found'
	String get ruleNotFound => 'Recurrence rule not found';
}

// Path: errorMapping.upload
class TranslationsErrorMappingUploadEn {
	TranslationsErrorMappingUploadEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No file uploaded'
	String get noFile => 'No file uploaded';

	/// en: 'File too large'
	String get tooLarge => 'File too large';

	/// en: 'Unsupported file type'
	String get unsupportedType => 'Unsupported file type';

	/// en: 'Too many files'
	String get tooManyFiles => 'Too many files';
}

// Path: errorMapping.ai
class TranslationsErrorMappingAiEn {
	TranslationsErrorMappingAiEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Context limit exceeded'
	String get contextLimit => 'Context limit exceeded';

	/// en: 'Insufficient tokens'
	String get tokenLimit => 'Insufficient tokens';

	/// en: 'Empty user message'
	String get emptyMessage => 'Empty user message';
}

// Path: chat.tools.done
class TranslationsChatToolsDoneEn {
	TranslationsChatToolsDoneEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Read file'
	String get read_file => 'Read file';

	/// en: 'Searched transactions'
	String get search_transactions => 'Searched transactions';

	/// en: 'Checked budget'
	String get query_budget_status => 'Checked budget';

	/// en: 'Created budget'
	String get create_budget => 'Created budget';

	/// en: 'Analyzed cash flow'
	String get get_cash_flow_analysis => 'Analyzed cash flow';

	/// en: 'Calculated health score'
	String get get_financial_health_score => 'Calculated health score';

	/// en: 'Financial report ready'
	String get get_financial_summary => 'Financial report ready';

	/// en: 'Health evaluation complete'
	String get evaluate_financial_health => 'Health evaluation complete';

	/// en: 'Balance forecast ready'
	String get forecast_balance => 'Balance forecast ready';

	/// en: 'Impact simulation complete'
	String get simulate_expense_impact => 'Impact simulation complete';

	/// en: 'Recorded transactions'
	String get record_transactions => 'Recorded transactions';

	/// en: 'Recorded transaction'
	String get create_transaction => 'Recorded transaction';

	/// en: 'Searched the web'
	String get duckduckgo_search => 'Searched the web';

	/// en: 'Transfer complete'
	String get execute_transfer => 'Transfer complete';

	/// en: 'Browsed directory'
	String get list_dir => 'Browsed directory';

	/// en: 'Processing complete'
	String get execute => 'Processing complete';

	/// en: 'Finance analysis complete'
	String get analyze_finance => 'Finance analysis complete';

	/// en: 'Finance forecast complete'
	String get forecast_finance => 'Finance forecast complete';

	/// en: 'Budget analysis complete'
	String get analyze_budget => 'Budget analysis complete';

	/// en: 'Audit analysis complete'
	String get audit_analysis => 'Audit analysis complete';

	/// en: 'Budget processing complete'
	String get budget_ops => 'Budget processing complete';

	/// en: 'Shared expense created'
	String get create_shared_transaction => 'Shared expense created';

	/// en: 'Shared spaces loaded'
	String get list_spaces => 'Shared spaces loaded';

	/// en: 'Space summary ready'
	String get query_space_summary => 'Space summary ready';

	/// en: 'Transfer ready'
	String get prepare_transfer => 'Transfer ready';

	/// en: 'Processing complete'
	String get unknown => 'Processing complete';
}

// Path: chat.tools.failed
class TranslationsChatToolsFailedEn {
	TranslationsChatToolsFailedEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Action failed'
	String get unknown => 'Action failed';
}

// Path: chat.genui.expenseSummary
class TranslationsChatGenuiExpenseSummaryEn {
	TranslationsChatGenuiExpenseSummaryEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Total Expense'
	String get totalExpense => 'Total Expense';

	/// en: 'Main Expenses'
	String get mainExpenses => 'Main Expenses';

	/// en: 'View all $count transactions'
	String viewAll({required Object count}) => 'View all ${count} transactions';

	/// en: 'Transaction Details'
	String get details => 'Transaction Details';
}

// Path: chat.genui.transactionList
class TranslationsChatGenuiTransactionListEn {
	TranslationsChatGenuiTransactionListEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Search Results ($count)'
	String searchResults({required Object count}) => 'Search Results (${count})';

	/// en: 'Loaded $count'
	String loaded({required Object count}) => 'Loaded ${count}';

	/// en: 'No transactions found'
	String get noResults => 'No transactions found';

	/// en: 'Scroll to load more'
	String get loadMore => 'Scroll to load more';

	/// en: 'All loaded'
	String get allLoaded => 'All loaded';
}

// Path: chat.genui.transactionGroupReceipt
class TranslationsChatGenuiTransactionGroupReceiptEn {
	TranslationsChatGenuiTransactionGroupReceiptEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Successfully'
	String get title => 'Successfully';

	/// en: '$count items'
	String count({required Object count}) => '${count} items';

	/// en: 'Total'
	String get total => 'Total';

	/// en: 'Select Account'
	String get selectAccount => 'Select Account';

	/// en: 'This account will be applied to all transactions above'
	String get selectAccountSubtitle => 'This account will be applied to all transactions above';

	/// en: 'Associated: $name'
	String associatedAccount({required Object name}) => 'Associated: ${name}';

	/// en: 'Click to associate account'
	String get clickToAssociate => 'Click to associate account';

	/// en: 'Successfully associated account to all transactions'
	String get associateSuccess => 'Successfully associated account to all transactions';

	/// en: 'Action failed: $error'
	String associateFailed({required Object error}) => 'Action failed: ${error}';

	/// en: 'Account'
	String get accountAssociation => 'Account';

	/// en: 'Shared Space'
	String get sharedSpace => 'Shared Space';

	/// en: 'Not linked'
	String get notAssociated => 'Not linked';

	/// en: 'Add'
	String get addSpace => 'Add';

	/// en: 'Select Shared Space'
	String get selectSpace => 'Select Shared Space';

	/// en: 'Linked to shared space'
	String get spaceAssociateSuccess => 'Linked to shared space';

	/// en: 'Failed to link: $error'
	String spaceAssociateFailed({required Object error}) => 'Failed to link: ${error}';

	/// en: 'Currency Mismatch'
	String get currencyMismatchTitle => 'Currency Mismatch';

	/// en: 'The transaction currency differs from the account currency. The account balance will be deducted at the exchange rate.'
	String get currencyMismatchDesc => 'The transaction currency differs from the account currency. The account balance will be deducted at the exchange rate.';

	/// en: 'Transaction Amount'
	String get transactionAmount => 'Transaction Amount';

	/// en: 'Account Currency'
	String get accountCurrency => 'Account Currency';

	/// en: 'Target Account'
	String get targetAccount => 'Target Account';

	/// en: 'Note: Account balance will be converted using current exchange rate'
	String get currencyMismatchNote => 'Note: Account balance will be converted using current exchange rate';

	/// en: 'Confirm'
	String get confirmAssociate => 'Confirm';

	/// en: '$count spaces'
	String spaceCount({required Object count}) => '${count} spaces';
}

// Path: chat.genui.budgetReceipt
class TranslationsChatGenuiBudgetReceiptEn {
	TranslationsChatGenuiBudgetReceiptEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'New Budget'
	String get newBudget => 'New Budget';

	/// en: 'Budget Created'
	String get budgetCreated => 'Budget Created';

	/// en: 'Rollover Budget'
	String get rolloverBudget => 'Rollover Budget';

	/// en: 'Failed to create budget'
	String get createFailed => 'Failed to create budget';

	/// en: 'This Month'
	String get thisMonth => 'This Month';

	/// en: '$start/$startDay - $end/$endDay'
	String dateRange({required Object start, required Object startDay, required Object end, required Object endDay}) => '${start}/${startDay} - ${end}/${endDay}';
}

// Path: chat.genui.budgetStatusCard
class TranslationsChatGenuiBudgetStatusCardEn {
	TranslationsChatGenuiBudgetStatusCardEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Budget'
	String get budget => 'Budget';

	/// en: 'Budget Overview'
	String get overview => 'Budget Overview';

	/// en: 'Total Budget'
	String get totalBudget => 'Total Budget';

	/// en: 'Used ¥$amount'
	String spent({required Object amount}) => 'Used ¥${amount}';

	/// en: 'Remaining ¥$amount'
	String remaining({required Object amount}) => 'Remaining ¥${amount}';

	/// en: 'Exceeded'
	String get exceeded => 'Exceeded';

	/// en: 'Warning'
	String get warning => 'Warning';

	/// en: 'Healthy'
	String get plentiful => 'Healthy';

	/// en: 'Normal'
	String get normal => 'Normal';
}

// Path: chat.genui.cashFlowForecast
class TranslationsChatGenuiCashFlowForecastEn {
	TranslationsChatGenuiCashFlowForecastEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cash Flow Forecast'
	String get title => 'Cash Flow Forecast';

	/// en: 'Recurring Transaction'
	String get recurringTransaction => 'Recurring Transaction';

	/// en: 'Recurring Income'
	String get recurringIncome => 'Recurring Income';

	/// en: 'Recurring Expense'
	String get recurringExpense => 'Recurring Expense';

	/// en: 'Recurring Transfer'
	String get recurringTransfer => 'Recurring Transfer';

	/// en: 'Next $days days'
	String nextDays({required Object days}) => 'Next ${days} days';

	/// en: 'No forecast data'
	String get noData => 'No forecast data';

	/// en: 'Forecast Summary'
	String get summary => 'Forecast Summary';

	/// en: 'Predicted Variable Expense'
	String get variableExpense => 'Predicted Variable Expense';

	/// en: 'Est. Net Change'
	String get netChange => 'Est. Net Change';

	/// en: 'Key Events'
	String get keyEvents => 'Key Events';

	/// en: 'No significant events in forecast period'
	String get noSignificantEvents => 'No significant events in forecast period';

	/// en: 'M/d'
	String get dateFormat => 'M/d';
}

// Path: chat.genui.healthScore
class TranslationsChatGenuiHealthScoreEn {
	TranslationsChatGenuiHealthScoreEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Financial Health'
	String get title => 'Financial Health';

	/// en: 'Suggestions'
	String get suggestions => 'Suggestions';

	/// en: '$score pts'
	String scorePoint({required Object score}) => '${score} pts';

	late final TranslationsChatGenuiHealthScoreStatusEn status = TranslationsChatGenuiHealthScoreStatusEn._(_root);
}

// Path: chat.genui.spaceSelector
class TranslationsChatGenuiSpaceSelectorEn {
	TranslationsChatGenuiSpaceSelectorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Selected'
	String get selected => 'Selected';

	/// en: 'Unnamed Space'
	String get unnamedSpace => 'Unnamed Space';

	/// en: 'Linked'
	String get linked => 'Linked';

	/// en: 'Owner'
	String get roleOwner => 'Owner';

	/// en: 'Admin'
	String get roleAdmin => 'Admin';

	/// en: 'Member'
	String get roleMember => 'Member';
}

// Path: chat.genui.transferPath
class TranslationsChatGenuiTransferPathEn {
	TranslationsChatGenuiTransferPathEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Select Source Account'
	String get selectSource => 'Select Source Account';

	/// en: 'Select Target Account'
	String get selectTarget => 'Select Target Account';

	/// en: 'From (Source)'
	String get from => 'From (Source)';

	/// en: 'To (Target)'
	String get to => 'To (Target)';

	/// en: 'Select'
	String get select => 'Select';

	/// en: 'Operation Cancelled'
	String get cancelled => 'Operation Cancelled';

	/// en: 'Failed to load account data'
	String get loadError => 'Failed to load account data';

	/// en: 'Account info missing in history'
	String get historyMissing => 'Account info missing in history';

	/// en: 'Amount Unconfirmed'
	String get amountUnconfirmed => 'Amount Unconfirmed';

	/// en: 'Confirmed: $source → $target'
	String confirmedWithArrow({required Object source, required Object target}) => 'Confirmed: ${source} → ${target}';

	/// en: 'Confirm: $source → $target'
	String confirmAction({required Object source, required Object target}) => 'Confirm: ${source} → ${target}';

	/// en: 'Please select source account'
	String get pleaseSelectSource => 'Please select source account';

	/// en: 'Please select target account'
	String get pleaseSelectTarget => 'Please select target account';

	/// en: 'Confirm Transfer Path'
	String get confirmLinks => 'Confirm Transfer Path';

	/// en: 'Path Locked'
	String get linkLocked => 'Path Locked';

	/// en: 'Click button below to confirm'
	String get clickToConfirm => 'Click button below to confirm';

	/// en: 'Reselect'
	String get reselect => 'Reselect';

	/// en: 'Transfer'
	String get title => 'Transfer';

	/// en: 'History'
	String get history => 'History';

	/// en: 'Unknown Account'
	String get unknownAccount => 'Unknown Account';

	/// en: 'Confirmed'
	String get confirmed => 'Confirmed';
}

// Path: chat.genui.transactionCard
class TranslationsChatGenuiTransactionCardEn {
	TranslationsChatGenuiTransactionCardEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Transaction Successful'
	String get title => 'Transaction Successful';

	/// en: 'Associated Account'
	String get associatedAccount => 'Associated Account';

	/// en: 'Not counted'
	String get notCounted => 'Not counted';

	/// en: 'Modify'
	String get modify => 'Modify';

	/// en: 'Associate Account'
	String get associate => 'Associate Account';

	/// en: 'Select Account'
	String get selectAccount => 'Select Account';

	/// en: 'No accounts available, please add one first'
	String get noAccount => 'No accounts available, please add one first';

	/// en: 'Transaction ID missing, cannot update'
	String get missingId => 'Transaction ID missing, cannot update';

	/// en: 'Associated to $name'
	String associatedTo({required Object name}) => 'Associated to ${name}';

	/// en: 'Update failed: $error'
	String updateFailed({required Object error}) => 'Update failed: ${error}';

	/// en: 'Shared Space'
	String get sharedSpace => 'Shared Space';

	/// en: 'No shared spaces available'
	String get noSpace => 'No shared spaces available';

	/// en: 'Select Shared Space'
	String get selectSpace => 'Select Shared Space';

	/// en: 'Linked to shared space'
	String get linkedToSpace => 'Linked to shared space';
}

// Path: chat.genui.cashFlowCard
class TranslationsChatGenuiCashFlowCardEn {
	TranslationsChatGenuiCashFlowCardEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cash Flow Analysis'
	String get title => 'Cash Flow Analysis';

	/// en: 'Savings $rate%'
	String savingsRate({required Object rate}) => 'Savings ${rate}%';

	/// en: 'Total Income'
	String get totalIncome => 'Total Income';

	/// en: 'Total Expense'
	String get totalExpense => 'Total Expense';

	/// en: 'Essential'
	String get essentialExpense => 'Essential';

	/// en: 'Discretionary'
	String get discretionaryExpense => 'Discretionary';

	/// en: 'AI Insight'
	String get aiInsight => 'AI Insight';
}

// Path: chat.welcome.morning
class TranslationsChatWelcomeMorningEn {
	TranslationsChatWelcomeMorningEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Start your day by tracking'
	String get subtitle => 'Start your day by tracking';

	late final TranslationsChatWelcomeMorningBreakfastEn breakfast = TranslationsChatWelcomeMorningBreakfastEn._(_root);
	late final TranslationsChatWelcomeMorningYesterdayReviewEn yesterdayReview = TranslationsChatWelcomeMorningYesterdayReviewEn._(_root);
	late final TranslationsChatWelcomeMorningTodayBudgetEn todayBudget = TranslationsChatWelcomeMorningTodayBudgetEn._(_root);
}

// Path: chat.welcome.midday
class TranslationsChatWelcomeMiddayEn {
	TranslationsChatWelcomeMiddayEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Good Afternoon'
	String get greeting => 'Good Afternoon';

	/// en: 'Quick record during lunch'
	String get subtitle => 'Quick record during lunch';

	late final TranslationsChatWelcomeMiddayLunchEn lunch = TranslationsChatWelcomeMiddayLunchEn._(_root);
	late final TranslationsChatWelcomeMiddayWeeklyExpenseEn weeklyExpense = TranslationsChatWelcomeMiddayWeeklyExpenseEn._(_root);
	late final TranslationsChatWelcomeMiddayCheckBalanceEn checkBalance = TranslationsChatWelcomeMiddayCheckBalanceEn._(_root);
}

// Path: chat.welcome.afternoon
class TranslationsChatWelcomeAfternoonEn {
	TranslationsChatWelcomeAfternoonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Tea time, let's review finances'
	String get subtitle => 'Tea time, let\'s review finances';

	late final TranslationsChatWelcomeAfternoonQuickRecordEn quickRecord = TranslationsChatWelcomeAfternoonQuickRecordEn._(_root);
	late final TranslationsChatWelcomeAfternoonAnalyzeSpendingEn analyzeSpending = TranslationsChatWelcomeAfternoonAnalyzeSpendingEn._(_root);
	late final TranslationsChatWelcomeAfternoonBudgetProgressEn budgetProgress = TranslationsChatWelcomeAfternoonBudgetProgressEn._(_root);
}

// Path: chat.welcome.evening
class TranslationsChatWelcomeEveningEn {
	TranslationsChatWelcomeEveningEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'End of day, time to balance the books'
	String get subtitle => 'End of day, time to balance the books';

	late final TranslationsChatWelcomeEveningDinnerEn dinner = TranslationsChatWelcomeEveningDinnerEn._(_root);
	late final TranslationsChatWelcomeEveningTodaySummaryEn todaySummary = TranslationsChatWelcomeEveningTodaySummaryEn._(_root);
	late final TranslationsChatWelcomeEveningTomorrowPlanEn tomorrowPlan = TranslationsChatWelcomeEveningTomorrowPlanEn._(_root);
}

// Path: chat.welcome.night
class TranslationsChatWelcomeNightEn {
	TranslationsChatWelcomeNightEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Late Night'
	String get greeting => 'Late Night';

	/// en: 'Quiet time for financial planning'
	String get subtitle => 'Quiet time for financial planning';

	late final TranslationsChatWelcomeNightMakeupRecordEn makeupRecord = TranslationsChatWelcomeNightMakeupRecordEn._(_root);
	late final TranslationsChatWelcomeNightMonthlyReviewEn monthlyReview = TranslationsChatWelcomeNightMonthlyReviewEn._(_root);
	late final TranslationsChatWelcomeNightFinancialThinkingEn financialThinking = TranslationsChatWelcomeNightFinancialThinkingEn._(_root);
}

// Path: chat.genui.healthScore.status
class TranslationsChatGenuiHealthScoreStatusEn {
	TranslationsChatGenuiHealthScoreStatusEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Excellent'
	String get excellent => 'Excellent';

	/// en: 'Good'
	String get good => 'Good';

	/// en: 'Fair'
	String get fair => 'Fair';

	/// en: 'Needs Improvement'
	String get needsImprovement => 'Needs Improvement';

	/// en: 'Poor'
	String get poor => 'Poor';
}

// Path: chat.welcome.morning.breakfast
class TranslationsChatWelcomeMorningBreakfastEn {
	TranslationsChatWelcomeMorningBreakfastEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Breakfast'
	String get title => 'Breakfast';

	/// en: 'Record breakfast expense'
	String get prompt => 'Record breakfast expense';

	/// en: 'Log today's first expense'
	String get description => 'Log today\'s first expense';
}

// Path: chat.welcome.morning.yesterdayReview
class TranslationsChatWelcomeMorningYesterdayReviewEn {
	TranslationsChatWelcomeMorningYesterdayReviewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Yesterday Review'
	String get title => 'Yesterday Review';

	/// en: 'Analyze yesterday's spending'
	String get prompt => 'Analyze yesterday\'s spending';

	/// en: 'Check how much you spent yesterday'
	String get description => 'Check how much you spent yesterday';
}

// Path: chat.welcome.morning.todayBudget
class TranslationsChatWelcomeMorningTodayBudgetEn {
	TranslationsChatWelcomeMorningTodayBudgetEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Today's Budget'
	String get title => 'Today\'s Budget';

	/// en: 'How much budget left for today'
	String get prompt => 'How much budget left for today';

	/// en: 'Plan your spending for today'
	String get description => 'Plan your spending for today';
}

// Path: chat.welcome.midday.lunch
class TranslationsChatWelcomeMiddayLunchEn {
	TranslationsChatWelcomeMiddayLunchEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Lunch'
	String get title => 'Lunch';

	/// en: 'Record lunch expense'
	String get prompt => 'Record lunch expense';

	/// en: 'Log your lunch spending'
	String get description => 'Log your lunch spending';
}

// Path: chat.welcome.midday.weeklyExpense
class TranslationsChatWelcomeMiddayWeeklyExpenseEn {
	TranslationsChatWelcomeMiddayWeeklyExpenseEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Weekly Spending'
	String get title => 'Weekly Spending';

	/// en: 'Analyze this week's spending'
	String get prompt => 'Analyze this week\'s spending';

	/// en: 'See your weekly expenses'
	String get description => 'See your weekly expenses';
}

// Path: chat.welcome.midday.checkBalance
class TranslationsChatWelcomeMiddayCheckBalanceEn {
	TranslationsChatWelcomeMiddayCheckBalanceEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Check Balance'
	String get title => 'Check Balance';

	/// en: 'Check my account balance'
	String get prompt => 'Check my account balance';

	/// en: 'View your account balances'
	String get description => 'View your account balances';
}

// Path: chat.welcome.afternoon.quickRecord
class TranslationsChatWelcomeAfternoonQuickRecordEn {
	TranslationsChatWelcomeAfternoonQuickRecordEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Quick Record'
	String get title => 'Quick Record';

	/// en: 'Help me record an expense'
	String get prompt => 'Help me record an expense';

	/// en: 'Quickly log a transaction'
	String get description => 'Quickly log a transaction';
}

// Path: chat.welcome.afternoon.analyzeSpending
class TranslationsChatWelcomeAfternoonAnalyzeSpendingEn {
	TranslationsChatWelcomeAfternoonAnalyzeSpendingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Analyze Spending'
	String get title => 'Analyze Spending';

	/// en: 'Analyze this month's spending'
	String get prompt => 'Analyze this month\'s spending';

	/// en: 'View spending trends and breakdown'
	String get description => 'View spending trends and breakdown';
}

// Path: chat.welcome.afternoon.budgetProgress
class TranslationsChatWelcomeAfternoonBudgetProgressEn {
	TranslationsChatWelcomeAfternoonBudgetProgressEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Budget Progress'
	String get title => 'Budget Progress';

	/// en: 'Check budget status'
	String get prompt => 'Check budget status';

	/// en: 'See how your budget is doing'
	String get description => 'See how your budget is doing';
}

// Path: chat.welcome.evening.dinner
class TranslationsChatWelcomeEveningDinnerEn {
	TranslationsChatWelcomeEveningDinnerEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Dinner'
	String get title => 'Dinner';

	/// en: 'Record dinner expense'
	String get prompt => 'Record dinner expense';

	/// en: 'Log tonight's dinner spending'
	String get description => 'Log tonight\'s dinner spending';
}

// Path: chat.welcome.evening.todaySummary
class TranslationsChatWelcomeEveningTodaySummaryEn {
	TranslationsChatWelcomeEveningTodaySummaryEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Today's Summary'
	String get title => 'Today\'s Summary';

	/// en: 'Summarize today's spending'
	String get prompt => 'Summarize today\'s spending';

	/// en: 'See what you spent today'
	String get description => 'See what you spent today';
}

// Path: chat.welcome.evening.tomorrowPlan
class TranslationsChatWelcomeEveningTomorrowPlanEn {
	TranslationsChatWelcomeEveningTomorrowPlanEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Tomorrow's Plan'
	String get title => 'Tomorrow\'s Plan';

	/// en: 'What fixed expenses tomorrow'
	String get prompt => 'What fixed expenses tomorrow';

	/// en: 'Plan ahead for tomorrow'
	String get description => 'Plan ahead for tomorrow';
}

// Path: chat.welcome.night.makeupRecord
class TranslationsChatWelcomeNightMakeupRecordEn {
	TranslationsChatWelcomeNightMakeupRecordEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Catch Up'
	String get title => 'Catch Up';

	/// en: 'Help me log any missed expenses'
	String get prompt => 'Help me log any missed expenses';

	/// en: 'Record expenses you forgot today'
	String get description => 'Record expenses you forgot today';
}

// Path: chat.welcome.night.monthlyReview
class TranslationsChatWelcomeNightMonthlyReviewEn {
	TranslationsChatWelcomeNightMonthlyReviewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Monthly Review'
	String get title => 'Monthly Review';

	/// en: 'Analyze this month's spending'
	String get prompt => 'Analyze this month\'s spending';

	/// en: 'Review your monthly expenses'
	String get description => 'Review your monthly expenses';
}

// Path: chat.welcome.night.financialThinking
class TranslationsChatWelcomeNightFinancialThinkingEn {
	TranslationsChatWelcomeNightFinancialThinkingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Financial Tips'
	String get title => 'Financial Tips';

	/// en: 'Give me some financial advice'
	String get prompt => 'Give me some financial advice';

	/// en: 'Get AI-powered financial insights'
	String get description => 'Get AI-powered financial insights';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
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
			'chat.tools.read_file' => 'Reading file...',
			'chat.tools.search_transactions' => 'Searching transactions...',
			'chat.tools.query_budget_status' => 'Checking budget...',
			'chat.tools.create_budget' => 'Creating budget plan...',
			'chat.tools.get_cash_flow_analysis' => 'Analyzing cash flow...',
			'chat.tools.get_financial_health_score' => 'Calculating financial health score...',
			'chat.tools.get_financial_summary' => 'Generating financial report...',
			'chat.tools.evaluate_financial_health' => 'Evaluating financial health...',
			'chat.tools.forecast_balance' => 'Forecasting future balance...',
			'chat.tools.simulate_expense_impact' => 'Simulating purchase impact...',
			'chat.tools.record_transactions' => 'Recording transactions...',
			'chat.tools.create_transaction' => 'Recording transaction...',
			'chat.tools.duckduckgo_search' => 'Searching the web...',
			'chat.tools.execute_transfer' => 'Executing transfer...',
			'chat.tools.list_dir' => 'Browsing directory...',
			'chat.tools.execute' => 'Processing...',
			'chat.tools.analyze_finance' => 'Analyzing finances...',
			'chat.tools.forecast_finance' => 'Forecasting finances...',
			'chat.tools.analyze_budget' => 'Analyzing budget...',
			'chat.tools.audit_analysis' => 'Running audit analysis...',
			'chat.tools.budget_ops' => 'Processing budget...',
			'chat.tools.create_shared_transaction' => 'Creating shared expense...',
			'chat.tools.list_spaces' => 'Loading shared spaces...',
			'chat.tools.query_space_summary' => 'Querying space summary...',
			'chat.tools.prepare_transfer' => 'Preparing transfer...',
			'chat.tools.unknown' => 'Processing request...',
			'chat.tools.done.read_file' => 'Read file',
			'chat.tools.done.search_transactions' => 'Searched transactions',
			'chat.tools.done.query_budget_status' => 'Checked budget',
			'chat.tools.done.create_budget' => 'Created budget',
			'chat.tools.done.get_cash_flow_analysis' => 'Analyzed cash flow',
			'chat.tools.done.get_financial_health_score' => 'Calculated health score',
			'chat.tools.done.get_financial_summary' => 'Financial report ready',
			'chat.tools.done.evaluate_financial_health' => 'Health evaluation complete',
			'chat.tools.done.forecast_balance' => 'Balance forecast ready',
			'chat.tools.done.simulate_expense_impact' => 'Impact simulation complete',
			'chat.tools.done.record_transactions' => 'Recorded transactions',
			'chat.tools.done.create_transaction' => 'Recorded transaction',
			'chat.tools.done.duckduckgo_search' => 'Searched the web',
			'chat.tools.done.execute_transfer' => 'Transfer complete',
			'chat.tools.done.list_dir' => 'Browsed directory',
			'chat.tools.done.execute' => 'Processing complete',
			'chat.tools.done.analyze_finance' => 'Finance analysis complete',
			'chat.tools.done.forecast_finance' => 'Finance forecast complete',
			'chat.tools.done.analyze_budget' => 'Budget analysis complete',
			'chat.tools.done.audit_analysis' => 'Audit analysis complete',
			'chat.tools.done.budget_ops' => 'Budget processing complete',
			'chat.tools.done.create_shared_transaction' => 'Shared expense created',
			'chat.tools.done.list_spaces' => 'Shared spaces loaded',
			'chat.tools.done.query_space_summary' => 'Space summary ready',
			'chat.tools.done.prepare_transfer' => 'Transfer ready',
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
