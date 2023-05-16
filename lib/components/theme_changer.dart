import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:tutopedia/constants/styling.dart';

class ThemeChange {
  final BuildContext context;
  AdaptiveThemeMode themeMode;

  ThemeChange(
    this.context,
    this.themeMode,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  "Choose theme",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 18.0,
                  ),
                ),
              ),
              RadioListTile(
                activeColor: primaryColor,
                title: const Text("Light"),
                groupValue: themeMode,
                value: AdaptiveThemeMode.light,
                onChanged: (dynamic value) {
                  AdaptiveTheme.of(context).setLight();
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                activeColor: primaryColor,
                title: const Text("Dark"),
                groupValue: themeMode,
                value: AdaptiveThemeMode.dark,
                onChanged: (dynamic value) {
                  AdaptiveTheme.of(context).setDark();
                  Navigator.pop(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0, right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Close"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
