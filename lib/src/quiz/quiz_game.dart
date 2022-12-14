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
      appBar: _buildAppBar(),
      body:  _layoutBuilderWrapper(
         ChangeNotifierProvider<QuizProvider>(
            create: (context) => QuizProvider(_wp),
            builder: (context, _) {
              return Consumer<QuizProvider>(
                  builder: (BuildContext context, QuizProvider provider, _) {
                switch (provider.status) {
                  case QuizProviderStatus.loading:
                    return const LinearLoadingWidget(info: 'Loading wait...');
                  case QuizProviderStatus.success:
                    if (provider.state.notPlayedIds.isEmpty && provider.state.isLocked) {
                      utils.showSnackBarInfo(context, msg: 'There is no more word to play');
                    }
                    return _buildScreenBody(context, provider);
                  case QuizProviderStatus.error:
                    String e = provider.errorMsg;
                    return LinearLoadingWidget(
                        isError: true,
                        info: e.isNotEmpty ? e : 'Error',
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back_rounded)),
                    );
                  default:
                    return const Center(child: CircularProgressIndicator.adaptive());
                }
              });
            }),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Text('Words Quiz'),
      centerTitle: true,
    );
  }

  Widget _buildScreenBody(BuildContext context, QuizProvider provider) {
    final isStatusLoading = provider.status == QuizProviderStatus.loading;
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8.0),
            _buildHeader(provider),
            const SizedBox(height: 2.0),
            _buildQuestionAndOptions(provider),
            _buildControlButtons(context, isStatusLoading),
            Center(
              child: (provider.state.notPlayedIds.isEmpty && provider.state.isLocked)
                  ? const Text('No more words to play.',
                      style: TextStyle(fontWeight: FontWeight.bold))
                  : null,
            )
          ],
        ),
      ),
    );
  }

  HeaderWidget _buildHeader(QuizProvider provider) {
    return HeaderWidget(
        didUserGuess: provider.state.didUserGuess,
        isLocked: provider.state.isLocked,
        total: provider.state.gamePoints,
        score: provider.state.roundPoints);
  }

  Flexible _buildQuestionAndOptions(QuizProvider provider) {
    return Flexible(
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
                          key: Key(
                              'OptionW-${option.wordId}-${option.isCorrect}_question:${provider.state.question.text()}'),
                          onTapedOption: (option) => provider.onSelect(option),
                          option: option))
                      .toList(),
                  // OptionWidget key must be unique for every OptionWidget!
                  // to prevent new question's option to be locked at start!
                  const Divider(thickness: 1, color: Colors.grey),
                  Consumer<QuizProvider>(builder: (BuildContext context, QuizProvider qp, _) {
                    return QuestionClueWidget(
                        onChanged: () => qp.onClueDemand(),
                        isExpended: qp.state.isClueOpen,
                        clue: qp.state.question.clue());
                  })
                ],
              ),
            ),
          ),
        ]));
  }

  Flexible _buildControlButtons(BuildContext context, bool isStatusLoading) {
    return Flexible(
        flex: 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuitBtn(context),
            isStatusLoading ? const CircularProgressIndicator.adaptive() : _buildNextBtn(),
          ],
        ));
  }

  LayoutBuilder _layoutBuilderWrapper(Widget child) {
    return LayoutBuilder(builder: (context, constraint) {
      // final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
      print('QUIZ ,mAX WIDTH: ${constraint.maxWidth}');
      // constraint.maxWidth: tablet Pixel C: v-900, h:1280.
      final double maxWidth = constraint.maxWidth;
      final bool isWidth = constraint.maxWidth > 700.0;
      print('QUIZ ,isWidth: $isWidth');
      final double landscapeMaxW = ((maxWidth * 3) / 4 - 20);
      return Center(child: SizedBox(width: isWidth ? landscapeMaxW : maxWidth - 30, child: child));
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
          (qp.state.notPlayedIds.isNotEmpty && (qp.state.isLocked || qp.state.didUserGuess));
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
