import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/custom_appbar.dart';
import 'package:deutschly/core/custom_button.dart';
import 'package:deutschly/core/empty_state_widget.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/image_path.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/progress/controller/progress_controller.dart';
import 'package:deutschly/features/progress/widgets/reset_progress_dialog.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courseController = Get.find<CourseController>();
    final progressController = Get.isRegistered<ProgressController>()
        ? Get.find<ProgressController>()
        : Get.put(ProgressController());
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(title: 'About & Info'),
      body: Obx(() {
        final course = courseController.course.value;
        if (course == null) {
          return const EmptyStateWidget(
            icon: Icons.info_outline_rounded,
            title: 'Course Info Unavailable',
            subtitle: 'Course metadata could not be loaded.',
          );
        }

        final totalVocabulary = course.lessons.fold<int>(
          0,
          (int sum, lesson) => sum + lesson.vocabulary.length,
        );
        final totalGrammar = course.lessons.fold<int>(
          0,
          (int sum, lesson) => sum + lesson.grammar.length,
        );
        final totalDialogues = course.lessons.fold<int>(
          0,
          (int sum, lesson) => sum + lesson.dialogues.length,
        );
        final totalExercises = course.lessons.fold<int>(
          0,
          (int sum, lesson) => sum + lesson.exercises.length,
        );
        final exerciseTypes =
            course.metadata?.exerciseTypes ?? const <String>[];

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.asset(
                                ImagePath.appLogo,
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  width: 52,
                                  height: 52,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    Icons.school_rounded,
                                    color: colorScheme.onPrimaryContainer,
                                    size: 26,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Deutschly',
                                    style: getTextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    course.title,
                                    style: getTextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Level ${course.level} • Version ${course.version}',
                                    style: getTextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          course.description,
                          style: getTextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurfaceVariant,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: <Widget>[
                            _InfoBadge(
                              icon: Icons.offline_pin_rounded,
                              label: '100% Offline-First',
                              color: AppColors.success,
                            ),
                            _InfoBadge(
                              icon: Icons.brightness_auto_rounded,
                              label: 'System Theme Enabled',
                              color: colorScheme.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Course Statistics',
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Column(
                      children: <Widget>[
                        _InfoRow(
                          label: 'Total Lessons',
                          value: '${course.lessons.length}',
                        ),
                        const Divider(height: 24),
                        _InfoRow(
                          label: 'Vocabulary Items (DE / EN / BN)',
                          value: '$totalVocabulary',
                        ),
                        const Divider(height: 24),
                        _InfoRow(
                          label: 'Grammar Points',
                          value: '$totalGrammar',
                        ),
                        const Divider(height: 24),
                        _InfoRow(
                          label: 'Dialogues',
                          value: '$totalDialogues',
                        ),
                        const Divider(height: 24),
                        _InfoRow(
                          label: 'Interactive Exercises',
                          value: '$totalExercises',
                        ),
                        if (exerciseTypes.isNotEmpty) ...<Widget>[
                          const Divider(height: 24),
                          _InfoRow(
                            label: 'Exercise Types Supported',
                            value: '${exerciseTypes.length}',
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    key: const ValueKey<String>('about_reset_progress_btn'),
                    label: 'Reset All Progress',
                    backgroundColor: AppColors.error,
                    textColor: Colors.white,
                    onPressed: () async {
                      final confirmed = await showResetProgressDialog(context);
                      if (confirmed) {
                        await progressController.resetAllProgress();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: getTextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: getTextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
