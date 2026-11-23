import 'package:deutschly/data/models/exercise.dart';

class PracticeSessionItem {
  const PracticeSessionItem({
    required this.lessonId,
    required this.exercise,
    this.isReview = false,
  });

  final String lessonId;
  final Exercise exercise;
  final bool isReview;
}
