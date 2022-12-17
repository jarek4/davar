import 'package:davar/src/authentication/authentication.dart';
import 'package:davar/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'onboarding_bottom_bar.dart';
import 'slide.dart';
import 'slides_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  static const routeName = '/onboarding';

  static const List<String> slidesTitles = [
    'DAVAR',
    'Cool, Quickly, Fluently',
    'There is no need to wait,',
  ];
  static const List<String> slidesSubtitles = [
    'Challenge your creativity',
    'You control what to learn',
    'DAVAR won\'t make you waste time'
  ];
  static const List<List<String>> slidesContent = [
    [
      'Learn new language fast and easy.',
      'Collect and memorize new words and sentences.',
      'English - български - polski - Türkçe',
    ],
    [
      'Cheerful Quiz. Track your stats.',
      'Learn only what is necessary',
      'You can use offline.',
    ],
    ['Sign in or register first', 'For personal use only!', '** This is a learning project **'],
  ];

  static final List<Widget> onBoardingSlides = [
    Slide(
        key: Key(slidesTitles[0]),
        title: slidesTitles[0],
        subtitle: slidesSubtitles[0],
        content: slidesContent[0],
        color: Colors.green[200],
        imgPath: AssetsPath.onBoard1),
    Slide(
        key: Key(slidesTitles[1]),
        title: slidesTitles[1],
        subtitle: slidesSubtitles[1],
        content: slidesContent[1],
        color: Colors.brown[50],
        imgPath: AssetsPath.onBoard2),
    Slide(
        key: Key(slidesTitles[2]),
        title: slidesTitles[2],
        subtitle: slidesSubtitles[2],
        content: slidesContent[2],
        color: Colors.white,
        imgPath: AssetsPath.onBoard3),
  ];

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  int currentPageIndex = 0;
  bool _isSlideIndicatorVisible = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChangeHandler(int index) {
    setState(() {
      currentPageIndex = index;
      _isSlideIndicatorVisible = index < 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) => onPageChangeHandler(index),
          itemCount: Onboarding.onBoardingSlides.length,
          itemBuilder: (BuildContext context, int index) {
            return Onboarding.onBoardingSlides[index];
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            if (_isSlideIndicatorVisible)
              TextButton(
                  onPressed: () =>
                      _pageController.jumpToPage(Onboarding.onBoardingSlides.length - 1),
                  child: const Text('Skip')),
            if (_isSlideIndicatorVisible)
              SlidesIndicator(
                slidesNumber: Onboarding.onBoardingSlides.length,
                currentPage: currentPageIndex.toDouble(),
              ),
            if (_isSlideIndicatorVisible)
              TextButton(
                  onPressed: () => _pageController.nextPage(
                      duration: const Duration(microseconds: 700), curve: Curves.easeInOut),
                  child: const Text('Next')),
            if (currentPageIndex >= 2)
              Expanded(
                  child: OnboardingBottomBar(
                leftBtnText: 'Register',
                rightBtnText: 'Login',
                leftBtnOnPressed: () => context.read<AuthProvider>().onRegisterRequest(),
                rightBtnOnPressed: () => context.read<AuthProvider>().onLoginRequest(),
              )),
          ]),
        ),
      ]),
    );
  }
}
