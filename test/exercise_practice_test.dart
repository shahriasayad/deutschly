import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:deutschly/data/models/exercise.dart';
import 'package:deutschly/features/exercise/controller/exercise_controller.dart';
import 'package:deutschly/features/exercise/widgets/exercise_feedback_card.dart';

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
