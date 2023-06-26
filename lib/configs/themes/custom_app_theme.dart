import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../enums/app_color_themes.dart';
import '../../state/app_state.dart';
import 'app_colors.dart';

class CustomAppTheme {
  ThemeData _getThemeData({
    required Color primary,
    required Color secondary,
    required Color tertiary,
    required Brightness brightness,
    required bool isPlainTheme,
  }) {
    bool isDark = false;
    if (brightness == Brightness.dark) {
      isDark = true;
    }

    return ThemeData(
      fontFamily: GoogleFonts.lato().fontFamily,
      //(fontWeight: FontWeight.w300).fontFamily,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: isPlainTheme ? AppColors.defaultAppColor : primary,
        secondary: isPlainTheme
            ? isDark
                ? AppColors.onSurfaceDarkTheme
                : AppColors.onSurfaceLightTheme
            : secondary,
        tertiary: isPlainTheme
            ? isDark
                ? AppColors.onSurfaceDarkTheme
                : AppColors.onSurfaceLightTheme
            : tertiary,
        background: isDark
            ? AppColors.backgroundDarkTheme
            : AppColors.backgroundLightTheme,
        surface:
            isDark ? AppColors.surfaceDarkTheme : AppColors.surfaceLightTheme,
        surfaceVariant: isDark
            ? AppColors.surfaceVariantDarkTheme
            : AppColors.surfaceVariantLightTheme,
        surfaceTint:
            isDark ? AppColors.dialogDarkTheme : AppColors.dialogLightTheme,
        shadow: isDark ? AppColors.shadowDarkTheme : AppColors.shadowLightTheme,
        error: Colors.red,
        onPrimary: isDark ? Colors.black : Colors.white,
        onBackground: isPlainTheme
            ? isDark
                ? Colors.white
                : Colors.black
            : isDark
                ? Colors.white
                : Colors.black,
        onSurface: isPlainTheme
            ? isDark
                ? Colors.white
                : Colors.black
            : isDark
                ? AppColors.onSurfaceDarkTheme
                : AppColors.onSurfaceLightTheme,
        onSurfaceVariant: isDark
            ? AppColors.onSurfaceVariantDarkTheme
            : AppColors.onSurfaceVariantLightTheme,
        onError: isDark ? Colors.black : Colors.white,
        onSecondary: isDark
            ? AppColors.onSurfaceDarkTheme
            : AppColors.onSurfaceLightTheme,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
        foregroundColor: isDark ? Colors.white : Colors.black,
      )),
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.shadowDarkTheme : AppColors.shadowLightTheme,
      ),
      sliderTheme: SliderThemeData(
          inactiveTrackColor:
              isDark ? AppColors.shadowDarkTheme : AppColors.shadowLightTheme),
      switchTheme: SwitchThemeData(
        thumbColor: isPlainTheme
            ? MaterialStateProperty.all<Color>(Colors.white)
            : MaterialStateProperty.all<Color>(secondary),
        trackColor: isPlainTheme
            ? MaterialStateProperty.all<Color>(
                isDark ? Colors.black : AppColors.defaultAppColor)
            : MaterialStateProperty.all<Color>(tertiary),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData getThemeData({
    required BuildContext context,
    required AppState appState,
    required AppColorTheme theme,
    required Brightness brightness,
  }) {
    Color primary = AppColors.themeColors
        .firstWhere((element) => element.color.name == theme.name)
        .primary;
    Color secondary = AppColors.themeColors
        .firstWhere((element) => element.color.name == theme.name)
        .secondary;
    Color tertiary = AppColors.themeColors
        .firstWhere((element) => element.color.name == theme.name)
        .tertiary;

    return CustomAppTheme()._getThemeData(
      primary: primary,
      secondary: secondary,
      brightness: brightness,
      tertiary: tertiary,
      isPlainTheme: appState.colorTheme == AppColorTheme.simple,
    );
  }
}
