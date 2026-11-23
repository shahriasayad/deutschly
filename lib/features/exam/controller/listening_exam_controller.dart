import 'dart:async';

import 'package:get/get.dart';
import 'package:deutschly/features/exam/controller/exam_timer_controller.dart';
import 'package:deutschly/features/exam/models/listening_task.dart';
import 'package:deutschly/features/exam/service/german_speech_service.dart';

class ListeningExamController extends GetxController {
  ListeningExamController({
    required this.tasks,
    required ExamTimerController timerController,
    GermanSpeechService? speechService,
  }) : _timerController = timerController,
       _speechService = speechService ?? GermanSpeechService();

  static const int maxPlaysPerTask = 2;

  final List<ListeningTask> tasks;
  final ExamTimerController _timerController;
  final GermanSpeechService _speechService;

  final RxInt currentIndex = 0.obs;
  final RxInt playsThisTask = 0.obs;
  final RxnInt selectedOption = RxnInt();
  final RxBool isChecked = false.obs;
  final RxBool isFinished = false.obs;
  final RxBool isSpeechReady = false.obs;
  final RxBool isSpeaking = false.obs;
  final RxnString speechError = RxnString();
  final RxInt correctCount = 0.obs;

  ListeningTask? get currentTask =>
      currentIndex.value >= 0 && currentIndex.value < tasks.length
      ? tasks[currentIndex.value]
      : null;

  bool get canPlay =>
      isSpeechReady.value &&
      !isSpeaking.value &&
      !isChecked.value &&
      playsThisTask.value < maxPlaysPerTask &&
      !_timerController.isExpired.value;

  bool get canCheck =>
      selectedOption.value != null &&
      playsThisTask.value > 0 &&
      !isChecked.value &&
      !isFinished.value &&
      !_timerController.isExpired.value;

  String get playButtonLabel {
    if (!isSpeechReady.value) {
      return 'Preparing German audio…';
    }
    if (isSpeaking.value) {
      return 'Playing audio…';
    }
    return playsThisTask.value == 0
        ? 'Play audio (2 plays)'
        : 'Play again (${maxPlaysPerTask - playsThisTask.value} left)';
  }

  @override
  void onInit() {
    super.onInit();
    unawaited(_initializeSpeech());
  }

  Future<void> _initializeSpeech() async {
    speechError.value = null;
    try {
      await _speechService.initialize(
        onStart: () => isSpeaking.value = true,
        onComplete: () => isSpeaking.value = false,
        onError: (String message) {
          if (isSpeaking.value && playsThisTask.value > 0) {
            playsThisTask.value--;
          }
          isSpeaking.value = false;
          speechError.value = GermanSpeechService.formatFriendlyError(message);
        },
      );
      isSpeechReady.value = true;
    } catch (_) {
      isSpeechReady.value = false;
      speechError.value =
          'No German voice is available. Enable or install a German voice in device text-to-speech settings, then retry.';
    }
  }

  Future<void> retrySpeechSetup() => _initializeSpeech();

  Future<void> playCurrent() async {
    final task = currentTask;
    if (task == null || !canPlay) {
      return;
    }
    playsThisTask.value++;
    speechError.value = null;
    try {
      isSpeaking.value = true;
      await _speechService.speak(task.spokenText);
    } catch (_) {
      playsThisTask.value--;
      isSpeaking.value = false;
      speechError.value = 'Could not play German audio. Try again.';
    }
  }

  void selectOption(int index) {
    if (isChecked.value ||
        index < 0 ||
        index >= (currentTask?.options.length ?? 0)) {
      return;
    }
    selectedOption.value = index;
  }

  bool? get currentAnswerCorrect {
    if (!isChecked.value || currentTask == null) {
      return null;
    }
    return selectedOption.value == currentTask!.correctIndex;
  }

  void checkAnswer() {
    if (!canCheck || currentTask == null) {
      return;
    }
    isChecked.value = true;
    if (selectedOption.value == currentTask!.correctIndex) {
      correctCount.value++;
    }
  }

  void nextTask() {
    if (!isChecked.value || isFinished.value) {
      return;
    }
    if (currentIndex.value >= tasks.length - 1) {
      finish();
      return;
    }
    currentIndex.value++;
    selectedOption.value = null;
    isChecked.value = false;
    playsThisTask.value = 0;
  }

  void finish() {
    isFinished.value = true;
    isSpeaking.value = false;
    unawaited(_speechService.stop());
  }

  int get answeredCount =>
      isChecked.value ? currentIndex.value + 1 : currentIndex.value;

  @override
  void onClose() {
    unawaited(_speechService.stop());
    super.onClose();
  }
}
