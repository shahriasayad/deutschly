import 'package:flutter/material.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/global_text_style.dart';

class ExerciseFeedbackCard extends StatelessWidget {
  const ExerciseFeedbackCard({
    super.key,
    required this.isCorrect,
    required this.correctAnswerSummary,
    this.explanation,
  });

  final bool isCorrect;
  final String correctAnswerSummary;
  final String? explanation;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = isCorrect ? AppColors.success : AppColors.error;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: statusColor,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'Correct!' : 'Incorrect',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ],
          ),
          if (!isCorrect && correctAnswerSummary.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              'Correct answer: $correctAnswerSummary',
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
          if (explanation != null && explanation!.trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              explanation!,
              style: getTextStyle(
                fontSize: 14,
                color: colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
