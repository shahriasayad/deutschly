import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:deutschly/core/api_logger.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/features/exam/service/german_speech_service.dart';

/// Shared lightweight German audio player reusing [GermanSpeechService].
class GermanPronunciationPlayer {
  GermanPronunciationPlayer._();

  static final GermanSpeechService _speechService = GermanSpeechService();
  static bool _isInitialized = false;

  static Future<void> speak(String text) async {
    final cleaned = text.replaceAll('...', '').trim();
    if (cleaned.isEmpty) {
      return;
    }
    try {
      if (!_isInitialized) {
        await _speechService.initialize(
          onStart: () {},
          onComplete: () {},
          onError: (String message) {
            ApiLogger.logError('GermanPronunciationPlayer TTS error: $message');
          },
        );
        _isInitialized = true;
      }
      await _speechService.stop();
      await _speechService.speak(cleaned);
    } catch (error, stackTrace) {
      _isInitialized = false;
      ApiLogger.logError(
        'German audio playback unavailable',
        error,
        stackTrace,
      );
      unawaited(
        EasyLoading.showInfo(
          'German voice is unavailable on this device.',
        ),
      );
    }
  }
}

class PronunciationIconButton extends StatelessWidget {
  const PronunciationIconButton({
    super.key,
    required this.text,
    this.tooltip = 'Listen in German',
    this.size = 34,
  });

  final String text;
  final String tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => unawaited(GermanPronunciationPlayer.speak(text)),
        borderRadius: BorderRadius.circular(999.r),
        child: Container(
          width: size.r,
          height: size.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.7),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.volume_up_rounded,
            size: (size * 0.52).r,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
