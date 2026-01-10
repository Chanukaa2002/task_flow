import 'package:flutter/material.dart';

/// Responsive utility helpers using MediaQuery
class ResponsiveUtils {
  /// Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get responsive width based on percentage
  static double widthPercent(BuildContext context, double percent) {
    return screenWidth(context) * (percent / 100);
  }

  /// Get responsive height based on percentage
  static double heightPercent(BuildContext context, double percent) {
    return screenHeight(context) * (percent / 100);
  }

  /// Check if device is mobile (width < 600)
  static bool isMobile(BuildContext context) {
    return screenWidth(context) < 600;
  }

  /// Check if device is tablet (width >= 600 && width < 1024)
  static bool isTablet(BuildContext context) {
    final width = screenWidth(context);
    return width >= 600 && width < 1024;
  }

  /// Check if device is desktop (width >= 1024)
  static bool isDesktop(BuildContext context) {
    return screenWidth(context) >= 1024;
  }

  /// Get responsive padding
  static EdgeInsets responsivePadding(
    BuildContext context, {
    double mobile = 16.0,
    double tablet = 24.0,
    double desktop = 32.0,
  }) {
    if (isDesktop(context)) {
      return EdgeInsets.all(desktop);
    } else if (isTablet(context)) {
      return EdgeInsets.all(tablet);
    }
    return EdgeInsets.all(mobile);
  }

  /// Get responsive font size
  static double responsiveFontSize(BuildContext context, double baseSize) {
    final width = screenWidth(context);
    if (width < 360) {
      return baseSize * 0.9;
    } else if (width > 600) {
      return baseSize * 1.1;
    }
    return baseSize;
  }

  /// Get safe area padding
  static EdgeInsets safeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Get keyboard height
  static double keyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }
}
