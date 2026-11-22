import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/app_router.dart';
import 'package:deutschly/core/custom_appbar.dart';
import 'package:deutschly/core/custom_button.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/data/models/exercise.dart';
import 'package:deutschly/data/models/lesson.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/exercise/controller/exercise_controller.dart';
import 'package:deutschly/features/exercise/widgets/exercise_feedback_card.dart';
import 'package:deutschly/features/exercise/widgets/fill_blank_widget.dart';
import 'package:deutschly/features/exercise/widgets/matching_widget.dart';
import 'package:deutschly/features/exercise/widgets/multiple_choice_widget.dart';
import 'package:deutschly/features/exercise/widgets/ordering_widget.dart';
import 'package:deutschly/features/exercise/widgets/speaking_prompt_widget.dart';
import 'package:deutschly/features/exercise/widgets/true_false_widget.dart';
import 'package:deutschly/features/exercise/widgets/writing_prompt_widget.dart';
import 'package:deutschly/features/lesson/controller/lesson_detail_controller.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({
    super.key,
    required this.lessonId,
    this.initialIndex = 0,
  });

  final String lessonId;
  final int initialIndex;

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.lessonDetail(lessonId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseController = Get.find<CourseController>();
    final lessons = courseController.course.value?.lessons ?? const <Lesson>[];
    final lesson = lessons.firstWhereOrNull((Lesson l) => l.id == lessonId);

    if (lesson == null || lesson.exercises.isEmpty) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Exercises',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => _handleBack(context),
          ),
        ),
        body: Center(
          child: Text(
            'No exercises found for this lesson.',
            style: getTextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Lesson ${lesson.number} Exercises',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Back',
          onPressed: () => _handleBack(context),
        ),
      ),
      body: ExercisePlayer(
        key: ValueKey<String>('player_${lessonId}_$initialIndex'),
        exercises: lesson.exercises,
        lessonId: lesson.id,
        initialIndex: initialIndex,
        onCompleteExit: () => _handleBack(context),
      ),
    );
  }
}

class ExercisePlayer extends StatefulWidget {
  const ExercisePlayer({
    super.key,
    required this.exercises,
    this.lessonId,
    this.initialIndex = 0,
    this.onCompleteExit,
  });

  final List<Exercise> exercises;
  final String? lessonId;
  final int initialIndex;
  final VoidCallback? onCompleteExit;

  @override
  State<ExercisePlayer> createState() => _ExercisePlayerState();
}

class _ExercisePlayerState extends State<ExercisePlayer> {
  static int _nextControllerId = 0;

  late String _controllerTag;
  late ExerciseController _controller;

  @override
  void initState() {
    super.initState();
    _controllerTag = 'exercise_player_${_nextControllerId++}';
    _controller = _createController();
  }

  ExerciseController _createController() {
    return Get.put(
      ExerciseController(
        exercises: widget.exercises,
        lessonId: widget.lessonId,
        initialIndex: widget.initialIndex,
      ),
      tag: _controllerTag,
    );
  }

  @override
  void didUpdateWidget(covariant ExercisePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (listEquals(oldWidget.exercises, widget.exercises) &&
        oldWidget.lessonId == widget.lessonId &&
        oldWidget.initialIndex == widget.initialIndex) {
      return;
    }
    final previousTag = _controllerTag;
    _controllerTag = 'exercise_player_${_nextControllerId++}';
    unawaited(Get.delete<ExerciseController>(tag: previousTag, force: true));
    _controller = _createController();
  }

  @override
  void dispose() {
    if (Get.isRegistered<ExerciseController>(tag: _controllerTag)) {
      unawaited(
        Get.delete<ExerciseController>(tag: _controllerTag, force: true),
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      if (_controller.isFinished.value) {
        return _ExerciseSummaryView(
          correctCount: _controller.correctCount,
          totalCount: _controller.totalExercises,
          reviewedCount: _controller.missedExerciseCount,
          onRestart: _controller.restartExercises,
          onDone: widget.onCompleteExit,
        );
      }

      final exercise = _controller.currentExercise;
      if (exercise == null) {
        return Center(
          child: Text(
            'No exercise available.',
            style: getTextStyle(fontSize: 16),
          ),
        );
      }

      final progress = _controller.currentProgress;
      final isChecked = _controller.isChecked.value;
      final canCheck = _controller.canCheck;

      return Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      _controller.currentProgressLabel,
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Score: ${_controller.correctCount} / ${_controller.answeredCount}',
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          LessonDetailController.formatExerciseType(
                            exercise.type,
                          ),
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        exercise.question,
                        style: getTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                          height: 1.35,
                        ),
                      ),
                      if (exercise.pronunciationBn?.isNotEmpty ==
                          true) ...<Widget>[
                        const SizedBox(height: 8),
                        Text(
                          'উচ্চারণ (আনুমানিক): ${exercise.pronunciationBn}',
                          style: getTextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                switch (exercise) {
                  MultipleChoiceExercise() => MultipleChoiceWidget(
                    exercise: exercise,
                    selectedIndex: _controller.selectedOptionIndex.value,
                    isChecked: isChecked,
                    onSelectOption: _controller.selectMultipleChoiceOption,
                  ),
                  FillBlankExercise() => FillBlankWidget(
                    exercise: exercise,
                    textController: _controller.fillBlankTextController,
                    isChecked: isChecked,
                    onChanged: _controller.updateFillBlankText,
                    onSubmitted: (_) {
                      if (_controller.canCheck) {
                        _controller.checkAnswer();
                      }
                    },
                    onInsertSpecialChar: _controller.insertCharacterInFillBlank,
                  ),
                  MatchingExercise() => MatchingWidget(
                    exercise: exercise,
                    rightOptions: _controller.rightColumnOptions.toList(),
                    selectedLeft: _controller.selectedLeftItem.value,
                    matchedPairs: Map<String, String>.from(
                      _controller.matchedPairs,
                    ),
                    isChecked: isChecked,
                    onSelectLeft: _controller.selectLeftMatchingItem,
                    onSelectRight: _controller.selectRightMatchingItem,
                  ),
                  TrueFalseExercise() => TrueFalseWidget(
                    exercise: exercise,
                    selectedValue: _controller.selectedTrueFalse.value,
                    isChecked: isChecked,
                    onSelect: _controller.selectTrueFalse,
                  ),
                  SpeakingPromptExercise() => SpeakingPromptWidget(
                    exercise: exercise,
                    showExample: _controller.showSpeakingExample.value,
                    selfEvaluation: _controller.speakingSelfEvaluation.value,
                    isChecked: isChecked,
                    onToggleExample: _controller.toggleSpeakingExample,
                    onSelectSelfEvaluation:
                        _controller.selectSpeakingSelfEvaluation,
                  ),
                  OrderingExercise() => OrderingWidget(
                    exercise: exercise,
                    currentOrderIndices: _controller.orderingIndices.toList(),
                    isChecked: isChecked,
                    onReorder: _controller.reorderItems,
                    onMoveItem: _controller.moveOrderingItem,
                  ),
                  WritingPromptExercise() => WritingPromptWidget(
                    exercise: exercise,
                    textController: _controller.writingTextController,
                    showExample: _controller.showWritingExample.value,
                    selfEvaluation: _controller.writingSelfEvaluation.value,
                    isChecked: isChecked,
                    onChanged: _controller.updateWritingText,
                    onToggleExample: _controller.toggleWritingExample,
                    onSelectSelfEvaluation:
                        _controller.selectWritingSelfEvaluation,
                  ),
                },
                if (isChecked) ...<Widget>[
                  const SizedBox(height: 18),
                  ExerciseFeedbackCard(
                    isCorrect: _controller.isCurrentCorrect.value,
                    correctAnswerSummary:
                        exercise is SpeakingPromptExercise ||
                            exercise is WritingPromptExercise
                        ? ''
                        : _controller.currentCorrectAnswerSummary,
                    explanation: exercise.explanation,
                    isSelfAssessment:
                        exercise is SpeakingPromptExercise ||
                        exercise is WritingPromptExercise,
                    isWritingPrompt: exercise is WritingPromptExercise,
                  ),
                ],
                const SizedBox(height: 22),
                if (!isChecked)
                  CustomButton(
                    key: const ValueKey<String>('exercise_check_btn'),
                    label: 'Check',
                    backgroundColor: canCheck
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHighest,
                    textColor: canCheck
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                    onPressed: canCheck ? _controller.checkAnswer : null,
                  )
                else
                  CustomButton(
                    key: const ValueKey<String>('exercise_next_btn'),
                    label: _controller.nextButtonLabel,
                    backgroundColor: colorScheme.primary,
                    textColor: colorScheme.onPrimary,
                    onPressed: _controller.nextExercise,
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _ExerciseSummaryView extends StatelessWidget {
  const _ExerciseSummaryView({
    required this.correctCount,
    required this.totalCount,
    required this.reviewedCount,
    required this.onRestart,
    this.onDone,
  });

  final int correctCount;
  final int totalCount;
  final int reviewedCount;
  final VoidCallback onRestart;
  final VoidCallback? onDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final percentage = totalCount == 0
        ? 0
        : ((correctCount / totalCount) * 100).round();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: AppColors.success,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Exercises Completed!',
                  style: getTextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'You scored $correctCount out of $totalCount ($percentage%)',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (reviewedCount > 0) ...<Widget>[
                  const SizedBox(height: 8),
                  Text(
                    'You revisited $reviewedCount ${reviewedCount == 1 ? 'tricky exercise' : 'tricky exercises'} to strengthen recall.',
                    style: getTextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                CustomButton(
                  key: const ValueKey<String>('exercise_retry_btn'),
                  label: 'Practice Again',
                  backgroundColor: colorScheme.primary,
                  textColor: colorScheme.onPrimary,
                  onPressed: onRestart,
                ),
                if (onDone != null) ...<Widget>[
                  const SizedBox(height: 12),
                  CustomButton(
                    key: const ValueKey<String>('exercise_done_btn'),
                    label: 'Back to Lesson',
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    textColor: colorScheme.onSurface,
                    onPressed: onDone,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
