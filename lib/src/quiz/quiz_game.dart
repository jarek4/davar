import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/quiz/widgets/quiz_widgets.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'quiz_provider.dart';

class QuizGame extends StatelessWidget {
  const QuizGame({Key? key, required WordsProvider wp})
      : _wp = wp,
        super(key: key);

  final WordsProvider _wp;

  @override
  Widget build(BuildContext context) {
    final String title = AppLocalizations.of(context)?.wordsQuiz ?? 'Words Quiz';
    return Scaffold(
      appBar: _buildAppBar(title),
      body: ChangeNotifierProvider<QuizProvider>(
          create: (context) => QuizProvider(_wp),
          builder: (context, _) {
            return Consumer<QuizProvider>(
                builder: (BuildContext context, QuizProvider provider, _) {
              switch (provider.status) {
                case QuizProviderStatus.loading:
                  final String loading = AppLocalizations.of(context)?.loading ?? 'Loading wait...';
                  return LinearLoadingWidget(info: loading);
                case QuizProviderStatus.success:
                  if (provider.state.notPlayedIds.isEmpty && provider.state.isLocked) {
                    final String noWords =
                        AppLocalizations.of(context)?.noMoreToPlay ?? 'No more words to play.';
                    utils.showSnackBarInfo(context, msg: noWords);
                  }
                  return _buildScreenBody(context, provider);
                case QuizProviderStatus.error:
                  String e = provider.errorMsg;
                  final String er = AppLocalizations.of(context)?.error ?? 'Error';
                  return LinearLoadingWidget(
                    isError: true,
                    info: e.isNotEmpty ? '$er: $e' : 'Error',
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
    );
  }

  AppBar _buildAppBar(String title) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(title),
      centerTitle: true,
    );
  }

  Widget _buildScreenBody(BuildContext context, QuizProvider provider) {
    final String noWords = AppLocalizations.of(context)?.noMoreToPlay ?? 'No more words to play.';
    final isStatusLoading = provider.status == QuizProviderStatus.loading;
    final bool noMoreWords = provider.state.notPlayedIds.isEmpty && provider.state.isLocked;
    return Center(
      child: LayoutBuilder(builder: (context, constraint) {
        // constraint.maxWidth(vert/hor): tablet Pixel C:900/1280. Pixel4:393/829 iPhone8:375/667
        // constraint.maxHeight(vert/hor): Pixel4:725/288.7 iPhone8:591/319
        final double maxWidth = constraint.maxWidth;
        final bool isWidth = constraint.maxWidth > 700.0;
        final double landscapeMaxW = ((maxWidth * 3) / 4 - 20);
        final double maxH = constraint.maxHeight;
        final bool isNotH = maxH < 640;
        return SizedBox(
          width: isWidth ? landscapeMaxW : maxWidth - 30,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              const SizedBox(height: 8.0),
              _buildHeader(provider),
              SizedBox(height: isNotH ? 2.0 : 16.0),
              Flexible(flex: isNotH ? 12 : 11, child: _buildQuestionAndOptions(context, provider)),
              Flexible(flex: isNotH ? 3 : 4, child: _buildControlButtons(context, isStatusLoading)),
              Center(
                  child: noMoreWords
                      ? Text(noWords, style: const TextStyle(fontWeight: FontWeight.bold))
                      : null)
            ]),
          ),
        );
      }),
    );
  }

  HeaderWidget _buildHeader(QuizProvider provider) {
    return HeaderWidget(
        didUserGuess: provider.state.didUserGuess,
        isLocked: provider.state.isLocked,
        total: provider.state.gamePoints,
        score: provider.state.roundPoints);
  }

  Widget _buildQuestionAndOptions(BuildContext context, QuizProvider provider) {
    final String select =
        AppLocalizations.of(context)?.selectCorrect ?? 'Select the correct answer';
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 5),
            Text(select, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
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
          ]),
        ),
      ),
    ]);
  }

  Widget _buildControlButtons(BuildContext context, bool isStatusLoading) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      _buildQuitBtn(context),
      isStatusLoading ? const CircularProgressIndicator.adaptive() : _buildNextBtn(),
    ]);
  }

  Widget _buildQuitBtn(BuildContext context) {
    final String quit = utils.capitalize(AppLocalizations.of(context)?.quit ?? 'Quit');
    return NeonButton(
        gradientColor1: Colors.grey,
        gradientColor2: Colors.blue,
        onPressed: () => Navigator.of(context).pop(),
        isGlowing: false,
        child: Text(quit,
            style: const TextStyle(fontWeight: FontWeight.w600), textAlign: TextAlign.center));
  }

  Widget _buildNextBtn() {
    return Consumer<QuizProvider>(builder: (BuildContext context, QuizProvider qp, _) {
      final String next = utils.capitalize(AppLocalizations.of(context)?.next ?? 'Next');
      final bool canGoNext =
          (qp.state.notPlayedIds.isNotEmpty && (qp.state.isLocked || qp.state.didUserGuess));
      return NeonButton(
          gradientColor1: Colors.pink,
          gradientColor2: Colors.blueAccent,
          isGlowing: canGoNext,
          onPressed: canGoNext ? () => qp.onNext() : () {},
          child: Text(next,
              style: TextStyle(
                  color: canGoNext ? Colors.white : Colors.grey, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center));
    });
  }
}
