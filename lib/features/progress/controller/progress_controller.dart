import 'package:get/get.dart';
import 'package:deutschly/data/models/lesson.dart';
import 'package:deutschly/data/models/lesson_progress.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/progress/service/progress_service.dart';

class ProgressController extends GetxController {
  ProgressController({
    ProgressService? progressService,
    CourseController? courseController,
  }) : _progressService = progressService ?? ProgressService(),
       _courseController = courseController;

  final ProgressService _progressService;
  final CourseController? _courseController;

  final RxMap<String, LessonProgress> progressByLesson =
      <String, LessonProgress>{}.obs;

  CourseController? get _resolvedCourseController {
    if (_courseController != null) {
      return _courseController;
    }
    if (Get.isRegistered<CourseController>()) {
      return Get.find<CourseController>();
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    loadProgress();
  }

  void loadProgress() {
    final loaded = _progressService.loadAllProgress();
    progressByLesson.assignAll(loaded);
  }

  LessonProgress getLessonProgressData(String lessonId) {
    return progressByLesson[lessonId] ?? const LessonProgress();
  }

  Set<String> getCompletedExerciseIds(String lessonId) {
    return getLessonProgressData(lessonId).completedExercises.toSet();
  }

  Set<String> getCanDoObjectives(String lessonId) {
    return getLessonProgressData(lessonId).canDoObjectives.toSet();
  }

  bool canDoObjective(String lessonId, String objective) =>
      getLessonProgressData(lessonId).canDoObjectives.contains(objective);

  int getCanDoObjectiveCount(Lesson lesson) {
    final completed = getCanDoObjectives(lesson.id);
    return lesson.objectives.where(completed.contains).length;
  }

  int get totalCanDoObjectives =>
      _resolvedCourseController?.course.value?.lessons.fold<int>(
        0,
        (int total, Lesson lesson) => total + lesson.objectives.length,
      ) ??
      0;

  int get completedCanDoObjectives {
    final lessons =
        _resolvedCourseController?.course.value?.lessons ?? const <Lesson>[];
    return lessons.fold<int>(
      0,
      (int total, Lesson lesson) => total + getCanDoObjectiveCount(lesson),
    );
  }

  double get canDoProgressRatio => totalCanDoObjectives == 0
      ? 0.0
      : (completedCanDoObjectives / totalCanDoObjectives).clamp(0.0, 1.0);

  int get canDoProgressPercent => (canDoProgressRatio * 100).round();

  Future<void> setCanDoObjective({
    required String lessonId,
    required String objective,
    required bool canDo,
  }) async {
    final current = getLessonProgressData(lessonId);
    final updated = current.copyWithCanDoObjective(objective, canDo);
    if (identical(current, updated)) {
      return;
    }
    progressByLesson[lessonId] = updated;
    await _progressService.saveAllProgress(
      Map<String, LessonProgress>.from(progressByLesson),
    );
  }

  Map<String, ExerciseReviewState> getDueReviewSchedule(
    String lessonId, {
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();
    return Map<String, ExerciseReviewState>.fromEntries(
      getLessonProgressData(lessonId).reviewSchedule.entries.where(
        (entry) => entry.value.isDueAt(currentTime),
      ),
    );
  }

  bool isExerciseCompleted(String lessonId, String exerciseId) {
    return getLessonProgressData(
      lessonId,
    ).completedExercises.contains(exerciseId);
  }

  int getLessonScore(String lessonId) {
    return getLessonProgressData(lessonId).score;
  }

  int getCompletedCount(String lessonId) {
    return getLessonProgressData(lessonId).completedExercises.length;
  }

  double getLessonProgressRatio(String lessonId, {int? totalExercises}) {
    final total = totalExercises ?? _getTotalExercisesForLesson(lessonId);
    if (total <= 0) {
      return 0.0;
    }
    final completed = getCompletedCount(lessonId);
    return (completed / total).clamp(0.0, 1.0);
  }

  int getLessonProgressPercent(String lessonId, {int? totalExercises}) {
    return (getLessonProgressRatio(lessonId, totalExercises: totalExercises) *
            100)
        .round();
  }

  int _getTotalExercisesForLesson(String lessonId) {
    final lessons =
        _resolvedCourseController?.course.value?.lessons ?? const <Lesson>[];
    final lesson = lessons.firstWhereOrNull((Lesson l) => l.id == lessonId);
    return lesson?.exercises.length ?? 0;
  }

  int get totalCompletedExercises {
    return progressByLesson.values.fold<int>(
      0,
      (int sum, LessonProgress item) => sum + item.completedExercises.length,
    );
  }

  int get totalCourseExercises {
    final lessons =
        _resolvedCourseController?.course.value?.lessons ?? const <Lesson>[];
    return lessons.fold<int>(
      0,
      (int sum, Lesson lesson) => sum + lesson.exercises.length,
    );
  }

  double get overallCourseProgress {
    final lessons =
        _resolvedCourseController?.course.value?.lessons ?? const <Lesson>[];
    if (lessons.isEmpty) {
      return 0.0;
    }
    final sum = lessons.fold<double>(
      0.0,
      (double acc, Lesson lesson) =>
          acc +
          getLessonProgressRatio(
            lesson.id,
            totalExercises: lesson.exercises.length,
          ),
    );
    return (sum / lessons.length).clamp(0.0, 1.0);
  }

  int get overallCourseProgressPercent => (overallCourseProgress * 100).round();

  Future<void> markExerciseCompleted({
    required String lessonId,
    required String exerciseId,
  }) async {
    final current = getLessonProgressData(lessonId);
    if (current.completedExercises.contains(exerciseId)) {
      return;
    }
    final updated = current.copyWithCompletedExercise(exerciseId);
    progressByLesson[lessonId] = updated;
    await _progressService.saveAllProgress(
      Map<String, LessonProgress>.from(progressByLesson),
    );
  }

  Future<void> recordExerciseAttempt({
    required String lessonId,
    required String exerciseId,
    required bool correct,
    DateTime? now,
  }) async {
    final current = getLessonProgressData(lessonId);
    final updated = current.copyWithAttempt(
      exerciseId: exerciseId,
      correct: correct,
      now: now ?? DateTime.now(),
    );
    progressByLesson[lessonId] = updated;
    await _progressService.saveAllProgress(
      Map<String, LessonProgress>.from(progressByLesson),
    );
  }

  Future<void> seedReviewForPreviouslyCompletedExercises({
    required Map<String, Set<String>> exerciseIdsByLesson,
    DateTime? now,
  }) async {
    var changed = false;
    final currentTime = now ?? DateTime.now();
    for (final entry in exerciseIdsByLesson.entries) {
      final current = getLessonProgressData(entry.key);
      final updated = current.copyWithSeededReviewSchedule(
        validExerciseIds: entry.value,
        dueAt: currentTime,
      );
      if (!identical(current, updated)) {
        progressByLesson[entry.key] = updated;
        changed = true;
      }
    }
    if (changed) {
      await _progressService.saveAllProgress(
        Map<String, LessonProgress>.from(progressByLesson),
      );
    }
  }

  Future<void> resetAllProgress() async {
    progressByLesson.clear();
    await _progressService.clearAllProgress();
  }
}
