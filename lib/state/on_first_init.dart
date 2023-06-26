import 'package:flutter/material.dart';
import '../pages/settings/dnd/dnd_access_dialog.dart';
import '../utils/methods/check_if_first_init.dart';

class OnFirstInit extends StatefulWidget {
  const OnFirstInit({Key? key}) : super(key: key);

  @override
  State<OnFirstInit> createState() => _OnFirstInitState();
}

class _OnFirstInitState extends State<OnFirstInit> {
  late final Future<bool> _dndFuture;

  bool _dndDialogIsShown = false;

  @override
  void initState() {
    _dndFuture = checkIfDNDShownOnInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkIfDNDShownOnInit();

    return FutureBuilder(
      future: Future.wait([
        _dndFuture,
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final dndHasShown = snapshot.data![0];
          if (!dndHasShown) {
            Future.delayed(
              const Duration(seconds: 5),
              () {
                if (mounted && !_dndDialogIsShown) {
                  showDialog(
                      context: context,
                      builder: (context) => const DNDAccessDialog());
                  _dndDialogIsShown = true;
                  WidgetsBinding.instance.addPostFrameCallback(
                    (timeStamp) async {
                      await setDNDPrefs();
                    },
                  );
                }
              },
            );
          }
        }

        return const SizedBox.shrink();
      },
    );
  }
}
