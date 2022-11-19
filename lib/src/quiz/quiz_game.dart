import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/quiz/widgets/quiz_widgets.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'quiz_provider.dart';

class QuizGame extends StatelessWidget {
  const QuizGame({Key? key, required WordsProvider wp})
      : _wp = wp,
        super(key: key);

  final WordsProvider _wp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Words Quiz'),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider<QuizProvider>(
          create: (context) => QuizProvider(_wp),
          builder: (context, _) {
            return Consumer<QuizProvider>(
                builder: (BuildContext context, QuizProvider provider, _) {
              switch (provider.status) {
                case QuizProviderStatus.loading:
                  return const LinearLoadingWidget(info: 'Loading wait...');
                case QuizProviderStatus.success:
                  if (provider.state.notPlayedIds.length < 3 && provider.state.isLocked) {
                    utils.showSnackBarInfo(context, msg: 'There is no more word to play');
                  }
                  return _buildScreenBody(context, provider);
                case QuizProviderStatus.error:
                  String e = provider.errorMsg;
                  return LinearLoadingWidget(isError: true, info: e.isNotEmpty ? e : 'Error');
                default:
                  return const Center(child: CircularProgressIndicator.adaptive());
              }
            });
          }),
    );
  }

  Widget _buildScreenBody(BuildContext context, QuizProvider provider) {
    return Container(
      alignment: Alignment.center,
      child: _layoutBuilderWrapper(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8.0),
            HeaderWidget(
                didUserGuess: provider.state.didUserGuess,
                isLocked: provider.state.isLocked,
                total: provider.state.gamePoints,
                score: provider.state.roundPoints),
            const SizedBox(height: 2.0),
            Flexible(
                flex: 11,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          const Text('Select the correct answer',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                          const SizedBox(height: 10),
                          QuestionWidget(question: provider.state.question.text()),
                          ...provider.state.options
                              .map((option) => OptionWidget(
                                  key: Key(option.text),
                                  onTapedOption: (option) => provider.onSelect(option),
                                  option: option))
                              .toList(),
                          const Divider(thickness: 1, color: Colors.grey),
                          Consumer<QuizProvider>(
                              builder: (BuildContext context, QuizProvider qp, _) {
                            return QuestionClueWidget(
                                onChanged: () => qp.onClueDemand(),
                                isExpended: qp.state.isClueOpen,
                                clue: qp.state.question.clue());
                          })
                        ],
                      ),
                    ),
                  ),
                ])),
            Flexible(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuitBtn(context),
                    _buildNextBtn(),
                  ],
                )),
            Center(
              child: (provider.state.notPlayedIds.length < 3 && provider.state.isLocked)
                  ? const Text('No more words to play.',
                      style: TextStyle(fontWeight: FontWeight.bold))
                  : null,
            )
          ],
        ),
      )),
    );
  }

  LayoutBuilder _layoutBuilderWrapper(Widget child) {
    return LayoutBuilder(builder: (context, constraint) {
      final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
      final double maxWidth = constraint.maxWidth;
      final double landscapeMaxW = (maxWidth * 3) / 4;
      return SizedBox(width: isPortrait ? maxWidth - 30 : landscapeMaxW, child: child);
    });
  }

  Widget _buildQuitBtn(BuildContext context) {
    return NeonButton(
        gradientColor1: Colors.grey,
        gradientColor2: Colors.blue,
        onPressed: () => Navigator.of(context).pop(),
        isGlowing: false,
        child: const Text('Quit',
            style: TextStyle(fontWeight: FontWeight.w600), textAlign: TextAlign.center));
  }

  Widget _buildNextBtn() {
    return Consumer<QuizProvider>(builder: (BuildContext context, QuizProvider qp, _) {
      final bool canGoNext =
          (qp.state.notPlayedIds.length >= 3 && (qp.state.isLocked || qp.state.didUserGuess));
      return NeonButton(
          gradientColor1: Colors.pink,
          gradientColor2: Colors.blueAccent,
          isGlowing: canGoNext,
          onPressed: canGoNext ? () => qp.onNext() : () {},
          child: Text('Next',
              style: TextStyle(
                  color: canGoNext ? Colors.white : Colors.grey, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center));
    });
  }
}
