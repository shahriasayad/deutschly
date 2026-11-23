import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:deutschly/data/models/course.dart';
import 'package:deutschly/data/models/exercise.dart';
import 'package:deutschly/data/models/lesson.dart';
import 'package:deutschly/data/models/lesson_progress.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/home/controller/home_controller.dart';
import 'package:deutschly/features/exercise/screen/exercise_screen.dart';
import 'package:deutschly/features/progress/controller/progress_controller.dart';
import 'package:deutschly/features/progress/service/progress_service.dart';

void main() {
  tearDown(Get.reset);

  test(
    'continue session starts at next uncompleted exercise, capped at five',
    () {
      final courseController = CourseController(initialCourse: _course());
      final progressController = ProgressController(
        progressService: ProgressService(),
        courseController: courseController,
      );
      progressController.progressByLesson['lesson_01'] = LessonProgress(
        completedExercises: <String>['exercise_01', 'exercise_02'],
        score: 2,
      );

      final homeController = HomeController(
        courseController: courseController,
        progressController: progressController,
      );
      final session = homeController.nextPracticeSession;

      expect(session?.items.first.lessonId, 'lesson_01');
      expect(session?.items.first.exercise.id, 'exercise_03');
      expect(session?.reviewCount, 0);
      expect(homeController.nextPracticeSessionExerciseCount, 5);
    },
  );

  test(
    'continue session advances to next lesson when current lesson is done',
    () {
      final courseController = CourseController(initialCourse: _course());
      final progressController = ProgressController(
        progressService: ProgressService(),
        courseController: courseController,
      );
      progressController.progressByLesson['lesson_01'] = LessonProgress(
        completedExercises: List<String>.generate(
          7,
          (index) => 'exercise_0${index + 1}',
        ),
        score: 7,
      );

      final homeController = HomeController(
        courseController: courseController,
        progressController: progressController,
      );
      final session = homeController.nextPracticeSession;

      expect(session?.items.first.lessonId, 'lesson_02');
      expect(session?.items.first.exercise.id, 'exercise_b1');
      expect(homeController.nextPracticeSessionExerciseCount, 3);
    },
  );

  test('continue session is empty after all lesson exercises are complete', () {
    final course = _course();
    final courseController = CourseController(initialCourse: course);
    final progressController = ProgressController(
      progressService: ProgressService(),
      courseController: courseController,
    );
    progressController.progressByLesson['lesson_01'] = LessonProgress(
      completedExercises: List<String>.generate(
        7,
        (index) => 'exercise_0${index + 1}',
      ),
      score: 7,
    );
    progressController.progressByLesson['lesson_02'] = LessonProgress(
      completedExercises: List<String>.generate(
        3,
        (index) => 'exercise_b${index + 1}',
      ),
      score: 3,
    );

    final homeController = HomeController(
      courseController: courseController,
      progressController: progressController,
    );

    expect(homeController.nextPracticeSession, isNull);
    expect(homeController.nextPracticeSessionExerciseCount, 0);
  });

  test('due review items return before new course exercises', () {
    final courseController = CourseController(initialCourse: _course());
    final progressController = ProgressController(
      progressService: ProgressService(),
      courseController: courseController,
    );
    final now = DateTime.now();
    progressController.progressByLesson['lesson_01'] = LessonProgress(
      completedExercises: <String>['exercise_01'],
      score: 1,
      reviewSchedule: <String, ExerciseReviewState>{
        'exercise_01': ExerciseReviewState(
          dueAt: now.subtract(const Duration(hours: 1)),
          successfulReviews: 1,
          intervalDays: 1,
          attempts: 1,
        ),
        'exercise_02': ExerciseReviewState(
          dueAt: now.add(const Duration(days: 1)),
          successfulReviews: 1,
          intervalDays: 1,
          attempts: 1,
        ),
      },
    );

    final homeController = HomeController(
      courseController: courseController,
      progressController: progressController,
    );
    final session = homeController.nextPracticeSession;

    expect(session?.reviewCount, 1);
    expect(session?.items.first.exercise.id, 'exercise_01');
    expect(session?.items.first.isReview, isTrue);
    expect(session?.items.last.exercise.id, 'exercise_06');
  });

  test(
    'completed exercises from existing progress are seeded once for review',
    () async {
      final courseController = CourseController(initialCourse: _course());
      final progressController = ProgressController(
        progressService: ProgressService(),
        courseController: courseController,
      );
      progressController.progressByLesson['lesson_01'] = LessonProgress(
        completedExercises: <String>['exercise_01', 'removed_exercise'],
        score: 2,
      );
      final firstSeedTime = DateTime.utc(2026, 1, 1);

      await progressController.seedReviewForPreviouslyCompletedExercises(
        exerciseIdsByLesson: <String, Set<String>>{
          'lesson_01': <String>{'exercise_01'},
        },
        now: firstSeedTime,
      );
      await progressController.seedReviewForPreviouslyCompletedExercises(
        exerciseIdsByLesson: <String, Set<String>>{
          'lesson_01': <String>{'exercise_01'},
        },
        now: firstSeedTime.add(const Duration(days: 10)),
      );

      final progress = progressController.getLessonProgressData('lesson_01');
      expect(progress.reviewSchedule.keys, <String>['exercise_01']);
      expect(progress.reviewSchedule['exercise_01']?.dueAt, firstSeedTime);
    },
  );

  test(
    'review schedule spaces successful recall and survives JSON round-trip',
    () {
      final firstAttempt = DateTime.utc(2026, 1, 1);
      final failed = const LessonProgress().copyWithAttempt(
        exerciseId: 'exercise_01',
        correct: false,
        now: firstAttempt,
      );
      expect(failed.completedExercises, isEmpty);
      expect(
        failed.reviewSchedule['exercise_01']?.dueAt,
        firstAttempt.add(const Duration(days: 1)),
      );

      final firstRecall = failed.copyWithAttempt(
        exerciseId: 'exercise_01',
        correct: true,
        now: firstAttempt.add(const Duration(days: 1)),
      );
      expect(firstRecall.completedExercises, contains('exercise_01'));
      expect(firstRecall.reviewSchedule['exercise_01']?.intervalDays, 1);

      final secondRecall = firstRecall.copyWithAttempt(
        exerciseId: 'exercise_01',
        correct: true,
        now: firstRecall.reviewSchedule['exercise_01']!.dueAt,
      );
      expect(secondRecall.reviewSchedule['exercise_01']?.intervalDays, 3);

      final restored = LessonProgress.fromJson(secondRecall.toJson());
      expect(restored.completedExercises, contains('exercise_01'));
      expect(
        restored.reviewSchedule['exercise_01']?.dueAt,
        secondRecall.reviewSchedule['exercise_01']?.dueAt,
      );
      expect(restored.reviewSchedule['exercise_01']?.attempts, 3);
    },
  );

  test('can-do self-checks roll up and persist independently', () async {
    final courseController = CourseController(initialCourse: _course());
    final service = ProgressService();
    final progressController = ProgressController(
      progressService: service,
      courseController: courseController,
    );

    expect(progressController.totalCanDoObjectives, 4);
    await progressController.setCanDoObjective(
      lessonId: 'lesson_01',
      objective: 'Use lesson_01 ability 1',
      canDo: true,
    );

    expect(progressController.completedCanDoObjectives, 1);
    expect(progressController.canDoProgressPercent, 25);
    expect(progressController.getCompletedCount('lesson_01'), 0);

    final reloaded = ProgressController(
      progressService: service,
      courseController: courseController,
    )..loadProgress();
    expect(
      reloaded.canDoObjective('lesson_01', 'Use lesson_01 ability 1'),
      isTrue,
    );
    expect(reloaded.getCompletedCount('lesson_01'), 0);

    await reloaded.setCanDoObjective(
      lessonId: 'lesson_01',
      objective: 'Use lesson_01 ability 1',
      canDo: false,
    );
    expect(reloaded.completedCanDoObjectives, 0);
  });

  test('older saved progress remains readable without can-do data', () {
    final restored = LessonProgress.fromJson(<String, dynamic>{
      'completedExercises': <String>['exercise_01'],
      'score': 1,
    });

    expect(restored.completedExercises, <String>['exercise_01']);
    expect(restored.canDoObjectives, isEmpty);
  });

  testWidgets('short session begins at selected course position', (
    tester,
  ) async {
    final courseController = Get.put(
      CourseController(initialCourse: _course()),
    );
    final progressController = Get.put(
      ProgressController(
        progressService: ProgressService(),
        courseController: courseController,
      ),
    );
    progressController.progressByLesson['lesson_01'] = LessonProgress(
      completedExercises: <String>['exercise_01', 'exercise_02'],
      score: 2,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: ExerciseScreen(
          lessonId: 'lesson_01',
          initialIndex: 2,
          sessionLength: 2,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Question 3'), findsOneWidget);
  });
}

Course _course() => Course(
  id: 'test_course',
  title: 'Test course',
  level: 'A1.1',
  language: 'German',
  description: 'Test course',
  totalLessons: 2,
  version: '1',
  created: '2026-01-01',
  lessons: <Lesson>[
    _lesson('lesson_01', 1, 7, 'exercise_0'),
    _lesson('lesson_02', 2, 3, 'exercise_b'),
  ],
);

Lesson _lesson(String id, int number, int exerciseCount, String prefix) =>
    Lesson(
      id: id,
      number: number,
      title: 'Lesson $number',
      titleBn: 'পাঠ $number',
      objectives: <String>['Use $id ability 1', 'Use $id ability 2'],
      exercises: List<Exercise>.generate(
        exerciseCount,
        (index) => Exercise.multipleChoice(
          id: '$prefix${index + 1}',
          question: 'Question ${index + 1}',
          options: const <String>['A', 'B'],
          correctIndex: 0,
        ),
      ),
    );
