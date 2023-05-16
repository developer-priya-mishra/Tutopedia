import 'package:flutter/material.dart';
import 'package:tutopedia/constants/styling.dart';

class PageViewIndicator extends StatelessWidget {
  final int currentPage;
  final int page;
  const PageViewIndicator({
    super.key,
    required this.currentPage,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        color: currentPage == page ? primaryColor.shade100 : Colors.grey,
        border: Border.all(
          color: currentPage == page
              ? Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black
              : Colors.grey,
          width: currentPage == page ? 2.5 : 0,
        ),
        shape: BoxShape.circle,
      ),
      width: currentPage == page ? 10.0 : 6.0,
      height: currentPage == page ? 10.0 : 6.0,
    );
  }
}
