import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/theme/theme.dart' as theme;
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({Key? key}) : super(key: key);
  static const routeName = '/add';

  @override
  Widget build(BuildContext context) {
    // new Scaffold is here! Without ChangeNotifierProvider<CategoriesProvider>.value
    // cannot find CategoriesProvider
    final CategoriesProvider cp = context.read<CategoriesProvider>();
    return ChangeNotifierProvider<CategoriesProvider>.value(
        value: cp,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: _buildAppBar(context),
          body: LayoutBuilder(builder: (context, constraints) {
            final bool isWidthMore600 = constraints.maxWidth > 600;
            final bool isHeightLess350 = constraints.maxHeight < 350;
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  Flexible(child: _buildHeaderWithLogo(isWidthMore600, isHeightLess350)),
                  const SizedBox(height: 20),
                  Expanded(child: _buildMainContent(isWidthMore600, context)),
                ],
              ),
            );
          }),
        ));
  }

  Widget _buildMainContent(bool isWidthMore600, BuildContext context) {
    return Wrap(
        direction: isWidthMore600 ? Axis.horizontal : Axis.vertical,
        spacing: 26.0,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        children: [
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
              isSentence: true),
          // errors:
          Consumer<WordsProvider>(builder: (BuildContext context, WordsProvider provider, _) {
            final bool hasErrorMsg = provider.wordsErrorMsg.isNotEmpty;
            if (hasErrorMsg) {
              utils.showSnackBarInfo(context, msg: provider.wordsErrorMsg);
            }
            switch (provider.status) {
              case WordsProviderStatus.error:
                return Text(provider.wordsErrorMsg);
              case WordsProviderStatus.loading:
                return const Text('Wait...');
              default:
                return const SizedBox.shrink();
            }
          })
        ]);
  }

  Widget _buildHeaderWithLogo(bool isWidthMore600, bool isHeightLess350) {
    return FractionallySizedBox(
      heightFactor: 0.7,
      widthFactor: 1,
      child: Container(
        decoration: BoxDecoration(
            // boxShadow: kElevationToShadow[12],
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.9),
                  spreadRadius: 4,
                  blurRadius: 32,
                  offset: const Offset(0, 0)),
              BoxShadow(
                  color: const Color(0xFF0D47A1).withOpacity(0.6),
                  spreadRadius: 4,
                  blurRadius: 32,
                  offset: const Offset(60, 0)),
              BoxShadow(
                  color: const Color(0xFF2E7D32).withOpacity(0.3),
                  spreadRadius: 4,
                  blurRadius: 32,
                  offset: const Offset(170, 0)),
              BoxShadow(
                  color: const Color(0XFF880E47).withOpacity(0.6),
                  spreadRadius: 4,
                  blurRadius: 32,
                  offset: Offset(isWidthMore600 ? 480 : 260, 0)),
              BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  spreadRadius: 4,
                  blurRadius: 18,
                  offset: Offset(isWidthMore600 ? 750 : 370, 0)),
            ]),
        child: Stack(alignment: AlignmentDirectional.center, fit: StackFit.passthrough, children: [
          Image.asset(utils.AssetsPath.davarLogoBackground, fit: BoxFit.fill),
          Positioned(
            //alignment: Alignment.topRight,
            right: isHeightLess350 ? 12 : null,
            top: isHeightLess350 ? 4 : null,
            child: Image.asset(utils.AssetsPath.davarLogo,
                fit: BoxFit.scaleDown, width: 70, height: 70),
          ),
        ]),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) => AppBar(
        title: Text('DAWAR',
            style: Theme.of(context).textTheme.headline6?.copyWith(color: const Color(0XFF00695C))),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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

  Widget _buildButton(String text, VoidCallback handle, {bool isSentence = false}) {
    return Container(
      constraints: const BoxConstraints(minWidth: 145, maxWidth: 150.0, minHeight: 70.0),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
                color: isSentence
                    ? theme.DavarColors.sentenceColors2[0].withOpacity(0.5)
                    : theme.DavarColors.wordColors2[0].withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(-4, -2)),
            BoxShadow(
                color: isSentence
                    ? theme.DavarColors.sentenceColors2[1].withOpacity(0.5)
                    : theme.DavarColors.wordColors2[1].withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(3, 2)),
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.grey[400],
          constraints: const BoxConstraints(minWidth: 145, maxWidth: 150.0, minHeight: 70.0),
          child: MaterialButton(
              onPressed: handle, child: Text(text, style: const TextStyle(fontSize: 26))),
        ),
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
