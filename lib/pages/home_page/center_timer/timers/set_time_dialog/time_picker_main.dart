import 'package:flutter/material.dart';
import 'custom_number_picker.dart';

class TimePickerMain extends StatelessWidget {
  const TimePickerMain({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CustomNumberPicker(
          alignment: MainAxisAlignment.end,
          text: 'H',
        ),
        Padding(
          padding: EdgeInsets.only(left: size.width * 0.01),
          child: VerticalDivider(
            indent: size.height * 0.05,
            endIndent: size.height * 0.05,
          ),
        ),
        const CustomNumberPicker(
          alignment: MainAxisAlignment.start,
          text: 'M',
        )
      ],
    );
  }
}
