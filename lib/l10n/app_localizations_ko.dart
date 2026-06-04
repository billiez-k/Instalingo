// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get achievementsTitle => '업적';

  @override
  String get active => '활성';

  @override
  String get advancedProgressTracking => '고급 진도 추적';

  @override
  String get aiAssistantName => '마야';

  @override
  String get aiAssistantRole => '카페 직원';

  @override
  String get aiBadge => 'AI';

  @override
  String get aiChat => 'AI 채팅';

  @override
  String get aiConversationGreeting =>
      '안녕하세요! 마야예요. 도쿄의 카페에서 일하고 있어요. 오늘은 무엇을 연습하고 싶으세요?';

  @override
  String get aiConversationPractice => 'AI 대화 연습';

  @override
  String get aiConversationTitle => 'AI 대화';

  @override
  String get aiPractice => 'AI 연습';

  @override
  String get aiYou => '당신';

  @override
  String get annual => '연간';

  @override
  String get appTagline => '배우다. 휴식. 반복.';

  @override
  String get appTitle => 'InstaLingo';

  @override
  String get back => '뒤로';

  @override
  String get cancel => '취소';

  @override
  String get chapter => '챕터';

  @override
  String get chatWithAI => 'AI 캐릭터와 채팅';

  @override
  String get check => '확인';

  @override
  String get chill => '휴식';

  @override
  String get chillCorner => 'Chill 코너';

  @override
  String get chill_addComment => '댓글을 추가하세요...';

  @override
  String get chill_aiGeneratedImage => 'AI 생성 이미지';

  @override
  String get chill_comments => '댓글';

  @override
  String get chill_noPosts => '아직 게시물이 없습니다';

  @override
  String get chill_noPostsMessage => '수업을 완료하여 커뮤니티 어휘 게시물을 잠금 해제하세요.';

  @override
  String get chill_postNotFound => '게시물을 찾을 수 없음';

  @override
  String get chill_postNotFoundMessage => '이 게시물은 삭제되었거나 더 이상 사용할 수 없습니다.';

  @override
  String get chill_share => '공유';

  @override
  String get clear => '지우기';

  @override
  String get clearAll => '모두 지우기';

  @override
  String get commitment => '학습 약속';

  @override
  String get continueLearning => '학습 계속하기';

  @override
  String get continueText => '계속';

  @override
  String get correct => '정답';

  @override
  String correctCountOfTotal(int correct, int total) {
    return '$correct / $total 정답';
  }

  @override
  String correctWithExplanation(String explanation) {
    return '정답입니다! $explanation';
  }

  @override
  String get courseComplete => '코스 완료!';

  @override
  String get courseCompleteTitle => '해냈어요!';

  @override
  String get coursePath => '코스 경로';

  @override
  String get createProfile => '프로필 만들기';

  @override
  String get createProfileDesc => '이것은 당신의 학습 경험을 개인화하는 데 도움이 됩니다.';

  @override
  String get dailyGoal => '일일 목표';

  @override
  String get dailyGoalCardTitle => '일일 목표';

  @override
  String get dailyGoalReached => '목표 달성! 수고하셨습니다!';

  @override
  String get darkMode => '다크 모드';

  @override
  String get dayStreak => '연속 학습 일수';

  @override
  String dayStreakCount(int count) {
    return '$count일';
  }

  @override
  String get defaultDisplayName => '학습자';

  @override
  String get done => '완료';

  @override
  String get editProfile => '프로필 편집';

  @override
  String get emptyStateMessage => '나중에 다시 확인해 주세요.';

  @override
  String get emptyStateTitle => '아직 콘텐츠가 없습니다';

  @override
  String get errorGenericMessage => '이 콘텐츠를 로드할 수 없습니다. 다시 시도해 주세요.';

  @override
  String get errorGenericTitle => '문제가 발생했습니다';

  @override
  String get exArrangeWords => '단어를 배열하여 올바른 문장을 만드세요';

  @override
  String get exComprehension => '글을 읽고 답하세요';

  @override
  String get exDialogueComplete => '대화를 완성하세요';

  @override
  String get exFillInBlank => '빈칸을 채우세요';

  @override
  String get exFlashCard => '탭하여 카드 뒤집기';

  @override
  String get exGrammarTip => '문법 팁';

  @override
  String get exImageIdentify => '올바른 이미지를 탭하세요';

  @override
  String get exMatchWords => '단어와 의미를 연결하세요';

  @override
  String get exPhraseBuilder => '구문을 만드세요';

  @override
  String get exSpeaking => '이 단어를 소리내어 말하세요';

  @override
  String get exTranslate => '이 문장을 번역하세요';

  @override
  String get exTrueFalse => '이 문장이 맞나요?';

  @override
  String get exTypeWhatYouHear => '들은 내용을 입력하세요';

  @override
  String exVocabMultipleChoice(Object word) {
    return '\"$word\"의 의미는 무엇인가요?';
  }

  @override
  String exWhichWordMeans(Object word) {
    return '\"$word\"의 의미는 무엇인가요?';
  }

  @override
  String get exWriting => '답을 적으세요';

  @override
  String get exampleLabel => '예시';

  @override
  String exercisesProgress(int completed, int total) {
    return '$completed / $total 연습';
  }

  @override
  String get falseLabel => '틀림';

  @override
  String get featureAICharacters => 'AI 캐릭터';

  @override
  String get featureAICharactersDesc =>
      'Chill Corner에서 실제 사람처럼 반응하는 AI 캐릭터와 연습하세요.';

  @override
  String get featureMotivation => '동기 부여 유지';

  @override
  String get featureMotivationDesc => 'XP를 획득하고, 연속 학습을 유지하며, 업적을解锁하세요.';

  @override
  String get featureStructuredCourses => '체계적인 코스';

  @override
  String get featureStructuredCoursesDesc => '전문적으로 설계된 레슨을 통해 단계적으로 학습하세요.';

  @override
  String get findFriends => '친구 찾기';

  @override
  String get finishLesson => '레슨 완료';

  @override
  String get flashcardEasy => '쉬움';

  @override
  String get flashcardGood => '좋음';

  @override
  String get flashcardHard => '어려움';

  @override
  String get followingTitle => '팔로잉';

  @override
  String get forceUpdateBody =>
      'InstaLingo를 더 빠르고 안정적으로 만들고 새로운 기능을 추가했습니다. 계속하려면 최신 버전으로 업데이트하세요.';

  @override
  String get forceUpdateBugFixes => '버그 수정 및 안정성';

  @override
  String get forceUpdateMessage =>
      'InstaLingo의 새로운 버전을 사용할 수 있습니다. 학습을 계속하려면 업데이트하세요.';

  @override
  String get forceUpdateNewContent => '새로운 레슨과 연습';

  @override
  String get forceUpdatePerformance => '성능 개선';

  @override
  String get forceUpdateTitle => '업데이트 필요';

  @override
  String get fri => '금';

  @override
  String get friendsTitle => '친구';

  @override
  String get gems => '보석';

  @override
  String get getStarted => '시작하기';

  @override
  String get getUnlimitedLearning => '무제한 학습 받기';

  @override
  String get goodbye => '안녕히 가세요';

  @override
  String get gotIt => '알겠습니다!';

  @override
  String get grammarExampleFallback => '연습이 완벽을 만듭니다!';

  @override
  String get grammarRuleFallback => '이 연습의 문법을 주의해서 보세요.';

  @override
  String get grammarTip => '문법 팁';

  @override
  String get greetingAfternoon => '좋은 오후입니다';

  @override
  String get greetingEvening => '좋은 저녁입니다';

  @override
  String get greetingMorning => '좋은 아침입니다';

  @override
  String get hello => '안녕하세요!';

  @override
  String get helpSupport => '도움말 및 지원';

  @override
  String get holdToSpeak => '말하려면 길게 누르세요';

  @override
  String get howAreYou => '어떻게 지내세요?';

  @override
  String get iAlreadyHaveAccount => '이미 계정이 있습니다';

  @override
  String get incorrect => '오답';

  @override
  String get knowIt => '알고 있음';

  @override
  String get language => '언어';

  @override
  String get leaderboardTitle => '리더보드';

  @override
  String get learn => '학습';

  @override
  String get learnRuleToImprove => '실력 향상을 위해 이 규칙을 배우세요';

  @override
  String get learningLanguage => '학습 언어';

  @override
  String get lessonComplete => '레슨 완료!';

  @override
  String get lessonCompleteGood => '노력했어! 복습하고 다시 도전하자!';

  @override
  String get lessonCompleteGreat => '잘했어! 계속 연습하자!';

  @override
  String get lessonCompletePerfect => '완벽해! 불타고 있어!';

  @override
  String get lessons => '레슨';

  @override
  String get levelAbbreviation => '레벨';

  @override
  String get levelAdvanced => '고급';

  @override
  String get levelBeginner => '초급';

  @override
  String get levelElementary => '입문';

  @override
  String get levelIntermediate => '중급';

  @override
  String get levelProficiency => '능숙';

  @override
  String get levelUpperIntermediate => '중상급';

  @override
  String get loading => '로딩 중...';

  @override
  String get loadingLesson => '레슨 불러오는 중...';

  @override
  String get logout => '로그아웃';

  @override
  String get matchPairsInstruction => '왼쪽 단어를 누른 다음 오른쪽에서 일치하는 항목을 누르세요';

  @override
  String get maybeLater => '나중에';

  @override
  String get mon => '월';

  @override
  String get monthly => '월간';

  @override
  String get motivation => '학습 동기';

  @override
  String get myNameIs => '제 이름은';

  @override
  String get nativeLanguage => '모국어';

  @override
  String get next => '다음';

  @override
  String get nextQuestion => '다음 질문';

  @override
  String get niceToMeetYou => '만나서 반갑습니다';

  @override
  String get noAds => '광고 없음';

  @override
  String get noConnectionMessage => '인터넷 연결을 확인하고 다시 시도해 주세요.';

  @override
  String get noConnectionTitle => '연결 없음';

  @override
  String get notNow => '지금은 안 함';

  @override
  String notQuiteWithExplanation(String explanation) {
    return '아쉽네요. $explanation';
  }

  @override
  String get notifications => '알림';

  @override
  String get onboardingTitle => '체계적인 코스와 AI 캐릭터로 언어를 배워보세요';

  @override
  String get onboarding_commitmentCasual => '가볍게';

  @override
  String get onboarding_commitmentIntense => '집중';

  @override
  String get onboarding_commitmentRegular => '꾸준히';

  @override
  String get onboarding_commitmentSerious => '진지';

  @override
  String get onboarding_commitmentSubtitle => '언제든지 설정에서 변경할 수 있습니다.';

  @override
  String get onboarding_commitmentTitle => '얼마나 시간을 투자할 수 있나요?';

  @override
  String get onboarding_displayNameLabel => '표시 이름';

  @override
  String get onboarding_emailOptionalLabel => '이메일 (선택)';

  @override
  String get onboarding_enterEmailHint => '이메일을 입력하세요';

  @override
  String get onboarding_enterNameHint => '이름을 입력하세요';

  @override
  String get onboarding_learningLangSubtitle => '마스터하고 싶은 언어를 선택하세요.';

  @override
  String get onboarding_motivationBrainTraining => '뇌 트레이닝';

  @override
  String get onboarding_motivationCareer => '경력';

  @override
  String get onboarding_motivationCulture => '문화';

  @override
  String get onboarding_motivationFamily => '가족';

  @override
  String get onboarding_motivationFun => '그냥 재미로';

  @override
  String get onboarding_motivationMoviesShows => '영화와 TV';

  @override
  String get onboarding_motivationStudyAbroad => '유학';

  @override
  String get onboarding_motivationSubtitle => '해당하는 것을 모두 선택하세요.';

  @override
  String get onboarding_motivationTitle => '왜 배우나요?';

  @override
  String get onboarding_motivationTravel => '여행';

  @override
  String get onboarding_nativeLangSubtitle => '이 정보를 바탕으로 학습 경험을 개인화합니다.';

  @override
  String get onboarding_proficiencyAdvanced => '고급';

  @override
  String get onboarding_proficiencyAdvancedDesc => '유창하게 말할 수 있습니다';

  @override
  String get onboarding_proficiencyBeginner => '초급';

  @override
  String get onboarding_proficiencyBeginnerDesc => '단어를 조금 압니다';

  @override
  String get onboarding_proficiencyElementary => '입문';

  @override
  String get onboarding_proficiencyElementaryDesc => '간단한 문장을 만들 수 있습니다';

  @override
  String get onboarding_proficiencyIntermediate => '중급';

  @override
  String get onboarding_proficiencyIntermediateDesc => '대화를 할 수 있습니다';

  @override
  String get onboarding_proficiencyProficient => '능숙';

  @override
  String get onboarding_proficiencyProficientDesc => '원어민처럼 말할 수 있습니다';

  @override
  String get onboarding_proficiencySubtitle => '적절한 난이도에서 시작합니다.';

  @override
  String get onboarding_proficiencyTitle => '현재 수준은?';

  @override
  String get onboarding_proficiencyUpperIntermediate => '중상급';

  @override
  String get onboarding_proficiencyUpperIntermediateDesc =>
      '다양한 주제를 이야기할 수 있습니다';

  @override
  String get onboarding_skipForNow => '지금은 건너뛰기';

  @override
  String get paywallSubtitle => '무제한 학습 잠금 해제';

  @override
  String get paywallTitle => 'InstaLingo 슈퍼';

  @override
  String get perMonth => '/월';

  @override
  String get perYear => '/년';

  @override
  String get pickNewCourse => '새 코스 선택하기';

  @override
  String get playing => '재생 중...';

  @override
  String get practiceWords => '방금 배운 단어 연습하기';

  @override
  String get privacy => '개인정보';

  @override
  String get proficiency => '숙련도';

  @override
  String get profile => '프로필';

  @override
  String get profile_academicEnglish => '학술 영어';

  @override
  String get profile_account => '계정';

  @override
  String get profile_achievementsUnlocked => '달성한 업적';

  @override
  String get profile_adFreeExperience => '광고 없는 경험';

  @override
  String get profile_adFreeExperienceDesc => '방해 없이 학습에 집중하세요.';

  @override
  String get profile_advanced => '고급';

  @override
  String get profile_advancedSpeakingDesc => '파형 표시와 함께 상세한 발음 및 유창성 분석을 받아보세요';

  @override
  String get profile_advancedSpeakingFeedback => '고급 말하기 피드백';

  @override
  String get profile_aiConversationPractice => 'AI 대화 연습';

  @override
  String get profile_aiConversationPracticeAnswer =>
      '다양한 시나리오에서 AI 캐릭터와 실제 대화를 연습하세요';

  @override
  String get profile_allChillCornerContent => '모든 Chill 코너 콘텐츠';

  @override
  String get profile_appearance => '화면';

  @override
  String get profile_beginner => '초급';

  @override
  String get profile_bestValue => '최고 가치';

  @override
  String get profile_browseTopics => '아래 주제를 찾아보거나 직접 문의하세요';

  @override
  String get profile_businessEnglish => '비즈니스 영어';

  @override
  String get profile_cancelAnytime => '언제든지 취소 가능. 약정 없음.';

  @override
  String get profile_checkForUpdates => '업데이트 확인';

  @override
  String get profile_completeBeginner => '완전 초보';

  @override
  String get profile_contactSupport => '지원팀에 문의';

  @override
  String get profile_createPlan => '계획 만들기';

  @override
  String get profile_dailyConversation => '일상 대화';

  @override
  String get profile_daytime => '낮 (오전 9시-오후 5시)';

  @override
  String get profile_displayName => '표시 이름';

  @override
  String get profile_duration => '시간';

  @override
  String get profile_durationDesc => '세션당 얼마나 오래 할까요?';

  @override
  String get profile_earningXPGems => 'XP와 젬 획득';

  @override
  String get profile_earningXPGemsAnswer =>
      '레슨을 완료하고, 연속 기록을 유지하고, 어휘를 복습하여 XP와 젬을 획득하세요.';

  @override
  String get profile_elementary => '초급';

  @override
  String get profile_email => '이메일';

  @override
  String get profile_enableNotifications => '알림 활성화';

  @override
  String get profile_enableNotificationsAnswer =>
      '설정에서 알림을 켜서 매일 학습 독려와 연속 기록을 유지하세요.';

  @override
  String get profile_enterYourEmail => '이메일 입력';

  @override
  String get profile_enterYourName => '이름 입력';

  @override
  String get profile_evening => '저녁 (오후 5시-9시)';

  @override
  String get profile_everyDay => '매일';

  @override
  String get profile_everythingInMonthly => '월간 플랜의 모든 것';

  @override
  String get profile_examPreparation => '시험 준비';

  @override
  String get profile_exclusiveStudyPlans => '독점 학습 계획';

  @override
  String get profile_fifteenMinutes => '15분';

  @override
  String get profile_fiveDaysAWeek => '주 5일';

  @override
  String get profile_fiveMinutes => '5분';

  @override
  String get profile_follow => '팔로우';

  @override
  String get profile_followOthersMessage => '다른 학습자를 팔로우하여 여기에서 확인하세요.';

  @override
  String get profile_gettingStarted => '시작하기';

  @override
  String get profile_goal => '목표';

  @override
  String get profile_goalDesc => '무엇을 달성하고 싶나요?';

  @override
  String get profile_gotIt => '확인';

  @override
  String get profile_howDoIStart => '학습을 어떻게 시작하나요?';

  @override
  String get profile_howDoIStartAnswer => '모국어를 선택한 다음 배울 언어를 선택하세요.';

  @override
  String get profile_inProgress => '진행 중';

  @override
  String get profile_instalingoSuperFAQ => 'InstaLingo Super';

  @override
  String get profile_instalingoSuperFAQAnswer =>
      'Super로 업그레이드하면 무제한 레슨, AI 연습, 고급 통계를 이용할 수 있습니다.';

  @override
  String get profile_intensity => '강도';

  @override
  String get profile_intensityDesc => '주당 몇 회?';

  @override
  String get profile_intermediate => '중급';

  @override
  String get profile_learning => '학습';

  @override
  String get profile_learningFeatures => '학습 기능';

  @override
  String profile_learningStatus(String language, String level) {
    return '학습 중: $language · $level';
  }

  @override
  String get profile_lessonRemindersStreakAlerts => '레슨 알림 및 연속 학습 알림';

  @override
  String profile_lessonsCompleted(int completed, int total) {
    return '레슨 $completed/$total 완료';
  }

  @override
  String get profile_level => '레벨';

  @override
  String get profile_levelDesc => '어디서부터 시작하나요?';

  @override
  String get profile_levelSuffix => '레벨';

  @override
  String profile_minPerDay(int min) {
    return '하루 $min분';
  }

  @override
  String profile_minutesCount(int count) {
    return '하루 $count분';
  }

  @override
  String get profile_morning => '아침 (오전 6-9시)';

  @override
  String get profile_night => '밤 (오후 9시-자정)';

  @override
  String get profile_noAchievementsMessage => '레슨을 완료하고 연속 기록을 유지하여 업적을 달성하세요';

  @override
  String get profile_noAchievementsYet => '아직 달성한 업적이 없습니다';

  @override
  String get profile_notSet => '설정 안 됨';

  @override
  String get profile_offlineMode => '오프라인 모드';

  @override
  String get profile_offlineModeDesc => '모든 레슨과 콘텐츠 다운로드';

  @override
  String get profile_perMonthDesc => '월간';

  @override
  String get profile_perYearDesc => '연간';

  @override
  String get profile_personalizedStudyPlans => '맞춤형 학습 계획';

  @override
  String get profile_personalizedStudyPlansDesc => '목표와 일정에 맞춘 AI 생성 학습 계획';

  @override
  String get profile_priorityAIResponses => '우선 AI 응답';

  @override
  String get profile_proBadge => 'PRO';

  @override
  String get profile_proficiencyLevel => '숙련도 레벨';

  @override
  String get profile_proficient => '능숙';

  @override
  String get profile_resetProgress => '진행 상황 초기화';

  @override
  String get profile_resetProgressFAQ => '진행 상황 초기화';

  @override
  String get profile_resetProgressFAQAnswer =>
      '설정 > 진행 상황 초기화에서 처음부터 다시 시작할 수 있습니다. 이 작업은 되돌릴 수 없습니다.';

  @override
  String get profile_saveFiftyVsMonthly => '월간 대비 50% 절약';

  @override
  String get profile_schedule => '일정';

  @override
  String get profile_scheduleDesc => '언제 공부할 수 있나요?';

  @override
  String get profile_settingDailyGoals => '일일 목표 설정';

  @override
  String get profile_settingDailyGoalsAnswer =>
      '프로필 > 설정 > 일일 목표에서 학습 목표 시간을 조정할 수 있습니다.';

  @override
  String get profile_someBasics => '기본 지식 있음';

  @override
  String get profile_soundEffects => '효과음';

  @override
  String profile_stepXofY(int current, int total) {
    return '단계 $current/$total';
  }

  @override
  String profile_streakLabel(int count) {
    return '$count일 연속';
  }

  @override
  String get profile_studyPlanCreated => '학습 계획이 생성되었습니다!';

  @override
  String get profile_superBadge => 'SUPER';

  @override
  String get profile_superSubtitle => 'AI 기반 기능으로 제공되는 최고의 언어 학습 경험';

  @override
  String get profile_superTitle => 'InstaLingo Super';

  @override
  String get profile_tenMinutes => '10분';

  @override
  String get profile_threeDaysAWeek => '주 3일';

  @override
  String get profile_travelBasics => '여행 기초';

  @override
  String get profile_twentyPlusMinutes => '20분 이상';

  @override
  String get profile_unlimitedAIConversations => '무제한 AI 대화';

  @override
  String get profile_unlimitedAIDesc => 'Chill 코너에서 AI 캐릭터와 무제한으로 연습';

  @override
  String get profile_unlockFullExperience => '전체 경험 잠금 해제';

  @override
  String get profile_unlocked => '잠금 해제됨';

  @override
  String get profile_upgradeToSuper => 'Super로 업그레이드';

  @override
  String get profile_upperIntermediate => '중상급';

  @override
  String profile_version(String version) {
    return 'InstaLingo v$version';
  }

  @override
  String get profile_visitHelpCenter => '고객센터 방문';

  @override
  String get profile_weekendsOnly => '주말만';

  @override
  String get profile_whatIsChillCorner => 'Chill 코너란?';

  @override
  String get profile_whatIsChillCornerAnswer =>
      'Chill 코너는 학습한 어휘를 실제 상황의 AI 생성 콘텐츠로 보여줍니다.';

  @override
  String questionXofY(int current, int total) {
    return '질문 $current / $total';
  }

  @override
  String get readyToLearn => '오늘도 학습할 준비가 되셨나요?';

  @override
  String get reminderTime => '알림 시간';

  @override
  String get review => '복습';

  @override
  String get reviewVocabulary => '어휘 복습';

  @override
  String get sampleAnswer => '답변 예시:';

  @override
  String get sat => '토';

  @override
  String get save => '저장';

  @override
  String savePercent(int percent) {
    return '$percent% 할인';
  }

  @override
  String get scenarioCafeTokyo => '시나리오: 도쿄 카페에서 주문하기';

  @override
  String get section => '섹션';

  @override
  String get sections => '섹션';

  @override
  String get seeResults => '결과 보기';

  @override
  String get seeWordsInContext => '배운 단어를 문맥에서 보기';

  @override
  String get settingsTitle => '설정';

  @override
  String get skip => '건너뛰기';

  @override
  String speakersCount(String speakers) {
    return '$speakers 명의 사용자';
  }

  @override
  String get start => '시작';

  @override
  String get startFreeTrial => '무료 체험 시작';

  @override
  String get startLearning => '학습 시작';

  @override
  String get startNextLesson => '코스의 다음 레슨 시작하기';

  @override
  String get statsTitle => '통계';

  @override
  String get stillLearning => '아직 학습 중';

  @override
  String get streakCalendar => '연속 학습 달력';

  @override
  String streakKeepStreak(int currentStreak) {
    return '수업을 완료하고 $currentStreak일 연속 기록 유지하세요!';
  }

  @override
  String get streakRepair => '연속 학습 복구';

  @override
  String get streakRepaired => '복구됨';

  @override
  String get streakShielded => '보호됨';

  @override
  String streakShieldsRemaining(int count) {
    return '$count개의 연속 학습 보호 남음';
  }

  @override
  String get studyPlan => '학습 계획';

  @override
  String get submit => '제출';

  @override
  String get subscription => '구독';

  @override
  String get sun => '일';

  @override
  String get takePlacementTest => '배치 테스트 보기';

  @override
  String get tapAndHoldMicrophone => '마이크를 길게 눌러 말하기';

  @override
  String get tapToFlip => '탭하여 뒤집기';

  @override
  String get tapToFlipBack => '탭하여 뒤집기';

  @override
  String get tapToPlay => '탭하여 재생';

  @override
  String get tapToReveal => '탭하여 보기';

  @override
  String get tapWordsToBuildAnswer => '단어를 탭하여 답변 만들기';

  @override
  String get tapWordsToBuildSentence => '단어를 탭하여 문장 만들기';

  @override
  String get thu => '목';

  @override
  String timeAgoHours(int hours) {
    return '$hours시간 전';
  }

  @override
  String timeAgoMinutes(int minutes) {
    return '$minutes분 전';
  }

  @override
  String get timeSpent => '학습 시간';

  @override
  String timeSpentHoursMinutes(int hours, int minutes) {
    return '$hours시간 $minutes분';
  }

  @override
  String get today => '오늘';

  @override
  String get totalXP => '총 XP';

  @override
  String get trueLabel => '정답';

  @override
  String get tryAgain => '다시 시도';

  @override
  String get tue => '화';

  @override
  String get typeMessage => '메시지를 입력하세요...';

  @override
  String get typeWhatYouHear => '들은 내용을 입력하세요...';

  @override
  String get typeYourAnswerHere => '여기에 답변을 입력하세요...';

  @override
  String get unlimitedLessons => '무제한 레슨';

  @override
  String get unlockSuper => '슈퍼 잠금 해제';

  @override
  String get updateNow => '지금 업데이트';

  @override
  String get visitChillCorner => 'Chill 코너 방문';

  @override
  String get vocabularyReview => '어휘 복습';

  @override
  String get wed => '수';

  @override
  String get welcomeSubtitle => '새로운 언어를 배우는 가장 효과적인 방법입니다.';

  @override
  String get welcomeTitle => 'InstaLingo에 오신 것을 환영합니다';

  @override
  String get whatNext => '다음에 무엇을 하시겠어요?';

  @override
  String get wordsLearned => '학습한 단어';

  @override
  String get wordsPracticed => '연습한 단어';

  @override
  String get xpShort => 'XP';

  @override
  String get xpThisWeek => '이번 주 XP';

  @override
  String xpToGoal(int xp) {
    return '$xp XP';
  }

  @override
  String get youLabel => '나';

  @override
  String get yourLevel => '당신의 레벨';

  @override
  String get profile_chooseYourPlan => '플랜 선택';

  @override
  String get profile_contactUs => '문의하기';

  @override
  String get profile_continueWithFree => '무료로 계속하기';

  @override
  String get profile_culturalInsights => '문화 인사이트';

  @override
  String get profile_culturalInsightsDesc => '각 단어의 문화적 배경과 사용법 배우기';

  @override
  String get profile_currentPlan => '현재 플랜';

  @override
  String get profile_dailyGoalMet => '오늘의 목표 달성!';

  @override
  String get profile_darkMode => '다크 모드';

  @override
  String get profile_downloadForOffline => '오프라인 다운로드';

  @override
  String get profile_downloadForOfflineDesc => '인터넷 없이 언제 어디서나 학습';

  @override
  String get profile_emailUs => '이메일로 문의';

  @override
  String get profile_falseBeginner => '거짓 초보';

  @override
  String get profile_faq => '자주 묻는 질문';

  @override
  String get profile_faqAnswer1 => 'InstaLingo는 실제 상황에서 언어를 배울 수 있는 몰입형 앱입니다.';

  @override
  String get profile_faqAnswer2 => 'Super 플랜으로 언제든지 업그레이드할 수 있습니다.';

  @override
  String get profile_faqAnswer3 => '설정 > 진행 상황 초기화에서 진행 상황을 초기화할 수 있습니다.';

  @override
  String get profile_faqAnswer4 => '설정 > 문의하기에서 지원팀에 연락할 수 있습니다.';

  @override
  String get profile_faqQuestion1 => 'InstaLingo란 무엇인가요?';

  @override
  String get profile_faqQuestion2 => '나중에 업그레이드할 수 있나요?';

  @override
  String get profile_faqQuestion3 => '진행 상황을 어떻게 초기화하나요?';

  @override
  String get profile_faqQuestion4 => '지원팀에 어떻게 연락하나요?';

  @override
  String get profile_feedback => '피드백';

  @override
  String get profile_findFriends => '친구 찾기';

  @override
  String get profile_firstSteps => '첫걸음';

  @override
  String get profile_followingTitle => '팔로잉';

  @override
  String get profile_freePlan => '무료';

  @override
  String get profile_goPremium => '프리미엄으로 업그레이드';

  @override
  String get profile_goalDescription => '주요 학습 목표는 무엇인가요?';

  @override
  String get profile_goalFluency => '유창성';

  @override
  String get profile_goalTravel => '여행';

  @override
  String get profile_goalWork => '업무';

  @override
  String get profile_inTheMorning => '아침에';

  @override
  String get profile_keepPracticing => '계속 연습하세요!';

  @override
  String get profile_lateNight => '늦은 밤 (오후 9시 이후)';

  @override
  String get profile_leaderboardTitle => '리더보드';

  @override
  String get profile_learnBasicPhrases => '기본 표현 배우기';

  @override
  String get profile_levelUp => '레벨 업!';

  @override
  String get profile_monthly => '월간';

  @override
  String get profile_morningBird => '아침형 (오전 5시-9시)';

  @override
  String get profile_mostPopular => '인기';

  @override
  String get profile_motivationCulture => '문화';

  @override
  String get profile_motivationFamily => '가족';

  @override
  String get profile_motivationFun => '재미';

  @override
  String get profile_motivationTravel => '여행';

  @override
  String get profile_motivationWork => '업무';

  @override
  String get profile_myPlan => '내 플랜';

  @override
  String get profile_nextAchievement => '다음 업적';

  @override
  String get profile_noFollowingYet => '아직 팔로우하지 않음';

  @override
  String get profile_noFollowingYetMessage => '학습자를 팔로우하여 최신 소식을 받아보세요!';

  @override
  String get profile_noFriendsYet => '아직 친구가 없습니다';

  @override
  String get profile_noFriendsYetMessage => '다른 학습자와 연결하여 함께 연습하세요!';

  @override
  String get profile_noLeaderboardData => '아직 리더보드 데이터가 없습니다';

  @override
  String get profile_noLeaderboardDataMessage => '학습을 시작하여 순위에 올라보세요!';

  @override
  String get profile_notifications => '알림';

  @override
  String get profile_offlineTitle => '오프라인';

  @override
  String get profile_onboardingComplete => '온보딩 완료';

  @override
  String get profile_onboardingTitle => '온보딩';

  @override
  String get profile_perMonth => '/월';

  @override
  String get profile_plan => '플랜';

  @override
  String get profile_premium => '프리미엄';

  @override
  String get profile_proFeatures => 'Pro 기능';

  @override
  String get profile_proFeaturesDesc => '모든 프리미엄 콘텐츠와 기능 잠금 해제';

  @override
  String get profile_proPlan => 'Pro 플랜';

  @override
  String get profile_proPlanDesc => '프리미엄 기능으로 학습 가속화';

  @override
  String get profile_profile => '프로필';

  @override
  String get profile_progress => '진행 상황';

  @override
  String get profile_progressReset => '진행 상황이 초기화됩니다';

  @override
  String get profile_progressResetMessage =>
      '이 작업은 모든 진행 상황을 삭제합니다. 되돌릴 수 없습니다.';

  @override
  String profile_questionXofY(Object x, Object y) {
    return '질문 $x/$y';
  }

  @override
  String get profile_reminder => '알림';

  @override
  String get profile_reminderTime => '알림 시간';

  @override
  String get profile_removeAds => '광고 제거';

  @override
  String get profile_removeAdsDesc => '방해 없는 학습 경험을 즐기세요';

  @override
  String profile_savePercent(Object percent) {
    return '$percent% 절약';
  }

  @override
  String get profile_section => '섹션';

  @override
  String get profile_seeAll => '모두 보기';

  @override
  String get profile_sendFeedback => '피드백 보내기';

  @override
  String get profile_skillLevel => '실력 수준';

  @override
  String get profile_speakingPractice => '말하기 연습';

  @override
  String get profile_startFreeTrial => '무료 체험 시작';

  @override
  String get profile_studyPlanDescription => '학습 계획을 맞춤 설정하세요.';

  @override
  String get profile_studyPlanTitle => '학습 계획';

  @override
  String get profile_studyReminder => '학습 알림';

  @override
  String get profile_subscribeNow => '지금 구독';

  @override
  String get profile_subtitle => '프로필';

  @override
  String get profile_superDescription => 'Super의 모든 기능 잠금 해제';

  @override
  String get profile_support => '지원';

  @override
  String get profile_travelPhrases => '여행 표현';

  @override
  String get profile_troubleshooting => '문제 해결';

  @override
  String profile_tryFreeForDays(Object days, Object price) {
    return '$days일 무료 체험 후 $price';
  }

  @override
  String get profile_unlimitedAccess => '무제한 접근';

  @override
  String get profile_unlimitedAccessDesc => '모든 언어 코스와 레슨에 접근';

  @override
  String get profile_unlimitedAiConversations => '무제한 AI 대화';

  @override
  String get profile_unlimitedAiConversationsDesc => '언제든지 AI 튜터와 대화 연습';

  @override
  String get profile_unlimitedLessons => '무제한 레슨';

  @override
  String get profile_unlimitedLessonsDesc => '제한 없이 모든 레슨에 접근';

  @override
  String get profile_unlimitedVocabularyBuilder => '무제한 어휘 빌더';

  @override
  String get profile_unlimitedVocabularyBuilderDesc => '적응형 플래시카드로 어휘력 향상';

  @override
  String get profile_weekdays => '평일';

  @override
  String get profile_weekends => '주말';

  @override
  String get profile_whenToStudy => '언제 공부할까요?';

  @override
  String get profile_workCommunication => '업무 소통';

  @override
  String get profile_workVocabulary => '비즈니스 어휘';

  @override
  String get profile_writingPractice => '쓰기 연습';

  @override
  String get profile_xpAndGems => 'XP와 젬';

  @override
  String get profile_xpAndGemsDesc => 'XP 및 보석 설명';

  @override
  String get profile_xpEarnedToday => '오늘 획득한 XP';

  @override
  String get profile_youEarned => '획득했습니다!';

  @override
  String get profile_yourStreak => '나의 연속 기록';

  @override
  String get progressToNextLevel => '다음 레벨까지 진행';

  @override
  String get rateApp => '앱 평가하기';

  @override
  String get recording => '녹음 중...';

  @override
  String get removeAds => '광고 제거';

  @override
  String get saveAndContinue => '저장 후 계속';

  @override
  String get searchPosts => '게시물 검색';

  @override
  String sectionX(Object x) {
    return '섹션 $x';
  }

  @override
  String get seeAllAchievements => '모든 업적 보기';

  @override
  String get shareApp => '앱 공유';

  @override
  String get speakNow => '지금 말하기';

  @override
  String get startSpeaking => '말하기 시작';

  @override
  String get streakTitle => '연속 학습';

  @override
  String get studyNow => '지금 학습';

  @override
  String get subscribeNow => '지금 구독';

  @override
  String get superMarket => '슈퍼마켓';

  @override
  String get swipeToContinue => '스와이프하여 계속';

  @override
  String get tapToListen => '탭하여 듣기';

  @override
  String get tapToSpeak => '탭하여 말하기';

  @override
  String get technicalIssues => '기술 문제';

  @override
  String get totalLessons => '총 레슨';

  @override
  String get unlimited => '무제한';

  @override
  String get unlockAllFeatures => '모든 기능 잠금 해제';

  @override
  String get unlockNow => '지금 잠금 해제';

  @override
  String get upgradeToPro => 'Pro로 업그레이드';

  @override
  String get upgradeToSuper => 'Super로 업그레이드';

  @override
  String get viewAll => '모두 보기';

  @override
  String get viewDetails => '상세 보기';

  @override
  String get viewLeaderboard => '리더보드 보기';

  @override
  String get vocabulary => '어휘';

  @override
  String get weekly => '주간';

  @override
  String get weeklyGoal => '주간 목표';

  @override
  String get welcome => '환영합니다';

  @override
  String get welcomeBack => '돌아오신 것을 환영합니다';

  @override
  String get wordOfTheDay => '오늘의 단어';

  @override
  String get xpEarned => '획득 XP';

  @override
  String get yearly => '연간';

  @override
  String get yes => '예';

  @override
  String get youAreOffline => '오프라인 상태입니다';

  @override
  String get yourAnswer => '내 답변';

  @override
  String get yourProgress => '내 진행 상황';

  @override
  String get onboarding_learningGoalTitle => '목표가 무엇인가요?';

  @override
  String get onboarding_learningGoalSubtitle => '학습 경험을 맞춤화하는 데 도움이 됩니다.';

  @override
  String get onboarding_examPrep => '시험 준비';

  @override
  String get onboarding_examPrepDesc =>
      '체계적인 레슨, 모의고사, 시간 제한 연습. 예상 점수를 추적하세요.';

  @override
  String get onboarding_justForFun => '그냥 재미로';

  @override
  String get onboarding_justForFunDesc =>
      '자신의 속도로 배우세요. 시험도, 부담도 없이 자연스럽게 언어를 익히세요.';

  @override
  String get onboarding_examTypeTitle => '어떤 시험?';

  @override
  String onboarding_examTypeSubtitle(String lang) {
    return '준비 중인 $lang 시험을 선택하세요.';
  }

  @override
  String get onboarding_japanese => '일본어';

  @override
  String get onboarding_korean => '한국어';

  @override
  String get onboarding_examLevelBeginner => '초급';

  @override
  String get onboarding_examLevelElementary => '기초';

  @override
  String get onboarding_examLevelBeginnerElementary => '초급–기초';

  @override
  String onboarding_examWordsCount(String count) {
    return '약 $count단어';
  }

  @override
  String get onboarding_examSectionsJLPT => '어휘, 문법, 읽기, 듣기';

  @override
  String get onboarding_examSectionsTOPIK => '듣기, 읽기';

  @override
  String get keepPracticing => '계속 연습하세요!';

  @override
  String get kanjiReference => '한자 참조';

  @override
  String get kanaReference => '가나 표';

  @override
  String get hiraganaChart => '히라가나';

  @override
  String get katakanaChart => '가타카나';

  @override
  String get examCompleteTitle => '모의고사 완료!';

  @override
  String get yourScore => '점수';

  @override
  String get predictedLevel => '예상 등급';

  @override
  String get profile_tts => '발음 (TTS)';

  @override
  String get profile_ttsDesc => '단어를 탭하여 발음 듣기';

  @override
  String get studyReminderBody => '연습할 시간입니다!';

  @override
  String get jlptN5Label => 'JLPT N5';

  @override
  String get jlptN4Label => 'JLPT N4';

  @override
  String get onboarding_examLevelIntermediate => '중급';

  @override
  String get onboarding_examLevelUpperIntermediate => '중고급';

  @override
  String get onboarding_examLevelAdvanced => '고급';
}
