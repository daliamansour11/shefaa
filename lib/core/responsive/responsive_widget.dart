import 'package:flutter/material.dart';
class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1024) {
      return desktop ?? tablet ?? mobile;
    }

    if (width >= 600) {
      return tablet ?? mobile;
    }

    return mobile;
  }
}