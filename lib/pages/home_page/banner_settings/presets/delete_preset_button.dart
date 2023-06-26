import 'package:zense_timer/models/prefs_model.dart';
import 'package:flutter/material.dart';

import '../../../../state/database_service.dart';

class DeletePresetButton extends StatelessWidget {
  const DeletePresetButton({
    super.key,
    required this.preset,
  });

  final PrefsModel preset;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: InkWell(
                      onTap: () async {
                        await DatabaseServiceAppData()
                            .deletePreset(preset: preset)
                            .then((value) async {
                          await Navigator.maybePop(context).then((value) async {
                            await Navigator.maybePop(context);
                          });
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.delete_outline_outlined),
                          Text(
                            '  Delete preset?',
                            style: Theme.of(context).textTheme.labelLarge,
                          )
                        ],
                      ),
                    ),
                  ));
        },
        icon: const Icon(Icons.more_horiz_outlined));
  }
}
