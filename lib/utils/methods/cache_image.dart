import 'package:flutter/material.dart';

import '../../data/app_images.dart';

Future<int> precacheAllImages({required BuildContext context}) async {
  for (var i in appImages) {
    await precacheImage(Image.asset(i).image, context);
  }
  return 1;
}
