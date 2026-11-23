import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:deutschly/data/models/exercise.dart';
import 'package:deutschly/features/exercise/controller/exercise_controller.dart';
import 'package:deutschly/features/exercise/widgets/exercise_feedback_card.dart';
import 'package:deutschly/features/progress/controller/progress_controller.dart';
import 'package:deutschly/features/progress/service/progress_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(Get.reset);

  test('missed exercises return once at the end for active recall', () {
    final controller = Get.put(
      ExerciseController(
        exercises: const <Exercise>[
          Exercise.multipleChoice(
            id: 'first',
            question: 'Choose the greeting.',
            options: <String>['Hallo', 'Tschüs'],
            correctIndex: 0,
          ),
          Exercise.multipleChoice(
            id: 'second',
            question: 'Choose the farewell.',
            options: <String>['Hallo', 'Tschüs'],
            correctIndex: 1,
          ),
        ],
      ),
      tag: 'practice_test',
    );

    controller.selectMultipleChoiceOption(1);
    controller.checkAnswer();
    controller.nextExercise();

    expect(controller.currentExercise?.id, 'second');
    expect(controller.currentProgressLabel, 'Exercise 2 of 2');

    controller.selectMultipleChoiceOption(1);
    controller.checkAnswer();
    controller.nextExercise();

    expect(controller.isReviewRound.value, isTrue);
    expect(controller.currentExercise?.id, 'first');
    expect(controller.currentProgressLabel, 'Review 1 of 1');
    expect(controller.nextButtonLabel, 'Finish');

    controller.selectMultipleChoiceOption(0);
    controller.checkAnswer();
    controller.nextExercise();

    expect(controller.isFinished.value, isTrue);
    expect(controller.correctCount, 2);
    expect(controller.totalExercises, 2);
    expect(controller.missedExerciseCount, 1);
  });

  test('a missed review answer does not create an endless retry loop', () {
    final controller = Get.put(
      ExerciseController(
        exercises: const <Exercise>[
          Exercise.trueFalse(
            id: 'true_false',
            question: 'German is a language.',
            correct: true,
          ),
        ],
      ),
      tag: 'review_limit_test',
    );

    controller.selectTrueFalse(false);
    controller.checkAnswer();
    controller.nextExercise();
    controller.selectTrueFalse(false);
    controller.checkAnswer();
    controller.nextExercise();

    expect(controller.isFinished.value, isTrue);
    expect(controller.correctCount, 0);
  });

  test(
    'same-session retry completes exercise without advancing review interval',
    () {
      final progressController = ProgressController(
        progressService: ProgressService(),
      );
      final controller = Get.put(
        ExerciseController(
          exercises: const <Exercise>[
            Exercise.trueFalse(
              id: 'reviewed_item',
              question: 'German is a language.',
              correct: true,
            ),
          ],
          lessonId: 'lesson_01',
          progressController: progressController,
        ),
        tag: 'review_schedule_retry_test',
      );

      controller.selectTrueFalse(false);
      controller.checkAnswer();
      final firstSchedule = progressController
          .getLessonProgressData('lesson_01')
          .reviewSchedule['reviewed_item'];
      expect(firstSchedule?.attempts, 1);

      controller.nextExercise();
      controller.selectTrueFalse(true);
      controller.checkAnswer();

      final progress = progressController.getLessonProgressData('lesson_01');
      expect(progress.completedExercises, contains('reviewed_item'));
      expect(progress.reviewSchedule['reviewed_item']?.attempts, 1);
      expect(
        progress.reviewSchedule['reviewed_item']?.dueAt,
        firstSchedule?.dueAt,
      );
    },
  );

  test('mixed-lesson practice saves each answer to its source lesson', () {
    final progressController = ProgressController(
      progressService: ProgressService(),
    );
    final controller = Get.put(
      ExerciseController(
        exercises: const <Exercise>[
          Exercise.multipleChoice(
            id: 'lesson_one_item',
            question: 'First question',
            options: <String>['A', 'B'],
            correctIndex: 0,
          ),
          Exercise.multipleChoice(
            id: 'lesson_two_item',
            question: 'Second question',
            options: <String>['A', 'B'],
            correctIndex: 0,
          ),
        ],
        lessonId: 'lesson_01',
        lessonIdByExercise: <String, String>{'lesson_two_item': 'lesson_02'},
        progressController: progressController,
      ),
      tag: 'mixed_lesson_review_test',
    );

    controller.selectMultipleChoiceOption(0);
    controller.checkAnswer();
    controller.nextExercise();
    controller.selectMultipleChoiceOption(0);
    controller.checkAnswer();

    expect(
      progressController.getCompletedExerciseIds('lesson_01'),
      contains('lesson_one_item'),
    );
    expect(
      progressController.getCompletedExerciseIds('lesson_02'),
      contains('lesson_two_item'),
    );
    expect(
      progressController.getLessonProgressData('lesson_02').reviewSchedule,
      contains('lesson_two_item'),
    );
  });

  test('writing practice requires a response before self-assessment', () {
    final controller = Get.put(
      ExerciseController(
        exercises: const <Exercise>[
          Exercise.writingPrompt(
            id: 'writing',
            question: 'Write a short introduction.',
            exampleAnswer: 'Ich heiße Anna.',
          ),
        ],
      ),
      tag: 'writing_practice_test',
    );

    controller.selectWritingSelfEvaluation(true);
    expect(controller.showWritingExample.value, isTrue);
    expect(controller.canCheck, isFalse);

    controller.updateWritingText('Ich heiße Amina.');
    expect(controller.canCheck, isTrue);
    controller.checkAnswer();

    expect(controller.isCurrentCorrect.value, isTrue);
    expect(controller.isChecked.value, isTrue);
  });

  testWidgets('speaking self-rating is described as practice, not incorrect', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExerciseFeedbackCard(
            isCorrect: false,
            correctAnswerSummary: 'Ich heiße Anna.',
            isSelfAssessment: true,
          ),
        ),
      ),
    );

    expect(find.text('Keep practicing'), findsOneWidget);
    expect(find.text('Example answer: Ich heiße Anna.'), findsOneWidget);
    expect(find.text('Incorrect'), findsNothing);
    expect(find.text('Correct answer: Ich heiße Anna.'), findsNothing);
  });
}
