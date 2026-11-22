class LessonProgress {
  const LessonProgress({
    this.completedExercises = const <String>[],
    this.score = 0,
  });

  final List<String> completedExercises;
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

    return LessonProgress(
      completedExercises: exercises,
      score: parsedScore,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'completedExercises': completedExercises,
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
      score: updated.length,
    );
  }
}
