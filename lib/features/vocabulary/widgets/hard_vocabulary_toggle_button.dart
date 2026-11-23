import 'package:flutter/material.dart';
import 'package:deutschly/core/screen_util.dart';

class HardVocabularyToggleButton extends StatelessWidget {
  const HardVocabularyToggleButton({
    super.key,
    required this.isHard,
    required this.onPressed,
  });

  final bool isHard;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      tooltip: isHard ? 'Remove from Hard Vocabulary' : 'Mark as Hard Word',
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      icon: Icon(
        isHard ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        size: 20.r,
        color: isHard ? colorScheme.secondary : colorScheme.onSurfaceVariant,
      ),
    );
  }
}
