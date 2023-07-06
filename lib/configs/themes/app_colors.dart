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
      const Color(0xffa64d79), // replaced 0xff4d2149 with 0xffa64d79
      const Color(0xffFB9062),
      const Color(0xff7f7f9e), // replaced 0xff18122B with 0xff7f7f9e
    ),
    ThemeColorModel(
      AppColorTheme.desert,
      const Color(0xffd4af37),
      const Color(0xffb0b0b0),
      const Color(0xffa64d79),
    ),
    ThemeColorModel(
      AppColorTheme.forest,
      const Color(0xff337B59),
      const Color(0xffb8d282),
      const Color(0xff33a65c), // replaced 0xff033a1e with 0xff33a65c
    ),
    ThemeColorModel(
      AppColorTheme.stone,
      const Color(0xff8ca3b4), // replaced 0xff495A64 with 0xff8ca3b4
      const Color(0xfff5f5f5),
      const Color(0xff393D47),
    ),
    ThemeColorModel(
      AppColorTheme.sunrise,
      const Color(0xffee5d6c),
      const Color(0xffFB9062),
      const Color(0xff4b3d60),
    ),
    ThemeColorModel(
      AppColorTheme.ocean,
  const Color(0xff007ACC),
      const Color(0xffD4E8FF),
      const Color(0xff003C5F),
    ),
    ThemeColorModel(
      AppColorTheme.sky,
      const Color(0xff00bfff),
      const Color(0xfff5f5f5),
      const Color(0xff1da2d8),
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
