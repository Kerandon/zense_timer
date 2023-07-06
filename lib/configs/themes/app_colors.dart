import 'package:zense_timer/models/theme_color_model.dart';
import 'package:flutter/material.dart';

import '../../enums/app_color_themes.dart';

class AppColors {
  static List<ThemeColorModel> themeColors = [
    ThemeColorModel(
      AppColorTheme.simple,
      const Color(0xff383838),
      const Color(0xff6a6767),
      const Color(0xff050505),
    ),
    ThemeColorModel(
      AppColorTheme.dusk,
      const Color(
          0xffd21d57), // Replaced 0xffa64d79 with a brighter shade of pink
      const Color(
          0xffFB6F53), // Replaced 0xffFB9062 with a slightly darker shade of orange
      const Color(
          0xff445280), // Replaced 0xff7f7f9e with a darker shade of blue
    ),
    ThemeColorModel(
      AppColorTheme.desert,
      const Color(
          0xffe0b84d), // Replaced 0xffd4af37 with a brighter shade of gold
      const Color(
          0xff909090), // Replaced 0xffb0b0b0 with a slightly darker shade of gray
      const Color(
          0xffd21d57), // Replaced 0xffa64d79 with a brighter shade of pink (matching dusk)
    ),
    ThemeColorModel(
      AppColorTheme.forest,
      const Color(
          0xff2e845b), // Replaced 0xff337B59 with a slightly darker shade of green
      const Color(
          0xffb3d06b), // Replaced 0xffb8d282 with a slightly brighter shade of lime green
      const Color(0xff33a65c),
    ),
    ThemeColorModel(
      AppColorTheme.stone,
      const Color(
          0xff758ea9), // Replaced 0xff8ca3b4 with a slightly darker shade of blue
      const Color(0xfff5f5f5),
      const Color(
          0xff323641), // Replaced 0xff393D47 with a slightly darker shade of gray
    ),
    ThemeColorModel(
      AppColorTheme.sunrise,
      const Color(
          0xffee6b7d), // Replaced 0xffee5d6c with a slightly brighter shade of red
      const Color(
          0xffFB6F53), // Replaced 0xffFB9062 with a slightly darker shade of orange (matching dusk)
      const Color(0xff4b3d60),
    ),
    ThemeColorModel(
      AppColorTheme.ocean,
      const Color(
          0xff0057A6), // Replaced 0xff007ACC with a slightly darker shade of blue
      const Color(0xffD4E8FF),
      const Color(
          0xff003146), // Replaced 0xff003C5F with a slightly darker shade of navy blue
    ),
    ThemeColorModel(
      AppColorTheme.sky,
      const Color(
          0xff00a8ff), // Replaced 0xff00bfff with a brighter shade of blue
      const Color(0xfff5f5f5),
      const Color(
          0xff147dbb), // Replaced 0xff1da2d8 with a slightly darker shade of blue
    ),
  ];

  static const defaultAppColor = Colors.teal;

  static const backgroundLightTheme = Color(0xfff5f5f5);
  static const backgroundDarkTheme = Color(0xFF121212);

  static const surfaceLightTheme = Color(0xffebebeb);
  static const surfaceDarkTheme = Color(0xff2a2a2a);

  static const surfaceVariantDarkTheme = Color(0xFF808080);
  static const surfaceVariantLightTheme = Color(0xFF808080);

  static const onBackgroundLightTheme = Colors.black;
  static const onBackgroundDarkTheme = Colors.white;

  static const onSurfaceLightTheme = Color(0xff5c5e60);
  static const onSurfaceDarkTheme = Color(0xFFBDBDBD);

  static const onSurfaceVariantLightTheme = Color(0xFF7e7e7e);
  static const onSurfaceVariantDarkTheme = Color(0xFF7e7e7e);

  static const dialogLightTheme = Color(0xffd2d2d2);
  static const dialogDarkTheme = Color(0xFF373737);

  static const shadowLightTheme = Color(0xffdde3ec);
  static const shadowDarkTheme = Color(0xff3c3c3a);

  static const disabledButton = Colors.grey;
  static const onDisabledButton = Color(0xffe6e8e6);
}
