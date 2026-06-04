import 'package:instalingo/models/localized_text.dart';

/// Course metadata (titles, section names, lesson names, descriptions) uses
/// [LocalizedText] so the app can display them in the user's native/interface
/// language. Learning content (vocabulary, example sentences) stays in the
/// target language.
class Course {
  final String id;
  final LocalizedText title;
  final LocalizedText subtitle;
  final String level;
  final String language;
  final int totalLessons;
  final int completedLessons;
  final List<Section> sections;
  final String? imageUrl;
  final LocalizedText description;
  final bool isLocked;

  const Course({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.level,
    required this.language,
    required this.totalLessons,
    this.completedLessons = 0,
    required this.sections,
    this.imageUrl,
    required this.description,
    this.isLocked = false,
  });

  Lesson? getLessonById(String lessonId) {
    for (final section in sections) {
      for (final lesson in section.lessons) {
        if (lesson.id == lessonId) return lesson;
      }
    }
    return null;
  }
}

class Section {
  final String id;
  final LocalizedText title;
  final int order;
  final List<Lesson> lessons;
  final bool isLocked;

  const Section({
    required this.id,
    required this.title,
    required this.order,
    required this.lessons,
    this.isLocked = false,
  });
}

class Lesson {
  final String id;
  final LocalizedText title;
  final LocalizedText description;
  final int order;
  final int xpReward;
  final int gemsReward;
  final List<Exercise> exercises;
  final bool isCompleted;
  final bool isLocked;
  final bool isCurrent;
  final double? progress;
  final String? thumbnailUrl;
  /// Vocabulary words taught in this lesson (target-language words).
  /// Used to determine which Chill Corner posts the user is ready to see.
  final List<String> vocabulary;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.xpReward,
    required this.gemsReward,
    required this.exercises,
    this.isCompleted = false,
    this.isLocked = true,
    this.isCurrent = false,
    this.progress,
    this.thumbnailUrl,
    this.vocabulary = const [],
  });

  Lesson copyWith({
    bool? isCompleted,
    bool? isLocked,
    bool? isCurrent,
    double? progress,
  }) =>
      Lesson(
        id: id,
        title: title,
        description: description,
        order: order,
        xpReward: xpReward,
        gemsReward: gemsReward,
        exercises: exercises,
        isCompleted: isCompleted ?? this.isCompleted,
        isLocked: isLocked ?? this.isLocked,
        isCurrent: isCurrent ?? this.isCurrent,
        progress: progress ?? this.progress,
        thumbnailUrl: thumbnailUrl,
        vocabulary: vocabulary,
      );
}

enum ExerciseType {
  vocabularyMultipleChoice,
  fillInBlank,
  translateSentence,
  matchPairs,
  listenAndType,
  speaking,
  dialogueComplete,
  grammarTip,
  wordSorting,
  imageIdentification,
  flashCard,
  comprehensionText,
  grammarTrueFalse,
  phraseBuilderPrefilled,
  writing,
}

class Exercise {
  final String id;
  final ExerciseType type;
  /// Question text in the target language.
  final String question;
  /// Instruction text in the user's native language (e.g. Chinese for a Chinese learner).
  final String? instruction;
  final String? contentLang; // Language code of the learning content (e.g., 'en', 'ko')
  final String?
      instructionLang; // Language code of the instruction text (e.g., 'zh', 'de')
  final String? audioUrl;
  final String? imageUrl;
  final List<String>? options;
  final String? correctAnswer;
  final List<String>? correctAnswerList;
  /// Explanation of why the answer is correct, in the user's native language.
  /// Must provide entries for every supported native language.
  final LocalizedText? explanation;
  final List<WordPair>? pairs;
  final List<DialogueTurn>? dialogue;
  /// Grammar rule explanation in the user's native language.
  final LocalizedText? grammarRule;
  /// Grammar example in the user's native language.
  final LocalizedText? grammarExample;
  final List<String>? wordBank;
  final String? passage; // For comprehensionText: the reading passage
  final List<String>? questions; // For comprehensionText: sub-questions
  final bool? isTrue; // For grammarTrueFalse
  /// Writing prompt in the user's native language.
  final LocalizedText? writingPrompt;
  /// Sample answer with native-language translation.
  final LocalizedText? sampleAnswer;

  const Exercise({
    required this.id,
    required this.type,
    required this.question,
    this.instruction,
    this.contentLang,
    this.instructionLang,
    this.audioUrl,
    this.imageUrl,
    this.options,
    this.correctAnswer,
    this.correctAnswerList,
    this.explanation,
    this.pairs,
    this.dialogue,
    this.grammarRule,
    this.grammarExample,
    this.wordBank,
    this.passage,
    this.questions,
    this.isTrue,
    this.writingPrompt,
    this.sampleAnswer,
  });
}

class WordPair {
  final String left;
  final String right;

  const WordPair({required this.left, required this.right});
}

class DialogueTurn {
  final String speaker;
  final String text;
  final bool isUser;
  final String? audioUrl;

  const DialogueTurn({
    required this.speaker,
    required this.text,
    this.isUser = false,
    this.audioUrl,
  });
}
