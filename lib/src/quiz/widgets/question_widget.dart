import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
    Key? key,
    required this.question,
  }) : super(key: key);

  final String question;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70.0,
      margin: const EdgeInsets.only(bottom: 10, top: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        border: Border.all(width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          question,
          style: const TextStyle(
              color: Colors.green, fontSize: 16, letterSpacing: 1.2, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
