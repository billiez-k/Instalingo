// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String get active => 'Active';

  @override
  String get advancedProgressTracking => 'Advanced progress tracking';

  @override
  String get aiAssistantName => 'Maya';

  @override
  String get aiAssistantRole => 'Cafe Worker';

  @override
  String get aiBadge => 'AI';

  @override
  String get aiChat => 'AI Chat';

  @override
  String get aiConversationGreeting =>
      'Hi! I\'m Maya. I work at a cafe in Tokyo. What would you like to practice today?';

  @override
  String get aiConversationPractice => 'AI conversation practice';

  @override
  String get aiConversationTitle => 'AI Conversation';

  @override
  String get aiPractice => 'AI Practice';

  @override
  String get aiYou => 'You';

  @override
  String get annual => 'Annual';

  @override
  String get appTagline => 'Learn. Chill. Repeat.';

  @override
  String get appTitle => 'InstaLingo';

  @override
  String get back => 'Back';

  @override
  String get cancel => 'Cancel';

  @override
  String get chapter => 'Chapter';

  @override
  String get chatWithAI => 'Chat with an AI character';

  @override
  String get check => 'Check';

  @override
  String get chill => 'Chill';

  @override
  String get chillCorner => 'Chill Corner';

  @override
  String get chill_addComment => 'Add a comment...';

  @override
  String get chill_aiGeneratedImage => 'AI Generated Image';

  @override
  String get chill_comments => 'Comments';

  @override
  String get chill_noPosts => 'No posts yet';

  @override
  String get chill_noPostsMessage =>
      'Complete lessons to unlock vocabulary posts from the community.';

  @override
  String get chill_postNotFound => 'Post not found';

  @override
  String get chill_postNotFoundMessage =>
      'This post may have been deleted or is no longer available.';

  @override
  String get chill_share => 'Share';

  @override
  String get clear => 'Clear';

  @override
  String get clearAll => 'Clear all';

  @override
  String get commitment => 'Commitment';

  @override
  String get continueLearning => 'Continue Learning';

  @override
  String get continueText => 'Continue';

  @override
  String get correct => 'Correct';

  @override
  String correctCountOfTotal(int correct, int total) {
    return '$correct / $total correct';
  }

  @override
  String correctWithExplanation(String explanation) {
    return 'Correct! $explanation';
  }

  @override
  String get courseComplete => 'Course Completed!';

  @override
  String get courseCompleteTitle => 'You did it!';

  @override
  String get coursePath => 'Course Path';

  @override
  String get createProfile => 'Create your profile';

  @override
  String get createProfileDesc => 'This helps us personalize your experience.';

  @override
  String get dailyGoal => 'Daily Goal';

  @override
  String get dailyGoalCardTitle => 'Daily Goal';

  @override
  String get dailyGoalReached => 'Goal reached! Great job!';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get dayStreak => 'Day Streak';

  @override
  String dayStreakCount(int count) {
    return '$count days';
  }

  @override
  String get defaultDisplayName => 'Learner';

  @override
  String get done => 'Done';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get emptyStateMessage => 'Come back later for more content.';

  @override
  String get emptyStateTitle => 'Nothing here yet';

  @override
  String get errorGenericMessage =>
      'We could not load this content. Please try again.';

  @override
  String get errorGenericTitle => 'Something went wrong';

  @override
  String get exArrangeWords => 'Arrange the words to form a correct sentence';

  @override
  String get exComprehension => 'Read the passage and answer';

  @override
  String get exDialogueComplete => 'Complete the dialogue';

  @override
  String get exFillInBlank => 'Fill in the blank';

  @override
  String get exFlashCard => 'Tap to flip the card';

  @override
  String get exGrammarTip => 'Grammar Tip';

  @override
  String get exImageIdentify => 'Tap the correct image';

  @override
  String get exMatchWords => 'Match the words with their meanings';

  @override
  String get exPhraseBuilder => 'Build the phrase';

  @override
  String get exSpeaking => 'Say this word aloud';

  @override
  String get exTranslate => 'Translate this sentence';

  @override
  String get exTrueFalse => 'Is this statement correct?';

  @override
  String get exTypeWhatYouHear => 'Type what you hear';

  @override
  String exVocabMultipleChoice(Object word) {
    return 'Which word means \"$word\"?';
  }

  @override
  String exWhichWordMeans(Object word) {
    return 'Which means \"$word\"?';
  }

  @override
  String get exWriting => 'Write your answer';

  @override
  String get exampleLabel => 'Example';

  @override
  String exercisesProgress(int completed, int total) {
    return '$completed of $total exercises';
  }

  @override
  String get falseLabel => 'False';

  @override
  String get featureAICharacters => 'AI Characters';

  @override
  String get featureAICharactersDesc =>
      'Practice with AI personas that respond like real people in the Chill Corner.';

  @override
  String get featureMotivation => 'Stay Motivated';

  @override
  String get featureMotivationDesc =>
      'Earn XP, maintain streaks, and unlock achievements as you progress.';

  @override
  String get featureStructuredCourses => 'Structured Courses';

  @override
  String get featureStructuredCoursesDesc =>
      'Learn with professionally designed lessons that build on each other.';

  @override
  String get findFriends => 'Find Friends';

  @override
  String get finishLesson => 'Finish Lesson';

  @override
  String get flashcardEasy => 'Easy';

  @override
  String get flashcardGood => 'Good';

  @override
  String get flashcardHard => 'Hard';

  @override
  String get followingTitle => 'Following';

  @override
  String get forceUpdateBody =>
      'We\'ve made InstaLingo faster, more stable, and packed with new features. Please update to the latest version to continue.';

  @override
  String get forceUpdateBugFixes => 'Bug fixes & stability';

  @override
  String get forceUpdateMessage =>
      'A new version of InstaLingo is available. Please update to continue learning.';

  @override
  String get forceUpdateNewContent => 'New lessons & exercises';

  @override
  String get forceUpdatePerformance => 'Performance improvements';

  @override
  String get forceUpdateTitle => 'Update Required';

  @override
  String get fri => 'F';

  @override
  String get friendsTitle => 'Friends';

  @override
  String get gems => 'Gems';

  @override
  String get getStarted => 'Get Started';

  @override
  String get getUnlimitedLearning => 'Get unlimited learning';

  @override
  String get goodbye => 'Goodbye';

  @override
  String get gotIt => 'Got it!';

  @override
  String get grammarExampleFallback => 'Practice makes perfect!';

  @override
  String get grammarRuleFallback =>
      'Pay attention to the grammar in this exercise.';

  @override
  String get grammarTip => 'Grammar Tip';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get hello => 'Hello!';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get holdToSpeak => 'Hold to speak';

  @override
  String get howAreYou => 'How Are You?';

  @override
  String get iAlreadyHaveAccount => 'I Already Have an Account';

  @override
  String get incorrect => 'Incorrect';

  @override
  String get knowIt => 'Know It';

  @override
  String get language => 'Language';

  @override
  String get leaderboardTitle => 'Leaderboard';

  @override
  String get learn => 'Learn';

  @override
  String get learnRuleToImprove => 'Learn this rule to improve';

  @override
  String get learningLanguage => 'Learning Language';

  @override
  String get lessonComplete => 'Lesson Complete!';

  @override
  String get lessonCompleteGood => 'Good effort! Review and try again!';

  @override
  String get lessonCompleteGreat => 'Great job! Keep practicing!';

  @override
  String get lessonCompletePerfect => 'Perfect! You are on fire!';

  @override
  String get lessons => 'Lessons';

  @override
  String get levelAbbreviation => 'LV';

  @override
  String get levelAdvanced => 'Advanced';

  @override
  String get levelBeginner => 'Beginner';

  @override
  String get levelElementary => 'Elementary';

  @override
  String get levelIntermediate => 'Intermediate';

  @override
  String get levelProficiency => 'Proficiency';

  @override
  String get levelUpperIntermediate => 'Upper Intermediate';

  @override
  String get loading => 'Loading...';

  @override
  String get loadingLesson => 'Loading lesson...';

  @override
  String get logout => 'Log Out';

  @override
  String get matchPairsInstruction =>
      'Tap a word on the left, then its match on the right';

  @override
  String get maybeLater => 'Maybe Later';

  @override
  String get mon => 'M';

  @override
  String get monthly => 'Monthly';

  @override
  String get motivation => 'Motivation';

  @override
  String get myNameIs => 'My Name Is';

  @override
  String get nativeLanguage => 'Native Language';

  @override
  String get next => 'Next';

  @override
  String get nextQuestion => 'Next Question';

  @override
  String get niceToMeetYou => 'Nice to Meet You';

  @override
  String get noAds => 'No ads';

  @override
  String get noConnectionMessage => 'Please check your internet and try again.';

  @override
  String get noConnectionTitle => 'No Connection';

  @override
  String get notNow => 'Not now';

  @override
  String notQuiteWithExplanation(String explanation) {
    return 'Not quite. $explanation';
  }

  @override
  String get notifications => 'Notifications';

  @override
  String get onboardingTitle =>
      'Learn languages through structured courses & AI personas';

  @override
  String get onboarding_commitmentCasual => 'Casual';

  @override
  String get onboarding_commitmentIntense => 'Intense';

  @override
  String get onboarding_commitmentRegular => 'Regular';

  @override
  String get onboarding_commitmentSerious => 'Serious';

  @override
  String get onboarding_commitmentSubtitle =>
      'You can always change this later in settings.';

  @override
  String get onboarding_commitmentTitle => 'How much time\ncan you commit?';

  @override
  String get onboarding_displayNameLabel => 'Display Name';

  @override
  String get onboarding_emailOptionalLabel => 'Email (optional)';

  @override
  String get onboarding_enterEmailHint => 'Enter your email';

  @override
  String get onboarding_enterNameHint => 'Enter your name';

  @override
  String get onboarding_learningLangSubtitle =>
      'Choose the language you want to master.';

  @override
  String get onboarding_motivationBrainTraining => 'Brain Training';

  @override
  String get onboarding_motivationCareer => 'Career';

  @override
  String get onboarding_motivationCulture => 'Culture';

  @override
  String get onboarding_motivationFamily => 'Family';

  @override
  String get onboarding_motivationFun => 'Just for Fun';

  @override
  String get onboarding_motivationMoviesShows => 'Movies & Shows';

  @override
  String get onboarding_motivationStudyAbroad => 'Study Abroad';

  @override
  String get onboarding_motivationSubtitle => 'Select all that apply.';

  @override
  String get onboarding_motivationTitle => 'Why are you learning?';

  @override
  String get onboarding_motivationTravel => 'Travel';

  @override
  String get onboarding_nativeLangSubtitle =>
      'We\'ll use this to personalize your learning experience.';

  @override
  String get onboarding_proficiencyAdvanced => 'Advanced';

  @override
  String get onboarding_proficiencyAdvancedDesc => 'I speak fluently';

  @override
  String get onboarding_proficiencyBeginner => 'Beginner';

  @override
  String get onboarding_proficiencyBeginnerDesc => 'I know a few words';

  @override
  String get onboarding_proficiencyElementary => 'Elementary';

  @override
  String get onboarding_proficiencyElementaryDesc =>
      'I can form simple sentences';

  @override
  String get onboarding_proficiencyIntermediate => 'Intermediate';

  @override
  String get onboarding_proficiencyIntermediateDesc =>
      'I can hold a conversation';

  @override
  String get onboarding_proficiencyProficient => 'Proficient';

  @override
  String get onboarding_proficiencyProficientDesc => 'I speak like a native';

  @override
  String get onboarding_proficiencySubtitle =>
      'We\'ll start you at the right difficulty.';

  @override
  String get onboarding_proficiencyTitle => 'What is your\ncurrent level?';

  @override
  String get onboarding_proficiencyUpperIntermediate => 'Upper-Intermediate';

  @override
  String get onboarding_proficiencyUpperIntermediateDesc =>
      'I can discuss various topics';

  @override
  String get onboarding_skipForNow => 'Skip for now';

  @override
  String get paywallSubtitle => 'Unlock unlimited learning';

  @override
  String get paywallTitle => 'InstaLingo Super';

  @override
  String get perMonth => '/month';

  @override
  String get perYear => '/year';

  @override
  String get pickNewCourse => 'Pick a New Course';

  @override
  String get playing => 'Playing...';

  @override
  String get practiceWords => 'Practice the words you just learned';

  @override
  String get privacy => 'Privacy';

  @override
  String get proficiency => 'Proficiency';

  @override
  String get profile => 'Profile';

  @override
  String get profile_academicEnglish => 'Academic English';

  @override
  String get profile_account => 'Account';

  @override
  String get profile_achievementsUnlocked => 'Achievements Unlocked';

  @override
  String get profile_adFreeExperience => 'Ad-Free Experience';

  @override
  String get profile_adFreeExperienceDesc =>
      'Focus on learning with zero interruptions.';

  @override
  String get profile_advanced => 'Advanced';

  @override
  String get profile_advancedSpeakingDesc =>
      'Get detailed pronunciation and fluency analysis with waveform visualization.';

  @override
  String get profile_advancedSpeakingFeedback => 'Advanced speaking feedback';

  @override
  String get profile_aiConversationPractice => 'AI Conversation Practice';

  @override
  String get profile_aiConversationPracticeAnswer =>
      'Practice real conversations with AI personas in different scenarios like cafes, airports, and offices.';

  @override
  String get profile_allChillCornerContent => 'All Chill Corner content';

  @override
  String get profile_appearance => 'Appearance';

  @override
  String get profile_beginner => 'Beginner';

  @override
  String get profile_bestValue => 'Best Value';

  @override
  String get profile_browseTopics =>
      'Browse topics below or contact us directly';

  @override
  String get profile_businessEnglish => 'Business English';

  @override
  String get profile_cancelAnytime => 'Cancel anytime. No commitment.';

  @override
  String get profile_checkForUpdates => 'Check for Updates';

  @override
  String get profile_completeBeginner => 'Complete beginner';

  @override
  String get profile_contactSupport => 'Contact Support';

  @override
  String get profile_createPlan => 'Create Plan';

  @override
  String get profile_dailyConversation => 'Daily conversation';

  @override
  String get profile_daytime => 'Daytime (9 AM-5 PM)';

  @override
  String get profile_displayName => 'Display Name';

  @override
  String get profile_duration => 'Duration';

  @override
  String get profile_durationDesc => 'How long per session?';

  @override
  String get profile_earningXPGems => 'Earning XP and Gems';

  @override
  String get profile_earningXPGemsAnswer =>
      'Complete lessons, maintain streaks, and review vocabulary to earn rewards and unlock achievements.';

  @override
  String get profile_elementary => 'Elementary';

  @override
  String get profile_email => 'Email';

  @override
  String get profile_enableNotifications => 'Enable notifications';

  @override
  String get profile_enableNotificationsAnswer =>
      'Turn on reminders in Settings to get daily prompts and maintain your streak.';

  @override
  String get profile_enterYourEmail => 'Enter your email';

  @override
  String get profile_enterYourName => 'Enter your name';

  @override
  String get profile_evening => 'Evening (5-9 PM)';

  @override
  String get profile_everyDay => 'Every day';

  @override
  String get profile_everythingInMonthly => 'Everything in Monthly';

  @override
  String get profile_examPreparation => 'Exam preparation';

  @override
  String get profile_exclusiveStudyPlans => 'Exclusive study plans';

  @override
  String get profile_fifteenMinutes => '15 minutes';

  @override
  String get profile_fiveDaysAWeek => '5 days a week';

  @override
  String get profile_fiveMinutes => '5 minutes';

  @override
  String get profile_follow => 'Follow';

  @override
  String get profile_followOthersMessage =>
      'Follow other learners to see them here.';

  @override
  String get profile_gettingStarted => 'Getting Started';

  @override
  String get profile_goal => 'Goal';

  @override
  String get profile_goalDesc => 'What do you want to achieve?';

  @override
  String get profile_gotIt => 'Got it';

  @override
  String get profile_howDoIStart => 'How do I start learning?';

  @override
  String get profile_howDoIStartAnswer =>
      'Choose your native language, then pick a language to learn. Complete the onboarding and start with the first lesson.';

  @override
  String get profile_inProgress => 'In Progress';

  @override
  String get profile_instalingoSuperFAQ => 'InstaLingo Super';

  @override
  String get profile_instalingoSuperFAQAnswer =>
      'Upgrade to Super for unlimited lessons, AI practice, advanced tracking, and an ad-free experience.';

  @override
  String get profile_intensity => 'Intensity';

  @override
  String get profile_intensityDesc => 'How often per week?';

  @override
  String get profile_intermediate => 'Intermediate';

  @override
  String get profile_learning => 'Learning';

  @override
  String get profile_learningFeatures => 'Learning Features';

  @override
  String profile_learningStatus(String language, String level) {
    return 'Learning $language · $level';
  }

  @override
  String get profile_lessonRemindersStreakAlerts =>
      'Lesson reminders, streak alerts';

  @override
  String profile_lessonsCompleted(int completed, int total) {
    return '$completed of $total lessons completed';
  }

  @override
  String get profile_level => 'Level';

  @override
  String get profile_levelDesc => 'Where are you starting?';

  @override
  String get profile_levelSuffix => 'Level';

  @override
  String profile_minPerDay(int min) {
    return '$min min / day';
  }

  @override
  String profile_minutesCount(int count) {
    return '$count minutes';
  }

  @override
  String get profile_morning => 'Morning (6-9 AM)';

  @override
  String get profile_night => 'Night (9 PM-12 AM)';

  @override
  String get profile_noAchievementsMessage =>
      'Complete lessons and maintain streaks to unlock achievements.';

  @override
  String get profile_noAchievementsYet => 'No achievements yet';

  @override
  String get profile_notSet => 'Not set';

  @override
  String get profile_offlineMode => 'Offline mode';

  @override
  String get profile_offlineModeDesc =>
      'Download lessons and learn anywhere without internet.';

  @override
  String get profile_perMonthDesc => 'per month';

  @override
  String get profile_perYearDesc => 'per year';

  @override
  String get profile_personalizedStudyPlans => 'Personalized Study Plans';

  @override
  String get profile_personalizedStudyPlansDesc =>
      'AI-generated study plans tailored to your goals and schedule.';

  @override
  String get profile_priorityAIResponses => 'Priority AI responses';

  @override
  String get profile_proBadge => 'PRO';

  @override
  String get profile_proficiencyLevel => 'Proficiency Level';

  @override
  String get profile_proficient => 'Proficient';

  @override
  String get profile_resetProgress => 'Reset Progress';

  @override
  String get profile_resetProgressFAQ => 'Reset Progress';

  @override
  String get profile_resetProgressFAQAnswer =>
      'Go to Settings > Reset Progress to start over. This action cannot be undone.';

  @override
  String get profile_saveFiftyVsMonthly => 'Save 50% vs monthly';

  @override
  String get profile_schedule => 'Schedule';

  @override
  String get profile_scheduleDesc => 'When can you study?';

  @override
  String get profile_settingDailyGoals => 'Setting daily goals';

  @override
  String get profile_settingDailyGoalsAnswer =>
      'Go to Profile > Settings > Daily Goal to adjust your learning target. We recommend 15-30 minutes per day.';

  @override
  String get profile_someBasics => 'Some basics';

  @override
  String get profile_soundEffects => 'Sound Effects';

  @override
  String profile_stepXofY(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String profile_streakLabel(int count) {
    return '$count streak';
  }

  @override
  String get profile_studyPlanCreated => 'Study plan created successfully!';

  @override
  String get profile_superBadge => 'SUPER';

  @override
  String get profile_superSubtitle =>
      'The ultimate language learning experience with AI-powered features.';

  @override
  String get profile_superTitle => 'Super';

  @override
  String get profile_tenMinutes => '10 minutes';

  @override
  String get profile_threeDaysAWeek => '3 days a week';

  @override
  String get profile_travelBasics => 'Travel basics';

  @override
  String get profile_twentyPlusMinutes => '20+ minutes';

  @override
  String get profile_unlimitedAIConversations => 'Unlimited AI conversations';

  @override
  String get profile_unlimitedAIDesc =>
      'Practice with AI personas without limits in the Chill Corner.';

  @override
  String get profile_unlockFullExperience =>
      'Unlock the full language learning experience.';

  @override
  String get profile_unlocked => 'Unlocked';

  @override
  String get profile_upgradeToSuper => 'Upgrade to Super';

  @override
  String get profile_upperIntermediate => 'Upper-Intermediate';

  @override
  String profile_version(String version) {
    return 'InstaLingo v$version';
  }

  @override
  String get profile_visitHelpCenter => 'Visit Help Center';

  @override
  String get profile_weekendsOnly => 'Weekends only';

  @override
  String get profile_whatIsChillCorner => 'What is Chill Corner?';

  @override
  String get profile_whatIsChillCornerAnswer =>
      'Chill Corner shows vocabulary you\'ve learned in real-world contexts, shared by AI characters.';

  @override
  String questionXofY(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get readyToLearn => 'Ready to learn today?';

  @override
  String get reminderTime => '9:00 AM';

  @override
  String get review => 'Review';

  @override
  String get reviewVocabulary => 'Review Vocabulary';

  @override
  String get sampleAnswer => 'Sample answer:';

  @override
  String get sat => 'S';

  @override
  String get save => 'Save';

  @override
  String savePercent(int percent) {
    return 'Save $percent%';
  }

  @override
  String get scenarioCafeTokyo => 'Scenario: Ordering at a cafe in Tokyo';

  @override
  String get section => 'Section';

  @override
  String get sections => 'Sections';

  @override
  String get seeResults => 'See Results';

  @override
  String get seeWordsInContext => 'See your learned words in context';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get skip => 'Skip';

  @override
  String speakersCount(String speakers) {
    return '$speakers speakers';
  }

  @override
  String get start => 'Start';

  @override
  String get startFreeTrial => 'Start Free Trial';

  @override
  String get startLearning => 'Start Learning';

  @override
  String get startNextLesson => 'Start the next lesson in your course';

  @override
  String get statsTitle => 'Statistics';

  @override
  String get stillLearning => 'Still Learning';

  @override
  String get streakCalendar => 'Streak Calendar';

  @override
  String streakKeepStreak(int currentStreak) {
    return 'Complete a lesson to keep your $currentStreak day streak!';
  }

  @override
  String get streakRepair => 'Repair Streak';

  @override
  String get streakRepaired => 'Repaired';

  @override
  String get streakShielded => 'Shielded';

  @override
  String streakShieldsRemaining(int count) {
    return '$count streak shields remaining';
  }

  @override
  String get studyPlan => 'Study Plan';

  @override
  String get submit => 'Submit';

  @override
  String get subscription => 'Subscription';

  @override
  String get sun => 'S';

  @override
  String get takePlacementTest => 'Take Placement Test';

  @override
  String get tapAndHoldMicrophone => 'Tap and hold the microphone to speak';

  @override
  String get tapToFlip => 'Tap to flip';

  @override
  String get tapToFlipBack => 'Tap to flip back';

  @override
  String get tapToPlay => 'Tap to play';

  @override
  String get tapToReveal => 'Tap to reveal';

  @override
  String get tapWordsToBuildAnswer => 'Tap words to build your answer';

  @override
  String get tapWordsToBuildSentence => 'Tap words to build the sentence';

  @override
  String get thu => 'T';

  @override
  String timeAgoHours(int hours) {
    return '${hours}h';
  }

  @override
  String timeAgoMinutes(int minutes) {
    return '${minutes}m';
  }

  @override
  String get timeSpent => 'Time Spent';

  @override
  String timeSpentHoursMinutes(int hours, int minutes) {
    return '$hours hours $minutes minutes';
  }

  @override
  String get today => 'Today';

  @override
  String get totalXP => 'Total XP';

  @override
  String get trueLabel => 'True';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get tue => 'T';

  @override
  String get typeMessage => 'Type your message...';

  @override
  String get typeWhatYouHear => 'Type what you hear...';

  @override
  String get typeYourAnswerHere => 'Type your answer here...';

  @override
  String get unlimitedLessons => 'Unlimited lessons';

  @override
  String get unlockSuper => 'Unlock Super';

  @override
  String get updateNow => 'Update Now';

  @override
  String get visitChillCorner => 'Visit Chill Corner';

  @override
  String get vocabularyReview => 'Vocabulary Review';

  @override
  String get wed => 'W';

  @override
  String get welcomeSubtitle =>
      'The most effective way to learn a new language.';

  @override
  String get welcomeTitle => 'Welcome to InstaLingo';

  @override
  String get whatNext => 'What would you like to do next?';

  @override
  String get wordsLearned => 'Words Learned';

  @override
  String get wordsPracticed => 'Words you practiced';

  @override
  String get xpShort => 'XP';

  @override
  String get xpThisWeek => 'XP This Week';

  @override
  String xpToGoal(int xp) {
    return '$xp more XP to reach your goal';
  }

  @override
  String get youLabel => 'You';

  @override
  String get yourLevel => 'Your Level';

  @override
  String get profile_chooseYourPlan => 'Choose Your Plan';

  @override
  String get profile_contactUs => 'Contact Us';

  @override
  String get profile_continueWithFree => 'Continue With Free';

  @override
  String get profile_culturalInsights => 'Cultural Insights';

  @override
  String get profile_culturalInsightsDesc => 'Cultural Insights Desc';

  @override
  String get profile_currentPlan => 'Current Plan';

  @override
  String get profile_dailyGoalMet => 'Daily Goal Met';

  @override
  String get profile_darkMode => 'Dark Mode';

  @override
  String get profile_downloadForOffline => 'Download For Offline';

  @override
  String get profile_downloadForOfflineDesc => 'Download For Offline Desc';

  @override
  String get profile_emailUs => 'Email Us';

  @override
  String get profile_falseBeginner => 'False Beginner';

  @override
  String get profile_faq => 'Faq';

  @override
  String get profile_faqAnswer1 => 'Faq Answer1';

  @override
  String get profile_faqAnswer2 => 'Faq Answer2';

  @override
  String get profile_faqAnswer3 => 'Faq Answer3';

  @override
  String get profile_faqAnswer4 => 'Faq Answer4';

  @override
  String get profile_faqQuestion1 => 'Faq Question1';

  @override
  String get profile_faqQuestion2 => 'Faq Question2';

  @override
  String get profile_faqQuestion3 => 'Faq Question3';

  @override
  String get profile_faqQuestion4 => 'Faq Question4';

  @override
  String get profile_feedback => 'Feedback';

  @override
  String get profile_findFriends => 'Find Friends';

  @override
  String get profile_firstSteps => 'First Steps';

  @override
  String get profile_followingTitle => 'Following Title';

  @override
  String get profile_freePlan => 'Free Plan';

  @override
  String get profile_goPremium => 'Go Premium';

  @override
  String get profile_goalDescription => 'Goal Description';

  @override
  String get profile_goalFluency => 'Goal Fluency';

  @override
  String get profile_goalTravel => 'Goal Travel';

  @override
  String get profile_goalWork => 'Goal Work';

  @override
  String get profile_inTheMorning => 'In The Morning';

  @override
  String get profile_keepPracticing => 'Keep Practicing';

  @override
  String get profile_lateNight => 'Late Night';

  @override
  String get profile_leaderboardTitle => 'Leaderboard Title';

  @override
  String get profile_learnBasicPhrases => 'Learn Basic Phrases';

  @override
  String get profile_levelUp => 'Level Up';

  @override
  String get profile_monthly => 'Monthly';

  @override
  String get profile_morningBird => 'Morning Bird';

  @override
  String get profile_mostPopular => 'Most Popular';

  @override
  String get profile_motivationCulture => 'Motivation Culture';

  @override
  String get profile_motivationFamily => 'Motivation Family';

  @override
  String get profile_motivationFun => 'Motivation Fun';

  @override
  String get profile_motivationTravel => 'Motivation Travel';

  @override
  String get profile_motivationWork => 'Motivation Work';

  @override
  String get profile_myPlan => 'My Plan';

  @override
  String get profile_nextAchievement => 'Next Achievement';

  @override
  String get profile_noFollowingYet => 'No Following Yet';

  @override
  String get profile_noFollowingYetMessage => 'No Following Yet Message';

  @override
  String get profile_noFriendsYet => 'No Friends Yet';

  @override
  String get profile_noFriendsYetMessage => 'No Friends Yet Message';

  @override
  String get profile_noLeaderboardData => 'No Leaderboard Data';

  @override
  String get profile_noLeaderboardDataMessage => 'No Leaderboard Data Message';

  @override
  String get profile_notifications => 'Notifications';

  @override
  String get profile_offlineTitle => 'Offline Title';

  @override
  String get profile_onboardingComplete => 'Onboarding Complete';

  @override
  String get profile_onboardingTitle => 'Onboarding Title';

  @override
  String get profile_perMonth => 'Per Month';

  @override
  String get profile_plan => 'Plan';

  @override
  String get profile_premium => 'Premium';

  @override
  String get profile_proFeatures => 'Pro Features';

  @override
  String get profile_proFeaturesDesc => 'Pro Features Desc';

  @override
  String get profile_proPlan => 'Pro Plan';

  @override
  String get profile_proPlanDesc => 'Pro Plan Desc';

  @override
  String get profile_profile => 'Profile';

  @override
  String get profile_progress => 'Progress';

  @override
  String get profile_progressReset => 'Progress Reset';

  @override
  String get profile_progressResetMessage => 'Progress Reset Message';

  @override
  String profile_questionXofY(Object x, Object y) {
    return 'Question $x of $y';
  }

  @override
  String get profile_reminder => 'Reminder';

  @override
  String get profile_reminderTime => 'Reminder Time';

  @override
  String get profile_removeAds => 'Remove Ads';

  @override
  String get profile_removeAdsDesc => 'Remove Ads Desc';

  @override
  String profile_savePercent(Object percent) {
    return 'Save $percent%';
  }

  @override
  String get profile_section => 'Section';

  @override
  String get profile_seeAll => 'See All';

  @override
  String get profile_sendFeedback => 'Send Feedback';

  @override
  String get profile_skillLevel => 'Skill Level';

  @override
  String get profile_speakingPractice => 'Speaking Practice';

  @override
  String get profile_startFreeTrial => 'Start Free Trial';

  @override
  String get profile_studyPlanDescription => 'Study Plan Description';

  @override
  String get profile_studyPlanTitle => 'Study Plan Title';

  @override
  String get profile_studyReminder => 'Study Reminder';

  @override
  String get profile_subscribeNow => 'Subscribe Now';

  @override
  String get profile_subtitle => 'Subtitle';

  @override
  String get profile_superDescription => 'Super Description';

  @override
  String get profile_support => 'Support';

  @override
  String get profile_travelPhrases => 'Travel Phrases';

  @override
  String get profile_troubleshooting => 'Troubleshooting';

  @override
  String profile_tryFreeForDays(Object days, Object price) {
    return 'Try free for $days days, then $price';
  }

  @override
  String get profile_unlimitedAccess => 'Unlimited Access';

  @override
  String get profile_unlimitedAccessDesc => 'Unlimited Access Desc';

  @override
  String get profile_unlimitedAiConversations => 'Unlimited Ai Conversations';

  @override
  String get profile_unlimitedAiConversationsDesc =>
      'Unlimited Ai Conversations Desc';

  @override
  String get profile_unlimitedLessons => 'Unlimited Lessons';

  @override
  String get profile_unlimitedLessonsDesc => 'Unlimited Lessons Desc';

  @override
  String get profile_unlimitedVocabularyBuilder =>
      'Unlimited Vocabulary Builder';

  @override
  String get profile_unlimitedVocabularyBuilderDesc =>
      'Unlimited Vocabulary Builder Desc';

  @override
  String get profile_weekdays => 'Weekdays';

  @override
  String get profile_weekends => 'Weekends';

  @override
  String get profile_whenToStudy => 'When To Study';

  @override
  String get profile_workCommunication => 'Work Communication';

  @override
  String get profile_workVocabulary => 'Work Vocabulary';

  @override
  String get profile_writingPractice => 'Writing Practice';

  @override
  String get profile_xpAndGems => 'Xp And Gems';

  @override
  String get profile_xpAndGemsDesc => 'Xp And Gems Desc';

  @override
  String get profile_xpEarnedToday => 'Xp Earned Today';

  @override
  String get profile_youEarned => 'You Earned';

  @override
  String get profile_yourStreak => 'Your Streak';

  @override
  String get progressToNextLevel => 'Progress To Next Level';

  @override
  String get rateApp => 'Rate App';

  @override
  String get recording => 'Recording';

  @override
  String get removeAds => 'Remove Ads';

  @override
  String get saveAndContinue => 'Save And Continue';

  @override
  String get searchPosts => 'Search Posts';

  @override
  String sectionX(Object x) {
    return 'Section $x';
  }

  @override
  String get seeAllAchievements => 'See All Achievements';

  @override
  String get shareApp => 'Share App';

  @override
  String get speakNow => 'Speak Now';

  @override
  String get startSpeaking => 'Start Speaking';

  @override
  String get streakTitle => 'Streak Title';

  @override
  String get studyNow => 'Study Now';

  @override
  String get subscribeNow => 'Subscribe Now';

  @override
  String get superMarket => 'Super Market';

  @override
  String get swipeToContinue => 'Swipe To Continue';

  @override
  String get tapToListen => 'Tap To Listen';

  @override
  String get tapToSpeak => 'Tap To Speak';

  @override
  String get technicalIssues => 'Technical Issues';

  @override
  String get totalLessons => 'Total Lessons';

  @override
  String get unlimited => 'Unlimited';

  @override
  String get unlockAllFeatures => 'Unlock All Features';

  @override
  String get unlockNow => 'Unlock Now';

  @override
  String get upgradeToPro => 'Upgrade To Pro';

  @override
  String get upgradeToSuper => 'Upgrade To Super';

  @override
  String get viewAll => 'View All';

  @override
  String get viewDetails => 'View Details';

  @override
  String get viewLeaderboard => 'View Leaderboard';

  @override
  String get vocabulary => 'Vocabulary';

  @override
  String get weekly => 'Weekly';

  @override
  String get weeklyGoal => 'Weekly Goal';

  @override
  String get welcome => 'Welcome';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get wordOfTheDay => 'Word Of The Day';

  @override
  String get xpEarned => 'Xp Earned';

  @override
  String get yearly => 'Yearly';

  @override
  String get yes => 'Yes';

  @override
  String get youAreOffline => 'You Are Offline';

  @override
  String get yourAnswer => 'Your Answer';

  @override
  String get yourProgress => 'Your Progress';

  @override
  String get onboarding_learningGoalTitle => 'What\'s your goal?';

  @override
  String get onboarding_learningGoalSubtitle =>
      'This helps us tailor your learning experience.';

  @override
  String get onboarding_examPrep => 'Prepare for an exam';

  @override
  String get onboarding_examPrepDesc =>
      'Structured lessons, mock tests, timed practice. Track your predicted score.';

  @override
  String get onboarding_justForFun => 'Just for fun';

  @override
  String get onboarding_justForFunDesc =>
      'Learn at your own pace. No tests, no pressure. Just pick up the language naturally.';

  @override
  String get onboarding_examTypeTitle => 'Which exam?';

  @override
  String onboarding_examTypeSubtitle(String lang) {
    return 'Pick the $lang exam you\'re working toward.';
  }

  @override
  String get onboarding_japanese => 'Japanese';

  @override
  String get onboarding_korean => 'Korean';

  @override
  String get onboarding_examLevelBeginner => 'Beginner';

  @override
  String get onboarding_examLevelElementary => 'Elementary';

  @override
  String get onboarding_examLevelBeginnerElementary => 'Beginner–Elementary';

  @override
  String onboarding_examWordsCount(String count) {
    return '$count words';
  }

  @override
  String get onboarding_examSectionsJLPT =>
      'Vocab, Grammar, Reading, Listening';

  @override
  String get onboarding_examSectionsTOPIK => 'Listening, Reading';

  @override
  String get keepPracticing => 'Keep practicing!';

  @override
  String get kanjiReference => 'Kanji Reference';

  @override
  String get kanaReference => 'Kana Charts';

  @override
  String get hiraganaChart => 'Hiragana';

  @override
  String get katakanaChart => 'Katakana';

  @override
  String get examCompleteTitle => 'Mock Test Complete!';

  @override
  String get yourScore => 'Your score';

  @override
  String get predictedLevel => 'Predicted level';

  @override
  String get profile_tts => 'Pronunciation (TTS)';

  @override
  String get profile_ttsDesc => 'Tap words to hear pronunciation';

  @override
  String get studyReminderBody => 'Time to practice!';

  @override
  String get jlptN5Label => 'JLPT N5';

  @override
  String get jlptN4Label => 'JLPT N4';

  @override
  String get onboarding_examLevelIntermediate => 'Intermediate';

  @override
  String get onboarding_examLevelUpperIntermediate => 'Upper Intermediate';

  @override
  String get onboarding_examLevelAdvanced => 'Advanced';
}
