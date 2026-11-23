enum ExamSkill {
  listening,
  reading,
  writing,
  speaking;

  String get title => switch (this) {
    ExamSkill.listening => 'Listening',
    ExamSkill.reading => 'Reading',
    ExamSkill.writing => 'Writing',
    ExamSkill.speaking => 'Speaking',
  };

  String get germanTitle => switch (this) {
    ExamSkill.listening => 'Hören',
    ExamSkill.reading => 'Lesen',
    ExamSkill.writing => 'Schreiben',
    ExamSkill.speaking => 'Sprechen',
  };

  String get description => switch (this) {
    ExamSkill.listening =>
      'Listen to everyday German and identify what you heard.',
    ExamSkill.reading =>
      'Understand short messages, signs, and everyday information.',
    ExamSkill.writing =>
      'Write short messages and personal information in German.',
    ExamSkill.speaking =>
      'Introduce yourself, answer questions, and make requests aloud.',
  };

  int get durationMinutes => switch (this) {
    ExamSkill.listening => 20,
    ExamSkill.reading => 25,
    ExamSkill.writing => 20,
    ExamSkill.speaking => 15,
  };

  int get practiceTaskLimit => switch (this) {
    ExamSkill.listening => 10,
    ExamSkill.reading => 10,
    ExamSkill.writing => 4,
    ExamSkill.speaking => 5,
  };

  static ExamSkill? parse(String value) => ExamSkill.values
      .where((ExamSkill skill) => skill.name == value)
      .firstOrNull;
}
