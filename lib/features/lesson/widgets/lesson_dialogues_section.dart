import 'package:flutter/material.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/data/models/dialogue.dart';

class LessonDialoguesSection extends StatelessWidget {
  const LessonDialoguesSection({
    super.key,
    required this.dialogues,
  });

  final List<Dialogue> dialogues;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.forum_outlined,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Dialogues (${dialogues.length})',
                style: getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (int i = 0; i < dialogues.length; i++) ...<Widget>[
            _DialogueCard(dialogue: dialogues[i]),
            if (i < dialogues.length - 1) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _DialogueCard extends StatelessWidget {
  const _DialogueCard({required this.dialogue});

  final Dialogue dialogue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            dialogue.title,
            style: getTextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < dialogue.lines.length; i++) ...<Widget>[
            _DialogueLineRow(
              line: dialogue.lines[i],
              isEvenSpeaker: i.isEven,
            ),
            if (i < dialogue.lines.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _DialogueLineRow extends StatelessWidget {
  const _DialogueLineRow({
    required this.line,
    required this.isEvenSpeaker,
  });

  final DialogueLine line;
  final bool isEvenSpeaker;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final avatarBg = isEvenSpeaker
        ? colorScheme.primaryContainer
        : colorScheme.secondaryContainer;
    final avatarFg = isEvenSpeaker
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSecondaryContainer;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: avatarBg,
            shape: BoxShape.circle,
          ),
          child: Text(
            line.speaker,
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: avatarFg,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              line.text,
              style: getTextStyle(
                fontSize: 14,
                color: colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
