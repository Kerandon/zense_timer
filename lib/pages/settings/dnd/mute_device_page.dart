import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../app_components/custom_switch_list_tile.dart';
import '../../../configs/constants.dart';
import '../../../state/app_state.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;

import 'dnd_access_dialog.dart';

class DNDPage extends ConsumerStatefulWidget {
  const DNDPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DNDPage> createState() => _MuteDevicePageState();
}

class _MuteDevicePageState extends ConsumerState<DNDPage> {
  bool _dialogIsShown = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);
    if (!state.muteDevice) {
      _dialogIsShown = false;
    }

    if (!_dialogIsShown && state.muteDevice) {
      _setMuteDevice(context, notifier);
      _dialogIsShown = true;
    }

    return CustomSwitchListTile(
      title: kMuteWhenMeditating,
      icon: Icons.volume_mute_outlined,
      value: state.muteDevice,
      onChanged: (value) => notifier.setDeviceIsMuted(value),
    );
  }
}

Future<void> _setMuteDevice(BuildContext context, AppNotifier notifier) async {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    permissions.Permission.accessNotificationPolicy;
    PermissionStatus permissionStatus =
        await permissions.Permission.accessNotificationPolicy.status;

    if (!permissionStatus.isGranted) {
      if (context.mounted) {
        await showDialog(
            context: context,
            builder: (context) => const DNDAccessDialog()).then((value) async {
          PermissionStatus permissionStatus =
              await permissions.Permission.accessNotificationPolicy.status;
          if (!permissionStatus.isGranted) {
            notifier.setMuteDevice(false);
          }
        });
      }
    }
  });
}
