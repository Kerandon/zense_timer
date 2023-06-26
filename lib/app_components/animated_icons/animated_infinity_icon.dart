import 'package:zense_timer/app_components/animated_icons/infinity_painter.dart';
import 'package:zense_timer/enums/session_state.dart';
import 'package:zense_timer/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AnimatedInfinityIcon extends ConsumerStatefulWidget {
  const AnimatedInfinityIcon({
    Key? key,
    this.color = Colors.white,
    this.strokeWidth = 20,
    this.repeatAnimation = false,
  }) : super(key: key);

  final Color color;
  final double strokeWidth;
  final bool repeatAnimation;

  @override
  ConsumerState<AnimatedInfinityIcon> createState() =>
      _AnimatedInfinityIconState();
}

class _AnimatedInfinityIconState extends ConsumerState<AnimatedInfinityIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    if (widget.repeatAnimation) {
      _controller = AnimationController(
          duration: const Duration(seconds: 60), vsync: this);
      super.initState();
      _progress = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
      )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _controller.repeat();
          }
        });
      _controller.forward();
    } else {
      _controller = AnimationController(
          duration: const Duration(milliseconds: 1200), vsync: this);
      super.initState();
      _progress = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
      );
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appProvider);
    if (appState.sessionState == SessionState.paused) {
      _controller.stop(canceled: false);
    }
    if (appState.sessionState == SessionState.inProgress) {
      if (!_controller.isAnimating) {
        _controller.forward();
      }
    }
    final size = MediaQuery.of(context).size;
    return Center(
      child: Stack(
        children: [
          FittedBox(
            child: SizedBox(
              width: size.width,
              height: size.width,
              child: CustomPaint(
                painter: InfinityPainter(
                  progress: 1,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.20),
                  strokeWidth: widget.strokeWidth * 0.60,
                ),
              ),
            ),
          ),
          FittedBox(
            child: SizedBox(
              width: size.width,
              height: size.width,
              child: CustomPaint(
                painter: InfinityPainter(
                  progress: _progress.value,
                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: widget.strokeWidth * 0.60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
