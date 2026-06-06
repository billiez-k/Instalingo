import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart' show SynchronousFuture;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_ar.dart';
import 'app_localizations_zh_cn.dart';
import 'app_localizations_zh_tw.dart';

abstract class AppLocalizations {

  String get achievementsInProgress;

  String get achievementsTitle;

  String get achievementsUnlocked;

  String get active;

  String get advancedProgressTracking;

  String get aiConversationPractice;

  String get annual;

  String get appTagline;

  String get appTitle;

  String get back;

  String get cancel;

  String get cardNotFound;

  String get check;

  String get chillAddComment;

  String get chillComments;

  String get chillCorner;

  String get chillCornerEyebrow;

  String get chillEmptyMessage;

  String get chillNoPosts;

  String get chillNoPostsMessage;

  String get chinese;

  String get collectionsEmptyHint;

  String get collectionsEmptyMessage;

  String get collectionsEmptyTitle;

  String get collectionsFilterAll;

  String get collectionsNoSavedWords;

  String get collectionsPosTopicFormat;

  String get collectionsSearchHint;

  String get collectionsTitle;

  String get collectionsUnlimited;

  String get collectionsUpgradePrompt;

  String get collectionsWordsCount;

  String get commentHintText;

  String get commentSectionTitle;

  String get confirm;

  String get coursePath;

  String get dailyCompleteCardsLabel;
  String get dailyCompleteSavedLabel;

  String get dailyCompleteCardsSwiped;

  String get dailyCompleteContinue;

  String get dailyCompleteGemsEarned;

  String get dailyCompleteGemsLabel;

  String get dailyCompleteShare;

  String get dailyCompleteStreak;

  String get dailyCompleteTitle;

  String get dailyCompleteXpEarned;

  String get dailyGoal;

  String get darkMode;

  String get dayStreak;

  String get defaultDisplayName;

  String get delete;

  String get editProfile;

  String get emptyStateMessage;

  String get emptyStateTitle;

  String get english;

  String get swipeSaveLabel;
  String get swipeSavedLabel;
  String get swipeAlreadyKnew;
  String get swipeFlipLabel;
  String get swipeShareLabel;
  String get swipeSkipped;
  String get error;

  String get errorGenericMessage;

  String get errorGenericTitle;

  String get errorLoadingFeed;

  String get errorLoadingReviews;

  String get exampleSectionLabel;

  String get featuredWord;

  String get free;

  String get fri;

  String get gems;

  String get getUnlimitedLearning;

  String get gotIt;

  String get helpSupport;

  String get jlptN3Label;

  String get jlptN4Label;

  String get jlptN5Label;

  String get keepPracticing;

  String get langNameDe;

  String get langNameEn;

  String get langNameEs;

  String get langNameFr;

  String get langNameJa;

  String get langNameKo;

  String get langNameMs;
  String get langNameAr;

  String get langNameZhCn;

  String get langNameZhTw;

  String get learningLanguage;

  String get learningLanguageLabel;

  String get lessons;

  String get levelAbbreviation;

  String get loading;

  String get locked;

  String get logout;

  String get maybeLater;

  String get mon;

  String get monthly;

  String get nativeLanguage;

  String get navCollections;

  String get navHome;

  String get navProfile;

  String get navReview;

  String get no;

  String get noAds;

  String get notificationReminderBody;

  String get notifications;

  String get onboardingAlreadyHaveAccount;

  String get onboardingComingSoon;

  String get onboardingDiscoverJapanese;

  String get onboardingGetStarted;

  String get onboardingJapanese;

  String get onboardingJlptLevels;

  String get onboardingKorean;

  String get onboardingSelectLearningLanguage;

  String get onboardingSelectNativeLanguage;

  String get onboardingStartLevel;

  String get onboardingSmartReview;

  String get onboardingSmartReviewDesc;

  String get onboardingSwipeLearn;

  String get onboardingSwipeLearnDesc;

  String get onboardingTrackProgress;

  String get onboardingTrackProgressDesc;

  String get onboarding_examLevelAdvanced;

  String get onboarding_examLevelBeginner;

  String get onboarding_examLevelIntermediate;

  String get onboarding_examWordsCount;

  String get paywallAnnual;

  String get paywallBestValue;

  String get paywallContinue;

  String get paywallDetailedStats;

  String get paywallFullSrsAccess;

  String get paywallMaybeLater;

  String get paywallMonthly;

  String get paywallNoAds;

  String get paywallPerMonth;

  String get paywallTitle;

  String get paywallUnlimitedSaves;

  String get paywallUnlockFull;

  String get perMonth;

  String get perYear;

  String get postNotFound;

  String get predictedLevel;

  String get pro;

  String get profile;

  String get profileAchievements;

  String get profileEdit;

  String get profileGems;

  String get profileHelp;

  String get profileLearner;

  String get profilePro;

  String get profileSettings;

  String get profileStats;

  String get profileStreak;

  String get profileWordsSaved;

  String get profileXp;

  String get profile_account;

  String get profile_advanced;

  String get profile_aiConversationPractice;

  String get profile_aiConversationPracticeAnswer;

  String get profile_appearance;

  String get profile_beginner;

  String get profile_browseTopics;

  String get profile_checkForUpdates;

  String get profile_contactSupport;

  String get profile_displayName;

  String get profile_earningXPGems;

  String get profile_earningXPGemsAnswer;

  String get profile_elementary;

  String get profile_email;

  String get profile_enableNotifications;

  String get profile_enableNotificationsAnswer;

  String get profile_enterYourEmail;

  String get profile_enterYourName;

  String get profile_gettingStarted;

  String get profile_gotIt;

  String get profile_howDoIStart;

  String get profile_howDoIStartAnswer;

  String get profile_instalingoSuperFAQ;

  String get profile_instalingoSuperFAQAnswer;

  String get profile_intermediate;

  String get profile_learning;

  String get profile_learningFeatures;

  String get profile_lessonRemindersStreakAlerts;

  String get profile_level;

  String get profile_levelSuffix;

  String get profile_notSet;

  String get profile_proBadge;

  String get profile_proficiencyLevel;

  String get profile_proficient;

  String get profile_resetProgress;

  String get profile_resetProgressFAQ;

  String get profile_resetProgressFAQAnswer;

  String get profile_settingDailyGoals;

  String get profile_settingDailyGoalsAnswer;

  String get profile_soundEffects;

  String get profile_superBadge;

  String get profile_tts;

  String get profile_ttsDesc;

  String get profile_upperIntermediate;

  String get profile_visitHelpCenter;

  String get profile_whatIsChillCorner;

  String get profile_whatIsChillCornerAnswer;

  String get retry;

  String get reviewAgain;

  String get reviewAllCaughtUp;

  String get reviewCardsDue;

  String get reviewCompleteMessage;

  String get reviewCompleteTitle;

  String get reviewEasy;

  String get reviewEmptyMessage;

  String get reviewEmptyTitle;

  String get reviewGood;

  String get reviewHard;

  String get reviewTitle;

  String get sat;

  String get save;

  String get settingsAccount;

  String get settingsAppearance;

  String get settingsCheckUpdates;

  String get settingsDailyGoal;

  String get settingsDarkMode;

  String get settingsLearning;

  String get settingsLearningLanguage;

  String get settingsLogout;

  String get settingsNativeLanguage;

  String get settingsNotifications;

  String get settingsReminderTime;

  String get settingsResetProgress;

  String get settingsSoundEffects;

  String get settingsTitle;

  String get settingsVersion;

  String get shareLabel;
  String get notificationPracticeReminder;

  String get shareAppSubject;

  String get shareAppText;

  String get shareCardSubject;

  String get shareCardText;

  String get shareWordPrefix;

  String get startFreeTrial;

  String get statsCardsSwiped;

  String get statsStreak;

  String get statsTitle;

  String get statsTotalXp;

  String get statsWeekXp;

  String get statsWordsSaved;

  String get streakCalendar;

  String get streakRepair;

  String get streakRepaired;

  String get streakShielded;

  String get studyPlan;

  String get studyReminderBody;

  String get subscription;

  String get sun;

  String get swipeAllCaughtUp;

  String get swipeBackToHome;

  String get swipeDayStreak;

  String get swipeLeft;

  String get swipeLeftDescription;

  String get swipeLoadingCards;

  String get swipeRemaining;

  String get swipeRight;

  String get swipeRightDescription;

  String get swipeSaved;

  String get swipeSeenAllCards;

  String get swipeToday;

  String get swipeUp;

  String get swipeUpDescription;

  String get swipeXp;

  String get tapToFlip;

  String get tapToFlipBack;

  String get tapToLearn;

  String get tapToStudyWord;

  String get thu;

  String get timeSpent;

  String get today;

  String get totalXP;

  String get tryAgain;

  String get tue;

  String get unlimitedLessons;

  String get unlockSuper;

  String get upgradePrompt;

  String get version;

  String get viaInstalingo;

  String get wed;

  String get wordsLearned;

  String get xpThisWeek;

  String get yes;

  String get youAreOffline;

  String get yourAnswer;

  String get yourProgress;

  String get yourScore;

  String dayStreakCount(int count);

  String lapsesCount(int count);

  String profile_learningStatus(String level, String wordsLearned);

  String profile_minPerDay(int min);

  String profile_minutesCount(int minutes);

  String profile_version(String version);

  String reviewsCount(int count);

  String savePercent(int percent);

  String sourceLabel(String source);

  String streakKeepStreak(int days);

  String streakShieldsRemaining(int remaining);

  String timeSpentHoursMinutes(int hours, int minutes);

  static final _localizedDelegate = {
    const Locale('ar'): () => AppLocalizationsAr(),
    const Locale('en'): () => AppLocalizationsEn(),
    const Locale('ja'): () => AppLocalizationsJa(),
    const Locale('ko'): () => AppLocalizationsKo(),
    const Locale('ms'): () => AppLocalizationsMs(),
    const Locale('zh', 'CN'): () => AppLocalizationsZhCn(),
    const Locale('zh', 'TW'): () => AppLocalizationsZhTw(),
  };

  // ignore: avoid-dynamic
  static final LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('ar'),
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('ms'),
    Locale('zh', 'CN'),
    Locale('zh', 'TW'),
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.contains(locale);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    final factory = AppLocalizations._localizedDelegate[locale] ??
        AppLocalizations._localizedDelegate[Locale(locale.languageCode)] ??
        (() => AppLocalizationsEn());
    return SynchronousFuture<AppLocalizations>(factory());
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}