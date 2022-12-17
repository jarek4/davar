import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final String t = AppLocalizations.of(context)?.total ?? 'Total';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // QuizGame appBar contains title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$t: $total',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.blue.shade800, fontWeight: FontWeight.w600)),
            buildScoreNotification(context, didUserGuess, isLocked)
          ],
        ),
        // const Divider(thickness: 1, color: Colors.grey),
      ],
    );
  }

  Text buildScoreNotification(BuildContext context, bool isGuess, bool isLocked) {
    final String notThisTime = AppLocalizations.of(context)?.notThisTime ?? 'Not this time';
    final String youWin = AppLocalizations.of(context)?.youWin ?? 'You win';
    final String canScore = AppLocalizations.of(context)?.canScore ?? 'You can score';
    final String  points = AppLocalizations.of(context)?.points ?? ' points';
    if (isLocked && !isGuess) {
      return Text(
        '$notThisTime 🥴',
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
      );
    }
    final String txt = isGuess ? '🎉 $youWin $score $points!' : '$canScore: $score';
    return Text(txt,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.green.shade700,
              fontWeight: isGuess ? FontWeight.w700 : FontWeight.w500,
            ));
  }
}
