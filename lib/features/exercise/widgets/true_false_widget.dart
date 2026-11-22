import 'package:flutter/material.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/data/models/exercise.dart';

class TrueFalseWidget extends StatelessWidget {
  const TrueFalseWidget({
    super.key,
    required this.exercise,
    required this.selectedValue,
    required this.isChecked,
    required this.onSelect,
  });

  final TrueFalseExercise exercise;
  final bool? selectedValue;
  final bool isChecked;
  final ValueChanged<bool> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: <Widget>[
        Expanded(
          child: _TrueFalseButton(
            key: const ValueKey<String>('tf_true'),
            label: 'True',
            subtitle: 'Richtig',
            icon: Icons.check_circle_outline_rounded,
            value: true,
            selectedValue: selectedValue,
            correctValue: exercise.correct,
            isChecked: isChecked,
            colorScheme: colorScheme,
            dividerColor: theme.dividerColor,
            onTap: () => onSelect(true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _TrueFalseButton(
            key: const ValueKey<String>('tf_false'),
            label: 'False',
            subtitle: 'Falsch',
            icon: Icons.highlight_off_rounded,
            value: false,
            selectedValue: selectedValue,
            correctValue: exercise.correct,
            isChecked: isChecked,
            colorScheme: colorScheme,
            dividerColor: theme.dividerColor,
            onTap: () => onSelect(false),
          ),
        ),
      ],
    );
  }
}

class _TrueFalseButton extends StatelessWidget {
  const _TrueFalseButton({
    super.key,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.selectedValue,
    required this.correctValue,
    required this.isChecked,
    required this.colorScheme,
    required this.dividerColor,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final bool value;
  final bool? selectedValue;
  final bool correctValue;
  final bool isChecked;
  final ColorScheme colorScheme;
  final Color dividerColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedValue == value;
    final isCorrectOption = correctValue == value;

    Color borderColor = isSelected ? colorScheme.primary : dividerColor;
    Color bgColor = isSelected
        ? colorScheme.primaryContainer.withValues(alpha: 0.45)
        : colorScheme.surface;

    if (isChecked) {
      if (isCorrectOption) {
        borderColor = AppColors.success;
        bgColor = AppColors.success.withValues(alpha: 0.12);
      } else if (isSelected) {
        borderColor = AppColors.error;
        bgColor = AppColors.error.withValues(alpha: 0.12);
      }
    }

    return InkWell(
      onTap: isChecked ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: (isSelected || (isChecked && isCorrectOption)) ? 1.8 : 1,
          ),
        ),
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              size: 28,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: getTextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
