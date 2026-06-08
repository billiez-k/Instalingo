import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instalingo/models/chill_post.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Instagram-style post image with gradient backgrounds and real-image support.
///
/// When [post.imageUrl] is non-null, the widget displays the remote image
/// (via [Image.network]) with a gradient fallback while loading.
/// Otherwise, a vibrant deterministic gradient is rendered from the author
/// name hash, with the target word displayed prominently.
class PostImage extends StatelessWidget {
  final ChillPost post;
  final double height;
  final bool showGridOverlay;
  final bool showDecorativeCircles;

  const PostImage({
    super.key,
    required this.post,
    this.height = 240,
    this.showGridOverlay = false,
    this.showDecorativeCircles = true,
  });

  static const _grads = [
    [Color(0xFF405DE6), Color(0xFF5851DB), Color(0xFF833AB4)],
    [Color(0xFFF77737), Color(0xFFFD1D1D), Color(0xFFC13584)],
    [Color(0xFF11998E), Color(0xFF38EF7D)],
    [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    [Color(0xFFF5576C), Color(0xFFFF6B35)],
    [Color(0xFF667EEA), Color(0xFF764BA2)],
    [Color(0xFF0F3443), Color(0xFF34E89E), Color(0xFF38F9D7)],
    [Color(0xFFFF0844), Color(0xFFFFB199)],
  ];

  @override
  Widget build(BuildContext context) {
    final g = _grads[post.authorName.hashCode.abs() % _grads.length];
    final hasImage = post.imageUrl != null && post.imageUrl!.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: Container(
        width: double.infinity,
        height: height.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: g,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Real image overlay (sits on top of gradient)
            if (hasImage)
              Positioned.fill(
                child: Image.network(
                  post.imageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return _GradientOnly(
                      gradientColors: g,
                      child: _WordOverlay(post: post),
                    );
                  },
                  errorBuilder: (_, __, ___) => _GradientOnly(
                    gradientColors: g,
                    child: _WordOverlay(post: post),
                  ),
                ),
              ),

            // Decorative circles
            if (showDecorativeCircles) ...[
              Positioned(
                right: -30.w, top: -30.h,
                child: Container(
                  width: 110.w, height: 110.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.06),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              if (height > 210)
                Positioned(
                  left: -20.w, bottom: -20.h,
                  child: Container(
                    width: 100.w, height: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.04),
                        width: 1,
                      ),
                    ),
                  ),
                ),
            ],

            // Grid overlay
            if (showGridOverlay)
              Positioned.fill(
                child: CustomPaint(painter: _GridOverlay()),
              ),

            // Word overlay (only if no real image or image errored)
            if (!hasImage) _WordOverlay(post: post),
          ],
        ),
      ),
    );
  }
}

class _WordOverlay extends StatelessWidget {
  final ChillPost post;
  const _WordOverlay({required this.post});

  @override
  Widget build(BuildContext context) {
    if (post.targetWord == null || post.targetWord!.isEmpty) {
      return Center(
        child: Opacity(
          opacity: 0.3,
          child: PhosphorIcon(
            PhosphorIcons.chatCircleText(PhosphorIconsStyle.fill),
            size: 48.sp,
            color: Colors.white,
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'JLPT N5',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.6),
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              post.targetWord!,
              style: TextStyle(
                fontSize: 40.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.5,
                shadows: const [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 16,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 0.8,
                ),
              ),
              child: Text(
                'tap to learn →',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.white.withValues(alpha: 0.9),
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fallback gradient-only background during image loading.
class _GradientOnly extends StatelessWidget {
  final List<Color> gradientColors;
  final Widget? child;
  const _GradientOnly({required this.gradientColors, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: child,
    );
  }
}

class _GridOverlay extends CustomPainter {
  const _GridOverlay();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    const spacing = 30.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
