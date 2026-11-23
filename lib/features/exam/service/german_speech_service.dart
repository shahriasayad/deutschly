import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:deutschly/core/api_logger.dart';

class GermanSpeechService {
  GermanSpeechService({FlutterTts? textToSpeech})
    : _textToSpeech = textToSpeech ?? FlutterTts();

  final FlutterTts _textToSpeech;
  bool _isReady = false;
  bool _hasOfflineVoice = false;

  bool get hasOfflineVoice => _hasOfflineVoice;

  Future<void> initialize({
    required void Function() onStart,
    required void Function() onComplete,
    required void Function(String message) onError,
  }) async {
    _textToSpeech.setStartHandler(onStart);
    _textToSpeech.setCompletionHandler(onComplete);
    _textToSpeech.setCancelHandler(onComplete);
    _textToSpeech.setErrorHandler((dynamic message) {
      onError(message?.toString() ?? 'Unknown speech error');
    });

    if (!kIsWeb && Platform.isIOS) {
      await _textToSpeech.setSharedInstance(true);
      await _textToSpeech.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        <IosTextToSpeechAudioCategoryOptions>[
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
          IosTextToSpeechAudioCategoryOptions.duckOthers,
        ],
        IosTextToSpeechAudioMode.spokenAudio,
      );
    }

    final targetLocale = await _resolveSupportedGermanLocale();
    if (targetLocale == null) {
      throw StateError('German speech is not available on this device.');
    }

    await _textToSpeech.setLanguage(targetLocale);
    await _selectBestGermanVoice(targetLocale);
    await _textToSpeech.setVolume(1.0);
    await _textToSpeech.setPitch(1.0);
    await _textToSpeech.setSpeechRate(0.42);
    // Keep speak() non-blocking so Android TTS errors never leave Future callers hanging.
    await _textToSpeech.awaitSpeakCompletion(false);
    _isReady = true;
  }

  Future<String?> _resolveSupportedGermanLocale() async {
    for (final candidate in const <String>['de-DE', 'de']) {
      final availability = await _textToSpeech.isLanguageAvailable(candidate);
      if (availability == true || availability == 1) {
        return candidate;
      }
    }
    return null;
  }

  Future<void> _selectBestGermanVoice(String targetLocale) async {
    _hasOfflineVoice = false;
    try {
      if (!kIsWeb && Platform.isAndroid) {
        final installed = await _textToSpeech.isLanguageInstalled(targetLocale);
        _hasOfflineVoice = installed == true || installed == 1;
      } else {
        _hasOfflineVoice = true;
      }

      final rawVoices = await _textToSpeech.getVoices;
      if (rawVoices is! List) {
        return;
      }

      final germanVoices = <Map<String, String>>[];
      for (final dynamic item in rawVoices) {
        if (item is! Map) {
          continue;
        }
        final locale = (item['locale'] ?? '').toString();
        final normalizedLocale = locale.toLowerCase().replaceAll('_', '-');
        if (!normalizedLocale.startsWith('de')) {
          continue;
        }
        final name = (item['name'] ?? '').toString();
        if (name.isEmpty) {
          continue;
        }
        final networkRequired = (item['network_required'] ?? '').toString();
        final features = (item['features'] ?? '').toString();
        final lowerName = name.toLowerCase();
        final isOfflineCapable =
            networkRequired != '1' &&
            !lowerName.contains('-server') &&
            !lowerName.contains('-network') &&
            !features.contains('notInstalled');
        if (isOfflineCapable) {
          germanVoices.add(<String, String>{
            'name': name,
            'locale': locale,
          });
        }
      }

      if (germanVoices.isNotEmpty) {
        final preferred = germanVoices.firstWhere(
          (Map<String, String> v) =>
              v['locale']!.toLowerCase().replaceAll('_', '-') == 'de-de',
          orElse: () => germanVoices.first,
        );
        final setVoiceResult = await _textToSpeech.setVoice(preferred);
        if (setVoiceResult == 1 || setVoiceResult == true) {
          _hasOfflineVoice = true;
          ApiLogger.logInfo(
            'Selected offline German voice: ${preferred['name']} (${preferred['locale']})',
          );
          return;
        }
      }

      ApiLogger.logInfo(
        'No offline German voice selected for $targetLocale (hasOfflineVoice=$_hasOfflineVoice).',
      );
    } catch (error, stackTrace) {
      ApiLogger.logError(
        'Failed inspecting TTS voices for $targetLocale',
        error,
        stackTrace,
      );
    }
  }

  Future<void> speak(String text) async {
    if (!_isReady) {
      throw StateError('German speech is not ready.');
    }
    final result = await _textToSpeech.speak(text, focus: true);
    if (result == 0 || result == false) {
      throw StateError('German speech could not start.');
    }
  }

  Future<void> stop() async {
    try {
      await _textToSpeech.stop();
    } catch (_) {
      // Speech cleanup should not interrupt leaving a listening session.
    }
  }

  static String formatFriendlyError(String rawMessage) {
    final lower = rawMessage.toLowerCase();
    if (lower.contains('-4') ||
        lower.contains('-3') ||
        lower.contains('-8') ||
        lower.contains('network') ||
        lower.contains('not installed')) {
      return 'German voice could not play. Download the German (de-DE) voice in Device Settings → Text-to-Speech, or check your internet connection.';
    }
    return 'Could not play German audio on this device.';
  }
}
