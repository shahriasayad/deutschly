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
  static final ValueNotifier<String?> activeText = ValueNotifier<String?>(null);
  static String? _pendingText;
  static bool _isInitialized = false;
  static bool _isBusy = false;
  static bool _ignoreNextCancel = false;

  static Future<void> speak(String text) async {
    final cleaned = text.replaceAll('...', '').trim();
    if (cleaned.isEmpty || _isBusy) {
      return;
    }
    _isBusy = true;
    _pendingText = cleaned;
    try {
      if (!_isInitialized) {
        await _speechService.initialize(
          onStart: () {
            _ignoreNextCancel = false;
            activeText.value = _pendingText;
          },
          onComplete: () {
            if (_ignoreNextCancel) {
              _ignoreNextCancel = false;
              return;
            }
            activeText.value = null;
          },
          onError: (String message) {
            _ignoreNextCancel = false;
            activeText.value = null;
            _isInitialized = false;
            ApiLogger.logError('GermanPronunciationPlayer TTS error: $message');
            unawaited(
              EasyLoading.showInfo(
                GermanSpeechService.formatFriendlyError(message),
              ),
            );
          },
        );
        _isInitialized = true;
      } else {
        if (activeText.value != null) {
          _ignoreNextCancel = true;
        }
        await _speechService.stop();
      }
      activeText.value = cleaned;
      await _speechService.speak(cleaned);
    } catch (error, stackTrace) {
      _ignoreNextCancel = false;
      activeText.value = null;
      _isInitialized = false;
      ApiLogger.logError(
        'German audio playback unavailable',
        error,
        stackTrace,
      );
      unawaited(
        EasyLoading.showInfo(
          GermanSpeechService.formatFriendlyError(error.toString()),
        ),
      );
    } finally {
      _isBusy = false;
    }
  }

  static Future<void> stop() async {
    _pendingText = null;
    if (activeText.value != null) {
      _ignoreNextCancel = true;
      activeText.value = null;
    }
    if (!_isInitialized) {
      return;
    }
    try {
      await _speechService.stop();
    } catch (error, stackTrace) {
      ApiLogger.logError('Failed stopping German audio', error, stackTrace);
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
    final cleaned = text.replaceAll('...', '').trim();

    return ValueListenableBuilder<String?>(
      valueListenable: GermanPronunciationPlayer.activeText,
      builder: (BuildContext context, String? active, _) {
        final isPlayingThis = active != null && active == cleaned;
        return Tooltip(
          message: tooltip,
          child: InkWell(
            onTap: () => unawaited(GermanPronunciationPlayer.speak(text)),
            borderRadius: BorderRadius.circular(999.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: size.r,
              height: size.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isPlayingThis
                    ? colorScheme.primary
                    : colorScheme.primaryContainer.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.volume_up_rounded,
                size: (size * 0.52).r,
                color: isPlayingThis
                    ? colorScheme.onPrimary
                    : colorScheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}
