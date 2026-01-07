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
class TranslationsJa extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsJa({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ja,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ja>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsJa _root = this; // ignore: unused_field

	@override
	TranslationsJa $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsJa(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsCommonJa common = _TranslationsCommonJa._(_root);
	@override late final _TranslationsTimeJa time = _TranslationsTimeJa._(_root);
	@override late final _TranslationsGreetingJa greeting = _TranslationsGreetingJa._(_root);
	@override late final _TranslationsNavigationJa navigation = _TranslationsNavigationJa._(_root);
	@override late final _TranslationsAuthJa auth = _TranslationsAuthJa._(_root);
	@override late final _TranslationsTransactionJa transaction = _TranslationsTransactionJa._(_root);
	@override late final _TranslationsHomeJa home = _TranslationsHomeJa._(_root);
	@override late final _TranslationsCommentJa comment = _TranslationsCommentJa._(_root);
	@override late final _TranslationsCalendarJa calendar = _TranslationsCalendarJa._(_root);
	@override late final _TranslationsCategoryJa category = _TranslationsCategoryJa._(_root);
	@override late final _TranslationsSettingsJa settings = _TranslationsSettingsJa._(_root);
	@override late final _TranslationsAppearanceJa appearance = _TranslationsAppearanceJa._(_root);
	@override late final _TranslationsSpeechJa speech = _TranslationsSpeechJa._(_root);
	@override late final _TranslationsAmountThemeJa amountTheme = _TranslationsAmountThemeJa._(_root);
	@override late final _TranslationsLocaleJa locale = _TranslationsLocaleJa._(_root);
	@override late final _TranslationsBudgetJa budget = _TranslationsBudgetJa._(_root);
	@override late final _TranslationsDateRangeJa dateRange = _TranslationsDateRangeJa._(_root);
	@override late final _TranslationsForecastJa forecast = _TranslationsForecastJa._(_root);
	@override late final _TranslationsChatJa chat = _TranslationsChatJa._(_root);
	@override late final _TranslationsFootprintJa footprint = _TranslationsFootprintJa._(_root);
	@override late final _TranslationsMediaJa media = _TranslationsMediaJa._(_root);
	@override late final _TranslationsErrorJa error = _TranslationsErrorJa._(_root);
	@override late final _TranslationsFontTestJa fontTest = _TranslationsFontTestJa._(_root);
	@override late final _TranslationsWizardJa wizard = _TranslationsWizardJa._(_root);
	@override late final _TranslationsUserJa user = _TranslationsUserJa._(_root);
	@override late final _TranslationsAccountJa account = _TranslationsAccountJa._(_root);
	@override late final _TranslationsFinancialJa financial = _TranslationsFinancialJa._(_root);
	@override late final _TranslationsAppJa app = _TranslationsAppJa._(_root);
	@override late final _TranslationsStatisticsJa statistics = _TranslationsStatisticsJa._(_root);
	@override late final _TranslationsCurrencyJa currency = _TranslationsCurrencyJa._(_root);
	@override late final _TranslationsSharedSpaceJa sharedSpace = _TranslationsSharedSpaceJa._(_root);
}

// Path: common
class _TranslationsCommonJa extends TranslationsCommonZh {
	_TranslationsCommonJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get loading => '読み込み中...';
	@override String get error => 'エラー';
	@override String get retry => '再試行';
	@override String get cancel => 'キャンセル';
	@override String get confirm => '確認';
	@override String get save => '保存';
	@override String get delete => '削除';
	@override String get edit => '編集';
	@override String get add => '追加';
	@override String get search => '検索';
	@override String get filter => 'フィルター';
	@override String get sort => '並べ替え';
	@override String get refresh => '更新';
	@override String get more => 'もっと見る';
	@override String get less => 'たたむ';
	@override String get all => 'すべて';
	@override String get none => 'なし';
	@override String get ok => 'OK';
	@override String get unknown => '不明';
	@override String get noData => 'データなし';
	@override String get loadMore => 'さらに読み込む';
	@override String get noMore => 'これ以上ありません';
	@override String get loadFailed => '読み込み失敗';
	@override String get history => '履歴';
	@override String get reset => 'リセット';
}

// Path: time
class _TranslationsTimeJa extends TranslationsTimeZh {
	_TranslationsTimeJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get today => '今日';
	@override String get yesterday => '昨日';
	@override String get dayBeforeYesterday => '一昨日';
	@override String get thisWeek => '今週';
	@override String get thisMonth => '今月';
	@override String get thisYear => '今年';
	@override String get selectDate => '日付を選択';
	@override String get selectTime => '時間を選択';
	@override String get justNow => 'たった今';
	@override String minutesAgo({required Object count}) => '${count}分前';
	@override String hoursAgo({required Object count}) => '${count}時間前';
	@override String daysAgo({required Object count}) => '${count}日前';
	@override String weeksAgo({required Object count}) => '${count}週間前';
}

// Path: greeting
class _TranslationsGreetingJa extends TranslationsGreetingZh {
	_TranslationsGreetingJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get morning => 'おはようございます';
	@override String get afternoon => 'こんにちは';
	@override String get evening => 'こんばんは';
}

// Path: navigation
class _TranslationsNavigationJa extends TranslationsNavigationZh {
	_TranslationsNavigationJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get home => 'ホーム';
	@override String get forecast => '予測';
	@override String get footprint => 'フットプリント';
	@override String get profile => 'マイページ';
}

// Path: auth
class _TranslationsAuthJa extends TranslationsAuthZh {
	_TranslationsAuthJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get login => 'ログイン';
	@override String get loggingIn => 'ログイン中...';
	@override String get logout => 'ログアウト';
	@override String get register => '新規登録';
	@override String get registering => '登録中...';
	@override String get welcomeBack => 'おかえりなさい';
	@override String get loginSuccess => 'おかえりなさい！';
	@override String get loginFailed => 'ログイン失敗';
	@override String get pleaseTryAgain => '後ほど再試行してください。';
	@override String get loginSubtitle => 'AI家計簿アシスタントを利用するにはログインしてください';
	@override String get noAccount => 'アカウントをお持ちでないですか？ 登録';
	@override String get createAccount => 'アカウントを作成';
	@override String get setPassword => 'パスワード設定';
	@override String get setAccountPassword => 'アカウントのパスワードを設定してください';
	@override String get completeRegistration => '登録完了';
	@override String get registrationSuccess => '登録が完了しました！';
	@override String get registrationFailed => '登録失敗';
	@override late final _TranslationsAuthEmailJa email = _TranslationsAuthEmailJa._(_root);
	@override late final _TranslationsAuthPasswordJa password = _TranslationsAuthPasswordJa._(_root);
	@override late final _TranslationsAuthVerificationCodeJa verificationCode = _TranslationsAuthVerificationCodeJa._(_root);
}

// Path: transaction
class _TranslationsTransactionJa extends TranslationsTransactionZh {
	_TranslationsTransactionJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get expense => '支出';
	@override String get income => '収入';
	@override String get transfer => '振替';
	@override String get amount => '金額';
	@override String get category => 'カテゴリー';
	@override String get description => 'メモ';
	@override String get tags => 'タグ';
	@override String get saveTransaction => '記録を保存';
	@override String get pleaseEnterAmount => '金額を入力してください';
	@override String get pleaseSelectCategory => 'カテゴリーを選択してください';
	@override String get saveFailed => '保存に失敗しました';
	@override String get descriptionHint => '取引の詳細を記録...';
	@override String get addCustomTag => 'カスタムタグを追加';
	@override String get commonTags => 'よく使うタグ';
	@override String maxTagsHint({required Object maxTags}) => 'タグは最大 ${maxTags} 個までです';
	@override String get noTransactionsFound => '取引履歴が見つかりません';
	@override String get tryAdjustingSearch => '検索条件を調整するか、新しい取引を作成してください';
	@override String get noDescription => 'メモなし';
	@override String get payment => '支払い';
	@override String get account => '口座';
	@override String get time => '時間';
	@override String get location => '場所';
	@override String get transactionDetail => '取引詳細';
	@override String get favorite => 'お気に入り';
	@override String get confirmDelete => '削除の確認';
	@override String get deleteTransactionConfirm => 'この取引記録を削除してもよろしいですか？この操作は取り消せません。';
	@override String get noActions => '利用可能なアクションはありません';
	@override String get deleted => '削除済み';
	@override String get deleteFailed => '削除に失敗しました。後ほど再試行してください。';
}

// Path: home
class _TranslationsHomeJa extends TranslationsHomeZh {
	_TranslationsHomeJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get totalExpense => '総支出額';
	@override String get todayExpense => '今日の支出';
	@override String get monthExpense => '今月の支出';
	@override String yearProgress({required Object year}) => '${year}年の進捗';
	@override String get amountHidden => '••••••••';
	@override String get loadFailed => '読み込み失敗';
	@override String get noTransactions => '取引履歴なし';
	@override String get tryRefresh => '更新してください';
	@override String get noMoreData => 'これ以上のデータはありません';
	@override String get userNotLoggedIn => 'ユーザーがログインしていないため、データを読み込めません';
}

// Path: comment
class _TranslationsCommentJa extends TranslationsCommentZh {
	_TranslationsCommentJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get error => 'エラー';
	@override String get commentFailed => 'コメントに失敗しました';
	@override String replyToPrefix({required Object name}) => '@${name} さんに返信:';
	@override String get reply => '返信';
	@override String get addNote => '備考を追加...';
	@override String get confirmDeleteTitle => '削除の確認';
	@override String get confirmDeleteContent => 'このコメントを削除してもよろしいですか？この操作は取り消せません。';
	@override String get success => '成功';
	@override String get commentDeleted => 'コメントを削除しました';
	@override String get deleteFailed => '削除失敗';
	@override String get deleteComment => 'コメント削除';
	@override String get hint => 'ヒント';
	@override String get noActions => '利用可能なアクションはありません';
	@override String get note => '備考';
	@override String get noNote => '備考なし';
	@override String get loadFailed => '備考の読み込みに失敗しました';
}

// Path: calendar
class _TranslationsCalendarJa extends TranslationsCalendarZh {
	_TranslationsCalendarJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '家計カレンダー';
	@override late final _TranslationsCalendarWeekdaysJa weekdays = _TranslationsCalendarWeekdaysJa._(_root);
	@override String get loadFailed => 'カレンダーデータの読み込みに失敗しました';
	@override String thisMonth({required Object amount}) => '今月: ${amount}';
	@override String get counting => '集計中...';
	@override String get unableToCount => '集計不可';
	@override String get trend => '傾向: ';
	@override String get noTransactionsTitle => 'この日の取引はありません';
	@override String get loadTransactionFailed => '取引の読み込みに失敗しました';
}

// Path: category
class _TranslationsCategoryJa extends TranslationsCategoryZh {
	_TranslationsCategoryJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get dailyConsumption => '生活費';
	@override String get transportation => '交通費';
	@override String get healthcare => '医療・健康';
	@override String get housing => '住居費';
	@override String get education => '教育・学習';
	@override String get incomeCategory => '収入';
	@override String get socialGifts => '交際・贈り物';
	@override String get moneyTransfer => '資金移動';
	@override String get other => 'その他';
	@override String get foodDining => '食費・外食';
	@override String get shoppingRetail => '買い物';
	@override String get housingUtilities => '住居・光熱費';
	@override String get personalCare => '美容・ケア';
	@override String get entertainment => '娯楽・レジャー';
	@override String get medicalHealth => '医療費';
	@override String get insurance => '保険';
	@override String get socialGifting => '冠婚葬祭';
	@override String get financialTax => '金融・税金';
	@override String get others => 'その他支出';
	@override String get salaryWage => '給与・報酬';
	@override String get businessTrade => '事業収入';
	@override String get investmentReturns => '投資収益';
	@override String get giftBonus => 'お祝い・ボーナス';
	@override String get refundRebate => '還付・ポイント';
	@override String get generalTransfer => '振替';
	@override String get debtRepayment => '債務返済';
}

// Path: settings
class _TranslationsSettingsJa extends TranslationsSettingsZh {
	_TranslationsSettingsJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '設定';
	@override String get language => '言語';
	@override String get languageSettings => '言語設定';
	@override String get selectLanguage => '言語を選択';
	@override String get languageChanged => '言語を変更しました';
	@override String get restartToApply => '変更を適用するにはアプリを再起動してください';
	@override String get theme => 'テーマ';
	@override String get darkMode => 'ダークモード';
	@override String get lightMode => 'ライトモード';
	@override String get systemMode => 'システムに従う';
	@override String get developerOptions => '開発者オプション';
	@override String get authDebug => '認証デバッグ';
	@override String get authDebugSubtitle => '認証ステータスとデバッグ情報を確認';
	@override String get fontTest => 'フォントテスト';
	@override String get fontTestSubtitle => 'フォントの表示効果をテスト';
	@override String get helpAndFeedback => 'ヘルプとフィードバック';
	@override String get helpAndFeedbackSubtitle => 'ヘルプの参照またはフィードバック送信';
	@override String get aboutApp => 'アプリについて';
	@override String get aboutAppSubtitle => 'バージョン情報と開発者情報';
	@override String currencyChangedRefreshHint({required Object currency}) => '${currency} に切り替えました。新しい取引はこの通貨で記録されます';
	@override String get sharedSpace => '共有スペース';
	@override String get speechRecognition => '音声認識';
	@override String get speechRecognitionSubtitle => '音声入力パラメータを設定';
	@override String get amountDisplayStyle => '金額表示スタイル';
	@override String get currency => '表示通貨';
	@override String get appearance => '外観設定';
	@override String get appearanceSubtitle => 'テーマモードと配色';
	@override String get speechTest => '音声テスト';
	@override String get speechTestSubtitle => 'WebSocket音声接続をテスト';
	@override String get userTypeRegular => '一般ユーザー';
	@override String get selectAmountStyle => '金額表示スタイルを選択';
	@override String get currencyDescription => '使用する通貨を選択してください。すべての金額がこの通貨で表示されます。';
}

// Path: appearance
class _TranslationsAppearanceJa extends TranslationsAppearanceZh {
	_TranslationsAppearanceJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '外観設定';
	@override String get themeMode => 'テーマモード';
	@override String get light => 'ライト';
	@override String get dark => 'ダーク';
	@override String get system => 'システム';
	@override String get colorScheme => '配色';
}

// Path: speech
class _TranslationsSpeechJa extends TranslationsSpeechZh {
	_TranslationsSpeechJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '音声認識設定';
	@override String get service => '音声認識サービス';
	@override String get systemVoice => 'システム音声';
	@override String get systemVoiceSubtitle => 'スマホ内蔵の音声認識サービス（推奨）';
	@override String get selfHostedASR => '自作 ASR サービス';
	@override String get selfHostedASRSubtitle => 'WebSocket経由で自作ASRサーバーに接続';
	@override String get serverConfig => 'サーバー設定';
	@override String get serverAddress => 'サーバーアドレス';
	@override String get port => 'ポート';
	@override String get path => 'パス';
	@override String get saveConfig => '設定を保存';
	@override String get info => '情報';
	@override String get infoContent => '• システム音声：内蔵サービスを使用。設定不要で高速です。\n• 自作 ASR：カスタムモデルやオフライン環境用。\n\n変更は次回の音声入力から有効になります。';
	@override String get enterAddress => 'サーバーアドレスを入力してください';
	@override String get enterValidPort => '有効なポート番号(1-65535)を入力してください';
	@override String get configSaved => '設定を保存しました';
}

// Path: amountTheme
class _TranslationsAmountThemeJa extends TranslationsAmountThemeZh {
	_TranslationsAmountThemeJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get chinaMarket => '中国市場慣習';
	@override String get chinaMarketDesc => '赤上昇/緑下落（推奨）';
	@override String get international => '国際標準';
	@override String get internationalDesc => '緑上昇/赤下落';
	@override String get minimalist => 'ミニマリスト';
	@override String get minimalistDesc => '記号のみで区別';
	@override String get colorBlind => '色覚サポート';
	@override String get colorBlindDesc => '青・オレンジ配色';
}

// Path: locale
class _TranslationsLocaleJa extends TranslationsLocaleZh {
	_TranslationsLocaleJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get chinese => '簡体字中国語';
	@override String get english => 'English';
	@override String get japanese => '日本語';
	@override String get korean => '한국어';
	@override String get traditionalChinese => '繁体字中国語';
}

// Path: budget
class _TranslationsBudgetJa extends TranslationsBudgetZh {
	_TranslationsBudgetJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '予算管理';
	@override String get detail => '予算詳細';
	@override String get info => '予算情報';
	@override String get totalBudget => '総予算';
	@override String get categoryBudget => 'カテゴリー別予算';
	@override String get monthlySummary => '今月の予算サマリー';
	@override String get used => '使用済み';
	@override String get remaining => '残り';
	@override String get overspent => '予算超過';
	@override String get budget => '予算';
	@override String get loadFailed => '読み込み失敗';
	@override String get noBudget => '予算未設定';
	@override String get createHint => 'Augoアシスタントに「予算を設定して」と言って作成';
	@override String get paused => '一時停止中';
	@override String get pause => '停止';
	@override String get resume => '再開';
	@override String get budgetPaused => '予算管理を停止しました';
	@override String get budgetResumed => '予算管理を再開しました';
	@override String get operationFailed => '操作に失敗しました';
	@override String get deleteBudget => '予算を削除';
	@override String get deleteConfirm => 'この予算を削除してもよろしいですか？取り消せません。';
	@override String get type => 'タイプ';
	@override String get category => 'カテゴリー';
	@override String get period => '周期';
	@override String get rollover => '予算繰越';
	@override String get rolloverBalance => '繰越残高';
	@override String get enabled => '有効';
	@override String get disabled => '無効';
	@override String get statusNormal => '予算内';
	@override String get statusWarning => '上限接近';
	@override String get statusOverspent => '超過';
	@override String get statusAchieved => '目標達成';
	@override String tipNormal({required Object amount}) => '残り ${amount} 利用可能';
	@override String tipWarning({required Object amount}) => '残り ${amount} です。ご注意ください';
	@override String tipOverspent({required Object amount}) => '${amount} 超過しています';
	@override String get tipAchieved => '貯金目標達成おめでとうございます！';
	@override String remainingAmount({required Object amount}) => '残り ${amount}';
	@override String overspentAmount({required Object amount}) => '超過 ${amount}';
	@override String budgetAmount({required Object amount}) => '予算 ${amount}';
	@override String get active => '有効';
	@override String get all => 'すべて';
	@override String get notFound => '予算が存在しないか削除されました';
	@override String get setup => '予算設定';
	@override String get settings => '予算設定';
	@override String get setAmount => '予算額を設定';
	@override String get setAmountDesc => '各カテゴリーの予算額を設定';
	@override String get monthly => '月次予算';
	@override String get monthlyDesc => '月単位で支出を管理します（推奨）';
	@override String get weekly => '週次予算';
	@override String get weeklyDesc => '週単位で細かく管理します';
	@override String get yearly => '年次予算';
	@override String get yearlyDesc => '長期的な計画や大きな支出用';
	@override String get editBudget => '予算を編集';
	@override String get editBudgetDesc => '予算額やカテゴリーを変更';
	@override String get reminderSettings => '通知設定';
	@override String get reminderSettingsDesc => '予算通知やリマインダーを設定';
	@override String get report => '予算レポート';
	@override String get reportDesc => '詳細な予算分析レポートを表示';
	@override String get welcome => '予算機能へようこそ！';
	@override String get createNewPlan => '新しい予算プランを作成';
	@override String get welcomeDesc => '予算を設定することで、支出をコントロールし財務目標を達成できます。';
	@override String get createDesc => 'カテゴリー別の予算上限を設定して、家計管理をサポートします。';
	@override String get newBudget => '新規予算';
	@override String get budgetAmountLabel => '予算額';
	@override String get currency => '通貨';
	@override String get periodSettings => '期間設定';
	@override String get autoGenerateTransactions => '有効にするとルールに従い自動記帳します';
	@override String get cycle => 'サイクル';
	@override String get budgetCategory => '予算カテゴリー';
	@override String get advancedOptions => '詳細オプション';
	@override String get periodType => '期間タイプ';
	@override String get anchorDay => '開始日';
	@override String get selectPeriodType => '期間タイプを選択';
	@override String get selectAnchorDay => '開始日を選択';
	@override String get rolloverDescription => '未使用分を翌期に繰り越す';
	@override String get createBudget => '予算を作成';
	@override String get save => '保存';
	@override String get pleaseEnterAmount => '予算額を入力してください';
	@override String get invalidAmount => '有効な金額を入力してください';
	@override String get updateSuccess => '予算を更新しました';
	@override String get createSuccess => '予算を作成しました';
	@override String get deleteSuccess => '予算を削除しました';
	@override String get deleteFailed => '削除に失敗しました';
	@override String everyMonthDay({required Object day}) => '毎月 ${day} 日';
	@override String get periodWeekly => '毎週';
	@override String get periodBiweekly => '2週間ごと';
	@override String get periodMonthly => '毎月';
	@override String get periodYearly => '毎年';
	@override String get statusActive => '進行中';
	@override String get statusArchived => 'アーカイブ済み';
	@override String get periodStatusOnTrack => '順調';
	@override String get periodStatusWarning => '警告';
	@override String get periodStatusExceeded => '超過';
	@override String get periodStatusAchieved => '達成';
	@override String usedPercent({required Object percent}) => '${percent}% 使用済み';
	@override String dayOfMonth({required Object day}) => '${day} 日';
	@override String get tenThousandSuffix => '万';
}

// Path: dateRange
class _TranslationsDateRangeJa extends TranslationsDateRangeZh {
	_TranslationsDateRangeJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get custom => 'カスタム';
	@override String get pickerTitle => '期間を選択';
	@override String get startDate => '開始日';
	@override String get endDate => '終了日';
	@override String get hint => '日付範囲を選択してください';
}

// Path: forecast
class _TranslationsForecastJa extends TranslationsForecastZh {
	_TranslationsForecastJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '予測';
	@override String get subtitle => 'データに基づき将来のキャッシュフローを予測します';
	@override String get financialNavigator => 'こんにちは、あなたの財務ナビゲーターです';
	@override String get financialMapSubtitle => '3ステップで、あなたの将来の財務マップを一緒に作成しましょう';
	@override String get predictCashFlow => '将来のキャッシュフローを予測';
	@override String get predictCashFlowDesc => '日々の財務状況を可視化';
	@override String get aiSmartSuggestions => 'AIスマートアドバイス';
	@override String get aiSmartSuggestionsDesc => 'パーソナライズされた財務ガイダンス';
	@override String get riskWarning => 'リスク警告';
	@override String get riskWarningDesc => '潜在的なリスクを事前に察知';
	@override String get analyzing => '財務データを分析し、今後30日間の予測を生成しています';
	@override String get analyzePattern => '収支パターンの分析';
	@override String get calculateTrend => 'トレンドの計算';
	@override String get generateWarning => 'リスク警告の生成';
	@override String get loadingForecast => '予測を読み込み中...';
	@override String get todayLabel => '今日';
	@override String get tomorrowLabel => '明日';
	@override String get balanceLabel => '残高';
	@override String get noSpecialEvents => '特別なイベントはありません';
	@override String get financialSafetyLine => 'セーフティライン';
	@override String get currentSetting => '現在の設定';
	@override String get dailySpendingEstimate => '1日の支出見積もり';
	@override String get adjustDailySpendingAmount => '予測金額を調整';
	@override String get tellMeYourSafetyLine => 'あなたの「安心できる最低残高」はいくらですか？';
	@override String get safetyLineDescription => '口座に維持したい最低額です。この額に近づくと警告します。';
	@override String get dailySpendingQuestion => '1日の生活費はいくらくらいですか？';
	@override String get dailySpendingDescription => '食費、交通費、買い物など。今後の記録から予測精度を向上させます。';
	@override String get perDay => '1日あたり';
	@override String get referenceStandard => '参考基準';
	@override String get frugalType => '節約型';
	@override String get comfortableType => '標準型';
	@override String get relaxedType => 'ゆとり型';
	@override String get frugalAmount => '1,000円-2,000円/日';
	@override String get comfortableAmount => '2,000円-4,000円/日';
	@override String get relaxedAmount => '4,000円-6,000円/日';
	@override late final _TranslationsForecastRecurringTransactionJa recurringTransaction = _TranslationsForecastRecurringTransactionJa._(_root);
}

// Path: chat
class _TranslationsChatJa extends TranslationsChatZh {
	_TranslationsChatJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get newChat => '新しいチャット';
	@override String get noMessages => 'メッセージがありません。';
	@override String get loadingFailed => '読み込み失敗';
	@override String get inputMessage => 'メッセージを入力...';
	@override String get listening => '聞き取り中...';
	@override String get aiThinking => '処理中...';
	@override late final _TranslationsChatToolsJa tools = _TranslationsChatToolsJa._(_root);
	@override String get speechNotRecognized => '音声を認識できませんでした';
	@override String get currentExpense => '今回の支出';
	@override String get loadingComponent => 'コンポーネントを読み込み中...';
	@override String get noHistory => '履歴がありません';
	@override String get startNewChat => '新しい会話を始めましょう！';
	@override String get searchHint => 'チャットを検索';
	@override String get library => 'ライブラリ';
	@override String get viewProfile => 'プロフィールを表示';
	@override String get noRelatedFound => '関連する会話が見つかりません';
	@override String get tryOtherKeywords => '他のキーワードで検索してください';
	@override String get searchFailed => '検索失敗';
	@override String get deleteConversation => 'チャットを削除';
	@override String get deleteConversationConfirm => 'このチャットを削除してもよろしいですか？この操作は取り消せません。';
	@override String get conversationDeleted => 'チャットを削除しました';
	@override String get deleteConversationFailed => 'チャットの削除に失敗しました';
	@override late final _TranslationsChatTransferWizardJa transferWizard = _TranslationsChatTransferWizardJa._(_root);
	@override late final _TranslationsChatGenuiJa genui = _TranslationsChatGenuiJa._(_root);
}

// Path: footprint
class _TranslationsFootprintJa extends TranslationsFootprintZh {
	_TranslationsFootprintJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get searchIn => '検索';
	@override String get searchInAllRecords => 'すべての記録から検索';
}

// Path: media
class _TranslationsMediaJa extends TranslationsMediaZh {
	_TranslationsMediaJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get selectPhotos => '写真を選択';
	@override String get addFiles => 'ファイルを追加';
	@override String get takePhoto => '写真を撮る';
	@override String get camera => 'カメラ';
	@override String get photos => '写真';
	@override String get files => 'ファイル';
	@override String get showAll => 'すべて表示';
	@override String get allPhotos => 'すべての写真';
	@override String get takingPhoto => '撮影中...';
	@override String get photoTaken => '写真を保存しました';
	@override String get cameraPermissionRequired => 'カメラの権限が必要です';
	@override String get fileSizeExceeded => 'ファイルサイズが10MBを超えています';
	@override String get unsupportedFormat => 'サポートされていない形式です';
	@override String get permissionDenied => 'アルバムへのアクセス権限が必要です';
	@override String get storageInsufficient => 'ストレージ容量が不足しています';
	@override String get networkError => 'ネットワークエラー';
	@override String get unknownUploadError => '不明なアップロードエラー';
}

// Path: error
class _TranslationsErrorJa extends TranslationsErrorZh {
	_TranslationsErrorJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get permissionRequired => '権限が必要です';
	@override String get permissionInstructions => '設定から権限を許可してください。';
	@override String get openSettings => '設定を開く';
	@override String get fileTooLarge => 'ファイルが大きすぎます';
	@override String get fileSizeHint => '10MB以下のファイルを選択してください。';
	@override String get supportedFormatsHint => '対応形式：画像、PDF、ドキュメント、音声など。';
	@override String get storageCleanupHint => '空き容量を確保して再試行してください。';
	@override String get networkErrorHint => '接続を確認して再試行してください。';
	@override String get platformNotSupported => 'サポートされていないプラットフォーム';
	@override String get fileReadError => '読み込み失敗';
	@override String get fileReadErrorHint => 'ファイルが破損している可能性があります。';
	@override String get validationError => '検証エラー';
	@override String get unknownError => '不明なエラー';
	@override String get unknownErrorHint => '予期せぬエラーが発生しました。';
	@override late final _TranslationsErrorGenuiJa genui = _TranslationsErrorGenuiJa._(_root);
}

// Path: fontTest
class _TranslationsFontTestJa extends TranslationsFontTestZh {
	_TranslationsFontTestJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get page => 'テストページ';
	@override String get displayTest => '表示テスト';
	@override String get chineseTextTest => '中国語テスト';
	@override String get englishTextTest => '英語テスト';
	@override String get sample1 => 'これはテスト用のテキストです。';
	@override String get sample2 => '支出分析：ショッピングが最多';
	@override String get sample3 => 'AIアシスタントによる財務分析';
	@override String get sample4 => 'グラフで消費トレンドを確認';
	@override String get sample5 => '各種決済サービスに対応';
}

// Path: wizard
class _TranslationsWizardJa extends TranslationsWizardZh {
	_TranslationsWizardJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get nextStep => '次へ';
	@override String get previousStep => '前へ';
	@override String get completeMapping => 'マップ作成完了';
}

// Path: user
class _TranslationsUserJa extends TranslationsUserZh {
	_TranslationsUserJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get username => 'ユーザー名';
	@override String get defaultEmail => 'user@example.com';
}

// Path: account
class _TranslationsAccountJa extends TranslationsAccountZh {
	_TranslationsAccountJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get editTitle => '口座を編集';
	@override String get addTitle => '新しい口座';
	@override String get selectTypeTitle => '口座タイプを選択';
	@override String get nameLabel => '口座名';
	@override String get amountLabel => '現在の残高';
	@override String get currencyLabel => '通貨';
	@override String get hiddenLabel => '非表示';
	@override String get hiddenDesc => 'リストに表示しない';
	@override String get includeInNetWorthLabel => '資産に含める';
	@override String get includeInNetWorthDesc => '純資産の統計に使用';
	@override String get nameHint => '例：給与振込口座';
	@override String get amountHint => '0.00';
	@override String get deleteAccount => '口座を削除';
	@override String get deleteConfirm => 'この口座を削除しますか？取り消せません。';
	@override String get save => '変更を保存';
	@override String get assetsCategory => '資産';
	@override String get liabilitiesCategory => '負債/クレジット';
	@override String get cash => '現金・財布';
	@override String get deposit => '銀行預金';
	@override String get creditCard => 'クレジットカード';
	@override String get investment => '投資・資産運用';
	@override String get eWallet => '電子マネー';
	@override String get loan => 'ローン';
	@override String get receivable => '売掛金・貸付';
	@override String get payable => '買掛金・借入';
	@override String get other => 'その他';
}

// Path: financial
class _TranslationsFinancialJa extends TranslationsFinancialZh {
	_TranslationsFinancialJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '財務';
	@override String get management => '財務管理';
	@override String get netWorth => '純資産';
	@override String get assets => '総資産';
	@override String get liabilities => '総負債';
	@override String get noAccounts => '口座なし';
	@override String get addFirstAccount => 'ボタンを押して口座を追加してください';
	@override String get assetAccounts => '資産口座';
	@override String get liabilityAccounts => '負債口座';
	@override String get selectCurrency => '通貨を選択';
	@override String get cancel => 'キャンセル';
	@override String get confirm => '確定';
	@override String get settings => '財務設定';
	@override String get budgetManagement => '予算管理';
	@override String get recurringTransactions => '繰り返し取引';
	@override String get safetyThreshold => 'セーフティライン';
	@override String get dailyBurnRate => '1日の支出';
	@override String get financialAssistant => '財務アシスタント';
	@override String get manageFinancialSettings => '財務設定を管理';
	@override String get safetyThresholdSettings => 'セーフティライン設定';
	@override String get setSafetyThreshold => 'セーフティラインの閾値を設定';
	@override String get safetyThresholdSaved => 'セーフティラインを保存しました';
	@override String get dailyBurnRateSettings => '支出見積もり';
	@override String get setDailyBurnRate => '1日の支出見積もりを設定';
	@override String get dailyBurnRateSaved => '支出見積もりを保存しました';
	@override String get saveFailed => '保存失敗';
}

// Path: app
class _TranslationsAppJa extends TranslationsAppZh {
	_TranslationsAppJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get splashTitle => 'スマートに、豊かに。';
	@override String get splashSubtitle => 'インテリジェント財務アシスタント';
}

// Path: statistics
class _TranslationsStatisticsJa extends TranslationsStatisticsZh {
	_TranslationsStatisticsJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '統計分析';
	@override String get analyze => '分析';
	@override String get exportInProgress => 'エクスポート機能は開発中です...';
	@override String get ranking => '高額支出ランキング';
	@override String get noData => 'データなし';
	@override late final _TranslationsStatisticsOverviewJa overview = _TranslationsStatisticsOverviewJa._(_root);
	@override late final _TranslationsStatisticsTrendJa trend = _TranslationsStatisticsTrendJa._(_root);
	@override late final _TranslationsStatisticsAnalysisJa analysis = _TranslationsStatisticsAnalysisJa._(_root);
	@override late final _TranslationsStatisticsFilterJa filter = _TranslationsStatisticsFilterJa._(_root);
	@override late final _TranslationsStatisticsSortJa sort = _TranslationsStatisticsSortJa._(_root);
	@override String get exportList => 'リストを書き出す';
}

// Path: currency
class _TranslationsCurrencyJa extends TranslationsCurrencyZh {
	_TranslationsCurrencyJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get cny => '人民元';
	@override String get usd => 'USドル';
	@override String get eur => 'ユーロ';
	@override String get jpy => '日本円';
	@override String get gbp => '英ポンド';
	@override String get aud => '豪ドル';
	@override String get cad => 'カナダドル';
	@override String get chf => 'スイスフラン';
	@override String get rub => 'ロシアルーブル';
	@override String get hkd => '香港ドル';
	@override String get twd => '新台湾ドル';
	@override String get inr => 'インドルピー';
}

// Path: sharedSpace
class _TranslationsSharedSpaceJa extends TranslationsSharedSpaceZh {
	_TranslationsSharedSpaceJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSharedSpaceDashboardJa dashboard = _TranslationsSharedSpaceDashboardJa._(_root);
	@override late final _TranslationsSharedSpaceRolesJa roles = _TranslationsSharedSpaceRolesJa._(_root);
}

// Path: auth.email
class _TranslationsAuthEmailJa extends TranslationsAuthEmailZh {
	_TranslationsAuthEmailJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => 'メールアドレス';
	@override String get placeholder => 'メールアドレスを入力してください';
	@override String get required => 'メールアドレスは必須です';
	@override String get invalid => '有効なメールアドレスを入力してください';
}

// Path: auth.password
class _TranslationsAuthPasswordJa extends TranslationsAuthPasswordZh {
	_TranslationsAuthPasswordJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => 'パスワード';
	@override String get placeholder => 'パスワードを入力してください';
	@override String get required => 'パスワードは必須です';
	@override String get tooShort => 'パスワードは6文字以上で入力してください';
	@override String get mustContainNumbersAndLetters => 'パスワードは英数字を含める必要があります';
	@override String get confirm => 'パスワード確認';
	@override String get confirmPlaceholder => 'もう一度パスワードを入力してください';
	@override String get mismatch => 'パスワードが一致しません';
}

// Path: auth.verificationCode
class _TranslationsAuthVerificationCodeJa extends TranslationsAuthVerificationCodeZh {
	_TranslationsAuthVerificationCodeJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => '認証コード';
	@override String get get => 'コードを取得';
	@override String get sending => '送信中...';
	@override String get sent => '認証コードを送信しました';
	@override String get sendFailed => '送信失敗';
	@override String get placeholder => '認証コードを入力';
	@override String get required => '認証コードは必須です';
}

// Path: calendar.weekdays
class _TranslationsCalendarWeekdaysJa extends TranslationsCalendarWeekdaysZh {
	_TranslationsCalendarWeekdaysJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get mon => '月';
	@override String get tue => '火';
	@override String get wed => '水';
	@override String get thu => '木';
	@override String get fri => '金';
	@override String get sat => '土';
	@override String get sun => '日';
}

// Path: forecast.recurringTransaction
class _TranslationsForecastRecurringTransactionJa extends TranslationsForecastRecurringTransactionZh {
	_TranslationsForecastRecurringTransactionJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '繰り返し取引';
	@override String get all => 'すべて';
	@override String get expense => '支出';
	@override String get income => '収入';
	@override String get transfer => '振替';
	@override String get noRecurring => '繰り返し取引なし';
	@override String get createHint => '設定すると、システムが自動で取引を記録します';
	@override String get create => '繰り返し取引を作成';
	@override String get edit => '繰り返し取引を編集';
	@override String get newTransaction => '新規繰り返し取引';
	@override String deleteConfirm({required Object name}) => '繰り返し取引「${name}」を削除しますか？';
	@override String activateConfirm({required Object name}) => '「${name}」を有効にしますか？自動記帳が始まります。';
	@override String pauseConfirm({required Object name}) => '「${name}」を一時停止しますか？';
	@override String get created => '作成しました';
	@override String get updated => '更新しました';
	@override String get activated => '有効化';
	@override String get paused => '停止中';
	@override String get nextTime => '次回';
	@override String get sortByTime => '時間順';
	@override String get allPeriod => 'すべての周期';
	@override String periodCount({required Object type, required Object count}) => '${type} (${count} 件)';
	@override String get confirmDelete => '削除確認';
	@override String get confirmActivate => '有効化確認';
	@override String get confirmPause => '停止確認';
	@override String get dynamicAmount => '動態平均';
	@override String get dynamicAmountTitle => '金額の確認が必要';
	@override String get dynamicAmountDescription => '通知が届いたら金額を確認して記帳を完了させてください。';
}

// Path: chat.tools
class _TranslationsChatToolsJa extends TranslationsChatToolsZh {
	_TranslationsChatToolsJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get processing => '処理中...';
	@override String get readFile => 'ファイルを確認中...';
	@override String get searchTransactions => '取引を検索中...';
	@override String get queryBudgetStatus => '予算を確認中...';
	@override String get createBudget => '予算プランを作成中...';
	@override String get getCashFlowAnalysis => 'キャッシュフローを分析中...';
	@override String get getFinancialHealthScore => '財務スコアを計算中...';
	@override String get getFinancialSummary => 'レポートを生成中...';
	@override String get evaluateFinancialHealth => '財務状況を評価中...';
	@override String get forecastBalance => '残高を予測中...';
	@override String get simulateExpenseImpact => '影響をシミュレーション中...';
	@override String get recordTransactions => '記帳中...';
	@override String get createTransaction => '記帳中...';
	@override String get duckduckgoSearch => 'ウェブを検索中...';
	@override String get executeTransfer => '振替を実行中...';
	@override String get listDir => 'ディレクトリを表示中...';
	@override String get execute => 'スクリプトを実行中...';
	@override String get analyzeFinance => '財務分析中...';
	@override String get forecastFinance => 'トレンド予測中...';
	@override String get analyzeBudget => '予算分析中...';
	@override String get auditAnalysis => '監査分析中...';
	@override String get budgetOps => '予算を処理中...';
	@override String get createSharedTransaction => '共有帳簿を作成中...';
	@override String get listSpaces => '共有スペースを取得中...';
	@override String get querySpaceSummary => 'スペース概要を確認中...';
	@override String get prepareTransfer => '振替を準備中...';
	@override String get unknown => 'リクエストを処理中...';
	@override late final _TranslationsChatToolsDoneJa done = _TranslationsChatToolsDoneJa._(_root);
	@override late final _TranslationsChatToolsFailedJa failed = _TranslationsChatToolsFailedJa._(_root);
}

// Path: chat.transferWizard
class _TranslationsChatTransferWizardJa extends TranslationsChatTransferWizardZh {
	_TranslationsChatTransferWizardJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '振替ウィザード';
	@override String get amount => '振替金額';
	@override String get amountHint => '金額を入力';
	@override String get sourceAccount => '振替元口座';
	@override String get targetAccount => '振替先口座';
	@override String get selectAccount => '口座を選択してください';
	@override String get confirmTransfer => '振替を確認';
	@override String get confirmed => '確認済み';
	@override String get transferSuccess => '振替が完了しました';
}

// Path: chat.genui
class _TranslationsChatGenuiJa extends TranslationsChatGenuiZh {
	_TranslationsChatGenuiJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsChatGenuiExpenseSummaryJa expenseSummary = _TranslationsChatGenuiExpenseSummaryJa._(_root);
	@override late final _TranslationsChatGenuiTransactionListJa transactionList = _TranslationsChatGenuiTransactionListJa._(_root);
	@override late final _TranslationsChatGenuiTransactionGroupReceiptJa transactionGroupReceipt = _TranslationsChatGenuiTransactionGroupReceiptJa._(_root);
	@override late final _TranslationsChatGenuiTransactionCardJa transactionCard = _TranslationsChatGenuiTransactionCardJa._(_root);
	@override late final _TranslationsChatGenuiCashFlowCardJa cashFlowCard = _TranslationsChatGenuiCashFlowCardJa._(_root);
}

// Path: error.genui
class _TranslationsErrorGenuiJa extends TranslationsErrorGenuiZh {
	_TranslationsErrorGenuiJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get loadingFailed => '読み込み失敗';
	@override String get schemaFailed => '検証失敗';
	@override String get schemaDescription => '定義が仕様に適合していません';
	@override String get networkError => 'ネットワークエラー';
	@override String retryStatus({required Object retryCount, required Object maxRetries}) => '再試行中 ${retryCount}/${maxRetries}';
	@override String get maxRetriesReached => '最大試行回数に達しました';
}

// Path: statistics.overview
class _TranslationsStatisticsOverviewJa extends TranslationsStatisticsOverviewZh {
	_TranslationsStatisticsOverviewJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get balance => '残高';
	@override String get income => '総収入';
	@override String get expense => '総支出';
}

// Path: statistics.trend
class _TranslationsStatisticsTrendJa extends TranslationsStatisticsTrendZh {
	_TranslationsStatisticsTrendJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '収支推移';
	@override String get expense => '支出';
	@override String get income => '収入';
}

// Path: statistics.analysis
class _TranslationsStatisticsAnalysisJa extends TranslationsStatisticsAnalysisZh {
	_TranslationsStatisticsAnalysisJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '支出分析';
	@override String get total => '合計';
	@override String get breakdown => 'カテゴリー詳細';
}

// Path: statistics.filter
class _TranslationsStatisticsFilterJa extends TranslationsStatisticsFilterZh {
	_TranslationsStatisticsFilterJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get accountType => '口座タイプ';
	@override String get allAccounts => 'すべての口座';
	@override String get apply => '適用';
}

// Path: statistics.sort
class _TranslationsStatisticsSortJa extends TranslationsStatisticsSortZh {
	_TranslationsStatisticsSortJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get amount => '金額順';
	@override String get date => '日付順';
}

// Path: sharedSpace.dashboard
class _TranslationsSharedSpaceDashboardJa extends TranslationsSharedSpaceDashboardZh {
	_TranslationsSharedSpaceDashboardJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get cumulativeTotalExpense => '累計総支出';
	@override String get participatingMembers => '参加メンバー';
	@override String membersCount({required Object count}) => '${count} 人';
	@override String get averagePerMember => 'メンバー平均';
	@override String get spendingDistribution => 'メンバー別支出割合';
	@override String get realtimeUpdates => 'リアルタイム更新';
	@override String get paid => '支払い済み';
}

// Path: sharedSpace.roles
class _TranslationsSharedSpaceRolesJa extends TranslationsSharedSpaceRolesZh {
	_TranslationsSharedSpaceRolesJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get owner => 'オーナー';
	@override String get admin => '管理者';
	@override String get member => 'メンバー';
}

// Path: chat.tools.done
class _TranslationsChatToolsDoneJa extends TranslationsChatToolsDoneZh {
	_TranslationsChatToolsDoneJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get readFile => 'ファイルを確認しました';
	@override String get searchTransactions => '取引を検索しました';
	@override String get queryBudgetStatus => '予算を確認しました';
	@override String get createBudget => '予算を作成しました';
	@override String get getCashFlowAnalysis => 'キャッシュフローを分析しました';
	@override String get getFinancialHealthScore => 'スコアを計算しました';
	@override String get getFinancialSummary => 'レポート生成完了';
	@override String get evaluateFinancialHealth => '財務評価完了';
	@override String get forecastBalance => '残高予測完了';
	@override String get simulateExpenseImpact => 'シミュレーション完了';
	@override String get recordTransactions => '記帳完了';
	@override String get createTransaction => '記帳しました';
	@override String get duckduckgoSearch => '検索完了';
	@override String get executeTransfer => '振替完了';
	@override String get listDir => 'ディレクトリ表示完了';
	@override String get execute => '実行完了';
	@override String get analyzeFinance => '分析完了';
	@override String get forecastFinance => '予測完了';
	@override String get analyzeBudget => '予算分析完了';
	@override String get auditAnalysis => '監査完了';
	@override String get budgetOps => '予算処理完了';
	@override String get createSharedTransaction => '共有帳簿作成完了';
	@override String get listSpaces => '共有スペース取得完了';
	@override String get querySpaceSummary => '概要確認完了';
	@override String get prepareTransfer => '準備完了';
	@override String get unknown => '完了しました';
}

// Path: chat.tools.failed
class _TranslationsChatToolsFailedJa extends TranslationsChatToolsFailedZh {
	_TranslationsChatToolsFailedJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get unknown => '操作に失敗しました';
}

// Path: chat.genui.expenseSummary
class _TranslationsChatGenuiExpenseSummaryJa extends TranslationsChatGenuiExpenseSummaryZh {
	_TranslationsChatGenuiExpenseSummaryJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get totalExpense => '総支出';
	@override String get mainExpenses => '主な支出';
	@override String viewAll({required Object count}) => '全 ${count} 件を表示';
	@override String get details => '詳細';
}

// Path: chat.genui.transactionList
class _TranslationsChatGenuiTransactionListJa extends TranslationsChatGenuiTransactionListZh {
	_TranslationsChatGenuiTransactionListJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String searchResults({required Object count}) => '検索結果 (${count})';
	@override String loaded({required Object count}) => '${count} 件読み込み済み';
	@override String get noResults => '結果が見つかりません';
	@override String get loadMore => 'さらに表示';
	@override String get allLoaded => 'すべて読み込みました';
}

// Path: chat.genui.transactionGroupReceipt
class _TranslationsChatGenuiTransactionGroupReceiptJa extends TranslationsChatGenuiTransactionGroupReceiptZh {
	_TranslationsChatGenuiTransactionGroupReceiptJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '記帳成功';
	@override String count({required Object count}) => '${count}件';
	@override String get selectAccount => '口座を関連付け';
	@override String get selectAccountSubtitle => 'この口座をすべての取引に適用します';
	@override String associatedAccount({required Object name}) => '関連付け口座：${name}';
	@override String get clickToAssociate => '口座を関連付ける（一括可）';
	@override String get associateSuccess => '関連付けに成功しました';
	@override String associateFailed({required Object error}) => 'エラー: ${error}';
	@override String get accountAssociation => '口座関連付け';
	@override String get sharedSpace => '共有スペース';
	@override String get notAssociated => '未設定';
	@override String get addSpace => '追加';
	@override String get selectSpace => 'スペースを選択';
	@override String get spaceAssociateSuccess => 'スペースに関連付けました';
	@override String spaceAssociateFailed({required Object error}) => 'スペース関連付け失敗: ${error}';
	@override String get currencyMismatchTitle => '通貨が異なります';
	@override String get currencyMismatchDesc => '取引の通貨と口座の通貨が異なります。口座残高は為替レートで換算されます。';
	@override String get transactionAmount => '取引金額';
	@override String get accountCurrency => '口座通貨';
	@override String get targetAccount => '対象口座';
	@override String get currencyMismatchNote => '注意：為替レートで換算して残高から差し引きます';
	@override String get confirmAssociate => '確認';
}

// Path: chat.genui.transactionCard
class _TranslationsChatGenuiTransactionCardJa extends TranslationsChatGenuiTransactionCardZh {
	_TranslationsChatGenuiTransactionCardJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '取引成功';
	@override String get associatedAccount => '関連口座';
	@override String get notCounted => '資産に含めない';
	@override String get modify => '修正';
	@override String get associate => '口座を関連付け';
	@override String get selectAccount => '口座を選択';
	@override String get noAccount => '口座がありません。追加してください';
	@override String get missingId => 'IDがありません';
	@override String associatedTo({required Object name}) => '${name} に関連付け済み';
	@override String updateFailed({required Object error}) => '更新失敗: ${error}';
}

// Path: chat.genui.cashFlowCard
class _TranslationsChatGenuiCashFlowCardJa extends TranslationsChatGenuiCashFlowCardZh {
	_TranslationsChatGenuiCashFlowCardJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'キャッシュフロー分析';
	@override String savingsRate({required Object rate}) => '貯蓄率 ${rate}%';
	@override String get totalIncome => '総収入';
	@override String get totalExpense => '総支出';
	@override String get essentialExpense => '必須支出';
	@override String get discretionaryExpense => '自由裁量支出';
	@override String get aiInsight => 'AI分析';
}

/// The flat map containing all translations for locale <ja>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsJa {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.loading' => '読み込み中...',
			'common.error' => 'エラー',
			'common.retry' => '再試行',
			'common.cancel' => 'キャンセル',
			'common.confirm' => '確認',
			'common.save' => '保存',
			'common.delete' => '削除',
			'common.edit' => '編集',
			'common.add' => '追加',
			'common.search' => '検索',
			'common.filter' => 'フィルター',
			'common.sort' => '並べ替え',
			'common.refresh' => '更新',
			'common.more' => 'もっと見る',
			'common.less' => 'たたむ',
			'common.all' => 'すべて',
			'common.none' => 'なし',
			'common.ok' => 'OK',
			'common.unknown' => '不明',
			'common.noData' => 'データなし',
			'common.loadMore' => 'さらに読み込む',
			'common.noMore' => 'これ以上ありません',
			'common.loadFailed' => '読み込み失敗',
			'common.history' => '履歴',
			'common.reset' => 'リセット',
			'time.today' => '今日',
			'time.yesterday' => '昨日',
			'time.dayBeforeYesterday' => '一昨日',
			'time.thisWeek' => '今週',
			'time.thisMonth' => '今月',
			'time.thisYear' => '今年',
			'time.selectDate' => '日付を選択',
			'time.selectTime' => '時間を選択',
			'time.justNow' => 'たった今',
			'time.minutesAgo' => ({required Object count}) => '${count}分前',
			'time.hoursAgo' => ({required Object count}) => '${count}時間前',
			'time.daysAgo' => ({required Object count}) => '${count}日前',
			'time.weeksAgo' => ({required Object count}) => '${count}週間前',
			'greeting.morning' => 'おはようございます',
			'greeting.afternoon' => 'こんにちは',
			'greeting.evening' => 'こんばんは',
			'navigation.home' => 'ホーム',
			'navigation.forecast' => '予測',
			'navigation.footprint' => 'フットプリント',
			'navigation.profile' => 'マイページ',
			'auth.login' => 'ログイン',
			'auth.loggingIn' => 'ログイン中...',
			'auth.logout' => 'ログアウト',
			'auth.register' => '新規登録',
			'auth.registering' => '登録中...',
			'auth.welcomeBack' => 'おかえりなさい',
			'auth.loginSuccess' => 'おかえりなさい！',
			'auth.loginFailed' => 'ログイン失敗',
			'auth.pleaseTryAgain' => '後ほど再試行してください。',
			'auth.loginSubtitle' => 'AI家計簿アシスタントを利用するにはログインしてください',
			'auth.noAccount' => 'アカウントをお持ちでないですか？ 登録',
			'auth.createAccount' => 'アカウントを作成',
			'auth.setPassword' => 'パスワード設定',
			'auth.setAccountPassword' => 'アカウントのパスワードを設定してください',
			'auth.completeRegistration' => '登録完了',
			'auth.registrationSuccess' => '登録が完了しました！',
			'auth.registrationFailed' => '登録失敗',
			'auth.email.label' => 'メールアドレス',
			'auth.email.placeholder' => 'メールアドレスを入力してください',
			'auth.email.required' => 'メールアドレスは必須です',
			'auth.email.invalid' => '有効なメールアドレスを入力してください',
			'auth.password.label' => 'パスワード',
			'auth.password.placeholder' => 'パスワードを入力してください',
			'auth.password.required' => 'パスワードは必須です',
			'auth.password.tooShort' => 'パスワードは6文字以上で入力してください',
			'auth.password.mustContainNumbersAndLetters' => 'パスワードは英数字を含める必要があります',
			'auth.password.confirm' => 'パスワード確認',
			'auth.password.confirmPlaceholder' => 'もう一度パスワードを入力してください',
			'auth.password.mismatch' => 'パスワードが一致しません',
			'auth.verificationCode.label' => '認証コード',
			'auth.verificationCode.get' => 'コードを取得',
			'auth.verificationCode.sending' => '送信中...',
			'auth.verificationCode.sent' => '認証コードを送信しました',
			'auth.verificationCode.sendFailed' => '送信失敗',
			'auth.verificationCode.placeholder' => '認証コードを入力',
			'auth.verificationCode.required' => '認証コードは必須です',
			'transaction.expense' => '支出',
			'transaction.income' => '収入',
			'transaction.transfer' => '振替',
			'transaction.amount' => '金額',
			'transaction.category' => 'カテゴリー',
			'transaction.description' => 'メモ',
			'transaction.tags' => 'タグ',
			'transaction.saveTransaction' => '記録を保存',
			'transaction.pleaseEnterAmount' => '金額を入力してください',
			'transaction.pleaseSelectCategory' => 'カテゴリーを選択してください',
			'transaction.saveFailed' => '保存に失敗しました',
			'transaction.descriptionHint' => '取引の詳細を記録...',
			'transaction.addCustomTag' => 'カスタムタグを追加',
			'transaction.commonTags' => 'よく使うタグ',
			'transaction.maxTagsHint' => ({required Object maxTags}) => 'タグは最大 ${maxTags} 個までです',
			'transaction.noTransactionsFound' => '取引履歴が見つかりません',
			'transaction.tryAdjustingSearch' => '検索条件を調整するか、新しい取引を作成してください',
			'transaction.noDescription' => 'メモなし',
			'transaction.payment' => '支払い',
			'transaction.account' => '口座',
			'transaction.time' => '時間',
			'transaction.location' => '場所',
			'transaction.transactionDetail' => '取引詳細',
			'transaction.favorite' => 'お気に入り',
			'transaction.confirmDelete' => '削除の確認',
			'transaction.deleteTransactionConfirm' => 'この取引記録を削除してもよろしいですか？この操作は取り消せません。',
			'transaction.noActions' => '利用可能なアクションはありません',
			'transaction.deleted' => '削除済み',
			'transaction.deleteFailed' => '削除に失敗しました。後ほど再試行してください。',
			'home.totalExpense' => '総支出額',
			'home.todayExpense' => '今日の支出',
			'home.monthExpense' => '今月の支出',
			'home.yearProgress' => ({required Object year}) => '${year}年の進捗',
			'home.amountHidden' => '••••••••',
			'home.loadFailed' => '読み込み失敗',
			'home.noTransactions' => '取引履歴なし',
			'home.tryRefresh' => '更新してください',
			'home.noMoreData' => 'これ以上のデータはありません',
			'home.userNotLoggedIn' => 'ユーザーがログインしていないため、データを読み込めません',
			'comment.error' => 'エラー',
			'comment.commentFailed' => 'コメントに失敗しました',
			'comment.replyToPrefix' => ({required Object name}) => '@${name} さんに返信:',
			'comment.reply' => '返信',
			'comment.addNote' => '備考を追加...',
			'comment.confirmDeleteTitle' => '削除の確認',
			'comment.confirmDeleteContent' => 'このコメントを削除してもよろしいですか？この操作は取り消せません。',
			'comment.success' => '成功',
			'comment.commentDeleted' => 'コメントを削除しました',
			'comment.deleteFailed' => '削除失敗',
			'comment.deleteComment' => 'コメント削除',
			'comment.hint' => 'ヒント',
			'comment.noActions' => '利用可能なアクションはありません',
			'comment.note' => '備考',
			'comment.noNote' => '備考なし',
			'comment.loadFailed' => '備考の読み込みに失敗しました',
			'calendar.title' => '家計カレンダー',
			'calendar.weekdays.mon' => '月',
			'calendar.weekdays.tue' => '火',
			'calendar.weekdays.wed' => '水',
			'calendar.weekdays.thu' => '木',
			'calendar.weekdays.fri' => '金',
			'calendar.weekdays.sat' => '土',
			'calendar.weekdays.sun' => '日',
			'calendar.loadFailed' => 'カレンダーデータの読み込みに失敗しました',
			'calendar.thisMonth' => ({required Object amount}) => '今月: ${amount}',
			'calendar.counting' => '集計中...',
			'calendar.unableToCount' => '集計不可',
			'calendar.trend' => '傾向: ',
			'calendar.noTransactionsTitle' => 'この日の取引はありません',
			'calendar.loadTransactionFailed' => '取引の読み込みに失敗しました',
			'category.dailyConsumption' => '生活費',
			'category.transportation' => '交通費',
			'category.healthcare' => '医療・健康',
			'category.housing' => '住居費',
			'category.education' => '教育・学習',
			'category.incomeCategory' => '収入',
			'category.socialGifts' => '交際・贈り物',
			'category.moneyTransfer' => '資金移動',
			'category.other' => 'その他',
			'category.foodDining' => '食費・外食',
			'category.shoppingRetail' => '買い物',
			'category.housingUtilities' => '住居・光熱費',
			'category.personalCare' => '美容・ケア',
			'category.entertainment' => '娯楽・レジャー',
			'category.medicalHealth' => '医療費',
			'category.insurance' => '保険',
			'category.socialGifting' => '冠婚葬祭',
			'category.financialTax' => '金融・税金',
			'category.others' => 'その他支出',
			'category.salaryWage' => '給与・報酬',
			'category.businessTrade' => '事業収入',
			'category.investmentReturns' => '投資収益',
			'category.giftBonus' => 'お祝い・ボーナス',
			'category.refundRebate' => '還付・ポイント',
			'category.generalTransfer' => '振替',
			'category.debtRepayment' => '債務返済',
			'settings.title' => '設定',
			'settings.language' => '言語',
			'settings.languageSettings' => '言語設定',
			'settings.selectLanguage' => '言語を選択',
			'settings.languageChanged' => '言語を変更しました',
			'settings.restartToApply' => '変更を適用するにはアプリを再起動してください',
			'settings.theme' => 'テーマ',
			'settings.darkMode' => 'ダークモード',
			'settings.lightMode' => 'ライトモード',
			'settings.systemMode' => 'システムに従う',
			'settings.developerOptions' => '開発者オプション',
			'settings.authDebug' => '認証デバッグ',
			'settings.authDebugSubtitle' => '認証ステータスとデバッグ情報を確認',
			'settings.fontTest' => 'フォントテスト',
			'settings.fontTestSubtitle' => 'フォントの表示効果をテスト',
			'settings.helpAndFeedback' => 'ヘルプとフィードバック',
			'settings.helpAndFeedbackSubtitle' => 'ヘルプの参照またはフィードバック送信',
			'settings.aboutApp' => 'アプリについて',
			'settings.aboutAppSubtitle' => 'バージョン情報と開発者情報',
			'settings.currencyChangedRefreshHint' => ({required Object currency}) => '${currency} に切り替えました。新しい取引はこの通貨で記録されます',
			'settings.sharedSpace' => '共有スペース',
			'settings.speechRecognition' => '音声認識',
			'settings.speechRecognitionSubtitle' => '音声入力パラメータを設定',
			'settings.amountDisplayStyle' => '金額表示スタイル',
			'settings.currency' => '表示通貨',
			'settings.appearance' => '外観設定',
			'settings.appearanceSubtitle' => 'テーマモードと配色',
			'settings.speechTest' => '音声テスト',
			'settings.speechTestSubtitle' => 'WebSocket音声接続をテスト',
			'settings.userTypeRegular' => '一般ユーザー',
			'settings.selectAmountStyle' => '金額表示スタイルを選択',
			'settings.currencyDescription' => '使用する通貨を選択してください。すべての金額がこの通貨で表示されます。',
			'appearance.title' => '外観設定',
			'appearance.themeMode' => 'テーマモード',
			'appearance.light' => 'ライト',
			'appearance.dark' => 'ダーク',
			'appearance.system' => 'システム',
			'appearance.colorScheme' => '配色',
			'speech.title' => '音声認識設定',
			'speech.service' => '音声認識サービス',
			'speech.systemVoice' => 'システム音声',
			'speech.systemVoiceSubtitle' => 'スマホ内蔵の音声認識サービス（推奨）',
			'speech.selfHostedASR' => '自作 ASR サービス',
			'speech.selfHostedASRSubtitle' => 'WebSocket経由で自作ASRサーバーに接続',
			'speech.serverConfig' => 'サーバー設定',
			'speech.serverAddress' => 'サーバーアドレス',
			'speech.port' => 'ポート',
			'speech.path' => 'パス',
			'speech.saveConfig' => '設定を保存',
			'speech.info' => '情報',
			'speech.infoContent' => '• システム音声：内蔵サービスを使用。設定不要で高速です。\n• 自作 ASR：カスタムモデルやオフライン環境用。\n\n変更は次回の音声入力から有効になります。',
			'speech.enterAddress' => 'サーバーアドレスを入力してください',
			'speech.enterValidPort' => '有効なポート番号(1-65535)を入力してください',
			'speech.configSaved' => '設定を保存しました',
			'amountTheme.chinaMarket' => '中国市場慣習',
			'amountTheme.chinaMarketDesc' => '赤上昇/緑下落（推奨）',
			'amountTheme.international' => '国際標準',
			'amountTheme.internationalDesc' => '緑上昇/赤下落',
			'amountTheme.minimalist' => 'ミニマリスト',
			'amountTheme.minimalistDesc' => '記号のみで区別',
			'amountTheme.colorBlind' => '色覚サポート',
			'amountTheme.colorBlindDesc' => '青・オレンジ配色',
			'locale.chinese' => '簡体字中国語',
			'locale.english' => 'English',
			'locale.japanese' => '日本語',
			'locale.korean' => '한국어',
			'locale.traditionalChinese' => '繁体字中国語',
			'budget.title' => '予算管理',
			'budget.detail' => '予算詳細',
			'budget.info' => '予算情報',
			'budget.totalBudget' => '総予算',
			'budget.categoryBudget' => 'カテゴリー別予算',
			'budget.monthlySummary' => '今月の予算サマリー',
			'budget.used' => '使用済み',
			'budget.remaining' => '残り',
			'budget.overspent' => '予算超過',
			'budget.budget' => '予算',
			'budget.loadFailed' => '読み込み失敗',
			'budget.noBudget' => '予算未設定',
			'budget.createHint' => 'Augoアシスタントに「予算を設定して」と言って作成',
			'budget.paused' => '一時停止中',
			'budget.pause' => '停止',
			'budget.resume' => '再開',
			'budget.budgetPaused' => '予算管理を停止しました',
			'budget.budgetResumed' => '予算管理を再開しました',
			'budget.operationFailed' => '操作に失敗しました',
			'budget.deleteBudget' => '予算を削除',
			'budget.deleteConfirm' => 'この予算を削除してもよろしいですか？取り消せません。',
			'budget.type' => 'タイプ',
			'budget.category' => 'カテゴリー',
			'budget.period' => '周期',
			'budget.rollover' => '予算繰越',
			'budget.rolloverBalance' => '繰越残高',
			'budget.enabled' => '有効',
			'budget.disabled' => '無効',
			'budget.statusNormal' => '予算内',
			'budget.statusWarning' => '上限接近',
			'budget.statusOverspent' => '超過',
			'budget.statusAchieved' => '目標達成',
			'budget.tipNormal' => ({required Object amount}) => '残り ${amount} 利用可能',
			'budget.tipWarning' => ({required Object amount}) => '残り ${amount} です。ご注意ください',
			'budget.tipOverspent' => ({required Object amount}) => '${amount} 超過しています',
			'budget.tipAchieved' => '貯金目標達成おめでとうございます！',
			'budget.remainingAmount' => ({required Object amount}) => '残り ${amount}',
			'budget.overspentAmount' => ({required Object amount}) => '超過 ${amount}',
			'budget.budgetAmount' => ({required Object amount}) => '予算 ${amount}',
			'budget.active' => '有効',
			'budget.all' => 'すべて',
			'budget.notFound' => '予算が存在しないか削除されました',
			'budget.setup' => '予算設定',
			'budget.settings' => '予算設定',
			'budget.setAmount' => '予算額を設定',
			'budget.setAmountDesc' => '各カテゴリーの予算額を設定',
			'budget.monthly' => '月次予算',
			'budget.monthlyDesc' => '月単位で支出を管理します（推奨）',
			'budget.weekly' => '週次予算',
			'budget.weeklyDesc' => '週単位で細かく管理します',
			'budget.yearly' => '年次予算',
			'budget.yearlyDesc' => '長期的な計画や大きな支出用',
			'budget.editBudget' => '予算を編集',
			'budget.editBudgetDesc' => '予算額やカテゴリーを変更',
			'budget.reminderSettings' => '通知設定',
			'budget.reminderSettingsDesc' => '予算通知やリマインダーを設定',
			'budget.report' => '予算レポート',
			'budget.reportDesc' => '詳細な予算分析レポートを表示',
			'budget.welcome' => '予算機能へようこそ！',
			'budget.createNewPlan' => '新しい予算プランを作成',
			'budget.welcomeDesc' => '予算を設定することで、支出をコントロールし財務目標を達成できます。',
			'budget.createDesc' => 'カテゴリー別の予算上限を設定して、家計管理をサポートします。',
			'budget.newBudget' => '新規予算',
			'budget.budgetAmountLabel' => '予算額',
			'budget.currency' => '通貨',
			'budget.periodSettings' => '期間設定',
			'budget.autoGenerateTransactions' => '有効にするとルールに従い自動記帳します',
			'budget.cycle' => 'サイクル',
			'budget.budgetCategory' => '予算カテゴリー',
			'budget.advancedOptions' => '詳細オプション',
			'budget.periodType' => '期間タイプ',
			'budget.anchorDay' => '開始日',
			'budget.selectPeriodType' => '期間タイプを選択',
			'budget.selectAnchorDay' => '開始日を選択',
			'budget.rolloverDescription' => '未使用分を翌期に繰り越す',
			'budget.createBudget' => '予算を作成',
			'budget.save' => '保存',
			'budget.pleaseEnterAmount' => '予算額を入力してください',
			'budget.invalidAmount' => '有効な金額を入力してください',
			'budget.updateSuccess' => '予算を更新しました',
			'budget.createSuccess' => '予算を作成しました',
			'budget.deleteSuccess' => '予算を削除しました',
			'budget.deleteFailed' => '削除に失敗しました',
			'budget.everyMonthDay' => ({required Object day}) => '毎月 ${day} 日',
			'budget.periodWeekly' => '毎週',
			'budget.periodBiweekly' => '2週間ごと',
			'budget.periodMonthly' => '毎月',
			'budget.periodYearly' => '毎年',
			'budget.statusActive' => '進行中',
			'budget.statusArchived' => 'アーカイブ済み',
			'budget.periodStatusOnTrack' => '順調',
			'budget.periodStatusWarning' => '警告',
			'budget.periodStatusExceeded' => '超過',
			'budget.periodStatusAchieved' => '達成',
			'budget.usedPercent' => ({required Object percent}) => '${percent}% 使用済み',
			'budget.dayOfMonth' => ({required Object day}) => '${day} 日',
			'budget.tenThousandSuffix' => '万',
			'dateRange.custom' => 'カスタム',
			'dateRange.pickerTitle' => '期間を選択',
			'dateRange.startDate' => '開始日',
			'dateRange.endDate' => '終了日',
			'dateRange.hint' => '日付範囲を選択してください',
			'forecast.title' => '予測',
			'forecast.subtitle' => 'データに基づき将来のキャッシュフローを予測します',
			'forecast.financialNavigator' => 'こんにちは、あなたの財務ナビゲーターです',
			'forecast.financialMapSubtitle' => '3ステップで、あなたの将来の財務マップを一緒に作成しましょう',
			'forecast.predictCashFlow' => '将来のキャッシュフローを予測',
			'forecast.predictCashFlowDesc' => '日々の財務状況を可視化',
			'forecast.aiSmartSuggestions' => 'AIスマートアドバイス',
			'forecast.aiSmartSuggestionsDesc' => 'パーソナライズされた財務ガイダンス',
			'forecast.riskWarning' => 'リスク警告',
			'forecast.riskWarningDesc' => '潜在的なリスクを事前に察知',
			'forecast.analyzing' => '財務データを分析し、今後30日間の予測を生成しています',
			'forecast.analyzePattern' => '収支パターンの分析',
			'forecast.calculateTrend' => 'トレンドの計算',
			'forecast.generateWarning' => 'リスク警告の生成',
			'forecast.loadingForecast' => '予測を読み込み中...',
			'forecast.todayLabel' => '今日',
			'forecast.tomorrowLabel' => '明日',
			'forecast.balanceLabel' => '残高',
			'forecast.noSpecialEvents' => '特別なイベントはありません',
			'forecast.financialSafetyLine' => 'セーフティライン',
			'forecast.currentSetting' => '現在の設定',
			'forecast.dailySpendingEstimate' => '1日の支出見積もり',
			'forecast.adjustDailySpendingAmount' => '予測金額を調整',
			'forecast.tellMeYourSafetyLine' => 'あなたの「安心できる最低残高」はいくらですか？',
			'forecast.safetyLineDescription' => '口座に維持したい最低額です。この額に近づくと警告します。',
			'forecast.dailySpendingQuestion' => '1日の生活費はいくらくらいですか？',
			'forecast.dailySpendingDescription' => '食費、交通費、買い物など。今後の記録から予測精度を向上させます。',
			'forecast.perDay' => '1日あたり',
			'forecast.referenceStandard' => '参考基準',
			'forecast.frugalType' => '節約型',
			'forecast.comfortableType' => '標準型',
			'forecast.relaxedType' => 'ゆとり型',
			'forecast.frugalAmount' => '1,000円-2,000円/日',
			'forecast.comfortableAmount' => '2,000円-4,000円/日',
			'forecast.relaxedAmount' => '4,000円-6,000円/日',
			'forecast.recurringTransaction.title' => '繰り返し取引',
			'forecast.recurringTransaction.all' => 'すべて',
			'forecast.recurringTransaction.expense' => '支出',
			'forecast.recurringTransaction.income' => '収入',
			'forecast.recurringTransaction.transfer' => '振替',
			'forecast.recurringTransaction.noRecurring' => '繰り返し取引なし',
			'forecast.recurringTransaction.createHint' => '設定すると、システムが自動で取引を記録します',
			'forecast.recurringTransaction.create' => '繰り返し取引を作成',
			'forecast.recurringTransaction.edit' => '繰り返し取引を編集',
			'forecast.recurringTransaction.newTransaction' => '新規繰り返し取引',
			'forecast.recurringTransaction.deleteConfirm' => ({required Object name}) => '繰り返し取引「${name}」を削除しますか？',
			'forecast.recurringTransaction.activateConfirm' => ({required Object name}) => '「${name}」を有効にしますか？自動記帳が始まります。',
			'forecast.recurringTransaction.pauseConfirm' => ({required Object name}) => '「${name}」を一時停止しますか？',
			'forecast.recurringTransaction.created' => '作成しました',
			'forecast.recurringTransaction.updated' => '更新しました',
			'forecast.recurringTransaction.activated' => '有効化',
			'forecast.recurringTransaction.paused' => '停止中',
			'forecast.recurringTransaction.nextTime' => '次回',
			'forecast.recurringTransaction.sortByTime' => '時間順',
			'forecast.recurringTransaction.allPeriod' => 'すべての周期',
			'forecast.recurringTransaction.periodCount' => ({required Object type, required Object count}) => '${type} (${count} 件)',
			'forecast.recurringTransaction.confirmDelete' => '削除確認',
			'forecast.recurringTransaction.confirmActivate' => '有効化確認',
			'forecast.recurringTransaction.confirmPause' => '停止確認',
			'forecast.recurringTransaction.dynamicAmount' => '動態平均',
			'forecast.recurringTransaction.dynamicAmountTitle' => '金額の確認が必要',
			'forecast.recurringTransaction.dynamicAmountDescription' => '通知が届いたら金額を確認して記帳を完了させてください。',
			'chat.newChat' => '新しいチャット',
			'chat.noMessages' => 'メッセージがありません。',
			'chat.loadingFailed' => '読み込み失敗',
			'chat.inputMessage' => 'メッセージを入力...',
			'chat.listening' => '聞き取り中...',
			'chat.aiThinking' => '処理中...',
			'chat.tools.processing' => '処理中...',
			'chat.tools.readFile' => 'ファイルを確認中...',
			'chat.tools.searchTransactions' => '取引を検索中...',
			'chat.tools.queryBudgetStatus' => '予算を確認中...',
			'chat.tools.createBudget' => '予算プランを作成中...',
			'chat.tools.getCashFlowAnalysis' => 'キャッシュフローを分析中...',
			'chat.tools.getFinancialHealthScore' => '財務スコアを計算中...',
			'chat.tools.getFinancialSummary' => 'レポートを生成中...',
			'chat.tools.evaluateFinancialHealth' => '財務状況を評価中...',
			'chat.tools.forecastBalance' => '残高を予測中...',
			'chat.tools.simulateExpenseImpact' => '影響をシミュレーション中...',
			'chat.tools.recordTransactions' => '記帳中...',
			'chat.tools.createTransaction' => '記帳中...',
			'chat.tools.duckduckgoSearch' => 'ウェブを検索中...',
			'chat.tools.executeTransfer' => '振替を実行中...',
			'chat.tools.listDir' => 'ディレクトリを表示中...',
			'chat.tools.execute' => 'スクリプトを実行中...',
			'chat.tools.analyzeFinance' => '財務分析中...',
			'chat.tools.forecastFinance' => 'トレンド予測中...',
			'chat.tools.analyzeBudget' => '予算分析中...',
			'chat.tools.auditAnalysis' => '監査分析中...',
			'chat.tools.budgetOps' => '予算を処理中...',
			'chat.tools.createSharedTransaction' => '共有帳簿を作成中...',
			'chat.tools.listSpaces' => '共有スペースを取得中...',
			'chat.tools.querySpaceSummary' => 'スペース概要を確認中...',
			'chat.tools.prepareTransfer' => '振替を準備中...',
			'chat.tools.unknown' => 'リクエストを処理中...',
			'chat.tools.done.readFile' => 'ファイルを確認しました',
			'chat.tools.done.searchTransactions' => '取引を検索しました',
			'chat.tools.done.queryBudgetStatus' => '予算を確認しました',
			'chat.tools.done.createBudget' => '予算を作成しました',
			'chat.tools.done.getCashFlowAnalysis' => 'キャッシュフローを分析しました',
			'chat.tools.done.getFinancialHealthScore' => 'スコアを計算しました',
			'chat.tools.done.getFinancialSummary' => 'レポート生成完了',
			'chat.tools.done.evaluateFinancialHealth' => '財務評価完了',
			'chat.tools.done.forecastBalance' => '残高予測完了',
			'chat.tools.done.simulateExpenseImpact' => 'シミュレーション完了',
			'chat.tools.done.recordTransactions' => '記帳完了',
			'chat.tools.done.createTransaction' => '記帳しました',
			'chat.tools.done.duckduckgoSearch' => '検索完了',
			'chat.tools.done.executeTransfer' => '振替完了',
			'chat.tools.done.listDir' => 'ディレクトリ表示完了',
			'chat.tools.done.execute' => '実行完了',
			'chat.tools.done.analyzeFinance' => '分析完了',
			'chat.tools.done.forecastFinance' => '予測完了',
			'chat.tools.done.analyzeBudget' => '予算分析完了',
			'chat.tools.done.auditAnalysis' => '監査完了',
			'chat.tools.done.budgetOps' => '予算処理完了',
			'chat.tools.done.createSharedTransaction' => '共有帳簿作成完了',
			'chat.tools.done.listSpaces' => '共有スペース取得完了',
			'chat.tools.done.querySpaceSummary' => '概要確認完了',
			'chat.tools.done.prepareTransfer' => '準備完了',
			'chat.tools.done.unknown' => '完了しました',
			'chat.tools.failed.unknown' => '操作に失敗しました',
			'chat.speechNotRecognized' => '音声を認識できませんでした',
			'chat.currentExpense' => '今回の支出',
			'chat.loadingComponent' => 'コンポーネントを読み込み中...',
			'chat.noHistory' => '履歴がありません',
			'chat.startNewChat' => '新しい会話を始めましょう！',
			'chat.searchHint' => 'チャットを検索',
			'chat.library' => 'ライブラリ',
			'chat.viewProfile' => 'プロフィールを表示',
			'chat.noRelatedFound' => '関連する会話が見つかりません',
			'chat.tryOtherKeywords' => '他のキーワードで検索してください',
			'chat.searchFailed' => '検索失敗',
			'chat.deleteConversation' => 'チャットを削除',
			'chat.deleteConversationConfirm' => 'このチャットを削除してもよろしいですか？この操作は取り消せません。',
			'chat.conversationDeleted' => 'チャットを削除しました',
			'chat.deleteConversationFailed' => 'チャットの削除に失敗しました',
			'chat.transferWizard.title' => '振替ウィザード',
			'chat.transferWizard.amount' => '振替金額',
			'chat.transferWizard.amountHint' => '金額を入力',
			'chat.transferWizard.sourceAccount' => '振替元口座',
			'chat.transferWizard.targetAccount' => '振替先口座',
			'chat.transferWizard.selectAccount' => '口座を選択してください',
			'chat.transferWizard.confirmTransfer' => '振替を確認',
			'chat.transferWizard.confirmed' => '確認済み',
			'chat.transferWizard.transferSuccess' => '振替が完了しました',
			'chat.genui.expenseSummary.totalExpense' => '総支出',
			'chat.genui.expenseSummary.mainExpenses' => '主な支出',
			'chat.genui.expenseSummary.viewAll' => ({required Object count}) => '全 ${count} 件を表示',
			'chat.genui.expenseSummary.details' => '詳細',
			'chat.genui.transactionList.searchResults' => ({required Object count}) => '検索結果 (${count})',
			'chat.genui.transactionList.loaded' => ({required Object count}) => '${count} 件読み込み済み',
			'chat.genui.transactionList.noResults' => '結果が見つかりません',
			'chat.genui.transactionList.loadMore' => 'さらに表示',
			'chat.genui.transactionList.allLoaded' => 'すべて読み込みました',
			'chat.genui.transactionGroupReceipt.title' => '記帳成功',
			'chat.genui.transactionGroupReceipt.count' => ({required Object count}) => '${count}件',
			'chat.genui.transactionGroupReceipt.selectAccount' => '口座を関連付け',
			'chat.genui.transactionGroupReceipt.selectAccountSubtitle' => 'この口座をすべての取引に適用します',
			'chat.genui.transactionGroupReceipt.associatedAccount' => ({required Object name}) => '関連付け口座：${name}',
			'chat.genui.transactionGroupReceipt.clickToAssociate' => '口座を関連付ける（一括可）',
			'chat.genui.transactionGroupReceipt.associateSuccess' => '関連付けに成功しました',
			'chat.genui.transactionGroupReceipt.associateFailed' => ({required Object error}) => 'エラー: ${error}',
			'chat.genui.transactionGroupReceipt.accountAssociation' => '口座関連付け',
			'chat.genui.transactionGroupReceipt.sharedSpace' => '共有スペース',
			'chat.genui.transactionGroupReceipt.notAssociated' => '未設定',
			_ => null,
		} ?? switch (path) {
			'chat.genui.transactionGroupReceipt.addSpace' => '追加',
			'chat.genui.transactionGroupReceipt.selectSpace' => 'スペースを選択',
			'chat.genui.transactionGroupReceipt.spaceAssociateSuccess' => 'スペースに関連付けました',
			'chat.genui.transactionGroupReceipt.spaceAssociateFailed' => ({required Object error}) => 'スペース関連付け失敗: ${error}',
			'chat.genui.transactionGroupReceipt.currencyMismatchTitle' => '通貨が異なります',
			'chat.genui.transactionGroupReceipt.currencyMismatchDesc' => '取引の通貨と口座の通貨が異なります。口座残高は為替レートで換算されます。',
			'chat.genui.transactionGroupReceipt.transactionAmount' => '取引金額',
			'chat.genui.transactionGroupReceipt.accountCurrency' => '口座通貨',
			'chat.genui.transactionGroupReceipt.targetAccount' => '対象口座',
			'chat.genui.transactionGroupReceipt.currencyMismatchNote' => '注意：為替レートで換算して残高から差し引きます',
			'chat.genui.transactionGroupReceipt.confirmAssociate' => '確認',
			'chat.genui.transactionCard.title' => '取引成功',
			'chat.genui.transactionCard.associatedAccount' => '関連口座',
			'chat.genui.transactionCard.notCounted' => '資産に含めない',
			'chat.genui.transactionCard.modify' => '修正',
			'chat.genui.transactionCard.associate' => '口座を関連付け',
			'chat.genui.transactionCard.selectAccount' => '口座を選択',
			'chat.genui.transactionCard.noAccount' => '口座がありません。追加してください',
			'chat.genui.transactionCard.missingId' => 'IDがありません',
			'chat.genui.transactionCard.associatedTo' => ({required Object name}) => '${name} に関連付け済み',
			'chat.genui.transactionCard.updateFailed' => ({required Object error}) => '更新失敗: ${error}',
			'chat.genui.cashFlowCard.title' => 'キャッシュフロー分析',
			'chat.genui.cashFlowCard.savingsRate' => ({required Object rate}) => '貯蓄率 ${rate}%',
			'chat.genui.cashFlowCard.totalIncome' => '総収入',
			'chat.genui.cashFlowCard.totalExpense' => '総支出',
			'chat.genui.cashFlowCard.essentialExpense' => '必須支出',
			'chat.genui.cashFlowCard.discretionaryExpense' => '自由裁量支出',
			'chat.genui.cashFlowCard.aiInsight' => 'AI分析',
			'footprint.searchIn' => '検索',
			'footprint.searchInAllRecords' => 'すべての記録から検索',
			'media.selectPhotos' => '写真を選択',
			'media.addFiles' => 'ファイルを追加',
			'media.takePhoto' => '写真を撮る',
			'media.camera' => 'カメラ',
			'media.photos' => '写真',
			'media.files' => 'ファイル',
			'media.showAll' => 'すべて表示',
			'media.allPhotos' => 'すべての写真',
			'media.takingPhoto' => '撮影中...',
			'media.photoTaken' => '写真を保存しました',
			'media.cameraPermissionRequired' => 'カメラの権限が必要です',
			'media.fileSizeExceeded' => 'ファイルサイズが10MBを超えています',
			'media.unsupportedFormat' => 'サポートされていない形式です',
			'media.permissionDenied' => 'アルバムへのアクセス権限が必要です',
			'media.storageInsufficient' => 'ストレージ容量が不足しています',
			'media.networkError' => 'ネットワークエラー',
			'media.unknownUploadError' => '不明なアップロードエラー',
			'error.permissionRequired' => '権限が必要です',
			'error.permissionInstructions' => '設定から権限を許可してください。',
			'error.openSettings' => '設定を開く',
			'error.fileTooLarge' => 'ファイルが大きすぎます',
			'error.fileSizeHint' => '10MB以下のファイルを選択してください。',
			'error.supportedFormatsHint' => '対応形式：画像、PDF、ドキュメント、音声など。',
			'error.storageCleanupHint' => '空き容量を確保して再試行してください。',
			'error.networkErrorHint' => '接続を確認して再試行してください。',
			'error.platformNotSupported' => 'サポートされていないプラットフォーム',
			'error.fileReadError' => '読み込み失敗',
			'error.fileReadErrorHint' => 'ファイルが破損している可能性があります。',
			'error.validationError' => '検証エラー',
			'error.unknownError' => '不明なエラー',
			'error.unknownErrorHint' => '予期せぬエラーが発生しました。',
			'error.genui.loadingFailed' => '読み込み失敗',
			'error.genui.schemaFailed' => '検証失敗',
			'error.genui.schemaDescription' => '定義が仕様に適合していません',
			'error.genui.networkError' => 'ネットワークエラー',
			'error.genui.retryStatus' => ({required Object retryCount, required Object maxRetries}) => '再試行中 ${retryCount}/${maxRetries}',
			'error.genui.maxRetriesReached' => '最大試行回数に達しました',
			'fontTest.page' => 'テストページ',
			'fontTest.displayTest' => '表示テスト',
			'fontTest.chineseTextTest' => '中国語テスト',
			'fontTest.englishTextTest' => '英語テスト',
			'fontTest.sample1' => 'これはテスト用のテキストです。',
			'fontTest.sample2' => '支出分析：ショッピングが最多',
			'fontTest.sample3' => 'AIアシスタントによる財務分析',
			'fontTest.sample4' => 'グラフで消費トレンドを確認',
			'fontTest.sample5' => '各種決済サービスに対応',
			'wizard.nextStep' => '次へ',
			'wizard.previousStep' => '前へ',
			'wizard.completeMapping' => 'マップ作成完了',
			'user.username' => 'ユーザー名',
			'user.defaultEmail' => 'user@example.com',
			'account.editTitle' => '口座を編集',
			'account.addTitle' => '新しい口座',
			'account.selectTypeTitle' => '口座タイプを選択',
			'account.nameLabel' => '口座名',
			'account.amountLabel' => '現在の残高',
			'account.currencyLabel' => '通貨',
			'account.hiddenLabel' => '非表示',
			'account.hiddenDesc' => 'リストに表示しない',
			'account.includeInNetWorthLabel' => '資産に含める',
			'account.includeInNetWorthDesc' => '純資産の統計に使用',
			'account.nameHint' => '例：給与振込口座',
			'account.amountHint' => '0.00',
			'account.deleteAccount' => '口座を削除',
			'account.deleteConfirm' => 'この口座を削除しますか？取り消せません。',
			'account.save' => '変更を保存',
			'account.assetsCategory' => '資産',
			'account.liabilitiesCategory' => '負債/クレジット',
			'account.cash' => '現金・財布',
			'account.deposit' => '銀行預金',
			'account.creditCard' => 'クレジットカード',
			'account.investment' => '投資・資産運用',
			'account.eWallet' => '電子マネー',
			'account.loan' => 'ローン',
			'account.receivable' => '売掛金・貸付',
			'account.payable' => '買掛金・借入',
			'account.other' => 'その他',
			'financial.title' => '財務',
			'financial.management' => '財務管理',
			'financial.netWorth' => '純資産',
			'financial.assets' => '総資産',
			'financial.liabilities' => '総負債',
			'financial.noAccounts' => '口座なし',
			'financial.addFirstAccount' => 'ボタンを押して口座を追加してください',
			'financial.assetAccounts' => '資産口座',
			'financial.liabilityAccounts' => '負債口座',
			'financial.selectCurrency' => '通貨を選択',
			'financial.cancel' => 'キャンセル',
			'financial.confirm' => '確定',
			'financial.settings' => '財務設定',
			'financial.budgetManagement' => '予算管理',
			'financial.recurringTransactions' => '繰り返し取引',
			'financial.safetyThreshold' => 'セーフティライン',
			'financial.dailyBurnRate' => '1日の支出',
			'financial.financialAssistant' => '財務アシスタント',
			'financial.manageFinancialSettings' => '財務設定を管理',
			'financial.safetyThresholdSettings' => 'セーフティライン設定',
			'financial.setSafetyThreshold' => 'セーフティラインの閾値を設定',
			'financial.safetyThresholdSaved' => 'セーフティラインを保存しました',
			'financial.dailyBurnRateSettings' => '支出見積もり',
			'financial.setDailyBurnRate' => '1日の支出見積もりを設定',
			'financial.dailyBurnRateSaved' => '支出見積もりを保存しました',
			'financial.saveFailed' => '保存失敗',
			'app.splashTitle' => 'スマートに、豊かに。',
			'app.splashSubtitle' => 'インテリジェント財務アシスタント',
			'statistics.title' => '統計分析',
			'statistics.analyze' => '分析',
			'statistics.exportInProgress' => 'エクスポート機能は開発中です...',
			'statistics.ranking' => '高額支出ランキング',
			'statistics.noData' => 'データなし',
			'statistics.overview.balance' => '残高',
			'statistics.overview.income' => '総収入',
			'statistics.overview.expense' => '総支出',
			'statistics.trend.title' => '収支推移',
			'statistics.trend.expense' => '支出',
			'statistics.trend.income' => '収入',
			'statistics.analysis.title' => '支出分析',
			'statistics.analysis.total' => '合計',
			'statistics.analysis.breakdown' => 'カテゴリー詳細',
			'statistics.filter.accountType' => '口座タイプ',
			'statistics.filter.allAccounts' => 'すべての口座',
			'statistics.filter.apply' => '適用',
			'statistics.sort.amount' => '金額順',
			'statistics.sort.date' => '日付順',
			'statistics.exportList' => 'リストを書き出す',
			'currency.cny' => '人民元',
			'currency.usd' => 'USドル',
			'currency.eur' => 'ユーロ',
			'currency.jpy' => '日本円',
			'currency.gbp' => '英ポンド',
			'currency.aud' => '豪ドル',
			'currency.cad' => 'カナダドル',
			'currency.chf' => 'スイスフラン',
			'currency.rub' => 'ロシアルーブル',
			'currency.hkd' => '香港ドル',
			'currency.twd' => '新台湾ドル',
			'currency.inr' => 'インドルピー',
			'sharedSpace.dashboard.cumulativeTotalExpense' => '累計総支出',
			'sharedSpace.dashboard.participatingMembers' => '参加メンバー',
			'sharedSpace.dashboard.membersCount' => ({required Object count}) => '${count} 人',
			'sharedSpace.dashboard.averagePerMember' => 'メンバー平均',
			'sharedSpace.dashboard.spendingDistribution' => 'メンバー別支出割合',
			'sharedSpace.dashboard.realtimeUpdates' => 'リアルタイム更新',
			'sharedSpace.dashboard.paid' => '支払い済み',
			'sharedSpace.roles.owner' => 'オーナー',
			'sharedSpace.roles.admin' => '管理者',
			'sharedSpace.roles.member' => 'メンバー',
			_ => null,
		};
	}
}
