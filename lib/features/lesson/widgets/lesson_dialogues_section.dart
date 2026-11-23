import 'package:flutter/material.dart';
import 'package:deutschly/core/empty_state_widget.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/pronunciation_button.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/models/dialogue.dart';

class LessonDialoguesSection extends StatelessWidget {
  const LessonDialoguesSection({super.key, required this.dialogues});

  final List<Dialogue> dialogues;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (dialogues.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.forum_outlined,
        title: 'No Dialogues Yet',
        subtitle: 'This lesson does not contain sample dialogues.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${dialogues.length} Everyday Dialogues',
          style: getTextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        12.vSpace,
        for (int i = 0; i < dialogues.length; i++) ...<Widget>[
          _DialogueCard(dialogue: dialogues[i]),
          if (i < dialogues.length - 1) 14.vSpace,
        ],
      ],
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
    final speakers = <String>[];
    for (final line in dialogue.lines) {
      if (!speakers.contains(line.speaker)) {
        speakers.add(line.speaker);
      }
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.forum_outlined, size: 18.r, color: colorScheme.primary),
              8.hSpace,
              Expanded(
                child: Text(
                  dialogue.title,
                  style: getTextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          14.vSpace,
          for (int i = 0; i < dialogue.lines.length; i++) ...<Widget>[
            _DialogueLineRow(
              line: dialogue.lines[i],
              isFirstSpeaker:
                  speakers.isEmpty || dialogue.lines[i].speaker == speakers.first,
            ),
            if (i < dialogue.lines.length - 1) 10.vSpace,
          ],
        ],
      ),
    );
  }
}

class _DialogueLineRow extends StatelessWidget {
  const _DialogueLineRow({
    required this.line,
    required this.isFirstSpeaker,
  });

  final DialogueLine line;
  final bool isFirstSpeaker;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final avatarBg = isFirstSpeaker
        ? colorScheme.primaryContainer
        : colorScheme.secondaryContainer;
    final avatarFg = isFirstSpeaker
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSecondaryContainer;
    final bubbleColor = isFirstSpeaker
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.48)
        : colorScheme.primaryContainer.withValues(alpha: 0.35);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 30.r,
          height: 30.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: avatarBg, shape: BoxShape.circle),
          child: Text(
            line.speaker,
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: avatarFg,
            ),
          ),
        ),
        10.hSpace,
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        line.text,
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                          height: 1.4,
                        ),
                      ),
                    ),
                    8.hSpace,
                    PronunciationIconButton(text: line.text, size: 30),
                  ],
                ),
                if (line.pronunciationBn?.isNotEmpty == true) ...<Widget>[
                  4.vSpace,
                  Text(
                    'উচ্চারণ (আনুমানিক): ${line.pronunciationBn}',
                    style: getTextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
