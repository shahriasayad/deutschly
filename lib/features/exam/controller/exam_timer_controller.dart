import 'dart:async';

import 'package:get/get.dart';

class ExamTimerController extends GetxController {
  final RxInt secondsRemaining = 0.obs;
  final RxBool isExpired = false.obs;
  Timer? _timer;

  void start({required int minutes, required void Function() onExpired}) {
    stop();
    secondsRemaining.value = minutes * 60;
    isExpired.value = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value <= 1) {
        secondsRemaining.value = 0;
        isExpired.value = true;
        timer.cancel();
        _timer = null;
        onExpired();
        return;
      }
      secondsRemaining.value--;
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  String get formattedTime {
    final minutes = secondsRemaining.value ~/ 60;
    final seconds = secondsRemaining.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    stop();
    super.onClose();
  }
}
