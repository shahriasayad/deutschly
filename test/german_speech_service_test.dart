import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deutschly/features/exam/service/german_speech_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('flutter_tts');
  final methodCalls = <MethodCall>[];

  tearDown(() {
    methodCalls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('selects offline German voice and configures non-blocking speak', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
          methodCalls.add(call);
          switch (call.method) {
            case 'isLanguageAvailable':
              return true;
            case 'isLanguageInstalled':
              return true;
            case 'getVoices':
              return <Map<String, String>>[
                <String, String>{
                  'name': 'en-in-x-cxx-local',
                  'locale': 'en-IN',
                  'network_required': '0',
                  'features': '',
                },
                <String, String>{
                  'name': 'de-de-x-dea-server',
                  'locale': 'de-DE',
                  'network_required': '1',
                  'features': '',
                },
                <String, String>{
                  'name': 'de-de-x-deb-local',
                  'locale': 'de-DE',
                  'network_required': '0',
                  'features': '',
                },
              ];
            default:
              return 1;
          }
        });

    final service = GermanSpeechService();
    await service.initialize(
      onStart: () {},
      onComplete: () {},
      onError: (_) {},
    );

    final setVoiceCall = methodCalls.firstWhere(
      (MethodCall c) => c.method == 'setVoice',
    );
    expect(setVoiceCall.arguments, <String, String>{
      'name': 'de-de-x-deb-local',
      'locale': 'de-DE',
    });

    final awaitCompletionCall = methodCalls.firstWhere(
      (MethodCall c) => c.method == 'awaitSpeakCompletion',
    );
    expect(awaitCompletionCall.arguments, isFalse);

    await service.speak('Guten Morgen');
    final speakCall = methodCalls.firstWhere(
      (MethodCall c) => c.method == 'speak',
    );
    expect(speakCall.arguments, isNotNull);
  });

  test('throws StateError when speak returns 0', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
          switch (call.method) {
            case 'isLanguageAvailable':
              return true;
            case 'getVoices':
              return const <Map<String, String>>[];
            case 'speak':
              return 0;
            default:
              return 1;
          }
        });

    final service = GermanSpeechService();
    await service.initialize(
      onStart: () {},
      onComplete: () {},
      onError: (_) {},
    );

    await expectLater(service.speak('Hallo'), throwsStateError);
  });

  test('formatFriendlyError maps Android TTS -4/-3/-8 errors to guidance', () {
    final msg = GermanSpeechService.formatFriendlyError(
      'Error from TextToSpeech (speak) - -4',
    );
    expect(msg, contains('de-DE'));
    expect(msg, contains('Text-to-Speech'));
  });
}
