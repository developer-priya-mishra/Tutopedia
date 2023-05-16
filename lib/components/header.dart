import 'package:flutter/material.dart';
import 'package:tutopedia/constants/styling.dart';

class Header extends StatelessWidget {
  final String title;
  const Header({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
      child: RichText(
        text: TextSpan(
          text: "Choose by",
          style: TextStyle(
            fontSize: 15.0,
            fontFamily: primaryFont,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
          ),
          children: [
            TextSpan(
              text: "\n$title",
              style: TextStyle(
                fontFamily: secondaryFont,
                fontSize: 25.0,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        maxLines: 2,
      ),
    );
  }
}
