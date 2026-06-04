// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get achievementsTitle => '実績';

  @override
  String get active => '達成';

  @override
  String get advancedProgressTracking => '高度な進捗トラッキング';

  @override
  String get aiAssistantName => 'マヤ';

  @override
  String get aiAssistantRole => 'カフェ店員';

  @override
  String get aiBadge => 'AI';

  @override
  String get aiChat => 'AIチャット';

  @override
  String get aiConversationGreeting => 'こんにちは！マヤです。東京のカフェで働いています。今日は何を練習しますか？';

  @override
  String get aiConversationPractice => 'AI会話練習';

  @override
  String get aiConversationTitle => 'AI会話';

  @override
  String get aiPractice => 'AI練習';

  @override
  String get aiYou => 'あなた';

  @override
  String get annual => '年間';

  @override
  String get appTagline => '学ぶ。くつろぐ。繰り返す。';

  @override
  String get appTitle => 'InstaLingo';

  @override
  String get back => '戻る';

  @override
  String get cancel => 'キャンセル';

  @override
  String get chapter => 'チャプター';

  @override
  String get chatWithAI => 'AIキャラクターと会話する';

  @override
  String get check => '確認';

  @override
  String get chill => 'くつろぐ';

  @override
  String get chillCorner => 'Chillコーナー';

  @override
  String get chill_addComment => 'コメントを追加...';

  @override
  String get chill_aiGeneratedImage => 'AI生成画像';

  @override
  String get chill_comments => 'コメント';

  @override
  String get chill_noPosts => 'まだ投稿がありません';

  @override
  String get chill_noPostsMessage => 'レッスンを完了してコミュニティの語彙投稿をアンロックしましょう。';

  @override
  String get chill_postNotFound => '投稿が見つかりません';

  @override
  String get chill_postNotFoundMessage => 'この投稿は削除されたか、利用できなくなっています。';

  @override
  String get chill_share => '共有';

  @override
  String get clear => 'クリア';

  @override
  String get clearAll => 'すべてクリア';

  @override
  String get commitment => '学習の約束';

  @override
  String get continueLearning => '学習を続ける';

  @override
  String get continueText => '続ける';

  @override
  String get correct => '正解';

  @override
  String correctCountOfTotal(int correct, int total) {
    return '$correct / $total 正解';
  }

  @override
  String correctWithExplanation(String explanation) {
    return '正解！$explanation';
  }

  @override
  String get courseComplete => 'コース完了！';

  @override
  String get courseCompleteTitle => 'やりました！';

  @override
  String get coursePath => 'コースパス';

  @override
  String get createProfile => 'プロフィールを作成';

  @override
  String get createProfileDesc => 'あなたの学習体験をパーソナライズするのに役立ちます。';

  @override
  String get dailyGoal => '毎日の目標';

  @override
  String get dailyGoalCardTitle => '毎日の目標';

  @override
  String get dailyGoalReached => '目標達成！おめでとう！';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get dayStreak => '連続日数';

  @override
  String dayStreakCount(int count) {
    return '$count 日';
  }

  @override
  String get defaultDisplayName => '学習者';

  @override
  String get done => '完了';

  @override
  String get editProfile => 'プロフィールを編集';

  @override
  String get emptyStateMessage => '後でもう一度確認してください。';

  @override
  String get emptyStateTitle => 'まだコンテンツがありません';

  @override
  String get errorGenericMessage => 'このコンテンツを読み込めませんでした。もう一度お試しください。';

  @override
  String get errorGenericTitle => 'エラーが発生しました';

  @override
  String get exArrangeWords => '単語を並べて正しい文を作ってください';

  @override
  String get exComprehension => '文章を読んで答えてください';

  @override
  String get exDialogueComplete => '会話を完成させてください';

  @override
  String get exFillInBlank => '空欄を埋めてください';

  @override
  String get exFlashCard => 'タップしてカードをめくる';

  @override
  String get exGrammarTip => '文法のヒント';

  @override
  String get exImageIdentify => '正しい画像をタップしてください';

  @override
  String get exMatchWords => '単語と意味をマッチさせてください';

  @override
  String get exPhraseBuilder => 'フレーズを作ってください';

  @override
  String get exSpeaking => 'この単語を声に出して言ってください';

  @override
  String get exTranslate => 'この文を翻訳してください';

  @override
  String get exTrueFalse => 'この文は正しいですか？';

  @override
  String get exTypeWhatYouHear => '聞こえた内容を入力してください';

  @override
  String exVocabMultipleChoice(Object word) {
    return '「$word」の意味はどれですか？';
  }

  @override
  String exWhichWordMeans(Object word) {
    return '「$word」の意味はどれですか？';
  }

  @override
  String get exWriting => '答えを書いてください';

  @override
  String get exampleLabel => '例';

  @override
  String exercisesProgress(int completed, int total) {
    return '$completed / $total 練習';
  }

  @override
  String get falseLabel => '不正解';

  @override
  String get featureAICharacters => 'AIキャラクター';

  @override
  String get featureAICharactersDesc => 'Chill Cornerで本物のように返答するAIキャラクターと練習。';

  @override
  String get featureMotivation => 'やる気を維持';

  @override
  String get featureMotivationDesc => 'XPを稼ぎ、連続記録を維持し、実績を解除。';

  @override
  String get featureStructuredCourses => '構造化されたコース';

  @override
  String get featureStructuredCoursesDesc => '段階的に積み重なるプロフェッショナルなレッスンで学ぶ。';

  @override
  String get findFriends => '友達を探す';

  @override
  String get finishLesson => 'レッスンを完了';

  @override
  String get flashcardEasy => '簡単';

  @override
  String get flashcardGood => '良い';

  @override
  String get flashcardHard => '難しい';

  @override
  String get followingTitle => 'フォロー中';

  @override
  String get forceUpdateBody =>
      'InstaLingoをより速く、安定し、新機能を追加しました。続けるには最新バージョンに更新してください。';

  @override
  String get forceUpdateBugFixes => 'バグ修正と安定性';

  @override
  String get forceUpdateMessage =>
      'InstaLingoの新しいバージョンが利用可能です。学習を続けるには更新してください。';

  @override
  String get forceUpdateNewContent => '新しいレッスンと練習';

  @override
  String get forceUpdatePerformance => 'パフォーマンス向上';

  @override
  String get forceUpdateTitle => '更新が必要';

  @override
  String get fri => '金';

  @override
  String get friendsTitle => '友達';

  @override
  String get gems => 'ジェム';

  @override
  String get getStarted => '始める';

  @override
  String get getUnlimitedLearning => '無制限の学習を取得';

  @override
  String get goodbye => 'さようなら';

  @override
  String get gotIt => 'わかりました！';

  @override
  String get grammarExampleFallback => '練習あるのみ！';

  @override
  String get grammarRuleFallback => 'この練習問題の文法に注意してください。';

  @override
  String get grammarTip => '文法ヒント';

  @override
  String get greetingAfternoon => 'こんにちは';

  @override
  String get greetingEvening => 'こんばんは';

  @override
  String get greetingMorning => 'おはようございます';

  @override
  String get hello => 'こんにちは！';

  @override
  String get helpSupport => 'ヘルプとサポート';

  @override
  String get holdToSpeak => '長押しして話す';

  @override
  String get howAreYou => 'お元気ですか？';

  @override
  String get iAlreadyHaveAccount => 'すでにアカウントを持っている';

  @override
  String get incorrect => '不正解';

  @override
  String get knowIt => '覚えた';

  @override
  String get language => '言語';

  @override
  String get leaderboardTitle => 'ランキング';

  @override
  String get learn => '学習';

  @override
  String get learnRuleToImprove => '上達するためにこのルールを学ぶ';

  @override
  String get learningLanguage => '学習言語';

  @override
  String get lessonComplete => 'レッスン完了！';

  @override
  String get lessonCompleteGood => '良い努力だ！復習してもう一度挑戦しよう！';

  @override
  String get lessonCompleteGreat => 'よくできた！練習を続けよう！';

  @override
  String get lessonCompletePerfect => '完璧！素晴らしい！';

  @override
  String get lessons => 'レッスン';

  @override
  String get levelAbbreviation => 'LV';

  @override
  String get levelAdvanced => '上級';

  @override
  String get levelBeginner => '初級';

  @override
  String get levelElementary => '初級';

  @override
  String get levelIntermediate => '中級';

  @override
  String get levelProficiency => '熟練';

  @override
  String get levelUpperIntermediate => '中上級';

  @override
  String get loading => '読み込み中...';

  @override
  String get loadingLesson => 'レッスンを読み込み中...';

  @override
  String get logout => 'ログアウト';

  @override
  String get matchPairsInstruction => '左の単語をタップし、右の一致するものをタップしてください';

  @override
  String get maybeLater => '後で';

  @override
  String get mon => '月';

  @override
  String get monthly => '月間';

  @override
  String get motivation => '学習の動機';

  @override
  String get myNameIs => '私の名前は';

  @override
  String get nativeLanguage => '母語';

  @override
  String get next => '次へ';

  @override
  String get nextQuestion => '次の質問';

  @override
  String get niceToMeetYou => 'はじめまして';

  @override
  String get noAds => '広告なし';

  @override
  String get noConnectionMessage => 'インターネット接続を確認して、もう一度お試しください。';

  @override
  String get noConnectionTitle => '接続なし';

  @override
  String get notNow => '今はしない';

  @override
  String notQuiteWithExplanation(String explanation) {
    return '惜しいです。$explanation';
  }

  @override
  String get notifications => '通知';

  @override
  String get onboardingTitle => '構造化されたコースとAIキャラクターで言語を学ぼう';

  @override
  String get onboarding_commitmentCasual => 'カジュアル';

  @override
  String get onboarding_commitmentIntense => '集中';

  @override
  String get onboarding_commitmentRegular => '通常';

  @override
  String get onboarding_commitmentSerious => '本気';

  @override
  String get onboarding_commitmentSubtitle => '後で設定からいつでも変更できます。';

  @override
  String get onboarding_commitmentTitle => 'どれくらいの時間を確保できますか？';

  @override
  String get onboarding_displayNameLabel => '表示名';

  @override
  String get onboarding_emailOptionalLabel => 'メール（任意）';

  @override
  String get onboarding_enterEmailHint => 'メールを入力';

  @override
  String get onboarding_enterNameHint => '名前を入力';

  @override
  String get onboarding_learningLangSubtitle => '習得したい言語を選んでください。';

  @override
  String get onboarding_motivationBrainTraining => '脳トレ';

  @override
  String get onboarding_motivationCareer => 'キャリア';

  @override
  String get onboarding_motivationCulture => '文化';

  @override
  String get onboarding_motivationFamily => '家族';

  @override
  String get onboarding_motivationFun => '楽しみのために';

  @override
  String get onboarding_motivationMoviesShows => '映画と番組';

  @override
  String get onboarding_motivationStudyAbroad => '留学';

  @override
  String get onboarding_motivationSubtitle => '該当するものをすべて選んでください。';

  @override
  String get onboarding_motivationTitle => 'なぜ学びたいですか？';

  @override
  String get onboarding_motivationTravel => '旅行';

  @override
  String get onboarding_nativeLangSubtitle => 'これを使って学習体験をパーソナライズします。';

  @override
  String get onboarding_proficiencyAdvanced => '上級';

  @override
  String get onboarding_proficiencyAdvancedDesc => '流暢に話せる';

  @override
  String get onboarding_proficiencyBeginner => '初級';

  @override
  String get onboarding_proficiencyBeginnerDesc => '少し単語を知っている';

  @override
  String get onboarding_proficiencyElementary => '初歩';

  @override
  String get onboarding_proficiencyElementaryDesc => '簡単な文が作れる';

  @override
  String get onboarding_proficiencyIntermediate => '中級';

  @override
  String get onboarding_proficiencyIntermediateDesc => '会話ができる';

  @override
  String get onboarding_proficiencyProficient => '精通';

  @override
  String get onboarding_proficiencyProficientDesc => 'ネイティブのように話せる';

  @override
  String get onboarding_proficiencySubtitle => '適切な難易度から始めます。';

  @override
  String get onboarding_proficiencyTitle => '現在のレベルは？';

  @override
  String get onboarding_proficiencyUpperIntermediate => '中上級';

  @override
  String get onboarding_proficiencyUpperIntermediateDesc => '様々なトピックを議論できる';

  @override
  String get onboarding_skipForNow => '今はスキップ';

  @override
  String get paywallSubtitle => '無制限の学習を解除';

  @override
  String get paywallTitle => 'InstaLingo スーパー';

  @override
  String get perMonth => '/月';

  @override
  String get perYear => '/年';

  @override
  String get pickNewCourse => '新しいコースを選ぶ';

  @override
  String get playing => '再生中...';

  @override
  String get practiceWords => '学んだ単語を練習する';

  @override
  String get privacy => 'プライバシー';

  @override
  String get proficiency => '習熟度';

  @override
  String get profile => 'プロフィール';

  @override
  String get profile_academicEnglish => 'アカデミック英語';

  @override
  String get profile_account => 'アカウント';

  @override
  String get profile_achievementsUnlocked => '解除済みの実績';

  @override
  String get profile_adFreeExperience => '広告なし体験';

  @override
  String get profile_adFreeExperienceDesc => '邪魔されずに学習に集中できます。';

  @override
  String get profile_advanced => '上級';

  @override
  String get profile_advancedSpeakingDesc => '波形表示による詳細な発音と流暢さの分析を取得';

  @override
  String get profile_advancedSpeakingFeedback => '高度なスピーキングフィードバック';

  @override
  String get profile_aiConversationPractice => 'AI会話練習';

  @override
  String get profile_aiConversationPracticeAnswer =>
      'さまざまなシナリオでAIキャラクターとリアルな会話を練習';

  @override
  String get profile_allChillCornerContent => 'すべてのチルコーナーコンテンツ';

  @override
  String get profile_appearance => '外観';

  @override
  String get profile_beginner => '初心者';

  @override
  String get profile_bestValue => 'お得';

  @override
  String get profile_browseTopics => '以下のトピックを参照するか、直接お問い合わせください';

  @override
  String get profile_businessEnglish => 'ビジネス英語';

  @override
  String get profile_cancelAnytime => 'いつでもキャンセル可能。契約不要。';

  @override
  String get profile_checkForUpdates => 'アップデートを確認';

  @override
  String get profile_completeBeginner => '完全初心者';

  @override
  String get profile_contactSupport => 'サポートに連絡';

  @override
  String get profile_createPlan => 'プランを作成';

  @override
  String get profile_dailyConversation => '日常会話';

  @override
  String get profile_daytime => '日中 (午前9時〜午後5時)';

  @override
  String get profile_displayName => '表示名';

  @override
  String get profile_duration => '時間';

  @override
  String get profile_durationDesc => '1回あたりの時間は？';

  @override
  String get profile_earningXPGems => 'XPとジェムの獲得';

  @override
  String get profile_earningXPGemsAnswer =>
      'レッスンを完了し、継続を維持し、語彙を復習してXPとジェムを獲得しましょう。';

  @override
  String get profile_elementary => '初級';

  @override
  String get profile_email => 'メールアドレス';

  @override
  String get profile_enableNotifications => '通知を有効にする';

  @override
  String get profile_enableNotificationsAnswer =>
      '設定でリマインダーをオンにして、毎日の学習促進と継続維持を。';

  @override
  String get profile_enterYourEmail => 'メールアドレスを入力';

  @override
  String get profile_enterYourName => 'お名前を入力';

  @override
  String get profile_evening => '夕方 (午後5時〜9時)';

  @override
  String get profile_everyDay => '毎日';

  @override
  String get profile_everythingInMonthly => '月額プランの全内容';

  @override
  String get profile_examPreparation => '試験対策';

  @override
  String get profile_exclusiveStudyPlans => '限定学習プラン';

  @override
  String get profile_fifteenMinutes => '15分';

  @override
  String get profile_fiveDaysAWeek => '週5日';

  @override
  String get profile_fiveMinutes => '5分';

  @override
  String get profile_follow => 'フォロー';

  @override
  String get profile_followOthersMessage => '他の学習者をフォローしてここに表示しましょう。';

  @override
  String get profile_gettingStarted => 'はじめに';

  @override
  String get profile_goal => '目標';

  @override
  String get profile_goalDesc => '何を達成したいですか？';

  @override
  String get profile_gotIt => '了解';

  @override
  String get profile_howDoIStart => '学習を始めるには？';

  @override
  String get profile_howDoIStartAnswer => '母国語を選び、学びたい言語を選択してください。';

  @override
  String get profile_inProgress => '進行中';

  @override
  String get profile_instalingoSuperFAQ => 'InstaLingo Super';

  @override
  String get profile_instalingoSuperFAQAnswer =>
      'Superにアップグレードすると、無制限レッスン、AI練習、高度な統計が利用できます。';

  @override
  String get profile_intensity => '頻度';

  @override
  String get profile_intensityDesc => '週に何回？';

  @override
  String get profile_intermediate => '中級';

  @override
  String get profile_learning => '学習';

  @override
  String get profile_learningFeatures => '学習機能';

  @override
  String profile_learningStatus(String language, String level) {
    return '学習中: $language · $level';
  }

  @override
  String get profile_lessonRemindersStreakAlerts => 'レッスンリマインダーと継続アラート';

  @override
  String profile_lessonsCompleted(int completed, int total) {
    return 'レッスン $completed/$total 完了';
  }

  @override
  String get profile_level => 'レベル';

  @override
  String get profile_levelDesc => 'どのレベルから始めますか？';

  @override
  String get profile_levelSuffix => 'レベル';

  @override
  String profile_minPerDay(int min) {
    return '1日$min分';
  }

  @override
  String profile_minutesCount(int count) {
    return '1日$count分';
  }

  @override
  String get profile_morning => '朝 (午前6時〜9時)';

  @override
  String get profile_night => '夜 (午後9時〜深夜0時)';

  @override
  String get profile_noAchievementsMessage => 'レッスンを完了し継続を維持して実績を解除しましょう';

  @override
  String get profile_noAchievementsYet => 'まだ実績がありません';

  @override
  String get profile_notSet => '未設定';

  @override
  String get profile_offlineMode => 'オフラインモード';

  @override
  String get profile_offlineModeDesc => 'すべてのレッスンとコンテンツをダウンロード';

  @override
  String get profile_perMonthDesc => '月額';

  @override
  String get profile_perYearDesc => '年額';

  @override
  String get profile_personalizedStudyPlans => 'パーソナライズ学習プラン';

  @override
  String get profile_personalizedStudyPlansDesc =>
      'あなたの目標とスケジュールに合わせたAI生成の学習プラン';

  @override
  String get profile_priorityAIResponses => '優先AI応答';

  @override
  String get profile_proBadge => 'PRO';

  @override
  String get profile_proficiencyLevel => '熟練度レベル';

  @override
  String get profile_proficient => '堪能';

  @override
  String get profile_resetProgress => '進捗をリセット';

  @override
  String get profile_resetProgressFAQ => '進捗をリセット';

  @override
  String get profile_resetProgressFAQAnswer =>
      '設定 > 進捗をリセット で最初からやり直せます。この操作は元に戻せません。';

  @override
  String get profile_saveFiftyVsMonthly => '月額より50%お得';

  @override
  String get profile_schedule => 'スケジュール';

  @override
  String get profile_scheduleDesc => 'いつ勉強できますか？';

  @override
  String get profile_settingDailyGoals => '毎日の目標設定';

  @override
  String get profile_settingDailyGoalsAnswer =>
      'プロフィール > 設定 > 毎日の目標 で学習目標時間を調整できます。';

  @override
  String get profile_someBasics => '基礎知識あり';

  @override
  String get profile_soundEffects => '効果音';

  @override
  String profile_stepXofY(int current, int total) {
    return 'ステップ $current/$total';
  }

  @override
  String profile_streakLabel(int count) {
    return '$count日継続';
  }

  @override
  String get profile_studyPlanCreated => '学習プランが作成されました！';

  @override
  String get profile_superBadge => 'SUPER';

  @override
  String get profile_superSubtitle => 'AI搭載機能による究極の言語学習体験';

  @override
  String get profile_superTitle => 'InstaLingo Super';

  @override
  String get profile_tenMinutes => '10分';

  @override
  String get profile_threeDaysAWeek => '週3日';

  @override
  String get profile_travelBasics => '旅行の基礎';

  @override
  String get profile_twentyPlusMinutes => '20分以上';

  @override
  String get profile_unlimitedAIConversations => '無制限AI会話';

  @override
  String get profile_unlimitedAIDesc => 'チルコーナーでAIキャラクターと無制限に練習';

  @override
  String get profile_unlockFullExperience => '完全な体験をアンロック';

  @override
  String get profile_unlocked => '解除済み';

  @override
  String get profile_upgradeToSuper => 'Superにアップグレード';

  @override
  String get profile_upperIntermediate => '中上級';

  @override
  String profile_version(String version) {
    return 'InstaLingo v$version';
  }

  @override
  String get profile_visitHelpCenter => 'ヘルプセンターを見る';

  @override
  String get profile_weekendsOnly => '週末のみ';

  @override
  String get profile_whatIsChillCorner => 'チルコーナーとは？';

  @override
  String get profile_whatIsChillCornerAnswer =>
      'チルコーナーでは、学んだ語彙が実世界のコンテキストでAI生成コンテンツとして表示されます。';

  @override
  String questionXofY(int current, int total) {
    return '質問 $current / $total';
  }

  @override
  String get readyToLearn => '今日も学びましょうか？';

  @override
  String get reminderTime => 'リマインダー時間';

  @override
  String get review => '復習';

  @override
  String get reviewVocabulary => '単語を復習';

  @override
  String get sampleAnswer => '回答例：';

  @override
  String get sat => '土';

  @override
  String get save => '保存';

  @override
  String savePercent(int percent) {
    return '$percent% お得';
  }

  @override
  String get scenarioCafeTokyo => 'シナリオ：東京のカフェで注文する';

  @override
  String get section => 'セクション';

  @override
  String get sections => 'セクション';

  @override
  String get seeResults => '結果を見る';

  @override
  String get seeWordsInContext => '文脈の中で学んだ単語を見る';

  @override
  String get settingsTitle => '設定';

  @override
  String get skip => 'スキップ';

  @override
  String speakersCount(String speakers) {
    return '$speakers 人の話者';
  }

  @override
  String get start => '開始';

  @override
  String get startFreeTrial => '無料トライアルを開始';

  @override
  String get startLearning => '学習を開始';

  @override
  String get startNextLesson => 'コースの次のレッスンを始める';

  @override
  String get statsTitle => '統計';

  @override
  String get stillLearning => 'まだ学習中';

  @override
  String get streakCalendar => '連続カレンダー';

  @override
  String streakKeepStreak(int currentStreak) {
    return 'レッスンを完了して、$currentStreak日連続記録を維持しましょう！';
  }

  @override
  String get streakRepair => '連続学習を修復';

  @override
  String get streakRepaired => '修復済み';

  @override
  String get streakShielded => '保護中';

  @override
  String streakShieldsRemaining(int count) {
    return '$count個の連続学習保護が残っています';
  }

  @override
  String get studyPlan => '学習プラン';

  @override
  String get submit => '送信';

  @override
  String get subscription => 'サブスクリプション';

  @override
  String get sun => '日';

  @override
  String get takePlacementTest => 'レベルテストを受ける';

  @override
  String get tapAndHoldMicrophone => 'マイクを長押しして話してください';

  @override
  String get tapToFlip => 'タップして裏返す';

  @override
  String get tapToFlipBack => 'タップして裏返す';

  @override
  String get tapToPlay => 'タップして再生';

  @override
  String get tapToReveal => 'タップして表示';

  @override
  String get tapWordsToBuildAnswer => '単語をタップして回答を作成';

  @override
  String get tapWordsToBuildSentence => '単語をタップして文章を作成';

  @override
  String get thu => '木';

  @override
  String timeAgoHours(int hours) {
    return '$hours時間前';
  }

  @override
  String timeAgoMinutes(int minutes) {
    return '$minutes分前';
  }

  @override
  String get timeSpent => '学習時間';

  @override
  String timeSpentHoursMinutes(int hours, int minutes) {
    return '$hours時間$minutes分';
  }

  @override
  String get today => '今日';

  @override
  String get totalXP => '総XP';

  @override
  String get trueLabel => '正解';

  @override
  String get tryAgain => 'もう一度試す';

  @override
  String get tue => '火';

  @override
  String get typeMessage => 'メッセージを入力...';

  @override
  String get typeWhatYouHear => '聞こえた内容を入力...';

  @override
  String get typeYourAnswerHere => 'ここに回答を入力...';

  @override
  String get unlimitedLessons => '無制限のレッスン';

  @override
  String get unlockSuper => 'スーパーを解除';

  @override
  String get updateNow => '今すぐ更新';

  @override
  String get visitChillCorner => 'Chillコーナーを訪れる';

  @override
  String get vocabularyReview => '語彙復習';

  @override
  String get wed => '水';

  @override
  String get welcomeSubtitle => '新しい言語を学ぶ最も効果的な方法。';

  @override
  String get welcomeTitle => 'InstaLingo へようこそ';

  @override
  String get whatNext => '次は何をしますか？';

  @override
  String get wordsLearned => '学習済み単語';

  @override
  String get wordsPracticed => '練習済み単語';

  @override
  String get xpShort => 'XP';

  @override
  String get xpThisWeek => '今週のXP';

  @override
  String xpToGoal(int xp) {
    return '$xp XP';
  }

  @override
  String get youLabel => 'あなた';

  @override
  String get yourLevel => 'あなたのレベル';

  @override
  String get profile_chooseYourPlan => 'プランを選択';

  @override
  String get profile_contactUs => 'お問い合わせ';

  @override
  String get profile_continueWithFree => '無料で続ける';

  @override
  String get profile_culturalInsights => '文化インサイト';

  @override
  String get profile_culturalInsightsDesc => '各単語の文化的背景と使用法を学ぶ';

  @override
  String get profile_currentPlan => '現在のプラン';

  @override
  String get profile_dailyGoalMet => '今日の目標達成！';

  @override
  String get profile_darkMode => 'ダークモード';

  @override
  String get profile_downloadForOffline => 'オフラインダウンロード';

  @override
  String get profile_downloadForOfflineDesc => 'インターネットなしでいつでもどこでも学習';

  @override
  String get profile_emailUs => 'メールでお問い合わせ';

  @override
  String get profile_falseBeginner => '偽初心者';

  @override
  String get profile_faq => 'よくある質問';

  @override
  String get profile_faqAnswer1 => 'InstaLingoは、実世界のシナリオで言語を学ぶための没入型アプリです。';

  @override
  String get profile_faqAnswer2 => 'Superプランでいつでもアップグレードできます。';

  @override
  String get profile_faqAnswer3 => '[設定] > [進捗をリセット]で進捗をリセットできます。';

  @override
  String get profile_faqAnswer4 => '[設定] > [お問い合わせ] からサポートチームにご連絡ください。';

  @override
  String get profile_faqQuestion1 => 'InstaLingoとは？';

  @override
  String get profile_faqQuestion2 => '後でアップグレードできますか？';

  @override
  String get profile_faqQuestion3 => '進捗をリセットするには？';

  @override
  String get profile_faqQuestion4 => 'サポートへの連絡方法は？';

  @override
  String get profile_feedback => 'フィードバック';

  @override
  String get profile_findFriends => '友達を探す';

  @override
  String get profile_firstSteps => '最初のステップ';

  @override
  String get profile_followingTitle => 'フォロー中';

  @override
  String get profile_freePlan => '無料';

  @override
  String get profile_goPremium => 'プレミアムにアップグレード';

  @override
  String get profile_goalDescription => '主な学習目標は何ですか？';

  @override
  String get profile_goalFluency => '流暢さ';

  @override
  String get profile_goalTravel => '旅行';

  @override
  String get profile_goalWork => '仕事';

  @override
  String get profile_inTheMorning => '午前中';

  @override
  String get profile_keepPracticing => '練習を続けましょう！';

  @override
  String get profile_lateNight => '深夜 (午後9時以降)';

  @override
  String get profile_leaderboardTitle => 'リーダーボード';

  @override
  String get profile_learnBasicPhrases => '基本フレーズを学ぶ';

  @override
  String get profile_levelUp => 'レベルアップ！';

  @override
  String get profile_monthly => '月額';

  @override
  String get profile_morningBird => '朝型 (午前5時〜9時)';

  @override
  String get profile_mostPopular => '人気';

  @override
  String get profile_motivationCulture => '文化';

  @override
  String get profile_motivationFamily => '家族';

  @override
  String get profile_motivationFun => '楽しみ';

  @override
  String get profile_motivationTravel => '旅行';

  @override
  String get profile_motivationWork => '仕事';

  @override
  String get profile_myPlan => 'マイプラン';

  @override
  String get profile_nextAchievement => '次の実績';

  @override
  String get profile_noFollowingYet => 'まだフォローしていません';

  @override
  String get profile_noFollowingYetMessage => '学習者をフォローして最新情報を入手しましょう！';

  @override
  String get profile_noFriendsYet => 'まだ友達がいません';

  @override
  String get profile_noFriendsYetMessage => '他の学習者とつながって一緒に練習しましょう！';

  @override
  String get profile_noLeaderboardData => 'まだリーダーボードデータがありません';

  @override
  String get profile_noLeaderboardDataMessage => '学習を開始してランキングに登場しましょう！';

  @override
  String get profile_notifications => '通知';

  @override
  String get profile_offlineTitle => 'オフライン';

  @override
  String get profile_onboardingComplete => 'オンボーディング完了';

  @override
  String get profile_onboardingTitle => 'オンボーディング';

  @override
  String get profile_perMonth => '/月';

  @override
  String get profile_plan => 'プラン';

  @override
  String get profile_premium => 'プレミアム';

  @override
  String get profile_proFeatures => 'Pro機能';

  @override
  String get profile_proFeaturesDesc => 'すべてのプレミアムコンテンツと機能をアンロック';

  @override
  String get profile_proPlan => 'Proプラン';

  @override
  String get profile_proPlanDesc => 'プレミアム機能で学習を加速';

  @override
  String get profile_profile => 'プロフィール';

  @override
  String get profile_progress => '進捗';

  @override
  String get profile_progressReset => '進捗がリセットされます';

  @override
  String get profile_progressResetMessage => 'これによりすべての進捗が消去されます。この操作は元に戻せません。';

  @override
  String profile_questionXofY(Object x, Object y) {
    return '質問 $x/$y';
  }

  @override
  String get profile_reminder => 'リマインダー';

  @override
  String get profile_reminderTime => 'リマインダー時間';

  @override
  String get profile_removeAds => '広告を削除';

  @override
  String get profile_removeAdsDesc => '中断のない学習体験をお楽しみください';

  @override
  String profile_savePercent(Object percent) {
    return '$percent% 保存';
  }

  @override
  String get profile_section => 'セクション';

  @override
  String get profile_seeAll => 'すべて見る';

  @override
  String get profile_sendFeedback => 'フィードバックを送信';

  @override
  String get profile_skillLevel => 'スキルレベル';

  @override
  String get profile_speakingPractice => 'スピーキング練習';

  @override
  String get profile_startFreeTrial => '無料トライアルを開始';

  @override
  String get profile_studyPlanDescription => '学習プランをカスタマイズしましょう。';

  @override
  String get profile_studyPlanTitle => '学習プラン';

  @override
  String get profile_studyReminder => '学習リマインダー';

  @override
  String get profile_subscribeNow => '今すぐ登録';

  @override
  String get profile_subtitle => 'プロフィール';

  @override
  String get profile_superDescription => 'Superの全機能をアンロック';

  @override
  String get profile_support => 'サポート';

  @override
  String get profile_travelPhrases => '旅行フレーズ';

  @override
  String get profile_troubleshooting => 'トラブルシューティング';

  @override
  String profile_tryFreeForDays(Object days, Object price) {
    return '$days日間無料でお試し、その後$price';
  }

  @override
  String get profile_unlimitedAccess => '無制限アクセス';

  @override
  String get profile_unlimitedAccessDesc => 'すべての言語コースとレッスンにアクセス';

  @override
  String get profile_unlimitedAiConversations => '無制限のAI会話';

  @override
  String get profile_unlimitedAiConversationsDesc => 'いつでもAIチューターと会話練習';

  @override
  String get profile_unlimitedLessons => '無制限レッスン';

  @override
  String get profile_unlimitedLessonsDesc => '制限なくすべてのレッスンにアクセス';

  @override
  String get profile_unlimitedVocabularyBuilder => '無制限の語彙ビルダー';

  @override
  String get profile_unlimitedVocabularyBuilderDesc => '適応型フラッシュカードで語彙を増やす';

  @override
  String get profile_weekdays => '平日';

  @override
  String get profile_weekends => '週末';

  @override
  String get profile_whenToStudy => 'いつ勉強しますか？';

  @override
  String get profile_workCommunication => '仕事のコミュニケーション';

  @override
  String get profile_workVocabulary => 'ビジネス語彙';

  @override
  String get profile_writingPractice => 'ライティング練習';

  @override
  String get profile_xpAndGems => 'XPとジェム';

  @override
  String get profile_xpAndGemsDesc => 'XPとジェムの説明';

  @override
  String get profile_xpEarnedToday => '今日獲得したXP';

  @override
  String get profile_youEarned => '獲得しました！';

  @override
  String get profile_yourStreak => 'あなたの継続';

  @override
  String get progressToNextLevel => '次のレベルまでの進捗';

  @override
  String get rateApp => 'アプリを評価';

  @override
  String get recording => '録音中...';

  @override
  String get removeAds => '広告を削除';

  @override
  String get saveAndContinue => '保存して続行';

  @override
  String get searchPosts => '投稿を検索';

  @override
  String sectionX(Object x) {
    return 'セクション $x';
  }

  @override
  String get seeAllAchievements => 'すべての実績を見る';

  @override
  String get shareApp => 'アプリを共有';

  @override
  String get speakNow => '今すぐ話す';

  @override
  String get startSpeaking => '話し始める';

  @override
  String get streakTitle => '継続日数';

  @override
  String get studyNow => '今すぐ学習';

  @override
  String get subscribeNow => '今すぐ登録';

  @override
  String get superMarket => 'スーパーマーケット';

  @override
  String get swipeToContinue => 'スワイプして続行';

  @override
  String get tapToListen => 'タップして聞く';

  @override
  String get tapToSpeak => 'タップして話す';

  @override
  String get technicalIssues => '技術的な問題';

  @override
  String get totalLessons => '総レッスン数';

  @override
  String get unlimited => '無制限';

  @override
  String get unlockAllFeatures => 'すべての機能をアンロック';

  @override
  String get unlockNow => '今すぐアンロック';

  @override
  String get upgradeToPro => 'Proにアップグレード';

  @override
  String get upgradeToSuper => 'Superにアップグレード';

  @override
  String get viewAll => 'すべて見る';

  @override
  String get viewDetails => '詳細を見る';

  @override
  String get viewLeaderboard => 'リーダーボードを見る';

  @override
  String get vocabulary => '語彙';

  @override
  String get weekly => '毎週';

  @override
  String get weeklyGoal => '週間目標';

  @override
  String get welcome => 'ようこそ';

  @override
  String get welcomeBack => 'おかえりなさい';

  @override
  String get wordOfTheDay => '今日の単語';

  @override
  String get xpEarned => '獲得XP';

  @override
  String get yearly => '年間';

  @override
  String get yes => 'はい';

  @override
  String get youAreOffline => 'オフラインです';

  @override
  String get yourAnswer => 'あなたの答え';

  @override
  String get yourProgress => 'あなたの進捗';

  @override
  String get onboarding_learningGoalTitle => '目標は何ですか？';

  @override
  String get onboarding_learningGoalSubtitle => '学習体験をカスタマイズするために役立ちます。';

  @override
  String get onboarding_examPrep => '試験対策';

  @override
  String get onboarding_examPrepDesc => '体系的なレッスン、模擬試験、時間制限付き練習。予想スコアを追跡。';

  @override
  String get onboarding_justForFun => '趣味で学ぶ';

  @override
  String get onboarding_justForFunDesc =>
      '自分のペースで学びましょう。テストもプレッシャーもありません。自然に言語を身につけましょう。';

  @override
  String get onboarding_examTypeTitle => 'どの試験？';

  @override
  String onboarding_examTypeSubtitle(String lang) {
    return '目指している$langの試験を選んでください。';
  }

  @override
  String get onboarding_japanese => '日本語';

  @override
  String get onboarding_korean => '韓国語';

  @override
  String get onboarding_examLevelBeginner => '初級';

  @override
  String get onboarding_examLevelElementary => '初級';

  @override
  String get onboarding_examLevelBeginnerElementary => '初級';

  @override
  String onboarding_examWordsCount(String count) {
    return '約$count語';
  }

  @override
  String get onboarding_examSectionsJLPT => '語彙、文法、読解、聴解';

  @override
  String get onboarding_examSectionsTOPIK => '聴解、読解';

  @override
  String get keepPracticing => '練習を続けましょう！';

  @override
  String get kanjiReference => '漢字リファレンス';

  @override
  String get kanaReference => 'かな表';

  @override
  String get hiraganaChart => 'ひらがな';

  @override
  String get katakanaChart => 'カタカナ';

  @override
  String get examCompleteTitle => '模擬試験完了！';

  @override
  String get yourScore => 'スコア';

  @override
  String get predictedLevel => '予想レベル';

  @override
  String get profile_tts => '発音 (TTS)';

  @override
  String get profile_ttsDesc => '単語をタップして発音を聞く';

  @override
  String get studyReminderBody => '練習の時間です！';

  @override
  String get jlptN5Label => 'JLPT N5';

  @override
  String get jlptN4Label => 'JLPT N4';

  @override
  String get onboarding_examLevelIntermediate => '中級';

  @override
  String get onboarding_examLevelUpperIntermediate => '中上級';

  @override
  String get onboarding_examLevelAdvanced => '上級';
}
