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
class TranslationsZh with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsZh({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.zh,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsZh _root = this; // ignore: unused_field

	@override
	TranslationsZh $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsZh(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsCommonZh common = _TranslationsCommonZh._(_root);
	@override late final _TranslationsTimeZh time = _TranslationsTimeZh._(_root);
	@override late final _TranslationsGreetingZh greeting = _TranslationsGreetingZh._(_root);
	@override late final _TranslationsNavigationZh navigation = _TranslationsNavigationZh._(_root);
	@override late final _TranslationsAuthZh auth = _TranslationsAuthZh._(_root);
	@override late final _TranslationsTransactionZh transaction = _TranslationsTransactionZh._(_root);
	@override late final _TranslationsHomeZh home = _TranslationsHomeZh._(_root);
	@override late final _TranslationsCommentZh comment = _TranslationsCommentZh._(_root);
	@override late final _TranslationsCalendarZh calendar = _TranslationsCalendarZh._(_root);
	@override late final _TranslationsCategoryZh category = _TranslationsCategoryZh._(_root);
	@override late final _TranslationsSettingsZh settings = _TranslationsSettingsZh._(_root);
	@override late final _TranslationsAppearanceZh appearance = _TranslationsAppearanceZh._(_root);
	@override late final _TranslationsSpeechZh speech = _TranslationsSpeechZh._(_root);
	@override late final _TranslationsAmountThemeZh amountTheme = _TranslationsAmountThemeZh._(_root);
	@override late final _TranslationsLocaleZh locale = _TranslationsLocaleZh._(_root);
	@override late final _TranslationsBudgetZh budget = _TranslationsBudgetZh._(_root);
	@override late final _TranslationsDateRangeZh dateRange = _TranslationsDateRangeZh._(_root);
	@override late final _TranslationsForecastZh forecast = _TranslationsForecastZh._(_root);
	@override late final _TranslationsChatZh chat = _TranslationsChatZh._(_root);
	@override late final _TranslationsFootprintZh footprint = _TranslationsFootprintZh._(_root);
	@override late final _TranslationsMediaZh media = _TranslationsMediaZh._(_root);
	@override late final _TranslationsErrorZh error = _TranslationsErrorZh._(_root);
	@override late final _TranslationsFontTestZh fontTest = _TranslationsFontTestZh._(_root);
	@override late final _TranslationsWizardZh wizard = _TranslationsWizardZh._(_root);
	@override late final _TranslationsUserZh user = _TranslationsUserZh._(_root);
	@override late final _TranslationsAccountZh account = _TranslationsAccountZh._(_root);
	@override late final _TranslationsFinancialZh financial = _TranslationsFinancialZh._(_root);
	@override late final _TranslationsAppZh app = _TranslationsAppZh._(_root);
	@override late final _TranslationsStatisticsZh statistics = _TranslationsStatisticsZh._(_root);
	@override late final _TranslationsCurrencyZh currency = _TranslationsCurrencyZh._(_root);
	@override late final _TranslationsBudgetSuggestionZh budgetSuggestion = _TranslationsBudgetSuggestionZh._(_root);
	@override late final _TranslationsServerZh server = _TranslationsServerZh._(_root);
	@override late final _TranslationsSharedSpaceZh sharedSpace = _TranslationsSharedSpaceZh._(_root);
	@override late final _TranslationsErrorMappingZh errorMapping = _TranslationsErrorMappingZh._(_root);
}

// Path: common
class _TranslationsCommonZh implements TranslationsCommonEn {
	_TranslationsCommonZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get loading => '加载中...';
	@override String get error => '错误';
	@override String get retry => '重试';
	@override String get cancel => '取消';
	@override String get confirm => '确认';
	@override String get save => '保存';
	@override String get delete => '删除';
	@override String get edit => '编辑';
	@override String get add => '添加';
	@override String get search => '搜索';
	@override String get filter => '筛选';
	@override String get sort => '排序';
	@override String get refresh => '刷新';
	@override String get more => '更多';
	@override String get less => '收起';
	@override String get all => '全部';
	@override String get none => '无';
	@override String get ok => '确定';
	@override String get unknown => '未知';
	@override String get noData => '暂无数据';
	@override String get loadMore => '加载更多';
	@override String get noMore => '没有更多了';
	@override String get loadFailed => '加载失败';
	@override String get history => '交易记录';
	@override String get reset => '重置';
}

// Path: time
class _TranslationsTimeZh implements TranslationsTimeEn {
	_TranslationsTimeZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get today => '今天';
	@override String get yesterday => '昨天';
	@override String get dayBeforeYesterday => '前天';
	@override String get thisWeek => '本周';
	@override String get thisMonth => '本月';
	@override String get thisYear => '今年';
	@override String get selectDate => '选择日期';
	@override String get selectTime => '选择时间';
	@override String get justNow => '刚刚';
	@override String minutesAgo({required Object count}) => '${count}分钟前';
	@override String hoursAgo({required Object count}) => '${count}小时前';
	@override String daysAgo({required Object count}) => '${count}天前';
	@override String weeksAgo({required Object count}) => '${count}周前';
}

// Path: greeting
class _TranslationsGreetingZh implements TranslationsGreetingEn {
	_TranslationsGreetingZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get morning => '上午好';
	@override String get afternoon => '下午好';
	@override String get evening => '晚上好';
}

// Path: navigation
class _TranslationsNavigationZh implements TranslationsNavigationEn {
	_TranslationsNavigationZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get home => '首页';
	@override String get forecast => '预测';
	@override String get footprint => '足迹';
	@override String get profile => '我的';
}

// Path: auth
class _TranslationsAuthZh implements TranslationsAuthEn {
	_TranslationsAuthZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get login => '登录';
	@override String get loggingIn => '登录中...';
	@override String get logout => '退出';
	@override String get logoutSuccess => '已成功退出登录';
	@override String get confirmLogoutTitle => '确认退出登录';
	@override String get confirmLogoutContent => '您确定要退出当前的登录状态吗？';
	@override String get register => '注册';
	@override String get registering => '注册中...';
	@override String get welcomeBack => '欢迎回来';
	@override String get loginSuccess => '欢迎回来!';
	@override String get loginFailed => '登录失败';
	@override String get pleaseTryAgain => '请稍后重试。';
	@override String get loginSubtitle => '登录以继续使用 AI 记账助理';
	@override String get noAccount => '还没有账户？注册';
	@override String get createAccount => '创建您的账户';
	@override String get setPassword => '设置密码';
	@override String get setAccountPassword => '设置您的账户密码';
	@override String get completeRegistration => '完成注册';
	@override String get registrationSuccess => '注册成功!';
	@override String get registrationFailed => '注册失败';
	@override late final _TranslationsAuthEmailZh email = _TranslationsAuthEmailZh._(_root);
	@override late final _TranslationsAuthPasswordZh password = _TranslationsAuthPasswordZh._(_root);
	@override late final _TranslationsAuthVerificationCodeZh verificationCode = _TranslationsAuthVerificationCodeZh._(_root);
}

// Path: transaction
class _TranslationsTransactionZh implements TranslationsTransactionEn {
	_TranslationsTransactionZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get expense => '支出';
	@override String get income => '收入';
	@override String get transfer => '转账';
	@override String get amount => '金额';
	@override String get category => '分类';
	@override String get description => '描述';
	@override String get tags => '标签';
	@override String get saveTransaction => '保存记账';
	@override String get pleaseEnterAmount => '请输入金额';
	@override String get pleaseSelectCategory => '请选择分类';
	@override String get saveFailed => '保存失败';
	@override String get descriptionHint => '记录这笔交易的详细信息...';
	@override String get addCustomTag => '添加自定义标签';
	@override String get commonTags => '常用标签';
	@override String maxTagsHint({required Object maxTags}) => '最多添加 ${maxTags} 个标签';
	@override String get noTransactionsFound => '没有找到交易记录';
	@override String get tryAdjustingSearch => '尝试调整搜索条件或创建新的交易记录';
	@override String get noDescription => '无描述';
	@override String get payment => '支付';
	@override String get account => '账户';
	@override String get time => '时间';
	@override String get location => '地点';
	@override String get transactionDetail => '交易详情';
	@override String get favorite => '收藏';
	@override String get confirmDelete => '确认删除';
	@override String get deleteTransactionConfirm => '您确定要删除此条交易记录吗？此操作无法撤销。';
	@override String get noActions => '没有可用的操作';
	@override String get deleted => '已删除';
	@override String get deleteFailed => '删除失败，请稍后重试';
	@override String get linkedAccount => '关联账户';
	@override String get linkedSpace => '关联空间';
	@override String get notLinked => '未关联';
	@override String get link => '关联';
	@override String get changeAccount => '更换账户';
	@override String get addSpace => '添加空间';
	@override String nSpaces({required Object count}) => '${count} 个空间';
	@override String get selectLinkedAccount => '选择关联账户';
	@override String get selectLinkedSpace => '选择关联空间';
	@override String get noSpacesAvailable => '暂无可用空间';
	@override String get linkSuccess => '关联成功';
	@override String get linkFailed => '关联失败';
	@override String get rawInput => '消息';
	@override String get noRawInput => '无消息';
}

// Path: home
class _TranslationsHomeZh implements TranslationsHomeEn {
	_TranslationsHomeZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get totalExpense => '总消费金额';
	@override String get todayExpense => '今日支出';
	@override String get monthExpense => '本月支出';
	@override String yearProgress({required Object year}) => '${year}年进度';
	@override String get amountHidden => '••••••••';
	@override String get loadFailed => '加载失败';
	@override String get noTransactions => '暂无交易记录';
	@override String get tryRefresh => '刷新试试';
	@override String get noMoreData => '没有更多数据了';
	@override String get userNotLoggedIn => '用户未登录，无法加载数据';
}

// Path: comment
class _TranslationsCommentZh implements TranslationsCommentEn {
	_TranslationsCommentZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get error => '错误';
	@override String get commentFailed => '评论失败';
	@override String replyToPrefix({required Object name}) => '回复 @${name}:';
	@override String get reply => '回复';
	@override String get addNote => '添加备注...';
	@override String get confirmDeleteTitle => '确认删除';
	@override String get confirmDeleteContent => '你确定要删除这条评论吗？此操作无法撤销。';
	@override String get success => '成功';
	@override String get commentDeleted => '评论已删除';
	@override String get deleteFailed => '删除失败';
	@override String get deleteComment => '删除评论';
	@override String get hint => '提示';
	@override String get noActions => '没有可用的操作';
	@override String get note => '备注';
	@override String get noNote => '暂无备注';
	@override String get loadFailed => '加载备注失败';
}

// Path: calendar
class _TranslationsCalendarZh implements TranslationsCalendarEn {
	_TranslationsCalendarZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '消费日历';
	@override late final _TranslationsCalendarWeekdaysZh weekdays = _TranslationsCalendarWeekdaysZh._(_root);
	@override String get loadFailed => '加载日历数据失败';
	@override String thisMonth({required Object amount}) => '本月: ${amount}';
	@override String get counting => '统计中...';
	@override String get unableToCount => '无法统计';
	@override String get trend => '趋势: ';
	@override String get noTransactionsTitle => '当日无交易记录';
	@override String get loadTransactionFailed => '加载交易失败';
}

// Path: category
class _TranslationsCategoryZh implements TranslationsCategoryEn {
	_TranslationsCategoryZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get dailyConsumption => '日常消费';
	@override String get transportation => '交通出行';
	@override String get healthcare => '医疗健康';
	@override String get housing => '住房物业';
	@override String get education => '教育培训';
	@override String get incomeCategory => '收入进账';
	@override String get socialGifts => '社交馈赠';
	@override String get moneyTransfer => '资金周转';
	@override String get other => '其他';
	@override String get foodDining => '餐饮美食';
	@override String get shoppingRetail => '购物消费';
	@override String get housingUtilities => '居住物业';
	@override String get personalCare => '个人护理';
	@override String get entertainment => '休闲娱乐';
	@override String get medicalHealth => '医疗健康';
	@override String get insurance => '保险';
	@override String get socialGifting => '人情往来';
	@override String get financialTax => '金融税务';
	@override String get others => '其他支出';
	@override String get salaryWage => '工资薪水';
	@override String get businessTrade => '经营交易';
	@override String get investmentReturns => '投资回报';
	@override String get giftBonus => '礼金红包';
	@override String get refundRebate => '退款返利';
	@override String get generalTransfer => '转账';
	@override String get debtRepayment => '债务还款';
}

// Path: settings
class _TranslationsSettingsZh implements TranslationsSettingsEn {
	_TranslationsSettingsZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '设置';
	@override String get language => '语言';
	@override String get languageSettings => '语言设置';
	@override String get selectLanguage => '选择语言';
	@override String get languageChanged => '语言已更改';
	@override String get restartToApply => '重启应用以应用更改';
	@override String get theme => '主题';
	@override String get darkMode => '深色模式';
	@override String get lightMode => '浅色模式';
	@override String get systemMode => '跟随系统';
	@override String get developerOptions => '开发者选项';
	@override String get authDebug => '认证状态调试';
	@override String get authDebugSubtitle => '查看认证状态和调试信息';
	@override String get fontTest => '字体测试';
	@override String get fontTestSubtitle => '测试应用字体显示效果';
	@override String get helpAndFeedback => '帮助与反馈';
	@override String get helpAndFeedbackSubtitle => '获取帮助或提供反馈';
	@override String get aboutApp => '关于应用';
	@override String get aboutAppSubtitle => '版本信息和开发者信息';
	@override String currencyChangedRefreshHint({required Object currency}) => '已切换为 ${currency}，新交易将以此货币记录';
	@override String get sharedSpace => '共享空间';
	@override String get speechRecognition => '语音识别';
	@override String get speechRecognitionSubtitle => '配置语音输入参数';
	@override String get amountDisplayStyle => '金额显示样式';
	@override String get currency => '显示币种';
	@override String get appearance => '外观设置';
	@override String get appearanceSubtitle => '主题模式与配色方案';
	@override String get speechTest => '语音测试';
	@override String get speechTestSubtitle => '测试 WebSocket 语音连接';
	@override String get userTypeRegular => '普通用户';
	@override String get selectAmountStyle => '选择金额显示样式';
	@override String get amountStyleNotice => '注意：金额样式主要应用于「交易流水」和「趋势分析」。为了保持视觉清晰，「账户余额」和「资产概览」等状态类数值将保持中性颜色。';
	@override String get currencyDescription => '选择您的主要货币。未来的记账将默认使用此货币，统计和汇总也将以此货币显示。历史交易的原始金额不受影响。';
	@override String get editUsername => '修改用户名';
	@override String get enterUsername => '请输入用户名';
	@override String get usernameRequired => '用户名不能为空';
	@override String get usernameUpdated => '用户名已更新';
	@override String get avatarUpdated => '头像已更新';
	@override String get appearanceUpdated => '外观设置已更新';
}

// Path: appearance
class _TranslationsAppearanceZh implements TranslationsAppearanceEn {
	_TranslationsAppearanceZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '外观设置';
	@override String get themeMode => '主题模式';
	@override String get light => '浅色';
	@override String get dark => '深色';
	@override String get system => '跟随系统';
	@override String get colorScheme => '配色方案';
	@override late final _TranslationsAppearancePalettesZh palettes = _TranslationsAppearancePalettesZh._(_root);
}

// Path: speech
class _TranslationsSpeechZh implements TranslationsSpeechEn {
	_TranslationsSpeechZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '语音识别设置';
	@override String get service => '语音识别服务';
	@override String get systemVoice => '系统语音';
	@override String get systemVoiceSubtitle => '使用手机内置的语音识别服务（推荐）';
	@override String get selfHostedASR => '自建 ASR 服务';
	@override String get selfHostedASRSubtitle => '使用 WebSocket 连接到自建语音识别服务';
	@override String get serverConfig => '服务器配置';
	@override String get serverAddress => '服务器地址';
	@override String get port => '端口';
	@override String get path => '路径';
	@override String get saveConfig => '保存配置';
	@override String get info => '信息';
	@override String get infoContent => '• 系统语音：使用设备内置服务，无需配置，响应更快\n• 自建 ASR：适用于自定义模型或离线场景\n\n更改将在下次使用语音输入时生效。';
	@override String get enterAddress => '请输入服务器地址';
	@override String get enterValidPort => '请输入有效的端口 (1-65535)';
	@override String get configSaved => '配置已保存';
}

// Path: amountTheme
class _TranslationsAmountThemeZh implements TranslationsAmountThemeEn {
	_TranslationsAmountThemeZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get chinaMarket => '中国市场';
	@override String get chinaMarketDesc => '红涨绿跌/黑跌';
	@override String get international => '国际标准';
	@override String get internationalDesc => '绿涨红跌';
	@override String get minimalist => '极简模式';
	@override String get minimalistDesc => '仅通过符号区分';
	@override String get colorBlind => '色弱友好';
	@override String get colorBlindDesc => '蓝橙配色方案';
}

// Path: locale
class _TranslationsLocaleZh implements TranslationsLocaleEn {
	_TranslationsLocaleZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get chinese => '中文（简体）';
	@override String get traditionalChinese => '中文（繁体）';
	@override String get english => 'English';
	@override String get japanese => '日本語';
	@override String get korean => '한국어';
}

// Path: budget
class _TranslationsBudgetZh implements TranslationsBudgetEn {
	_TranslationsBudgetZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '预算管理';
	@override String get detail => '预算详情';
	@override String get info => '预算信息';
	@override String get totalBudget => '总预算';
	@override String get categoryBudget => '分类预算';
	@override String get monthlySummary => '本月预算汇总';
	@override String get used => '已使用';
	@override String get remaining => '剩余';
	@override String get overspent => '超支';
	@override String get budget => '预算';
	@override String get loadFailed => '加载失败';
	@override String get noBudget => '暂无预算';
	@override String get createHint => '通过 Augo 助手说"帮我设置预算"来创建';
	@override String get paused => '已暂停';
	@override String get pause => '暂停';
	@override String get resume => '恢复';
	@override String get budgetPaused => '预算已暂停';
	@override String get budgetResumed => '预算已恢复';
	@override String get operationFailed => '操作失败';
	@override String get deleteBudget => '删除预算';
	@override String get deleteConfirm => '确定要删除这个预算吗？此操作不可撤销。';
	@override String get type => '类型';
	@override String get category => '分类';
	@override String get period => '周期';
	@override String get rollover => '滚动预算';
	@override String get rolloverBalance => '滚动余额';
	@override String get enabled => '开启';
	@override String get disabled => '关闭';
	@override String get statusNormal => '预算正常';
	@override String get statusWarning => '接近上限';
	@override String get statusOverspent => '已超支';
	@override String get statusAchieved => '目标达成';
	@override String tipNormal({required Object amount}) => '还剩 ${amount} 可用';
	@override String tipWarning({required Object amount}) => '仅剩 ${amount}，请注意控制';
	@override String tipOverspent({required Object amount}) => '已超支 ${amount}';
	@override String get tipAchieved => '恭喜完成储蓄目标！';
	@override String remainingAmount({required Object amount}) => '剩余 ${amount}';
	@override String overspentAmount({required Object amount}) => '超支 ${amount}';
	@override String budgetAmount({required Object amount}) => '预算 ${amount}';
	@override String get active => '活跃';
	@override String get all => '全部';
	@override String get notFound => '预算不存在或已被删除';
	@override String get setup => '预算设置';
	@override String get settings => '预算设置';
	@override String get setAmount => '设置预算金额';
	@override String get setAmountDesc => '为每个分类设置预算金额';
	@override String get monthly => '月度预算';
	@override String get monthlyDesc => '按月管理您的支出，适合大多数人';
	@override String get weekly => '周预算';
	@override String get weeklyDesc => '按周管理支出，更精细的控制';
	@override String get yearly => '年度预算';
	@override String get yearlyDesc => '长期财务规划，适合大额支出管理';
	@override String get editBudget => '编辑预算';
	@override String get editBudgetDesc => '修改预算金额和分类';
	@override String get reminderSettings => '提醒设置';
	@override String get reminderSettingsDesc => '设置预算提醒和通知';
	@override String get report => '预算报告';
	@override String get reportDesc => '查看详细的预算分析报告';
	@override String get welcome => '欢迎使用预算功能！';
	@override String get createNewPlan => '创建新的预算计划';
	@override String get welcomeDesc => '通过设置预算，您可以更好地控制支出，实现财务目标。让我们开始设置您的第一个预算计划吧！';
	@override String get createDesc => '为不同的支出类别设置预算限额，帮助您更好地管理财务。';
	@override String get newBudget => '新建预算';
	@override String get budgetAmountLabel => '预算金额';
	@override String get currency => '货币';
	@override String get periodSettings => '周期设置';
	@override String get autoGenerateTransactions => '开启后按规则自动生成交易';
	@override String get cycle => '周期';
	@override String get budgetCategory => '预算分类';
	@override String get advancedOptions => '高级选项';
	@override String get periodType => '周期类型';
	@override String get anchorDay => '起算日';
	@override String get selectPeriodType => '选择周期类型';
	@override String get selectAnchorDay => '选择起算日';
	@override String get rolloverDescription => '未用完的预算结转到下期';
	@override String get createBudget => '创建预算';
	@override String get save => '保存';
	@override String get pleaseEnterAmount => '请输入预算金额';
	@override String get invalidAmount => '请输入有效的预算金额';
	@override String get updateSuccess => '预算更新成功';
	@override String get createSuccess => '预算创建成功';
	@override String get deleteSuccess => '预算已删除';
	@override String get deleteFailed => '删除失败';
	@override String everyMonthDay({required Object day}) => '每月 ${day} 号';
	@override String get periodWeekly => '每周';
	@override String get periodBiweekly => '双周';
	@override String get periodMonthly => '每月';
	@override String get periodYearly => '每年';
	@override String get statusActive => '进行中';
	@override String get statusArchived => '已归档';
	@override String get periodStatusOnTrack => '正常';
	@override String get periodStatusWarning => '预警';
	@override String get periodStatusExceeded => '超支';
	@override String get periodStatusAchieved => '达成';
	@override String usedPercent({required Object percent}) => '${percent}% 已使用';
	@override String dayOfMonth({required Object day}) => '${day} 号';
	@override String get tenThousandSuffix => '万';
}

// Path: dateRange
class _TranslationsDateRangeZh implements TranslationsDateRangeEn {
	_TranslationsDateRangeZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get custom => '自定义';
	@override String get pickerTitle => '选择时间范围';
	@override String get startDate => '开始日期';
	@override String get endDate => '结束日期';
	@override String get hint => '请选择日期范围';
}

// Path: forecast
class _TranslationsForecastZh implements TranslationsForecastEn {
	_TranslationsForecastZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '预测';
	@override String get subtitle => '基于您的财务数据智能预测未来现金流';
	@override String get financialNavigator => '你好，我是你的财务领航员';
	@override String get financialMapSubtitle => '只需3步，我们一起绘制你未来的财务地图';
	@override String get predictCashFlow => '预测未来现金流';
	@override String get predictCashFlowDesc => '看清每一天的财务状况';
	@override String get aiSmartSuggestions => 'AI智能建议';
	@override String get aiSmartSuggestionsDesc => '个性化的财务决策指导';
	@override String get riskWarning => '风险预警';
	@override String get riskWarningDesc => '提前发现潜在的财务风险';
	@override String get analyzing => '我正在分析你的财务数据，生成未来30天的现金流预测';
	@override String get analyzePattern => '分析收入支出模式';
	@override String get calculateTrend => '计算现金流趋势';
	@override String get generateWarning => '生成风险预警';
	@override String get loadingForecast => '正在加载财务预测...';
	@override String get todayLabel => '今日';
	@override String get tomorrowLabel => '明日';
	@override String get balanceLabel => '余额';
	@override String get noSpecialEvents => '无特殊事件';
	@override String get financialSafetyLine => '财务安全线';
	@override String get currentSetting => '当前设置';
	@override String get dailySpendingEstimate => '日常消费预估';
	@override String get adjustDailySpendingAmount => '调整每日消费预测金额';
	@override String get tellMeYourSafetyLine => '告诉我你的财务"安心线"是多少？';
	@override String get safetyLineDescription => '这是你希望账户保持的最低余额，当余额接近这个数值时，我会提醒你注意财务风险。';
	@override String get dailySpendingQuestion => '每天的"小日子"大概花多少？';
	@override String get dailySpendingDescription => '包括吃饭、交通、购物等日常开销\n这只是一个初始估算，我会通过你未来的真实记录，让预测越来越准';
	@override String get perDay => '每天';
	@override String get referenceStandard => '参考标准';
	@override String get frugalType => '节俭型';
	@override String get comfortableType => '舒适型';
	@override String get relaxedType => '宽松型';
	@override String get frugalAmount => '50-100元/天';
	@override String get comfortableAmount => '100-200元/天';
	@override String get relaxedAmount => '200-300元/天';
	@override late final _TranslationsForecastRecurringTransactionZh recurringTransaction = _TranslationsForecastRecurringTransactionZh._(_root);
}

// Path: chat
class _TranslationsChatZh implements TranslationsChatEn {
	_TranslationsChatZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get newChat => '新聊天';
	@override String get noMessages => '没有消息可显示。';
	@override String get loadingFailed => '加载失败';
	@override String get inputMessage => '输入消息...';
	@override String get listening => '正在聆听...';
	@override String get aiThinking => '正在处理...';
	@override late final _TranslationsChatToolsZh tools = _TranslationsChatToolsZh._(_root);
	@override String get speechNotRecognized => '未识别到语音，请重试';
	@override String get currentExpense => '当前支出';
	@override String get loadingComponent => '正在加载组件...';
	@override String get noHistory => '暂无历史会话';
	@override String get startNewChat => '开启一段新对话吧！';
	@override String get searchHint => '搜索会话';
	@override String get library => '库';
	@override String get viewProfile => '查看个人资料';
	@override String get noRelatedFound => '未找到相关会话';
	@override String get tryOtherKeywords => '尝试搜索其他关键词';
	@override String get searchFailed => '搜索失败';
	@override String get deleteConversation => '删除会话';
	@override String get deleteConversationConfirm => '确定要删除这个会话吗？此操作无法撤销。';
	@override String get conversationDeleted => '会话已删除';
	@override String get deleteConversationFailed => '删除会话失败';
	@override late final _TranslationsChatTransferWizardZh transferWizard = _TranslationsChatTransferWizardZh._(_root);
	@override late final _TranslationsChatGenuiZh genui = _TranslationsChatGenuiZh._(_root);
	@override late final _TranslationsChatWelcomeZh welcome = _TranslationsChatWelcomeZh._(_root);
}

// Path: footprint
class _TranslationsFootprintZh implements TranslationsFootprintEn {
	_TranslationsFootprintZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get searchIn => '搜索';
	@override String get searchInAllRecords => '在所有记录中搜索相关内容';
}

// Path: media
class _TranslationsMediaZh implements TranslationsMediaEn {
	_TranslationsMediaZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get selectPhotos => '选择照片';
	@override String get addFiles => '添加文件';
	@override String get takePhoto => '拍照';
	@override String get camera => '相机';
	@override String get photos => '照片';
	@override String get files => '文件';
	@override String get showAll => '显示全部';
	@override String get allPhotos => '所有照片';
	@override String get takingPhoto => '拍照中...';
	@override String get photoTaken => '照片已保存';
	@override String get cameraPermissionRequired => '需要相机权限';
	@override String get fileSizeExceeded => '文件大小超过10MB限制';
	@override String get unsupportedFormat => '不支持的文件格式';
	@override String get permissionDenied => '需要相册访问权限';
	@override String get storageInsufficient => '存储空间不足';
	@override String get networkError => '网络连接错误';
	@override String get unknownUploadError => '上传时发生未知错误';
}

// Path: error
class _TranslationsErrorZh implements TranslationsErrorEn {
	_TranslationsErrorZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get permissionRequired => '需要权限';
	@override String get permissionInstructions => '请在设置中开启相册和存储权限，以便选择和上传文件。';
	@override String get openSettings => '打开设置';
	@override String get fileTooLarge => '文件过大';
	@override String get fileSizeHint => '请选择小于10MB的文件，或者压缩后再上传。';
	@override String get supportedFormatsHint => '支持的格式包括：图片(jpg, png, gif等)、文档(pdf, doc, txt等)、音视频文件等。';
	@override String get storageCleanupHint => '请清理设备存储空间后重试，或选择较小的文件。';
	@override String get networkErrorHint => '请检查网络连接是否正常，然后重试。';
	@override String get platformNotSupported => '平台不支持';
	@override String get fileReadError => '文件读取失败';
	@override String get fileReadErrorHint => '文件可能已损坏或被其他程序占用，请重新选择文件。';
	@override String get validationError => '文件验证失败';
	@override String get unknownError => '未知错误';
	@override String get unknownErrorHint => '发生了意外错误，请重试或联系技术支持。';
	@override late final _TranslationsErrorGenuiZh genui = _TranslationsErrorGenuiZh._(_root);
}

// Path: fontTest
class _TranslationsFontTestZh implements TranslationsFontTestEn {
	_TranslationsFontTestZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get page => '字体测试页面';
	@override String get displayTest => '字体显示测试';
	@override String get chineseTextTest => '中文文本测试';
	@override String get englishTextTest => '英文文本测试';
	@override String get sample1 => '这是一段中文文本，用于测试字体显示效果。';
	@override String get sample2 => '支出分类汇总，购物最高';
	@override String get sample3 => '人工智能助手为您提供专业的财务分析服务';
	@override String get sample4 => '数据可视化图表展示您的消费趋势';
	@override String get sample5 => '微信支付、支付宝、银行卡等多种支付方式';
}

// Path: wizard
class _TranslationsWizardZh implements TranslationsWizardEn {
	_TranslationsWizardZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get nextStep => '下一步';
	@override String get previousStep => '上一步';
	@override String get completeMapping => '完成绘制';
}

// Path: user
class _TranslationsUserZh implements TranslationsUserEn {
	_TranslationsUserZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get username => '用户名';
	@override String get defaultEmail => 'user@example.com';
}

// Path: account
class _TranslationsAccountZh implements TranslationsAccountEn {
	_TranslationsAccountZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get editTitle => '编辑账户';
	@override String get addTitle => '新建账户';
	@override String get selectTypeTitle => '选择账户类型';
	@override String get nameLabel => '账户名称';
	@override String get amountLabel => '当前余额';
	@override String get currencyLabel => '币种';
	@override String get hiddenLabel => '隐藏';
	@override String get hiddenDesc => '在账户列表中隐藏该账户';
	@override String get includeInNetWorthLabel => '计入资产';
	@override String get includeInNetWorthDesc => '用于净资产统计';
	@override String get nameHint => '例如：工资卡';
	@override String get amountHint => '0.00';
	@override String get deleteAccount => '删除账户';
	@override String get deleteConfirm => '确定要删除该账户吗？此操作无法撤销。';
	@override String get save => '保存修改';
	@override String get assetsCategory => '资产类';
	@override String get liabilitiesCategory => '负债/信用类';
	@override String get cash => '现金钱包';
	@override String get deposit => '银行存款';
	@override String get creditCard => '信用卡';
	@override String get investment => '投资理财';
	@override String get eWallet => '电子钱包';
	@override String get loan => '贷款账户';
	@override String get receivable => '应收款项';
	@override String get payable => '应付款项';
	@override String get other => '其他账户';
	@override late final _TranslationsAccountTypesZh types = _TranslationsAccountTypesZh._(_root);
}

// Path: financial
class _TranslationsFinancialZh implements TranslationsFinancialEn {
	_TranslationsFinancialZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '财务';
	@override String get management => '财务管理';
	@override String get netWorth => '总净值';
	@override String get assets => '总资产';
	@override String get liabilities => '总负债';
	@override String get noAccounts => '暂无账户';
	@override String get addFirstAccount => '点击下方按钮添加您的第一个账户';
	@override String get assetAccounts => '资产账户';
	@override String get liabilityAccounts => '负债账户';
	@override String get selectCurrency => '选择货币';
	@override String get cancel => '取消';
	@override String get confirm => '确定';
	@override String get settings => '财务设置';
	@override String get budgetManagement => '预算管理';
	@override String get recurringTransactions => '周期交易';
	@override String get safetyThreshold => '安全阈值';
	@override String get dailyBurnRate => '每日消费';
	@override String get financialAssistant => '财务助手';
	@override String get manageFinancialSettings => '管理您的财务设置';
	@override String get safetyThresholdSettings => '财务安全线设置';
	@override String get setSafetyThreshold => '设置您的财务安全阈值';
	@override String get safetyThresholdSaved => '财务安全线已保存';
	@override String get dailyBurnRateSettings => '日常消费预估';
	@override String get setDailyBurnRate => '设置您的日常消费预估金额';
	@override String get dailyBurnRateSaved => '日常消费预估已保存';
	@override String get saveFailed => '保存失败';
}

// Path: app
class _TranslationsAppZh implements TranslationsAppEn {
	_TranslationsAppZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get splashTitle => '智见增长，格物致富。';
	@override String get splashSubtitle => '智能财务助手';
}

// Path: statistics
class _TranslationsStatisticsZh implements TranslationsStatisticsEn {
	_TranslationsStatisticsZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '统计分析';
	@override String get analyze => '统计分析';
	@override String get exportInProgress => '导出功能开发中...';
	@override String get ranking => '大额消费排行';
	@override String get noData => '暂无数据';
	@override late final _TranslationsStatisticsOverviewZh overview = _TranslationsStatisticsOverviewZh._(_root);
	@override late final _TranslationsStatisticsTrendZh trend = _TranslationsStatisticsTrendZh._(_root);
	@override late final _TranslationsStatisticsAnalysisZh analysis = _TranslationsStatisticsAnalysisZh._(_root);
	@override late final _TranslationsStatisticsFilterZh filter = _TranslationsStatisticsFilterZh._(_root);
	@override late final _TranslationsStatisticsSortZh sort = _TranslationsStatisticsSortZh._(_root);
	@override String get exportList => '导出列表';
	@override late final _TranslationsStatisticsEmptyStateZh emptyState = _TranslationsStatisticsEmptyStateZh._(_root);
	@override String get noMoreData => '没有更多数据了';
}

// Path: currency
class _TranslationsCurrencyZh implements TranslationsCurrencyEn {
	_TranslationsCurrencyZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get cny => '人民币';
	@override String get usd => '美元';
	@override String get eur => '欧元';
	@override String get jpy => '日元';
	@override String get gbp => '英镑';
	@override String get aud => '澳元';
	@override String get cad => '加元';
	@override String get chf => '瑞士法郎';
	@override String get rub => '俄罗斯卢布';
	@override String get hkd => '港币';
	@override String get twd => '新台币';
	@override String get inr => '印度卢比';
}

// Path: budgetSuggestion
class _TranslationsBudgetSuggestionZh implements TranslationsBudgetSuggestionEn {
	_TranslationsBudgetSuggestionZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String highPercentage({required Object category, required Object percentage}) => '${category} 占支出的 ${percentage}%，建议设置预算上限';
	@override String monthlyIncrease({required Object percentage}) => '本月支出增长了 ${percentage}%，需要关注';
	@override String frequentSmall({required Object category, required Object count}) => '${category} 有 ${count} 笔小额交易，可能是订阅消费';
	@override String get financialInsights => '财务洞察';
}

// Path: server
class _TranslationsServerZh implements TranslationsServerEn {
	_TranslationsServerZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '连接服务器';
	@override String get subtitle => '输入您自部署的服务器地址，或扫描服务器启动时显示的二维码';
	@override String get urlLabel => '服务器地址';
	@override String get urlPlaceholder => '例如：https://api.example.com 或 192.168.1.100:8000';
	@override String get scanQr => '扫描二维码';
	@override String get scanQrInstruction => '对准服务器终端显示的二维码';
	@override String get testConnection => '测试连接';
	@override String get connecting => '正在连接...';
	@override String get connected => '已连接';
	@override String get connectionFailed => '连接失败';
	@override String get continueToLogin => '继续登录';
	@override String get saveAndReturn => '保存并返回';
	@override String get serverSettings => '服务器设置';
	@override String get currentServer => '当前服务器';
	@override String get version => '版本';
	@override String get environment => '环境';
	@override String get changeServer => '更换服务器';
	@override String get changeServerWarning => '更换服务器将退出登录，是否继续？';
	@override late final _TranslationsServerErrorZh error = _TranslationsServerErrorZh._(_root);
}

// Path: sharedSpace
class _TranslationsSharedSpaceZh implements TranslationsSharedSpaceEn {
	_TranslationsSharedSpaceZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSharedSpaceDashboardZh dashboard = _TranslationsSharedSpaceDashboardZh._(_root);
	@override late final _TranslationsSharedSpaceRolesZh roles = _TranslationsSharedSpaceRolesZh._(_root);
}

// Path: errorMapping
class _TranslationsErrorMappingZh implements TranslationsErrorMappingEn {
	_TranslationsErrorMappingZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsErrorMappingGenericZh generic = _TranslationsErrorMappingGenericZh._(_root);
	@override late final _TranslationsErrorMappingAuthZh auth = _TranslationsErrorMappingAuthZh._(_root);
	@override late final _TranslationsErrorMappingTransactionZh transaction = _TranslationsErrorMappingTransactionZh._(_root);
	@override late final _TranslationsErrorMappingSpaceZh space = _TranslationsErrorMappingSpaceZh._(_root);
	@override late final _TranslationsErrorMappingRecurringZh recurring = _TranslationsErrorMappingRecurringZh._(_root);
	@override late final _TranslationsErrorMappingUploadZh upload = _TranslationsErrorMappingUploadZh._(_root);
	@override late final _TranslationsErrorMappingAiZh ai = _TranslationsErrorMappingAiZh._(_root);
}

// Path: auth.email
class _TranslationsAuthEmailZh implements TranslationsAuthEmailEn {
	_TranslationsAuthEmailZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get label => '邮箱';
	@override String get placeholder => '请输入您的邮箱';
	@override String get required => '邮箱不能为空';
	@override String get invalid => '请输入有效的邮箱地址';
}

// Path: auth.password
class _TranslationsAuthPasswordZh implements TranslationsAuthPasswordEn {
	_TranslationsAuthPasswordZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get label => '密码';
	@override String get placeholder => '请输入您的密码';
	@override String get required => '密码不能为空';
	@override String get tooShort => '密码长度不能少于6位';
	@override String get mustContainNumbersAndLetters => '密码必须包含数字和字母';
	@override String get confirm => '确认密码';
	@override String get confirmPlaceholder => '请再次输入您的密码';
	@override String get mismatch => '两次输入的密码不一致';
}

// Path: auth.verificationCode
class _TranslationsAuthVerificationCodeZh implements TranslationsAuthVerificationCodeEn {
	_TranslationsAuthVerificationCodeZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get label => '验证码';
	@override String get get => '获取验证码';
	@override String get sending => '发送中...';
	@override String get sent => '验证码已发送';
	@override String get sendFailed => '发送失败';
	@override String get placeholder => '暂不校验，随意输入';
	@override String get required => '验证码不能为空';
}

// Path: calendar.weekdays
class _TranslationsCalendarWeekdaysZh implements TranslationsCalendarWeekdaysEn {
	_TranslationsCalendarWeekdaysZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get mon => '一';
	@override String get tue => '二';
	@override String get wed => '三';
	@override String get thu => '四';
	@override String get fri => '五';
	@override String get sat => '六';
	@override String get sun => '日';
}

// Path: appearance.palettes
class _TranslationsAppearancePalettesZh implements TranslationsAppearancePalettesEn {
	_TranslationsAppearancePalettesZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get zinc => '锌灰';
	@override String get slate => '板岩';
	@override String get red => '绯红';
	@override String get rose => '玫瑰';
	@override String get orange => '橙色';
	@override String get green => '绿色';
	@override String get blue => '蓝色';
	@override String get yellow => '黄色';
	@override String get violet => '紫罗兰';
}

// Path: forecast.recurringTransaction
class _TranslationsForecastRecurringTransactionZh implements TranslationsForecastRecurringTransactionEn {
	_TranslationsForecastRecurringTransactionZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '周期交易';
	@override String get all => '全部';
	@override String get expense => '支出';
	@override String get income => '收入';
	@override String get transfer => '转账';
	@override String get noRecurring => '暂无周期交易';
	@override String get createHint => '创建周期交易后，系统将自动为您生成交易记录';
	@override String get create => '创建周期交易';
	@override String get edit => '编辑周期交易';
	@override String get newTransaction => '新建周期交易';
	@override String deleteConfirm({required Object name}) => '确定要删除周期交易「${name}」吗？此操作不可撤销。';
	@override String activateConfirm({required Object name}) => '确定要启用周期交易「${name}」吗？启用后将按照设定的规则自动生成交易记录。';
	@override String pauseConfirm({required Object name}) => '确定要暂停周期交易「${name}」吗？暂停后将不再自动生成交易记录。';
	@override String get created => '周期交易已创建';
	@override String get updated => '周期交易已更新';
	@override String get activated => '已启用';
	@override String get paused => '已暂停';
	@override String get nextTime => '下次';
	@override String get sortByTime => '按时间排序';
	@override String get allPeriod => '全部周期';
	@override String periodCount({required Object type, required Object count}) => '${type}周期 (${count})';
	@override String get confirmDelete => '确认删除';
	@override String get confirmActivate => '确认启用';
	@override String get confirmPause => '确认暂停';
	@override String get dynamicAmount => '动态均值';
	@override String get dynamicAmountTitle => '金额需手动确认';
	@override String get dynamicAmountDescription => '系统将在账单日发送提醒，需要您手动确认具体金额后才会记账。';
}

// Path: chat.tools
class _TranslationsChatToolsZh implements TranslationsChatToolsEn {
	_TranslationsChatToolsZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get processing => '正在处理...';
	@override String get read_file => '正在查看文件...';
	@override String get search_transactions => '正在查询交易...';
	@override String get query_budget_status => '正在检查预算...';
	@override String get create_budget => '正在创建预算计划...';
	@override String get get_cash_flow_analysis => '正在分析现金流...';
	@override String get get_financial_health_score => '正在计算财务健康分...';
	@override String get get_financial_summary => '正在生成财务报告...';
	@override String get evaluate_financial_health => '正在评估财务健康...';
	@override String get forecast_balance => '正在预测未来余额...';
	@override String get simulate_expense_impact => '正在模拟购买影响...';
	@override String get record_transactions => '正在记账...';
	@override String get create_transaction => '正在记账...';
	@override String get duckduckgo_search => '正在搜索网络...';
	@override String get execute_transfer => '正在执行转账...';
	@override String get list_dir => '正在浏览目录...';
	@override String get execute => '正在执行脚本...';
	@override String get analyze_finance => '正在分析财务状况...';
	@override String get forecast_finance => '正在预测财务趋势...';
	@override String get analyze_budget => '正在分析预算...';
	@override String get audit_analysis => '正在审计分析...';
	@override String get budget_ops => '正在处理预算...';
	@override String get create_shared_transaction => '正在创建共享账单...';
	@override String get list_spaces => '正在获取共享空间...';
	@override String get query_space_summary => '正在查询空间摘要...';
	@override String get prepare_transfer => '正在准备转账...';
	@override String get unknown => '正在处理请求...';
	@override late final _TranslationsChatToolsDoneZh done = _TranslationsChatToolsDoneZh._(_root);
	@override late final _TranslationsChatToolsFailedZh failed = _TranslationsChatToolsFailedZh._(_root);
	@override String get cancelled => '已取消';
}

// Path: chat.transferWizard
class _TranslationsChatTransferWizardZh implements TranslationsChatTransferWizardEn {
	_TranslationsChatTransferWizardZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '转账向导';
	@override String get amount => '转账金额';
	@override String get amountHint => '请输入金额';
	@override String get sourceAccount => '转出账户';
	@override String get targetAccount => '转入账户';
	@override String get selectAccount => '请选择账户';
	@override String get selectReceiveAccount => '选择收款账户';
	@override String get confirmTransfer => '确认转账';
	@override String get confirmed => '已确认';
	@override String get transferSuccess => '转账成功';
}

// Path: chat.genui
class _TranslationsChatGenuiZh implements TranslationsChatGenuiEn {
	_TranslationsChatGenuiZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsChatGenuiExpenseSummaryZh expenseSummary = _TranslationsChatGenuiExpenseSummaryZh._(_root);
	@override late final _TranslationsChatGenuiTransactionListZh transactionList = _TranslationsChatGenuiTransactionListZh._(_root);
	@override late final _TranslationsChatGenuiTransactionGroupReceiptZh transactionGroupReceipt = _TranslationsChatGenuiTransactionGroupReceiptZh._(_root);
	@override late final _TranslationsChatGenuiBudgetReceiptZh budgetReceipt = _TranslationsChatGenuiBudgetReceiptZh._(_root);
	@override late final _TranslationsChatGenuiBudgetStatusCardZh budgetStatusCard = _TranslationsChatGenuiBudgetStatusCardZh._(_root);
	@override late final _TranslationsChatGenuiCashFlowForecastZh cashFlowForecast = _TranslationsChatGenuiCashFlowForecastZh._(_root);
	@override late final _TranslationsChatGenuiHealthScoreZh healthScore = _TranslationsChatGenuiHealthScoreZh._(_root);
	@override late final _TranslationsChatGenuiSpaceSelectorZh spaceSelector = _TranslationsChatGenuiSpaceSelectorZh._(_root);
	@override late final _TranslationsChatGenuiTransferPathZh transferPath = _TranslationsChatGenuiTransferPathZh._(_root);
	@override late final _TranslationsChatGenuiTransactionCardZh transactionCard = _TranslationsChatGenuiTransactionCardZh._(_root);
	@override late final _TranslationsChatGenuiTransactionConfirmationZh transactionConfirmation = _TranslationsChatGenuiTransactionConfirmationZh._(_root);
	@override late final _TranslationsChatGenuiBudgetAnalysisZh budgetAnalysis = _TranslationsChatGenuiBudgetAnalysisZh._(_root);
	@override late final _TranslationsChatGenuiCashFlowCardZh cashFlowCard = _TranslationsChatGenuiCashFlowCardZh._(_root);
}

// Path: chat.welcome
class _TranslationsChatWelcomeZh implements TranslationsChatWelcomeEn {
	_TranslationsChatWelcomeZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsChatWelcomeMorningZh morning = _TranslationsChatWelcomeMorningZh._(_root);
	@override late final _TranslationsChatWelcomeMiddayZh midday = _TranslationsChatWelcomeMiddayZh._(_root);
	@override late final _TranslationsChatWelcomeAfternoonZh afternoon = _TranslationsChatWelcomeAfternoonZh._(_root);
	@override late final _TranslationsChatWelcomeEveningZh evening = _TranslationsChatWelcomeEveningZh._(_root);
	@override late final _TranslationsChatWelcomeNightZh night = _TranslationsChatWelcomeNightZh._(_root);
}

// Path: error.genui
class _TranslationsErrorGenuiZh implements TranslationsErrorGenuiEn {
	_TranslationsErrorGenuiZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get loadingFailed => '组件加载失败';
	@override String get schemaFailed => '架构验证失败';
	@override String get schemaDescription => '组件定义不符合 GenUI 规范，降级为纯文本显示';
	@override String get networkError => '网络错误';
	@override String retryStatus({required Object retryCount, required Object maxRetries}) => '已重试 ${retryCount}/${maxRetries} 次';
	@override String get maxRetriesReached => '已达最大重试次数';
}

// Path: account.types
class _TranslationsAccountTypesZh implements TranslationsAccountTypesEn {
	_TranslationsAccountTypesZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get cashTitle => '现金';
	@override String get cashSubtitle => '纸币、硬币等实体货币';
	@override String get depositTitle => '银行存款';
	@override String get depositSubtitle => '储蓄卡、活期/定期存款';
	@override String get eMoneyTitle => '电子钱包';
	@override String get eMoneySubtitle => '第三方支付平台余额';
	@override String get investmentTitle => '投资账户';
	@override String get investmentSubtitle => '股票、基金、债券等';
	@override String get receivableTitle => '应收款项';
	@override String get receivableSubtitle => '借出款项、待收账款';
	@override String get receivableHelper => '他人欠我';
	@override String get creditCardTitle => '信用卡';
	@override String get creditCardSubtitle => '信用卡账户欠款';
	@override String get loanTitle => '贷款';
	@override String get loanSubtitle => '房贷、车贷、消费贷等';
	@override String get payableTitle => '应付款项';
	@override String get payableSubtitle => '借入款项、待付账款';
	@override String get payableHelper => '我欠他人';
}

// Path: statistics.overview
class _TranslationsStatisticsOverviewZh implements TranslationsStatisticsOverviewEn {
	_TranslationsStatisticsOverviewZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get balance => '总结余';
	@override String get income => '总收入';
	@override String get expense => '总支出';
}

// Path: statistics.trend
class _TranslationsStatisticsTrendZh implements TranslationsStatisticsTrendEn {
	_TranslationsStatisticsTrendZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '收支趋势';
	@override String get expense => '支出';
	@override String get income => '收入';
}

// Path: statistics.analysis
class _TranslationsStatisticsAnalysisZh implements TranslationsStatisticsAnalysisEn {
	_TranslationsStatisticsAnalysisZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '支出分析';
	@override String get total => '总计';
	@override String get breakdown => '支出分类明细';
}

// Path: statistics.filter
class _TranslationsStatisticsFilterZh implements TranslationsStatisticsFilterEn {
	_TranslationsStatisticsFilterZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get accountType => '账户类型';
	@override String get allAccounts => '全部账户';
	@override String get apply => '确认应用';
}

// Path: statistics.sort
class _TranslationsStatisticsSortZh implements TranslationsStatisticsSortEn {
	_TranslationsStatisticsSortZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get amount => '按金额排序';
	@override String get date => '按时间排序';
}

// Path: statistics.emptyState
class _TranslationsStatisticsEmptyStateZh implements TranslationsStatisticsEmptyStateEn {
	_TranslationsStatisticsEmptyStateZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '开启财务洞察';
	@override String get description => '您的财务报表目前是一张白纸。\n记录第一笔消费，让数据为您讲述财富故事。';
	@override String get action => '记录首笔交易';
}

// Path: server.error
class _TranslationsServerErrorZh implements TranslationsServerErrorEn {
	_TranslationsServerErrorZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get urlRequired => '请输入服务器地址';
	@override String get invalidUrl => 'URL 格式无效';
	@override String get connectionTimeout => '连接超时';
	@override String get connectionRefused => '无法连接到服务器';
	@override String get sslError => 'SSL 证书错误';
	@override String get serverError => '服务器错误';
}

// Path: sharedSpace.dashboard
class _TranslationsSharedSpaceDashboardZh implements TranslationsSharedSpaceDashboardEn {
	_TranslationsSharedSpaceDashboardZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get cumulativeTotalExpense => '累计总支出';
	@override String get participatingMembers => '参与成员';
	@override String membersCount({required Object count}) => '${count} 人';
	@override String get averagePerMember => '成员人均';
	@override String get spendingDistribution => '成员消费分布';
	@override String get realtimeUpdates => '实时更新';
	@override String get paid => '已支付';
}

// Path: sharedSpace.roles
class _TranslationsSharedSpaceRolesZh implements TranslationsSharedSpaceRolesEn {
	_TranslationsSharedSpaceRolesZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get owner => '主理人';
	@override String get admin => '管理员';
	@override String get member => '成员';
}

// Path: errorMapping.generic
class _TranslationsErrorMappingGenericZh implements TranslationsErrorMappingGenericEn {
	_TranslationsErrorMappingGenericZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get badRequest => '请求无效';
	@override String get authFailed => '认证失败，请重新登录';
	@override String get permissionDenied => '权限不足';
	@override String get notFound => '资源未找到';
	@override String get serverError => '服务器内部错误';
	@override String get systemError => '系统错误';
	@override String get validationFailed => '数据验证失败';
}

// Path: errorMapping.auth
class _TranslationsErrorMappingAuthZh implements TranslationsErrorMappingAuthEn {
	_TranslationsErrorMappingAuthZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get failed => '认证失败';
	@override String get emailWrong => '邮箱错误';
	@override String get phoneWrong => '手机号错误';
	@override String get phoneRegistered => '该手机号已被注册';
	@override String get emailRegistered => '该邮箱已被注册';
	@override String get sendFailed => '验证码发送失败';
	@override String get expired => '验证码已过期';
	@override String get tooFrequent => '验证码发送太频繁';
	@override String get unsupportedType => '不支持的验证码类型';
	@override String get wrongPassword => '密码错误';
	@override String get userNotFound => '用户不存在';
	@override String get prefsMissing => '偏好设置参数缺失';
	@override String get invalidTimezone => '无效的客户端时区';
}

// Path: errorMapping.transaction
class _TranslationsErrorMappingTransactionZh implements TranslationsErrorMappingTransactionEn {
	_TranslationsErrorMappingTransactionZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get commentEmpty => '评论内容不能为空';
	@override String get invalidParent => '无效的父评论ID';
	@override String get saveFailed => '评论保存失败';
	@override String get deleteFailed => '评论删除失败';
	@override String get notExists => '交易记录不存在';
}

// Path: errorMapping.space
class _TranslationsErrorMappingSpaceZh implements TranslationsErrorMappingSpaceEn {
	_TranslationsErrorMappingSpaceZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get notFound => '共享空间不存在或无权访问';
	@override String get inviteDenied => '无权邀请成员';
	@override String get inviteSelf => '不能邀请你自己';
	@override String get inviteSent => '邀请已发送';
	@override String get alreadyMember => '该用户已是成员或已被邀请';
	@override String get invalidAction => '无效操作';
	@override String get invitationNotFound => '邀请不存在';
	@override String get onlyOwner => '仅拥有者可执行此操作';
	@override String get ownerNotRemovable => '不能移除空间拥有者';
	@override String get memberNotFound => '成员不存在';
	@override String get notMember => '该用户不是此空间的成员';
	@override String get ownerCantLeave => '拥有者不能直接退出，请先转让所有权';
	@override String get invalidCode => '无效的邀请码';
	@override String get codeExpired => '邀请码已过期或达到上限';
}

// Path: errorMapping.recurring
class _TranslationsErrorMappingRecurringZh implements TranslationsErrorMappingRecurringEn {
	_TranslationsErrorMappingRecurringZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get invalidRule => '无效的重复规则';
	@override String get ruleNotFound => '未找到重复规则';
}

// Path: errorMapping.upload
class _TranslationsErrorMappingUploadZh implements TranslationsErrorMappingUploadEn {
	_TranslationsErrorMappingUploadZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get noFile => '未上传文件';
	@override String get tooLarge => '文件过大';
	@override String get unsupportedType => '不支持的文件类型';
	@override String get tooManyFiles => '文件数量过多';
}

// Path: errorMapping.ai
class _TranslationsErrorMappingAiZh implements TranslationsErrorMappingAiEn {
	_TranslationsErrorMappingAiZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get contextLimit => '上下文长度超出限制';
	@override String get tokenLimit => 'Token配额不足';
	@override String get emptyMessage => '用户消息为空';
}

// Path: chat.tools.done
class _TranslationsChatToolsDoneZh implements TranslationsChatToolsDoneEn {
	_TranslationsChatToolsDoneZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get read_file => '已查看文件';
	@override String get search_transactions => '已查询交易';
	@override String get query_budget_status => '已检查预算';
	@override String get create_budget => '已创建预算';
	@override String get get_cash_flow_analysis => '已分析现金流';
	@override String get get_financial_health_score => '已计算健康分';
	@override String get get_financial_summary => '财务报告生成完成';
	@override String get evaluate_financial_health => '财务健康评估完成';
	@override String get forecast_balance => '余额预测完成';
	@override String get simulate_expense_impact => '购买影响模拟完成';
	@override String get record_transactions => '记账完成';
	@override String get create_transaction => '已完成记账';
	@override String get duckduckgo_search => '已搜索网络';
	@override String get execute_transfer => '转账完成';
	@override String get list_dir => '已浏览目录';
	@override String get execute => '脚本执行完成';
	@override String get analyze_finance => '财务分析完成';
	@override String get forecast_finance => '财务预测完成';
	@override String get analyze_budget => '预算分析完成';
	@override String get audit_analysis => '审计分析完成';
	@override String get budget_ops => '预算处理完成';
	@override String get create_shared_transaction => '共享账单创建完成';
	@override String get list_spaces => '共享空间获取完成';
	@override String get query_space_summary => '空间摘要查询完成';
	@override String get prepare_transfer => '转账准备完成';
	@override String get unknown => '处理完成';
}

// Path: chat.tools.failed
class _TranslationsChatToolsFailedZh implements TranslationsChatToolsFailedEn {
	_TranslationsChatToolsFailedZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get unknown => '操作失败';
}

// Path: chat.genui.expenseSummary
class _TranslationsChatGenuiExpenseSummaryZh implements TranslationsChatGenuiExpenseSummaryEn {
	_TranslationsChatGenuiExpenseSummaryZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get totalExpense => '总支出';
	@override String get mainExpenses => '主要支出';
	@override String viewAll({required Object count}) => '查看全部 ${count} 笔消费';
	@override String get details => '消费明细';
}

// Path: chat.genui.transactionList
class _TranslationsChatGenuiTransactionListZh implements TranslationsChatGenuiTransactionListEn {
	_TranslationsChatGenuiTransactionListZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String searchResults({required Object count}) => '搜索结果 (${count})';
	@override String loaded({required Object count}) => '已加载 ${count}';
	@override String get noResults => '未找到相关交易';
	@override String get loadMore => '滚动加载更多';
	@override String get allLoaded => '全部加载完成';
}

// Path: chat.genui.transactionGroupReceipt
class _TranslationsChatGenuiTransactionGroupReceiptZh implements TranslationsChatGenuiTransactionGroupReceiptEn {
	_TranslationsChatGenuiTransactionGroupReceiptZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '交易成功';
	@override String count({required Object count}) => '${count}笔';
	@override String get total => '共计';
	@override String get selectAccount => '选择关联账户';
	@override String get selectAccountSubtitle => '此账户将应用到以上所有笔交易';
	@override String associatedAccount({required Object name}) => '已关联账户：${name}';
	@override String get clickToAssociate => '点击关联账户（支持批量操作）';
	@override String get associateSuccess => '已成功为所有交易关联账户';
	@override String associateFailed({required Object error}) => '操作失败: ${error}';
	@override String get accountAssociation => '账户关联';
	@override String get sharedSpace => '共享空间';
	@override String get notAssociated => '未关联';
	@override String get addSpace => '添加';
	@override String get selectSpace => '选择共享空间';
	@override String get spaceAssociateSuccess => '已关联到共享空间';
	@override String spaceAssociateFailed({required Object error}) => '关联共享空间失败: ${error}';
	@override String get currencyMismatchTitle => '币种不一致';
	@override String get currencyMismatchDesc => '交易币种与账户币种不同，系统将按当时汇率换算后扣减账户余额。';
	@override String get transactionAmount => '交易金额';
	@override String get accountCurrency => '账户币种';
	@override String get targetAccount => '目标账户';
	@override String get currencyMismatchNote => '提示：账户余额将按当时汇率进行换算扣减';
	@override String get confirmAssociate => '确认关联';
	@override String spaceCount({required Object count}) => '${count} 空间';
}

// Path: chat.genui.budgetReceipt
class _TranslationsChatGenuiBudgetReceiptZh implements TranslationsChatGenuiBudgetReceiptEn {
	_TranslationsChatGenuiBudgetReceiptZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get newBudget => '新预算';
	@override String get budgetCreated => '预算已创建';
	@override String get rolloverBudget => '滚动预算';
	@override String get createFailed => '创建预算失败';
	@override String get thisMonth => '本月';
	@override String dateRange({required Object start, required Object startDay, required Object end, required Object endDay}) => '${start}月${startDay}日 - ${end}月${endDay}日';
}

// Path: chat.genui.budgetStatusCard
class _TranslationsChatGenuiBudgetStatusCardZh implements TranslationsChatGenuiBudgetStatusCardEn {
	_TranslationsChatGenuiBudgetStatusCardZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get budget => '预算';
	@override String get overview => '预算概览';
	@override String get totalBudget => '总预算';
	@override String spent({required Object amount}) => '已用 ¥${amount}';
	@override String remaining({required Object amount}) => '剩余 ¥${amount}';
	@override String get exceeded => '已超支';
	@override String get warning => '预算紧张';
	@override String get plentiful => '预算充裕';
	@override String get normal => '正常';
}

// Path: chat.genui.cashFlowForecast
class _TranslationsChatGenuiCashFlowForecastZh implements TranslationsChatGenuiCashFlowForecastEn {
	_TranslationsChatGenuiCashFlowForecastZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '现金流预测';
	@override String get recurringTransaction => '周期性交易';
	@override String get recurringIncome => '周期性收入';
	@override String get recurringExpense => '周期性支出';
	@override String get recurringTransfer => '周期性转账';
	@override String nextDays({required Object days}) => '未来 ${days} 天';
	@override String get noData => '暂无预测数据';
	@override String get summary => '预测摘要';
	@override String get variableExpense => '预测可变支出';
	@override String get netChange => '预计净变化';
	@override String get keyEvents => '关键事件';
	@override String get noSignificantEvents => '预测期内无重大事件';
	@override String get dateFormat => 'M月d日';
}

// Path: chat.genui.healthScore
class _TranslationsChatGenuiHealthScoreZh implements TranslationsChatGenuiHealthScoreEn {
	_TranslationsChatGenuiHealthScoreZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '财务健康';
	@override String get suggestions => '改进建议';
	@override String scorePoint({required Object score}) => '${score}分';
	@override late final _TranslationsChatGenuiHealthScoreStatusZh status = _TranslationsChatGenuiHealthScoreStatusZh._(_root);
}

// Path: chat.genui.spaceSelector
class _TranslationsChatGenuiSpaceSelectorZh implements TranslationsChatGenuiSpaceSelectorEn {
	_TranslationsChatGenuiSpaceSelectorZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get selected => '已选择';
	@override String get unnamedSpace => '未命名空间';
	@override String get linked => '已关联';
	@override String get roleOwner => '创建者';
	@override String get roleAdmin => '管理员';
	@override String get roleMember => '成员';
}

// Path: chat.genui.transferPath
class _TranslationsChatGenuiTransferPathZh implements TranslationsChatGenuiTransferPathEn {
	_TranslationsChatGenuiTransferPathZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get selectSource => '选择转出账户';
	@override String get selectTarget => '选择转入账户';
	@override String get from => '转出 (FROM)';
	@override String get to => '转入 (TO)';
	@override String get select => '请选择';
	@override String get cancelled => '操作已取消';
	@override String get loadError => '无法加载账户数据';
	@override String get historyMissing => '历史记录中缺少账户信息';
	@override String get amountUnconfirmed => '金额待确认';
	@override String confirmedWithArrow({required Object source, required Object target}) => '已确认：${source} → ${target}';
	@override String confirmAction({required Object source, required Object target}) => '确认：${source} → ${target}';
	@override String get pleaseSelectSource => '请先选择转出账户';
	@override String get pleaseSelectTarget => '请选择转入账户';
	@override String get confirmLinks => '确认转账链路';
	@override String get linkLocked => '链路已锁定';
	@override String get clickToConfirm => '点击下方按钮确认执行';
	@override String get reselect => '重选';
	@override String get title => '转账';
	@override String get history => '历史记录';
	@override String get unknownAccount => '未知账户';
	@override String get confirmed => '已确认';
}

// Path: chat.genui.transactionCard
class _TranslationsChatGenuiTransactionCardZh implements TranslationsChatGenuiTransactionCardEn {
	_TranslationsChatGenuiTransactionCardZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '交易成功';
	@override String get associatedAccount => '已关联账户';
	@override String get notCounted => '不计入资产';
	@override String get modify => '修改';
	@override String get associate => '关联账户';
	@override String get selectAccount => '选择关联账户';
	@override String get noAccount => '暂无可用账户，请先添加账户';
	@override String get missingId => '交易 ID 缺失，无法更新';
	@override String associatedTo({required Object name}) => '已关联到 ${name}';
	@override String updateFailed({required Object error}) => '更新失败: ${error}';
	@override String get sharedSpace => '共享空间';
	@override String get noSpace => '暂无可用共享空间';
	@override String get selectSpace => '选择共享空间';
	@override String get linkedToSpace => '已关联到共享空间';
}

// Path: chat.genui.transactionConfirmation
class _TranslationsChatGenuiTransactionConfirmationZh implements TranslationsChatGenuiTransactionConfirmationEn {
	_TranslationsChatGenuiTransactionConfirmationZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get multipleAccounts => '检测到多个关联账户';
	@override String get confirmed => '已确认';
}

// Path: chat.genui.budgetAnalysis
class _TranslationsChatGenuiBudgetAnalysisZh implements TranslationsChatGenuiBudgetAnalysisEn {
	_TranslationsChatGenuiBudgetAnalysisZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '预算分析报告';
	@override String periodDays({required Object days}) => '过去 ${days} 天';
	@override String get totalExpense => '总支出';
	@override String momChange({required Object change}) => '环比 ${change}%';
	@override String get categoryDistribution => '分类占比';
	@override String get topSpenders => '大额支出';
	@override String amountWan({required Object amount}) => '${amount}万';
}

// Path: chat.genui.cashFlowCard
class _TranslationsChatGenuiCashFlowCardZh implements TranslationsChatGenuiCashFlowCardEn {
	_TranslationsChatGenuiCashFlowCardZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '现金流分析';
	@override String savingsRate({required Object rate}) => '储蓄 ${rate}%';
	@override String get totalIncome => '总收入';
	@override String get totalExpense => '总支出';
	@override String get essentialExpense => '必要支出';
	@override String get discretionaryExpense => '可选消费';
	@override String get aiInsight => 'AI 分析';
}

// Path: chat.welcome.morning
class _TranslationsChatWelcomeMorningZh implements TranslationsChatWelcomeMorningEn {
	_TranslationsChatWelcomeMorningZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get subtitle => '新的一天，从记录开始';
	@override late final _TranslationsChatWelcomeMorningBreakfastZh breakfast = _TranslationsChatWelcomeMorningBreakfastZh._(_root);
	@override late final _TranslationsChatWelcomeMorningYesterdayReviewZh yesterdayReview = _TranslationsChatWelcomeMorningYesterdayReviewZh._(_root);
	@override late final _TranslationsChatWelcomeMorningTodayBudgetZh todayBudget = _TranslationsChatWelcomeMorningTodayBudgetZh._(_root);
}

// Path: chat.welcome.midday
class _TranslationsChatWelcomeMiddayZh implements TranslationsChatWelcomeMiddayEn {
	_TranslationsChatWelcomeMiddayZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get greeting => '中午好';
	@override String get subtitle => '午间时光，顺手记一笔';
	@override late final _TranslationsChatWelcomeMiddayLunchZh lunch = _TranslationsChatWelcomeMiddayLunchZh._(_root);
	@override late final _TranslationsChatWelcomeMiddayWeeklyExpenseZh weeklyExpense = _TranslationsChatWelcomeMiddayWeeklyExpenseZh._(_root);
	@override late final _TranslationsChatWelcomeMiddayCheckBalanceZh checkBalance = _TranslationsChatWelcomeMiddayCheckBalanceZh._(_root);
}

// Path: chat.welcome.afternoon
class _TranslationsChatWelcomeAfternoonZh implements TranslationsChatWelcomeAfternoonEn {
	_TranslationsChatWelcomeAfternoonZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get subtitle => '下午茶时间，理理财';
	@override late final _TranslationsChatWelcomeAfternoonQuickRecordZh quickRecord = _TranslationsChatWelcomeAfternoonQuickRecordZh._(_root);
	@override late final _TranslationsChatWelcomeAfternoonAnalyzeSpendingZh analyzeSpending = _TranslationsChatWelcomeAfternoonAnalyzeSpendingZh._(_root);
	@override late final _TranslationsChatWelcomeAfternoonBudgetProgressZh budgetProgress = _TranslationsChatWelcomeAfternoonBudgetProgressZh._(_root);
}

// Path: chat.welcome.evening
class _TranslationsChatWelcomeEveningZh implements TranslationsChatWelcomeEveningEn {
	_TranslationsChatWelcomeEveningZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get subtitle => '辛苦一天，来理理账';
	@override late final _TranslationsChatWelcomeEveningDinnerZh dinner = _TranslationsChatWelcomeEveningDinnerZh._(_root);
	@override late final _TranslationsChatWelcomeEveningTodaySummaryZh todaySummary = _TranslationsChatWelcomeEveningTodaySummaryZh._(_root);
	@override late final _TranslationsChatWelcomeEveningTomorrowPlanZh tomorrowPlan = _TranslationsChatWelcomeEveningTomorrowPlanZh._(_root);
}

// Path: chat.welcome.night
class _TranslationsChatWelcomeNightZh implements TranslationsChatWelcomeNightEn {
	_TranslationsChatWelcomeNightZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get greeting => '夜深了';
	@override String get subtitle => '静心理财，规划未来';
	@override late final _TranslationsChatWelcomeNightMakeupRecordZh makeupRecord = _TranslationsChatWelcomeNightMakeupRecordZh._(_root);
	@override late final _TranslationsChatWelcomeNightMonthlyReviewZh monthlyReview = _TranslationsChatWelcomeNightMonthlyReviewZh._(_root);
	@override late final _TranslationsChatWelcomeNightFinancialThinkingZh financialThinking = _TranslationsChatWelcomeNightFinancialThinkingZh._(_root);
}

// Path: chat.genui.healthScore.status
class _TranslationsChatGenuiHealthScoreStatusZh implements TranslationsChatGenuiHealthScoreStatusEn {
	_TranslationsChatGenuiHealthScoreStatusZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get excellent => '财务状况优秀';
	@override String get good => '财务状况良好';
	@override String get fair => '财务状况一般';
	@override String get needsImprovement => '财务状况需改善';
	@override String get poor => '财务状况较差';
}

// Path: chat.welcome.morning.breakfast
class _TranslationsChatWelcomeMorningBreakfastZh implements TranslationsChatWelcomeMorningBreakfastEn {
	_TranslationsChatWelcomeMorningBreakfastZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '早餐记账';
	@override String get prompt => '记一笔早餐';
	@override String get description => '快速记录今天的第一笔消费';
}

// Path: chat.welcome.morning.yesterdayReview
class _TranslationsChatWelcomeMorningYesterdayReviewZh implements TranslationsChatWelcomeMorningYesterdayReviewEn {
	_TranslationsChatWelcomeMorningYesterdayReviewZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '昨日回顾';
	@override String get prompt => '分析昨天的消费';
	@override String get description => '看看昨天花了多少钱';
}

// Path: chat.welcome.morning.todayBudget
class _TranslationsChatWelcomeMorningTodayBudgetZh implements TranslationsChatWelcomeMorningTodayBudgetEn {
	_TranslationsChatWelcomeMorningTodayBudgetZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '今日预算';
	@override String get prompt => '今天还剩多少预算';
	@override String get description => '规划一天的消费额度';
}

// Path: chat.welcome.midday.lunch
class _TranslationsChatWelcomeMiddayLunchZh implements TranslationsChatWelcomeMiddayLunchEn {
	_TranslationsChatWelcomeMiddayLunchZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '午餐记账';
	@override String get prompt => '记一笔午餐';
	@override String get description => '记录午餐开销';
}

// Path: chat.welcome.midday.weeklyExpense
class _TranslationsChatWelcomeMiddayWeeklyExpenseZh implements TranslationsChatWelcomeMiddayWeeklyExpenseEn {
	_TranslationsChatWelcomeMiddayWeeklyExpenseZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '本周消费';
	@override String get prompt => '分析本周消费';
	@override String get description => '了解本周花费情况';
}

// Path: chat.welcome.midday.checkBalance
class _TranslationsChatWelcomeMiddayCheckBalanceZh implements TranslationsChatWelcomeMiddayCheckBalanceEn {
	_TranslationsChatWelcomeMiddayCheckBalanceZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '查看余额';
	@override String get prompt => '查看账户余额';
	@override String get description => '看看各账户还剩多少';
}

// Path: chat.welcome.afternoon.quickRecord
class _TranslationsChatWelcomeAfternoonQuickRecordZh implements TranslationsChatWelcomeAfternoonQuickRecordEn {
	_TranslationsChatWelcomeAfternoonQuickRecordZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '随手记账';
	@override String get prompt => '帮我记一笔';
	@override String get description => '快速记录一笔消费';
}

// Path: chat.welcome.afternoon.analyzeSpending
class _TranslationsChatWelcomeAfternoonAnalyzeSpendingZh implements TranslationsChatWelcomeAfternoonAnalyzeSpendingEn {
	_TranslationsChatWelcomeAfternoonAnalyzeSpendingZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '分析消费';
	@override String get prompt => '分析本月消费';
	@override String get description => '查看消费趋势和构成';
}

// Path: chat.welcome.afternoon.budgetProgress
class _TranslationsChatWelcomeAfternoonBudgetProgressZh implements TranslationsChatWelcomeAfternoonBudgetProgressEn {
	_TranslationsChatWelcomeAfternoonBudgetProgressZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '财务健康';
	@override String get prompt => '评估我的财务健康';
	@override String get description => '收支平衡评分与建议';
}

// Path: chat.welcome.evening.dinner
class _TranslationsChatWelcomeEveningDinnerZh implements TranslationsChatWelcomeEveningDinnerEn {
	_TranslationsChatWelcomeEveningDinnerZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '晚餐记账';
	@override String get prompt => '记一笔晚餐';
	@override String get description => '记录今天的晚餐消费';
}

// Path: chat.welcome.evening.todaySummary
class _TranslationsChatWelcomeEveningTodaySummaryZh implements TranslationsChatWelcomeEveningTodaySummaryEn {
	_TranslationsChatWelcomeEveningTodaySummaryZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '今日总结';
	@override String get prompt => '总结今天的消费';
	@override String get description => '看看今天花了多少';
}

// Path: chat.welcome.evening.tomorrowPlan
class _TranslationsChatWelcomeEveningTomorrowPlanZh implements TranslationsChatWelcomeEveningTomorrowPlanEn {
	_TranslationsChatWelcomeEveningTomorrowPlanZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '明日计划';
	@override String get prompt => '明天有什么固定支出';
	@override String get description => '提前规划明天的消费';
}

// Path: chat.welcome.night.makeupRecord
class _TranslationsChatWelcomeNightMakeupRecordZh implements TranslationsChatWelcomeNightMakeupRecordEn {
	_TranslationsChatWelcomeNightMakeupRecordZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '补记今日';
	@override String get prompt => '帮我补记今天的消费';
	@override String get description => '把今天忘记的账补上';
}

// Path: chat.welcome.night.monthlyReview
class _TranslationsChatWelcomeNightMonthlyReviewZh implements TranslationsChatWelcomeNightMonthlyReviewEn {
	_TranslationsChatWelcomeNightMonthlyReviewZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '本月分析';
	@override String get prompt => '详细分析本月支出';
	@override String get description => '回顾这个月的钱花哪了';
}

// Path: chat.welcome.night.financialThinking
class _TranslationsChatWelcomeNightFinancialThinkingZh implements TranslationsChatWelcomeNightFinancialThinkingEn {
	_TranslationsChatWelcomeNightFinancialThinkingZh._(this._root);

	final TranslationsZh _root; // ignore: unused_field

	// Translations
	@override String get title => '未来预测';
	@override String get prompt => '预测未来 30 天余额';
	@override String get description => '看清未来的财务趋势';
}

/// The flat map containing all translations for locale <zh>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsZh {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.loading' => '加载中...',
			'common.error' => '错误',
			'common.retry' => '重试',
			'common.cancel' => '取消',
			'common.confirm' => '确认',
			'common.save' => '保存',
			'common.delete' => '删除',
			'common.edit' => '编辑',
			'common.add' => '添加',
			'common.search' => '搜索',
			'common.filter' => '筛选',
			'common.sort' => '排序',
			'common.refresh' => '刷新',
			'common.more' => '更多',
			'common.less' => '收起',
			'common.all' => '全部',
			'common.none' => '无',
			'common.ok' => '确定',
			'common.unknown' => '未知',
			'common.noData' => '暂无数据',
			'common.loadMore' => '加载更多',
			'common.noMore' => '没有更多了',
			'common.loadFailed' => '加载失败',
			'common.history' => '交易记录',
			'common.reset' => '重置',
			'time.today' => '今天',
			'time.yesterday' => '昨天',
			'time.dayBeforeYesterday' => '前天',
			'time.thisWeek' => '本周',
			'time.thisMonth' => '本月',
			'time.thisYear' => '今年',
			'time.selectDate' => '选择日期',
			'time.selectTime' => '选择时间',
			'time.justNow' => '刚刚',
			'time.minutesAgo' => ({required Object count}) => '${count}分钟前',
			'time.hoursAgo' => ({required Object count}) => '${count}小时前',
			'time.daysAgo' => ({required Object count}) => '${count}天前',
			'time.weeksAgo' => ({required Object count}) => '${count}周前',
			'greeting.morning' => '上午好',
			'greeting.afternoon' => '下午好',
			'greeting.evening' => '晚上好',
			'navigation.home' => '首页',
			'navigation.forecast' => '预测',
			'navigation.footprint' => '足迹',
			'navigation.profile' => '我的',
			'auth.login' => '登录',
			'auth.loggingIn' => '登录中...',
			'auth.logout' => '退出',
			'auth.logoutSuccess' => '已成功退出登录',
			'auth.confirmLogoutTitle' => '确认退出登录',
			'auth.confirmLogoutContent' => '您确定要退出当前的登录状态吗？',
			'auth.register' => '注册',
			'auth.registering' => '注册中...',
			'auth.welcomeBack' => '欢迎回来',
			'auth.loginSuccess' => '欢迎回来!',
			'auth.loginFailed' => '登录失败',
			'auth.pleaseTryAgain' => '请稍后重试。',
			'auth.loginSubtitle' => '登录以继续使用 AI 记账助理',
			'auth.noAccount' => '还没有账户？注册',
			'auth.createAccount' => '创建您的账户',
			'auth.setPassword' => '设置密码',
			'auth.setAccountPassword' => '设置您的账户密码',
			'auth.completeRegistration' => '完成注册',
			'auth.registrationSuccess' => '注册成功!',
			'auth.registrationFailed' => '注册失败',
			'auth.email.label' => '邮箱',
			'auth.email.placeholder' => '请输入您的邮箱',
			'auth.email.required' => '邮箱不能为空',
			'auth.email.invalid' => '请输入有效的邮箱地址',
			'auth.password.label' => '密码',
			'auth.password.placeholder' => '请输入您的密码',
			'auth.password.required' => '密码不能为空',
			'auth.password.tooShort' => '密码长度不能少于6位',
			'auth.password.mustContainNumbersAndLetters' => '密码必须包含数字和字母',
			'auth.password.confirm' => '确认密码',
			'auth.password.confirmPlaceholder' => '请再次输入您的密码',
			'auth.password.mismatch' => '两次输入的密码不一致',
			'auth.verificationCode.label' => '验证码',
			'auth.verificationCode.get' => '获取验证码',
			'auth.verificationCode.sending' => '发送中...',
			'auth.verificationCode.sent' => '验证码已发送',
			'auth.verificationCode.sendFailed' => '发送失败',
			'auth.verificationCode.placeholder' => '暂不校验，随意输入',
			'auth.verificationCode.required' => '验证码不能为空',
			'transaction.expense' => '支出',
			'transaction.income' => '收入',
			'transaction.transfer' => '转账',
			'transaction.amount' => '金额',
			'transaction.category' => '分类',
			'transaction.description' => '描述',
			'transaction.tags' => '标签',
			'transaction.saveTransaction' => '保存记账',
			'transaction.pleaseEnterAmount' => '请输入金额',
			'transaction.pleaseSelectCategory' => '请选择分类',
			'transaction.saveFailed' => '保存失败',
			'transaction.descriptionHint' => '记录这笔交易的详细信息...',
			'transaction.addCustomTag' => '添加自定义标签',
			'transaction.commonTags' => '常用标签',
			'transaction.maxTagsHint' => ({required Object maxTags}) => '最多添加 ${maxTags} 个标签',
			'transaction.noTransactionsFound' => '没有找到交易记录',
			'transaction.tryAdjustingSearch' => '尝试调整搜索条件或创建新的交易记录',
			'transaction.noDescription' => '无描述',
			'transaction.payment' => '支付',
			'transaction.account' => '账户',
			'transaction.time' => '时间',
			'transaction.location' => '地点',
			'transaction.transactionDetail' => '交易详情',
			'transaction.favorite' => '收藏',
			'transaction.confirmDelete' => '确认删除',
			'transaction.deleteTransactionConfirm' => '您确定要删除此条交易记录吗？此操作无法撤销。',
			'transaction.noActions' => '没有可用的操作',
			'transaction.deleted' => '已删除',
			'transaction.deleteFailed' => '删除失败，请稍后重试',
			'transaction.linkedAccount' => '关联账户',
			'transaction.linkedSpace' => '关联空间',
			'transaction.notLinked' => '未关联',
			'transaction.link' => '关联',
			'transaction.changeAccount' => '更换账户',
			'transaction.addSpace' => '添加空间',
			'transaction.nSpaces' => ({required Object count}) => '${count} 个空间',
			'transaction.selectLinkedAccount' => '选择关联账户',
			'transaction.selectLinkedSpace' => '选择关联空间',
			'transaction.noSpacesAvailable' => '暂无可用空间',
			'transaction.linkSuccess' => '关联成功',
			'transaction.linkFailed' => '关联失败',
			'transaction.rawInput' => '消息',
			'transaction.noRawInput' => '无消息',
			'home.totalExpense' => '总消费金额',
			'home.todayExpense' => '今日支出',
			'home.monthExpense' => '本月支出',
			'home.yearProgress' => ({required Object year}) => '${year}年进度',
			'home.amountHidden' => '••••••••',
			'home.loadFailed' => '加载失败',
			'home.noTransactions' => '暂无交易记录',
			'home.tryRefresh' => '刷新试试',
			'home.noMoreData' => '没有更多数据了',
			'home.userNotLoggedIn' => '用户未登录，无法加载数据',
			'comment.error' => '错误',
			'comment.commentFailed' => '评论失败',
			'comment.replyToPrefix' => ({required Object name}) => '回复 @${name}:',
			'comment.reply' => '回复',
			'comment.addNote' => '添加备注...',
			'comment.confirmDeleteTitle' => '确认删除',
			'comment.confirmDeleteContent' => '你确定要删除这条评论吗？此操作无法撤销。',
			'comment.success' => '成功',
			'comment.commentDeleted' => '评论已删除',
			'comment.deleteFailed' => '删除失败',
			'comment.deleteComment' => '删除评论',
			'comment.hint' => '提示',
			'comment.noActions' => '没有可用的操作',
			'comment.note' => '备注',
			'comment.noNote' => '暂无备注',
			'comment.loadFailed' => '加载备注失败',
			'calendar.title' => '消费日历',
			'calendar.weekdays.mon' => '一',
			'calendar.weekdays.tue' => '二',
			'calendar.weekdays.wed' => '三',
			'calendar.weekdays.thu' => '四',
			'calendar.weekdays.fri' => '五',
			'calendar.weekdays.sat' => '六',
			'calendar.weekdays.sun' => '日',
			'calendar.loadFailed' => '加载日历数据失败',
			'calendar.thisMonth' => ({required Object amount}) => '本月: ${amount}',
			'calendar.counting' => '统计中...',
			'calendar.unableToCount' => '无法统计',
			'calendar.trend' => '趋势: ',
			'calendar.noTransactionsTitle' => '当日无交易记录',
			'calendar.loadTransactionFailed' => '加载交易失败',
			'category.dailyConsumption' => '日常消费',
			'category.transportation' => '交通出行',
			'category.healthcare' => '医疗健康',
			'category.housing' => '住房物业',
			'category.education' => '教育培训',
			'category.incomeCategory' => '收入进账',
			'category.socialGifts' => '社交馈赠',
			'category.moneyTransfer' => '资金周转',
			'category.other' => '其他',
			'category.foodDining' => '餐饮美食',
			'category.shoppingRetail' => '购物消费',
			'category.housingUtilities' => '居住物业',
			'category.personalCare' => '个人护理',
			'category.entertainment' => '休闲娱乐',
			'category.medicalHealth' => '医疗健康',
			'category.insurance' => '保险',
			'category.socialGifting' => '人情往来',
			'category.financialTax' => '金融税务',
			'category.others' => '其他支出',
			'category.salaryWage' => '工资薪水',
			'category.businessTrade' => '经营交易',
			'category.investmentReturns' => '投资回报',
			'category.giftBonus' => '礼金红包',
			'category.refundRebate' => '退款返利',
			'category.generalTransfer' => '转账',
			'category.debtRepayment' => '债务还款',
			'settings.title' => '设置',
			'settings.language' => '语言',
			'settings.languageSettings' => '语言设置',
			'settings.selectLanguage' => '选择语言',
			'settings.languageChanged' => '语言已更改',
			'settings.restartToApply' => '重启应用以应用更改',
			'settings.theme' => '主题',
			'settings.darkMode' => '深色模式',
			'settings.lightMode' => '浅色模式',
			'settings.systemMode' => '跟随系统',
			'settings.developerOptions' => '开发者选项',
			'settings.authDebug' => '认证状态调试',
			'settings.authDebugSubtitle' => '查看认证状态和调试信息',
			'settings.fontTest' => '字体测试',
			'settings.fontTestSubtitle' => '测试应用字体显示效果',
			'settings.helpAndFeedback' => '帮助与反馈',
			'settings.helpAndFeedbackSubtitle' => '获取帮助或提供反馈',
			'settings.aboutApp' => '关于应用',
			'settings.aboutAppSubtitle' => '版本信息和开发者信息',
			'settings.currencyChangedRefreshHint' => ({required Object currency}) => '已切换为 ${currency}，新交易将以此货币记录',
			'settings.sharedSpace' => '共享空间',
			'settings.speechRecognition' => '语音识别',
			'settings.speechRecognitionSubtitle' => '配置语音输入参数',
			'settings.amountDisplayStyle' => '金额显示样式',
			'settings.currency' => '显示币种',
			'settings.appearance' => '外观设置',
			'settings.appearanceSubtitle' => '主题模式与配色方案',
			'settings.speechTest' => '语音测试',
			'settings.speechTestSubtitle' => '测试 WebSocket 语音连接',
			'settings.userTypeRegular' => '普通用户',
			'settings.selectAmountStyle' => '选择金额显示样式',
			'settings.amountStyleNotice' => '注意：金额样式主要应用于「交易流水」和「趋势分析」。为了保持视觉清晰，「账户余额」和「资产概览」等状态类数值将保持中性颜色。',
			'settings.currencyDescription' => '选择您的主要货币。未来的记账将默认使用此货币，统计和汇总也将以此货币显示。历史交易的原始金额不受影响。',
			'settings.editUsername' => '修改用户名',
			'settings.enterUsername' => '请输入用户名',
			'settings.usernameRequired' => '用户名不能为空',
			'settings.usernameUpdated' => '用户名已更新',
			'settings.avatarUpdated' => '头像已更新',
			'settings.appearanceUpdated' => '外观设置已更新',
			'appearance.title' => '外观设置',
			'appearance.themeMode' => '主题模式',
			'appearance.light' => '浅色',
			'appearance.dark' => '深色',
			'appearance.system' => '跟随系统',
			'appearance.colorScheme' => '配色方案',
			'appearance.palettes.zinc' => '锌灰',
			'appearance.palettes.slate' => '板岩',
			'appearance.palettes.red' => '绯红',
			'appearance.palettes.rose' => '玫瑰',
			'appearance.palettes.orange' => '橙色',
			'appearance.palettes.green' => '绿色',
			'appearance.palettes.blue' => '蓝色',
			'appearance.palettes.yellow' => '黄色',
			'appearance.palettes.violet' => '紫罗兰',
			'speech.title' => '语音识别设置',
			'speech.service' => '语音识别服务',
			'speech.systemVoice' => '系统语音',
			'speech.systemVoiceSubtitle' => '使用手机内置的语音识别服务（推荐）',
			'speech.selfHostedASR' => '自建 ASR 服务',
			'speech.selfHostedASRSubtitle' => '使用 WebSocket 连接到自建语音识别服务',
			'speech.serverConfig' => '服务器配置',
			'speech.serverAddress' => '服务器地址',
			'speech.port' => '端口',
			'speech.path' => '路径',
			'speech.saveConfig' => '保存配置',
			'speech.info' => '信息',
			'speech.infoContent' => '• 系统语音：使用设备内置服务，无需配置，响应更快\n• 自建 ASR：适用于自定义模型或离线场景\n\n更改将在下次使用语音输入时生效。',
			'speech.enterAddress' => '请输入服务器地址',
			'speech.enterValidPort' => '请输入有效的端口 (1-65535)',
			'speech.configSaved' => '配置已保存',
			'amountTheme.chinaMarket' => '中国市场',
			'amountTheme.chinaMarketDesc' => '红涨绿跌/黑跌',
			'amountTheme.international' => '国际标准',
			'amountTheme.internationalDesc' => '绿涨红跌',
			'amountTheme.minimalist' => '极简模式',
			'amountTheme.minimalistDesc' => '仅通过符号区分',
			'amountTheme.colorBlind' => '色弱友好',
			'amountTheme.colorBlindDesc' => '蓝橙配色方案',
			'locale.chinese' => '中文（简体）',
			'locale.traditionalChinese' => '中文（繁体）',
			'locale.english' => 'English',
			'locale.japanese' => '日本語',
			'locale.korean' => '한국어',
			'budget.title' => '预算管理',
			'budget.detail' => '预算详情',
			'budget.info' => '预算信息',
			'budget.totalBudget' => '总预算',
			'budget.categoryBudget' => '分类预算',
			'budget.monthlySummary' => '本月预算汇总',
			'budget.used' => '已使用',
			'budget.remaining' => '剩余',
			'budget.overspent' => '超支',
			'budget.budget' => '预算',
			'budget.loadFailed' => '加载失败',
			'budget.noBudget' => '暂无预算',
			'budget.createHint' => '通过 Augo 助手说"帮我设置预算"来创建',
			'budget.paused' => '已暂停',
			'budget.pause' => '暂停',
			'budget.resume' => '恢复',
			'budget.budgetPaused' => '预算已暂停',
			'budget.budgetResumed' => '预算已恢复',
			'budget.operationFailed' => '操作失败',
			'budget.deleteBudget' => '删除预算',
			'budget.deleteConfirm' => '确定要删除这个预算吗？此操作不可撤销。',
			'budget.type' => '类型',
			'budget.category' => '分类',
			'budget.period' => '周期',
			'budget.rollover' => '滚动预算',
			'budget.rolloverBalance' => '滚动余额',
			'budget.enabled' => '开启',
			'budget.disabled' => '关闭',
			'budget.statusNormal' => '预算正常',
			'budget.statusWarning' => '接近上限',
			'budget.statusOverspent' => '已超支',
			'budget.statusAchieved' => '目标达成',
			'budget.tipNormal' => ({required Object amount}) => '还剩 ${amount} 可用',
			'budget.tipWarning' => ({required Object amount}) => '仅剩 ${amount}，请注意控制',
			'budget.tipOverspent' => ({required Object amount}) => '已超支 ${amount}',
			'budget.tipAchieved' => '恭喜完成储蓄目标！',
			'budget.remainingAmount' => ({required Object amount}) => '剩余 ${amount}',
			'budget.overspentAmount' => ({required Object amount}) => '超支 ${amount}',
			'budget.budgetAmount' => ({required Object amount}) => '预算 ${amount}',
			'budget.active' => '活跃',
			'budget.all' => '全部',
			'budget.notFound' => '预算不存在或已被删除',
			'budget.setup' => '预算设置',
			'budget.settings' => '预算设置',
			'budget.setAmount' => '设置预算金额',
			'budget.setAmountDesc' => '为每个分类设置预算金额',
			'budget.monthly' => '月度预算',
			'budget.monthlyDesc' => '按月管理您的支出，适合大多数人',
			'budget.weekly' => '周预算',
			'budget.weeklyDesc' => '按周管理支出，更精细的控制',
			'budget.yearly' => '年度预算',
			'budget.yearlyDesc' => '长期财务规划，适合大额支出管理',
			'budget.editBudget' => '编辑预算',
			'budget.editBudgetDesc' => '修改预算金额和分类',
			'budget.reminderSettings' => '提醒设置',
			'budget.reminderSettingsDesc' => '设置预算提醒和通知',
			'budget.report' => '预算报告',
			'budget.reportDesc' => '查看详细的预算分析报告',
			'budget.welcome' => '欢迎使用预算功能！',
			'budget.createNewPlan' => '创建新的预算计划',
			'budget.welcomeDesc' => '通过设置预算，您可以更好地控制支出，实现财务目标。让我们开始设置您的第一个预算计划吧！',
			'budget.createDesc' => '为不同的支出类别设置预算限额，帮助您更好地管理财务。',
			'budget.newBudget' => '新建预算',
			'budget.budgetAmountLabel' => '预算金额',
			'budget.currency' => '货币',
			'budget.periodSettings' => '周期设置',
			'budget.autoGenerateTransactions' => '开启后按规则自动生成交易',
			'budget.cycle' => '周期',
			'budget.budgetCategory' => '预算分类',
			'budget.advancedOptions' => '高级选项',
			'budget.periodType' => '周期类型',
			'budget.anchorDay' => '起算日',
			'budget.selectPeriodType' => '选择周期类型',
			'budget.selectAnchorDay' => '选择起算日',
			'budget.rolloverDescription' => '未用完的预算结转到下期',
			'budget.createBudget' => '创建预算',
			'budget.save' => '保存',
			'budget.pleaseEnterAmount' => '请输入预算金额',
			'budget.invalidAmount' => '请输入有效的预算金额',
			'budget.updateSuccess' => '预算更新成功',
			'budget.createSuccess' => '预算创建成功',
			'budget.deleteSuccess' => '预算已删除',
			'budget.deleteFailed' => '删除失败',
			'budget.everyMonthDay' => ({required Object day}) => '每月 ${day} 号',
			'budget.periodWeekly' => '每周',
			'budget.periodBiweekly' => '双周',
			'budget.periodMonthly' => '每月',
			'budget.periodYearly' => '每年',
			'budget.statusActive' => '进行中',
			'budget.statusArchived' => '已归档',
			'budget.periodStatusOnTrack' => '正常',
			'budget.periodStatusWarning' => '预警',
			'budget.periodStatusExceeded' => '超支',
			'budget.periodStatusAchieved' => '达成',
			'budget.usedPercent' => ({required Object percent}) => '${percent}% 已使用',
			'budget.dayOfMonth' => ({required Object day}) => '${day} 号',
			'budget.tenThousandSuffix' => '万',
			'dateRange.custom' => '自定义',
			'dateRange.pickerTitle' => '选择时间范围',
			'dateRange.startDate' => '开始日期',
			'dateRange.endDate' => '结束日期',
			'dateRange.hint' => '请选择日期范围',
			'forecast.title' => '预测',
			'forecast.subtitle' => '基于您的财务数据智能预测未来现金流',
			'forecast.financialNavigator' => '你好，我是你的财务领航员',
			'forecast.financialMapSubtitle' => '只需3步，我们一起绘制你未来的财务地图',
			'forecast.predictCashFlow' => '预测未来现金流',
			'forecast.predictCashFlowDesc' => '看清每一天的财务状况',
			'forecast.aiSmartSuggestions' => 'AI智能建议',
			'forecast.aiSmartSuggestionsDesc' => '个性化的财务决策指导',
			'forecast.riskWarning' => '风险预警',
			'forecast.riskWarningDesc' => '提前发现潜在的财务风险',
			'forecast.analyzing' => '我正在分析你的财务数据，生成未来30天的现金流预测',
			'forecast.analyzePattern' => '分析收入支出模式',
			'forecast.calculateTrend' => '计算现金流趋势',
			'forecast.generateWarning' => '生成风险预警',
			'forecast.loadingForecast' => '正在加载财务预测...',
			'forecast.todayLabel' => '今日',
			'forecast.tomorrowLabel' => '明日',
			'forecast.balanceLabel' => '余额',
			'forecast.noSpecialEvents' => '无特殊事件',
			'forecast.financialSafetyLine' => '财务安全线',
			'forecast.currentSetting' => '当前设置',
			'forecast.dailySpendingEstimate' => '日常消费预估',
			'forecast.adjustDailySpendingAmount' => '调整每日消费预测金额',
			'forecast.tellMeYourSafetyLine' => '告诉我你的财务"安心线"是多少？',
			'forecast.safetyLineDescription' => '这是你希望账户保持的最低余额，当余额接近这个数值时，我会提醒你注意财务风险。',
			'forecast.dailySpendingQuestion' => '每天的"小日子"大概花多少？',
			'forecast.dailySpendingDescription' => '包括吃饭、交通、购物等日常开销\n这只是一个初始估算，我会通过你未来的真实记录，让预测越来越准',
			'forecast.perDay' => '每天',
			'forecast.referenceStandard' => '参考标准',
			'forecast.frugalType' => '节俭型',
			'forecast.comfortableType' => '舒适型',
			'forecast.relaxedType' => '宽松型',
			'forecast.frugalAmount' => '50-100元/天',
			'forecast.comfortableAmount' => '100-200元/天',
			'forecast.relaxedAmount' => '200-300元/天',
			'forecast.recurringTransaction.title' => '周期交易',
			'forecast.recurringTransaction.all' => '全部',
			'forecast.recurringTransaction.expense' => '支出',
			'forecast.recurringTransaction.income' => '收入',
			'forecast.recurringTransaction.transfer' => '转账',
			'forecast.recurringTransaction.noRecurring' => '暂无周期交易',
			'forecast.recurringTransaction.createHint' => '创建周期交易后，系统将自动为您生成交易记录',
			'forecast.recurringTransaction.create' => '创建周期交易',
			'forecast.recurringTransaction.edit' => '编辑周期交易',
			'forecast.recurringTransaction.newTransaction' => '新建周期交易',
			'forecast.recurringTransaction.deleteConfirm' => ({required Object name}) => '确定要删除周期交易「${name}」吗？此操作不可撤销。',
			'forecast.recurringTransaction.activateConfirm' => ({required Object name}) => '确定要启用周期交易「${name}」吗？启用后将按照设定的规则自动生成交易记录。',
			'forecast.recurringTransaction.pauseConfirm' => ({required Object name}) => '确定要暂停周期交易「${name}」吗？暂停后将不再自动生成交易记录。',
			'forecast.recurringTransaction.created' => '周期交易已创建',
			'forecast.recurringTransaction.updated' => '周期交易已更新',
			'forecast.recurringTransaction.activated' => '已启用',
			'forecast.recurringTransaction.paused' => '已暂停',
			'forecast.recurringTransaction.nextTime' => '下次',
			'forecast.recurringTransaction.sortByTime' => '按时间排序',
			'forecast.recurringTransaction.allPeriod' => '全部周期',
			'forecast.recurringTransaction.periodCount' => ({required Object type, required Object count}) => '${type}周期 (${count})',
			'forecast.recurringTransaction.confirmDelete' => '确认删除',
			'forecast.recurringTransaction.confirmActivate' => '确认启用',
			'forecast.recurringTransaction.confirmPause' => '确认暂停',
			'forecast.recurringTransaction.dynamicAmount' => '动态均值',
			'forecast.recurringTransaction.dynamicAmountTitle' => '金额需手动确认',
			'forecast.recurringTransaction.dynamicAmountDescription' => '系统将在账单日发送提醒，需要您手动确认具体金额后才会记账。',
			'chat.newChat' => '新聊天',
			'chat.noMessages' => '没有消息可显示。',
			'chat.loadingFailed' => '加载失败',
			'chat.inputMessage' => '输入消息...',
			'chat.listening' => '正在聆听...',
			'chat.aiThinking' => '正在处理...',
			'chat.tools.processing' => '正在处理...',
			'chat.tools.read_file' => '正在查看文件...',
			'chat.tools.search_transactions' => '正在查询交易...',
			'chat.tools.query_budget_status' => '正在检查预算...',
			'chat.tools.create_budget' => '正在创建预算计划...',
			'chat.tools.get_cash_flow_analysis' => '正在分析现金流...',
			'chat.tools.get_financial_health_score' => '正在计算财务健康分...',
			'chat.tools.get_financial_summary' => '正在生成财务报告...',
			'chat.tools.evaluate_financial_health' => '正在评估财务健康...',
			'chat.tools.forecast_balance' => '正在预测未来余额...',
			'chat.tools.simulate_expense_impact' => '正在模拟购买影响...',
			'chat.tools.record_transactions' => '正在记账...',
			'chat.tools.create_transaction' => '正在记账...',
			'chat.tools.duckduckgo_search' => '正在搜索网络...',
			'chat.tools.execute_transfer' => '正在执行转账...',
			'chat.tools.list_dir' => '正在浏览目录...',
			'chat.tools.execute' => '正在执行脚本...',
			'chat.tools.analyze_finance' => '正在分析财务状况...',
			'chat.tools.forecast_finance' => '正在预测财务趋势...',
			'chat.tools.analyze_budget' => '正在分析预算...',
			'chat.tools.audit_analysis' => '正在审计分析...',
			'chat.tools.budget_ops' => '正在处理预算...',
			'chat.tools.create_shared_transaction' => '正在创建共享账单...',
			'chat.tools.list_spaces' => '正在获取共享空间...',
			'chat.tools.query_space_summary' => '正在查询空间摘要...',
			'chat.tools.prepare_transfer' => '正在准备转账...',
			'chat.tools.unknown' => '正在处理请求...',
			'chat.tools.done.read_file' => '已查看文件',
			'chat.tools.done.search_transactions' => '已查询交易',
			'chat.tools.done.query_budget_status' => '已检查预算',
			'chat.tools.done.create_budget' => '已创建预算',
			'chat.tools.done.get_cash_flow_analysis' => '已分析现金流',
			'chat.tools.done.get_financial_health_score' => '已计算健康分',
			'chat.tools.done.get_financial_summary' => '财务报告生成完成',
			'chat.tools.done.evaluate_financial_health' => '财务健康评估完成',
			'chat.tools.done.forecast_balance' => '余额预测完成',
			'chat.tools.done.simulate_expense_impact' => '购买影响模拟完成',
			'chat.tools.done.record_transactions' => '记账完成',
			'chat.tools.done.create_transaction' => '已完成记账',
			'chat.tools.done.duckduckgo_search' => '已搜索网络',
			'chat.tools.done.execute_transfer' => '转账完成',
			'chat.tools.done.list_dir' => '已浏览目录',
			'chat.tools.done.execute' => '脚本执行完成',
			'chat.tools.done.analyze_finance' => '财务分析完成',
			'chat.tools.done.forecast_finance' => '财务预测完成',
			'chat.tools.done.analyze_budget' => '预算分析完成',
			'chat.tools.done.audit_analysis' => '审计分析完成',
			'chat.tools.done.budget_ops' => '预算处理完成',
			'chat.tools.done.create_shared_transaction' => '共享账单创建完成',
			'chat.tools.done.list_spaces' => '共享空间获取完成',
			'chat.tools.done.query_space_summary' => '空间摘要查询完成',
			'chat.tools.done.prepare_transfer' => '转账准备完成',
			'chat.tools.done.unknown' => '处理完成',
			'chat.tools.failed.unknown' => '操作失败',
			'chat.tools.cancelled' => '已取消',
			'chat.speechNotRecognized' => '未识别到语音，请重试',
			'chat.currentExpense' => '当前支出',
			'chat.loadingComponent' => '正在加载组件...',
			'chat.noHistory' => '暂无历史会话',
			'chat.startNewChat' => '开启一段新对话吧！',
			'chat.searchHint' => '搜索会话',
			'chat.library' => '库',
			'chat.viewProfile' => '查看个人资料',
			'chat.noRelatedFound' => '未找到相关会话',
			'chat.tryOtherKeywords' => '尝试搜索其他关键词',
			_ => null,
		} ?? switch (path) {
			'chat.searchFailed' => '搜索失败',
			'chat.deleteConversation' => '删除会话',
			'chat.deleteConversationConfirm' => '确定要删除这个会话吗？此操作无法撤销。',
			'chat.conversationDeleted' => '会话已删除',
			'chat.deleteConversationFailed' => '删除会话失败',
			'chat.transferWizard.title' => '转账向导',
			'chat.transferWizard.amount' => '转账金额',
			'chat.transferWizard.amountHint' => '请输入金额',
			'chat.transferWizard.sourceAccount' => '转出账户',
			'chat.transferWizard.targetAccount' => '转入账户',
			'chat.transferWizard.selectAccount' => '请选择账户',
			'chat.transferWizard.selectReceiveAccount' => '选择收款账户',
			'chat.transferWizard.confirmTransfer' => '确认转账',
			'chat.transferWizard.confirmed' => '已确认',
			'chat.transferWizard.transferSuccess' => '转账成功',
			'chat.genui.expenseSummary.totalExpense' => '总支出',
			'chat.genui.expenseSummary.mainExpenses' => '主要支出',
			'chat.genui.expenseSummary.viewAll' => ({required Object count}) => '查看全部 ${count} 笔消费',
			'chat.genui.expenseSummary.details' => '消费明细',
			'chat.genui.transactionList.searchResults' => ({required Object count}) => '搜索结果 (${count})',
			'chat.genui.transactionList.loaded' => ({required Object count}) => '已加载 ${count}',
			'chat.genui.transactionList.noResults' => '未找到相关交易',
			'chat.genui.transactionList.loadMore' => '滚动加载更多',
			'chat.genui.transactionList.allLoaded' => '全部加载完成',
			'chat.genui.transactionGroupReceipt.title' => '交易成功',
			'chat.genui.transactionGroupReceipt.count' => ({required Object count}) => '${count}笔',
			'chat.genui.transactionGroupReceipt.total' => '共计',
			'chat.genui.transactionGroupReceipt.selectAccount' => '选择关联账户',
			'chat.genui.transactionGroupReceipt.selectAccountSubtitle' => '此账户将应用到以上所有笔交易',
			'chat.genui.transactionGroupReceipt.associatedAccount' => ({required Object name}) => '已关联账户：${name}',
			'chat.genui.transactionGroupReceipt.clickToAssociate' => '点击关联账户（支持批量操作）',
			'chat.genui.transactionGroupReceipt.associateSuccess' => '已成功为所有交易关联账户',
			'chat.genui.transactionGroupReceipt.associateFailed' => ({required Object error}) => '操作失败: ${error}',
			'chat.genui.transactionGroupReceipt.accountAssociation' => '账户关联',
			'chat.genui.transactionGroupReceipt.sharedSpace' => '共享空间',
			'chat.genui.transactionGroupReceipt.notAssociated' => '未关联',
			'chat.genui.transactionGroupReceipt.addSpace' => '添加',
			'chat.genui.transactionGroupReceipt.selectSpace' => '选择共享空间',
			'chat.genui.transactionGroupReceipt.spaceAssociateSuccess' => '已关联到共享空间',
			'chat.genui.transactionGroupReceipt.spaceAssociateFailed' => ({required Object error}) => '关联共享空间失败: ${error}',
			'chat.genui.transactionGroupReceipt.currencyMismatchTitle' => '币种不一致',
			'chat.genui.transactionGroupReceipt.currencyMismatchDesc' => '交易币种与账户币种不同，系统将按当时汇率换算后扣减账户余额。',
			'chat.genui.transactionGroupReceipt.transactionAmount' => '交易金额',
			'chat.genui.transactionGroupReceipt.accountCurrency' => '账户币种',
			'chat.genui.transactionGroupReceipt.targetAccount' => '目标账户',
			'chat.genui.transactionGroupReceipt.currencyMismatchNote' => '提示：账户余额将按当时汇率进行换算扣减',
			'chat.genui.transactionGroupReceipt.confirmAssociate' => '确认关联',
			'chat.genui.transactionGroupReceipt.spaceCount' => ({required Object count}) => '${count} 空间',
			'chat.genui.budgetReceipt.newBudget' => '新预算',
			'chat.genui.budgetReceipt.budgetCreated' => '预算已创建',
			'chat.genui.budgetReceipt.rolloverBudget' => '滚动预算',
			'chat.genui.budgetReceipt.createFailed' => '创建预算失败',
			'chat.genui.budgetReceipt.thisMonth' => '本月',
			'chat.genui.budgetReceipt.dateRange' => ({required Object start, required Object startDay, required Object end, required Object endDay}) => '${start}月${startDay}日 - ${end}月${endDay}日',
			'chat.genui.budgetStatusCard.budget' => '预算',
			'chat.genui.budgetStatusCard.overview' => '预算概览',
			'chat.genui.budgetStatusCard.totalBudget' => '总预算',
			'chat.genui.budgetStatusCard.spent' => ({required Object amount}) => '已用 ¥${amount}',
			'chat.genui.budgetStatusCard.remaining' => ({required Object amount}) => '剩余 ¥${amount}',
			'chat.genui.budgetStatusCard.exceeded' => '已超支',
			'chat.genui.budgetStatusCard.warning' => '预算紧张',
			'chat.genui.budgetStatusCard.plentiful' => '预算充裕',
			'chat.genui.budgetStatusCard.normal' => '正常',
			'chat.genui.cashFlowForecast.title' => '现金流预测',
			'chat.genui.cashFlowForecast.recurringTransaction' => '周期性交易',
			'chat.genui.cashFlowForecast.recurringIncome' => '周期性收入',
			'chat.genui.cashFlowForecast.recurringExpense' => '周期性支出',
			'chat.genui.cashFlowForecast.recurringTransfer' => '周期性转账',
			'chat.genui.cashFlowForecast.nextDays' => ({required Object days}) => '未来 ${days} 天',
			'chat.genui.cashFlowForecast.noData' => '暂无预测数据',
			'chat.genui.cashFlowForecast.summary' => '预测摘要',
			'chat.genui.cashFlowForecast.variableExpense' => '预测可变支出',
			'chat.genui.cashFlowForecast.netChange' => '预计净变化',
			'chat.genui.cashFlowForecast.keyEvents' => '关键事件',
			'chat.genui.cashFlowForecast.noSignificantEvents' => '预测期内无重大事件',
			'chat.genui.cashFlowForecast.dateFormat' => 'M月d日',
			'chat.genui.healthScore.title' => '财务健康',
			'chat.genui.healthScore.suggestions' => '改进建议',
			'chat.genui.healthScore.scorePoint' => ({required Object score}) => '${score}分',
			'chat.genui.healthScore.status.excellent' => '财务状况优秀',
			'chat.genui.healthScore.status.good' => '财务状况良好',
			'chat.genui.healthScore.status.fair' => '财务状况一般',
			'chat.genui.healthScore.status.needsImprovement' => '财务状况需改善',
			'chat.genui.healthScore.status.poor' => '财务状况较差',
			'chat.genui.spaceSelector.selected' => '已选择',
			'chat.genui.spaceSelector.unnamedSpace' => '未命名空间',
			'chat.genui.spaceSelector.linked' => '已关联',
			'chat.genui.spaceSelector.roleOwner' => '创建者',
			'chat.genui.spaceSelector.roleAdmin' => '管理员',
			'chat.genui.spaceSelector.roleMember' => '成员',
			'chat.genui.transferPath.selectSource' => '选择转出账户',
			'chat.genui.transferPath.selectTarget' => '选择转入账户',
			'chat.genui.transferPath.from' => '转出 (FROM)',
			'chat.genui.transferPath.to' => '转入 (TO)',
			'chat.genui.transferPath.select' => '请选择',
			'chat.genui.transferPath.cancelled' => '操作已取消',
			'chat.genui.transferPath.loadError' => '无法加载账户数据',
			'chat.genui.transferPath.historyMissing' => '历史记录中缺少账户信息',
			'chat.genui.transferPath.amountUnconfirmed' => '金额待确认',
			'chat.genui.transferPath.confirmedWithArrow' => ({required Object source, required Object target}) => '已确认：${source} → ${target}',
			'chat.genui.transferPath.confirmAction' => ({required Object source, required Object target}) => '确认：${source} → ${target}',
			'chat.genui.transferPath.pleaseSelectSource' => '请先选择转出账户',
			'chat.genui.transferPath.pleaseSelectTarget' => '请选择转入账户',
			'chat.genui.transferPath.confirmLinks' => '确认转账链路',
			'chat.genui.transferPath.linkLocked' => '链路已锁定',
			'chat.genui.transferPath.clickToConfirm' => '点击下方按钮确认执行',
			'chat.genui.transferPath.reselect' => '重选',
			'chat.genui.transferPath.title' => '转账',
			'chat.genui.transferPath.history' => '历史记录',
			'chat.genui.transferPath.unknownAccount' => '未知账户',
			'chat.genui.transferPath.confirmed' => '已确认',
			'chat.genui.transactionCard.title' => '交易成功',
			'chat.genui.transactionCard.associatedAccount' => '已关联账户',
			'chat.genui.transactionCard.notCounted' => '不计入资产',
			'chat.genui.transactionCard.modify' => '修改',
			'chat.genui.transactionCard.associate' => '关联账户',
			'chat.genui.transactionCard.selectAccount' => '选择关联账户',
			'chat.genui.transactionCard.noAccount' => '暂无可用账户，请先添加账户',
			'chat.genui.transactionCard.missingId' => '交易 ID 缺失，无法更新',
			'chat.genui.transactionCard.associatedTo' => ({required Object name}) => '已关联到 ${name}',
			'chat.genui.transactionCard.updateFailed' => ({required Object error}) => '更新失败: ${error}',
			'chat.genui.transactionCard.sharedSpace' => '共享空间',
			'chat.genui.transactionCard.noSpace' => '暂无可用共享空间',
			'chat.genui.transactionCard.selectSpace' => '选择共享空间',
			'chat.genui.transactionCard.linkedToSpace' => '已关联到共享空间',
			'chat.genui.transactionConfirmation.multipleAccounts' => '检测到多个关联账户',
			'chat.genui.transactionConfirmation.confirmed' => '已确认',
			'chat.genui.budgetAnalysis.title' => '预算分析报告',
			'chat.genui.budgetAnalysis.periodDays' => ({required Object days}) => '过去 ${days} 天',
			'chat.genui.budgetAnalysis.totalExpense' => '总支出',
			'chat.genui.budgetAnalysis.momChange' => ({required Object change}) => '环比 ${change}%',
			'chat.genui.budgetAnalysis.categoryDistribution' => '分类占比',
			'chat.genui.budgetAnalysis.topSpenders' => '大额支出',
			'chat.genui.budgetAnalysis.amountWan' => ({required Object amount}) => '${amount}万',
			'chat.genui.cashFlowCard.title' => '现金流分析',
			'chat.genui.cashFlowCard.savingsRate' => ({required Object rate}) => '储蓄 ${rate}%',
			'chat.genui.cashFlowCard.totalIncome' => '总收入',
			'chat.genui.cashFlowCard.totalExpense' => '总支出',
			'chat.genui.cashFlowCard.essentialExpense' => '必要支出',
			'chat.genui.cashFlowCard.discretionaryExpense' => '可选消费',
			'chat.genui.cashFlowCard.aiInsight' => 'AI 分析',
			'chat.welcome.morning.subtitle' => '新的一天，从记录开始',
			'chat.welcome.morning.breakfast.title' => '早餐记账',
			'chat.welcome.morning.breakfast.prompt' => '记一笔早餐',
			'chat.welcome.morning.breakfast.description' => '快速记录今天的第一笔消费',
			'chat.welcome.morning.yesterdayReview.title' => '昨日回顾',
			'chat.welcome.morning.yesterdayReview.prompt' => '分析昨天的消费',
			'chat.welcome.morning.yesterdayReview.description' => '看看昨天花了多少钱',
			'chat.welcome.morning.todayBudget.title' => '今日预算',
			'chat.welcome.morning.todayBudget.prompt' => '今天还剩多少预算',
			'chat.welcome.morning.todayBudget.description' => '规划一天的消费额度',
			'chat.welcome.midday.greeting' => '中午好',
			'chat.welcome.midday.subtitle' => '午间时光，顺手记一笔',
			'chat.welcome.midday.lunch.title' => '午餐记账',
			'chat.welcome.midday.lunch.prompt' => '记一笔午餐',
			'chat.welcome.midday.lunch.description' => '记录午餐开销',
			'chat.welcome.midday.weeklyExpense.title' => '本周消费',
			'chat.welcome.midday.weeklyExpense.prompt' => '分析本周消费',
			'chat.welcome.midday.weeklyExpense.description' => '了解本周花费情况',
			'chat.welcome.midday.checkBalance.title' => '查看余额',
			'chat.welcome.midday.checkBalance.prompt' => '查看账户余额',
			'chat.welcome.midday.checkBalance.description' => '看看各账户还剩多少',
			'chat.welcome.afternoon.subtitle' => '下午茶时间，理理财',
			'chat.welcome.afternoon.quickRecord.title' => '随手记账',
			'chat.welcome.afternoon.quickRecord.prompt' => '帮我记一笔',
			'chat.welcome.afternoon.quickRecord.description' => '快速记录一笔消费',
			'chat.welcome.afternoon.analyzeSpending.title' => '分析消费',
			'chat.welcome.afternoon.analyzeSpending.prompt' => '分析本月消费',
			'chat.welcome.afternoon.analyzeSpending.description' => '查看消费趋势和构成',
			'chat.welcome.afternoon.budgetProgress.title' => '财务健康',
			'chat.welcome.afternoon.budgetProgress.prompt' => '评估我的财务健康',
			'chat.welcome.afternoon.budgetProgress.description' => '收支平衡评分与建议',
			'chat.welcome.evening.subtitle' => '辛苦一天，来理理账',
			'chat.welcome.evening.dinner.title' => '晚餐记账',
			'chat.welcome.evening.dinner.prompt' => '记一笔晚餐',
			'chat.welcome.evening.dinner.description' => '记录今天的晚餐消费',
			'chat.welcome.evening.todaySummary.title' => '今日总结',
			'chat.welcome.evening.todaySummary.prompt' => '总结今天的消费',
			'chat.welcome.evening.todaySummary.description' => '看看今天花了多少',
			'chat.welcome.evening.tomorrowPlan.title' => '明日计划',
			'chat.welcome.evening.tomorrowPlan.prompt' => '明天有什么固定支出',
			'chat.welcome.evening.tomorrowPlan.description' => '提前规划明天的消费',
			'chat.welcome.night.greeting' => '夜深了',
			'chat.welcome.night.subtitle' => '静心理财，规划未来',
			'chat.welcome.night.makeupRecord.title' => '补记今日',
			'chat.welcome.night.makeupRecord.prompt' => '帮我补记今天的消费',
			'chat.welcome.night.makeupRecord.description' => '把今天忘记的账补上',
			'chat.welcome.night.monthlyReview.title' => '本月分析',
			'chat.welcome.night.monthlyReview.prompt' => '详细分析本月支出',
			'chat.welcome.night.monthlyReview.description' => '回顾这个月的钱花哪了',
			'chat.welcome.night.financialThinking.title' => '未来预测',
			'chat.welcome.night.financialThinking.prompt' => '预测未来 30 天余额',
			'chat.welcome.night.financialThinking.description' => '看清未来的财务趋势',
			'footprint.searchIn' => '搜索',
			'footprint.searchInAllRecords' => '在所有记录中搜索相关内容',
			'media.selectPhotos' => '选择照片',
			'media.addFiles' => '添加文件',
			'media.takePhoto' => '拍照',
			'media.camera' => '相机',
			'media.photos' => '照片',
			'media.files' => '文件',
			'media.showAll' => '显示全部',
			'media.allPhotos' => '所有照片',
			'media.takingPhoto' => '拍照中...',
			'media.photoTaken' => '照片已保存',
			'media.cameraPermissionRequired' => '需要相机权限',
			'media.fileSizeExceeded' => '文件大小超过10MB限制',
			'media.unsupportedFormat' => '不支持的文件格式',
			'media.permissionDenied' => '需要相册访问权限',
			'media.storageInsufficient' => '存储空间不足',
			'media.networkError' => '网络连接错误',
			'media.unknownUploadError' => '上传时发生未知错误',
			'error.permissionRequired' => '需要权限',
			'error.permissionInstructions' => '请在设置中开启相册和存储权限，以便选择和上传文件。',
			'error.openSettings' => '打开设置',
			'error.fileTooLarge' => '文件过大',
			'error.fileSizeHint' => '请选择小于10MB的文件，或者压缩后再上传。',
			'error.supportedFormatsHint' => '支持的格式包括：图片(jpg, png, gif等)、文档(pdf, doc, txt等)、音视频文件等。',
			'error.storageCleanupHint' => '请清理设备存储空间后重试，或选择较小的文件。',
			'error.networkErrorHint' => '请检查网络连接是否正常，然后重试。',
			'error.platformNotSupported' => '平台不支持',
			'error.fileReadError' => '文件读取失败',
			'error.fileReadErrorHint' => '文件可能已损坏或被其他程序占用，请重新选择文件。',
			'error.validationError' => '文件验证失败',
			'error.unknownError' => '未知错误',
			'error.unknownErrorHint' => '发生了意外错误，请重试或联系技术支持。',
			'error.genui.loadingFailed' => '组件加载失败',
			'error.genui.schemaFailed' => '架构验证失败',
			'error.genui.schemaDescription' => '组件定义不符合 GenUI 规范，降级为纯文本显示',
			'error.genui.networkError' => '网络错误',
			'error.genui.retryStatus' => ({required Object retryCount, required Object maxRetries}) => '已重试 ${retryCount}/${maxRetries} 次',
			'error.genui.maxRetriesReached' => '已达最大重试次数',
			'fontTest.page' => '字体测试页面',
			'fontTest.displayTest' => '字体显示测试',
			'fontTest.chineseTextTest' => '中文文本测试',
			'fontTest.englishTextTest' => '英文文本测试',
			'fontTest.sample1' => '这是一段中文文本，用于测试字体显示效果。',
			'fontTest.sample2' => '支出分类汇总，购物最高',
			'fontTest.sample3' => '人工智能助手为您提供专业的财务分析服务',
			'fontTest.sample4' => '数据可视化图表展示您的消费趋势',
			'fontTest.sample5' => '微信支付、支付宝、银行卡等多种支付方式',
			'wizard.nextStep' => '下一步',
			'wizard.previousStep' => '上一步',
			'wizard.completeMapping' => '完成绘制',
			'user.username' => '用户名',
			'user.defaultEmail' => 'user@example.com',
			'account.editTitle' => '编辑账户',
			'account.addTitle' => '新建账户',
			'account.selectTypeTitle' => '选择账户类型',
			'account.nameLabel' => '账户名称',
			'account.amountLabel' => '当前余额',
			'account.currencyLabel' => '币种',
			'account.hiddenLabel' => '隐藏',
			'account.hiddenDesc' => '在账户列表中隐藏该账户',
			'account.includeInNetWorthLabel' => '计入资产',
			'account.includeInNetWorthDesc' => '用于净资产统计',
			'account.nameHint' => '例如：工资卡',
			'account.amountHint' => '0.00',
			'account.deleteAccount' => '删除账户',
			'account.deleteConfirm' => '确定要删除该账户吗？此操作无法撤销。',
			'account.save' => '保存修改',
			'account.assetsCategory' => '资产类',
			'account.liabilitiesCategory' => '负债/信用类',
			'account.cash' => '现金钱包',
			'account.deposit' => '银行存款',
			'account.creditCard' => '信用卡',
			'account.investment' => '投资理财',
			'account.eWallet' => '电子钱包',
			'account.loan' => '贷款账户',
			'account.receivable' => '应收款项',
			'account.payable' => '应付款项',
			'account.other' => '其他账户',
			'account.types.cashTitle' => '现金',
			'account.types.cashSubtitle' => '纸币、硬币等实体货币',
			'account.types.depositTitle' => '银行存款',
			'account.types.depositSubtitle' => '储蓄卡、活期/定期存款',
			'account.types.eMoneyTitle' => '电子钱包',
			'account.types.eMoneySubtitle' => '第三方支付平台余额',
			'account.types.investmentTitle' => '投资账户',
			'account.types.investmentSubtitle' => '股票、基金、债券等',
			'account.types.receivableTitle' => '应收款项',
			'account.types.receivableSubtitle' => '借出款项、待收账款',
			'account.types.receivableHelper' => '他人欠我',
			'account.types.creditCardTitle' => '信用卡',
			'account.types.creditCardSubtitle' => '信用卡账户欠款',
			'account.types.loanTitle' => '贷款',
			'account.types.loanSubtitle' => '房贷、车贷、消费贷等',
			'account.types.payableTitle' => '应付款项',
			'account.types.payableSubtitle' => '借入款项、待付账款',
			'account.types.payableHelper' => '我欠他人',
			'financial.title' => '财务',
			'financial.management' => '财务管理',
			'financial.netWorth' => '总净值',
			'financial.assets' => '总资产',
			'financial.liabilities' => '总负债',
			'financial.noAccounts' => '暂无账户',
			'financial.addFirstAccount' => '点击下方按钮添加您的第一个账户',
			'financial.assetAccounts' => '资产账户',
			'financial.liabilityAccounts' => '负债账户',
			'financial.selectCurrency' => '选择货币',
			'financial.cancel' => '取消',
			'financial.confirm' => '确定',
			'financial.settings' => '财务设置',
			'financial.budgetManagement' => '预算管理',
			'financial.recurringTransactions' => '周期交易',
			'financial.safetyThreshold' => '安全阈值',
			'financial.dailyBurnRate' => '每日消费',
			'financial.financialAssistant' => '财务助手',
			'financial.manageFinancialSettings' => '管理您的财务设置',
			'financial.safetyThresholdSettings' => '财务安全线设置',
			'financial.setSafetyThreshold' => '设置您的财务安全阈值',
			'financial.safetyThresholdSaved' => '财务安全线已保存',
			'financial.dailyBurnRateSettings' => '日常消费预估',
			'financial.setDailyBurnRate' => '设置您的日常消费预估金额',
			'financial.dailyBurnRateSaved' => '日常消费预估已保存',
			'financial.saveFailed' => '保存失败',
			'app.splashTitle' => '智见增长，格物致富。',
			'app.splashSubtitle' => '智能财务助手',
			'statistics.title' => '统计分析',
			'statistics.analyze' => '统计分析',
			'statistics.exportInProgress' => '导出功能开发中...',
			'statistics.ranking' => '大额消费排行',
			'statistics.noData' => '暂无数据',
			'statistics.overview.balance' => '总结余',
			'statistics.overview.income' => '总收入',
			'statistics.overview.expense' => '总支出',
			'statistics.trend.title' => '收支趋势',
			'statistics.trend.expense' => '支出',
			'statistics.trend.income' => '收入',
			'statistics.analysis.title' => '支出分析',
			'statistics.analysis.total' => '总计',
			'statistics.analysis.breakdown' => '支出分类明细',
			'statistics.filter.accountType' => '账户类型',
			'statistics.filter.allAccounts' => '全部账户',
			'statistics.filter.apply' => '确认应用',
			'statistics.sort.amount' => '按金额排序',
			'statistics.sort.date' => '按时间排序',
			'statistics.exportList' => '导出列表',
			'statistics.emptyState.title' => '开启财务洞察',
			'statistics.emptyState.description' => '您的财务报表目前是一张白纸。\n记录第一笔消费，让数据为您讲述财富故事。',
			'statistics.emptyState.action' => '记录首笔交易',
			'statistics.noMoreData' => '没有更多数据了',
			'currency.cny' => '人民币',
			'currency.usd' => '美元',
			'currency.eur' => '欧元',
			'currency.jpy' => '日元',
			'currency.gbp' => '英镑',
			'currency.aud' => '澳元',
			'currency.cad' => '加元',
			'currency.chf' => '瑞士法郎',
			'currency.rub' => '俄罗斯卢布',
			'currency.hkd' => '港币',
			'currency.twd' => '新台币',
			'currency.inr' => '印度卢比',
			'budgetSuggestion.highPercentage' => ({required Object category, required Object percentage}) => '${category} 占支出的 ${percentage}%，建议设置预算上限',
			'budgetSuggestion.monthlyIncrease' => ({required Object percentage}) => '本月支出增长了 ${percentage}%，需要关注',
			'budgetSuggestion.frequentSmall' => ({required Object category, required Object count}) => '${category} 有 ${count} 笔小额交易，可能是订阅消费',
			'budgetSuggestion.financialInsights' => '财务洞察',
			'server.title' => '连接服务器',
			'server.subtitle' => '输入您自部署的服务器地址，或扫描服务器启动时显示的二维码',
			'server.urlLabel' => '服务器地址',
			'server.urlPlaceholder' => '例如：https://api.example.com 或 192.168.1.100:8000',
			'server.scanQr' => '扫描二维码',
			'server.scanQrInstruction' => '对准服务器终端显示的二维码',
			'server.testConnection' => '测试连接',
			'server.connecting' => '正在连接...',
			'server.connected' => '已连接',
			'server.connectionFailed' => '连接失败',
			'server.continueToLogin' => '继续登录',
			'server.saveAndReturn' => '保存并返回',
			'server.serverSettings' => '服务器设置',
			'server.currentServer' => '当前服务器',
			'server.version' => '版本',
			'server.environment' => '环境',
			'server.changeServer' => '更换服务器',
			'server.changeServerWarning' => '更换服务器将退出登录，是否继续？',
			'server.error.urlRequired' => '请输入服务器地址',
			'server.error.invalidUrl' => 'URL 格式无效',
			'server.error.connectionTimeout' => '连接超时',
			'server.error.connectionRefused' => '无法连接到服务器',
			'server.error.sslError' => 'SSL 证书错误',
			'server.error.serverError' => '服务器错误',
			'sharedSpace.dashboard.cumulativeTotalExpense' => '累计总支出',
			'sharedSpace.dashboard.participatingMembers' => '参与成员',
			'sharedSpace.dashboard.membersCount' => ({required Object count}) => '${count} 人',
			'sharedSpace.dashboard.averagePerMember' => '成员人均',
			'sharedSpace.dashboard.spendingDistribution' => '成员消费分布',
			'sharedSpace.dashboard.realtimeUpdates' => '实时更新',
			'sharedSpace.dashboard.paid' => '已支付',
			'sharedSpace.roles.owner' => '主理人',
			'sharedSpace.roles.admin' => '管理员',
			'sharedSpace.roles.member' => '成员',
			'errorMapping.generic.badRequest' => '请求无效',
			'errorMapping.generic.authFailed' => '认证失败，请重新登录',
			'errorMapping.generic.permissionDenied' => '权限不足',
			'errorMapping.generic.notFound' => '资源未找到',
			'errorMapping.generic.serverError' => '服务器内部错误',
			'errorMapping.generic.systemError' => '系统错误',
			'errorMapping.generic.validationFailed' => '数据验证失败',
			'errorMapping.auth.failed' => '认证失败',
			'errorMapping.auth.emailWrong' => '邮箱错误',
			'errorMapping.auth.phoneWrong' => '手机号错误',
			'errorMapping.auth.phoneRegistered' => '该手机号已被注册',
			'errorMapping.auth.emailRegistered' => '该邮箱已被注册',
			'errorMapping.auth.sendFailed' => '验证码发送失败',
			'errorMapping.auth.expired' => '验证码已过期',
			'errorMapping.auth.tooFrequent' => '验证码发送太频繁',
			'errorMapping.auth.unsupportedType' => '不支持的验证码类型',
			'errorMapping.auth.wrongPassword' => '密码错误',
			'errorMapping.auth.userNotFound' => '用户不存在',
			'errorMapping.auth.prefsMissing' => '偏好设置参数缺失',
			'errorMapping.auth.invalidTimezone' => '无效的客户端时区',
			'errorMapping.transaction.commentEmpty' => '评论内容不能为空',
			'errorMapping.transaction.invalidParent' => '无效的父评论ID',
			'errorMapping.transaction.saveFailed' => '评论保存失败',
			'errorMapping.transaction.deleteFailed' => '评论删除失败',
			'errorMapping.transaction.notExists' => '交易记录不存在',
			'errorMapping.space.notFound' => '共享空间不存在或无权访问',
			'errorMapping.space.inviteDenied' => '无权邀请成员',
			'errorMapping.space.inviteSelf' => '不能邀请你自己',
			'errorMapping.space.inviteSent' => '邀请已发送',
			'errorMapping.space.alreadyMember' => '该用户已是成员或已被邀请',
			'errorMapping.space.invalidAction' => '无效操作',
			'errorMapping.space.invitationNotFound' => '邀请不存在',
			'errorMapping.space.onlyOwner' => '仅拥有者可执行此操作',
			'errorMapping.space.ownerNotRemovable' => '不能移除空间拥有者',
			'errorMapping.space.memberNotFound' => '成员不存在',
			'errorMapping.space.notMember' => '该用户不是此空间的成员',
			'errorMapping.space.ownerCantLeave' => '拥有者不能直接退出，请先转让所有权',
			'errorMapping.space.invalidCode' => '无效的邀请码',
			'errorMapping.space.codeExpired' => '邀请码已过期或达到上限',
			'errorMapping.recurring.invalidRule' => '无效的重复规则',
			'errorMapping.recurring.ruleNotFound' => '未找到重复规则',
			'errorMapping.upload.noFile' => '未上传文件',
			'errorMapping.upload.tooLarge' => '文件过大',
			'errorMapping.upload.unsupportedType' => '不支持的文件类型',
			'errorMapping.upload.tooManyFiles' => '文件数量过多',
			'errorMapping.ai.contextLimit' => '上下文长度超出限制',
			'errorMapping.ai.tokenLimit' => 'Token配额不足',
			'errorMapping.ai.emptyMessage' => '用户消息为空',
			_ => null,
		};
	}
}
