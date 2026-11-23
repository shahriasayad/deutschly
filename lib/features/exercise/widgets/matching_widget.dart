import 'package:flutter/material.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/models/exercise.dart';

class MatchingWidget extends StatelessWidget {
  const MatchingWidget({
    super.key,
    required this.exercise,
    required this.rightOptions,
    required this.selectedLeft,
    required this.matchedPairs,
    required this.isChecked,
    required this.onSelectLeft,
    required this.onSelectRight,
  });

  final MatchingExercise exercise;
  final List<String> rightOptions;
  final String? selectedLeft;
  final Map<String, String> matchedPairs;
  final bool isChecked;
  final ValueChanged<String> onSelectLeft;
  final ValueChanged<String> onSelectRight;

  int? _badgeNumberForLeft(String left) {
    if (!matchedPairs.containsKey(left)) {
      return null;
    }
    final index =
        exercise.pairs.indexWhere((MatchingPair p) => p.left == left);
    return index >= 0 ? index + 1 : null;
  }

  String? _matchedLeftForRight(String right) {
    for (final MapEntry<String, String> entry in matchedPairs.entries) {
      if (entry.value == right) {
        return entry.key;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final leftItems =
        exercise.pairs.map((MatchingPair p) => p.left).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Tap an item on the left, then tap its match on the right.',
          style: getTextStyle(
            fontSize: 13,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        12.vSpace,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  for (int i = 0; i < leftItems.length; i++) ...<Widget>[
                    _MatchingTile(
                      key: ValueKey<String>('match_left_${leftItems[i]}'),
                      label: leftItems[i],
                      badgeNumber: _badgeNumberForLeft(leftItems[i]),
                      isSelected: selectedLeft == leftItems[i],
                      isMatched: matchedPairs.containsKey(leftItems[i]),
                      isCorrectMatch: isChecked
                          ? matchedPairs[leftItems[i]] ==
                              exercise.pairs[i].right
                          : null,
                      colorScheme: colorScheme,
                      dividerColor: theme.dividerColor,
                      onTap: isChecked
                          ? null
                          : () => onSelectLeft(leftItems[i]),
                    ),
                    if (i < leftItems.length - 1) 10.vSpace,
                  ],
                ],
              ),
            ),
            12.hSpace,
            Expanded(
              child: Column(
                children: <Widget>[
                  for (int i = 0; i < rightOptions.length; i++) ...<Widget>[
                    Builder(
                      builder: (BuildContext context) {
                        final right = rightOptions[i];
                        final matchedLeft = _matchedLeftForRight(right);
                        final badgeNumber = matchedLeft != null
                            ? _badgeNumberForLeft(matchedLeft)
                            : null;
                        bool? isCorrectMatch;
                        if (isChecked && matchedLeft != null) {
                          final expectedPair = exercise.pairs.firstWhere(
                            (MatchingPair p) => p.left == matchedLeft,
                          );
                          isCorrectMatch = expectedPair.right == right;
                        }
                        return _MatchingTile(
                          key: ValueKey<String>('match_right_$right'),
                          label: right,
                          badgeNumber: badgeNumber,
                          isSelected: false,
                          isMatched: matchedLeft != null,
                          isCorrectMatch: isCorrectMatch,
                          colorScheme: colorScheme,
                          dividerColor: theme.dividerColor,
                          onTap: isChecked
                              ? null
                              : () => onSelectRight(right),
                        );
                      },
                    ),
                    if (i < rightOptions.length - 1) 10.vSpace,
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MatchingTile extends StatelessWidget {
  const _MatchingTile({
    super.key,
    required this.label,
    required this.badgeNumber,
    required this.isSelected,
    required this.isMatched,
    required this.isCorrectMatch,
    required this.colorScheme,
    required this.dividerColor,
    required this.onTap,
  });

  final String label;
  final int? badgeNumber;
  final bool isSelected;
  final bool isMatched;
  final bool? isCorrectMatch;
  final ColorScheme colorScheme;
  final Color dividerColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Color borderColor = dividerColor;
    Color bgColor = colorScheme.surface;

    if (isCorrectMatch != null) {
      borderColor = isCorrectMatch! ? AppColors.success : AppColors.error;
      bgColor = (isCorrectMatch! ? AppColors.success : AppColors.error)
          .withValues(alpha: 0.12);
    } else if (isSelected) {
      borderColor = colorScheme.primary;
      bgColor = colorScheme.primaryContainer.withValues(alpha: 0.5);
    } else if (isMatched) {
      borderColor = colorScheme.primary.withValues(alpha: 0.7);
      bgColor = colorScheme.primaryContainer.withValues(alpha: 0.25);
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 54.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: borderColor,
            width: ((isSelected || isMatched) ? 1.6 : 1).w,
          ),
        ),
        child: Row(
          children: <Widget>[
            if (badgeNumber != null) ...<Widget>[
              Container(
                width: 22.r,
                height: 22.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$badgeNumber',
                  style: getTextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
              8.hSpace,
            ],
            Expanded(
              child: Text(
                label,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: (isSelected || isMatched)
                      ? FontWeight.w600
                      : FontWeight.w500,
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
