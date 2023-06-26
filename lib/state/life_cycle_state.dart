import 'package:zense_timer/state/app_state.dart';
import 'package:zense_timer/utils/methods/ringer_status_methods.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakelock/wakelock.dart';
import 'package:timezone/data/latest.dart' as tz_data;

class LifecycleState extends ConsumerStatefulWidget {
  const LifecycleState({Key? key}) : super(key: key);

  @override
  ConsumerState<LifecycleState> createState() => _LifecycleStateState();
}

class _LifecycleStateState extends ConsumerState<LifecycleState>
    with WidgetsBindingObserver {
  AppLifecycleState _lifecycleState = AppLifecycleState.resumed;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();

    tz_data.initializeTimeZones();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _lifecycleState = AppLifecycleState.resumed;
        setState(() {});
        break;
      case AppLifecycleState.inactive:
        _lifecycleState = AppLifecycleState.inactive;
        setState(() {});
        break;
      case AppLifecycleState.paused:
        _lifecycleState = AppLifecycleState.paused;
        setState(() {});
        break;
      case AppLifecycleState.detached:
        _lifecycleState = AppLifecycleState.detached;
        setState(() {});
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      appNotifier.setLifecycleState(_lifecycleState);
    });

    if (appState.lifecycleState == AppLifecycleState.detached) {
      setDND(on: false, state: appState);
      Wakelock.disable();
    }

    return const SizedBox.shrink();
  }
}
