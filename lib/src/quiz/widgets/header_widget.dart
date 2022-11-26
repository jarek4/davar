import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
    required this.didUserGuess,
    required this.isLocked,
    required this.total,
    required this.score,
  }) : super(key: key);

  final bool didUserGuess;
  final bool isLocked;
  final int total;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // QuizGame appBar contains title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total: $total',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.blue.shade800, fontWeight: FontWeight.w600)),
            buildScoreNotification(context, didUserGuess, isLocked)
          ],
        ),
        const Divider(thickness: 1, color: Colors.grey),
      ],
    );
  }

  Text buildScoreNotification(BuildContext context, bool isGuess, bool isLocked) {
    if (isLocked && !isGuess) {
      return const Text(
        'Not this time 🥴',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
      );
    }
    final String txt = isGuess ? '🎉 You win $score points!' : 'You can score: $score';
    return Text(txt,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.green.shade700,
              fontWeight: isGuess ? FontWeight.w700 : FontWeight.w500,
            ));
  }
}
