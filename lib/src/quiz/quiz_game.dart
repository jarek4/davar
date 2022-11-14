import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/quiz/widgets/quiz_widgets.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'quiz_provider.dart';

class QuizGame extends StatelessWidget {
  const QuizGame({Key? key, required this.wp}) : super(key: key);

  final WordsProvider wp;

  @override
  Widget build(BuildContext context) {
    // final WordsProvider wp = Provider.of<WordsProvider>(context);
    return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
          ),
          body: ChangeNotifierProvider<QuizProvider>(
              create: (context) => QuizProvider(wp),
              builder: (context, _) {
              return Consumer<QuizProvider>(builder: (BuildContext context, QuizProvider provider, _) {
                switch (provider.status) {
                  case QuizProviderStatus.loading:
                    return const LinearLoadingWidget(
                      info: 'Loading wait...',
                    );
                  case QuizProviderStatus.success:
                    if (provider.state.notPlayedIds.length < 3 && provider.state.isLocked) {
                      utils.showSnackBarInfo(context, msg: 'There is no more word to play');
                    }
                    return _buildScreenBody(context, provider);
                  case QuizProviderStatus.error:
                    String e = provider.errorMsg;
                    return LinearLoadingWidget(
                      isError: true,
                      info: e.isNotEmpty ? e : 'Error',
                    );
                  default:
                    return const Center(child: CircularProgressIndicator.adaptive());
                }
              });
            }
          ),
        );
  }

  Widget _buildScreenBody(BuildContext context, QuizProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HeaderWidget(
              title: 'QUIZ',
              didUserGuess: provider.state.didUserGuess,
              isLocked: provider.state.isLocked,
              total: provider.state.gamePoints,
              score: provider.state.roundPoints),
          Flexible(
              fit: FlexFit.loose,
              flex: 3,
              child: PageView.builder(
                  itemCount: 2,
                  // controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    // final _question = 'questions[index]';
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                        option: option,
                                      ))
                                  .toList(),
                              const Divider(thickness: 1, color: Colors.grey),
                              QuestionClueWidget(
                                  // onChanged: (bool isExpending) =>
                                  //     context.read<QuizCubit>().onClueDemand(isExpending),
                                  onChanged: () => provider.onClueDemand(),
                                  isExpended: provider.state.isClueOpen,
                                  clue: provider.state.question.clue())
                            ],
                          ),
                        ),
                      ),
                    ]);
                  })),
          Flexible(
              fit: FlexFit.loose,
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildElevatedBtn(
                    text: 'Quit',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  _buildElevatedBtn(
                    text: 'Next',
                    onPressed: (provider.state.notPlayedIds.length >= 3 &&
                            (provider.state.isLocked || provider.state.didUserGuess))
                        ? () => provider.onNext()
                        : null,
                  ),
                ],
              )),
          Center(
            child: (provider.state.notPlayedIds.length < 3 && provider.state.isLocked)
                ? const Text(
                    'You have played all your words',
                    style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                  )
                : null,
          )
        ],
      ),
    );
  }

  Center _showLessThen3wordsNotification(int addedWords) {
    const String untilNow = 'Until now you have been added: ';
    const String toPlay = '\nThen you can play.';
    final int haveToAdd = 3 - addedWords;
    return Center(
        child: Text(
      '$untilNow $addedWords words or sentences.\n You have to add at least $haveToAdd more $toPlay',
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.bold, height: 2.0, color: Colors.red),
    ));
  }

  ElevatedButton _buildElevatedBtn({
    required String text,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton(
        key: Key(text),
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(onPressed == null ? Colors.blueGrey : Colors.blue),
          padding: MaterialStateProperty.all(const EdgeInsets.all(2)),
        ),
        child: Text(text));
  }
}
