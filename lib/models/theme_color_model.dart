import 'package:flutter/material.dart';

import '../enums/app_color_themes.dart';

class ThemeColorModel {
  final AppColorTheme color;
  final Color primary;
  final Color secondary;
  final Color tertiary;

  ThemeColorModel(this.color, this.primary, this.secondary, this.tertiary);
}
