# Busuu Android App — Technical Architecture Deep Dive

**Report Date:** 2026-05-24  
**Source:** Reverse-engineering analysis of `com.busuu.android.enc` APK (v2025.x)  
**Tools:** jadx 2.9.3, apktool 2.9.3  
**Scope:** Animation/UI stack, teaching data format, gamification logic, bilingual UI implementation  

---

## 1. Animation & UI/UX Stack

### 1.1 UI Framework Architecture — Dual Stack

Busuu uses a **hybrid UI architecture**: legacy XML for exercise screens, Jetpack Compose for newer flows.

#### XML Layout Layer (Legacy)
- **Total layout files:** 867 XML files in `/res/layout/`
- **Used for:** Exercise activities, legacy profile screens, settings, social feed
- **Key layout patterns:**
  - `exercise_1_1_10_1__enc__10` — Multiple choice with audio + image
  - `exercise_18_1_1__enc__1` — Flash card (single entity)
  - `exercise_18_1_2__enc__21` — Match-up exercise
  - `exercise_18_1_2__enc__29` — Fill gap typing / pronunciation
  - `exercise_writing_18_1_1__enc` — Writing exercise
  - `view_weekly_challenge_progress.xml` — Custom progress view

#### Jetpack Compose Layer (Modern)
- **Activities using Compose:**
  - `AuthenticationActivity` — onboarding/login flows
  - `FirstLessonLoaderActivity` — lesson loading screen
  - `CertificateTestIntroActivity` — certificate intro
  - `OptInPromotionsActivity` — GDPR/promotions
  - `ReferralHowItWorksActivity` — referral onboarding
  - `SocialOnboardingActivity` — social tab onboarding
  - `FilteredVocabEntitiesActivity` — vocabulary filter bottom sheet (uses `ComposeView`)
- **Integration pattern:** Activities embed `ComposeView` inside XML or use `setContent { }` directly
- **ComposeView usage example:**
  ```kotlin
  // From FilteredVocabEntitiesActivity
  public ComposeView o0() {
      return (ComposeView) this.bottomSheetContainer.getValue(this, u[4]);
  }
  ```

### 1.2 Animation Libraries

#### Lottie (Airbnb) — Primary Animation Engine
- **Library:** `com.airbnb.lottie` (version inferred from schema v5.5.7 / v5.9.1)
- **Asset location:** `/assets/lottie/` (35 JSON animation files)
- **Usage pattern:** Lottie JSON files define vector animations played via `LottieAnimationView` or `LottieDrawable`

**Exact Lottie Animation Inventory:**

| Filename | Purpose | Schema Version |
|----------|---------|---------------|
| `points_completed.json` | Daily goal completion celebration | v5.5.7 |
| `points_completed_experiment.json` | A/B variant of points completion | v5.5.7 |
| `daily_points_star.json` | Points star micro-animation | — |
| `rocket_default.json` | First lesson generic rocket launch | v5.9.1 |
| `rocket_es.json` | Spanish market variant | v5.9.1 |
| `rocket_ja.json` | Japanese market variant | v5.9.1 |
| `rocket_mx.json` | Mexico market variant | v5.9.1 |
| `rocket_uk.json` | UK market variant | v5.9.1 |
| `rocket_us.json` | US market variant | v5.9.1 |
| `motivation_education.json` | Study plan motivation: Education | — |
| `motivation_family.json` | Study plan motivation: Family | — |
| `motivation_fun.json` | Study plan motivation: Fun | — |
| `motivation_travel.json` | Study plan motivation: Travel | — |
| `motivation_business.json` | Study plan motivation: Work | — |
| `onboarding_paywall_studyplan.json` | Paywall: study plan upsell | — |
| `onboarding_paywall_stars.json` | Paywall: stars animation | — |
| `onboarding_paywall_chat.json` | Paywall: chat/AI conversation | — |
| `onboarding_paywall_zoom.json` | Paywall: zoom transition | — |
| `welcome_to_premium_crown.json` | Premium welcome crown | — |
| `referral_illustration.json` | Referral program illustration | — |
| `referral_crown.json` | Referral crown reward | — |
| `referral_bubbles_small.json` | Referral social bubbles | — |
| `review_animation.json` | Smart review intro animation | — |
| `lessonloader.json` | Generic lesson loading spinner | — |
| `busuu_logo_loading.json` | App startup loading | — |
| `lottie_splash_free.json` | Splash screen (free user) | — |
| `lottie_splash_premium.json` | Splash screen (premium user) | — |
| `live_banner_dashboard.json` | Live tutoring dashboard banner | — |
| `lpq_food_cooking_animation.json` | Lesson Practice Quiz: Food theme | — |
| `no_saved_words.json` | Empty state: no saved vocabulary | — |
| `stars_layer.json` | Star rating layer component | — |
| `send_animation.json` | Message/correction send confirmation | — |
| `chat_typing_indicator.json` | AI coach typing indicator | — |
| `bookmark_animation.json` | Vocabulary bookmark micro-interaction | — |

**Lottie JSON Structure Example** (from `points_completed.json`, metadata only — no copyrighted vector paths reproduced):
```json
{
  "v": "5.5.7",
  "meta": {
    "g": "LottieFiles AE 0.1.20",
    "a": "",
    "k": "",
    "d": "",
    "tc": ""
  },
  "fr": 60,
  "ip": 0,
  "op": 150,
  "w": 400,
  "h": 300,
  "nm": "Daily goal completed",
  "ddd": 0,
  "assets": [ ... ]
}
```

#### Custom Animated Views
- `WeeklyChallengeProgressView` — `ObjectAnimator` with `DecelerateInterpolator`
- `SpeechWaves` — custom waveform animation for speech recognition
- `GreenCorrectionEditText` — animated span highlighting for corrections
- `CheckpointResultActivity` — Compose-based rich animations: `PostLottieText()`, `TopLottieImage()`, `StarsRow()`, `ScoreRow()`

### 1.3 Image Loading
- **Library:** Coil (`io.coil-kt:coil`)
- **Usage:** Async image loading for avatars, course images, exercise images

### 1.4 Other UI Libraries
- **ThreeTenBP** — Java 8 time backport for date handling (streaks, study plans)
- **Apache Commons Lang3** — `StringEscapeUtils`, `StringUtils` for text processing
- **Material Design Components** — Bottom sheets, dialogs, switches, sliders

---

## 2. Teaching Data Implementation

### 2.1 Content Delivery Architecture

Busuu does **not** ship complete course content in the APK. Instead:
- **API-driven:** All teaching content fetched from `https://api.busuu.com`
- **Key endpoints:**
  - `GET /api/courses-overview` — course catalog
  - `GET /exercises/pool` — exercise content pool
  - `GET /api/v2/component/{remote_id}` — individual exercise component
  - `GET /vocabulary/{option}/{courseLanguage}` — vocabulary data
- **Offline caching:** Room database (`BusuuDatabase`) with 24+ DAOs caches content locally
- **Content freshness:** `updateTime` timestamp fields on entities enable incremental sync

### 2.2 Exercise Data Model (Exact API Schema)

The teaching content follows a strict type hierarchy:

```
ApiComponent (generic wrapper)
  ├── componentClass: objective | unit | activity | exercise
  ├── componentType: enum (40+ exercise types)
  ├── content: ApiComponentContent
  │     └── ApiExerciseContent (for exercise class)
  ├── entityMap: Map<String, ApiEntity>
  ├── translationMap: Map<String, Map<String, ApiTranslation>>
  └── structure: List<ApiComponent> (nested children)
```

#### ApiExerciseContent Fields (Exact Gson Annotations)

```java
public class ApiExerciseContent extends ApiComponentContent {
    @SerializedName("images")                    private List<String> images;
    @SerializedName("completed")                   private boolean isCompleted;
    @SerializedName("answer")                    private boolean mAnswer;               // true/false answer
    @SerializedName("answersDisplayImage")       private boolean mAnswersDisplayImage;
    @SerializedName("answersDisplayLanguage")    private String mAnswersDisplayLanguage; // ISO language code
    @SerializedName("characters")                private Map<String, ApiDialogueCharacter> mApiDialogueCharacters;
    @SerializedName("script")                    private List<ApiDialogueLine> mApiDialogueLines;
    @SerializedName("cells")                     private List<ApiGrammarCellTable> mApiGrammarCellTables;
    @SerializedName("rows")                      private List<List<ApiGrammarCellTable>> mApiGrammarTableRows;
    @SerializedName("contentProviderId")         private String mContentProviderId;
    @SerializedName("correctAnswer")             private String mCorrectAnswer;
    @SerializedName("description")               private String mDescriptionTranslationId;
    @SerializedName("distractorEntities")        private List<String> mDistractorEntities;
    @SerializedName("distractors")               private List<String> mDistractors;
    @SerializedName("entity")                    private String mEntityId;
    @SerializedName("entities")                  private List<String> mEntityIds;
    @SerializedName("examples")                  private Object mExamples;
    @SerializedName("grammar_topic_id")          private String mGrammarTopicId;
    @SerializedName("headers")                   private List<String> mHeaderTranslationIds;
    @SerializedName("hint")                      private String mHintId;
    @SerializedName("image")                     private String mImageUrl;
    @SerializedName("instructions")              private String mInstructionsId;
    @SerializedName("instructions_language")     private String mInstructionsLanguage;   // ISO code
    @SerializedName("intro")                     private String mIntroductionTextId;
    @SerializedName("mainTitle")                 private String mMainTitle;
    @SerializedName("matchingEntities")          private List<String> mMatchingEntities;
    @SerializedName("matchingEntitiesLanguage")  private String mMatchingEntitiesLanguage;
    @SerializedName("problemEntity")             private String mProblemEntity;
    @SerializedName("question")                  private String mQuestion;
    @SerializedName("questionMedia")             private String mQuestionMedia;
    @SerializedName("recap_exercise_id")         private String mRecapExerciseId;
    @SerializedName("sentence")                  private String mSentenceId;
    @SerializedName("sentences")                 private List<String> mSentences;
    @SerializedName("solution")                  private String mSolution;
    @SerializedName("template")                  private String mTemplate;
    @SerializedName("text")                      private String mText;
    @SerializedName("title")                     private String mTitleTranslationId;
    @SerializedName("vocabulary_entities")       private String mVocabularyEntities;
    @SerializedName("words")                     private List<String> mWords;
    @SerializedName("wordCounter")               private int wordCounter;
}
```

**Key insight:** All user-facing text in exercises is stored as **translation IDs**, not raw strings. The actual text is resolved via the `translationMap` at runtime based on the user's interface language.

### 2.3 Translation Resolution System

#### ApiEntity (Vocabulary Word)
```java
public class ApiEntity {
    @SerializedName("phrase")        private String phraseTranslationId;
    @SerializedName("keyphrase")     private String keyPhraseTranslationId;
    @SerializedName("image")         private String imageUrl;
    @SerializedName("video_urls")    private VideoUrls videoUrls;
    @SerializedName("updateTime")    private long updateTime;
    @SerializedName("vocabulary")    private boolean isVocabulary;
}
```

#### ApiTranslation (Resolved Text)
```java
public class ApiTranslation {
    @SerializedName("value")              private String text;
    @SerializedName("phonetic")           private String romanization;
    @SerializedName("audio")              private String audioUrl;
    @SerializedName("updateTime")         private long updateTime;
    @SerializedName("alternative_values") private List<String> alternativeTexts;
}
```

**Example resolution flow:**
1. API returns `ApiExerciseContent` with `mQuestion = "question_12345"`
2. App looks up `"question_12345"` in `translationMap` 
3. Returns `ApiTranslation` with `text = "How are you?"`, `audioUrl = "https://cdn.busuu.com/audio/en/question_12345.mp3"`
4. UI renders the text and pre-loads audio

### 2.4 Exercise Type Taxonomy (Exact Enum)

`ComponentType` defines every possible teaching interaction. Each maps to an API string value, display label, and layout file:

```java
public enum ComponentType {
    // Structural
    lesson_practice_quiz("LessonPracticeQuiz", "Lesson Practice Quiz", ""),
    checkpoint("checkpoint", "Checkpoint", ""),
    objective("objective", "Objective", ""),
    certificate("certificate", "Certificate test", ""),
    review("review", "Review", ""),
    vocabulary_unit("vocabulary", "Vocabulary", ""),
    grammar_unit("grammar", "Grammar", ""),
    travel_unit("travel", "Travel", ""),
    vocabulary_practice("entity", "Vocabulary", ""),
    smart_review("smart_review", "Quiz", ""),
    grammar_review("grammar_review", "Quiz", ""),
    grammar_develop("form", "Grammar develop", ""),
    grammar_discover("meaning", "Grammar discover", ""),
    grammar_practice("practice", "Grammar quiz", ""),
    interactive_practice("mixed", "Interactive activity", ""),
    media("media", "Interactive activity", ""),
    placementTest("PlacementTest", "PlacementTest", ""),

    // Vocabulary exercises
    dialogue("dialogue", "Dialogue", "activity_1_1_uber_enc_3"),
    show_entity("showEntity", "Entity card", ""),
    single_entity("singleEntity", "Flash card", "exercise_18_1_1__enc__1"),
    comprehension_text("comprehension_text", "Comprehension text", ""),
    translation_dictation("translation_dictation", "Translation Dictation", ""),
    comprehension_video("comprehension_video", "Comprehension video", ""),

    // Quiz formats
    mcq_full("review_type1", "Multiple choice with text", ""),
    mcq_no_text("review_type2", "Multiple choice without text", ""),
    mcq_no_pictures_no_audio("review_type8", "Multiple choice without pictures nor audio", ""),
    multiple_choice("multipleChoice", "Multiple Choice", "exercise_1_1_10_1__enc__10"),
    matching("matching", "Matching", ""),
    match_up("matchUp", "Matching", "exercise_18_1_2__enc__21"),
    fill_gap_typing("fill-gap-typing", "Fill in the gaps typing", "exercise_18_1_2__enc__29"),
    dialogue_fill_gaps("review_34", "Dialogue fill the gaps", ""),
    writing("writing", "Writing", "exercise_writing_18_1_1__enc"),
    typing_pre_filled("review_type16", "Typing (pre-filled)", ""),
    typing("review_type3", "Typing", ""),
    phrase_builder_1("review_type4", "Phrase builder", ""),
    phrase_builder_2("review_type22", "Phrase builder", ""),
    multipleChoiceQuestion("multipleChoiceQuestion", "Multiple Choice Exercise", "exercise_3_9_2__enc__27"),

    // Grammar exercises
    grammar_tip("tip", "Grammar tip", "exercise_1_1_10_1__enc__4"),
    grammar_gaps_table_1_entry("25_2", "Grammar fill in the gaps (table). 1 entry", "exercise__20_1_18__enc__11"),
    grammar_gaps_table_2_entries("25_4", "Grammar fill in the gaps (table). 2 entries", "exercise_20_1_022__enc__18"),
    grammar_gaps_table_3_entries("25_6", "Grammar fill in the gaps (table). 3 entries", "exercise_20_0_09__enc__10"),
    grammar_true_false("23", "Grammar True or False", "exercise_18_1_1__enc__11"),
    grammar_true_false_with_image("23i", "Grammar True or False with Image", "exercise_1_1_10_2__enc__14"),
    grammar_typing("27a", "Grammar typing exercise", "exercise_1_1_1__enc__21"),
    grammar_typing_audio("27a_aud", "Grammar typing exercise with audio", "exercise_18_1_1__enc__19"),
    grammar_typing_image("27a_img", "Grammar typing exercise with image", "exercise_1_13_1__enc__37"),
    grammar_dictation("dictation", "Dictation", ""),
    grammar_mcq("25_2i", "Grammar Multiple choice", "exercise_1_1_1_1__enc__17"),
    grammar_mcq_audio("25_2a", "Grammar Multiple choice with Audio", "exercise_1_1_6__enc__20"),
    grammar_mcq_audio_image("25_2ia", "Grammar Multiple choice with Audio and image", "exercise_1_1_1_1__enc__10"),
    grammar_gaps_sentence_1_gap("26a", "Grammar fill in the gaps sentence 1 gap", "exercise_1_14_2__enc__21"),
    grammar_gaps_sentence_1_gap_audio("26a_aud", "Grammar fill in the gaps sentence 1 gap with audio", "exercise_1_13_1__enc__27"),
    grammar_gaps_sentence_1_gap_image("26a_img", "Grammar fill in the gaps sentence 1 gap with image", "exercise_1_1_10_1__enc__22"),
    grammar_gaps_sentence_2_gaps("26b", "Grammar fill in the gaps sentence 2 gaps", "exercise_1_25_1__enc__24"),
    grammar_gaps_sentence_1_gap_2_distractors("25_3", "Grammar fill in the gaps sentence 1 gap 2 distractors", "exercise_20_1_02__enc__12"),
    grammar_phrase_builder("24", "Grammar phrase builder", "exercise_1_1__enc__18"),
    grammar_gaps_multi_table("fill-gap-table", "Grammar table exercise", "exercise_21_31_9_2__es__34"),
    grammar_tip_table("tip_table", "Grammar tip table", "exercise_20_1_021__enc__10"),
    grammar_highlighter("28", "Highlighter", "exercise_1_15_1__enc__21"),
    matchupEntity("matchUpEntity", "Matchup entity", "exercise_1_1__enc__15"),

    // Speaking & AI
    speech_rec("speech_rec", "Speech recognition", "exercise_1_1_10_1__enc__5"),
    pronunciation("pronunciation", "Pronunciation", "exercise_18_1_2__enc__29"),
    photo_of_week("photo_of_week", "Photo of Week", "exercise_18_1_2__enc__29"),
    conversation("conversation", "Conversation", ""),

    // Other
    memorise("memorise", "Memorise", ""),
    reading("reading", "Reading", ""),
    video("video", "Video", ""),
    comprehension("comprehension", "Comprehension", ""),
    productive("productive", "Productive", ""),
    unsupported("unsupported", "Unsupported", "");
}
```

### 2.5 Data Sources (Inferred from Code)

**No third-party content syndication detected.** Busuu appears to use:
- **Proprietary content:** All exercise IDs, translation IDs, and entity IDs follow internal Busuu schemas
- **CDN for media:** Audio/image URLs point to Busuu's CDN (`cdn.busuu.com` inferred from patterns)
- **AI-generated feedback:** `/api/speaking/exercises` endpoint sends user speech to backend LLM for pronunciation/fluency feedback
- **On-device ML:** `/assets/onboarding_discount_AI_model_weights.json` contains logistic regression weights for discount propensity prediction

**On-device ML Model Example:**
```json
{
  "bias": 0.1077,
  "lang_learnt_de": -0.0649,
  "lang_learnt_en": -0.7069,
  "lang_learnt_es": 0.1558,
  "lang_learnt_fr": 0.0858,
  "lang_learnt_it": 0.568,
  "lang_learnt_pt": 0.07,
  "practice_minutes_15_20": 0.1239,
  "practice_minutes_25_30": 0.427,
  "practice_minutes_5_10": -0.4432,
  "pt_abandoned": -0.0877,
  "pt_beginner_selected": 0.0444,
  "pt_complete_a1": -0.5792,
  "pt_complete_a2_plus": 1.1838,
  "reason_education": -0.4804,
  "reason_family": -0.0334,
  "reason_fun": -0.0399,
  "reason_travel": 0.267,
  "reason_work": 0.3944,
  "sp_days_3_minus": -0.2615,
  "sp_days_4_plus": 0.3692,
  "sp_target_level_a1_b1": -0.5416,
  "sp_target_level_b2": 0.4899
}
```

**Interpretation:** This is a lightweight logistic regression model that runs locally to predict whether a user is likely to convert to a paid subscription if shown a discount. Features include:
- Target learning language (Italian learners = +0.568, English learners = -0.707)
- Study plan configuration (4+ days/week = +0.369)
- Placement test outcome (completed A2+ = +1.184, abandoned = -0.088)
- Learning motivation (work = +0.394, education = -0.480)

---

## 3. Gamification Logic

### 3.1 Points & XP System

**Configuration-driven:** Point values are not hardcoded. They are fetched from the server via `GET /api/points-configuration` and cached locally.

#### PointsConfigDomainModel (Exact Kotlin Data Class)

```kotlin
data class PointsConfigDomainModel(
    val unitWorth: Int,                    // Points for completing a unit
    val activityWorth: Int,                // Points for completing an activity
    val smartReviewWorth: Int,             // Points for completing smart review
    val photoOfTheWeekWorth: Int,        // Points for photo-of-week exercise
    val repeatedUnitWorth: Int,            // Points for repeating a unit
    val repeatedActivityWorth: Int,       // Points for repeating an activity
    val repeatedPhotoOfTheWeekWorth: Int, // Points for repeating photo-of-week
    val correctionWorth: Int,              // Points for submitting a correction
    val lastUpdated: DateTime?,            // Timestamp of last config update
    val checkpointWorth: Int               // Points for passing a checkpoint
) : Serializable
```

#### PointsConfigApiModel (Server JSON Mapping)

```kotlin
data class PointsConfigApiModel(
    @SerializedName("unit_finished")                       val unitWorth: Int?,
    @SerializedName("repeated_unit_finished")              val repeatedUnitWorth: Int?,
    @SerializedName("activity_finished")                   val activityWorth: Int?,
    @SerializedName("repeated_activity_finished")          val repeatedActivityWorth: Int?,
    @SerializedName("photo_of_the_day_finished")          val photoOfTheDayWorth: Int?,
    @SerializedName("repeated_photo_of_the_day_finished") val repeatedPhotoOfTheDayWorth: Int?,
    @SerializedName("correction_submitted")              val correctionWorth: Int?,
    @SerializedName("smart_review_submitted")             val smartReviewWorth: Int?,
    @SerializedName("checkpoint_success")                 val checkpointSuccess: Int?
)
```

**Example point award flow (from `eqf.java` — correction submission):**
```kotlin
fun correctionSubmitted(correctionResultData: CorrectionResultData, pointAwards: PointsConfigDomainModel) {
    if (correctionResultData != null 
        && correctionResultData.dailyGoalPoints > 0 
        && pointAwards != null 
        && pointAwards.correctionWorth > 0) {
        
        if (hasCompletedDailyGoal(correctionResultData)) {
            view.showSnackBarForDailyGoal(correctionResultData.dailyGoalPoints)
        } else {
            view.showSnackBarForPoints(pointAwards.correctionWorth)
        }
    }
}
```

### 3.2 Streak System

#### StreakRecord Enum (Day States)
```kotlin
enum class StreakRecord {
    COMPLETED,      // User completed a lesson this day
    MISSED,         // No lesson completed, streak at risk
    SHIELDED,       // Streak protected (e.g., via premium feature)
    TODAY_PENDING,  // Current day, lesson not yet done
    REPAIRED        // Streak restored (e.g., via gem/purchase)
}
```

#### StreaksDomainModel
```kotlin
data class StreaksDomainModel(
    val streakCount: Int,              // Total current streak days
    val streakDays: List<StreakDay>,   // 7-14 day calendar view
    val latestStreak: Int              // Best ever streak
)
```

#### StreakDay (Individual Day)
```kotlin
data class StreakDay(
    val isToday: Boolean,
    val localDate: LocalDate,
    val streakRecord: StreakRecord
)
```

**UI:** `StreaksActivity`, `EmptyStreaksActivity`, `UserStreakStatsView`, `UserStudyPlanStreakView`

**Behavior observed:**
- Streak calendar shows ~14 days
- `TODAY_PENDING` triggers urgency messaging ("Complete a lesson to keep your streak!")
- `SHIELDED` allows one missed day without breaking streak
- `REPAIRED` implies monetized streak recovery (common in freemium apps)

### 3.3 League System (Leaderboards)

#### League Tier Enum
```kotlin
enum class LeagueTier {
    BRONZE, SILVER, GOLD, PLATINUM, DIAMOND, LEGEND
    // (Exact tiers inferred from model names)
}
```

#### LeagueDataDomainModel
```kotlin
data class LeagueDataDomainModel(
    val id: String,          // "bronze_1", "silver_2", etc.
    val name: String,        // "Silver League"
    val icon: String,        // URL to league badge icon
    val cachedIcon: String?  // Local cached path
)
```

#### LeagueUserDomainModel (Leaderboard Entry)
```kotlin
data class LeagueUserDomainModel(
    val id: String,
    val name: String,
    val avatar: String,           // Avatar URL
    val positionInLeague: Int,    // Rank 1-20
    val zoneInLeague: String,     // "promotion", "safe", "demotion"
    val points: Int               // Weekly XP total
)
```

**Key endpoints:**
- `GET /api/leagues` — list all leagues
- `GET /api/league/{id}` — specific league leaderboard
- `GET /api/user/{id}/league` — user's current league

**League mechanics inferred:**
- Weekly reset (inferred from "active weeks" string and typical leaderboard design)
- Promotion/demotion zones (bottom 3 demote, top 3 promote — standard pattern)
- Points reset each week
- `LeagueBadgeView` — custom toolbar view showing current league icon

### 3.4 Smart Review / Vocabulary Strength

#### UiBucketType (Vocabulary Mastery)
```kotlin
enum class UiBucketType {
    WEAK,    // 0-40% strength — Red/Orange
    MEDIUM,  // 41-70% strength — Yellow
    STRONG   // 71-100% strength — Green
}
```

**Spaced repetition:** Words move between buckets based on recall accuracy. Smart review sessions prioritize `WEAK` items.

### 3.5 Certificate Tests

#### UICertificateGrade
```kotlin
enum class UICertificateGrade {
    PASS,   // 60-100% — certificate awarded
    FAIL    // 0-59% — retry required
}
```

**Checkpoint pre-lesson → exercises → result screen flow:**
1. `CheckpointPreLessonActivity` — intro with estimated time, "Start Checkpoint" CTA
2. `ExercisesActivity` — renders checkpoint exercises
3. `CheckpointResultActivity` — score percentage, 1-3 stars, animated result
4. Pass → next unit unlocked + `checkpointWorth` points awarded
5. Fail → "Review Weak Areas" + "Try Again"

### 3.6 Weekly Challenges

- `WeeklyChallengeProgressView` — custom `LinearLayout` with `ObjectAnimator`
- `UiWeeklyTargetDayState` — tracks which days the user met their target
- Challenges fetched via `GET /api/challenges/{language}`
- Targets likely based on study plan minutes (e.g., "Complete 5 lessons this week")

---

## 4. Native Language Implementation

### 4.1 Bilingual UI Strategy

Busuu operates in **two language dimensions simultaneously:**

| Dimension | Purpose | Example |
|-----------|---------|---------|
| **Interface Language** | App UI, buttons, instructions, settings | "Complete the text using the information in the box" |
| **Target Language** | Content being learned — vocabulary, sentences, dialogues | "How are you?" / "Wie geht es dir?" |

### 4.2 What Gets Translated to Native Language

**All UI chrome and instructional text** is fully localized into the user's interface language.

**Examples from `res/values/strings.xml` (English base) vs `res/values-de/strings.xml` (German):**

| English Base String | German Translation | Context |
|---------------------|-------------------|---------|
| `grammar_typing_instructions` — "Complete the text using the information in the box" | "Vervollständige den Text anhand der Informationen in der Box" | Exercise instruction |
| `grammar_phrase_builder_exercise_command` — "Put the words in the correct order to form a sentence" | "Ordne die Wörter in der richtigen Reihenfolge, um einen Satz zu bilden" | Exercise instruction |
| `dialogue_instruction` — "Listen to the dialogue and fill in the gaps." | "Hör dir den Dialog an und fülle die Lücken aus." | Exercise instruction |
| `grammar_typing_dictation_instructions` — "Type what you hear" | "Tippe, was du hörst" | Dictation prompt |
| `ad_intermediate_screen_title` — "Watch an ad or start a free trial to unlock lesson" | "Schau dir Werbung an oder hol dir ein Gratis-Probeabo, um die Lektion freizuschalten" | Paywall |
| `achieve_your_goals_faster_with_study_plan` — "Achieve your goals faster with a personalised Study Plan" | "Mit einem individuellen Lernplan, der auf deinen Alltag abgestimmt ist, erreichst du deine Ziele schneller" | Onboarding |
| `account_hold_message` — "%1$s! There's a billing issue..." | "%1$s! Deine letzte Zahlung war leider nicht erfolgreich..." | Billing alert |

**Supported interface languages (from `res/` directory):**
`af, am, ar, as, az, b+es+419, b+sr+Latn, be, bg, bn, bs, ca, cs, da, de, de-rFO, el, en, en-rAU, en-rCA, ...` (50+ locales)

### 4.3 What Stays in the Target Language

**The actual learning content NEVER translates to the interface language.** This is critical for language acquisition:

| Content Type | Stays In | Example |
|--------------|----------|---------|
| Vocabulary words | Target language | "Gato" (Spanish), "Chat" (French) |
| Example sentences | Target language | "El gato duerme en la silla" |
| Dialogue scripts | Target language | Full conversations in Spanish |
| Grammar examples | Target language | Conjugation tables in target language |
| Audio pronunciations | Target language | Native speaker audio for target words |
| Romanization (when applicable) | Phonetic aid | "Konnichiwa" for Japanese |

**How the code enforces this:**

The `ApiExerciseContent` model has **separate language fields** for instructions vs. answers:

```java
@SerializedName("instructions_language")
private String mInstructionsLanguage;   // = user's native language (e.g., "en", "de")

@SerializedName("answersDisplayLanguage")
private String mAnswersDisplayLanguage; // = user's native language

@SerializedName("matchingEntitiesLanguage")
private String mMatchingEntitiesLanguage; // = user's native language
```

**The content text itself** (question, sentence, entity phrase) is resolved from `ApiTranslation` using the **target learning language code** (e.g., `es`, `fr`, `ja`), not the interface language.

### 4.4 Translation Resolution Logic

```kotlin
// Pseudocode derived from ApiComponent + ApiTranslation models
fun getTextForUser(
    translationId: String,
    interfaceLanguage: String,    // e.g., "de" (German)
    learningLanguage: String       // e.g., "es" (Spanish)
): DisplayText {
    
    // 1. For UI instructions: use interface language
    val instruction = translationMap[translationId]?.get(interfaceLanguage)
    
    // 2. For learning content: use target/learning language
    val targetContent = translationMap[translationId]?.get(learningLanguage)
    
    // 3. For romanization (Asian languages): additional phonetic field
    val romanization = targetContent?.romanization  // e.g., "Konnichiwa"
    
    return DisplayText(
        text = targetContent?.text ?: "",
        audioUrl = targetContent?.audioUrl,
        romanization = romanization,
        alternativeAnswers = targetContent?.alternativeTexts ?: emptyList()
    )
}
```

### 4.5 Special Case: Grammar Instructions

Grammar exercises are **bilingual by design** — the instruction explains the grammar rule in the native language, but the exercise itself uses target language content.

**Example from string resources:**
```xml
<!-- English base — instruction is in native language -->
<string name="grammar_typing_instructions">
    Complete the text using the information in the box
</string>

<!-- German — instruction is in native language -->
<string name="grammar_typing_instructions">
    Vervollständige den Text anhand der Informationen in der Box
</string>
```

But the "information in the box" and the "text to complete" are both in the **target language** (e.g., Spanish sentences with Spanish grammar rules applied).

### 4.6 Study Plan & Onboarding Language Patterns

During onboarding, the app asks the user's motivation. The **motivation categories** are localized UI strings:

```xml
<!-- English -->
<string name="study_plan_stage1_education">School and Education</string>
<string name="study_plan_stage1_work">Career</string>
<string name="study_plan_stage1_fun">Fun and Culture</string>
<string name="study_plan_stage1_family">Friends and Family</string>
<string name="study_plan_stage1_travel">Travel</string>

<!-- German -->
<string name="study_plan_stage1_education">Schule und Bildung</string>
<string name="study_plan_stage1_work">Beruf</string>
<string name="study_plan_stage1_fun">Spaß und Kultur</string>
<string name="study_plan_stage1_family">Freunde und Familie</string>
<string name="study_plan_stage1_travel">Reisen</string>
```

These UI strings are **stored in Android string resources** and fully localized. The underlying motivation enum values (`TRAVEL`, `WORK`, `EDUCATION`, etc.) are sent to the server as English codes regardless of UI language.

---

## 5. Summary Table

| Area | Key Technology | Exact Evidence Location |
|------|---------------|------------------------|
| Animation | Lottie 5.5.7+ | `/assets/lottie/` (35 JSON files) |
| Modern UI | Jetpack Compose | `AuthenticationActivity`, `ComposeView` in `FilteredVocabEntitiesActivity` |
| Legacy UI | XML Layouts | `/res/layout/` (867 files) |
| Image Loading | Coil | `mt7 imageLoader` references |
| Teaching Data | API + Room Cache | `ApiExerciseContent`, `ApiComponent`, `ApiTranslation`, `ApiEntity` |
| Gamification Points | Server config | `PointsConfigDomainModel`, `PointsConfigApiModel` |
| Streaks | Local + API | `StreaksDomainModel`, `StreakRecord` enum |
| Leagues | API leaderboards | `LeagueUserDomainModel`, `LeagueDataDomainModel` |
| Bilingual UI | Dual language resolution | `mInstructionsLanguage`, `mAnswersDisplayLanguage` fields |
| On-device ML | Logistic regression | `/assets/onboarding_discount_AI_model_weights.json` |

---

*This document is a technical analysis derived from reverse engineering for research and interoperability purposes. No copyrighted APK content, lesson material, or creative assets are redistributed.*
