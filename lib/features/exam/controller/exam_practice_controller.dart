import 'package:get/get.dart';
import 'package:deutschly/data/models/dialogue.dart';
import 'package:deutschly/data/models/exercise.dart';
import 'package:deutschly/data/models/practice_session_item.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/exam/models/exam_skill.dart';
import 'package:deutschly/features/exam/models/listening_task.dart';

class ExamPracticeController extends GetxController {
  ExamPracticeController({required CourseController courseController})
    : _courseController = courseController;

  final CourseController _courseController;
  final RxBool isTimedMode = false.obs;

  List<PracticeSessionItem> practiceExercisesFor(ExamSkill skill) {
    final lessons = _courseController.course.value?.lessons ?? const [];
    final lessonItems = <List<PracticeSessionItem>>[];
    for (final lesson in lessons) {
      final items = <PracticeSessionItem>[];
      for (final exercise in lesson.exercises) {
        if (_supportsSkill(exercise, skill)) {
          items.add(
            PracticeSessionItem(lessonId: lesson.id, exercise: exercise),
          );
        }
      }
      lessonItems.add(items);
    }
    return _takeRoundRobin(lessonItems, skill.practiceTaskLimit);
  }

  List<ListeningTask> get listeningTasks {
    final lessons = _courseController.course.value?.lessons ?? const [];
    final allLines = lessons
        .expand((lesson) => lesson.dialogues)
        .expand((dialogue) => dialogue.lines)
        .map((DialogueLine line) => line.text.trim())
        .where((String text) => text.isNotEmpty)
        .toSet()
        .toList(growable: false);
    final lessonTasks = <List<ListeningTask>>[];
    var taskIndex = 0;

    for (final lesson in lessons) {
      final tasks = <ListeningTask>[];
      for (final dialogue in lesson.dialogues) {
        final lines = dialogue.lines
            .map((DialogueLine line) => line.text.trim())
            .where((String text) => text.isNotEmpty)
            .toList();
        if (lines.isEmpty) {
          continue;
        }
        final target = lines.reduce(
          (longest, line) => line.length > longest.length ? line : longest,
        );
        final distractors = allLines
            .where((String text) => text != target)
            .take(3)
            .toList();
        if (distractors.length < 3) {
          continue;
        }
        final correctIndex = taskIndex++ % 4;
        final options = List<String>.from(distractors)
          ..insert(correctIndex, target);
        tasks.add(
          ListeningTask(
            id: '${dialogue.id}_listen',
            prompt: 'Listen and choose the sentence you heard.',
            spokenText: target,
            options: options,
            correctIndex: correctIndex,
          ),
        );
      }
      lessonTasks.add(tasks);
    }
    return _takeRoundRobin(lessonTasks, ExamSkill.listening.practiceTaskLimit);
  }

  int taskCount(ExamSkill skill) => skill == ExamSkill.listening
      ? listeningTasks.length
      : practiceExercisesFor(skill).length;

  void setTimedMode(bool value) => isTimedMode.value = value;

  List<T> _takeRoundRobin<T>(List<List<T>> lessonBuckets, int limit) {
    final items = <T>[];
    var bucketIndex = 0;
    while (items.length < limit &&
        lessonBuckets.any((bucket) => bucket.isNotEmpty)) {
      final bucket = lessonBuckets[bucketIndex % lessonBuckets.length];
      bucketIndex++;
      if (bucket.isNotEmpty) {
        items.add(bucket.removeAt(0));
      }
    }
    return items;
  }

  bool _supportsSkill(Exercise exercise, ExamSkill skill) => switch (skill) {
    ExamSkill.listening => false,
    ExamSkill.reading => switch (exercise) {
      MultipleChoiceExercise() ||
      FillBlankExercise() ||
      MatchingExercise() ||
      TrueFalseExercise() ||
      OrderingExercise() => true,
      SpeakingPromptExercise() || WritingPromptExercise() => false,
    },
    ExamSkill.writing => exercise is WritingPromptExercise,
    ExamSkill.speaking => exercise is SpeakingPromptExercise,
  };
}
