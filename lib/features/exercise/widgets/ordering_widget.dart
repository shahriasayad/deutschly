import 'package:flutter/material.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/models/exercise.dart';

class OrderingWidget extends StatelessWidget {
  const OrderingWidget({
    super.key,
    required this.exercise,
    required this.currentOrderIndices,
    required this.isChecked,
    required this.onReorder,
    required this.onMoveItem,
  });

  final OrderingExercise exercise;
  final List<int> currentOrderIndices;
  final bool isChecked;
  final void Function(int oldIndex, int newIndex) onReorder;
  final void Function(int index, int delta) onMoveItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Drag items or use the arrows to arrange them in the correct order.',
          style: getTextStyle(
            fontSize: 13,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        12.vSpace,
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: !isChecked,
          itemCount: currentOrderIndices.length,
          onReorderItem: onReorder,
          itemBuilder: (BuildContext context, int position) {
            final itemIndex = currentOrderIndices[position];
            final text = exercise.items[itemIndex];
            final isPositionCorrect = isChecked &&
                position < exercise.correctOrder.length &&
                exercise.correctOrder[position] == itemIndex;

            Color borderColor = theme.dividerColor;
            Color bgColor = colorScheme.surface;
            if (isChecked) {
              borderColor =
                  isPositionCorrect ? AppColors.success : AppColors.error;
              bgColor =
                  (isPositionCorrect ? AppColors.success : AppColors.error)
                      .withValues(alpha: 0.12);
            }

            return Container(
              key: ValueKey<String>('ordering_item_$itemIndex'),
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 26.r,
                    height: 26.r,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '${position + 1}',
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  12.hSpace,
                  Expanded(
                    child: Text(
                      text,
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  if (!isChecked) ...<Widget>[
                    IconButton(
                      key: ValueKey<String>('order_up_$position'),
                      icon: const Icon(Icons.keyboard_arrow_up_rounded),
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Move up',
                      onPressed: position > 0
                          ? () => onMoveItem(position, -1)
                          : null,
                    ),
                    IconButton(
                      key: ValueKey<String>('order_down_$position'),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Move down',
                      onPressed: position < currentOrderIndices.length - 1
                          ? () => onMoveItem(position, 1)
                          : null,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
