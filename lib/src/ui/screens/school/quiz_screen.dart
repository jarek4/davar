import 'package:davar/src/davar_ads/davar_ads.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/quiz/quiz.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<WordsProvider, WordsProviderStatus>(
        selector: (_, state) => state.status,
        shouldRebuild: (WordsProviderStatus pre, WordsProviderStatus next) {
          return pre != next;
        },
        builder: (BuildContext context,  status, _) {
      switch (status) {
        case WordsProviderStatus.loading:
          final String wait = '${AppLocalizations.of(context)?.error ?? 'Loading wait'}...';
          return LinearLoadingWidget(info: wait);
        case WordsProviderStatus.success:
          return _buildScreenBody(context, context.read<WordsProvider>());
        case WordsProviderStatus.error:
          final String er = AppLocalizations.of(context)?.error ?? 'Error';
          String e = context.read<WordsProvider>().wordsErrorMsg;
          return LinearLoadingWidget(isError: true, info: e.isNotEmpty ? '$er: $e' : er);
        default:
          return const Center(child: CircularProgressIndicator.adaptive());
      }
    });
  }
  Widget _buildScreenBody(BuildContext context, WordsProvider provider) {
    return FutureBuilder(
        future: provider.wordsIds,
        builder: (context, snapshot) {
          final bool snapHasError = snapshot.hasError;
          ConnectionState connection = snapshot.connectionState;
          if (connection == ConnectionState.done && !snapHasError) {
            return _buildContent(context, provider, snapshot);
          }
          if (snapHasError) {
            final String er = AppLocalizations.of(context)?.error ?? 'Error occurs';
            return LinearLoadingWidget(isError: true, info: er);
          }
          return const Center(child: CircularProgressIndicator.adaptive());
        });
  }

  Widget _buildContent(BuildContext context, WordsProvider provider, AsyncSnapshot sp) {
    final String how = AppLocalizations.of(context)?.quizHow.toUpperCase() ?? 'HOW TO PLAY';
    final String man1 = AppLocalizations.of(context)?.quizManual1 ?? _quizManual1;
    final String man2 = AppLocalizations.of(context)?.quizManual2 ?? _quizManual2;
    // need at least 3 words to quiz!
    final bool isMoreThen3words = (sp.data != null && sp.data!.length >= 3);
    return _layoutBuilderWrapper(SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: 4.0),
        const DavarAdBanner(key: Key('School-QuizScreen-bottom-top-320')),
        const SizedBox(height: 15.0),
        Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
            child: Text(
              how,
              style: Theme.of(context).textTheme.headlineSmall,
            )),
        const SizedBox(height: 8.0),
        Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
            child: Text(
              man1,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            )),
        const SizedBox(height: 8.0),
        Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
            child: Text(
              man2,
              textAlign: TextAlign.center,
            )),
        const Divider(thickness: 1.3),
        const SizedBox(height: 15.0),
        isMoreThen3words
            ? _buildStartBtn(context, provider)
            : _showLessThen3wordsNotification(context, sp.data.length),
      ]),
    ));
  }

  Widget _buildStartBtn(BuildContext context, WordsProvider provider) {
    return NeonButton(
        gradientColor1: Colors.pink,
        gradientColor2: Colors.blueAccent,
        onPressed: () => Navigator.of(context)
            .push((MaterialPageRoute(builder: (context) => QuizGame(wp: provider)))),
        child: Row(
          children: const [
            Expanded(child: Icon(Icons.play_arrow_outlined, color: Colors.white)),
            Expanded(
                flex: 3,
                child: Text('PLAY',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center))
          ],
        ));
  }

  LayoutBuilder _layoutBuilderWrapper(Widget child) {
    return LayoutBuilder(builder: (context, constraint) {
      final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
      final double maxWidth = constraint.maxWidth;
      final double landscapeMaxW = (maxWidth * 3) / 4;
      return SizedBox(width: isPortrait ? maxWidth - 30 : landscapeMaxW, child: child);
    });
  }

  Widget _showLessThen3wordsNotification(BuildContext context, int addedWords) {
    final String untilNow =
        '${AppLocalizations.of(context)?.quizAdded ?? 'Until now you have been added'}:\n';
    final String w = AppLocalizations.of(context)?.words ?? 'words';
    final String s = AppLocalizations.of(context)?.quizAddAtLeast ?? 'Add at least:';
    final String add = AppLocalizations.of(context)?.quizManual1 ?? _quizManual1;
    final int haveToAdd = 3 - addedWords;
    return Center(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
      child: Text(
        '$untilNow $addedWords $w ($s).\n$add $haveToAdd.',
        softWrap: true,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ));
  }

  static const String _quizManual1 = 'Your task is to choose the correct answer.\n'
      'You can win up to 3 points if your first choice is correct. '
      'If you guess the second time you get 2 points. ';
  static const String _quizManual2 = 'If you have added a clue to the word, '
      'you will be able to use it. But it will takes 1 point.\n'
      'The number of the points of a particular word will be increased accordingly.';
}
