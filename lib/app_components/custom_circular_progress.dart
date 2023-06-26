import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dimensions = MediaQuery.of(context).size.width * 0.10;
    return SizedBox(
      width: dimensions,
      height: dimensions,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
