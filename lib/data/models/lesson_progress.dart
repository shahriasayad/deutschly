class LessonProgress {
  const LessonProgress({
    this.completedExercises = const <String>[],
    this.reviewSchedule = const <String, ExerciseReviewState>{},
    this.canDoObjectives = const <String>[],
    this.hardWords = const <String>[],
    this.score = 0,
  });

  final List<String> completedExercises;
  final Map<String, ExerciseReviewState> reviewSchedule;
  final List<String> canDoObjectives;
  final List<String> hardWords;
  final int score;

  factory LessonProgress.fromJson(Map<dynamic, dynamic> json) {
    final rawList = json['completedExercises'];
    final exercises = rawList is Iterable
        ? rawList.map((dynamic e) => e.toString()).toSet().toList()
        : const <String>[];
    final rawScore = json['score'];
    final parsedScore = rawScore is int
        ? rawScore
        : int.tryParse(rawScore?.toString() ?? '') ?? exercises.length;
    final rawSchedule = json['reviewSchedule'];
    final schedule = <String, ExerciseReviewState>{};
    if (rawSchedule is Map) {
      for (final MapEntry<dynamic, dynamic> entry in rawSchedule.entries) {
        if (entry.value is Map) {
          final state = ExerciseReviewState.fromJson(entry.value as Map);
          if (state != null) {
            schedule[entry.key.toString()] = state;
          }
        }
      }
    }

    return LessonProgress(
      completedExercises: exercises,
      reviewSchedule: schedule,
      canDoObjectives: _readStringList(json['canDoObjectives']),
      hardWords: _readStringList(json['hardWords']),
      score: parsedScore,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'completedExercises': completedExercises,
      'reviewSchedule': <String, dynamic>{
        for (final entry in reviewSchedule.entries)
          entry.key: entry.value.toJson(),
      },
      'canDoObjectives': canDoObjectives,
      'hardWords': hardWords,
      'score': score,
    };
  }

  LessonProgress copyWithCompletedExercise(String exerciseId) {
    if (completedExercises.contains(exerciseId)) {
      return this;
    }
    final updated = <String>[...completedExercises, exerciseId];
    return LessonProgress(
      completedExercises: updated,
      reviewSchedule: reviewSchedule,
      canDoObjectives: canDoObjectives,
      hardWords: hardWords,
      score: updated.length,
    );
  }

  LessonProgress copyWithAttempt({
    required String exerciseId,
    required bool correct,
    required DateTime now,
  }) {
    final previous = reviewSchedule[exerciseId];
    final successfulReviews = correct
        ? (previous?.successfulReviews ?? 0) + 1
        : 0;
    final intervalDays = !correct
        ? 1
        : switch (successfulReviews) {
            1 => 1,
            2 => 3,
            3 => 7,
            _ => ((previous?.intervalDays ?? 7) * 2).clamp(14, 60).toInt(),
          };
    final nextSchedule = Map<String, ExerciseReviewState>.from(reviewSchedule)
      ..[exerciseId] = ExerciseReviewState(
        dueAt: now.add(Duration(days: intervalDays)),
        successfulReviews: successfulReviews,
        intervalDays: intervalDays,
        attempts: (previous?.attempts ?? 0) + 1,
      );
    final nextCompleted = correct && !completedExercises.contains(exerciseId)
        ? <String>[...completedExercises, exerciseId]
        : completedExercises;

    return LessonProgress(
      completedExercises: nextCompleted,
      reviewSchedule: nextSchedule,
      canDoObjectives: canDoObjectives,
      hardWords: hardWords,
      score: nextCompleted.length,
    );
  }

  LessonProgress copyWithSeededReviewSchedule({
    required Set<String> validExerciseIds,
    required DateTime dueAt,
  }) {
    final nextSchedule = Map<String, ExerciseReviewState>.from(reviewSchedule);
    for (final exerciseId in completedExercises) {
      if (validExerciseIds.contains(exerciseId) &&
          !nextSchedule.containsKey(exerciseId)) {
        nextSchedule[exerciseId] = ExerciseReviewState(
          dueAt: dueAt,
          successfulReviews: 0,
          intervalDays: 0,
          attempts: 0,
        );
      }
    }
    if (nextSchedule.length == reviewSchedule.length) {
      return this;
    }
    return LessonProgress(
      completedExercises: completedExercises,
      reviewSchedule: nextSchedule,
      canDoObjectives: canDoObjectives,
      hardWords: hardWords,
      score: score,
    );
  }

  LessonProgress copyWithCanDoObjective(String objective, bool canDo) {
    final nextObjectives = canDoObjectives.toSet();
    if (canDo) {
      nextObjectives.add(objective);
    } else {
      nextObjectives.remove(objective);
    }
    if (nextObjectives.length == canDoObjectives.length) {
      return this;
    }
    return LessonProgress(
      completedExercises: completedExercises,
      reviewSchedule: reviewSchedule,
      canDoObjectives: nextObjectives.toList(growable: false),
      hardWords: hardWords,
      score: score,
    );
  }

  LessonProgress copyWithHardWord(String wordDe, bool isHard) {
    final nextHardWords = hardWords.toSet();
    final changed = isHard
        ? nextHardWords.add(wordDe)
        : nextHardWords.remove(wordDe);
    if (!changed) {
      return this;
    }
    return LessonProgress(
      completedExercises: completedExercises,
      reviewSchedule: reviewSchedule,
      canDoObjectives: canDoObjectives,
      hardWords: nextHardWords.toList(growable: false),
      score: score,
    );
  }

  static List<String> _readStringList(dynamic rawValue) => rawValue is Iterable
      ? rawValue.map((dynamic value) => value.toString()).toSet().toList()
      : const <String>[];
}

class ExerciseReviewState {
  const ExerciseReviewState({
    required this.dueAt,
    required this.successfulReviews,
    required this.intervalDays,
    required this.attempts,
  });

  final DateTime dueAt;
  final int successfulReviews;
  final int intervalDays;
  final int attempts;

  bool isDueAt(DateTime now) => !dueAt.isAfter(now);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'dueAt': dueAt.toIso8601String(),
    'successfulReviews': successfulReviews,
    'intervalDays': intervalDays,
    'attempts': attempts,
  };

  static ExerciseReviewState? fromJson(Map<dynamic, dynamic> json) {
    final rawDueAt = json['dueAt'];
    if (rawDueAt is! String) {
      return null;
    }
    final dueAt = DateTime.tryParse(rawDueAt);
    if (dueAt == null) {
      return null;
    }
    return ExerciseReviewState(
      dueAt: dueAt,
      successfulReviews: _readInt(json['successfulReviews']),
      intervalDays: _readInt(json['intervalDays'], fallback: 1),
      attempts: _readInt(json['attempts'], fallback: 1),
    );
  }

  static int _readInt(dynamic value, {int fallback = 0}) {
    if (value is int && value >= 0) {
      return value;
    }
    final parsed = int.tryParse(value?.toString() ?? '');
    return parsed != null && parsed >= 0 ? parsed : fallback;
  }
}
