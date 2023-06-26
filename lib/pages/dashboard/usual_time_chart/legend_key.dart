import 'package:flutter/material.dart';

class LegendKey extends StatelessWidget {
  const LegendKey({
    super.key,
    required this.text,
    required this.color,
    required this.percent,
  });

  final String text;
  final Color color;
  final double percent;

  @override
  Widget build(BuildContext context) {
    var p = ((percent * 100).toStringAsFixed(1));
    if (p == '100.0') {
      p = '100';
    }
    final txt = '  $text ($p%)';
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: SizedBox(
        width: size.width * 0.40,
        child: Row(
          children: [
            Container(
              width: size.width * 0.05,
              height: size.width * 0.05,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            Text(
              txt,
            )
          ],
        ),
      ),
    );
  }
}
