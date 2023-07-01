import 'package:flutter/material.dart';

import '../configs/constants.dart';

class FadeAnimation extends StatefulWidget {
  const FadeAnimation({
    Key? key,
    required this.animate,
    this.child,
    this.reverse = false,
    this.reset = false,
    this.onComplete,
  }) : super(key: key);

  final Widget? child;
  final bool animate, reset;
  final bool reverse;
  final VoidCallback? onComplete;

  @override
  State<FadeAnimation> createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: kFadeInTimeSlow), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete?.call();
        }
      });

    double begin = 0.0, end = 1.0;
    if (widget.reverse) {
      begin = 1.0;
      end = 0.0;
    }
    _fade = Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutSine));

    super.initState();
  }

  @override
  void dispose() {
    _controller.removeStatusListener((status) {});
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FadeAnimation oldWidget) {
    if (widget.animate && !_controller.isAnimating) {
      if (mounted) {
        _controller.forward();
      }
    }
    if (widget.reset) {
      _controller.reset();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: kFadeInTimeSlow),
      opacity: _fade.value,
      child: widget.child ?? const SizedBox.shrink(),
    );
  }
}
