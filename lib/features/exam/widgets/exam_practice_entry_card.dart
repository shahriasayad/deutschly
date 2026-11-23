import 'package:flutter/material.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';

class ExamPracticeEntryCard extends StatelessWidget {
  const ExamPracticeEntryCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.r),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.assignment_outlined,
                size: 22.r,
                color: colorScheme.primary,
              ),
              12.hSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'A1 exam practice',
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    3.vSpace,
                    Text(
                      'Prepare listening, reading, writing, and speaking.',
                      style: getTextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              8.hSpace,
              Icon(
                Icons.chevron_right_rounded,
                size: 22.r,
                color: colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
