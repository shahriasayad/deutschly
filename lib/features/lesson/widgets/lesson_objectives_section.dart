import 'package:flutter/material.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';

class LessonObjectivesSection extends StatelessWidget {
  const LessonObjectivesSection({
    super.key,
    required this.objectives,
  });

  final List<String> objectives;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.check_circle_outline_rounded,
                color: colorScheme.primary,
                size: 20.r,
              ),
              8.hSpace,
              Text(
                'Learning Objectives',
                style: getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          12.vSpace,
          for (int i = 0; i < objectives.length; i++) ...<Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 3.h),
                  child: Icon(
                    Icons.task_alt_rounded,
                    size: 16.r,
                    color: colorScheme.primary,
                  ),
                ),
                10.hSpace,
                Expanded(
                  child: Text(
                    objectives[i],
                    style: getTextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            if (i < objectives.length - 1) 8.vSpace,
          ],
        ],
      ),
    );
  }
}
