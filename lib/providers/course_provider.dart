import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instalingo/data/demo_data.dart';
import 'package:instalingo/models/course.dart';
import 'package:instalingo/providers/user_provider.dart';
import 'package:instalingo/services/offline_service.dart';

final courseProvider = StateNotifierProvider<CourseNotifier, Course>((ref) {
  return CourseNotifier(ref);
});

class CourseNotifier extends StateNotifier<Course> {
  final Ref _ref;

  CourseNotifier(this._ref)
      : super(DemoData.courseForLanguage(DemoData.user.learningLanguage)) {
    _init();
  }

  void _init() {
    _load();
    // Auto-react to learning-language changes in UserProfile.
    // When the user switches their target language anywhere in the app,
    // the course reloads automatically without manual switchLanguage() calls.
    _ref.listen(
      userProvider.select((u) => u.learningLanguage),
      (prevLang, nextLang) {
        if (prevLang != nextLang) {
          _loadLanguage(nextLang);
        }
      },
    );
  }

  Future<void> _load() async {
    final user = _ref.read(userProvider);
    await _loadLanguage(user.learningLanguage);
  }

  Future<void> _loadLanguage(String langCode) async {
    final course = DemoData.courseForLanguage(langCode);
    // Set default course immediately to prevent flash of old language content
    state = course;
    // Then layer on any persisted progress (lesson completion, section unlocks)
    final offline = await OfflineService.loadCourse(course);
    if (offline != null) {
      state = offline;
    }
  }

  Future<void> completeLesson(String lessonId) async {
    // Collect vocabulary from the lesson being completed so we can add it
    // to the user's learned-words set.
    final List<String> lessonVocab = [];
    for (final section in state.sections) {
      for (final lesson in section.lessons) {
        if (lesson.id == lessonId) {
          lessonVocab.addAll(lesson.vocabulary);
          break;
        }
      }
    }

    // Update user profile with newly learned words.
    if (lessonVocab.isNotEmpty) {
      _ref.read(userProvider.notifier).addLearnedWords(lessonVocab);
    }

    final updatedSections = state.sections.map((section) {
      final updatedLessons = section.lessons.map((lesson) {
        if (lesson.id == lessonId) {
          return lesson.copyWith(
            isCompleted: true,
            isLocked: false,
            isCurrent: false,
            progress: 1.0,
          );
        }
        // Unlock next lesson
        final currentIndex = section.lessons.indexWhere((l) => l.id == lessonId);
        final thisIndex = section.lessons.indexOf(lesson);
        if (currentIndex != -1 && thisIndex == currentIndex + 1) {
          return lesson.copyWith(
            isLocked: false,
            isCurrent: true,
          );
        }
        return lesson;
      }).toList();

      return Section(
        id: section.id,
        title: section.title,
        order: section.order,
        lessons: updatedLessons,
        isLocked: section.isLocked,
      );
    }).toList();

    // Unlock next section if all lessons in current section are completed
    for (int i = 0; i < updatedSections.length - 1; i++) {
      final allCompleted = updatedSections[i].lessons.every((l) => l.isCompleted);
      if (allCompleted && updatedSections[i + 1].isLocked) {
        updatedSections[i + 1] = Section(
          id: updatedSections[i + 1].id,
          title: updatedSections[i + 1].title,
          order: updatedSections[i + 1].order,
          lessons: updatedSections[i + 1].lessons.map((l) => l.copyWith(
            isLocked: false,
            isCurrent: l.order == 0,
          )).toList(),
          isLocked: false,
        );
      }
    }

    state = Course(
      id: state.id,
      title: state.title,
      subtitle: state.subtitle,
      level: state.level,
      language: state.language,
      totalLessons: state.totalLessons,
      completedLessons: state.completedLessons + 1,
      sections: updatedSections,
      imageUrl: state.imageUrl,
      description: state.description,
      isLocked: state.isLocked,
    );
    await OfflineService.saveCourse(state);
  }

  Lesson? getLessonById(String id) {
    for (final section in state.sections) {
      for (final lesson in section.lessons) {
        if (lesson.id == id) return lesson;
      }
    }
    return null;
  }
}
