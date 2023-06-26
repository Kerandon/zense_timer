import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../configs/constants.dart';

class CustomStripButton extends ConsumerStatefulWidget {
  const CustomStripButton({
    super.key,
    required this.index,
    required this.title,
    required this.onPressed,
    this.duration = 180,
    this.isSelected = false,
    this.infoBar,
    this.hasAnimated,
    this.infoSheetOpen,
    this.showMusicIcon = false,
  });

  final int index;
  final Widget title;
  final bool isSelected;
  final VoidCallback onPressed;
  final int duration;
  final Widget? infoBar;
  final Function(int)? hasAnimated;
  final Function(bool)? infoSheetOpen;
  final bool showMusicIcon;

  @override
  ConsumerState<CustomStripButton> createState() => _CustomStripButtonState();
}

class _CustomStripButtonState extends ConsumerState<CustomStripButton> {
  bool _infoBarOpened = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const radius = kBorderRadiusBig;
    widget.infoSheetOpen?.call(_infoBarOpened);
    final widthPadding = size.width * 0.06;
    final heightPadding = size.height * 0.01;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.005),
      child: Container(
        constraints: BoxConstraints(
          minWidth: size.width * 0.28,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.006),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Material(
              color: widget.isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              child: InkWell(
                onTap: widget.onPressed,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      widthPadding, heightPadding, widthPadding, heightPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      widget.title,
                      if (widget.infoBar != null) ...[
                        IconButton(
                          onPressed: () {
                            _infoBarOpened = true;
                            setState(() {});

                            final sheet = showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) =>
                                    widget.infoBar ?? const SizedBox.shrink());

                            sheet.whenComplete(() {
                              _infoBarOpened = false;
                            });
                          },
                          icon: widget.showMusicIcon
                              ? Icon(
                                  Icons.audiotrack_outlined,
                                  color: widget.isSelected
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.onSurface,
                                )
                              : RotatedBox(
                                  quarterTurns: _infoBarOpened ? 1 : 3,
                                  child: Icon(
                                    Icons.arrow_back_ios_new_outlined,
                                    color: widget.isSelected
                                        ? Colors.white
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                  ),
                                ),
                        )
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    )
        .animate(onComplete: (controller) {
          widget.hasAnimated?.call(widget.index);
        })
        .fadeIn(
            duration: widget.duration.milliseconds,
            begin: 0.50,
            delay: widget.duration.milliseconds == 0.seconds
                ? 0.seconds
                : (widget.index * 50).milliseconds)
        .scaleXY(
          duration: widget.duration.milliseconds,
          begin: 0,
          delay: widget.duration.milliseconds == 0.seconds
              ? 0.seconds
              : (widget.index * 50).milliseconds,
        );
  }
}
