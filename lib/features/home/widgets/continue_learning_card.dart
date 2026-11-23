import 'package:flutter/material.dart';
import 'package:deutschly/core/custom_button.dart';
import 'package:deutschly/core/global_text_style.dart';

class ContinueLearningCard extends StatelessWidget {
  const ContinueLearningCard({
    super.key,
    required this.exerciseCount,
    required this.reviewCount,
    required this.onStart,
  });

  final int exerciseCount;
  final int reviewCount;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasSession = exerciseCount > 0;

    return Card(
      elevation: 0,
      color: colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.bolt_rounded,
                  color: colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Continue learning',
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              hasSession
                  ? reviewCount > 0
                        ? '$reviewCount review ${reviewCount == 1 ? 'item is' : 'items are'} due, with ${exerciseCount - reviewCount} new ${exerciseCount - reviewCount == 1 ? 'exercise' : 'exercises'}.'
                        : 'A short practice session with $exerciseCount new ${exerciseCount == 1 ? 'exercise' : 'exercises'} from your course.'
                  : 'You have completed every lesson exercise. Revisit a lesson to keep practicing.',
              style: getTextStyle(
                fontSize: 14,
                color: colorScheme.onSecondaryContainer,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            CustomButton(
              label: hasSession ? 'Start short practice' : 'Course complete',
              onPressed: onStart,
              backgroundColor: colorScheme.primary,
              textColor: colorScheme.onPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
