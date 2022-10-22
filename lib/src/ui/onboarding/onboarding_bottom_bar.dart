import 'package:flutter/material.dart';

class OnboardingBottomBar extends StatelessWidget {
  const OnboardingBottomBar({
    Key? key,
    required this.leftBtnText,
    required this.rightBtnText,
    required this.leftBtnOnPressed,
    required this.rightBtnOnPressed,
  }) : super(key: key);

  final String leftBtnText;
  final String rightBtnText;
  final VoidCallback leftBtnOnPressed;
  final VoidCallback rightBtnOnPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          const BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      child: Container(
        color: Colors.green.shade400,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade400)),
              onPressed: leftBtnOnPressed,
              child: Text(
                leftBtnText,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.0, height: 2),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade400)),
              onPressed: rightBtnOnPressed,
              child: Text(
                rightBtnText,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.0, height: 2),
              ),
            )
          ],
        ),
      ),
    );
  }
}
