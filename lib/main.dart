import 'dart:async';
import 'package:upgrader/upgrader.dart';
import 'package:zense_timer/enums/app_color_themes.dart';
import 'package:zense_timer/enums/platform.dart';
import 'package:zense_timer/pages/home_page/home.dart';
import 'package:zense_timer/state/audio_state.dart';
import 'package:zense_timer/models/prefs_model.dart';
import 'package:zense_timer/state/app_state.dart';
import 'package:zense_timer/state/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'configs/constants.dart';
import 'configs/themes/app_colors.dart';
import 'configs/themes/custom_app_theme.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'dart:io';

late final AppPlatform platform;

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    platform = AppPlatform.android;
  } else if (Platform.isIOS) {
    platform = AppPlatform.iOs;
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const ProviderScope(child: ZenseApp()));
}

class ZenseApp extends ConsumerStatefulWidget {
  const ZenseApp({Key? key}) : super(key: key);

  @override
  ConsumerState<ZenseApp> createState() => ZenseAppState();
}

class ZenseAppState extends ConsumerState<ZenseApp> {
  bool _prefsUpdated = false;
  late final Future<PrefsModel> _prefFuture;

  @override
  void initState() {
    _prefFuture = DatabaseServiceAppData().getPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);
    final audioNotifier = ref.read(audioProvider.notifier);
    AppColorTheme colorTheme = AppColorTheme.sunrise;
    return FutureBuilder<dynamic>(
      future: Future.wait(
        [
          _prefFuture,
        ],
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final prefsModel = snapshot.data[0];

          colorTheme = AppColors.themeColors
              .firstWhere(
                  (element) => element.color.name == appState.colorTheme.name)
              .color;
          WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) {
              if (!_prefsUpdated) {
                appNotifier.setAllPrefs(prefsModel: prefsModel);

                audioNotifier.setAllPrefs(prefsModel);
                _prefsUpdated = true;
                Timer(
                  const Duration(milliseconds: 150),
                  () {
                    FlutterNativeSplash.remove();
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      appNotifier.setAppHasLoaded(true);
                    });
                  },
                );
              }
            },
          );
          if (appState.followOSTheme) {
            /// Detect OS brightness
            final brightness = PlatformDispatcher.instance.platformBrightness;
            bool isDarkMode = brightness == Brightness.dark;
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              appNotifier.setDarkTheme(isDarkMode);
            });
          } else {
            colorTheme = AppColors.themeColors
                .firstWhere(
                    (element) => element.color.name == appState.colorTheme.name)
                .color;
          }
        }

        final appTheme = CustomAppTheme.getThemeData(
            context: context,
            appState: appState,
            theme: colorTheme,
            brightness:
                appState.darkTheme ? Brightness.dark : Brightness.light);

        /// Gets the user's preferred [RingerModeStatus] so when the app is not in progress, will
        /// revert to this status, or when the app exits.
        // getRingerModeStatus().then((status) async {
        //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //     appNotifier.setOriginalRingerModeStatus(status);
        //   });
        // });

        return MaterialApp(
          title: kAppName,
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          home: Stack(
            children: [
              UpgradeAlert(),
              // const LifecycleState(),
              // const OnFirstInit(),
              const HomePage(),
            ],
          ),
        );
      },
    );
  }
}
