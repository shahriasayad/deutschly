import 'dart:math';
import 'package:flutter/material.dart';

class AppScreenUtil {
  AppScreenUtil._();

  static double screenWidth = 0;
  static double screenHeight = 0;
  static Orientation orientation = Orientation.portrait;
  static bool _isInitialized = false;

  /// Minimum logical width for scaling calculations on compact viewports.
  static const double _minScalingConstraint = 320.0;

  /// Maximum logical width before we stop scaling up to prevent tablet distortion.
  static const double _maxScalingConstraint = 450.0;

  /// Maximum logical width for text scaling to preserve readability on large screens.
  static const double _maxTextScalingConstraint = 430.0;

  /// Base generic mobile dimensions for scaling calculations.
  static const double _mobileWidthBaseline = 390.0;
  static const double _mobileHeightBaseline = 844.0;

  static const double _minHeightScaleFactor = 0.85;
  static const double _maxHeightScaleFactor =
      _maxScalingConstraint / _mobileWidthBaseline;

  static bool get isInitialized => _isInitialized;

  static bool get isTablet =>
      _isInitialized && min(screenWidth, screenHeight) >= 600.0;

  static void init(BuildContext context) {
    final size = MediaQuery.maybeSizeOf(context);
    // Prevent initializing with invalid or zero dimensions during early app startup.
    if (size == null || size.width <= 0 || size.height <= 0) {
      return;
    }

    final currentOrientation = size.width > size.height
        ? Orientation.landscape
        : Orientation.portrait;
    if (_isInitialized &&
        screenWidth == size.width &&
        screenHeight == size.height &&
        orientation == currentOrientation) {
      return;
    }

    screenWidth = size.width;
    screenHeight = size.height;
    orientation = currentOrientation;
    _isInitialized = true;
  }

  @visibleForTesting
  static void reset() {
    screenWidth = 0;
    screenHeight = 0;
    orientation = Orientation.portrait;
    _isInitialized = false;
  }

  /// Device-adaptive scale factor using the shortest side.
  /// Clamped to avoid extreme shrinking on tiny viewports or bloated scaling on tablets.
  static double get scaleFactor {
    if (!_isInitialized) {
      return 1.0;
    }

    final shortestSide = min(screenWidth, screenHeight);
    final clampedSide = shortestSide
        .clamp(_minScalingConstraint, _maxScalingConstraint)
        .toDouble();

    return clampedSide / _mobileWidthBaseline;
  }

  /// Vertical scale factor bounded by available viewport height so landscape and
  /// compact-height screens keep vertical spacing comfortable without overflowing.
  static double get heightScaleFactor {
    if (!_isInitialized) {
      return 1.0;
    }

    final heightRatio = (screenHeight / _mobileHeightBaseline)
        .clamp(_minHeightScaleFactor, _maxHeightScaleFactor)
        .toDouble();

    return min(scaleFactor, heightRatio);
  }

  /// Text scale factor that caps sooner than layout scale to maintain readability
  /// without becoming oversized on tablets and desktops.
  static double get textScaleFactor {
    if (!_isInitialized) {
      return 1.0;
    }

    final shortestSide = min(screenWidth, screenHeight);
    final clampedSide = shortestSide
        .clamp(_minScalingConstraint, _maxTextScalingConstraint)
        .toDouble();

    return clampedSide / _mobileWidthBaseline;
  }
}

extension ResponsiveExtension on num {
  /// Responsive width: scales adaptively based on shortest side, safely clamped for tablets.
  double get w => this * AppScreenUtil.scaleFactor;

  /// Responsive height: scales adaptively while respecting available vertical space.
  double get h => this * AppScreenUtil.heightScaleFactor;

  /// Responsive text size: scales gracefully and caps earlier for readability.
  double get sp => this * AppScreenUtil.textScaleFactor;

  /// Responsive radius.
  double get r => this * AppScreenUtil.scaleFactor;

  Widget get vSpace => SizedBox(height: h);

  Widget get hSpace => SizedBox(width: w);
}
