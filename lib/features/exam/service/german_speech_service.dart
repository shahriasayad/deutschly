import 'package:flutter_tts/flutter_tts.dart';

class GermanSpeechService {
  GermanSpeechService({FlutterTts? textToSpeech})
    : _textToSpeech = textToSpeech ?? FlutterTts();

  final FlutterTts _textToSpeech;
  bool _isReady = false;

  Future<void> initialize({
    required void Function() onStart,
    required void Function() onComplete,
    required void Function(String message) onError,
  }) async {
    _textToSpeech.setStartHandler(onStart);
    _textToSpeech.setCompletionHandler(onComplete);
    _textToSpeech.setCancelHandler(onComplete);
    _textToSpeech.setErrorHandler((message) => onError(message));

    final availability = await _textToSpeech.isLanguageAvailable('de-DE');
    if (availability == false || availability == 0) {
      throw StateError('German speech is not available on this device.');
    }
    await _textToSpeech.setLanguage('de-DE');
    await _textToSpeech.setSpeechRate(0.42);
    await _textToSpeech.awaitSpeakCompletion(true);
    _isReady = true;
  }

  Future<void> speak(String text) async {
    if (!_isReady) {
      throw StateError('German speech is not ready.');
    }
    await _textToSpeech.speak(text);
  }

  Future<void> stop() async {
    try {
      await _textToSpeech.stop();
    } catch (_) {
      // Speech cleanup should not interrupt leaving a listening session.
    }
  }
}
