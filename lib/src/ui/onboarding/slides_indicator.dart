import 'package:flutter/material.dart';

class SlidesIndicator extends StatelessWidget {
  const SlidesIndicator(
      {Key? key, required this.slidesNumber, required this.currentPage})
      : super(key: key);
  final int slidesNumber;
  final double currentPage;

  List<Widget> _indicator() => List<Widget>.generate(
      slidesNumber,
      (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            height: 10.0,
            width: 10.0,
            decoration: BoxDecoration(
                color: currentPage.round() == index
                    ? const Color(0XFF256075)
                    : const Color(0XFF256075).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0)),
          ));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _indicator(),
      ),
    );
  }
}
