///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsZh = Translations; // ignore: unused_element
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
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsCommonZh common = TranslationsCommonZh.internal(_root);
	late final TranslationsTimeZh time = TranslationsTimeZh.internal(_root);
	late final TranslationsGreetingZh greeting = TranslationsGreetingZh.internal(_root);
	late final TranslationsNavigationZh navigation = TranslationsNavigationZh.internal(_root);
	late final TranslationsAuthZh auth = TranslationsAuthZh.internal(_root);
	late final TranslationsTransactionZh transaction = TranslationsTransactionZh.internal(_root);
	late final TranslationsHomeZh home = TranslationsHomeZh.internal(_root);
	late final TranslationsCommentZh comment = TranslationsCommentZh.internal(_root);
	late final TranslationsCalendarZh calendar = TranslationsCalendarZh.internal(_root);
	late final TranslationsCategoryZh category = TranslationsCategoryZh.internal(_root);
	late final TranslationsSettingsZh settings = TranslationsSettingsZh.internal(_root);
	late final TranslationsAppearanceZh appearance = TranslationsAppearanceZh.internal(_root);
	late final TranslationsSpeechZh speech = TranslationsSpeechZh.internal(_root);
	late final TranslationsAmountThemeZh amountTheme = TranslationsAmountThemeZh.internal(_root);
	late final TranslationsLocaleZh locale = TranslationsLocaleZh.internal(_root);
	late final TranslationsBudgetZh budget = TranslationsBudgetZh.internal(_root);
	late final TranslationsDateRangeZh dateRange = TranslationsDateRangeZh.internal(_root);
	late final TranslationsForecastZh forecast = TranslationsForecastZh.internal(_root);
	late final TranslationsChatZh chat = TranslationsChatZh.internal(_root);
	late final TranslationsFootprintZh footprint = TranslationsFootprintZh.internal(_root);
	late final TranslationsMediaZh media = TranslationsMediaZh.internal(_root);
	late final TranslationsErrorZh error = TranslationsErrorZh.internal(_root);
	late final TranslationsFontTestZh fontTest = TranslationsFontTestZh.internal(_root);
	late final TranslationsWizardZh wizard = TranslationsWizardZh.internal(_root);
	late final TranslationsUserZh user = TranslationsUserZh.internal(_root);
	late final TranslationsAccountZh account = TranslationsAccountZh.internal(_root);
	late final TranslationsFinancialZh financial = TranslationsFinancialZh.internal(_root);
	late final TranslationsAppZh app = TranslationsAppZh.internal(_root);
	late final TranslationsStatisticsZh statistics = TranslationsStatisticsZh.internal(_root);
	late final TranslationsCurrencyZh currency = TranslationsCurrencyZh.internal(_root);
	late final TranslationsBudgetSuggestionZh budgetSuggestion = TranslationsBudgetSuggestionZh.internal(_root);
	late final TranslationsServerZh server = TranslationsServerZh.internal(_root);
	late final TranslationsErrorMappingZh errorMapping = TranslationsErrorMappingZh.internal(_root);
}

// Path: common
class TranslationsCommonZh {
	TranslationsCommonZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '加载中...'
	String get loading => '加载中...';

	/// zh: '错误'
	String get error => '错误';

	/// zh: '重试'
	String get retry => '重试';

	/// zh: '取消'
	String get cancel => '取消';

	/// zh: '确认'
	String get confirm => '确认';

	/// zh: '保存'
	String get save => '保存';

	/// zh: '删除'
	String get delete => '删除';

	/// zh: '编辑'
	String get edit => '编辑';

	/// zh: '添加'
	String get add => '添加';

	/// zh: '搜索'
	String get search => '搜索';

	/// zh: '筛选'
	String get filter => '筛选';

	/// zh: '排序'
	String get sort => '排序';

	/// zh: '刷新'
	String get refresh => '刷新';

	/// zh: '更多'
	String get more => '更多';

	/// zh: '收起'
	String get less => '收起';

	/// zh: '全部'
	String get all => '全部';

	/// zh: '无'
	String get none => '无';

	/// zh: '确定'
	String get ok => '确定';

	/// zh: '未知'
	String get unknown => '未知';

	/// zh: '暂无数据'
	String get noData => '暂无数据';

	/// zh: '加载更多'
	String get loadMore => '加载更多';

	/// zh: '没有更多了'
	String get noMore => '没有更多了';

	/// zh: '加载失败'
	String get loadFailed => '加载失败';

	/// zh: '交易记录'
	String get history => '交易记录';

	/// zh: '重置'
	String get reset => '重置';
}

// Path: time
class TranslationsTimeZh {
	TranslationsTimeZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '今天'
	String get today => '今天';

	/// zh: '昨天'
	String get yesterday => '昨天';

	/// zh: '前天'
	String get dayBeforeYesterday => '前天';

	/// zh: '本周'
	String get thisWeek => '本周';

	/// zh: '本月'
	String get thisMonth => '本月';

	/// zh: '今年'
	String get thisYear => '今年';

	/// zh: '选择日期'
	String get selectDate => '选择日期';

	/// zh: '选择时间'
	String get selectTime => '选择时间';

	/// zh: '刚刚'
	String get justNow => '刚刚';

	/// zh: '$count分钟前'
	String minutesAgo({required Object count}) => '${count}分钟前';

	/// zh: '$count小时前'
	String hoursAgo({required Object count}) => '${count}小时前';

	/// zh: '$count天前'
	String daysAgo({required Object count}) => '${count}天前';

	/// zh: '$count周前'
	String weeksAgo({required Object count}) => '${count}周前';
}

// Path: greeting
class TranslationsGreetingZh {
	TranslationsGreetingZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '上午好'
	String get morning => '上午好';

	/// zh: '下午好'
	String get afternoon => '下午好';

	/// zh: '晚上好'
	String get evening => '晚上好';
}

// Path: navigation
class TranslationsNavigationZh {
	TranslationsNavigationZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '首页'
	String get home => '首页';

	/// zh: '预测'
	String get forecast => '预测';

	/// zh: '足迹'
	String get footprint => '足迹';

	/// zh: '我的'
	String get profile => '我的';
}

// Path: auth
class TranslationsAuthZh {
	TranslationsAuthZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '登录'
	String get login => '登录';

	/// zh: '登录中...'
	String get loggingIn => '登录中...';

	/// zh: '退出'
	String get logout => '退出';

	/// zh: '已成功退出登录'
	String get logoutSuccess => '已成功退出登录';

	/// zh: '确认退出登录'
	String get confirmLogoutTitle => '确认退出登录';

	/// zh: '您确定要退出当前的登录状态吗？'
	String get confirmLogoutContent => '您确定要退出当前的登录状态吗？';

	/// zh: '注册'
	String get register => '注册';

	/// zh: '注册中...'
	String get registering => '注册中...';

	/// zh: '欢迎回来'
	String get welcomeBack => '欢迎回来';

	/// zh: '欢迎回来!'
	String get loginSuccess => '欢迎回来!';

	/// zh: '登录失败'
	String get loginFailed => '登录失败';

	/// zh: '请稍后重试。'
	String get pleaseTryAgain => '请稍后重试。';

	/// zh: '登录以继续使用 AI 记账助理'
	String get loginSubtitle => '登录以继续使用 AI 记账助理';

	/// zh: '还没有账户？注册'
	String get noAccount => '还没有账户？注册';

	/// zh: '创建您的账户'
	String get createAccount => '创建您的账户';

	/// zh: '设置密码'
	String get setPassword => '设置密码';

	/// zh: '设置您的账户密码'
	String get setAccountPassword => '设置您的账户密码';

	/// zh: '完成注册'
	String get completeRegistration => '完成注册';

	/// zh: '注册成功!'
	String get registrationSuccess => '注册成功!';

	/// zh: '注册失败'
	String get registrationFailed => '注册失败';

	late final TranslationsAuthEmailZh email = TranslationsAuthEmailZh.internal(_root);
	late final TranslationsAuthPasswordZh password = TranslationsAuthPasswordZh.internal(_root);
	late final TranslationsAuthVerificationCodeZh verificationCode = TranslationsAuthVerificationCodeZh.internal(_root);
}

// Path: transaction
class TranslationsTransactionZh {
	TranslationsTransactionZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '支出'
	String get expense => '支出';

	/// zh: '收入'
	String get income => '收入';

	/// zh: '转账'
	String get transfer => '转账';

	/// zh: '金额'
	String get amount => '金额';

	/// zh: '分类'
	String get category => '分类';

	/// zh: '描述'
	String get description => '描述';

	/// zh: '标签'
	String get tags => '标签';

	/// zh: '保存记账'
	String get saveTransaction => '保存记账';

	/// zh: '请输入金额'
	String get pleaseEnterAmount => '请输入金额';

	/// zh: '请选择分类'
	String get pleaseSelectCategory => '请选择分类';

	/// zh: '保存失败'
	String get saveFailed => '保存失败';

	/// zh: '记录这笔交易的详细信息...'
	String get descriptionHint => '记录这笔交易的详细信息...';

	/// zh: '添加自定义标签'
	String get addCustomTag => '添加自定义标签';

	/// zh: '常用标签'
	String get commonTags => '常用标签';

	/// zh: '最多添加 $maxTags 个标签'
	String maxTagsHint({required Object maxTags}) => '最多添加 ${maxTags} 个标签';

	/// zh: '没有找到交易记录'
	String get noTransactionsFound => '没有找到交易记录';

	/// zh: '尝试调整搜索条件或创建新的交易记录'
	String get tryAdjustingSearch => '尝试调整搜索条件或创建新的交易记录';

	/// zh: '无描述'
	String get noDescription => '无描述';

	/// zh: '支付'
	String get payment => '支付';

	/// zh: '账户'
	String get account => '账户';

	/// zh: '时间'
	String get time => '时间';

	/// zh: '地点'
	String get location => '地点';

	/// zh: '交易详情'
	String get transactionDetail => '交易详情';

	/// zh: '收藏'
	String get favorite => '收藏';

	/// zh: '确认删除'
	String get confirmDelete => '确认删除';

	/// zh: '您确定要删除此条交易记录吗？此操作无法撤销。'
	String get deleteTransactionConfirm => '您确定要删除此条交易记录吗？此操作无法撤销。';

	/// zh: '没有可用的操作'
	String get noActions => '没有可用的操作';

	/// zh: '已删除'
	String get deleted => '已删除';

	/// zh: '删除失败，请稍后重试'
	String get deleteFailed => '删除失败，请稍后重试';

	/// zh: '关联账户'
	String get linkedAccount => '关联账户';

	/// zh: '关联空间'
	String get linkedSpace => '关联空间';

	/// zh: '未关联'
	String get notLinked => '未关联';

	/// zh: '关联'
	String get link => '关联';

	/// zh: '更换账户'
	String get changeAccount => '更换账户';

	/// zh: '添加空间'
	String get addSpace => '添加空间';

	/// zh: '$count 个空间'
	String nSpaces({required Object count}) => '${count} 个空间';

	/// zh: '选择关联账户'
	String get selectLinkedAccount => '选择关联账户';

	/// zh: '选择关联空间'
	String get selectLinkedSpace => '选择关联空间';

	/// zh: '暂无可用空间'
	String get noSpacesAvailable => '暂无可用空间';

	/// zh: '关联成功'
	String get linkSuccess => '关联成功';

	/// zh: '关联失败'
	String get linkFailed => '关联失败';

	/// zh: '消息'
	String get rawInput => '消息';

	/// zh: '无消息'
	String get noRawInput => '无消息';
}

// Path: home
class TranslationsHomeZh {
	TranslationsHomeZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '总消费金额'
	String get totalExpense => '总消费金额';

	/// zh: '今日支出'
	String get todayExpense => '今日支出';

	/// zh: '本月支出'
	String get monthExpense => '本月支出';

	/// zh: '$year年进度'
	String yearProgress({required Object year}) => '${year}年进度';

	/// zh: '••••••••'
	String get amountHidden => '••••••••';

	/// zh: '加载失败'
	String get loadFailed => '加载失败';

	/// zh: '暂无交易记录'
	String get noTransactions => '暂无交易记录';

	/// zh: '刷新试试'
	String get tryRefresh => '刷新试试';

	/// zh: '没有更多数据了'
	String get noMoreData => '没有更多数据了';

	/// zh: '用户未登录，无法加载数据'
	String get userNotLoggedIn => '用户未登录，无法加载数据';
}

// Path: comment
class TranslationsCommentZh {
	TranslationsCommentZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '错误'
	String get error => '错误';

	/// zh: '评论失败'
	String get commentFailed => '评论失败';

	/// zh: '回复 @$name:'
	String replyToPrefix({required Object name}) => '回复 @${name}:';

	/// zh: '回复'
	String get reply => '回复';

	/// zh: '添加备注...'
	String get addNote => '添加备注...';

	/// zh: '确认删除'
	String get confirmDeleteTitle => '确认删除';

	/// zh: '你确定要删除这条评论吗？此操作无法撤销。'
	String get confirmDeleteContent => '你确定要删除这条评论吗？此操作无法撤销。';

	/// zh: '成功'
	String get success => '成功';

	/// zh: '评论已删除'
	String get commentDeleted => '评论已删除';

	/// zh: '删除失败'
	String get deleteFailed => '删除失败';

	/// zh: '删除评论'
	String get deleteComment => '删除评论';

	/// zh: '提示'
	String get hint => '提示';

	/// zh: '没有可用的操作'
	String get noActions => '没有可用的操作';

	/// zh: '备注'
	String get note => '备注';

	/// zh: '暂无备注'
	String get noNote => '暂无备注';

	/// zh: '加载备注失败'
	String get loadFailed => '加载备注失败';
}

// Path: calendar
class TranslationsCalendarZh {
	TranslationsCalendarZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '消费日历'
	String get title => '消费日历';

	late final TranslationsCalendarWeekdaysZh weekdays = TranslationsCalendarWeekdaysZh.internal(_root);

	/// zh: '加载日历数据失败'
	String get loadFailed => '加载日历数据失败';

	/// zh: '本月: $amount'
	String thisMonth({required Object amount}) => '本月: ${amount}';

	/// zh: '统计中...'
	String get counting => '统计中...';

	/// zh: '无法统计'
	String get unableToCount => '无法统计';

	/// zh: '趋势: '
	String get trend => '趋势: ';

	/// zh: '当日无交易记录'
	String get noTransactionsTitle => '当日无交易记录';

	/// zh: '加载交易失败'
	String get loadTransactionFailed => '加载交易失败';
}

// Path: category
class TranslationsCategoryZh {
	TranslationsCategoryZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '日常消费'
	String get dailyConsumption => '日常消费';

	/// zh: '交通出行'
	String get transportation => '交通出行';

	/// zh: '医疗健康'
	String get healthcare => '医疗健康';

	/// zh: '住房物业'
	String get housing => '住房物业';

	/// zh: '教育培训'
	String get education => '教育培训';

	/// zh: '收入进账'
	String get incomeCategory => '收入进账';

	/// zh: '社交馈赠'
	String get socialGifts => '社交馈赠';

	/// zh: '资金周转'
	String get moneyTransfer => '资金周转';

	/// zh: '其他'
	String get other => '其他';

	/// zh: '餐饮美食'
	String get foodDining => '餐饮美食';

	/// zh: '购物消费'
	String get shoppingRetail => '购物消费';

	/// zh: '居住物业'
	String get housingUtilities => '居住物业';

	/// zh: '个人护理'
	String get personalCare => '个人护理';

	/// zh: '休闲娱乐'
	String get entertainment => '休闲娱乐';

	/// zh: '医疗健康'
	String get medicalHealth => '医疗健康';

	/// zh: '保险'
	String get insurance => '保险';

	/// zh: '人情往来'
	String get socialGifting => '人情往来';

	/// zh: '金融税务'
	String get financialTax => '金融税务';

	/// zh: '其他支出'
	String get others => '其他支出';

	/// zh: '工资薪水'
	String get salaryWage => '工资薪水';

	/// zh: '经营交易'
	String get businessTrade => '经营交易';

	/// zh: '投资回报'
	String get investmentReturns => '投资回报';

	/// zh: '礼金红包'
	String get giftBonus => '礼金红包';

	/// zh: '退款返利'
	String get refundRebate => '退款返利';

	/// zh: '转账'
	String get generalTransfer => '转账';

	/// zh: '债务还款'
	String get debtRepayment => '债务还款';
}

// Path: settings
class TranslationsSettingsZh {
	TranslationsSettingsZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '设置'
	String get title => '设置';

	/// zh: '语言'
	String get language => '语言';

	/// zh: '语言设置'
	String get languageSettings => '语言设置';

	/// zh: '选择语言'
	String get selectLanguage => '选择语言';

	/// zh: '语言已更改'
	String get languageChanged => '语言已更改';

	/// zh: '重启应用以应用更改'
	String get restartToApply => '重启应用以应用更改';

	/// zh: '主题'
	String get theme => '主题';

	/// zh: '深色模式'
	String get darkMode => '深色模式';

	/// zh: '浅色模式'
	String get lightMode => '浅色模式';

	/// zh: '跟随系统'
	String get systemMode => '跟随系统';

	/// zh: '开发者选项'
	String get developerOptions => '开发者选项';

	/// zh: '认证状态调试'
	String get authDebug => '认证状态调试';

	/// zh: '查看认证状态和调试信息'
	String get authDebugSubtitle => '查看认证状态和调试信息';

	/// zh: '字体测试'
	String get fontTest => '字体测试';

	/// zh: '测试应用字体显示效果'
	String get fontTestSubtitle => '测试应用字体显示效果';

	/// zh: '帮助与反馈'
	String get helpAndFeedback => '帮助与反馈';

	/// zh: '获取帮助或提供反馈'
	String get helpAndFeedbackSubtitle => '获取帮助或提供反馈';

	/// zh: '关于应用'
	String get aboutApp => '关于应用';

	/// zh: '版本信息和开发者信息'
	String get aboutAppSubtitle => '版本信息和开发者信息';

	/// zh: '已切换为 $currency，新交易将以此货币记录'
	String currencyChangedRefreshHint({required Object currency}) => '已切换为 ${currency}，新交易将以此货币记录';

	/// zh: '共享空间'
	String get sharedSpace => '共享空间';

	/// zh: '语音识别'
	String get speechRecognition => '语音识别';

	/// zh: '配置语音输入参数'
	String get speechRecognitionSubtitle => '配置语音输入参数';

	/// zh: '金额显示样式'
	String get amountDisplayStyle => '金额显示样式';

	/// zh: '显示币种'
	String get currency => '显示币种';

	/// zh: '外观设置'
	String get appearance => '外观设置';

	/// zh: '主题模式与配色方案'
	String get appearanceSubtitle => '主题模式与配色方案';

	/// zh: '语音测试'
	String get speechTest => '语音测试';

	/// zh: '测试 WebSocket 语音连接'
	String get speechTestSubtitle => '测试 WebSocket 语音连接';

	/// zh: '普通用户'
	String get userTypeRegular => '普通用户';

	/// zh: '选择金额显示样式'
	String get selectAmountStyle => '选择金额显示样式';

	/// zh: '注意：金额样式主要应用于「交易流水」和「趋势分析」。为了保持视觉清晰，「账户余额」和「资产概览」等状态类数值将保持中性颜色。'
	String get amountStyleNotice => '注意：金额样式主要应用于「交易流水」和「趋势分析」。为了保持视觉清晰，「账户余额」和「资产概览」等状态类数值将保持中性颜色。';

	/// zh: '选择您的主要货币。未来的记账将默认使用此货币，统计和汇总也将以此货币显示。历史交易的原始金额不受影响。'
	String get currencyDescription => '选择您的主要货币。未来的记账将默认使用此货币，统计和汇总也将以此货币显示。历史交易的原始金额不受影响。';

	/// zh: '修改用户名'
	String get editUsername => '修改用户名';

	/// zh: '请输入用户名'
	String get enterUsername => '请输入用户名';

	/// zh: '用户名不能为空'
	String get usernameRequired => '用户名不能为空';

	/// zh: '用户名已更新'
	String get usernameUpdated => '用户名已更新';

	/// zh: '头像已更新'
	String get avatarUpdated => '头像已更新';

	/// zh: '外观设置已更新'
	String get appearanceUpdated => '外观设置已更新';
}

// Path: appearance
class TranslationsAppearanceZh {
	TranslationsAppearanceZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '外观设置'
	String get title => '外观设置';

	/// zh: '主题模式'
	String get themeMode => '主题模式';

	/// zh: '浅色'
	String get light => '浅色';

	/// zh: '深色'
	String get dark => '深色';

	/// zh: '跟随系统'
	String get system => '跟随系统';

	/// zh: '配色方案'
	String get colorScheme => '配色方案';

	late final TranslationsAppearancePalettesZh palettes = TranslationsAppearancePalettesZh.internal(_root);
}

// Path: speech
class TranslationsSpeechZh {
	TranslationsSpeechZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '语音识别设置'
	String get title => '语音识别设置';

	/// zh: '语音识别服务'
	String get service => '语音识别服务';

	/// zh: '系统语音'
	String get systemVoice => '系统语音';

	/// zh: '使用手机内置的语音识别服务（推荐）'
	String get systemVoiceSubtitle => '使用手机内置的语音识别服务（推荐）';

	/// zh: '自建 ASR 服务'
	String get selfHostedASR => '自建 ASR 服务';

	/// zh: '使用 WebSocket 连接到自建语音识别服务'
	String get selfHostedASRSubtitle => '使用 WebSocket 连接到自建语音识别服务';

	/// zh: '服务器配置'
	String get serverConfig => '服务器配置';

	/// zh: '服务器地址'
	String get serverAddress => '服务器地址';

	/// zh: '端口'
	String get port => '端口';

	/// zh: '路径'
	String get path => '路径';

	/// zh: '保存配置'
	String get saveConfig => '保存配置';

	/// zh: '信息'
	String get info => '信息';

	/// zh: '• 系统语音：使用设备内置服务，无需配置，响应更快 • 自建 ASR：适用于自定义模型或离线场景 更改将在下次使用语音输入时生效。'
	String get infoContent => '• 系统语音：使用设备内置服务，无需配置，响应更快\n• 自建 ASR：适用于自定义模型或离线场景\n\n更改将在下次使用语音输入时生效。';

	/// zh: '请输入服务器地址'
	String get enterAddress => '请输入服务器地址';

	/// zh: '请输入有效的端口 (1-65535)'
	String get enterValidPort => '请输入有效的端口 (1-65535)';

	/// zh: '配置已保存'
	String get configSaved => '配置已保存';
}

// Path: amountTheme
class TranslationsAmountThemeZh {
	TranslationsAmountThemeZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '中国市场习惯'
	String get chinaMarket => '中国市场习惯';

	/// zh: '红涨绿跌/黑跌 (推荐)'
	String get chinaMarketDesc => '红涨绿跌/黑跌 (推荐)';

	/// zh: '国际标准'
	String get international => '国际标准';

	/// zh: '绿涨红跌'
	String get internationalDesc => '绿涨红跌';

	/// zh: '极简模式'
	String get minimalist => '极简模式';

	/// zh: '仅通过符号区分'
	String get minimalistDesc => '仅通过符号区分';

	/// zh: '色弱友好'
	String get colorBlind => '色弱友好';

	/// zh: '蓝橙配色方案'
	String get colorBlindDesc => '蓝橙配色方案';
}

// Path: locale
class TranslationsLocaleZh {
	TranslationsLocaleZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '中文（简体）'
	String get chinese => '中文（简体）';

	/// zh: '中文（繁体）'
	String get traditionalChinese => '中文（繁体）';

	/// zh: 'English'
	String get english => 'English';

	/// zh: '日本語'
	String get japanese => '日本語';

	/// zh: '한국어'
	String get korean => '한국어';
}

// Path: budget
class TranslationsBudgetZh {
	TranslationsBudgetZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '预算管理'
	String get title => '预算管理';

	/// zh: '预算详情'
	String get detail => '预算详情';

	/// zh: '预算信息'
	String get info => '预算信息';

	/// zh: '总预算'
	String get totalBudget => '总预算';

	/// zh: '分类预算'
	String get categoryBudget => '分类预算';

	/// zh: '本月预算汇总'
	String get monthlySummary => '本月预算汇总';

	/// zh: '已使用'
	String get used => '已使用';

	/// zh: '剩余'
	String get remaining => '剩余';

	/// zh: '超支'
	String get overspent => '超支';

	/// zh: '预算'
	String get budget => '预算';

	/// zh: '加载失败'
	String get loadFailed => '加载失败';

	/// zh: '暂无预算'
	String get noBudget => '暂无预算';

	/// zh: '通过 Augo 助手说"帮我设置预算"来创建'
	String get createHint => '通过 Augo 助手说"帮我设置预算"来创建';

	/// zh: '已暂停'
	String get paused => '已暂停';

	/// zh: '暂停'
	String get pause => '暂停';

	/// zh: '恢复'
	String get resume => '恢复';

	/// zh: '预算已暂停'
	String get budgetPaused => '预算已暂停';

	/// zh: '预算已恢复'
	String get budgetResumed => '预算已恢复';

	/// zh: '操作失败'
	String get operationFailed => '操作失败';

	/// zh: '删除预算'
	String get deleteBudget => '删除预算';

	/// zh: '确定要删除这个预算吗？此操作不可撤销。'
	String get deleteConfirm => '确定要删除这个预算吗？此操作不可撤销。';

	/// zh: '类型'
	String get type => '类型';

	/// zh: '分类'
	String get category => '分类';

	/// zh: '周期'
	String get period => '周期';

	/// zh: '滚动预算'
	String get rollover => '滚动预算';

	/// zh: '滚动余额'
	String get rolloverBalance => '滚动余额';

	/// zh: '开启'
	String get enabled => '开启';

	/// zh: '关闭'
	String get disabled => '关闭';

	/// zh: '预算正常'
	String get statusNormal => '预算正常';

	/// zh: '接近上限'
	String get statusWarning => '接近上限';

	/// zh: '已超支'
	String get statusOverspent => '已超支';

	/// zh: '目标达成'
	String get statusAchieved => '目标达成';

	/// zh: '还剩 $amount 可用'
	String tipNormal({required Object amount}) => '还剩 ${amount} 可用';

	/// zh: '仅剩 $amount，请注意控制'
	String tipWarning({required Object amount}) => '仅剩 ${amount}，请注意控制';

	/// zh: '已超支 $amount'
	String tipOverspent({required Object amount}) => '已超支 ${amount}';

	/// zh: '恭喜完成储蓄目标！'
	String get tipAchieved => '恭喜完成储蓄目标！';

	/// zh: '剩余 $amount'
	String remainingAmount({required Object amount}) => '剩余 ${amount}';

	/// zh: '超支 $amount'
	String overspentAmount({required Object amount}) => '超支 ${amount}';

	/// zh: '预算 $amount'
	String budgetAmount({required Object amount}) => '预算 ${amount}';

	/// zh: '活跃'
	String get active => '活跃';

	/// zh: '全部'
	String get all => '全部';

	/// zh: '预算不存在或已被删除'
	String get notFound => '预算不存在或已被删除';

	/// zh: '预算设置'
	String get setup => '预算设置';

	/// zh: '预算设置'
	String get settings => '预算设置';

	/// zh: '设置预算金额'
	String get setAmount => '设置预算金额';

	/// zh: '为每个分类设置预算金额'
	String get setAmountDesc => '为每个分类设置预算金额';

	/// zh: '月度预算'
	String get monthly => '月度预算';

	/// zh: '按月管理您的支出，适合大多数人'
	String get monthlyDesc => '按月管理您的支出，适合大多数人';

	/// zh: '周预算'
	String get weekly => '周预算';

	/// zh: '按周管理支出，更精细的控制'
	String get weeklyDesc => '按周管理支出，更精细的控制';

	/// zh: '年度预算'
	String get yearly => '年度预算';

	/// zh: '长期财务规划，适合大额支出管理'
	String get yearlyDesc => '长期财务规划，适合大额支出管理';

	/// zh: '编辑预算'
	String get editBudget => '编辑预算';

	/// zh: '修改预算金额和分类'
	String get editBudgetDesc => '修改预算金额和分类';

	/// zh: '提醒设置'
	String get reminderSettings => '提醒设置';

	/// zh: '设置预算提醒和通知'
	String get reminderSettingsDesc => '设置预算提醒和通知';

	/// zh: '预算报告'
	String get report => '预算报告';

	/// zh: '查看详细的预算分析报告'
	String get reportDesc => '查看详细的预算分析报告';

	/// zh: '欢迎使用预算功能！'
	String get welcome => '欢迎使用预算功能！';

	/// zh: '创建新的预算计划'
	String get createNewPlan => '创建新的预算计划';

	/// zh: '通过设置预算，您可以更好地控制支出，实现财务目标。让我们开始设置您的第一个预算计划吧！'
	String get welcomeDesc => '通过设置预算，您可以更好地控制支出，实现财务目标。让我们开始设置您的第一个预算计划吧！';

	/// zh: '为不同的支出类别设置预算限额，帮助您更好地管理财务。'
	String get createDesc => '为不同的支出类别设置预算限额，帮助您更好地管理财务。';

	/// zh: '新建预算'
	String get newBudget => '新建预算';

	/// zh: '预算金额'
	String get budgetAmountLabel => '预算金额';

	/// zh: '货币'
	String get currency => '货币';

	/// zh: '周期设置'
	String get periodSettings => '周期设置';

	/// zh: '开启后按规则自动生成交易'
	String get autoGenerateTransactions => '开启后按规则自动生成交易';

	/// zh: '周期'
	String get cycle => '周期';

	/// zh: '预算分类'
	String get budgetCategory => '预算分类';

	/// zh: '高级选项'
	String get advancedOptions => '高级选项';

	/// zh: '周期类型'
	String get periodType => '周期类型';

	/// zh: '起算日'
	String get anchorDay => '起算日';

	/// zh: '选择周期类型'
	String get selectPeriodType => '选择周期类型';

	/// zh: '选择起算日'
	String get selectAnchorDay => '选择起算日';

	/// zh: '未用完的预算结转到下期'
	String get rolloverDescription => '未用完的预算结转到下期';

	/// zh: '创建预算'
	String get createBudget => '创建预算';

	/// zh: '保存'
	String get save => '保存';

	/// zh: '请输入预算金额'
	String get pleaseEnterAmount => '请输入预算金额';

	/// zh: '请输入有效的预算金额'
	String get invalidAmount => '请输入有效的预算金额';

	/// zh: '预算更新成功'
	String get updateSuccess => '预算更新成功';

	/// zh: '预算创建成功'
	String get createSuccess => '预算创建成功';

	/// zh: '预算已删除'
	String get deleteSuccess => '预算已删除';

	/// zh: '删除失败'
	String get deleteFailed => '删除失败';

	/// zh: '每月 $day 号'
	String everyMonthDay({required Object day}) => '每月 ${day} 号';

	/// zh: '每周'
	String get periodWeekly => '每周';

	/// zh: '双周'
	String get periodBiweekly => '双周';

	/// zh: '每月'
	String get periodMonthly => '每月';

	/// zh: '每年'
	String get periodYearly => '每年';

	/// zh: '进行中'
	String get statusActive => '进行中';

	/// zh: '已归档'
	String get statusArchived => '已归档';

	/// zh: '正常'
	String get periodStatusOnTrack => '正常';

	/// zh: '预警'
	String get periodStatusWarning => '预警';

	/// zh: '超支'
	String get periodStatusExceeded => '超支';

	/// zh: '达成'
	String get periodStatusAchieved => '达成';

	/// zh: '$percent% 已使用'
	String usedPercent({required Object percent}) => '${percent}% 已使用';

	/// zh: '$day 号'
	String dayOfMonth({required Object day}) => '${day} 号';

	/// zh: '万'
	String get tenThousandSuffix => '万';
}

// Path: dateRange
class TranslationsDateRangeZh {
	TranslationsDateRangeZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '自定义'
	String get custom => '自定义';

	/// zh: '选择时间范围'
	String get pickerTitle => '选择时间范围';

	/// zh: '开始日期'
	String get startDate => '开始日期';

	/// zh: '结束日期'
	String get endDate => '结束日期';

	/// zh: '请选择日期范围'
	String get hint => '请选择日期范围';
}

// Path: forecast
class TranslationsForecastZh {
	TranslationsForecastZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '预测'
	String get title => '预测';

	/// zh: '基于您的财务数据智能预测未来现金流'
	String get subtitle => '基于您的财务数据智能预测未来现金流';

	/// zh: '你好，我是你的财务领航员'
	String get financialNavigator => '你好，我是你的财务领航员';

	/// zh: '只需3步，我们一起绘制你未来的财务地图'
	String get financialMapSubtitle => '只需3步，我们一起绘制你未来的财务地图';

	/// zh: '预测未来现金流'
	String get predictCashFlow => '预测未来现金流';

	/// zh: '看清每一天的财务状况'
	String get predictCashFlowDesc => '看清每一天的财务状况';

	/// zh: 'AI智能建议'
	String get aiSmartSuggestions => 'AI智能建议';

	/// zh: '个性化的财务决策指导'
	String get aiSmartSuggestionsDesc => '个性化的财务决策指导';

	/// zh: '风险预警'
	String get riskWarning => '风险预警';

	/// zh: '提前发现潜在的财务风险'
	String get riskWarningDesc => '提前发现潜在的财务风险';

	/// zh: '我正在分析你的财务数据，生成未来30天的现金流预测'
	String get analyzing => '我正在分析你的财务数据，生成未来30天的现金流预测';

	/// zh: '分析收入支出模式'
	String get analyzePattern => '分析收入支出模式';

	/// zh: '计算现金流趋势'
	String get calculateTrend => '计算现金流趋势';

	/// zh: '生成风险预警'
	String get generateWarning => '生成风险预警';

	/// zh: '正在加载财务预测...'
	String get loadingForecast => '正在加载财务预测...';

	/// zh: '今日'
	String get todayLabel => '今日';

	/// zh: '明日'
	String get tomorrowLabel => '明日';

	/// zh: '余额'
	String get balanceLabel => '余额';

	/// zh: '无特殊事件'
	String get noSpecialEvents => '无特殊事件';

	/// zh: '财务安全线'
	String get financialSafetyLine => '财务安全线';

	/// zh: '当前设置'
	String get currentSetting => '当前设置';

	/// zh: '日常消费预估'
	String get dailySpendingEstimate => '日常消费预估';

	/// zh: '调整每日消费预测金额'
	String get adjustDailySpendingAmount => '调整每日消费预测金额';

	/// zh: '告诉我你的财务"安心线"是多少？'
	String get tellMeYourSafetyLine => '告诉我你的财务"安心线"是多少？';

	/// zh: '这是你希望账户保持的最低余额，当余额接近这个数值时，我会提醒你注意财务风险。'
	String get safetyLineDescription => '这是你希望账户保持的最低余额，当余额接近这个数值时，我会提醒你注意财务风险。';

	/// zh: '每天的"小日子"大概花多少？'
	String get dailySpendingQuestion => '每天的"小日子"大概花多少？';

	/// zh: '包括吃饭、交通、购物等日常开销 这只是一个初始估算，我会通过你未来的真实记录，让预测越来越准'
	String get dailySpendingDescription => '包括吃饭、交通、购物等日常开销\n这只是一个初始估算，我会通过你未来的真实记录，让预测越来越准';

	/// zh: '每天'
	String get perDay => '每天';

	/// zh: '参考标准'
	String get referenceStandard => '参考标准';

	/// zh: '节俭型'
	String get frugalType => '节俭型';

	/// zh: '舒适型'
	String get comfortableType => '舒适型';

	/// zh: '宽松型'
	String get relaxedType => '宽松型';

	/// zh: '50-100元/天'
	String get frugalAmount => '50-100元/天';

	/// zh: '100-200元/天'
	String get comfortableAmount => '100-200元/天';

	/// zh: '200-300元/天'
	String get relaxedAmount => '200-300元/天';

	late final TranslationsForecastRecurringTransactionZh recurringTransaction = TranslationsForecastRecurringTransactionZh.internal(_root);
}

// Path: chat
class TranslationsChatZh {
	TranslationsChatZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '新聊天'
	String get newChat => '新聊天';

	/// zh: '没有消息可显示。'
	String get noMessages => '没有消息可显示。';

	/// zh: '加载失败'
	String get loadingFailed => '加载失败';

	/// zh: '输入消息...'
	String get inputMessage => '输入消息...';

	/// zh: '正在聆听...'
	String get listening => '正在聆听...';

	/// zh: '正在处理...'
	String get aiThinking => '正在处理...';

	late final TranslationsChatToolsZh tools = TranslationsChatToolsZh.internal(_root);

	/// zh: '未识别到语音，请重试'
	String get speechNotRecognized => '未识别到语音，请重试';

	/// zh: '当前支出'
	String get currentExpense => '当前支出';

	/// zh: '正在加载组件...'
	String get loadingComponent => '正在加载组件...';

	/// zh: '暂无历史会话'
	String get noHistory => '暂无历史会话';

	/// zh: '开启一段新对话吧！'
	String get startNewChat => '开启一段新对话吧！';

	/// zh: '搜索会话'
	String get searchHint => '搜索会话';

	/// zh: '库'
	String get library => '库';

	/// zh: '查看个人资料'
	String get viewProfile => '查看个人资料';

	/// zh: '未找到相关会话'
	String get noRelatedFound => '未找到相关会话';

	/// zh: '尝试搜索其他关键词'
	String get tryOtherKeywords => '尝试搜索其他关键词';

	/// zh: '搜索失败'
	String get searchFailed => '搜索失败';

	/// zh: '删除会话'
	String get deleteConversation => '删除会话';

	/// zh: '确定要删除这个会话吗？此操作无法撤销。'
	String get deleteConversationConfirm => '确定要删除这个会话吗？此操作无法撤销。';

	/// zh: '会话已删除'
	String get conversationDeleted => '会话已删除';

	/// zh: '删除会话失败'
	String get deleteConversationFailed => '删除会话失败';

	late final TranslationsChatTransferWizardZh transferWizard = TranslationsChatTransferWizardZh.internal(_root);
	late final TranslationsChatGenuiZh genui = TranslationsChatGenuiZh.internal(_root);
}

// Path: footprint
class TranslationsFootprintZh {
	TranslationsFootprintZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '搜索'
	String get searchIn => '搜索';

	/// zh: '在所有记录中搜索相关内容'
	String get searchInAllRecords => '在所有记录中搜索相关内容';
}

// Path: media
class TranslationsMediaZh {
	TranslationsMediaZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '选择照片'
	String get selectPhotos => '选择照片';

	/// zh: '添加文件'
	String get addFiles => '添加文件';

	/// zh: '拍照'
	String get takePhoto => '拍照';

	/// zh: '相机'
	String get camera => '相机';

	/// zh: '照片'
	String get photos => '照片';

	/// zh: '文件'
	String get files => '文件';

	/// zh: '显示全部'
	String get showAll => '显示全部';

	/// zh: '所有照片'
	String get allPhotos => '所有照片';

	/// zh: '拍照中...'
	String get takingPhoto => '拍照中...';

	/// zh: '照片已保存'
	String get photoTaken => '照片已保存';

	/// zh: '需要相机权限'
	String get cameraPermissionRequired => '需要相机权限';

	/// zh: '文件大小超过10MB限制'
	String get fileSizeExceeded => '文件大小超过10MB限制';

	/// zh: '不支持的文件格式'
	String get unsupportedFormat => '不支持的文件格式';

	/// zh: '需要相册访问权限'
	String get permissionDenied => '需要相册访问权限';

	/// zh: '存储空间不足'
	String get storageInsufficient => '存储空间不足';

	/// zh: '网络连接错误'
	String get networkError => '网络连接错误';

	/// zh: '上传时发生未知错误'
	String get unknownUploadError => '上传时发生未知错误';
}

// Path: error
class TranslationsErrorZh {
	TranslationsErrorZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '需要权限'
	String get permissionRequired => '需要权限';

	/// zh: '请在设置中开启相册和存储权限，以便选择和上传文件。'
	String get permissionInstructions => '请在设置中开启相册和存储权限，以便选择和上传文件。';

	/// zh: '打开设置'
	String get openSettings => '打开设置';

	/// zh: '文件过大'
	String get fileTooLarge => '文件过大';

	/// zh: '请选择小于10MB的文件，或者压缩后再上传。'
	String get fileSizeHint => '请选择小于10MB的文件，或者压缩后再上传。';

	/// zh: '支持的格式包括：图片(jpg, png, gif等)、文档(pdf, doc, txt等)、音视频文件等。'
	String get supportedFormatsHint => '支持的格式包括：图片(jpg, png, gif等)、文档(pdf, doc, txt等)、音视频文件等。';

	/// zh: '请清理设备存储空间后重试，或选择较小的文件。'
	String get storageCleanupHint => '请清理设备存储空间后重试，或选择较小的文件。';

	/// zh: '请检查网络连接是否正常，然后重试。'
	String get networkErrorHint => '请检查网络连接是否正常，然后重试。';

	/// zh: '平台不支持'
	String get platformNotSupported => '平台不支持';

	/// zh: '文件读取失败'
	String get fileReadError => '文件读取失败';

	/// zh: '文件可能已损坏或被其他程序占用，请重新选择文件。'
	String get fileReadErrorHint => '文件可能已损坏或被其他程序占用，请重新选择文件。';

	/// zh: '文件验证失败'
	String get validationError => '文件验证失败';

	/// zh: '未知错误'
	String get unknownError => '未知错误';

	/// zh: '发生了意外错误，请重试或联系技术支持。'
	String get unknownErrorHint => '发生了意外错误，请重试或联系技术支持。';

	late final TranslationsErrorGenuiZh genui = TranslationsErrorGenuiZh.internal(_root);
}

// Path: fontTest
class TranslationsFontTestZh {
	TranslationsFontTestZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '字体测试页面'
	String get page => '字体测试页面';

	/// zh: '字体显示测试'
	String get displayTest => '字体显示测试';

	/// zh: '中文文本测试'
	String get chineseTextTest => '中文文本测试';

	/// zh: '英文文本测试'
	String get englishTextTest => '英文文本测试';

	/// zh: '这是一段中文文本，用于测试字体显示效果。'
	String get sample1 => '这是一段中文文本，用于测试字体显示效果。';

	/// zh: '支出分类汇总，购物最高'
	String get sample2 => '支出分类汇总，购物最高';

	/// zh: '人工智能助手为您提供专业的财务分析服务'
	String get sample3 => '人工智能助手为您提供专业的财务分析服务';

	/// zh: '数据可视化图表展示您的消费趋势'
	String get sample4 => '数据可视化图表展示您的消费趋势';

	/// zh: '微信支付、支付宝、银行卡等多种支付方式'
	String get sample5 => '微信支付、支付宝、银行卡等多种支付方式';
}

// Path: wizard
class TranslationsWizardZh {
	TranslationsWizardZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '下一步'
	String get nextStep => '下一步';

	/// zh: '上一步'
	String get previousStep => '上一步';

	/// zh: '完成绘制'
	String get completeMapping => '完成绘制';
}

// Path: user
class TranslationsUserZh {
	TranslationsUserZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '用户名'
	String get username => '用户名';

	/// zh: 'user@example.com'
	String get defaultEmail => 'user@example.com';
}

// Path: account
class TranslationsAccountZh {
	TranslationsAccountZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '编辑账户'
	String get editTitle => '编辑账户';

	/// zh: '新建账户'
	String get addTitle => '新建账户';

	/// zh: '选择账户类型'
	String get selectTypeTitle => '选择账户类型';

	/// zh: '账户名称'
	String get nameLabel => '账户名称';

	/// zh: '当前余额'
	String get amountLabel => '当前余额';

	/// zh: '币种'
	String get currencyLabel => '币种';

	/// zh: '隐藏'
	String get hiddenLabel => '隐藏';

	/// zh: '在账户列表中隐藏该账户'
	String get hiddenDesc => '在账户列表中隐藏该账户';

	/// zh: '计入资产'
	String get includeInNetWorthLabel => '计入资产';

	/// zh: '用于净资产统计'
	String get includeInNetWorthDesc => '用于净资产统计';

	/// zh: '例如：工资卡'
	String get nameHint => '例如：工资卡';

	/// zh: '0.00'
	String get amountHint => '0.00';

	/// zh: '删除账户'
	String get deleteAccount => '删除账户';

	/// zh: '确定要删除该账户吗？此操作无法撤销。'
	String get deleteConfirm => '确定要删除该账户吗？此操作无法撤销。';

	/// zh: '保存修改'
	String get save => '保存修改';

	/// zh: '资产类'
	String get assetsCategory => '资产类';

	/// zh: '负债/信用类'
	String get liabilitiesCategory => '负债/信用类';

	/// zh: '现金钱包'
	String get cash => '现金钱包';

	/// zh: '银行存款'
	String get deposit => '银行存款';

	/// zh: '信用卡'
	String get creditCard => '信用卡';

	/// zh: '投资理财'
	String get investment => '投资理财';

	/// zh: '电子钱包'
	String get eWallet => '电子钱包';

	/// zh: '贷款账户'
	String get loan => '贷款账户';

	/// zh: '应收款项'
	String get receivable => '应收款项';

	/// zh: '应付款项'
	String get payable => '应付款项';

	/// zh: '其他账户'
	String get other => '其他账户';

	late final TranslationsAccountTypesZh types = TranslationsAccountTypesZh.internal(_root);
}

// Path: financial
class TranslationsFinancialZh {
	TranslationsFinancialZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '财务'
	String get title => '财务';

	/// zh: '财务管理'
	String get management => '财务管理';

	/// zh: '总净值'
	String get netWorth => '总净值';

	/// zh: '总资产'
	String get assets => '总资产';

	/// zh: '总负债'
	String get liabilities => '总负债';

	/// zh: '暂无账户'
	String get noAccounts => '暂无账户';

	/// zh: '点击下方按钮添加您的第一个账户'
	String get addFirstAccount => '点击下方按钮添加您的第一个账户';

	/// zh: '资产账户'
	String get assetAccounts => '资产账户';

	/// zh: '负债账户'
	String get liabilityAccounts => '负债账户';

	/// zh: '选择货币'
	String get selectCurrency => '选择货币';

	/// zh: '取消'
	String get cancel => '取消';

	/// zh: '确定'
	String get confirm => '确定';

	/// zh: '财务设置'
	String get settings => '财务设置';

	/// zh: '预算管理'
	String get budgetManagement => '预算管理';

	/// zh: '周期交易'
	String get recurringTransactions => '周期交易';

	/// zh: '安全阈值'
	String get safetyThreshold => '安全阈值';

	/// zh: '每日消费'
	String get dailyBurnRate => '每日消费';

	/// zh: '财务助手'
	String get financialAssistant => '财务助手';

	/// zh: '管理您的财务设置'
	String get manageFinancialSettings => '管理您的财务设置';

	/// zh: '财务安全线设置'
	String get safetyThresholdSettings => '财务安全线设置';

	/// zh: '设置您的财务安全阈值'
	String get setSafetyThreshold => '设置您的财务安全阈值';

	/// zh: '财务安全线已保存'
	String get safetyThresholdSaved => '财务安全线已保存';

	/// zh: '日常消费预估'
	String get dailyBurnRateSettings => '日常消费预估';

	/// zh: '设置您的日常消费预估金额'
	String get setDailyBurnRate => '设置您的日常消费预估金额';

	/// zh: '日常消费预估已保存'
	String get dailyBurnRateSaved => '日常消费预估已保存';

	/// zh: '保存失败'
	String get saveFailed => '保存失败';
}

// Path: app
class TranslationsAppZh {
	TranslationsAppZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '智见增长，格物致富。'
	String get splashTitle => '智见增长，格物致富。';

	/// zh: '智能财务助手'
	String get splashSubtitle => '智能财务助手';
}

// Path: statistics
class TranslationsStatisticsZh {
	TranslationsStatisticsZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '统计分析'
	String get title => '统计分析';

	/// zh: '统计分析'
	String get analyze => '统计分析';

	/// zh: '导出功能开发中...'
	String get exportInProgress => '导出功能开发中...';

	/// zh: '大额消费排行'
	String get ranking => '大额消费排行';

	/// zh: '暂无数据'
	String get noData => '暂无数据';

	late final TranslationsStatisticsOverviewZh overview = TranslationsStatisticsOverviewZh.internal(_root);
	late final TranslationsStatisticsTrendZh trend = TranslationsStatisticsTrendZh.internal(_root);
	late final TranslationsStatisticsAnalysisZh analysis = TranslationsStatisticsAnalysisZh.internal(_root);
	late final TranslationsStatisticsFilterZh filter = TranslationsStatisticsFilterZh.internal(_root);
	late final TranslationsStatisticsSortZh sort = TranslationsStatisticsSortZh.internal(_root);

	/// zh: '导出列表'
	String get exportList => '导出列表';

	late final TranslationsStatisticsEmptyStateZh emptyState = TranslationsStatisticsEmptyStateZh.internal(_root);

	/// zh: '没有更多数据了'
	String get noMoreData => '没有更多数据了';
}

// Path: currency
class TranslationsCurrencyZh {
	TranslationsCurrencyZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '人民币'
	String get cny => '人民币';

	/// zh: '美元'
	String get usd => '美元';

	/// zh: '欧元'
	String get eur => '欧元';

	/// zh: '日元'
	String get jpy => '日元';

	/// zh: '英镑'
	String get gbp => '英镑';

	/// zh: '澳元'
	String get aud => '澳元';

	/// zh: '加元'
	String get cad => '加元';

	/// zh: '瑞士法郎'
	String get chf => '瑞士法郎';

	/// zh: '俄罗斯卢布'
	String get rub => '俄罗斯卢布';

	/// zh: '港币'
	String get hkd => '港币';

	/// zh: '新台币'
	String get twd => '新台币';

	/// zh: '印度卢比'
	String get inr => '印度卢比';
}

// Path: budgetSuggestion
class TranslationsBudgetSuggestionZh {
	TranslationsBudgetSuggestionZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '$category 占支出的 $percentage%，建议设置预算上限'
	String highPercentage({required Object category, required Object percentage}) => '${category} 占支出的 ${percentage}%，建议设置预算上限';

	/// zh: '本月支出增长了 $percentage%，需要关注'
	String monthlyIncrease({required Object percentage}) => '本月支出增长了 ${percentage}%，需要关注';

	/// zh: '$category 有 $count 笔小额交易，可能是订阅消费'
	String frequentSmall({required Object category, required Object count}) => '${category} 有 ${count} 笔小额交易，可能是订阅消费';

	/// zh: '财务洞察'
	String get financialInsights => '财务洞察';
}

// Path: server
class TranslationsServerZh {
	TranslationsServerZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '连接服务器'
	String get title => '连接服务器';

	/// zh: '输入您自部署的服务器地址，或扫描服务器启动时显示的二维码'
	String get subtitle => '输入您自部署的服务器地址，或扫描服务器启动时显示的二维码';

	/// zh: '服务器地址'
	String get urlLabel => '服务器地址';

	/// zh: '例如：https://api.example.com 或 192.168.1.100:8000'
	String get urlPlaceholder => '例如：https://api.example.com 或 192.168.1.100:8000';

	/// zh: '扫描二维码'
	String get scanQr => '扫描二维码';

	/// zh: '对准服务器终端显示的二维码'
	String get scanQrInstruction => '对准服务器终端显示的二维码';

	/// zh: '测试连接'
	String get testConnection => '测试连接';

	/// zh: '正在连接...'
	String get connecting => '正在连接...';

	/// zh: '已连接'
	String get connected => '已连接';

	/// zh: '连接失败'
	String get connectionFailed => '连接失败';

	/// zh: '继续登录'
	String get continueToLogin => '继续登录';

	/// zh: '保存并返回'
	String get saveAndReturn => '保存并返回';

	/// zh: '服务器设置'
	String get serverSettings => '服务器设置';

	/// zh: '当前服务器'
	String get currentServer => '当前服务器';

	/// zh: '版本'
	String get version => '版本';

	/// zh: '环境'
	String get environment => '环境';

	/// zh: '更换服务器'
	String get changeServer => '更换服务器';

	/// zh: '更换服务器将退出登录，是否继续？'
	String get changeServerWarning => '更换服务器将退出登录，是否继续？';

	late final TranslationsServerErrorZh error = TranslationsServerErrorZh.internal(_root);
}

// Path: errorMapping
class TranslationsErrorMappingZh {
	TranslationsErrorMappingZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsErrorMappingGenericZh generic = TranslationsErrorMappingGenericZh.internal(_root);
	late final TranslationsErrorMappingAuthZh auth = TranslationsErrorMappingAuthZh.internal(_root);
	late final TranslationsErrorMappingTransactionZh transaction = TranslationsErrorMappingTransactionZh.internal(_root);
	late final TranslationsErrorMappingSpaceZh space = TranslationsErrorMappingSpaceZh.internal(_root);
	late final TranslationsErrorMappingRecurringZh recurring = TranslationsErrorMappingRecurringZh.internal(_root);
	late final TranslationsErrorMappingUploadZh upload = TranslationsErrorMappingUploadZh.internal(_root);
	late final TranslationsErrorMappingAiZh ai = TranslationsErrorMappingAiZh.internal(_root);
}

// Path: auth.email
class TranslationsAuthEmailZh {
	TranslationsAuthEmailZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '邮箱'
	String get label => '邮箱';

	/// zh: '请输入您的邮箱'
	String get placeholder => '请输入您的邮箱';

	/// zh: '邮箱不能为空'
	String get required => '邮箱不能为空';

	/// zh: '请输入有效的邮箱地址'
	String get invalid => '请输入有效的邮箱地址';
}

// Path: auth.password
class TranslationsAuthPasswordZh {
	TranslationsAuthPasswordZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '密码'
	String get label => '密码';

	/// zh: '请输入您的密码'
	String get placeholder => '请输入您的密码';

	/// zh: '密码不能为空'
	String get required => '密码不能为空';

	/// zh: '密码长度不能少于6位'
	String get tooShort => '密码长度不能少于6位';

	/// zh: '密码必须包含数字和字母'
	String get mustContainNumbersAndLetters => '密码必须包含数字和字母';

	/// zh: '确认密码'
	String get confirm => '确认密码';

	/// zh: '请再次输入您的密码'
	String get confirmPlaceholder => '请再次输入您的密码';

	/// zh: '两次输入的密码不一致'
	String get mismatch => '两次输入的密码不一致';
}

// Path: auth.verificationCode
class TranslationsAuthVerificationCodeZh {
	TranslationsAuthVerificationCodeZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '验证码'
	String get label => '验证码';

	/// zh: '获取验证码'
	String get get => '获取验证码';

	/// zh: '发送中...'
	String get sending => '发送中...';

	/// zh: '验证码已发送'
	String get sent => '验证码已发送';

	/// zh: '发送失败'
	String get sendFailed => '发送失败';

	/// zh: '暂不校验，随意输入'
	String get placeholder => '暂不校验，随意输入';

	/// zh: '验证码不能为空'
	String get required => '验证码不能为空';
}

// Path: calendar.weekdays
class TranslationsCalendarWeekdaysZh {
	TranslationsCalendarWeekdaysZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '一'
	String get mon => '一';

	/// zh: '二'
	String get tue => '二';

	/// zh: '三'
	String get wed => '三';

	/// zh: '四'
	String get thu => '四';

	/// zh: '五'
	String get fri => '五';

	/// zh: '六'
	String get sat => '六';

	/// zh: '日'
	String get sun => '日';
}

// Path: appearance.palettes
class TranslationsAppearancePalettesZh {
	TranslationsAppearancePalettesZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '锌灰'
	String get zinc => '锌灰';

	/// zh: '板岩'
	String get slate => '板岩';

	/// zh: '绯红'
	String get red => '绯红';

	/// zh: '玫瑰'
	String get rose => '玫瑰';

	/// zh: '橙色'
	String get orange => '橙色';

	/// zh: '绿色'
	String get green => '绿色';

	/// zh: '蓝色'
	String get blue => '蓝色';

	/// zh: '黄色'
	String get yellow => '黄色';

	/// zh: '紫罗兰'
	String get violet => '紫罗兰';
}

// Path: forecast.recurringTransaction
class TranslationsForecastRecurringTransactionZh {
	TranslationsForecastRecurringTransactionZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '周期交易'
	String get title => '周期交易';

	/// zh: '全部'
	String get all => '全部';

	/// zh: '支出'
	String get expense => '支出';

	/// zh: '收入'
	String get income => '收入';

	/// zh: '转账'
	String get transfer => '转账';

	/// zh: '暂无周期交易'
	String get noRecurring => '暂无周期交易';

	/// zh: '创建周期交易后，系统将自动为您生成交易记录'
	String get createHint => '创建周期交易后，系统将自动为您生成交易记录';

	/// zh: '创建周期交易'
	String get create => '创建周期交易';

	/// zh: '编辑周期交易'
	String get edit => '编辑周期交易';

	/// zh: '新建周期交易'
	String get newTransaction => '新建周期交易';

	/// zh: '确定要删除周期交易「$name」吗？此操作不可撤销。'
	String deleteConfirm({required Object name}) => '确定要删除周期交易「${name}」吗？此操作不可撤销。';

	/// zh: '确定要启用周期交易「$name」吗？启用后将按照设定的规则自动生成交易记录。'
	String activateConfirm({required Object name}) => '确定要启用周期交易「${name}」吗？启用后将按照设定的规则自动生成交易记录。';

	/// zh: '确定要暂停周期交易「$name」吗？暂停后将不再自动生成交易记录。'
	String pauseConfirm({required Object name}) => '确定要暂停周期交易「${name}」吗？暂停后将不再自动生成交易记录。';

	/// zh: '周期交易已创建'
	String get created => '周期交易已创建';

	/// zh: '周期交易已更新'
	String get updated => '周期交易已更新';

	/// zh: '已启用'
	String get activated => '已启用';

	/// zh: '已暂停'
	String get paused => '已暂停';

	/// zh: '下次'
	String get nextTime => '下次';

	/// zh: '按时间排序'
	String get sortByTime => '按时间排序';

	/// zh: '全部周期'
	String get allPeriod => '全部周期';

	/// zh: '$type周期 ($count)'
	String periodCount({required Object type, required Object count}) => '${type}周期 (${count})';

	/// zh: '确认删除'
	String get confirmDelete => '确认删除';

	/// zh: '确认启用'
	String get confirmActivate => '确认启用';

	/// zh: '确认暂停'
	String get confirmPause => '确认暂停';

	/// zh: '动态均值'
	String get dynamicAmount => '动态均值';

	/// zh: '金额需手动确认'
	String get dynamicAmountTitle => '金额需手动确认';

	/// zh: '系统将在账单日发送提醒，需要您手动确认具体金额后才会记账。'
	String get dynamicAmountDescription => '系统将在账单日发送提醒，需要您手动确认具体金额后才会记账。';
}

// Path: chat.tools
class TranslationsChatToolsZh {
	TranslationsChatToolsZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '正在处理...'
	String get processing => '正在处理...';

	/// zh: '正在查看文件...'
	String get readFile => '正在查看文件...';

	/// zh: '正在查询交易...'
	String get searchTransactions => '正在查询交易...';

	/// zh: '正在检查预算...'
	String get queryBudgetStatus => '正在检查预算...';

	/// zh: '正在创建预算计划...'
	String get createBudget => '正在创建预算计划...';

	/// zh: '正在分析现金流...'
	String get getCashFlowAnalysis => '正在分析现金流...';

	/// zh: '正在计算财务健康分...'
	String get getFinancialHealthScore => '正在计算财务健康分...';

	/// zh: '正在生成财务报告...'
	String get getFinancialSummary => '正在生成财务报告...';

	/// zh: '正在评估财务健康...'
	String get evaluateFinancialHealth => '正在评估财务健康...';

	/// zh: '正在预测未来余额...'
	String get forecastBalance => '正在预测未来余额...';

	/// zh: '正在模拟购买影响...'
	String get simulateExpenseImpact => '正在模拟购买影响...';

	/// zh: '正在记账...'
	String get recordTransactions => '正在记账...';

	/// zh: '正在记账...'
	String get createTransaction => '正在记账...';

	/// zh: '正在搜索网络...'
	String get duckduckgoSearch => '正在搜索网络...';

	/// zh: '正在执行转账...'
	String get executeTransfer => '正在执行转账...';

	/// zh: '正在浏览目录...'
	String get listDir => '正在浏览目录...';

	/// zh: '正在执行脚本...'
	String get execute => '正在执行脚本...';

	/// zh: '正在分析财务状况...'
	String get analyzeFinance => '正在分析财务状况...';

	/// zh: '正在预测财务趋势...'
	String get forecastFinance => '正在预测财务趋势...';

	/// zh: '正在分析预算...'
	String get analyzeBudget => '正在分析预算...';

	/// zh: '正在审计分析...'
	String get auditAnalysis => '正在审计分析...';

	/// zh: '正在处理预算...'
	String get budgetOps => '正在处理预算...';

	/// zh: '正在创建共享账单...'
	String get createSharedTransaction => '正在创建共享账单...';

	/// zh: '正在获取共享空间...'
	String get listSpaces => '正在获取共享空间...';

	/// zh: '正在查询空间摘要...'
	String get querySpaceSummary => '正在查询空间摘要...';

	/// zh: '正在准备转账...'
	String get prepareTransfer => '正在准备转账...';

	/// zh: '正在处理请求...'
	String get unknown => '正在处理请求...';

	late final TranslationsChatToolsDoneZh done = TranslationsChatToolsDoneZh.internal(_root);
	late final TranslationsChatToolsFailedZh failed = TranslationsChatToolsFailedZh.internal(_root);
}

// Path: chat.transferWizard
class TranslationsChatTransferWizardZh {
	TranslationsChatTransferWizardZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '转账向导'
	String get title => '转账向导';

	/// zh: '转账金额'
	String get amount => '转账金额';

	/// zh: '请输入金额'
	String get amountHint => '请输入金额';

	/// zh: '转出账户'
	String get sourceAccount => '转出账户';

	/// zh: '转入账户'
	String get targetAccount => '转入账户';

	/// zh: '请选择账户'
	String get selectAccount => '请选择账户';

	/// zh: '选择收款账户'
	String get selectReceiveAccount => '选择收款账户';

	/// zh: '确认转账'
	String get confirmTransfer => '确认转账';

	/// zh: '已确认'
	String get confirmed => '已确认';

	/// zh: '转账成功'
	String get transferSuccess => '转账成功';
}

// Path: chat.genui
class TranslationsChatGenuiZh {
	TranslationsChatGenuiZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsChatGenuiExpenseSummaryZh expenseSummary = TranslationsChatGenuiExpenseSummaryZh.internal(_root);
	late final TranslationsChatGenuiTransactionListZh transactionList = TranslationsChatGenuiTransactionListZh.internal(_root);
	late final TranslationsChatGenuiTransactionGroupReceiptZh transactionGroupReceipt = TranslationsChatGenuiTransactionGroupReceiptZh.internal(_root);
	late final TranslationsChatGenuiBudgetReceiptZh budgetReceipt = TranslationsChatGenuiBudgetReceiptZh.internal(_root);
	late final TranslationsChatGenuiBudgetStatusCardZh budgetStatusCard = TranslationsChatGenuiBudgetStatusCardZh.internal(_root);
	late final TranslationsChatGenuiCashFlowForecastZh cashFlowForecast = TranslationsChatGenuiCashFlowForecastZh.internal(_root);
	late final TranslationsChatGenuiHealthScoreZh healthScore = TranslationsChatGenuiHealthScoreZh.internal(_root);
	late final TranslationsChatGenuiSpaceSelectorZh spaceSelector = TranslationsChatGenuiSpaceSelectorZh.internal(_root);
	late final TranslationsChatGenuiTransferPathZh transferPath = TranslationsChatGenuiTransferPathZh.internal(_root);
	late final TranslationsChatGenuiTransactionCardZh transactionCard = TranslationsChatGenuiTransactionCardZh.internal(_root);
	late final TranslationsChatGenuiTransactionConfirmationZh transactionConfirmation = TranslationsChatGenuiTransactionConfirmationZh.internal(_root);
	late final TranslationsChatGenuiBudgetAnalysisZh budgetAnalysis = TranslationsChatGenuiBudgetAnalysisZh.internal(_root);
}

// Path: error.genui
class TranslationsErrorGenuiZh {
	TranslationsErrorGenuiZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '组件加载失败'
	String get loadingFailed => '组件加载失败';

	/// zh: '架构验证失败'
	String get schemaFailed => '架构验证失败';

	/// zh: '组件定义不符合 GenUI 规范，降级为纯文本显示'
	String get schemaDescription => '组件定义不符合 GenUI 规范，降级为纯文本显示';

	/// zh: '网络错误'
	String get networkError => '网络错误';

	/// zh: '已重试 $retryCount/$maxRetries 次'
	String retryStatus({required Object retryCount, required Object maxRetries}) => '已重试 ${retryCount}/${maxRetries} 次';

	/// zh: '已达最大重试次数'
	String get maxRetriesReached => '已达最大重试次数';
}

// Path: account.types
class TranslationsAccountTypesZh {
	TranslationsAccountTypesZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '现金'
	String get cashTitle => '现金';

	/// zh: '纸币、硬币等实体货币'
	String get cashSubtitle => '纸币、硬币等实体货币';

	/// zh: '银行存款'
	String get depositTitle => '银行存款';

	/// zh: '储蓄卡、活期/定期存款'
	String get depositSubtitle => '储蓄卡、活期/定期存款';

	/// zh: '电子钱包'
	String get eMoneyTitle => '电子钱包';

	/// zh: '第三方支付平台余额'
	String get eMoneySubtitle => '第三方支付平台余额';

	/// zh: '投资账户'
	String get investmentTitle => '投资账户';

	/// zh: '股票、基金、债券等'
	String get investmentSubtitle => '股票、基金、债券等';

	/// zh: '应收款项'
	String get receivableTitle => '应收款项';

	/// zh: '借出款项、待收账款'
	String get receivableSubtitle => '借出款项、待收账款';

	/// zh: '他人欠我'
	String get receivableHelper => '他人欠我';

	/// zh: '信用卡'
	String get creditCardTitle => '信用卡';

	/// zh: '信用卡账户欠款'
	String get creditCardSubtitle => '信用卡账户欠款';

	/// zh: '贷款'
	String get loanTitle => '贷款';

	/// zh: '房贷、车贷、消费贷等'
	String get loanSubtitle => '房贷、车贷、消费贷等';

	/// zh: '应付款项'
	String get payableTitle => '应付款项';

	/// zh: '借入款项、待付账款'
	String get payableSubtitle => '借入款项、待付账款';

	/// zh: '我欠他人'
	String get payableHelper => '我欠他人';
}

// Path: statistics.overview
class TranslationsStatisticsOverviewZh {
	TranslationsStatisticsOverviewZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '总结余'
	String get balance => '总结余';

	/// zh: '总收入'
	String get income => '总收入';

	/// zh: '总支出'
	String get expense => '总支出';
}

// Path: statistics.trend
class TranslationsStatisticsTrendZh {
	TranslationsStatisticsTrendZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '收支趋势'
	String get title => '收支趋势';

	/// zh: '支出'
	String get expense => '支出';

	/// zh: '收入'
	String get income => '收入';
}

// Path: statistics.analysis
class TranslationsStatisticsAnalysisZh {
	TranslationsStatisticsAnalysisZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '支出分析'
	String get title => '支出分析';

	/// zh: '总计'
	String get total => '总计';

	/// zh: '支出分类明细'
	String get breakdown => '支出分类明细';
}

// Path: statistics.filter
class TranslationsStatisticsFilterZh {
	TranslationsStatisticsFilterZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '账户类型'
	String get accountType => '账户类型';

	/// zh: '全部账户'
	String get allAccounts => '全部账户';

	/// zh: '确认应用'
	String get apply => '确认应用';
}

// Path: statistics.sort
class TranslationsStatisticsSortZh {
	TranslationsStatisticsSortZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '按金额排序'
	String get amount => '按金额排序';

	/// zh: '按时间排序'
	String get date => '按时间排序';
}

// Path: statistics.emptyState
class TranslationsStatisticsEmptyStateZh {
	TranslationsStatisticsEmptyStateZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '开启财务洞察'
	String get title => '开启财务洞察';

	/// zh: '您的财务报表目前是一张白纸。 记录第一笔消费，让数据为您讲述财富故事。'
	String get description => '您的财务报表目前是一张白纸。\n记录第一笔消费，让数据为您讲述财富故事。';

	/// zh: '记录首笔交易'
	String get action => '记录首笔交易';
}

// Path: server.error
class TranslationsServerErrorZh {
	TranslationsServerErrorZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '请输入服务器地址'
	String get urlRequired => '请输入服务器地址';

	/// zh: 'URL 格式无效'
	String get invalidUrl => 'URL 格式无效';

	/// zh: '连接超时'
	String get connectionTimeout => '连接超时';

	/// zh: '无法连接到服务器'
	String get connectionRefused => '无法连接到服务器';

	/// zh: 'SSL 证书错误'
	String get sslError => 'SSL 证书错误';

	/// zh: '服务器错误'
	String get serverError => '服务器错误';
}

// Path: errorMapping.generic
class TranslationsErrorMappingGenericZh {
	TranslationsErrorMappingGenericZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '请求无效'
	String get badRequest => '请求无效';

	/// zh: '认证失败，请重新登录'
	String get authFailed => '认证失败，请重新登录';

	/// zh: '权限不足'
	String get permissionDenied => '权限不足';

	/// zh: '资源未找到'
	String get notFound => '资源未找到';

	/// zh: '服务器内部错误'
	String get serverError => '服务器内部错误';

	/// zh: '系统错误'
	String get systemError => '系统错误';

	/// zh: '数据验证失败'
	String get validationFailed => '数据验证失败';
}

// Path: errorMapping.auth
class TranslationsErrorMappingAuthZh {
	TranslationsErrorMappingAuthZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '认证失败'
	String get failed => '认证失败';

	/// zh: '邮箱错误'
	String get emailWrong => '邮箱错误';

	/// zh: '手机号错误'
	String get phoneWrong => '手机号错误';

	/// zh: '该手机号已被注册'
	String get phoneRegistered => '该手机号已被注册';

	/// zh: '该邮箱已被注册'
	String get emailRegistered => '该邮箱已被注册';

	/// zh: '验证码发送失败'
	String get sendFailed => '验证码发送失败';

	/// zh: '验证码已过期'
	String get expired => '验证码已过期';

	/// zh: '验证码发送太频繁'
	String get tooFrequent => '验证码发送太频繁';

	/// zh: '不支持的验证码类型'
	String get unsupportedType => '不支持的验证码类型';

	/// zh: '密码错误'
	String get wrongPassword => '密码错误';

	/// zh: '用户不存在'
	String get userNotFound => '用户不存在';

	/// zh: '偏好设置参数缺失'
	String get prefsMissing => '偏好设置参数缺失';

	/// zh: '无效的客户端时区'
	String get invalidTimezone => '无效的客户端时区';
}

// Path: errorMapping.transaction
class TranslationsErrorMappingTransactionZh {
	TranslationsErrorMappingTransactionZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '评论内容不能为空'
	String get commentEmpty => '评论内容不能为空';

	/// zh: '无效的父评论ID'
	String get invalidParent => '无效的父评论ID';

	/// zh: '评论保存失败'
	String get saveFailed => '评论保存失败';

	/// zh: '评论删除失败'
	String get deleteFailed => '评论删除失败';

	/// zh: '交易记录不存在'
	String get notExists => '交易记录不存在';
}

// Path: errorMapping.space
class TranslationsErrorMappingSpaceZh {
	TranslationsErrorMappingSpaceZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '共享空间不存在或无权访问'
	String get notFound => '共享空间不存在或无权访问';

	/// zh: '无权邀请成员'
	String get inviteDenied => '无权邀请成员';

	/// zh: '不能邀请你自己'
	String get inviteSelf => '不能邀请你自己';

	/// zh: '邀请已发送'
	String get inviteSent => '邀请已发送';

	/// zh: '该用户已是成员或已被邀请'
	String get alreadyMember => '该用户已是成员或已被邀请';

	/// zh: '无效操作'
	String get invalidAction => '无效操作';

	/// zh: '邀请不存在'
	String get invitationNotFound => '邀请不存在';

	/// zh: '仅拥有者可执行此操作'
	String get onlyOwner => '仅拥有者可执行此操作';

	/// zh: '不能移除空间拥有者'
	String get ownerNotRemovable => '不能移除空间拥有者';

	/// zh: '成员不存在'
	String get memberNotFound => '成员不存在';

	/// zh: '该用户不是此空间的成员'
	String get notMember => '该用户不是此空间的成员';

	/// zh: '拥有者不能直接退出，请先转让所有权'
	String get ownerCantLeave => '拥有者不能直接退出，请先转让所有权';

	/// zh: '无效的邀请码'
	String get invalidCode => '无效的邀请码';

	/// zh: '邀请码已过期或达到上限'
	String get codeExpired => '邀请码已过期或达到上限';
}

// Path: errorMapping.recurring
class TranslationsErrorMappingRecurringZh {
	TranslationsErrorMappingRecurringZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '无效的重复规则'
	String get invalidRule => '无效的重复规则';

	/// zh: '未找到重复规则'
	String get ruleNotFound => '未找到重复规则';
}

// Path: errorMapping.upload
class TranslationsErrorMappingUploadZh {
	TranslationsErrorMappingUploadZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '未上传文件'
	String get noFile => '未上传文件';

	/// zh: '文件过大'
	String get tooLarge => '文件过大';

	/// zh: '不支持的文件类型'
	String get unsupportedType => '不支持的文件类型';

	/// zh: '文件数量过多'
	String get tooManyFiles => '文件数量过多';
}

// Path: errorMapping.ai
class TranslationsErrorMappingAiZh {
	TranslationsErrorMappingAiZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '上下文长度超出限制'
	String get contextLimit => '上下文长度超出限制';

	/// zh: 'Token配额不足'
	String get tokenLimit => 'Token配额不足';

	/// zh: '用户消息为空'
	String get emptyMessage => '用户消息为空';
}

// Path: chat.tools.done
class TranslationsChatToolsDoneZh {
	TranslationsChatToolsDoneZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '已查看文件'
	String get readFile => '已查看文件';

	/// zh: '已查询交易'
	String get searchTransactions => '已查询交易';

	/// zh: '已检查预算'
	String get queryBudgetStatus => '已检查预算';

	/// zh: '已创建预算'
	String get createBudget => '已创建预算';

	/// zh: '已分析现金流'
	String get getCashFlowAnalysis => '已分析现金流';

	/// zh: '已计算健康分'
	String get getFinancialHealthScore => '已计算健康分';

	/// zh: '财务报告生成完成'
	String get getFinancialSummary => '财务报告生成完成';

	/// zh: '财务健康评估完成'
	String get evaluateFinancialHealth => '财务健康评估完成';

	/// zh: '余额预测完成'
	String get forecastBalance => '余额预测完成';

	/// zh: '购买影响模拟完成'
	String get simulateExpenseImpact => '购买影响模拟完成';

	/// zh: '记账完成'
	String get recordTransactions => '记账完成';

	/// zh: '已完成记账'
	String get createTransaction => '已完成记账';

	/// zh: '已搜索网络'
	String get duckduckgoSearch => '已搜索网络';

	/// zh: '转账完成'
	String get executeTransfer => '转账完成';

	/// zh: '已浏览目录'
	String get listDir => '已浏览目录';

	/// zh: '脚本执行完成'
	String get execute => '脚本执行完成';

	/// zh: '财务分析完成'
	String get analyzeFinance => '财务分析完成';

	/// zh: '财务预测完成'
	String get forecastFinance => '财务预测完成';

	/// zh: '预算分析完成'
	String get analyzeBudget => '预算分析完成';

	/// zh: '审计分析完成'
	String get auditAnalysis => '审计分析完成';

	/// zh: '预算处理完成'
	String get budgetOps => '预算处理完成';

	/// zh: '共享账单创建完成'
	String get createSharedTransaction => '共享账单创建完成';

	/// zh: '共享空间获取完成'
	String get listSpaces => '共享空间获取完成';

	/// zh: '空间摘要查询完成'
	String get querySpaceSummary => '空间摘要查询完成';

	/// zh: '转账准备完成'
	String get prepareTransfer => '转账准备完成';

	/// zh: '处理完成'
	String get unknown => '处理完成';
}

// Path: chat.tools.failed
class TranslationsChatToolsFailedZh {
	TranslationsChatToolsFailedZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '操作失败'
	String get unknown => '操作失败';
}

// Path: chat.genui.expenseSummary
class TranslationsChatGenuiExpenseSummaryZh {
	TranslationsChatGenuiExpenseSummaryZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '总支出'
	String get totalExpense => '总支出';

	/// zh: '主要支出'
	String get mainExpenses => '主要支出';

	/// zh: '查看全部 $count 笔消费'
	String viewAll({required Object count}) => '查看全部 ${count} 笔消费';

	/// zh: '消费明细'
	String get details => '消费明细';
}

// Path: chat.genui.transactionList
class TranslationsChatGenuiTransactionListZh {
	TranslationsChatGenuiTransactionListZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '搜索结果 ($count)'
	String searchResults({required Object count}) => '搜索结果 (${count})';

	/// zh: '已加载 $count'
	String loaded({required Object count}) => '已加载 ${count}';

	/// zh: '未找到相关交易'
	String get noResults => '未找到相关交易';

	/// zh: '滚动加载更多'
	String get loadMore => '滚动加载更多';

	/// zh: '全部加载完成'
	String get allLoaded => '全部加载完成';
}

// Path: chat.genui.transactionGroupReceipt
class TranslationsChatGenuiTransactionGroupReceiptZh {
	TranslationsChatGenuiTransactionGroupReceiptZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '交易成功'
	String get title => '交易成功';

	/// zh: '$count笔'
	String count({required Object count}) => '${count}笔';

	/// zh: '共计'
	String get total => '共计';

	/// zh: '选择关联账户'
	String get selectAccount => '选择关联账户';

	/// zh: '此账户将应用到以上所有笔交易'
	String get selectAccountSubtitle => '此账户将应用到以上所有笔交易';

	/// zh: '已关联账户：$name'
	String associatedAccount({required Object name}) => '已关联账户：${name}';

	/// zh: '点击关联账户（支持批量操作）'
	String get clickToAssociate => '点击关联账户（支持批量操作）';

	/// zh: '已成功为所有交易关联账户'
	String get associateSuccess => '已成功为所有交易关联账户';

	/// zh: '操作失败: $error'
	String associateFailed({required Object error}) => '操作失败: ${error}';

	/// zh: '账户关联'
	String get accountAssociation => '账户关联';

	/// zh: '共享空间'
	String get sharedSpace => '共享空间';

	/// zh: '未关联'
	String get notAssociated => '未关联';

	/// zh: '添加'
	String get addSpace => '添加';

	/// zh: '选择共享空间'
	String get selectSpace => '选择共享空间';

	/// zh: '已关联到共享空间'
	String get spaceAssociateSuccess => '已关联到共享空间';

	/// zh: '关联共享空间失败: $error'
	String spaceAssociateFailed({required Object error}) => '关联共享空间失败: ${error}';

	/// zh: '币种不一致'
	String get currencyMismatchTitle => '币种不一致';

	/// zh: '交易币种与账户币种不同，系统将按当时汇率换算后扣减账户余额。'
	String get currencyMismatchDesc => '交易币种与账户币种不同，系统将按当时汇率换算后扣减账户余额。';

	/// zh: '交易金额'
	String get transactionAmount => '交易金额';

	/// zh: '账户币种'
	String get accountCurrency => '账户币种';

	/// zh: '目标账户'
	String get targetAccount => '目标账户';

	/// zh: '提示：账户余额将按当时汇率进行换算扣减'
	String get currencyMismatchNote => '提示：账户余额将按当时汇率进行换算扣减';

	/// zh: '确认关联'
	String get confirmAssociate => '确认关联';

	/// zh: '$count 空间'
	String spaceCount({required Object count}) => '${count} 空间';
}

// Path: chat.genui.budgetReceipt
class TranslationsChatGenuiBudgetReceiptZh {
	TranslationsChatGenuiBudgetReceiptZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '新预算'
	String get newBudget => '新预算';

	/// zh: '预算已创建'
	String get budgetCreated => '预算已创建';

	/// zh: '滚动预算'
	String get rolloverBudget => '滚动预算';

	/// zh: '创建预算失败'
	String get createFailed => '创建预算失败';

	/// zh: '本月'
	String get thisMonth => '本月';

	/// zh: '$start月$startDay日 - $end月$endDay日'
	String dateRange({required Object start, required Object startDay, required Object end, required Object endDay}) => '${start}月${startDay}日 - ${end}月${endDay}日';
}

// Path: chat.genui.budgetStatusCard
class TranslationsChatGenuiBudgetStatusCardZh {
	TranslationsChatGenuiBudgetStatusCardZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '预算'
	String get budget => '预算';

	/// zh: '预算概览'
	String get overview => '预算概览';

	/// zh: '总预算'
	String get totalBudget => '总预算';

	/// zh: '已用 ¥$amount'
	String spent({required Object amount}) => '已用 ¥${amount}';

	/// zh: '剩余 ¥$amount'
	String remaining({required Object amount}) => '剩余 ¥${amount}';

	/// zh: '已超支'
	String get exceeded => '已超支';

	/// zh: '预算紧张'
	String get warning => '预算紧张';

	/// zh: '预算充裕'
	String get plentiful => '预算充裕';

	/// zh: '正常'
	String get normal => '正常';
}

// Path: chat.genui.cashFlowForecast
class TranslationsChatGenuiCashFlowForecastZh {
	TranslationsChatGenuiCashFlowForecastZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '现金流预测'
	String get title => '现金流预测';

	/// zh: '周期性交易'
	String get recurringTransaction => '周期性交易';

	/// zh: '周期性收入'
	String get recurringIncome => '周期性收入';

	/// zh: '周期性支出'
	String get recurringExpense => '周期性支出';

	/// zh: '周期性转账'
	String get recurringTransfer => '周期性转账';

	/// zh: '未来 $days 天'
	String nextDays({required Object days}) => '未来 ${days} 天';

	/// zh: '暂无预测数据'
	String get noData => '暂无预测数据';

	/// zh: '预测摘要'
	String get summary => '预测摘要';

	/// zh: '预测可变支出'
	String get variableExpense => '预测可变支出';

	/// zh: '预计净变化'
	String get netChange => '预计净变化';

	/// zh: '关键事件'
	String get keyEvents => '关键事件';

	/// zh: '预测期内无重大事件'
	String get noSignificantEvents => '预测期内无重大事件';

	/// zh: 'M月d日'
	String get dateFormat => 'M月d日';
}

// Path: chat.genui.healthScore
class TranslationsChatGenuiHealthScoreZh {
	TranslationsChatGenuiHealthScoreZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '财务健康'
	String get title => '财务健康';

	/// zh: '改进建议'
	String get suggestions => '改进建议';

	/// zh: '$score分'
	String scorePoint({required Object score}) => '${score}分';

	late final TranslationsChatGenuiHealthScoreStatusZh status = TranslationsChatGenuiHealthScoreStatusZh.internal(_root);
}

// Path: chat.genui.spaceSelector
class TranslationsChatGenuiSpaceSelectorZh {
	TranslationsChatGenuiSpaceSelectorZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '已选择'
	String get selected => '已选择';

	/// zh: '未命名空间'
	String get unnamedSpace => '未命名空间';

	/// zh: '已关联'
	String get linked => '已关联';

	/// zh: '创建者'
	String get roleOwner => '创建者';

	/// zh: '管理员'
	String get roleAdmin => '管理员';

	/// zh: '成员'
	String get roleMember => '成员';
}

// Path: chat.genui.transferPath
class TranslationsChatGenuiTransferPathZh {
	TranslationsChatGenuiTransferPathZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '选择转出账户'
	String get selectSource => '选择转出账户';

	/// zh: '选择转入账户'
	String get selectTarget => '选择转入账户';

	/// zh: '转出 (FROM)'
	String get from => '转出 (FROM)';

	/// zh: '转入 (TO)'
	String get to => '转入 (TO)';

	/// zh: '请选择'
	String get select => '请选择';

	/// zh: '操作已取消'
	String get cancelled => '操作已取消';

	/// zh: '无法加载账户数据'
	String get loadError => '无法加载账户数据';

	/// zh: '历史记录中缺少账户信息'
	String get historyMissing => '历史记录中缺少账户信息';

	/// zh: '金额待确认'
	String get amountUnconfirmed => '金额待确认';

	/// zh: '已确认：$source → $target'
	String confirmedWithArrow({required Object source, required Object target}) => '已确认：${source} → ${target}';

	/// zh: '确认：$source → $target'
	String confirmAction({required Object source, required Object target}) => '确认：${source} → ${target}';

	/// zh: '请先选择转出账户'
	String get pleaseSelectSource => '请先选择转出账户';

	/// zh: '请选择转入账户'
	String get pleaseSelectTarget => '请选择转入账户';

	/// zh: '确认转账链路'
	String get confirmLinks => '确认转账链路';

	/// zh: '链路已锁定'
	String get linkLocked => '链路已锁定';

	/// zh: '点击下方按钮确认执行'
	String get clickToConfirm => '点击下方按钮确认执行';

	/// zh: '重选'
	String get reselect => '重选';

	/// zh: '转账'
	String get title => '转账';

	/// zh: '历史记录'
	String get history => '历史记录';

	/// zh: '未知账户'
	String get unknownAccount => '未知账户';

	/// zh: '已确认'
	String get confirmed => '已确认';
}

// Path: chat.genui.transactionCard
class TranslationsChatGenuiTransactionCardZh {
	TranslationsChatGenuiTransactionCardZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '交易成功'
	String get title => '交易成功';

	/// zh: '已关联账户'
	String get associatedAccount => '已关联账户';

	/// zh: '不计入资产'
	String get notCounted => '不计入资产';

	/// zh: '修改'
	String get modify => '修改';

	/// zh: '关联账户'
	String get associate => '关联账户';

	/// zh: '选择关联账户'
	String get selectAccount => '选择关联账户';

	/// zh: '暂无可用账户，请先添加账户'
	String get noAccount => '暂无可用账户，请先添加账户';

	/// zh: '交易 ID 缺失，无法更新'
	String get missingId => '交易 ID 缺失，无法更新';

	/// zh: '已关联到 $name'
	String associatedTo({required Object name}) => '已关联到 ${name}';

	/// zh: '更新失败: $error'
	String updateFailed({required Object error}) => '更新失败: ${error}';

	/// zh: '共享空间'
	String get sharedSpace => '共享空间';

	/// zh: '暂无可用共享空间'
	String get noSpace => '暂无可用共享空间';

	/// zh: '选择共享空间'
	String get selectSpace => '选择共享空间';

	/// zh: '已关联到共享空间'
	String get linkedToSpace => '已关联到共享空间';
}

// Path: chat.genui.transactionConfirmation
class TranslationsChatGenuiTransactionConfirmationZh {
	TranslationsChatGenuiTransactionConfirmationZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '检测到多个关联账户'
	String get multipleAccounts => '检测到多个关联账户';

	/// zh: '已确认'
	String get confirmed => '已确认';
}

// Path: chat.genui.budgetAnalysis
class TranslationsChatGenuiBudgetAnalysisZh {
	TranslationsChatGenuiBudgetAnalysisZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '预算分析报告'
	String get title => '预算分析报告';

	/// zh: '过去 $days 天'
	String periodDays({required Object days}) => '过去 ${days} 天';

	/// zh: '总支出'
	String get totalExpense => '总支出';

	/// zh: '环比 $change%'
	String momChange({required Object change}) => '环比 ${change}%';

	/// zh: '分类占比'
	String get categoryDistribution => '分类占比';

	/// zh: '大额支出'
	String get topSpenders => '大额支出';

	/// zh: '$amount万'
	String amountWan({required Object amount}) => '${amount}万';
}

// Path: chat.genui.healthScore.status
class TranslationsChatGenuiHealthScoreStatusZh {
	TranslationsChatGenuiHealthScoreStatusZh.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '财务状况优秀'
	String get excellent => '财务状况优秀';

	/// zh: '财务状况良好'
	String get good => '财务状况良好';

	/// zh: '财务状况一般'
	String get fair => '财务状况一般';

	/// zh: '财务状况需改善'
	String get needsImprovement => '财务状况需改善';

	/// zh: '财务状况较差'
	String get poor => '财务状况较差';
}

/// The flat map containing all translations for locale <zh>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
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
			'amountTheme.chinaMarket' => '中国市场习惯',
			'amountTheme.chinaMarketDesc' => '红涨绿跌/黑跌 (推荐)',
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
			'chat.tools.readFile' => '正在查看文件...',
			'chat.tools.searchTransactions' => '正在查询交易...',
			'chat.tools.queryBudgetStatus' => '正在检查预算...',
			'chat.tools.createBudget' => '正在创建预算计划...',
			'chat.tools.getCashFlowAnalysis' => '正在分析现金流...',
			'chat.tools.getFinancialHealthScore' => '正在计算财务健康分...',
			'chat.tools.getFinancialSummary' => '正在生成财务报告...',
			'chat.tools.evaluateFinancialHealth' => '正在评估财务健康...',
			'chat.tools.forecastBalance' => '正在预测未来余额...',
			'chat.tools.simulateExpenseImpact' => '正在模拟购买影响...',
			'chat.tools.recordTransactions' => '正在记账...',
			'chat.tools.createTransaction' => '正在记账...',
			'chat.tools.duckduckgoSearch' => '正在搜索网络...',
			'chat.tools.executeTransfer' => '正在执行转账...',
			'chat.tools.listDir' => '正在浏览目录...',
			'chat.tools.execute' => '正在执行脚本...',
			'chat.tools.analyzeFinance' => '正在分析财务状况...',
			'chat.tools.forecastFinance' => '正在预测财务趋势...',
			'chat.tools.analyzeBudget' => '正在分析预算...',
			'chat.tools.auditAnalysis' => '正在审计分析...',
			'chat.tools.budgetOps' => '正在处理预算...',
			'chat.tools.createSharedTransaction' => '正在创建共享账单...',
			'chat.tools.listSpaces' => '正在获取共享空间...',
			'chat.tools.querySpaceSummary' => '正在查询空间摘要...',
			'chat.tools.prepareTransfer' => '正在准备转账...',
			'chat.tools.unknown' => '正在处理请求...',
			'chat.tools.done.readFile' => '已查看文件',
			'chat.tools.done.searchTransactions' => '已查询交易',
			'chat.tools.done.queryBudgetStatus' => '已检查预算',
			'chat.tools.done.createBudget' => '已创建预算',
			'chat.tools.done.getCashFlowAnalysis' => '已分析现金流',
			'chat.tools.done.getFinancialHealthScore' => '已计算健康分',
			'chat.tools.done.getFinancialSummary' => '财务报告生成完成',
			'chat.tools.done.evaluateFinancialHealth' => '财务健康评估完成',
			'chat.tools.done.forecastBalance' => '余额预测完成',
			'chat.tools.done.simulateExpenseImpact' => '购买影响模拟完成',
			'chat.tools.done.recordTransactions' => '记账完成',
			'chat.tools.done.createTransaction' => '已完成记账',
			'chat.tools.done.duckduckgoSearch' => '已搜索网络',
			'chat.tools.done.executeTransfer' => '转账完成',
			'chat.tools.done.listDir' => '已浏览目录',
			'chat.tools.done.execute' => '脚本执行完成',
			'chat.tools.done.analyzeFinance' => '财务分析完成',
			'chat.tools.done.forecastFinance' => '财务预测完成',
			'chat.tools.done.analyzeBudget' => '预算分析完成',
			'chat.tools.done.auditAnalysis' => '审计分析完成',
			'chat.tools.done.budgetOps' => '预算处理完成',
			'chat.tools.done.createSharedTransaction' => '共享账单创建完成',
			'chat.tools.done.listSpaces' => '共享空间获取完成',
			'chat.tools.done.querySpaceSummary' => '空间摘要查询完成',
			'chat.tools.done.prepareTransfer' => '转账准备完成',
			'chat.tools.done.unknown' => '处理完成',
			'chat.tools.failed.unknown' => '操作失败',
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
			'chat.searchFailed' => '搜索失败',
			_ => null,
		} ?? switch (path) {
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
