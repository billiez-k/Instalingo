import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh', 'TW'),
  ];

  String get appTitle;
  String get appTagline;
  String get onboardingDiscoverJapanese;
  String get onboardingSwipeLearn;
  String get onboardingSmartReview;
  String get onboardingTrackProgress;
  String get onboardingGetStarted;
  String get onboardingAlreadyHaveAccount;
  String get onboardingSelectNativeLanguage;
  String get onboardingSelectLearningLanguage;
  String get onboardingJapanese;
  String get onboardingKorean;
  String get onboardingComingSoon;
  String get onboardingJlptLevels;
  String get navHome;
  String get navReview;
  String get navCollections;
  String get navProfile;
  String get swipeLoadingCards;
  String get swipeAllCaughtUp;
  String get swipeSeenAllCards;
  String get swipeBackToHome;
  String get swipeToday;
  String get swipeRemaining;
  String get swipeDayStreak;
  String get swipeSaved;
  String get swipeXp;
  String get reviewTitle;
  String get reviewCardsDue;
  String get reviewAllCaughtUp;
  String get reviewAgain;
  String get reviewHard;
  String get reviewGood;
  String get reviewEasy;
  String get collectionsTitle;
  String get collectionsWordsCount;
  String get collectionsSearchHint;
  String get collectionsFilterAll;
  String get collectionsUpgradePrompt;
  String get collectionsNoSavedWords;
  String get dailyCompleteTitle;
  String get dailyCompleteCardsSwiped;
  String get dailyCompleteXpEarned;
  String get dailyCompleteGemsEarned;
  String get dailyCompleteStreak;
  String get dailyCompleteContinue;
  String get dailyCompleteShare;
  String get chillCorner;
  String get chillNoPosts;
  String get chillNoPostsMessage;
  String get chillAddComment;
  String get chillComments;
  String get cardNotFound;
  String get chinese;
  String get chillEmptyMessage;
  String get collectionsEmptyHint;
  String get collectionsEmptyMessage;
  String get collectionsEmptyTitle;
  String get dailyCompleteCardsLabel;
  String get dailyCompleteGemsLabel;
  String get english;
  String get errorLoadingFeed;
  String get errorLoadingReviews;
  String get gotIt;
  String get reviewCompleteMessage;
  String get reviewCompleteTitle;
  String get reviewEmptyMessage;
  String get reviewEmptyTitle;
  String get swipeLeft;
  String get swipeLeftDescription;
  String get swipeRight;
  String get swipeRightDescription;
  String get swipeUp;
  String get swipeUpDescription;
  String get tapToFlip;
  String get tapToFlipBack;
  String get tapToLearn;
  String get upgradePrompt;
  String lapsesCount(int count);
  String reviewsCount(int count);
  String sourceLabel(String source);
  String get profile;
  String get profileStats;
  String get profileAchievements;
  String get profileSettings;
  String get profileEdit;
  String get profileHelp;
  String get profileStreak;
  String get profileXp;
  String get profileGems;
  String get profileWordsSaved;
  String get profilePro;
  String get settingsTitle;
  String get settingsAppearance;
  String get settingsDarkMode;
  String get settingsSoundEffects;
  String get settingsNotifications;
  String get settingsReminderTime;
  String get settingsLearning;
  String get settingsDailyGoal;
  String get settingsNativeLanguage;
  String get settingsLearningLanguage;
  String get settingsAccount;
  String get settingsCheckUpdates;
  String get settingsResetProgress;
  String get settingsLogout;
  String get settingsVersion;
  String get achievementsTitle;
  String get achievementsUnlocked;
  String get achievementsInProgress;
  String get paywallUnlockFull;
  String get paywallUnlimitedSaves;
  String get paywallFullSrsAccess;
  String get paywallDetailedStats;
  String get paywallNoAds;
  String get paywallAnnual;
  String get paywallMonthly;
  String get paywallContinue;
  String get paywallMaybeLater;
  String get paywallPerMonth;
  String get paywallBestValue;
  String get statsTitle;
  String get statsWeekXp;
  String get statsStreak;
  String get statsTotalXp;
  String get statsCardsSwiped;
  String get statsWordsSaved;
  String get back;
  String get cancel;
  String get check;
  String get save;
  String get delete;
  String get confirm;
  String get loading;
  String get error;
  String get retry;
  String get yes;
  String get no;
  String get active;
  String get locked;
  String get free;
  String get pro;
  String get version;
  String get studyReminderBody;
  String get youAreOffline;
  String get keepPracticing;
  String get yourProgress;
  String get yourAnswer;
  String get yourScore;
  String get predictedLevel;
  String get profile_tts;
  String get profile_ttsDesc;
  String get jlptN5Label;
  String get jlptN4Label;
  String get jlptN3Label;
  String get onboarding_examLevelBeginner;
  String get onboarding_examLevelIntermediate;
  String get onboarding_examLevelAdvanced;
  String get onboarding_examWordsCount;
  String get advancedProgressTracking;
  String get aiConversationPractice;
  String get annual;
  String get coursePath;
  String get dailyGoal;
  String get darkMode;
  String get dayStreak;
  String get defaultDisplayName;
  String get editProfile;
  String get emptyStateMessage;
  String get emptyStateTitle;
  String get errorGenericMessage;
  String get errorGenericTitle;
  String get fri;
  String get gems;
  String get getUnlimitedLearning;
  String get helpSupport;
  String get learningLanguage;
  String get lessons;
  String get levelAbbreviation;
  String get logout;
  String get maybeLater;
  String get mon;
  String get monthly;
  String get nativeLanguage;
  String get noAds;
  String get notifications;
  String get paywallTitle;
  String get perMonth;
  String get perYear;
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
  String get profile_upperIntermediate;
  String get profile_visitHelpCenter;
  String get profile_whatIsChillCorner;
  String get profile_whatIsChillCornerAnswer;
  String get sat;
  String get startFreeTrial;
  String get streakCalendar;
  String get streakRepair;
  String get streakRepaired;
  String get streakShielded;
  String get studyPlan;
  String get subscription;
  String get sun;
  String get thu;
  String get timeSpent;
  String get today;
  String get totalXP;
  String get tryAgain;
  String get tue;
  String get unlimitedLessons;
  String get unlockSuper;
  String get wed;
  String get wordsLearned;
  String get xpThisWeek;
  String dayStreakCount(int count);
  String profile_learningStatus(String level, int wordsLearned);
  String profile_minPerDay(int minutes);
  String profile_minutesCount(int count);
  String profile_version(String version);
  String savePercent(int percent);
  String streakKeepStreak(int days);
  String streakShieldsRemaining(int count);
  String timeSpentHoursMinutes(int hours, int minutes);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  if (locale.languageCode == 'zh') {
    return AppLocalizationsZh();
  }
  return AppLocalizationsEn();
}
