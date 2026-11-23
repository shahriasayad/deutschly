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
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/models/exercise.dart';
import 'package:deutschly/data/models/lesson.dart';
import 'package:deutschly/data/models/practice_session_item.dart';
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
import 'package:deutschly/features/progress/controller/progress_controller.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({
    super.key,
    required this.lessonId,
    this.initialIndex = 0,
    this.sessionLength = 0,
    this.sessionItems,
  });

  final String lessonId;
  final int initialIndex;
  final int sessionLength;
  final List<PracticeSessionItem>? sessionItems;

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.lessonDetail(lessonId));
    }
  }

  @override
  Widget build(BuildContext context) {
    AppScreenUtil.init(context);
    final courseController = Get.find<CourseController>();
    final lessons = courseController.course.value?.lessons ?? const <Lesson>[];
    final lesson = lessons.firstWhereOrNull((Lesson l) => l.id == lessonId);
    final isSession = sessionItems != null || sessionLength > 0;
    final completedExerciseIds =
        lesson != null && sessionItems == null && sessionLength > 0
        ? Get.find<ProgressController>().getCompletedExerciseIds(lesson.id)
        : const <String>{};

    final exercises = sessionItems != null
        ? sessionItems!.map((item) => item.exercise).toList(growable: false)
        : lesson == null
        ? const <Exercise>[]
        : sessionLength > 0
        ? lesson.exercises
              .skip(initialIndex.clamp(0, lesson.exercises.length).toInt())
              .where((exercise) => !completedExerciseIds.contains(exercise.id))
              .take(sessionLength)
              .toList(growable: false)
        : lesson.exercises;

    if ((lesson == null && sessionItems == null) || exercises.isEmpty) {
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
            isSession
                ? 'No practice exercises are available here yet.'
                : 'No exercises found for this lesson.',
            style: getTextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: isSession
            ? 'Quick practice'
            : 'Lesson ${lesson?.number ?? ''} Exercises',
        subtitle: isSession ? 'Mixed review & new practice' : lesson?.title,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Back',
          onPressed: () => _handleBack(context),
        ),
      ),
      body: ExercisePlayer(
        key: ValueKey<String>('player_${lessonId}_$initialIndex'),
        exercises: exercises,
        lessonId: lesson?.id,
        lessonIdByExercise: sessionItems == null
            ? const <String, String>{}
            : <String, String>{
                for (final item in sessionItems!)
                  item.exercise.id: item.lessonId,
              },
        initialIndex: isSession ? 0 : initialIndex,
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
    this.lessonIdByExercise = const <String, String>{},
    this.recordProgress = true,
    this.initialIndex = 0,
    this.onCompleteExit,
    this.onControllerReady,
  });

  final List<Exercise> exercises;
  final String? lessonId;
  final Map<String, String> lessonIdByExercise;
  final bool recordProgress;
  final int initialIndex;
  final VoidCallback? onCompleteExit;
  final ValueChanged<ExerciseController>? onControllerReady;

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
    final controller = Get.put(
      ExerciseController(
        exercises: widget.exercises,
        lessonId: widget.lessonId,
        lessonIdByExercise: widget.lessonIdByExercise,
        recordProgress: widget.recordProgress,
        initialIndex: widget.initialIndex,
      ),
      tag: _controllerTag,
    );
    widget.onControllerReady?.call(controller);
    return controller;
  }

  @override
  void didUpdateWidget(covariant ExercisePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (listEquals(oldWidget.exercises, widget.exercises) &&
        oldWidget.lessonId == widget.lessonId &&
        mapEquals(oldWidget.lessonIdByExercise, widget.lessonIdByExercise) &&
        oldWidget.recordProgress == widget.recordProgress &&
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
    AppScreenUtil.init(context);
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
      final isReviewRound = _controller.isReviewRound.value;

      return Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        if (isReviewRound)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 9.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                            child: Text(
                              _controller.currentProgressLabel,
                              style: getTextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSecondaryContainer,
                              ),
                            ),
                          )
                        else
                          Text(
                            _controller.currentProgressLabel,
                            style: getTextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.primary,
                            ),
                          ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.star_rounded,
                                size: 15.r,
                                color: colorScheme.primary,
                              ),
                              4.hSpace,
                              Text(
                                'Score: ${_controller.correctCount} / ${_controller.answeredCount}',
                                style: getTextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    8.vSpace,
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999.r),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 7.h,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isReviewRound
                              ? AppColors.warning
                              : colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(18.w),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                LessonDetailController.formatExerciseType(
                                  exercise.type,
                                ),
                                style: getTextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                            12.vSpace,
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
                              10.vSpace,
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest
                                      .withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  'উচ্চারণ (আনুমানিক): ${exercise.pronunciationBn}',
                                  style: getTextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurfaceVariant,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      16.vSpace,
                      switch (exercise) {
                        MultipleChoiceExercise() => MultipleChoiceWidget(
                          exercise: exercise,
                          selectedIndex: _controller.selectedOptionIndex.value,
                          isChecked: isChecked,
                          onSelectOption:
                              _controller.selectMultipleChoiceOption,
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
                          onInsertSpecialChar:
                              _controller.insertCharacterInFillBlank,
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
                          selfEvaluation:
                              _controller.speakingSelfEvaluation.value,
                          isChecked: isChecked,
                          onToggleExample: _controller.toggleSpeakingExample,
                          onSelectSelfEvaluation:
                              _controller.selectSpeakingSelfEvaluation,
                        ),
                        OrderingExercise() => OrderingWidget(
                          exercise: exercise,
                          currentOrderIndices:
                              _controller.orderingIndices.toList(),
                          isChecked: isChecked,
                          onReorder: _controller.reorderItems,
                          onMoveItem: _controller.moveOrderingItem,
                        ),
                        WritingPromptExercise() => WritingPromptWidget(
                          exercise: exercise,
                          textController: _controller.writingTextController,
                          showExample: _controller.showWritingExample.value,
                          selfEvaluation:
                              _controller.writingSelfEvaluation.value,
                          isChecked: isChecked,
                          onChanged: _controller.updateWritingText,
                          onToggleExample: _controller.toggleWritingExample,
                          onSelectSelfEvaluation:
                              _controller.selectWritingSelfEvaluation,
                        ),
                      },
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(top: BorderSide(color: theme.dividerColor)),
            ),
            child: SafeArea(
              top: false,
              child: Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (isChecked) ...<Widget>[
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 200.h),
                            child: SingleChildScrollView(
                              child: ExerciseFeedbackCard(
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
                                isWritingPrompt:
                                    exercise is WritingPromptExercise,
                              ),
                            ),
                          ),
                          12.vSpace,
                        ],
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
                            onPressed: canCheck
                                ? _controller.checkAnswer
                                : null,
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
              ),
            ),
          ),
        ],
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
          padding: EdgeInsets.all(24.w),
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 68.r,
                  height: 68.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.emoji_events_rounded,
                    color: AppColors.success,
                    size: 36.r,
                  ),
                ),
                16.vSpace,
                Text(
                  'Exercises Completed!',
                  style: getTextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                8.vSpace,
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
                  8.vSpace,
                  Text(
                    'You revisited $reviewedCount ${reviewedCount == 1 ? 'tricky exercise' : 'tricky exercises'} to strengthen recall.',
                    style: getTextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                24.vSpace,
                CustomButton(
                  key: const ValueKey<String>('exercise_retry_btn'),
                  label: 'Practice Again',
                  icon: Icons.refresh_rounded,
                  backgroundColor: colorScheme.primary,
                  textColor: colorScheme.onPrimary,
                  onPressed: onRestart,
                ),
                if (onDone != null) ...<Widget>[
                  12.vSpace,
                  CustomButton(
                    key: const ValueKey<String>('exercise_done_btn'),
                    label: 'Back to Lesson',
                    isOutlined: true,
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
