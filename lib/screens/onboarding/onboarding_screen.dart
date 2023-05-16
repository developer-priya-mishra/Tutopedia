import 'package:flutter/material.dart';
import 'package:tutopedia/constants/hive_boxes.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/screens/onboarding/components/page_view_content.dart';
import 'package:tutopedia/screens/onboarding/components/page_view_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();

  int currentPage = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    appLogBox.put('visitStatus', true);

                    authInfoBox.put('name', "");
                    authInfoBox.put('email', "");
                    authInfoBox.put('profilePhoto', "");
                    authInfoBox.put('authToken', "");
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  physics: const BouncingScrollPhysics(),
                  controller: pageController,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  children: const [
                    PageViewContent(
                      image: 'assets/svg/onboarding_1.svg',
                      title: "Online Study is the",
                      subtitle: "Best choice for",
                      hightLightedText: "everyone.",
                    ),
                    PageViewContent(
                      image: 'assets/svg/onboarding_2.svg',
                      title: "Best platform for both",
                      hightLightedText: "Teachers & Learners",
                    ),
                    PageViewContent(
                      image: 'assets/svg/onboarding_3.svg',
                      title: "Learn Anytime,",
                      subtitle: "Anywhere. Accelerate",
                      hightLightedText: "Your Future and beyond.",
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [0, 1, 2].map((page) {
                  return PageViewIndicator(
                    currentPage: currentPage,
                    page: page,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                  onPressed: () {
                    if (currentPage == 2) {
                      appLogBox.put('visitStatus', true);

                      authInfoBox.put('name', "");
                      authInfoBox.put('email', "");
                      authInfoBox.put('profilePhoto', "");
                      authInfoBox.put('authToken', "");
                    } else {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOutCubic,
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryColor),
                  ),
                  child: Text(
                    currentPage == 2 ? "Explore" : "Next",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
