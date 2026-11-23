import 'package:flutter/material.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';
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
    final totalVocab = course.lessons.fold<int>(
      0,
      (int sum, lesson) => sum + lesson.vocabulary.length,
    );
    final totalExercises = course.lessons.fold<int>(
      0,
      (int sum, lesson) => sum + lesson.exercises.length,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              colorScheme.primary,
              Color.lerp(colorScheme.primary, AppColors.germanInk, 0.35)!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Subtle German tri-color studio ribbon
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(height: 3.h, color: AppColors.germanInk),
                ),
                Expanded(
                  child: Container(height: 3.h, color: AppColors.germanRed),
                ),
                Expanded(
                  child: Container(height: 3.h, color: AppColors.germanGold),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Wrap(
                          spacing: 8.w,
                          runSpacing: 6.h,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.onPrimary.withValues(
                                  alpha: 0.16,
                                ),
                                borderRadius: BorderRadius.circular(999.r),
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
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.onPrimary.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(999.r),
                              ),
                              child: Text(
                                'DE · EN · BN',
                                style: getTextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onPrimary.withValues(
                                    alpha: 0.9,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      8.hSpace,
                      Text(
                        '${course.lessons.length} Lessons',
                        style: getTextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimary.withValues(alpha: 0.92),
                        ),
                      ),
                    ],
                  ),
                  14.vSpace,
                  Text(
                    course.title,
                    style: getTextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  6.vSpace,
                  Text(
                    '$totalVocab words · $totalExercises interactive exercises',
                    style: getTextStyle(
                      fontSize: 13,
                      color: colorScheme.onPrimary.withValues(alpha: 0.85),
                    ),
                  ),
                  16.vSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Course Mastery',
                        style: getTextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        '$overallProgressPercent%',
                        style: getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  8.vSpace,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999.r),
                    child: LinearProgressIndicator(
                      value: overallProgress,
                      minHeight: 8.h,
                      backgroundColor: colorScheme.onPrimary.withValues(
                        alpha: 0.22,
                      ),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
