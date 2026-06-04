import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LottieLoader extends StatelessWidget {
  final double size;
  final String assetPath;

  const LottieLoader({
    super.key,
    this.size = 120,
    this.assetPath = 'assets/lottie/rocket.json',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.w,
      height: size.w,
      child: Lottie.asset(
        assetPath,
        repeat: true,
        animate: true,
        fit: BoxFit.contain,
      ),
    );
  }
}

class RocketLoader extends StatelessWidget {
  final double size;
  const RocketLoader({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.w,
      height: size.w,
      child: Lottie.asset(
        'assets/lottie/rocket.json',
        repeat: true,
        animate: true,
        fit: BoxFit.contain,
      ),
    );
  }
}

class PointsCompletedLottie extends StatelessWidget {
  final double size;
  const PointsCompletedLottie({super.key, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.w,
      height: size.w,
      child: Lottie.asset(
        'assets/lottie/points_completed.json',
        repeat: false,
        animate: true,
        fit: BoxFit.contain,
      ),
    );
  }
}

class DailyPointsLottie extends StatelessWidget {
  final double size;
  const DailyPointsLottie({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.w,
      height: size.w,
      child: Lottie.asset(
        'assets/lottie/daily_points.json',
        repeat: true,
        animate: true,
        fit: BoxFit.contain,
      ),
    );
  }
}
