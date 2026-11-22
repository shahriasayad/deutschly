import 'package:flutter/material.dart';
import 'package:deutschly/core/custom_text_field.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/data/models/exercise.dart';

class FillBlankWidget extends StatelessWidget {
  const FillBlankWidget({
    super.key,
    required this.exercise,
    required this.textController,
    required this.isChecked,
    required this.onChanged,
    required this.onSubmitted,
    required this.onInsertSpecialChar,
  });

  final FillBlankExercise exercise;
  final TextEditingController textController;
  final bool isChecked;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onInsertSpecialChar;

  static const List<String> _germanChars = <String>[
    'ä',
    'ö',
    'ü',
    'ß',
    'Ä',
    'Ö',
    'Ü',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomTextField(
          controller: textController,
          enabled: !isChecked,
          hintText: 'Type your German answer...',
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _germanChars
              .map(
                (String char) => InkWell(
                  key: ValueKey<String>('umlaut_$char'),
                  onTap: isChecked ? null : () => onInsertSpecialChar(char),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Text(
                      char,
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
