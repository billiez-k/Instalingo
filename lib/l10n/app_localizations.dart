import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @advancedProgressTracking.
  ///
  /// In en, this message translates to:
  /// **'Advanced progress tracking'**
  String get advancedProgressTracking;

  /// No description provided for @aiAssistantName.
  ///
  /// In en, this message translates to:
  /// **'Maya'**
  String get aiAssistantName;

  /// No description provided for @aiAssistantRole.
  ///
  /// In en, this message translates to:
  /// **'Cafe Worker'**
  String get aiAssistantRole;

  /// No description provided for @aiBadge.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get aiBadge;

  /// No description provided for @aiChat.
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get aiChat;

  /// No description provided for @aiConversationGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m Maya. I work at a cafe in Tokyo. What would you like to practice today?'**
  String get aiConversationGreeting;

  /// No description provided for @aiConversationPractice.
  ///
  /// In en, this message translates to:
  /// **'AI conversation practice'**
  String get aiConversationPractice;

  /// No description provided for @aiConversationTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Conversation'**
  String get aiConversationTitle;

  /// No description provided for @aiPractice.
  ///
  /// In en, this message translates to:
  /// **'AI Practice'**
  String get aiPractice;

  /// No description provided for @aiYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get aiYou;

  /// No description provided for @annual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get annual;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Learn. Chill. Repeat.'**
  String get appTagline;

  /// The app name
  ///
  /// In en, this message translates to:
  /// **'InstaLingo'**
  String get appTitle;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @chapter.
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get chapter;

  /// No description provided for @chatWithAI.
  ///
  /// In en, this message translates to:
  /// **'Chat with an AI character'**
  String get chatWithAI;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @chill.
  ///
  /// In en, this message translates to:
  /// **'Chill'**
  String get chill;

  /// No description provided for @chillCorner.
  ///
  /// In en, this message translates to:
  /// **'Chill Corner'**
  String get chillCorner;

  /// No description provided for @chill_addComment.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get chill_addComment;

  /// No description provided for @chill_aiGeneratedImage.
  ///
  /// In en, this message translates to:
  /// **'AI Generated Image'**
  String get chill_aiGeneratedImage;

  /// No description provided for @chill_comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get chill_comments;

  /// No description provided for @chill_noPosts.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get chill_noPosts;

  /// No description provided for @chill_noPostsMessage.
  ///
  /// In en, this message translates to:
  /// **'Complete lessons to unlock vocabulary posts from the community.'**
  String get chill_noPostsMessage;

  /// No description provided for @chill_postNotFound.
  ///
  /// In en, this message translates to:
  /// **'Post not found'**
  String get chill_postNotFound;

  /// No description provided for @chill_postNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'This post may have been deleted or is no longer available.'**
  String get chill_postNotFoundMessage;

  /// No description provided for @chill_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get chill_share;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @commitment.
  ///
  /// In en, this message translates to:
  /// **'Commitment'**
  String get commitment;

  /// No description provided for @continueLearning.
  ///
  /// In en, this message translates to:
  /// **'Continue Learning'**
  String get continueLearning;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// No description provided for @correctCountOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{correct} / {total} correct'**
  String correctCountOfTotal(int correct, int total);

  /// No description provided for @correctWithExplanation.
  ///
  /// In en, this message translates to:
  /// **'Correct! {explanation}'**
  String correctWithExplanation(String explanation);

  /// No description provided for @courseComplete.
  ///
  /// In en, this message translates to:
  /// **'Course Completed!'**
  String get courseComplete;

  /// No description provided for @courseCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'You did it!'**
  String get courseCompleteTitle;

  /// No description provided for @coursePath.
  ///
  /// In en, this message translates to:
  /// **'Course Path'**
  String get coursePath;

  /// No description provided for @createProfile.
  ///
  /// In en, this message translates to:
  /// **'Create your profile'**
  String get createProfile;

  /// No description provided for @createProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'This helps us personalize your experience.'**
  String get createProfileDesc;

  /// No description provided for @dailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoal;

  /// No description provided for @dailyGoalCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoalCardTitle;

  /// No description provided for @dailyGoalReached.
  ///
  /// In en, this message translates to:
  /// **'Goal reached! Great job!'**
  String get dailyGoalReached;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get dayStreak;

  /// No description provided for @dayStreakCount.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String dayStreakCount(int count);

  /// No description provided for @defaultDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Learner'**
  String get defaultDisplayName;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @emptyStateMessage.
  ///
  /// In en, this message translates to:
  /// **'Come back later for more content.'**
  String get emptyStateMessage;

  /// No description provided for @emptyStateTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyStateTitle;

  /// No description provided for @errorGenericMessage.
  ///
  /// In en, this message translates to:
  /// **'We could not load this content. Please try again.'**
  String get errorGenericMessage;

  /// No description provided for @errorGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGenericTitle;

  /// No description provided for @exArrangeWords.
  ///
  /// In en, this message translates to:
  /// **'Arrange the words to form a correct sentence'**
  String get exArrangeWords;

  /// No description provided for @exComprehension.
  ///
  /// In en, this message translates to:
  /// **'Read the passage and answer'**
  String get exComprehension;

  /// No description provided for @exDialogueComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete the dialogue'**
  String get exDialogueComplete;

  /// No description provided for @exFillInBlank.
  ///
  /// In en, this message translates to:
  /// **'Fill in the blank'**
  String get exFillInBlank;

  /// No description provided for @exFlashCard.
  ///
  /// In en, this message translates to:
  /// **'Tap to flip the card'**
  String get exFlashCard;

  /// No description provided for @exGrammarTip.
  ///
  /// In en, this message translates to:
  /// **'Grammar Tip'**
  String get exGrammarTip;

  /// No description provided for @exImageIdentify.
  ///
  /// In en, this message translates to:
  /// **'Tap the correct image'**
  String get exImageIdentify;

  /// No description provided for @exMatchWords.
  ///
  /// In en, this message translates to:
  /// **'Match the words with their meanings'**
  String get exMatchWords;

  /// No description provided for @exPhraseBuilder.
  ///
  /// In en, this message translates to:
  /// **'Build the phrase'**
  String get exPhraseBuilder;

  /// No description provided for @exSpeaking.
  ///
  /// In en, this message translates to:
  /// **'Say this word aloud'**
  String get exSpeaking;

  /// No description provided for @exTranslate.
  ///
  /// In en, this message translates to:
  /// **'Translate this sentence'**
  String get exTranslate;

  /// No description provided for @exTrueFalse.
  ///
  /// In en, this message translates to:
  /// **'Is this statement correct?'**
  String get exTrueFalse;

  /// No description provided for @exTypeWhatYouHear.
  ///
  /// In en, this message translates to:
  /// **'Type what you hear'**
  String get exTypeWhatYouHear;

  /// No description provided for @exVocabMultipleChoice.
  ///
  /// In en, this message translates to:
  /// **'Which word means \"{word}\"?'**
  String exVocabMultipleChoice(Object word);

  /// No description provided for @exWhichWordMeans.
  ///
  /// In en, this message translates to:
  /// **'Which means \"{word}\"?'**
  String exWhichWordMeans(Object word);

  /// No description provided for @exWriting.
  ///
  /// In en, this message translates to:
  /// **'Write your answer'**
  String get exWriting;

  /// No description provided for @exampleLabel.
  ///
  /// In en, this message translates to:
  /// **'Example'**
  String get exampleLabel;

  /// No description provided for @exercisesProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} exercises'**
  String exercisesProgress(int completed, int total);

  /// No description provided for @falseLabel.
  ///
  /// In en, this message translates to:
  /// **'False'**
  String get falseLabel;

  /// No description provided for @featureAICharacters.
  ///
  /// In en, this message translates to:
  /// **'AI Characters'**
  String get featureAICharacters;

  /// No description provided for @featureAICharactersDesc.
  ///
  /// In en, this message translates to:
  /// **'Practice with AI personas that respond like real people in the Chill Corner.'**
  String get featureAICharactersDesc;

  /// No description provided for @featureMotivation.
  ///
  /// In en, this message translates to:
  /// **'Stay Motivated'**
  String get featureMotivation;

  /// No description provided for @featureMotivationDesc.
  ///
  /// In en, this message translates to:
  /// **'Earn XP, maintain streaks, and unlock achievements as you progress.'**
  String get featureMotivationDesc;

  /// No description provided for @featureStructuredCourses.
  ///
  /// In en, this message translates to:
  /// **'Structured Courses'**
  String get featureStructuredCourses;

  /// No description provided for @featureStructuredCoursesDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn with professionally designed lessons that build on each other.'**
  String get featureStructuredCoursesDesc;

  /// No description provided for @findFriends.
  ///
  /// In en, this message translates to:
  /// **'Find Friends'**
  String get findFriends;

  /// No description provided for @finishLesson.
  ///
  /// In en, this message translates to:
  /// **'Finish Lesson'**
  String get finishLesson;

  /// No description provided for @flashcardEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get flashcardEasy;

  /// No description provided for @flashcardGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get flashcardGood;

  /// No description provided for @flashcardHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get flashcardHard;

  /// No description provided for @followingTitle.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get followingTitle;

  /// No description provided for @forceUpdateBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ve made InstaLingo faster, more stable, and packed with new features. Please update to the latest version to continue.'**
  String get forceUpdateBody;

  /// No description provided for @forceUpdateBugFixes.
  ///
  /// In en, this message translates to:
  /// **'Bug fixes & stability'**
  String get forceUpdateBugFixes;

  /// No description provided for @forceUpdateMessage.
  ///
  /// In en, this message translates to:
  /// **'A new version of InstaLingo is available. Please update to continue learning.'**
  String get forceUpdateMessage;

  /// No description provided for @forceUpdateNewContent.
  ///
  /// In en, this message translates to:
  /// **'New lessons & exercises'**
  String get forceUpdateNewContent;

  /// No description provided for @forceUpdatePerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance improvements'**
  String get forceUpdatePerformance;

  /// No description provided for @forceUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get forceUpdateTitle;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get fri;

  /// No description provided for @friendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friendsTitle;

  /// No description provided for @gems.
  ///
  /// In en, this message translates to:
  /// **'Gems'**
  String get gems;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @getUnlimitedLearning.
  ///
  /// In en, this message translates to:
  /// **'Get unlimited learning'**
  String get getUnlimitedLearning;

  /// No description provided for @goodbye.
  ///
  /// In en, this message translates to:
  /// **'Goodbye'**
  String get goodbye;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get gotIt;

  /// No description provided for @grammarExampleFallback.
  ///
  /// In en, this message translates to:
  /// **'Practice makes perfect!'**
  String get grammarExampleFallback;

  /// No description provided for @grammarRuleFallback.
  ///
  /// In en, this message translates to:
  /// **'Pay attention to the grammar in this exercise.'**
  String get grammarRuleFallback;

  /// No description provided for @grammarTip.
  ///
  /// In en, this message translates to:
  /// **'Grammar Tip'**
  String get grammarTip;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get hello;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @holdToSpeak.
  ///
  /// In en, this message translates to:
  /// **'Hold to speak'**
  String get holdToSpeak;

  /// No description provided for @howAreYou.
  ///
  /// In en, this message translates to:
  /// **'How Are You?'**
  String get howAreYou;

  /// No description provided for @iAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I Already Have an Account'**
  String get iAlreadyHaveAccount;

  /// No description provided for @incorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get incorrect;

  /// No description provided for @knowIt.
  ///
  /// In en, this message translates to:
  /// **'Know It'**
  String get knowIt;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @leaderboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboardTitle;

  /// No description provided for @learn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learn;

  /// No description provided for @learnRuleToImprove.
  ///
  /// In en, this message translates to:
  /// **'Learn this rule to improve'**
  String get learnRuleToImprove;

  /// No description provided for @learningLanguage.
  ///
  /// In en, this message translates to:
  /// **'Learning Language'**
  String get learningLanguage;

  /// No description provided for @lessonComplete.
  ///
  /// In en, this message translates to:
  /// **'Lesson Complete!'**
  String get lessonComplete;

  /// No description provided for @lessonCompleteGood.
  ///
  /// In en, this message translates to:
  /// **'Good effort! Review and try again!'**
  String get lessonCompleteGood;

  /// No description provided for @lessonCompleteGreat.
  ///
  /// In en, this message translates to:
  /// **'Great job! Keep practicing!'**
  String get lessonCompleteGreat;

  /// No description provided for @lessonCompletePerfect.
  ///
  /// In en, this message translates to:
  /// **'Perfect! You are on fire!'**
  String get lessonCompletePerfect;

  /// No description provided for @lessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessons;

  /// No description provided for @levelAbbreviation.
  ///
  /// In en, this message translates to:
  /// **'LV'**
  String get levelAbbreviation;

  /// No description provided for @levelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get levelAdvanced;

  /// No description provided for @levelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get levelBeginner;

  /// No description provided for @levelElementary.
  ///
  /// In en, this message translates to:
  /// **'Elementary'**
  String get levelElementary;

  /// No description provided for @levelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get levelIntermediate;

  /// No description provided for @levelProficiency.
  ///
  /// In en, this message translates to:
  /// **'Proficiency'**
  String get levelProficiency;

  /// No description provided for @levelUpperIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Upper Intermediate'**
  String get levelUpperIntermediate;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @loadingLesson.
  ///
  /// In en, this message translates to:
  /// **'Loading lesson...'**
  String get loadingLesson;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @matchPairsInstruction.
  ///
  /// In en, this message translates to:
  /// **'Tap a word on the left, then its match on the right'**
  String get matchPairsInstruction;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get mon;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @motivation.
  ///
  /// In en, this message translates to:
  /// **'Motivation'**
  String get motivation;

  /// No description provided for @myNameIs.
  ///
  /// In en, this message translates to:
  /// **'My Name Is'**
  String get myNameIs;

  /// No description provided for @nativeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Native Language'**
  String get nativeLanguage;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @nextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get nextQuestion;

  /// No description provided for @niceToMeetYou.
  ///
  /// In en, this message translates to:
  /// **'Nice to Meet You'**
  String get niceToMeetYou;

  /// No description provided for @noAds.
  ///
  /// In en, this message translates to:
  /// **'No ads'**
  String get noAds;

  /// No description provided for @noConnectionMessage.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet and try again.'**
  String get noConnectionMessage;

  /// No description provided for @noConnectionTitle.
  ///
  /// In en, this message translates to:
  /// **'No Connection'**
  String get noConnectionTitle;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @notQuiteWithExplanation.
  ///
  /// In en, this message translates to:
  /// **'Not quite. {explanation}'**
  String notQuiteWithExplanation(String explanation);

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn languages through structured courses & AI personas'**
  String get onboardingTitle;

  /// No description provided for @onboarding_commitmentCasual.
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get onboarding_commitmentCasual;

  /// No description provided for @onboarding_commitmentIntense.
  ///
  /// In en, this message translates to:
  /// **'Intense'**
  String get onboarding_commitmentIntense;

  /// No description provided for @onboarding_commitmentRegular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get onboarding_commitmentRegular;

  /// No description provided for @onboarding_commitmentSerious.
  ///
  /// In en, this message translates to:
  /// **'Serious'**
  String get onboarding_commitmentSerious;

  /// No description provided for @onboarding_commitmentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can always change this later in settings.'**
  String get onboarding_commitmentSubtitle;

  /// No description provided for @onboarding_commitmentTitle.
  ///
  /// In en, this message translates to:
  /// **'How much time\ncan you commit?'**
  String get onboarding_commitmentTitle;

  /// No description provided for @onboarding_displayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get onboarding_displayNameLabel;

  /// No description provided for @onboarding_emailOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get onboarding_emailOptionalLabel;

  /// No description provided for @onboarding_enterEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get onboarding_enterEmailHint;

  /// No description provided for @onboarding_enterNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get onboarding_enterNameHint;

  /// No description provided for @onboarding_learningLangSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the language you want to master.'**
  String get onboarding_learningLangSubtitle;

  /// No description provided for @onboarding_motivationBrainTraining.
  ///
  /// In en, this message translates to:
  /// **'Brain Training'**
  String get onboarding_motivationBrainTraining;

  /// No description provided for @onboarding_motivationCareer.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get onboarding_motivationCareer;

  /// No description provided for @onboarding_motivationCulture.
  ///
  /// In en, this message translates to:
  /// **'Culture'**
  String get onboarding_motivationCulture;

  /// No description provided for @onboarding_motivationFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get onboarding_motivationFamily;

  /// No description provided for @onboarding_motivationFun.
  ///
  /// In en, this message translates to:
  /// **'Just for Fun'**
  String get onboarding_motivationFun;

  /// No description provided for @onboarding_motivationMoviesShows.
  ///
  /// In en, this message translates to:
  /// **'Movies & Shows'**
  String get onboarding_motivationMoviesShows;

  /// No description provided for @onboarding_motivationStudyAbroad.
  ///
  /// In en, this message translates to:
  /// **'Study Abroad'**
  String get onboarding_motivationStudyAbroad;

  /// No description provided for @onboarding_motivationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select all that apply.'**
  String get onboarding_motivationSubtitle;

  /// No description provided for @onboarding_motivationTitle.
  ///
  /// In en, this message translates to:
  /// **'Why are you learning?'**
  String get onboarding_motivationTitle;

  /// No description provided for @onboarding_motivationTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get onboarding_motivationTravel;

  /// No description provided for @onboarding_nativeLangSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll use this to personalize your learning experience.'**
  String get onboarding_nativeLangSubtitle;

  /// No description provided for @onboarding_proficiencyAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get onboarding_proficiencyAdvanced;

  /// No description provided for @onboarding_proficiencyAdvancedDesc.
  ///
  /// In en, this message translates to:
  /// **'I speak fluently'**
  String get onboarding_proficiencyAdvancedDesc;

  /// No description provided for @onboarding_proficiencyBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get onboarding_proficiencyBeginner;

  /// No description provided for @onboarding_proficiencyBeginnerDesc.
  ///
  /// In en, this message translates to:
  /// **'I know a few words'**
  String get onboarding_proficiencyBeginnerDesc;

  /// No description provided for @onboarding_proficiencyElementary.
  ///
  /// In en, this message translates to:
  /// **'Elementary'**
  String get onboarding_proficiencyElementary;

  /// No description provided for @onboarding_proficiencyElementaryDesc.
  ///
  /// In en, this message translates to:
  /// **'I can form simple sentences'**
  String get onboarding_proficiencyElementaryDesc;

  /// No description provided for @onboarding_proficiencyIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get onboarding_proficiencyIntermediate;

  /// No description provided for @onboarding_proficiencyIntermediateDesc.
  ///
  /// In en, this message translates to:
  /// **'I can hold a conversation'**
  String get onboarding_proficiencyIntermediateDesc;

  /// No description provided for @onboarding_proficiencyProficient.
  ///
  /// In en, this message translates to:
  /// **'Proficient'**
  String get onboarding_proficiencyProficient;

  /// No description provided for @onboarding_proficiencyProficientDesc.
  ///
  /// In en, this message translates to:
  /// **'I speak like a native'**
  String get onboarding_proficiencyProficientDesc;

  /// No description provided for @onboarding_proficiencySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll start you at the right difficulty.'**
  String get onboarding_proficiencySubtitle;

  /// No description provided for @onboarding_proficiencyTitle.
  ///
  /// In en, this message translates to:
  /// **'What is your\ncurrent level?'**
  String get onboarding_proficiencyTitle;

  /// No description provided for @onboarding_proficiencyUpperIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Upper-Intermediate'**
  String get onboarding_proficiencyUpperIntermediate;

  /// No description provided for @onboarding_proficiencyUpperIntermediateDesc.
  ///
  /// In en, this message translates to:
  /// **'I can discuss various topics'**
  String get onboarding_proficiencyUpperIntermediateDesc;

  /// No description provided for @onboarding_skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get onboarding_skipForNow;

  /// No description provided for @paywallSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock unlimited learning'**
  String get paywallSubtitle;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'InstaLingo Super'**
  String get paywallTitle;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get perMonth;

  /// No description provided for @perYear.
  ///
  /// In en, this message translates to:
  /// **'/year'**
  String get perYear;

  /// No description provided for @pickNewCourse.
  ///
  /// In en, this message translates to:
  /// **'Pick a New Course'**
  String get pickNewCourse;

  /// No description provided for @playing.
  ///
  /// In en, this message translates to:
  /// **'Playing...'**
  String get playing;

  /// No description provided for @practiceWords.
  ///
  /// In en, this message translates to:
  /// **'Practice the words you just learned'**
  String get practiceWords;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @proficiency.
  ///
  /// In en, this message translates to:
  /// **'Proficiency'**
  String get proficiency;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profile_academicEnglish.
  ///
  /// In en, this message translates to:
  /// **'Academic English'**
  String get profile_academicEnglish;

  /// No description provided for @profile_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profile_account;

  /// No description provided for @profile_achievementsUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Achievements Unlocked'**
  String get profile_achievementsUnlocked;

  /// No description provided for @profile_adFreeExperience.
  ///
  /// In en, this message translates to:
  /// **'Ad-Free Experience'**
  String get profile_adFreeExperience;

  /// No description provided for @profile_adFreeExperienceDesc.
  ///
  /// In en, this message translates to:
  /// **'Focus on learning with zero interruptions.'**
  String get profile_adFreeExperienceDesc;

  /// No description provided for @profile_advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get profile_advanced;

  /// No description provided for @profile_advancedSpeakingDesc.
  ///
  /// In en, this message translates to:
  /// **'Get detailed pronunciation and fluency analysis with waveform visualization.'**
  String get profile_advancedSpeakingDesc;

  /// No description provided for @profile_advancedSpeakingFeedback.
  ///
  /// In en, this message translates to:
  /// **'Advanced speaking feedback'**
  String get profile_advancedSpeakingFeedback;

  /// No description provided for @profile_aiConversationPractice.
  ///
  /// In en, this message translates to:
  /// **'AI Conversation Practice'**
  String get profile_aiConversationPractice;

  /// No description provided for @profile_aiConversationPracticeAnswer.
  ///
  /// In en, this message translates to:
  /// **'Practice real conversations with AI personas in different scenarios like cafes, airports, and offices.'**
  String get profile_aiConversationPracticeAnswer;

  /// No description provided for @profile_allChillCornerContent.
  ///
  /// In en, this message translates to:
  /// **'All Chill Corner content'**
  String get profile_allChillCornerContent;

  /// No description provided for @profile_appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profile_appearance;

  /// No description provided for @profile_beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get profile_beginner;

  /// No description provided for @profile_bestValue.
  ///
  /// In en, this message translates to:
  /// **'Best Value'**
  String get profile_bestValue;

  /// No description provided for @profile_browseTopics.
  ///
  /// In en, this message translates to:
  /// **'Browse topics below or contact us directly'**
  String get profile_browseTopics;

  /// No description provided for @profile_businessEnglish.
  ///
  /// In en, this message translates to:
  /// **'Business English'**
  String get profile_businessEnglish;

  /// No description provided for @profile_cancelAnytime.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime. No commitment.'**
  String get profile_cancelAnytime;

  /// No description provided for @profile_checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get profile_checkForUpdates;

  /// No description provided for @profile_completeBeginner.
  ///
  /// In en, this message translates to:
  /// **'Complete beginner'**
  String get profile_completeBeginner;

  /// No description provided for @profile_contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get profile_contactSupport;

  /// No description provided for @profile_createPlan.
  ///
  /// In en, this message translates to:
  /// **'Create Plan'**
  String get profile_createPlan;

  /// No description provided for @profile_dailyConversation.
  ///
  /// In en, this message translates to:
  /// **'Daily conversation'**
  String get profile_dailyConversation;

  /// No description provided for @profile_daytime.
  ///
  /// In en, this message translates to:
  /// **'Daytime (9 AM-5 PM)'**
  String get profile_daytime;

  /// No description provided for @profile_displayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get profile_displayName;

  /// No description provided for @profile_duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get profile_duration;

  /// No description provided for @profile_durationDesc.
  ///
  /// In en, this message translates to:
  /// **'How long per session?'**
  String get profile_durationDesc;

  /// No description provided for @profile_earningXPGems.
  ///
  /// In en, this message translates to:
  /// **'Earning XP and Gems'**
  String get profile_earningXPGems;

  /// No description provided for @profile_earningXPGemsAnswer.
  ///
  /// In en, this message translates to:
  /// **'Complete lessons, maintain streaks, and review vocabulary to earn rewards and unlock achievements.'**
  String get profile_earningXPGemsAnswer;

  /// No description provided for @profile_elementary.
  ///
  /// In en, this message translates to:
  /// **'Elementary'**
  String get profile_elementary;

  /// No description provided for @profile_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profile_email;

  /// No description provided for @profile_enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get profile_enableNotifications;

  /// No description provided for @profile_enableNotificationsAnswer.
  ///
  /// In en, this message translates to:
  /// **'Turn on reminders in Settings to get daily prompts and maintain your streak.'**
  String get profile_enableNotificationsAnswer;

  /// No description provided for @profile_enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get profile_enterYourEmail;

  /// No description provided for @profile_enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get profile_enterYourName;

  /// No description provided for @profile_evening.
  ///
  /// In en, this message translates to:
  /// **'Evening (5-9 PM)'**
  String get profile_evening;

  /// No description provided for @profile_everyDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get profile_everyDay;

  /// No description provided for @profile_everythingInMonthly.
  ///
  /// In en, this message translates to:
  /// **'Everything in Monthly'**
  String get profile_everythingInMonthly;

  /// No description provided for @profile_examPreparation.
  ///
  /// In en, this message translates to:
  /// **'Exam preparation'**
  String get profile_examPreparation;

  /// No description provided for @profile_exclusiveStudyPlans.
  ///
  /// In en, this message translates to:
  /// **'Exclusive study plans'**
  String get profile_exclusiveStudyPlans;

  /// No description provided for @profile_fifteenMinutes.
  ///
  /// In en, this message translates to:
  /// **'15 minutes'**
  String get profile_fifteenMinutes;

  /// No description provided for @profile_fiveDaysAWeek.
  ///
  /// In en, this message translates to:
  /// **'5 days a week'**
  String get profile_fiveDaysAWeek;

  /// No description provided for @profile_fiveMinutes.
  ///
  /// In en, this message translates to:
  /// **'5 minutes'**
  String get profile_fiveMinutes;

  /// No description provided for @profile_follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get profile_follow;

  /// No description provided for @profile_followOthersMessage.
  ///
  /// In en, this message translates to:
  /// **'Follow other learners to see them here.'**
  String get profile_followOthersMessage;

  /// No description provided for @profile_gettingStarted.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get profile_gettingStarted;

  /// No description provided for @profile_goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get profile_goal;

  /// No description provided for @profile_goalDesc.
  ///
  /// In en, this message translates to:
  /// **'What do you want to achieve?'**
  String get profile_goalDesc;

  /// No description provided for @profile_gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get profile_gotIt;

  /// No description provided for @profile_howDoIStart.
  ///
  /// In en, this message translates to:
  /// **'How do I start learning?'**
  String get profile_howDoIStart;

  /// No description provided for @profile_howDoIStartAnswer.
  ///
  /// In en, this message translates to:
  /// **'Choose your native language, then pick a language to learn. Complete the onboarding and start with the first lesson.'**
  String get profile_howDoIStartAnswer;

  /// No description provided for @profile_inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get profile_inProgress;

  /// No description provided for @profile_instalingoSuperFAQ.
  ///
  /// In en, this message translates to:
  /// **'InstaLingo Super'**
  String get profile_instalingoSuperFAQ;

  /// No description provided for @profile_instalingoSuperFAQAnswer.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Super for unlimited lessons, AI practice, advanced tracking, and an ad-free experience.'**
  String get profile_instalingoSuperFAQAnswer;

  /// No description provided for @profile_intensity.
  ///
  /// In en, this message translates to:
  /// **'Intensity'**
  String get profile_intensity;

  /// No description provided for @profile_intensityDesc.
  ///
  /// In en, this message translates to:
  /// **'How often per week?'**
  String get profile_intensityDesc;

  /// No description provided for @profile_intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get profile_intermediate;

  /// No description provided for @profile_learning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get profile_learning;

  /// No description provided for @profile_learningFeatures.
  ///
  /// In en, this message translates to:
  /// **'Learning Features'**
  String get profile_learningFeatures;

  /// No description provided for @profile_learningStatus.
  ///
  /// In en, this message translates to:
  /// **'Learning {language} · {level}'**
  String profile_learningStatus(String language, String level);

  /// No description provided for @profile_lessonRemindersStreakAlerts.
  ///
  /// In en, this message translates to:
  /// **'Lesson reminders, streak alerts'**
  String get profile_lessonRemindersStreakAlerts;

  /// No description provided for @profile_lessonsCompleted.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} lessons completed'**
  String profile_lessonsCompleted(int completed, int total);

  /// No description provided for @profile_level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get profile_level;

  /// No description provided for @profile_levelDesc.
  ///
  /// In en, this message translates to:
  /// **'Where are you starting?'**
  String get profile_levelDesc;

  /// No description provided for @profile_levelSuffix.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get profile_levelSuffix;

  /// No description provided for @profile_minPerDay.
  ///
  /// In en, this message translates to:
  /// **'{min} min / day'**
  String profile_minPerDay(int min);

  /// No description provided for @profile_minutesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes'**
  String profile_minutesCount(int count);

  /// No description provided for @profile_morning.
  ///
  /// In en, this message translates to:
  /// **'Morning (6-9 AM)'**
  String get profile_morning;

  /// No description provided for @profile_night.
  ///
  /// In en, this message translates to:
  /// **'Night (9 PM-12 AM)'**
  String get profile_night;

  /// No description provided for @profile_noAchievementsMessage.
  ///
  /// In en, this message translates to:
  /// **'Complete lessons and maintain streaks to unlock achievements.'**
  String get profile_noAchievementsMessage;

  /// No description provided for @profile_noAchievementsYet.
  ///
  /// In en, this message translates to:
  /// **'No achievements yet'**
  String get profile_noAchievementsYet;

  /// No description provided for @profile_notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get profile_notSet;

  /// No description provided for @profile_offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline mode'**
  String get profile_offlineMode;

  /// No description provided for @profile_offlineModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Download lessons and learn anywhere without internet.'**
  String get profile_offlineModeDesc;

  /// No description provided for @profile_perMonthDesc.
  ///
  /// In en, this message translates to:
  /// **'per month'**
  String get profile_perMonthDesc;

  /// No description provided for @profile_perYearDesc.
  ///
  /// In en, this message translates to:
  /// **'per year'**
  String get profile_perYearDesc;

  /// No description provided for @profile_personalizedStudyPlans.
  ///
  /// In en, this message translates to:
  /// **'Personalized Study Plans'**
  String get profile_personalizedStudyPlans;

  /// No description provided for @profile_personalizedStudyPlansDesc.
  ///
  /// In en, this message translates to:
  /// **'AI-generated study plans tailored to your goals and schedule.'**
  String get profile_personalizedStudyPlansDesc;

  /// No description provided for @profile_priorityAIResponses.
  ///
  /// In en, this message translates to:
  /// **'Priority AI responses'**
  String get profile_priorityAIResponses;

  /// No description provided for @profile_proBadge.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get profile_proBadge;

  /// No description provided for @profile_proficiencyLevel.
  ///
  /// In en, this message translates to:
  /// **'Proficiency Level'**
  String get profile_proficiencyLevel;

  /// No description provided for @profile_proficient.
  ///
  /// In en, this message translates to:
  /// **'Proficient'**
  String get profile_proficient;

  /// No description provided for @profile_resetProgress.
  ///
  /// In en, this message translates to:
  /// **'Reset Progress'**
  String get profile_resetProgress;

  /// No description provided for @profile_resetProgressFAQ.
  ///
  /// In en, this message translates to:
  /// **'Reset Progress'**
  String get profile_resetProgressFAQ;

  /// No description provided for @profile_resetProgressFAQAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings > Reset Progress to start over. This action cannot be undone.'**
  String get profile_resetProgressFAQAnswer;

  /// No description provided for @profile_saveFiftyVsMonthly.
  ///
  /// In en, this message translates to:
  /// **'Save 50% vs monthly'**
  String get profile_saveFiftyVsMonthly;

  /// No description provided for @profile_schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get profile_schedule;

  /// No description provided for @profile_scheduleDesc.
  ///
  /// In en, this message translates to:
  /// **'When can you study?'**
  String get profile_scheduleDesc;

  /// No description provided for @profile_settingDailyGoals.
  ///
  /// In en, this message translates to:
  /// **'Setting daily goals'**
  String get profile_settingDailyGoals;

  /// No description provided for @profile_settingDailyGoalsAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile > Settings > Daily Goal to adjust your learning target. We recommend 15-30 minutes per day.'**
  String get profile_settingDailyGoalsAnswer;

  /// No description provided for @profile_someBasics.
  ///
  /// In en, this message translates to:
  /// **'Some basics'**
  String get profile_someBasics;

  /// No description provided for @profile_soundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get profile_soundEffects;

  /// No description provided for @profile_stepXofY.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String profile_stepXofY(int current, int total);

  /// No description provided for @profile_streakLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} streak'**
  String profile_streakLabel(int count);

  /// No description provided for @profile_studyPlanCreated.
  ///
  /// In en, this message translates to:
  /// **'Study plan created successfully!'**
  String get profile_studyPlanCreated;

  /// No description provided for @profile_superBadge.
  ///
  /// In en, this message translates to:
  /// **'SUPER'**
  String get profile_superBadge;

  /// No description provided for @profile_superSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The ultimate language learning experience with AI-powered features.'**
  String get profile_superSubtitle;

  /// No description provided for @profile_superTitle.
  ///
  /// In en, this message translates to:
  /// **'Super'**
  String get profile_superTitle;

  /// No description provided for @profile_tenMinutes.
  ///
  /// In en, this message translates to:
  /// **'10 minutes'**
  String get profile_tenMinutes;

  /// No description provided for @profile_threeDaysAWeek.
  ///
  /// In en, this message translates to:
  /// **'3 days a week'**
  String get profile_threeDaysAWeek;

  /// No description provided for @profile_travelBasics.
  ///
  /// In en, this message translates to:
  /// **'Travel basics'**
  String get profile_travelBasics;

  /// No description provided for @profile_twentyPlusMinutes.
  ///
  /// In en, this message translates to:
  /// **'20+ minutes'**
  String get profile_twentyPlusMinutes;

  /// No description provided for @profile_unlimitedAIConversations.
  ///
  /// In en, this message translates to:
  /// **'Unlimited AI conversations'**
  String get profile_unlimitedAIConversations;

  /// No description provided for @profile_unlimitedAIDesc.
  ///
  /// In en, this message translates to:
  /// **'Practice with AI personas without limits in the Chill Corner.'**
  String get profile_unlimitedAIDesc;

  /// No description provided for @profile_unlockFullExperience.
  ///
  /// In en, this message translates to:
  /// **'Unlock the full language learning experience.'**
  String get profile_unlockFullExperience;

  /// No description provided for @profile_unlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get profile_unlocked;

  /// No description provided for @profile_upgradeToSuper.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Super'**
  String get profile_upgradeToSuper;

  /// No description provided for @profile_upperIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Upper-Intermediate'**
  String get profile_upperIntermediate;

  /// No description provided for @profile_version.
  ///
  /// In en, this message translates to:
  /// **'InstaLingo v{version}'**
  String profile_version(String version);

  /// No description provided for @profile_visitHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Visit Help Center'**
  String get profile_visitHelpCenter;

  /// No description provided for @profile_weekendsOnly.
  ///
  /// In en, this message translates to:
  /// **'Weekends only'**
  String get profile_weekendsOnly;

  /// No description provided for @profile_whatIsChillCorner.
  ///
  /// In en, this message translates to:
  /// **'What is Chill Corner?'**
  String get profile_whatIsChillCorner;

  /// No description provided for @profile_whatIsChillCornerAnswer.
  ///
  /// In en, this message translates to:
  /// **'Chill Corner shows vocabulary you\'ve learned in real-world contexts, shared by AI characters.'**
  String get profile_whatIsChillCornerAnswer;

  /// No description provided for @questionXofY.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String questionXofY(int current, int total);

  /// No description provided for @readyToLearn.
  ///
  /// In en, this message translates to:
  /// **'Ready to learn today?'**
  String get readyToLearn;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'9:00 AM'**
  String get reminderTime;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @reviewVocabulary.
  ///
  /// In en, this message translates to:
  /// **'Review Vocabulary'**
  String get reviewVocabulary;

  /// No description provided for @sampleAnswer.
  ///
  /// In en, this message translates to:
  /// **'Sample answer:'**
  String get sampleAnswer;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get sat;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @savePercent.
  ///
  /// In en, this message translates to:
  /// **'Save {percent}%'**
  String savePercent(int percent);

  /// No description provided for @scenarioCafeTokyo.
  ///
  /// In en, this message translates to:
  /// **'Scenario: Ordering at a cafe in Tokyo'**
  String get scenarioCafeTokyo;

  /// No description provided for @section.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get section;

  /// No description provided for @sections.
  ///
  /// In en, this message translates to:
  /// **'Sections'**
  String get sections;

  /// No description provided for @seeResults.
  ///
  /// In en, this message translates to:
  /// **'See Results'**
  String get seeResults;

  /// No description provided for @seeWordsInContext.
  ///
  /// In en, this message translates to:
  /// **'See your learned words in context'**
  String get seeWordsInContext;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @speakersCount.
  ///
  /// In en, this message translates to:
  /// **'{speakers} speakers'**
  String speakersCount(String speakers);

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @startFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'Start Free Trial'**
  String get startFreeTrial;

  /// No description provided for @startLearning.
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get startLearning;

  /// No description provided for @startNextLesson.
  ///
  /// In en, this message translates to:
  /// **'Start the next lesson in your course'**
  String get startNextLesson;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statsTitle;

  /// No description provided for @stillLearning.
  ///
  /// In en, this message translates to:
  /// **'Still Learning'**
  String get stillLearning;

  /// No description provided for @streakCalendar.
  ///
  /// In en, this message translates to:
  /// **'Streak Calendar'**
  String get streakCalendar;

  /// No description provided for @streakKeepStreak.
  ///
  /// In en, this message translates to:
  /// **'Complete a lesson to keep your {currentStreak} day streak!'**
  String streakKeepStreak(int currentStreak);

  /// No description provided for @streakRepair.
  ///
  /// In en, this message translates to:
  /// **'Repair Streak'**
  String get streakRepair;

  /// No description provided for @streakRepaired.
  ///
  /// In en, this message translates to:
  /// **'Repaired'**
  String get streakRepaired;

  /// No description provided for @streakShielded.
  ///
  /// In en, this message translates to:
  /// **'Shielded'**
  String get streakShielded;

  /// No description provided for @streakShieldsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} streak shields remaining'**
  String streakShieldsRemaining(int count);

  /// No description provided for @studyPlan.
  ///
  /// In en, this message translates to:
  /// **'Study Plan'**
  String get studyPlan;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get sun;

  /// No description provided for @takePlacementTest.
  ///
  /// In en, this message translates to:
  /// **'Take Placement Test'**
  String get takePlacementTest;

  /// No description provided for @tapAndHoldMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Tap and hold the microphone to speak'**
  String get tapAndHoldMicrophone;

  /// No description provided for @tapToFlip.
  ///
  /// In en, this message translates to:
  /// **'Tap to flip'**
  String get tapToFlip;

  /// No description provided for @tapToFlipBack.
  ///
  /// In en, this message translates to:
  /// **'Tap to flip back'**
  String get tapToFlipBack;

  /// No description provided for @tapToPlay.
  ///
  /// In en, this message translates to:
  /// **'Tap to play'**
  String get tapToPlay;

  /// No description provided for @tapToReveal.
  ///
  /// In en, this message translates to:
  /// **'Tap to reveal'**
  String get tapToReveal;

  /// No description provided for @tapWordsToBuildAnswer.
  ///
  /// In en, this message translates to:
  /// **'Tap words to build your answer'**
  String get tapWordsToBuildAnswer;

  /// No description provided for @tapWordsToBuildSentence.
  ///
  /// In en, this message translates to:
  /// **'Tap words to build the sentence'**
  String get tapWordsToBuildSentence;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get thu;

  /// No description provided for @timeAgoHours.
  ///
  /// In en, this message translates to:
  /// **'{hours}h'**
  String timeAgoHours(int hours);

  /// No description provided for @timeAgoMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m'**
  String timeAgoMinutes(int minutes);

  /// No description provided for @timeSpent.
  ///
  /// In en, this message translates to:
  /// **'Time Spent'**
  String get timeSpent;

  /// No description provided for @timeSpentHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours {minutes} minutes'**
  String timeSpentHoursMinutes(int hours, int minutes);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @totalXP.
  ///
  /// In en, this message translates to:
  /// **'Total XP'**
  String get totalXP;

  /// No description provided for @trueLabel.
  ///
  /// In en, this message translates to:
  /// **'True'**
  String get trueLabel;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get tue;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get typeMessage;

  /// No description provided for @typeWhatYouHear.
  ///
  /// In en, this message translates to:
  /// **'Type what you hear...'**
  String get typeWhatYouHear;

  /// No description provided for @typeYourAnswerHere.
  ///
  /// In en, this message translates to:
  /// **'Type your answer here...'**
  String get typeYourAnswerHere;

  /// No description provided for @unlimitedLessons.
  ///
  /// In en, this message translates to:
  /// **'Unlimited lessons'**
  String get unlimitedLessons;

  /// No description provided for @unlockSuper.
  ///
  /// In en, this message translates to:
  /// **'Unlock Super'**
  String get unlockSuper;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateNow;

  /// No description provided for @visitChillCorner.
  ///
  /// In en, this message translates to:
  /// **'Visit Chill Corner'**
  String get visitChillCorner;

  /// No description provided for @vocabularyReview.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary Review'**
  String get vocabularyReview;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get wed;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The most effective way to learn a new language.'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to InstaLingo'**
  String get welcomeTitle;

  /// No description provided for @whatNext.
  ///
  /// In en, this message translates to:
  /// **'What would you like to do next?'**
  String get whatNext;

  /// No description provided for @wordsLearned.
  ///
  /// In en, this message translates to:
  /// **'Words Learned'**
  String get wordsLearned;

  /// No description provided for @wordsPracticed.
  ///
  /// In en, this message translates to:
  /// **'Words you practiced'**
  String get wordsPracticed;

  /// No description provided for @xpShort.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get xpShort;

  /// No description provided for @xpThisWeek.
  ///
  /// In en, this message translates to:
  /// **'XP This Week'**
  String get xpThisWeek;

  /// No description provided for @xpToGoal.
  ///
  /// In en, this message translates to:
  /// **'{xp} more XP to reach your goal'**
  String xpToGoal(int xp);

  /// No description provided for @youLabel.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get youLabel;

  /// No description provided for @yourLevel.
  ///
  /// In en, this message translates to:
  /// **'Your Level'**
  String get yourLevel;

  /// No description provided for @profile_chooseYourPlan.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Plan'**
  String get profile_chooseYourPlan;

  /// No description provided for @profile_contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get profile_contactUs;

  /// No description provided for @profile_continueWithFree.
  ///
  /// In en, this message translates to:
  /// **'Continue With Free'**
  String get profile_continueWithFree;

  /// No description provided for @profile_culturalInsights.
  ///
  /// In en, this message translates to:
  /// **'Cultural Insights'**
  String get profile_culturalInsights;

  /// No description provided for @profile_culturalInsightsDesc.
  ///
  /// In en, this message translates to:
  /// **'Cultural Insights Desc'**
  String get profile_culturalInsightsDesc;

  /// No description provided for @profile_currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get profile_currentPlan;

  /// No description provided for @profile_dailyGoalMet.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal Met'**
  String get profile_dailyGoalMet;

  /// No description provided for @profile_darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get profile_darkMode;

  /// No description provided for @profile_downloadForOffline.
  ///
  /// In en, this message translates to:
  /// **'Download For Offline'**
  String get profile_downloadForOffline;

  /// No description provided for @profile_downloadForOfflineDesc.
  ///
  /// In en, this message translates to:
  /// **'Download For Offline Desc'**
  String get profile_downloadForOfflineDesc;

  /// No description provided for @profile_emailUs.
  ///
  /// In en, this message translates to:
  /// **'Email Us'**
  String get profile_emailUs;

  /// No description provided for @profile_falseBeginner.
  ///
  /// In en, this message translates to:
  /// **'False Beginner'**
  String get profile_falseBeginner;

  /// No description provided for @profile_faq.
  ///
  /// In en, this message translates to:
  /// **'Faq'**
  String get profile_faq;

  /// No description provided for @profile_faqAnswer1.
  ///
  /// In en, this message translates to:
  /// **'Faq Answer1'**
  String get profile_faqAnswer1;

  /// No description provided for @profile_faqAnswer2.
  ///
  /// In en, this message translates to:
  /// **'Faq Answer2'**
  String get profile_faqAnswer2;

  /// No description provided for @profile_faqAnswer3.
  ///
  /// In en, this message translates to:
  /// **'Faq Answer3'**
  String get profile_faqAnswer3;

  /// No description provided for @profile_faqAnswer4.
  ///
  /// In en, this message translates to:
  /// **'Faq Answer4'**
  String get profile_faqAnswer4;

  /// No description provided for @profile_faqQuestion1.
  ///
  /// In en, this message translates to:
  /// **'Faq Question1'**
  String get profile_faqQuestion1;

  /// No description provided for @profile_faqQuestion2.
  ///
  /// In en, this message translates to:
  /// **'Faq Question2'**
  String get profile_faqQuestion2;

  /// No description provided for @profile_faqQuestion3.
  ///
  /// In en, this message translates to:
  /// **'Faq Question3'**
  String get profile_faqQuestion3;

  /// No description provided for @profile_faqQuestion4.
  ///
  /// In en, this message translates to:
  /// **'Faq Question4'**
  String get profile_faqQuestion4;

  /// No description provided for @profile_feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get profile_feedback;

  /// No description provided for @profile_findFriends.
  ///
  /// In en, this message translates to:
  /// **'Find Friends'**
  String get profile_findFriends;

  /// No description provided for @profile_firstSteps.
  ///
  /// In en, this message translates to:
  /// **'First Steps'**
  String get profile_firstSteps;

  /// No description provided for @profile_followingTitle.
  ///
  /// In en, this message translates to:
  /// **'Following Title'**
  String get profile_followingTitle;

  /// No description provided for @profile_freePlan.
  ///
  /// In en, this message translates to:
  /// **'Free Plan'**
  String get profile_freePlan;

  /// No description provided for @profile_goPremium.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get profile_goPremium;

  /// No description provided for @profile_goalDescription.
  ///
  /// In en, this message translates to:
  /// **'Goal Description'**
  String get profile_goalDescription;

  /// No description provided for @profile_goalFluency.
  ///
  /// In en, this message translates to:
  /// **'Goal Fluency'**
  String get profile_goalFluency;

  /// No description provided for @profile_goalTravel.
  ///
  /// In en, this message translates to:
  /// **'Goal Travel'**
  String get profile_goalTravel;

  /// No description provided for @profile_goalWork.
  ///
  /// In en, this message translates to:
  /// **'Goal Work'**
  String get profile_goalWork;

  /// No description provided for @profile_inTheMorning.
  ///
  /// In en, this message translates to:
  /// **'In The Morning'**
  String get profile_inTheMorning;

  /// No description provided for @profile_keepPracticing.
  ///
  /// In en, this message translates to:
  /// **'Keep Practicing'**
  String get profile_keepPracticing;

  /// No description provided for @profile_lateNight.
  ///
  /// In en, this message translates to:
  /// **'Late Night'**
  String get profile_lateNight;

  /// No description provided for @profile_leaderboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard Title'**
  String get profile_leaderboardTitle;

  /// No description provided for @profile_learnBasicPhrases.
  ///
  /// In en, this message translates to:
  /// **'Learn Basic Phrases'**
  String get profile_learnBasicPhrases;

  /// No description provided for @profile_levelUp.
  ///
  /// In en, this message translates to:
  /// **'Level Up'**
  String get profile_levelUp;

  /// No description provided for @profile_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get profile_monthly;

  /// No description provided for @profile_morningBird.
  ///
  /// In en, this message translates to:
  /// **'Morning Bird'**
  String get profile_morningBird;

  /// No description provided for @profile_mostPopular.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get profile_mostPopular;

  /// No description provided for @profile_motivationCulture.
  ///
  /// In en, this message translates to:
  /// **'Motivation Culture'**
  String get profile_motivationCulture;

  /// No description provided for @profile_motivationFamily.
  ///
  /// In en, this message translates to:
  /// **'Motivation Family'**
  String get profile_motivationFamily;

  /// No description provided for @profile_motivationFun.
  ///
  /// In en, this message translates to:
  /// **'Motivation Fun'**
  String get profile_motivationFun;

  /// No description provided for @profile_motivationTravel.
  ///
  /// In en, this message translates to:
  /// **'Motivation Travel'**
  String get profile_motivationTravel;

  /// No description provided for @profile_motivationWork.
  ///
  /// In en, this message translates to:
  /// **'Motivation Work'**
  String get profile_motivationWork;

  /// No description provided for @profile_myPlan.
  ///
  /// In en, this message translates to:
  /// **'My Plan'**
  String get profile_myPlan;

  /// No description provided for @profile_nextAchievement.
  ///
  /// In en, this message translates to:
  /// **'Next Achievement'**
  String get profile_nextAchievement;

  /// No description provided for @profile_noFollowingYet.
  ///
  /// In en, this message translates to:
  /// **'No Following Yet'**
  String get profile_noFollowingYet;

  /// No description provided for @profile_noFollowingYetMessage.
  ///
  /// In en, this message translates to:
  /// **'No Following Yet Message'**
  String get profile_noFollowingYetMessage;

  /// No description provided for @profile_noFriendsYet.
  ///
  /// In en, this message translates to:
  /// **'No Friends Yet'**
  String get profile_noFriendsYet;

  /// No description provided for @profile_noFriendsYetMessage.
  ///
  /// In en, this message translates to:
  /// **'No Friends Yet Message'**
  String get profile_noFriendsYetMessage;

  /// No description provided for @profile_noLeaderboardData.
  ///
  /// In en, this message translates to:
  /// **'No Leaderboard Data'**
  String get profile_noLeaderboardData;

  /// No description provided for @profile_noLeaderboardDataMessage.
  ///
  /// In en, this message translates to:
  /// **'No Leaderboard Data Message'**
  String get profile_noLeaderboardDataMessage;

  /// No description provided for @profile_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profile_notifications;

  /// No description provided for @profile_offlineTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline Title'**
  String get profile_offlineTitle;

  /// No description provided for @profile_onboardingComplete.
  ///
  /// In en, this message translates to:
  /// **'Onboarding Complete'**
  String get profile_onboardingComplete;

  /// No description provided for @profile_onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Onboarding Title'**
  String get profile_onboardingTitle;

  /// No description provided for @profile_perMonth.
  ///
  /// In en, this message translates to:
  /// **'Per Month'**
  String get profile_perMonth;

  /// No description provided for @profile_plan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get profile_plan;

  /// No description provided for @profile_premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get profile_premium;

  /// No description provided for @profile_proFeatures.
  ///
  /// In en, this message translates to:
  /// **'Pro Features'**
  String get profile_proFeatures;

  /// No description provided for @profile_proFeaturesDesc.
  ///
  /// In en, this message translates to:
  /// **'Pro Features Desc'**
  String get profile_proFeaturesDesc;

  /// No description provided for @profile_proPlan.
  ///
  /// In en, this message translates to:
  /// **'Pro Plan'**
  String get profile_proPlan;

  /// No description provided for @profile_proPlanDesc.
  ///
  /// In en, this message translates to:
  /// **'Pro Plan Desc'**
  String get profile_proPlanDesc;

  /// No description provided for @profile_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_profile;

  /// No description provided for @profile_progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get profile_progress;

  /// No description provided for @profile_progressReset.
  ///
  /// In en, this message translates to:
  /// **'Progress Reset'**
  String get profile_progressReset;

  /// No description provided for @profile_progressResetMessage.
  ///
  /// In en, this message translates to:
  /// **'Progress Reset Message'**
  String get profile_progressResetMessage;

  /// No description provided for @profile_questionXofY.
  ///
  /// In en, this message translates to:
  /// **'Question {x} of {y}'**
  String profile_questionXofY(Object x, Object y);

  /// No description provided for @profile_reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get profile_reminder;

  /// No description provided for @profile_reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get profile_reminderTime;

  /// No description provided for @profile_removeAds.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads'**
  String get profile_removeAds;

  /// No description provided for @profile_removeAdsDesc.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads Desc'**
  String get profile_removeAdsDesc;

  /// No description provided for @profile_savePercent.
  ///
  /// In en, this message translates to:
  /// **'Save {percent}%'**
  String profile_savePercent(Object percent);

  /// No description provided for @profile_section.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get profile_section;

  /// No description provided for @profile_seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get profile_seeAll;

  /// No description provided for @profile_sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get profile_sendFeedback;

  /// No description provided for @profile_skillLevel.
  ///
  /// In en, this message translates to:
  /// **'Skill Level'**
  String get profile_skillLevel;

  /// No description provided for @profile_speakingPractice.
  ///
  /// In en, this message translates to:
  /// **'Speaking Practice'**
  String get profile_speakingPractice;

  /// No description provided for @profile_startFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'Start Free Trial'**
  String get profile_startFreeTrial;

  /// No description provided for @profile_studyPlanDescription.
  ///
  /// In en, this message translates to:
  /// **'Study Plan Description'**
  String get profile_studyPlanDescription;

  /// No description provided for @profile_studyPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Study Plan Title'**
  String get profile_studyPlanTitle;

  /// No description provided for @profile_studyReminder.
  ///
  /// In en, this message translates to:
  /// **'Study Reminder'**
  String get profile_studyReminder;

  /// No description provided for @profile_subscribeNow.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now'**
  String get profile_subscribeNow;

  /// No description provided for @profile_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Subtitle'**
  String get profile_subtitle;

  /// No description provided for @profile_superDescription.
  ///
  /// In en, this message translates to:
  /// **'Super Description'**
  String get profile_superDescription;

  /// No description provided for @profile_support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get profile_support;

  /// No description provided for @profile_travelPhrases.
  ///
  /// In en, this message translates to:
  /// **'Travel Phrases'**
  String get profile_travelPhrases;

  /// No description provided for @profile_troubleshooting.
  ///
  /// In en, this message translates to:
  /// **'Troubleshooting'**
  String get profile_troubleshooting;

  /// No description provided for @profile_tryFreeForDays.
  ///
  /// In en, this message translates to:
  /// **'Try free for {days} days, then {price}'**
  String profile_tryFreeForDays(Object days, Object price);

  /// No description provided for @profile_unlimitedAccess.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Access'**
  String get profile_unlimitedAccess;

  /// No description provided for @profile_unlimitedAccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Access Desc'**
  String get profile_unlimitedAccessDesc;

  /// No description provided for @profile_unlimitedAiConversations.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Ai Conversations'**
  String get profile_unlimitedAiConversations;

  /// No description provided for @profile_unlimitedAiConversationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Ai Conversations Desc'**
  String get profile_unlimitedAiConversationsDesc;

  /// No description provided for @profile_unlimitedLessons.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Lessons'**
  String get profile_unlimitedLessons;

  /// No description provided for @profile_unlimitedLessonsDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Lessons Desc'**
  String get profile_unlimitedLessonsDesc;

  /// No description provided for @profile_unlimitedVocabularyBuilder.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Vocabulary Builder'**
  String get profile_unlimitedVocabularyBuilder;

  /// No description provided for @profile_unlimitedVocabularyBuilderDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Vocabulary Builder Desc'**
  String get profile_unlimitedVocabularyBuilderDesc;

  /// No description provided for @profile_weekdays.
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get profile_weekdays;

  /// No description provided for @profile_weekends.
  ///
  /// In en, this message translates to:
  /// **'Weekends'**
  String get profile_weekends;

  /// No description provided for @profile_whenToStudy.
  ///
  /// In en, this message translates to:
  /// **'When To Study'**
  String get profile_whenToStudy;

  /// No description provided for @profile_workCommunication.
  ///
  /// In en, this message translates to:
  /// **'Work Communication'**
  String get profile_workCommunication;

  /// No description provided for @profile_workVocabulary.
  ///
  /// In en, this message translates to:
  /// **'Work Vocabulary'**
  String get profile_workVocabulary;

  /// No description provided for @profile_writingPractice.
  ///
  /// In en, this message translates to:
  /// **'Writing Practice'**
  String get profile_writingPractice;

  /// No description provided for @profile_xpAndGems.
  ///
  /// In en, this message translates to:
  /// **'Xp And Gems'**
  String get profile_xpAndGems;

  /// No description provided for @profile_xpAndGemsDesc.
  ///
  /// In en, this message translates to:
  /// **'Xp And Gems Desc'**
  String get profile_xpAndGemsDesc;

  /// No description provided for @profile_xpEarnedToday.
  ///
  /// In en, this message translates to:
  /// **'Xp Earned Today'**
  String get profile_xpEarnedToday;

  /// No description provided for @profile_youEarned.
  ///
  /// In en, this message translates to:
  /// **'You Earned'**
  String get profile_youEarned;

  /// No description provided for @profile_yourStreak.
  ///
  /// In en, this message translates to:
  /// **'Your Streak'**
  String get profile_yourStreak;

  /// No description provided for @progressToNextLevel.
  ///
  /// In en, this message translates to:
  /// **'Progress To Next Level'**
  String get progressToNextLevel;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording'**
  String get recording;

  /// No description provided for @removeAds.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads'**
  String get removeAds;

  /// No description provided for @saveAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save And Continue'**
  String get saveAndContinue;

  /// No description provided for @searchPosts.
  ///
  /// In en, this message translates to:
  /// **'Search Posts'**
  String get searchPosts;

  /// No description provided for @sectionX.
  ///
  /// In en, this message translates to:
  /// **'Section {x}'**
  String sectionX(Object x);

  /// No description provided for @seeAllAchievements.
  ///
  /// In en, this message translates to:
  /// **'See All Achievements'**
  String get seeAllAchievements;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @speakNow.
  ///
  /// In en, this message translates to:
  /// **'Speak Now'**
  String get speakNow;

  /// No description provided for @startSpeaking.
  ///
  /// In en, this message translates to:
  /// **'Start Speaking'**
  String get startSpeaking;

  /// No description provided for @streakTitle.
  ///
  /// In en, this message translates to:
  /// **'Streak Title'**
  String get streakTitle;

  /// No description provided for @studyNow.
  ///
  /// In en, this message translates to:
  /// **'Study Now'**
  String get studyNow;

  /// No description provided for @subscribeNow.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now'**
  String get subscribeNow;

  /// No description provided for @superMarket.
  ///
  /// In en, this message translates to:
  /// **'Super Market'**
  String get superMarket;

  /// No description provided for @swipeToContinue.
  ///
  /// In en, this message translates to:
  /// **'Swipe To Continue'**
  String get swipeToContinue;

  /// No description provided for @tapToListen.
  ///
  /// In en, this message translates to:
  /// **'Tap To Listen'**
  String get tapToListen;

  /// No description provided for @tapToSpeak.
  ///
  /// In en, this message translates to:
  /// **'Tap To Speak'**
  String get tapToSpeak;

  /// No description provided for @technicalIssues.
  ///
  /// In en, this message translates to:
  /// **'Technical Issues'**
  String get technicalIssues;

  /// No description provided for @totalLessons.
  ///
  /// In en, this message translates to:
  /// **'Total Lessons'**
  String get totalLessons;

  /// No description provided for @unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimited;

  /// No description provided for @unlockAllFeatures.
  ///
  /// In en, this message translates to:
  /// **'Unlock All Features'**
  String get unlockAllFeatures;

  /// No description provided for @unlockNow.
  ///
  /// In en, this message translates to:
  /// **'Unlock Now'**
  String get unlockNow;

  /// No description provided for @upgradeToPro.
  ///
  /// In en, this message translates to:
  /// **'Upgrade To Pro'**
  String get upgradeToPro;

  /// No description provided for @upgradeToSuper.
  ///
  /// In en, this message translates to:
  /// **'Upgrade To Super'**
  String get upgradeToSuper;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @viewLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'View Leaderboard'**
  String get viewLeaderboard;

  /// No description provided for @vocabulary.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get vocabulary;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @weeklyGoal.
  ///
  /// In en, this message translates to:
  /// **'Weekly Goal'**
  String get weeklyGoal;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @wordOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'Word Of The Day'**
  String get wordOfTheDay;

  /// No description provided for @xpEarned.
  ///
  /// In en, this message translates to:
  /// **'Xp Earned'**
  String get xpEarned;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @youAreOffline.
  ///
  /// In en, this message translates to:
  /// **'You Are Offline'**
  String get youAreOffline;

  /// No description provided for @yourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your Answer'**
  String get yourAnswer;

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get yourProgress;

  /// No description provided for @onboarding_learningGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your goal?'**
  String get onboarding_learningGoalTitle;

  /// No description provided for @onboarding_learningGoalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This helps us tailor your learning experience.'**
  String get onboarding_learningGoalSubtitle;

  /// No description provided for @onboarding_examPrep.
  ///
  /// In en, this message translates to:
  /// **'Prepare for an exam'**
  String get onboarding_examPrep;

  /// No description provided for @onboarding_examPrepDesc.
  ///
  /// In en, this message translates to:
  /// **'Structured lessons, mock tests, timed practice. Track your predicted score.'**
  String get onboarding_examPrepDesc;

  /// No description provided for @onboarding_justForFun.
  ///
  /// In en, this message translates to:
  /// **'Just for fun'**
  String get onboarding_justForFun;

  /// No description provided for @onboarding_justForFunDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn at your own pace. No tests, no pressure. Just pick up the language naturally.'**
  String get onboarding_justForFunDesc;

  /// No description provided for @onboarding_examTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Which exam?'**
  String get onboarding_examTypeTitle;

  /// No description provided for @onboarding_examTypeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick the {lang} exam you\'re working toward.'**
  String onboarding_examTypeSubtitle(String lang);

  /// No description provided for @onboarding_japanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get onboarding_japanese;

  /// No description provided for @onboarding_korean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get onboarding_korean;

  /// No description provided for @onboarding_examLevelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get onboarding_examLevelBeginner;

  /// No description provided for @onboarding_examLevelElementary.
  ///
  /// In en, this message translates to:
  /// **'Elementary'**
  String get onboarding_examLevelElementary;

  /// No description provided for @onboarding_examLevelBeginnerElementary.
  ///
  /// In en, this message translates to:
  /// **'Beginner–Elementary'**
  String get onboarding_examLevelBeginnerElementary;

  /// No description provided for @onboarding_examWordsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} words'**
  String onboarding_examWordsCount(String count);

  /// No description provided for @onboarding_examSectionsJLPT.
  ///
  /// In en, this message translates to:
  /// **'Vocab, Grammar, Reading, Listening'**
  String get onboarding_examSectionsJLPT;

  /// No description provided for @onboarding_examSectionsTOPIK.
  ///
  /// In en, this message translates to:
  /// **'Listening, Reading'**
  String get onboarding_examSectionsTOPIK;

  /// No description provided for @keepPracticing.
  ///
  /// In en, this message translates to:
  /// **'Keep practicing!'**
  String get keepPracticing;

  /// No description provided for @kanjiReference.
  ///
  /// In en, this message translates to:
  /// **'Kanji Reference'**
  String get kanjiReference;

  /// No description provided for @kanaReference.
  ///
  /// In en, this message translates to:
  /// **'Kana Charts'**
  String get kanaReference;

  /// No description provided for @hiraganaChart.
  ///
  /// In en, this message translates to:
  /// **'Hiragana'**
  String get hiraganaChart;

  /// No description provided for @katakanaChart.
  ///
  /// In en, this message translates to:
  /// **'Katakana'**
  String get katakanaChart;

  /// No description provided for @examCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Mock Test Complete!'**
  String get examCompleteTitle;

  /// No description provided for @yourScore.
  ///
  /// In en, this message translates to:
  /// **'Your score'**
  String get yourScore;

  /// No description provided for @predictedLevel.
  ///
  /// In en, this message translates to:
  /// **'Predicted level'**
  String get predictedLevel;

  /// No description provided for @profile_tts.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation (TTS)'**
  String get profile_tts;

  /// No description provided for @profile_ttsDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap words to hear pronunciation'**
  String get profile_ttsDesc;

  /// No description provided for @studyReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Time to practice!'**
  String get studyReminderBody;

  /// No description provided for @jlptN5Label.
  ///
  /// In en, this message translates to:
  /// **'JLPT N5'**
  String get jlptN5Label;

  /// No description provided for @jlptN4Label.
  ///
  /// In en, this message translates to:
  /// **'JLPT N4'**
  String get jlptN4Label;

  /// No description provided for @onboarding_examLevelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get onboarding_examLevelIntermediate;

  /// No description provided for @onboarding_examLevelUpperIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Upper Intermediate'**
  String get onboarding_examLevelUpperIntermediate;

  /// No description provided for @onboarding_examLevelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get onboarding_examLevelAdvanced;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'ja',
        'ko',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
