import 'package:davar/src/providers/words_provider.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({Key? key}) : super(key: key);
  static const routeName = '/add';

  @override
  Widget build(BuildContext context) {
    return Consumer<WordsProvider>(builder: (BuildContext context, WordsProvider provider, _) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const Text('ADD NEW:', style: TextStyle(fontSize: 20)),
            Text('status: ${context.read<WordsProvider>().status.toString()}'),
            _buildButton(
                'Word', () => _showAddWordDialog(context, const AddNewWordModal(), 'New Word')),
            _buildButton(
                'Sentence',
                () => _showAddWordDialog(
                    context, const AddNewWordModal(isSentence: true), 'New Sentence'))
          ]),
        ),
      );
    });
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

  Future<dynamic> _showAddWordDialog(BuildContext ctx, Widget alertContentWidget, String title) =>
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
                  content: alertContentWidget,
                ),
              ));
        },
      );
}
