import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tutopedia/constants/styling.dart';

class PageViewContent extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final String hightLightedText;

  const PageViewContent({
    super.key,
    required this.image,
    required this.title,
    this.subtitle = "",
    required this.hightLightedText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            SvgPicture.asset(
              image,
              width: MediaQuery.of(context).size.width,
            ),
            const SizedBox(height: 20.0),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87,
                fontSize: 25.0,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 25.0,
                  fontFamily: secondaryFont,
                ),
                textAlign: TextAlign.center,
              ),
            Stack(
              children: [
                Positioned(
                  bottom: 2,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 10.0,
                    color: primaryColor.shade100,
                  ),
                ),
                Text(
                  hightLightedText,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 25.0,
                    fontFamily: secondaryFont,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
