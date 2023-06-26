import 'dart:math';
import 'package:zense_timer/enums/app_color_themes.dart';
import 'package:zense_timer/state/app_state.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConfettiAnimation extends ConsumerStatefulWidget {
  const ConfettiAnimation({Key? key, required this.animate}) : super(key: key);

  final bool animate;

  @override
  ConsumerState<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends ConsumerState<ConfettiAnimation> {
  late final ConfettiController _controller;
  bool _haveAnimated = false;

  @override
  void initState() {
    _controller =
        ConfettiController(duration: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ConfettiAnimation oldWidget) {
    if (widget.animate && !_haveAnimated) {
      _controller.play();
      _haveAnimated = true;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appProvider);
    return Stack(
      children: [
        Align(
          alignment: const Alignment(0, 0),
          child: ConfettiWidget(
            colors: [
              if (appState.colorTheme == AppColorTheme.simple) ...[
                Theme.of(context).colorScheme.primary,
                Colors.amber
              ],
              if (appState.colorTheme != AppColorTheme.simple) ...[
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.tertiary,
              ],
            ],
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 30,
            maxBlastForce: 150,
            gravity: 1.0,
            minimumSize: const Size(15, 20),
            maximumSize: const Size(20, 30),
            shouldLoop: false,
            confettiController: _controller,
            createParticlePath: drawStar,
          ),
        ),
      ],
    );
  }
}

Path drawStar(Size size) {
  double degToRad(double deg) => deg * (pi / 180.0);

  const numberOfPoints = 5;
  final halfWidth = size.width / 2;
  final externalRadius = halfWidth;
  final internalRadius = halfWidth / 2.5;
  final degreesPerStep = degToRad(360 / numberOfPoints);
  final halfDegreesPerStep = degreesPerStep / 2;
  final path = Path();
  final fullAngle = degToRad(360);
  path.moveTo(size.width, halfWidth);

  for (double step = 0; step < fullAngle; step += degreesPerStep) {
    path.lineTo(halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step));
    path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep));
  }
  path.close();
  return path;
}
