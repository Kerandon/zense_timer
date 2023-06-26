import 'package:flutter/material.dart';
import 'custom_circular_progress.dart';

class LoadingHelper extends StatefulWidget {
  const LoadingHelper({Key? key, required this.future, this.onComplete})
      : super(key: key);

  final Future<dynamic> future;
  final VoidCallback? onComplete;

  @override
  State<LoadingHelper> createState() => _LoadingHelperState();
}

class _LoadingHelperState extends State<LoadingHelper> {
  late final Future<dynamic> _future;
  bool _callBackMade = false;

  @override
  void initState() {
    _future = widget.future;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (!_callBackMade) {
              widget.onComplete?.call();
              _callBackMade = true;
            }
            return const SizedBox();
          }

          return const CustomLoadingIndicator();
        });
  }
}
