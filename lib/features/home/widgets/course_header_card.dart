import 'package:flutter/material.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/data/models/course.dart';

class CourseHeaderCard extends StatelessWidget {
  const CourseHeaderCard({
    super.key,
    required this.course,
    required this.overallProgress,
    required this.overallProgressPercent,
  });

  final Course course;
  final double overallProgress;
  final int overallProgressPercent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.82),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'CEFR ${course.level}',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${course.lessons.length} Lessons',
                style: getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onPrimary.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            course.title,
            style: getTextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            course.description,
            style: getTextStyle(
              fontSize: 13,
              color: colorScheme.onPrimary.withValues(alpha: 0.85),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Overall Progress',
                style: getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onPrimary,
                ),
              ),
              Text(
                '$overallProgressPercent%',
                style: getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: overallProgress,
              minHeight: 8,
              backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.24),
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
