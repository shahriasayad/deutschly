import 'package:flutter/material.dart';
import 'package:deutschly/core/empty_state_widget.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/pronunciation_button.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/models/dialogue.dart';

class LessonDialoguesSection extends StatelessWidget {
  const LessonDialoguesSection({
    super.key,
    required this.lessonId,
    required this.dialogues,
    required this.hideTranslations,
    required this.revealedLineKeys,
    required this.onToggleHideTranslations,
    required this.onToggleLineReveal,
  });

  final String lessonId;
  final List<Dialogue> dialogues;
  final bool hideTranslations;
  final Set<String> revealedLineKeys;
  final VoidCallback onToggleHideTranslations;
  final ValueChanged<String> onToggleLineReveal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                '${dialogues.length} Everyday Dialogues',
                style: getTextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            InkWell(
              key: const ValueKey<String>('dialogues_flashcard_toggle'),
              onTap: onToggleHideTranslations,
              borderRadius: BorderRadius.circular(999.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: hideTranslations
                      ? colorScheme.primaryContainer
                      : colorScheme.surface,
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(
                    color: hideTranslations
                        ? colorScheme.primary
                        : theme.dividerColor,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      hideTranslations
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 15.r,
                      color: colorScheme.primary,
                    ),
                    6.hSpace,
                    Text(
                      hideTranslations ? 'Flashcard: ON' : 'Flashcard: OFF',
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        12.vSpace,
        for (int i = 0; i < dialogues.length; i++) ...<Widget>[
          _DialogueCard(
            lessonId: lessonId,
            dialogueIndex: i,
            dialogue: dialogues[i],
            hideTranslations: hideTranslations,
            revealedLineKeys: revealedLineKeys,
            onToggleLineReveal: onToggleLineReveal,
          ),
          if (i < dialogues.length - 1) 14.vSpace,
        ],
      ],
    );
  }
}

class _DialogueCard extends StatelessWidget {
  const _DialogueCard({
    required this.lessonId,
    required this.dialogueIndex,
    required this.dialogue,
    required this.hideTranslations,
    required this.revealedLineKeys,
    required this.onToggleLineReveal,
  });

  final String lessonId;
  final int dialogueIndex;
  final Dialogue dialogue;
  final bool hideTranslations;
  final Set<String> revealedLineKeys;
  final ValueChanged<String> onToggleLineReveal;

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
            Builder(
              builder: (BuildContext context) {
                final line = dialogue.lines[i];
                final lineKey =
                    '${lessonId}_${dialogueIndex}_${dialogue.id}_$i';
                final isRevealed =
                    !hideTranslations || revealedLineKeys.contains(lineKey);
                return _DialogueLineRow(
                  lineKey: lineKey,
                  line: line,
                  isFirstSpeaker:
                      speakers.isEmpty || line.speaker == speakers.first,
                  isRevealed: isRevealed,
                  isFlashcardMode: hideTranslations,
                  onTap: hideTranslations
                      ? () => onToggleLineReveal(lineKey)
                      : null,
                );
              },
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
    required this.lineKey,
    required this.line,
    required this.isFirstSpeaker,
    required this.isRevealed,
    required this.isFlashcardMode,
    this.onTap,
  });

  final String lineKey;
  final DialogueLine line;
  final bool isFirstSpeaker;
  final bool isRevealed;
  final bool isFlashcardMode;
  final VoidCallback? onTap;

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
          child: Material(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(14.r),
            child: InkWell(
              key: ValueKey<String>('dialogue_line_$lineKey'),
              onTap: onTap,
              borderRadius: BorderRadius.circular(14.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: isFlashcardMode && isRevealed
                        ? colorScheme.primary.withValues(alpha: 0.45)
                        : Colors.transparent,
                  ),
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
                        'উচ্চারণ: ${line.pronunciationBn}',
                        style: getTextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                    ],
                    if (line.translationBn?.isNotEmpty == true) ...<Widget>[
                      6.vSpace,
                      if (isRevealed)
                        Text(
                          line.translationBn!,
                          style: getTextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.primary,
                            height: 1.35,
                          ),
                        )
                      else
                        Text(
                          'Tap line to reveal translation',
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
