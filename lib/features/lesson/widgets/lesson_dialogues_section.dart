import 'package:flutter/material.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/models/dialogue.dart';

class LessonDialoguesSection extends StatelessWidget {
  const LessonDialoguesSection({super.key, required this.dialogues});

  final List<Dialogue> dialogues;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.forum_outlined, color: colorScheme.primary, size: 20.r),
              8.hSpace,
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
          14.vSpace,
          for (int i = 0; i < dialogues.length; i++) ...<Widget>[
            _DialogueCard(dialogue: dialogues[i]),
            if (i < dialogues.length - 1) 14.vSpace,
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
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12.r),
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
          12.vSpace,
          for (int i = 0; i < dialogue.lines.length; i++) ...<Widget>[
            _DialogueLineRow(line: dialogue.lines[i], isEvenSpeaker: i.isEven),
            if (i < dialogue.lines.length - 1) 10.vSpace,
          ],
        ],
      ),
    );
  }
}

class _DialogueLineRow extends StatelessWidget {
  const _DialogueLineRow({required this.line, required this.isEvenSpeaker});

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
          width: 28.r,
          height: 28.r,
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
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  line.text,
                  style: getTextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface,
                    height: 1.4,
                  ),
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
