import 'package:flutter/material.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/models/exercise.dart';

class MultipleChoiceWidget extends StatelessWidget {
  const MultipleChoiceWidget({
    super.key,
    required this.exercise,
    required this.selectedIndex,
    required this.isChecked,
    required this.onSelectOption,
  });

  final MultipleChoiceExercise exercise;
  final int? selectedIndex;
  final bool isChecked;
  final ValueChanged<int> onSelectOption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: <Widget>[
        for (int i = 0; i < exercise.options.length; i++) ...<Widget>[
          _OptionTile(
            index: i,
            label: exercise.options[i],
            isSelected: selectedIndex == i,
            isCorrectOption: exercise.correctIndex == i,
            isChecked: isChecked,
            colorScheme: colorScheme,
            dividerColor: theme.dividerColor,
            onTap: () => onSelectOption(i),
          ),
          if (i < exercise.options.length - 1) 10.vSpace,
        ],
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.index,
    required this.label,
    required this.isSelected,
    required this.isCorrectOption,
    required this.isChecked,
    required this.colorScheme,
    required this.dividerColor,
    required this.onTap,
  });

  final int index;
  final String label;
  final bool isSelected;
  final bool isCorrectOption;
  final bool isChecked;
  final ColorScheme colorScheme;
  final Color dividerColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color borderColor = isSelected ? colorScheme.primary : dividerColor;
    Color backgroundColor = isSelected
        ? colorScheme.primaryContainer.withValues(alpha: 0.45)
        : colorScheme.surface;
    IconData? trailingIcon;
    Color? trailingColor;

    if (isChecked) {
      if (isCorrectOption) {
        borderColor = AppColors.success;
        backgroundColor = AppColors.success.withValues(alpha: 0.12);
        trailingIcon = Icons.check_circle_rounded;
        trailingColor = AppColors.success;
      } else if (isSelected) {
        borderColor = AppColors.error;
        backgroundColor = AppColors.error.withValues(alpha: 0.12);
        trailingIcon = Icons.cancel_rounded;
        trailingColor = AppColors.error;
      }
    }

    final optionLetter = String.fromCharCode(65 + index);

    return InkWell(
      key: ValueKey<String>('mc_option_$index'),
      onTap: isChecked ? null : onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: borderColor,
            width: ((isSelected || (isChecked && isCorrectOption)) ? 1.8 : 1).w,
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 30.r,
              height: 30.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Text(
                optionLetter,
                style: getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                ),
              ),
            ),
            14.hSpace,
            Expanded(
              child: Text(
                label,
                style: getTextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            if (trailingIcon != null) ...<Widget>[
              8.hSpace,
              Icon(trailingIcon, color: trailingColor, size: 22.r),
            ],
          ],
        ),
      ),
    );
  }
}
