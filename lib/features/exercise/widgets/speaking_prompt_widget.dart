import 'package:flutter/material.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/data/models/exercise.dart';

class SpeakingPromptWidget extends StatelessWidget {
  const SpeakingPromptWidget({
    super.key,
    required this.exercise,
    required this.showExample,
    required this.selfEvaluation,
    required this.isChecked,
    required this.onToggleExample,
    required this.onSelectSelfEvaluation,
  });

  final SpeakingPromptExercise exercise;
  final bool showExample;
  final bool? selfEvaluation;
  final bool isChecked;
  final VoidCallback onToggleExample;
  final ValueChanged<bool> onSelectSelfEvaluation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.record_voice_over_rounded,
                color: colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Say your answer out loud in German, then compare with the example answer below and self-evaluate.',
                  style: getTextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurface,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        InkWell(
          key: const ValueKey<String>('speaking_toggle_example'),
          onTap: onToggleExample,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        showExample
                            ? 'Example Answer'
                            : 'Tap to Show Example Answer',
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    Icon(
                      showExample
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                if (showExample) ...<Widget>[
                  const SizedBox(height: 10),
                  Text(
                    exercise.exampleAnswer,
                    style: getTextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'How did you do?',
          style: getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: _SelfEvalButton(
                key: const ValueKey<String>('speaking_eval_good'),
                label: 'I said it well',
                icon: Icons.thumb_up_alt_outlined,
                isSelected: selfEvaluation == true,
                activeColor: AppColors.success,
                colorScheme: colorScheme,
                dividerColor: theme.dividerColor,
                onTap: isChecked ? null : () => onSelectSelfEvaluation(true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SelfEvalButton(
                key: const ValueKey<String>('speaking_eval_retry'),
                label: 'Need practice',
                icon: Icons.refresh_rounded,
                isSelected: selfEvaluation == false,
                activeColor: AppColors.warning,
                colorScheme: colorScheme,
                dividerColor: theme.dividerColor,
                onTap: isChecked ? null : () => onSelectSelfEvaluation(false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SelfEvalButton extends StatelessWidget {
  const _SelfEvalButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.activeColor,
    required this.colorScheme,
    required this.dividerColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final Color activeColor;
  final ColorScheme colorScheme;
  final Color dividerColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.14)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : dividerColor,
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 18,
              color: isSelected ? activeColor : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
