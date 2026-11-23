import 'dart:async';

import 'package:get/get.dart';
import 'package:deutschly/data/models/course.dart';
import 'package:deutschly/data/models/lesson.dart';
import 'package:deutschly/data/models/practice_session_item.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/progress/controller/progress_controller.dart';

class HomeController extends GetxController {
  static const int practiceSessionExerciseLimit = 5;

  HomeController({
    CourseController? courseController,
    ProgressController? progressController,
  }) : _courseController = courseController ?? Get.find<CourseController>(),
       _progressController = progressController;

  final CourseController _courseController;
  final ProgressController? _progressController;
  Worker? _courseWorker;
  bool _didSeedLegacyReview = false;

  ProgressController get _resolvedProgressController {
    if (_progressController != null) {
      return _progressController;
    }
    if (Get.isRegistered<ProgressController>()) {
      return Get.find<ProgressController>();
    }
    return Get.put(ProgressController(courseController: _courseController));
  }

  Course? get course => _courseController.course.value;

  List<Lesson> get lessons => course?.lessons ?? const <Lesson>[];

  @override
  void onInit() {
    super.onInit();
    _seedLegacyReviewSchedule();
    if (!_didSeedLegacyReview) {
      _courseWorker = ever<Course?>(_courseController.course, (loadedCourse) {
        if (loadedCourse != null) {
          _seedLegacyReviewSchedule();
          _courseWorker?.dispose();
          _courseWorker = null;
        }
      });
    }
  }

  @override
  void onClose() {
    _courseWorker?.dispose();
    super.onClose();
  }

  void _seedLegacyReviewSchedule() {
    final loadedCourse = course;
    if (_didSeedLegacyReview || loadedCourse == null) {
      return;
    }
    _didSeedLegacyReview = true;
    unawaited(
      _resolvedProgressController.seedReviewForPreviouslyCompletedExercises(
        exerciseIdsByLesson: <String, Set<String>>{
          for (final lesson in loadedCourse.lessons)
            lesson.id: lesson.exercises.map((exercise) => exercise.id).toSet(),
        },
      ),
    );
  }

  ({List<PracticeSessionItem> items, int reviewCount})?
  get nextPracticeSession {
    final now = DateTime.now();
    final dueReviews = <({DateTime dueAt, PracticeSessionItem item})>[];
    for (final lesson in lessons) {
      final dueSchedule = _resolvedProgressController.getDueReviewSchedule(
        lesson.id,
        now: now,
      );
      for (final entry in dueSchedule.entries) {
        final exercise = lesson.exercises.firstWhereOrNull(
          (item) => item.id == entry.key,
        );
        if (exercise != null) {
          dueReviews.add((
            dueAt: entry.value.dueAt,
            item: PracticeSessionItem(
              lessonId: lesson.id,
              exercise: exercise,
              isReview: true,
            ),
          ));
        }
      }
    }
    dueReviews.sort((a, b) => a.dueAt.compareTo(b.dueAt));

    final selectedReviews = dueReviews
        .take(maxReviewExercisesPerSession)
        .map((entry) => entry.item)
        .toList();
    final selectedIds = selectedReviews.map((item) => item.exercise.id).toSet();
    final remainingSlots =
        practiceSessionExerciseLimit - selectedReviews.length;
    final newExercises = <PracticeSessionItem>[];
    for (final lesson in lessons) {
      final completedIds = _resolvedProgressController.getCompletedExerciseIds(
        lesson.id,
      );
      final schedule = _resolvedProgressController
          .getLessonProgressData(lesson.id)
          .reviewSchedule;
      for (final exercise in lesson.exercises) {
        if (!completedIds.contains(exercise.id) &&
            !schedule.containsKey(exercise.id) &&
            !selectedIds.contains(exercise.id)) {
          newExercises.add(
            PracticeSessionItem(lessonId: lesson.id, exercise: exercise),
          );
          if (newExercises.length >= remainingSlots) {
            break;
          }
        }
      }
      if (newExercises.length >= remainingSlots) {
        break;
      }
    }

    final items = <PracticeSessionItem>[...selectedReviews, ...newExercises];
    if (items.length < practiceSessionExerciseLimit) {
      items.addAll(
        dueReviews
            .skip(selectedReviews.length)
            .take(practiceSessionExerciseLimit - items.length)
            .map((entry) => entry.item),
      );
    }
    if (items.isEmpty) {
      return null;
    }
    return (
      items: items,
      reviewCount: items.where((item) => item.isReview).length,
    );
  }

  int get nextPracticeSessionExerciseCount {
    return nextPracticeSession?.items.length ?? 0;
  }

  static const int maxReviewExercisesPerSession = 3;

  bool get isLoading => _courseController.isLoading.value;

  String? get errorMessage => _courseController.errorMessage.value;

  double getLessonProgress(String lessonId) {
    final lesson = lessons.firstWhereOrNull((Lesson l) => l.id == lessonId);
    return _resolvedProgressController.getLessonProgressRatio(
      lessonId,
      totalExercises: lesson?.exercises.length,
    );
  }

  int getLessonProgressPercent(String lessonId) {
    final lesson = lessons.firstWhereOrNull((Lesson l) => l.id == lessonId);
    return _resolvedProgressController.getLessonProgressPercent(
      lessonId,
      totalExercises: lesson?.exercises.length,
    );
  }

  double get overallProgress =>
      _resolvedProgressController.overallCourseProgress;

  int get overallProgressPercent =>
      _resolvedProgressController.overallCourseProgressPercent;

  Future<void> resetAllProgress() =>
      _resolvedProgressController.resetAllProgress();

  Future<void> retryLoadCourse() => _courseController.loadCourse();
}
