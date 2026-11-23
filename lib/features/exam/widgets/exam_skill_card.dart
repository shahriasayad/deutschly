import 'package:flutter/material.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/features/exam/models/exam_skill.dart';

class ExamSkillCard extends StatelessWidget {
  const ExamSkillCard({
    super.key,
    required this.skill,
    required this.taskCount,
    required this.onStart,
  });

  final ExamSkill skill;
  final int taskCount;
  final VoidCallback? onStart;

  IconData get _icon => switch (skill) {
    ExamSkill.listening => Icons.headphones_rounded,
    ExamSkill.reading => Icons.menu_book_rounded,
    ExamSkill.writing => Icons.edit_note_rounded,
    ExamSkill.speaking => Icons.record_voice_over_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_icon, color: colorScheme.onPrimaryContainer),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        skill.title,
                        style: getTextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        skill.germanTitle,
                        style: getTextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${skill.durationMinutes} min',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              skill.description,
              style: getTextStyle(
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '$taskCount practice ${taskCount == 1 ? 'task' : 'tasks'}',
                    style: getTextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: taskCount == 0 ? null : onStart,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start section'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
