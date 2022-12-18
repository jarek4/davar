import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/davar_ads/davar_ads.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/theme/theme.dart' as theme;
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({Key? key}) : super(key: key);
  static const routeName = '/add';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: LayoutBuilder(builder: (context, constraints) {
        // iPhone8: portrait-> maxH= ; maxW= , horizontal-> maxH= ; maxW= ;
        // Pixel4xl: portrait-> maxH= 764.5; maxW= 411.4, horizontal-> maxH= 355.4; maxW= 771.7;
        final bool isWidthMore600 = constraints.maxWidth > 600;
        final bool isHeightLess360 = constraints.maxHeight < 360;
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(child: _buildHeaderWithLogo(isWidthMore600, isHeightLess360)),
            const SizedBox(height: 20),
            _handleLoadingState(),
            Expanded(child: _buildMainContent(isWidthMore600, constraints.maxHeight, context)),
            _handleErrors(),
            const DavarAdBanner(key: Key('AddScreen-bottom-banner-320'))
          ]),
        );
      }),
    );
  }

  AppBar _buildAppBar(BuildContext context) => AppBar(
      title: Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: Text('DAVAR',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.white.withOpacity(0.33)))),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0);

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
            right: isHeightLess350 ? 12 : null,
            top: isHeightLess350 ? 3 : null,
            child: Image.asset(utils.AssetsPath.davarLogo,
                fit: BoxFit.scaleDown, width: isHeightLess350 ? 60: 68, height: isHeightLess350 ? 60 : 68),
          ),
        ]),
      ),
    );
  }

  Widget _buildMainContent(bool isWidthMore600, double maxH, BuildContext context) {
    // iphone8 maxHeight=611.0; pixel4xl=764.5;
    final bool isHeight = maxH > 620.0;
    return Padding(
      padding: EdgeInsets.only(top: isHeight ? 50.0 : 16.0),
      child: Wrap(
          direction: isWidthMore600 ? Axis.horizontal : Axis.vertical,
          spacing: 70,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          children: [
            _buildAddNewWord(context),
            _buildAddNewSentence(context),
          ]),
    );
  }

  Widget _buildAddNewWord(BuildContext context) {
    return _buildAddNewButton(
      context,
      () => _addNewItem(
        context: context,
        categories: context.read<CategoriesProvider>().categories,
        onSubmit: (Word w) => context.read<WordsProvider>().create(w),
      ),
    );
  }

  Widget _buildAddNewSentence(BuildContext context) {
    return _buildAddNewButton(
        context,
        () => _addNewItem(
            context: context,
            isSentence: true,
            categories: context.read<CategoriesProvider>().categories,
            onSubmit: (Word w) => context.read<WordsProvider>().create(w)),
        isSentence: true);
  }

  void _addNewItem({
    required BuildContext context,
    bool isSentence = false,
    required List<WordCategory> categories,
    required Function onSubmit,
  }) {
    final String newS = AppLocalizations.of(context)?.newSentence ?? 'New sentence';
    final String newW = AppLocalizations.of(context)?.newWord ?? 'New word';
    _showAddWordDialog(
        context,
        AddNewWordModal(isSentence: isSentence, categories: categories, handleSubmit: onSubmit),
        isSentence ? newS : newW);
  }

  Widget _buildAddNewButton(BuildContext context, VoidCallback handle, {bool isSentence = false}) {
    final String word = utils.capitalize(AppLocalizations.of(context)?.word ?? 'Word');
    final String sentence = utils.capitalize(AppLocalizations.of(context)?.sentence ?? 'Sentence');
    final WordsProviderStatus status = context
        .select<WordsProvider, WordsProviderStatus>((WordsProvider provider) => provider.status);
    final bool isLoading = status == WordsProviderStatus.loading;
    return Container(
      constraints: const BoxConstraints(minWidth: 172, maxWidth: 188.0, minHeight: 66.0),
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
            onPressed: isLoading ? null : handle,
            child: Text(isSentence ? sentence : word,
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 20.0)),
          ),
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

  Widget _handleErrors() {
    return Selector<WordsProvider, String>(
        selector: (_, state) => state.wordsErrorMsg,
        shouldRebuild: (String pre, String next) {
          return pre != next;
        },
        builder: (BuildContext context, err, __) {
          if (err.isNotEmpty) {
            return SmallUserDialog(err, context.read<WordsProvider>().confirmReadErrorMsg);
          }
          return const SizedBox.shrink();
        });
  }

  Widget _handleLoadingState() {
    return Selector<WordsProvider, WordsProviderStatus>(
        selector: (_, state) => state.status,
        shouldRebuild: (WordsProviderStatus pre, WordsProviderStatus next) {
          return pre != next;
        },
        builder: (BuildContext context, status, __) {
          final bool isLoading = status == WordsProviderStatus.loading;
          if (isLoading) {
            final String info = AppLocalizations.of(context)?.loading ?? 'Loading...';
            return LinearLoadingWidget(info: info);
          }
          return const SizedBox.shrink();
        });
  }
}
