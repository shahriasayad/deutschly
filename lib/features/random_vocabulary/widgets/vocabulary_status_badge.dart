import 'package:flutter/material.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';

class VocabularyStatusBadge extends StatelessWidget {
  const VocabularyStatusBadge({
    super.key,
    required this.status,
  });

  final LearningStatus status;

  String get _label => switch (status) {
    LearningStatus.unseen => 'New',
    LearningStatus.struggling => 'Struggling',
    LearningStatus.learning => 'Learning',
    LearningStatus.good => 'Familiar',
    LearningStatus.mastered => 'Mastered',
  };

  @override
  Widget build(BuildContext context) {
    if (status == LearningStatus.unseen) {
      return const SizedBox.shrink();
    }
    final fg = AppColors.statusColor(context, status);
    final bg = AppColors.statusContainerColor(context, status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          4.hSpace,
          Text(
            _label,
            style: getTextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
