import 'package:deutschly/data/models/vocabulary_item.dart';

class VocabularyExample {
  const VocabularyExample({
    required this.de,
    required this.en,
  });

  final String de;
  final String en;
}

/// Resolves natural German A1 example sentences with English translations
/// for any [VocabularyItem], supporting both existing and future lessons.
class VocabularyExampleService {
  const VocabularyExampleService._();

  static const Map<String, VocabularyExample> _curatedExamples =
      <String, VocabularyExample>{
        'guten morgen': VocabularyExample(
          de: 'Guten Morgen! Wie geht es Ihnen?',
          en: 'Good morning! How are you?',
        ),
        'guten tag': VocabularyExample(
          de: 'Guten Tag! Ich heiße Anna.',
          en: 'Hello! My name is Anna.',
        ),
        'guten abend': VocabularyExample(
          de: 'Guten Abend! Haben Sie noch geöffnet?',
          en: 'Good evening! Are you still open?',
        ),
        'gute nacht': VocabularyExample(
          de: 'Gute Nacht und schlaf gut!',
          en: 'Good night and sleep well!',
        ),
        'hallo': VocabularyExample(
          de: 'Hallo! Schön, dich zu sehen.',
          en: 'Hi! Nice to see you.',
        ),
        'tschüs': VocabularyExample(
          de: 'Tschüs, bis morgen!',
          en: 'Bye, see you tomorrow!',
        ),
        'auf wiedersehen': VocabularyExample(
          de: 'Auf Wiedersehen! Kommen Sie gut nach Hause.',
          en: 'Goodbye! Have a safe trip home.',
        ),
        'danke': VocabularyExample(
          de: 'Danke für deine Hilfe!',
          en: 'Thank you for your help!',
        ),
        'bitte': VocabularyExample(
          de: 'Ein Glas Wasser, bitte.',
          en: 'A glass of water, please.',
        ),
        'entschuldigung': VocabularyExample(
          de: 'Entschuldigung, wo ist der Bahnhof?',
          en: 'Excuse me, where is the train station?',
        ),
        'ja': VocabularyExample(
          de: 'Ja, das stimmt genau.',
          en: 'Yes, that is completely right.',
        ),
        'nein': VocabularyExample(
          de: 'Nein, ich habe heute keine Zeit.',
          en: 'No, I do not have time today.',
        ),
        'pünktlich': VocabularyExample(
          de: 'Der Zug kommt heute pünktlich an.',
          en: 'The train arrives on time today.',
        ),
        'kochen': VocabularyExample(
          de: 'Am Abend kochen wir zusammen.',
          en: 'In the evening we cook together.',
        ),
      };

  static VocabularyExample resolve(VocabularyItem item) {
    final normalized = item.de.trim().toLowerCase();
    final curated = _curatedExamples[normalized];
    if (curated != null) {
      return curated;
    }

    final rawDe = item.de.trim();
    final rawEn = _cleanEnglish(item.en);

    // Ellipsis phrases like "Ich heiße ..." -> "Ich heiße Lukas."
    if (rawDe.contains('...')) {
      final filledDe = rawDe.replaceAll('...', 'Anna').replaceAll('  ', ' ');
      final filledEn = rawEn.replaceAll('...', 'Anna').replaceAll('  ', ' ');
      return VocabularyExample(de: filledDe, en: filledEn);
    }

    // Complete questions or sentences
    if (rawDe.endsWith('?') || rawDe.endsWith('!')) {
      return VocabularyExample(
        de: rawDe,
        en: _capitalize(rawEn),
      );
    }

    // Nouns with definite articles (der / die / das)
    if (rawDe.startsWith('der ') ||
        rawDe.startsWith('die ') ||
        rawDe.startsWith('das ')) {
      return VocabularyExample(
        de: 'Hier ist $rawDe.',
        en: 'Here is the ${_stripArticle(rawEn)}.',
      );
    }

    // Verbs (lowercase infinitives ending in -en or -n)
    final isLowercaseSingleWord =
        !rawDe.contains(' ') && rawDe == rawDe.toLowerCase();
    if (isLowercaseSingleWord &&
        (rawDe.endsWith('en') || rawDe.endsWith('ern') || rawDe.endsWith('eln'))) {
      final verbEn = rawEn.startsWith('to ') ? rawEn.substring(3) : rawEn;
      return VocabularyExample(
        de: 'Ich möchte heute $rawDe.',
        en: 'I would like to $verbEn today.',
      );
    }

    // Adjectives / adverbs / other single words or short phrases
    return VocabularyExample(
      de: 'Im Alltag benutzen wir oft „$rawDe“.',
      en: 'In everyday life we often use "$rawEn".',
    );
  }

  static String _cleanEnglish(String en) {
    return en
        .replaceAll(RegExp(r'\s*\([^)]*\)'), '')
        .split('/')
        .first
        .trim();
  }

  static String _stripArticle(String en) {
    final lower = en.toLowerCase();
    if (lower.startsWith('the ')) {
      return en.substring(4);
    }
    if (lower.startsWith('a ')) {
      return en.substring(2);
    }
    if (lower.startsWith('an ')) {
      return en.substring(3);
    }
    return en;
  }

  static String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1);
  }
}
