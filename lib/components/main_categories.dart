import 'package:flutter/material.dart';
import 'package:tutopedia/components/shimmer_box.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/models/main_category_model.dart';
import 'package:tutopedia/screens/sub_categories_screen.dart';

class MainCategories extends StatelessWidget {
  final List<MainCategoryModel> categoryList;
  const MainCategories(this.categoryList, {super.key});

  @override
  Widget build(BuildContext context) {
    if (categoryList.isNotEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categoryList.map((item) {
            return InkWell(
              borderRadius: const BorderRadius.all(
                Radius.circular(15.0),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SubCategoryScreen(mainCategory: item),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(7.5),
                width: 200.0,
                height: 115.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.indigo.shade400,
                      Colors.indigo.shade300,
                      Colors.indigo.shade200,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          text: item.title,
                          style: const TextStyle(
                            fontFamily: secondaryFont,
                          ),
                          children: [
                            TextSpan(
                              text: "\n${item.numberOfCourses} courses",
                              style: const TextStyle(
                                fontFamily: primaryFont,
                                fontSize: 10.0,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: Image.asset(
                          "assets/images/${item.title.toLowerCase()}.png",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.filled(5, 0).map((item) {
            return const ShimmerBox(
              height: 115.0,
              width: 200.0,
              borderRadius: 15.0,
              margin: 7.5,
            );
          }).toList(),
        ),
      );
    }
  }
}
