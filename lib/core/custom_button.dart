import 'package:flutter/material.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/global_text_style.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.surface,
    this.isLoading = false,
    this.width,
    this.height = 48,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool isLoading;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.surface,
                ),
              )
            : Text(
                label,
                style: getTextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
      ),
    );
  }
}
