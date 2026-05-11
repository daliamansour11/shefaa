import 'package:flutter/material.dart';

extension ResponsiveExtension on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  bool get isMobile => width < 600;

  bool get isTablet =>
      width >= 600 && width < 1024;

  bool get isDesktop => width >= 1024;

  double responsiveValue({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop) return desktop ?? tablet ?? mobile;

    if (isTablet) return tablet ?? mobile;

    return mobile;
  }
}