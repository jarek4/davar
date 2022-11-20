import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/quiz/quiz.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final WordsProvider wp = Provider.of<WordsProvider>(context);
    return Consumer<WordsProvider>(builder: (BuildContext context, WordsProvider provider, _) {
      switch (provider.status) {
        case WordsProviderStatus.loading:
          return const LinearLoadingWidget(info: 'Loading wait... WordsProvider');
        case WordsProviderStatus.success:
          return _buildScreenBody(context, provider);
        case WordsProviderStatus.error:
          String e = provider.wordsErrorMsg;
          return LinearLoadingWidget(isError: true, info: e.isNotEmpty ? e : 'Error');
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
            return const LinearLoadingWidget(isError: true, info: 'Error occurs');
          }
          return const Center(child: CircularProgressIndicator.adaptive());
        });
  }

  Widget _buildContent(BuildContext context, WordsProvider provider, AsyncSnapshot sp) {
    // need at least 3 words to quiz!
    final bool isMoreThen3words = (sp.data != null && sp.data!.length >= 3);
    return _layoutBuilderWrapper(SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 8.0),
          Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
              child: Text(
                'HOW TO PLAY',
                style: Theme.of(context).textTheme.headlineSmall,
              )),
          const SizedBox(height: 8.0),
          Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
              child: Text(
                _quizManual1,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              )),
          const SizedBox(height: 8.0),
          const Padding(
              padding: EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
              child: Text(
                _quizManual2,
                textAlign: TextAlign.center,
              )),
          const Divider(thickness: 1.3),
          const SizedBox(height: 15.0),
          isMoreThen3words
              ? _buildStartBtn(context, provider)
              : _showLessThen3wordsNotification(context, sp.data.length),
          const SizedBox(height: 15.0),
        ],
      ),
    ));
  }

  Widget _buildStartBtn(BuildContext context, WordsProvider provider) {
    /*return MaterialButton(
        // style: Theme.of(context).buttonTheme.,
        onPressed: () => Navigator.of(context)
            .push((MaterialPageRoute(builder: (context) => QuizGame(wp: provider)))),
        child: const Text('Start'));*/
    // return const NeonButton();
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
    const String untilNow = 'Until now you have been added:\n';
    final int haveToAdd = 3 - addedWords;
    return Center(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
      child: Text(
        '$untilNow $addedWords words or sentences.\nAdd at least $haveToAdd more to play.',
        softWrap: true,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ));
  }

  static const String _quizManual1 = 'Your task is to choose the correct answer.\n'
      'You can win up to 5 points if your first choice is correct. '
      'If you guess the second time you get 3 points. ';
  static const String _quizManual2 = 'If you have added a clue to the word, '
      'you will be able to use it. But it will takes 2 points.\n'
      'The number of the points of a particular word will be increased accordingly.';
}
