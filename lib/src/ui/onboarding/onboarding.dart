import 'package:davar/src/authentication/auth_provider.dart';
import 'package:davar/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    'WORD, ДУМА, KELIME',
    'You decide what you need to learn',
    'Let\'s start'
  ];
  static const List<List<String>> slidesContent = [
    [
      'Learn new language fast and easy.',
      'Collect and memorize new words and sentences.',
      'English - български - романи - Türkçe',
    ],
    [
      'Cheerful Quiz in School section.',
      'Track your stats',
      'You can use offline.',
    ],
    ['At first sign in or register', 'For personal use only!', '** This is a learning project **'],
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
  double _currentIndex = 0.0;
  bool _isLastSlide = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page != _currentIndex) {
        setState(() {
          _currentIndex = _pageController.page ?? 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(() {});
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _isLastSlide = index == 2),
            itemCount: Onboarding.onBoardingSlides.length,
            itemBuilder: (BuildContext context, int index) {
              return Onboarding.onBoardingSlides[index];
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (!_isLastSlide)
                  TextButton(
                      onPressed: () =>
                          _pageController.jumpToPage(Onboarding.onBoardingSlides.length - 1),
                      child: const Text('Skip')),
                if (!_isLastSlide)
                  SlidesIndicator(
                    slidesNumber: Onboarding.onBoardingSlides.length,
                    currentPage: _currentIndex,
                  ),
                !_isLastSlide
                    ? TextButton(
                        onPressed: () => _pageController.nextPage(
                            duration: const Duration(microseconds: 700), curve: Curves.easeInOut),
                        child: const Text('Next'),
                      )
                    : Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                          child: Container(
                            color: Colors.green.shade400,
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(Colors.green.shade400)),
                                  onPressed: () => context.read<AuthProvider>().register(),
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19.0,
                                        height: 2),
                                  ),
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(Colors.green.shade400)),
                                  onPressed: () {},
                                  child: const Text(
                                    'Sign in',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19.0,
                                        height: 2),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
