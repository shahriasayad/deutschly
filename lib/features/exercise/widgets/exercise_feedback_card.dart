import 'package:flutter/material.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/global_text_style.dart';

class ExerciseFeedbackCard extends StatelessWidget {
  const ExerciseFeedbackCard({
    super.key,
    required this.isCorrect,
    required this.correctAnswerSummary,
    this.explanation,
    this.isSelfAssessment = false,
    this.isWritingPrompt = false,
  });

  final bool isCorrect;
  final String correctAnswerSummary;
  final String? explanation;
  final bool isSelfAssessment;
  final bool isWritingPrompt;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final feedbackTitle = switch ((
      isSelfAssessment,
      isWritingPrompt,
      isCorrect,
    )) {
      (true, true, true) => 'Writing reviewed',
      (true, true, false) => 'Revise and try again',
      (true, false, true) => 'Nice speaking practice!',
      (true, false, false) => 'Keep practicing',
      (false, _, true) => 'Correct!',
      (false, _, false) => 'Incorrect',
    };
    final statusColor = isCorrect
        ? AppColors.success
        : isSelfAssessment
        ? AppColors.warning
        : AppColors.error;

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
                isCorrect
                    ? Icons.check_circle_rounded
                    : isSelfAssessment
                    ? Icons.lightbulb_outline_rounded
                    : Icons.cancel_rounded,
                color: statusColor,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                feedbackTitle,
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ],
          ),
          if ((isSelfAssessment || !isCorrect) &&
              correctAnswerSummary.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              '${isSelfAssessment ? 'Example answer' : 'Correct answer'}: $correctAnswerSummary',
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
          if (explanation != null &&
              explanation!.trim().isNotEmpty) ...<Widget>[
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
