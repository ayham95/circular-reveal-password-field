import 'package:flutter/material.dart';
import 'dart:math' show sqrt, max;
import 'dart:ui' show lerpDouble;

/// [CircularAnimation] widget controls the circular reveal animation of any view (child)
class CircularAnimation extends StatelessWidget {
  /// The point that the animation starts and ends
  final Offset offset;
  final double minRadius;
  final double maxRadius;
  final Widget child;
  final Animation<double> animation;
  
  CircularAnimation({
    @required this.child,
    @required this.animation,
    this.offset,
    this.minRadius,
    this.maxRadius,
  })  : assert(child != null),
        assert(animation != null);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget _) {
        return ClipPath(
          clipper: AnimationClipper(
            fraction: animation.value,
            offset: offset,
            minRadius: minRadius,
            maxRadius: maxRadius,
          ),
          child: this.child,
        );
      },
    );
  }
}

/// [AnimationClipper] is where the magic happens.
/// The class takes the widget and redraw it on the canvas.
/// In our case, as a circular reveal.
class AnimationClipper extends CustomClipper<Path> {
  /// value between 0 and 1. It's the distance between minRadius and maxRadius
  final double fraction;
  final Offset offset;
  final double minRadius;
  final double maxRadius;

  AnimationClipper({
    @required this.fraction,
    this.offset,
    this.minRadius,
    this.maxRadius,
  });

  @override
  Path getClip(Size size) {
    final center = this.offset ?? Offset(size.width / 2, size.height / 2);
    final minRadius = this.minRadius ?? 0;
    final maxRadius = this.maxRadius ?? calcMaxRadius(size, center);

    return Path()
      ..addOval(
        Rect.fromCircle(
          center: center,
          radius: lerpDouble(minRadius, maxRadius, fraction),
        ),
      );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

  static double calcMaxRadius(Size size, Offset center) {
    final w = max(center.dx, size.width - center.dx);
    final h = max(center.dy, size.height - center.dy);
    return sqrt(w * w + h * h);
  }
}