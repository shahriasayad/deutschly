import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/custom_button.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/features/exam/controller/exam_timer_controller.dart';
import 'package:deutschly/features/exam/controller/listening_exam_controller.dart';

class ListeningExamPlayer extends StatelessWidget {
  const ListeningExamPlayer({
    super.key,
    required this.controller,
    required this.timerController,
    required this.onDone,
  });

  final ListeningExamController controller;
  final ExamTimerController timerController;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Obx(() {
      final task = controller.currentTask;
      if (controller.isFinished.value || timerController.isExpired.value) {
        return _ListeningSummary(
          correctCount: controller.correctCount.value,
          answeredCount: controller.answeredCount,
          totalCount: controller.tasks.length,
          isTimedOut: timerController.isExpired.value,
          onDone: onDone,
        );
      }
      if (task == null) {
        return const Center(child: Text('No listening tasks are available.'));
      }

      final isChecked = controller.isChecked.value;
      final selectedOption = controller.selectedOption.value;
      final answerCorrect = controller.currentAnswerCorrect;
      final playsRemaining =
          ListeningExamController.maxPlaysPerTask -
          controller.playsThisTask.value;

      return Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Listening task ${controller.currentIndex.value + 1} of ${controller.tasks.length}',
                          style: getTextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: <Widget>[
                            for (
                              int i = 0;
                              i < ListeningExamController.maxPlaysPerTask;
                              i++
                            ) ...<Widget>[
                              Container(
                                width: 8.r,
                                height: 8.r,
                                margin: EdgeInsets.only(left: 4.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: i < playsRemaining
                                      ? colorScheme.primary
                                      : theme.dividerColor,
                                ),
                              ),
                            ],
                            6.hSpace,
                            Text(
                              '$playsRemaining left',
                              style: getTextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    8.vSpace,
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999.r),
                      child: LinearProgressIndicator(
                        value:
                            (controller.currentIndex.value + 1) /
                            controller.tasks.length,
                        minHeight: 7.h,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(18.w),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(
                            alpha: 0.55,
                          ),
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              task.prompt,
                              style: getTextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                            14.vSpace,
                            FilledButton.icon(
                              onPressed: controller.canPlay
                                  ? controller.playCurrent
                                  : null,
                              icon: Icon(
                                controller.isSpeaking.value
                                    ? Icons.volume_up_rounded
                                    : Icons.play_arrow_rounded,
                                size: 18.r,
                              ),
                              label: Text(
                                controller.playButtonLabel,
                                style: getTextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (!controller.isSpeechReady.value &&
                                controller.speechError.value ==
                                    null) ...<Widget>[
                              10.vSpace,
                              const LinearProgressIndicator(),
                            ],
                            if (controller.speechError.value
                                case final error?) ...<Widget>[
                              10.vSpace,
                              Text(
                                error,
                                style: getTextStyle(
                                  fontSize: 13,
                                  color: colorScheme.error,
                                ),
                              ),
                              TextButton(
                                onPressed: controller.retrySpeechSetup,
                                child: Text(
                                  'Try audio again',
                                  style: getTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      18.vSpace,
                      for (int index = 0; index < task.options.length; index++)
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: _ListeningOption(
                            index: index,
                            text: task.options[index],
                            selected: selectedOption == index,
                            isChecked: isChecked,
                            isCorrectAnswer: index == task.correctIndex,
                            onTap: () => controller.selectOption(index),
                          ),
                        ),
                      if (answerCorrect != null) ...<Widget>[
                        6.vSpace,
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color:
                                (answerCorrect
                                        ? AppColors.success
                                        : AppColors.error)
                                    .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color:
                                  (answerCorrect
                                          ? AppColors.success
                                          : AppColors.error)
                                      .withValues(alpha: 0.55),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                answerCorrect
                                    ? 'Correct. You heard:'
                                    : 'Listen for this sentence next time:',
                                style: getTextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: answerCorrect
                                      ? AppColors.success
                                      : AppColors.error,
                                ),
                              ),
                              4.vSpace,
                              Text(
                                task.spokenText,
                                style: getTextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                    child: CustomButton(
                      label: isChecked
                          ? controller.currentIndex.value >=
                                    controller.tasks.length - 1
                                ? 'Finish listening section'
                                : 'Next listening task'
                          : 'Check answer',
                      onPressed: isChecked
                          ? controller.nextTask
                          : controller.canCheck
                          ? controller.checkAnswer
                          : null,
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

class _ListeningOption extends StatelessWidget {
  const _ListeningOption({
    required this.index,
    required this.text,
    required this.selected,
    required this.isChecked,
    required this.isCorrectAnswer,
    required this.onTap,
  });

  final int index;
  final String text;
  final bool selected;
  final bool isChecked;
  final bool isCorrectAnswer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    Color borderColor = selected ? colorScheme.primary : theme.dividerColor;
    Color bgColor = selected
        ? colorScheme.primaryContainer.withValues(alpha: 0.4)
        : colorScheme.surface;

    if (isChecked) {
      if (isCorrectAnswer) {
        borderColor = AppColors.success;
        bgColor = AppColors.success.withValues(alpha: 0.12);
      } else if (selected) {
        borderColor = AppColors.error;
        bgColor = AppColors.error.withValues(alpha: 0.12);
      }
    }

    return InkWell(
      onTap: isChecked ? null : onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: borderColor,
            width: (selected || (isChecked && isCorrectAnswer)) ? 1.6.w : 1,
          ),
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 13.r,
              backgroundColor: selected
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerHighest,
              child: Text(
                String.fromCharCode(65 + index),
                style: getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                ),
              ),
            ),
            12.hSpace,
            Expanded(
              child: Text(
                text,
                style: getTextStyle(fontSize: 14, color: colorScheme.onSurface),
              ),
            ),
            if (isChecked && isCorrectAnswer)
              Icon(
                Icons.check_circle_rounded,
                size: 22.r,
                color: AppColors.success,
              )
            else if (isChecked && selected)
              Icon(
                Icons.cancel_rounded,
                size: 22.r,
                color: AppColors.error,
              ),
          ],
        ),
      ),
    );
  }
}

class _ListeningSummary extends StatelessWidget {
  const _ListeningSummary({
    required this.correctCount,
    required this.answeredCount,
    required this.totalCount,
    required this.isTimedOut,
    required this.onDone,
  });

  final int correctCount;
  final int answeredCount;
  final int totalCount;
  final bool isTimedOut;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
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
                Icon(
                  isTimedOut ? Icons.timer_off_rounded : Icons.task_alt_rounded,
                  size: 52.r,
                  color: colorScheme.primary,
                ),
                12.vSpace,
                Text(
                  isTimedOut ? 'Time is up' : 'Listening section complete',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                8.vSpace,
                Text(
                  '$correctCount correct · $answeredCount of $totalCount answered',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    fontSize: 15,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                20.vSpace,
                CustomButton(
                  label: 'Return to exam practice',
                  onPressed: onDone,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
