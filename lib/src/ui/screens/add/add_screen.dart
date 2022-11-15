import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/providers/words_provider.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({Key? key}) : super(key: key);
  static const routeName = '/add';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ListView(
            // shrinkWrap: true,
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                const Text('ADD NEW:', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 30),
                _buildButton(
                  'Word',
                  () => _addNewSentence(
                      context: context,
                      categories: context.read<CategoriesProvider>().categories,
                      onSubmit: (Word w) => context.read<WordsProvider>().create(w)),
                ),
                const SizedBox(height: 50),
                _buildButton(
                  'Sentence',
                  () => _addNewSentence(
                      context: context,
                      isSentence: true,
                      categories: context.read<CategoriesProvider>().categories,
                      onSubmit: (Word w) => context.read<WordsProvider>().create(w)),
                ),
                // errors:
                Consumer<WordsProvider>(builder: (BuildContext context, WordsProvider provider, _) {
                  final bool hasErrorMsg = provider.wordsErrorMsg.isNotEmpty;
                  if (hasErrorMsg) utils.showSnackBarInfo(context, msg: provider.wordsErrorMsg);
                  switch (provider.status) {
                    case WordsProviderStatus.error:
                      return Text(provider.wordsErrorMsg);
                    case WordsProviderStatus.loading:
                      return const Text('Wait...');
                    default:
                      return const SizedBox();
                  }
                })
              ]),
            ]),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
        title: const Text('ADD'),
        centerTitle: true,
        flexibleSpace: SizedBox(
          height: 130,
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.orange, Colors.purple],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            )),
          ),
        ),
        toolbarHeight: 97.0,
        toolbarOpacity: 0.7,
        bottomOpacity: 0.8,
        elevation: 4,
      );

  void _addNewSentence({
    required BuildContext context,
    bool isSentence = false,
    required List<WordCategory> categories,
    required Function onSubmit,
  }) {
    _showAddWordDialog(
        context,
        AddNewWordModal(
          isSentence: isSentence,
          categories: categories,
          handleSubmit: onSubmit,
          handleErrorMessage: (String v) => context.read<WordsProvider>().errorMsg = v,
        ),
        'New Sentence');
  }

  Widget _buildButton(String text, VoidCallback handle) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        constraints: const BoxConstraints(minWidth: 145, maxWidth: 150.0, minHeight: 70.0),
        decoration: BoxDecoration(
            color: Colors.amberAccent.shade100,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            border: Border.all(
              width: 1.5,
              color: Colors.black.withOpacity(0.2),
            )),
        child: MaterialButton(
            onPressed: handle, child: Text(text, style: const TextStyle(fontSize: 26))),
      ),
    );
  }

  Future<dynamic> _showAddWordDialog(BuildContext ctx, Widget alertContent, String title) =>
      showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        barrierDismissible: true,
        barrierLabel: '',
        context: ctx,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        },
        transitionDuration: const Duration(milliseconds: 400),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
              transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
              child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  scrollable: true,
                  shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                  title: Text(title),
                  content: alertContent,
                ),
              ));
        },
      );
}
