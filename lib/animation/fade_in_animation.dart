import 'package:flutter/material.dart';

import '../configs/constants.dart';

class FadeInAnimation extends StatefulWidget {
  const FadeInAnimation({
    Key? key,
    required this.child,
    this.durationMilliseconds = 1200,
    this.delayMilliseconds = 0,
    this.beginScale = kScaleInBegin,
    this.beginOpacity = 0.0,
    this.animateOnDemand = false,
    this.resetBeforeAnimate = false,
    this.animationCompleted,
  }) : super(key: key);

  final Widget child;
  final int durationMilliseconds;
  final int delayMilliseconds;
  final double beginScale;
  final double beginOpacity;
  final bool animateOnDemand;
  final bool? resetBeforeAnimate;
  final VoidCallback? animationCompleted;

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale, _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: widget.durationMilliseconds),
        vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.animationCompleted?.call();
        }
      });

    _scale = Tween<double>(begin: widget.beginScale, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacity = Tween<double>(begin: widget.beginOpacity, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (!widget.animateOnDemand) {
      Future.delayed(Duration(milliseconds: widget.delayMilliseconds), () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener((status) {});
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FadeInAnimation oldWidget) {
    if (widget.animateOnDemand) {
      if (widget.resetBeforeAnimate == true) {
        _controller.reset();
        _controller.forward();
      } else if (!_controller.isAnimating) {
        _controller.forward();
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
