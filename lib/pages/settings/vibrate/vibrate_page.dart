import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../app_components/custom_switch_list_tile.dart';
import '../../../state/app_state.dart';

class VibratePage extends ConsumerStatefulWidget {
  const VibratePage({
    super.key,
  });

  @override
  ConsumerState<VibratePage> createState() => _VibrateState();
}

class _VibrateState extends ConsumerState<VibratePage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);

    return CustomSwitchListTile(
      title: 'Vibrate on completion',
      icon: Icons.vibration_outlined,
      value: state.vibrate,
      onChanged: (value) async {
        notifier.setVibrate(value);
        if (value) {
          await Vibration.vibrate();
        }
      },
    );
  }
}
