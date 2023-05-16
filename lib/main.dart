import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tutopedia/constants/hive_boxes.dart';
import 'package:tutopedia/screens/home_screen.dart';
import 'package:tutopedia/screens/onboarding/onboarding_screen.dart';
import 'constants/styling.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox("app_log");
  await Hive.openBox("auth_info");
  await Hive.openBox("my_courses");
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp(
    this.savedThemeMode, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryColor,
        primarySwatch: primaryColor,
        fontFamily: primaryFont,
        useMaterial3: true,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        primarySwatch: primaryColor,
        fontFamily: primaryFont,
        useMaterial3: true,
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (ThemeData lightTheme, ThemeData darkTheme) {
        return MaterialApp(
          title: 'Tutopedia',
          theme: lightTheme,
          darkTheme: darkTheme,
          debugShowCheckedModeBanner: false,
          home: ValueListenableBuilder(
            valueListenable: appLogBox.listenable(),
            builder: (context, appLogBox, child) {
              bool? visitStatus = appLogBox.get('visitStatus');
              if (visitStatus != null && visitStatus) {
                return const HomeScreen();
              } else {
                return const OnboardingScreen();
              }
            },
          ),
        );
      },
    );
  }
}
