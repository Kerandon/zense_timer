import 'package:zense_timer/app_components/custom_switch_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../configs/constants.dart';
import '../../../state/app_state.dart';

class KeepAwakePage extends ConsumerWidget {
  const KeepAwakePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);
    return CustomSwitchListTile(
        title: kKeepAwake,
        icon: Icons.light_mode_outlined,
        value: state.keepAwake,
        onChanged: (value) => notifier.setKeepAwake(value));
  }
}
