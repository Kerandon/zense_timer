import 'package:animated_music_indicator/animated_music_indicator.dart';
import 'package:zense_timer/enums/app_color_themes.dart';
import 'package:zense_timer/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../configs/constants.dart';

class CustomAnimatedGridBox extends ConsumerWidget {
  const CustomAnimatedGridBox({
    required this.onPressed,
    required this.isSelected,
    required this.contents,
    this.labelText,
    this.selectedLabelColor,
    this.labelAlignment = const Alignment(0, -0.80),
    this.showMusicBars = false,
    super.key,
  });

  final String? labelText;
  final VoidCallback? onPressed;
  final bool isSelected;
  final Widget contents;
  final Color? selectedLabelColor;
  final Alignment labelAlignment;
  final bool showMusicBars;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(appProvider);

    return ClipRRect(
      borderRadius: BorderRadius.circular(kBorderRadiusBig),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Stack(
            children: [
              Center(
                child: AnimatedContainer(
                  width: isSelected ? size.width * 0.50 : size.width * 0.45,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOutCubic,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kBorderRadiusBig),
                    border: Border.all(
                      color: isSelected
                          ? state.colorTheme == AppColorTheme.simple
                              ? Theme.of(context).colorScheme.onBackground
                              : Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.008),
                    child: contents,
                  ),
                ),
              ),
              if (labelText != null) ...[
                Align(
                  alignment: labelAlignment,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBorderRadiusBig),
                      color: isSelected
                          ? Theme.of(context).colorScheme.surface
                          : Theme.of(context).colorScheme.shadow,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(size.width * 0.02),
                      child: Text(
                        labelText!,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
              if (showMusicBars) ...[
                Align(
                  alignment: const Alignment(0.80, 0.80),
                  child: SizedBox(
                    child: AnimatedMusicIndicator(
                      animate: isSelected,
                      barStyle: BarStyle.dash,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
