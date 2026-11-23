import 'package:flutter/material.dart';
import 'package:deutschly/core/custom_text_field.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/models/exercise.dart';

class WritingPromptWidget extends StatelessWidget {
  const WritingPromptWidget({
    super.key,
    required this.exercise,
    required this.textController,
    required this.showExample,
    required this.selfEvaluation,
    required this.isChecked,
    required this.onChanged,
    required this.onToggleExample,
    required this.onSelectSelfEvaluation,
  });

  final WritingPromptExercise exercise;
  final TextEditingController textController;
  final bool showExample;
  final bool? selfEvaluation;
  final bool isChecked;
  final ValueChanged<String> onChanged;
  final VoidCallback onToggleExample;
  final ValueChanged<bool> onSelectSelfEvaluation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Write your answer in German before opening the example.',
          style: getTextStyle(
            fontSize: 13,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        10.vSpace,
        CustomTextField(
          key: const ValueKey<String>('writing_response'),
          controller: textController,
          enabled: !isChecked,
          hintText: 'Write a few words or sentences in German',
          minLines: 3,
          maxLines: 6,
          onChanged: onChanged,
        ),
        14.vSpace,
        InkWell(
          key: const ValueKey<String>('writing_toggle_example'),
          onTap: onToggleExample,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  showExample ? 'Example answer' : 'Show example answer',
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
                if (showExample) ...<Widget>[
                  8.vSpace,
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
        14.vSpace,
        Text(
          'Compare your response with the example. Did you include the key information?',
          style: getTextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        10.vSpace,
        Wrap(
          spacing: 10.w,
          runSpacing: 8.h,
          children: <Widget>[
            ChoiceChip(
              key: const ValueKey<String>('writing_eval_ready'),
              label: Text(
                'I included the key details',
                style: getTextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              selected: selfEvaluation == true,
              onSelected: isChecked
                  ? null
                  : (_) => onSelectSelfEvaluation(true),
            ),
            ChoiceChip(
              key: const ValueKey<String>('writing_eval_retry'),
              label: Text(
                'I need to revise it',
                style: getTextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              selected: selfEvaluation == false,
              onSelected: isChecked
                  ? null
                  : (_) => onSelectSelfEvaluation(false),
            ),
          ],
        ),
      ],
    );
  }
}
