import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
    required this.didUserGuess,
    required this.isLocked,
    required this.title,
    required this.total,
    required this.score,
  }) : super(key: key);

  final bool didUserGuess;
  final bool isLocked;
  final String title;
  final int total;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total: $total',
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.normal, color: Colors.blue)),
            buildScoreNotification(didUserGuess, isLocked)
          ],
        ),
        const Divider(thickness: 1, color: Colors.grey),
      ],
    );
  }

  Text buildScoreNotification(bool isGuess, bool isLocked) {
    if (isLocked && !isGuess) {
      return const Text(
        'Not this time 🥴',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.deepOrange),
      );
    }
    final String txt = isGuess ? '🎉 You win $score points!' : 'You can score: $score';
    return Text(
      txt,
      style: TextStyle(
          fontSize: 12,
          fontWeight: isGuess ? FontWeight.bold : FontWeight.normal,
          color: Colors.green),
    );
  }
}
