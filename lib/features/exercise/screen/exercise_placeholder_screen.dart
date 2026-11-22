import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:deutschly/core/app_router.dart';
import 'package:deutschly/core/custom_appbar.dart';
import 'package:deutschly/core/global_text_style.dart';

class ExercisePlaceholderScreen extends StatelessWidget {
  const ExercisePlaceholderScreen({
    super.key,
    required this.lessonId,
    this.initialIndex = 0,
  });

  final String lessonId;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Exercises',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.lessonDetail(lessonId));
            }
          },
        ),
      ),
      body: Center(
        child: Text(
          'Exercises for $lessonId (Starting at #${initialIndex + 1})',
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
