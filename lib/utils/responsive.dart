import 'package:flutter/material.dart';
import 'dart:math' as math;

class Responsive {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static double maxContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 1000;
    if (width >= 900) return 800;
    if (width >= 600) return 560;
    return width;
  }

  static EdgeInsets responsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return const EdgeInsets.symmetric(horizontal: 80);
    if (width >= 900) return const EdgeInsets.symmetric(horizontal: 48);
    if (width >= 600) return const EdgeInsets.symmetric(horizontal: 32);
    return const EdgeInsets.symmetric(horizontal: 20);
  }
}

class ConstrainedContent extends StatelessWidget {
  final Widget child;
  const ConstrainedContent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final maxWidth = Responsive.maxContentWidth(context);
    final constrainedWidth = math.min(media.size.width, maxWidth);
    return Center(
      child: MediaQuery(
        data: media.copyWith(
          size: Size(constrainedWidth, media.size.height),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
