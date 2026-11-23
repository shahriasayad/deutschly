import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:deutschly/core/app_router.dart';
import 'package:deutschly/core/custom_appbar.dart';
import 'package:deutschly/core/empty_state_widget.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/models/practice_session_item.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/exam/controller/exam_practice_controller.dart';
import 'package:deutschly/features/exam/controller/exam_timer_controller.dart';
import 'package:deutschly/features/exam/controller/listening_exam_controller.dart';
import 'package:deutschly/features/exam/models/exam_skill.dart';
import 'package:deutschly/features/exam/widgets/listening_exam_player.dart';
import 'package:deutschly/features/exercise/controller/exercise_controller.dart';
import 'package:deutschly/features/exercise/screen/exercise_screen.dart';

class ExamSectionScreen extends StatefulWidget {
  const ExamSectionScreen({
    super.key,
    required this.skill,
    required this.timed,
  });

  final ExamSkill skill;
  final bool timed;

  @override
  State<ExamSectionScreen> createState() => _ExamSectionScreenState();
}

class _ExamSectionScreenState extends State<ExamSectionScreen> {
  static int _nextSessionId = 0;

  late final String _tag;
  late final ExamTimerController _timerController;
  late final List<PracticeSessionItem> _practiceItems;
  late final ListeningExamController? _listeningController;
  ExerciseController? _exerciseController;
  Worker? _exerciseCompletionWorker;

  @override
  void initState() {
    super.initState();
    _tag = 'exam_session_${_nextSessionId++}';
    _timerController = Get.put(ExamTimerController(), tag: '$_tag timer');
    final practiceController = Get.isRegistered<ExamPracticeController>()
        ? Get.find<ExamPracticeController>()
        : Get.put(
            ExamPracticeController(
              courseController: Get.find<CourseController>(),
            ),
          );
    _practiceItems = widget.skill == ExamSkill.listening
        ? const <PracticeSessionItem>[]
        : practiceController.practiceExercisesFor(widget.skill);
    _listeningController = widget.skill == ExamSkill.listening
        ? Get.put(
            ListeningExamController(
              tasks: practiceController.listeningTasks,
              timerController: _timerController,
            ),
            tag: '$_tag listening',
          )
        : null;

    if (widget.timed) {
      _timerController.start(
        minutes: widget.skill.durationMinutes,
        onExpired: _finishForTimeout,
      );
    }
  }

  void _finishForTimeout() {
    _exerciseController?.finishSession();
    _listeningController?.finish();
  }

  void _onExerciseControllerReady(ExerciseController controller) {
    _exerciseController = controller;
    _exerciseCompletionWorker?.dispose();
    _exerciseCompletionWorker = ever<bool>(controller.isFinished, (finished) {
      if (finished) {
        _timerController.stop();
      }
    });
    if (_timerController.isExpired.value) {
      controller.finishSession();
    }
  }

  void _finishSection() {
    _timerController.stop();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.examPractice);
    }
  }

  @override
  void dispose() {
    _exerciseCompletionWorker?.dispose();
    _timerController.stop();
    unawaited(Get.delete<ExamTimerController>(tag: '$_tag timer', force: true));
    if (_listeningController != null) {
      unawaited(
        Get.delete<ListeningExamController>(
          tag: '$_tag listening',
          force: true,
        ),
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppScreenUtil.init(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppBar(
        title: '${widget.skill.title} · ${widget.skill.germanTitle}',
        leading: IconButton(
          tooltip: 'Back',
          onPressed: _finishSection,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: widget.timed
            ? <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Center(
                    child: Obx(
                      () => Text(
                        _timerController.formattedTime,
                        style: getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _timerController.secondsRemaining.value <= 60
                              ? colorScheme.error
                              : colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: Column(
        children: <Widget>[
          if (!widget.timed)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
              color: colorScheme.surfaceContainerHighest,
              child: Text(
                'Untimed practice · Exam section time: ${widget.skill.durationMinutes} minutes',
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          Expanded(
            child: widget.skill == ExamSkill.listening
                ? _buildListeningSection()
                : _buildExerciseSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildListeningSection() {
    final controller = _listeningController;
    if (controller == null || controller.tasks.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.headphones_outlined,
        title: 'No Listening Tasks',
        subtitle: 'There are no dialogue lines available for this section yet.',
      );
    }
    return ListeningExamPlayer(
      controller: controller,
      timerController: _timerController,
      onDone: _finishSection,
    );
  }

  Widget _buildExerciseSection() {
    if (_practiceItems.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.assignment_outlined,
        title: 'No Practice Tasks',
        subtitle: 'This exam section does not have practice tasks yet.',
      );
    }
    return ExercisePlayer(
      key: ValueKey<String>('exam_${widget.skill.name}_$_tag'),
      exercises: _practiceItems
          .map((PracticeSessionItem item) => item.exercise)
          .toList(growable: false),
      lessonId: _practiceItems.first.lessonId,
      lessonIdByExercise: <String, String>{
        for (final item in _practiceItems) item.exercise.id: item.lessonId,
      },
      recordProgress: false,
      onControllerReady: _onExerciseControllerReady,
      onCompleteExit: _finishSection,
    );
  }
}
