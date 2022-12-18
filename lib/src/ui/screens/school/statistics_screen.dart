import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/statistics_services/statistics_service.dart';
import 'package:davar/src/theme/theme.dart' as theme;
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late Future<DavarStatistic>? _futureStatistics;

  @override
  void initState() {
    _futureStatistics =
        Provider.of<StatisticsProvider>(context, listen: false).loadPreviewsStatistics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StatisticsProvider>(builder: (BuildContext context, StatisticsProvider sp, _) {
      switch (sp.status) {
        case StatisticsProviderStatus.loading:
          final String loading = AppLocalizations.of(context)?.loading ?? 'Loading wait...';
          return LinearLoadingWidget(info: loading);
        case StatisticsProviderStatus.success:
          return _buildScreenBody(context, sp);
        case StatisticsProviderStatus.error:
          String e = sp.errorMsg;
          final String err = utils.capitalize(AppLocalizations.of(context)?.sentence ?? 'Error');
          return LinearLoadingWidget(isError: true, info: e.isNotEmpty ? '$err: $e' : err);
        default:
          return const Center(child: CircularProgressIndicator.adaptive());
      }
    });
  }

  Widget _buildScreenBody(BuildContext context, StatisticsProvider sp) {
    return FutureBuilder<DavarStatistic>(
        initialData: const DavarStatistic(),
        future: _futureStatistics,
        builder: (context, snapshot) {
          final bool snapHasError = snapshot.hasError;
          ConnectionState connection = snapshot.connectionState;
          if (connection == ConnectionState.done && !snapHasError) {
            return _buildContent(context, sp, snapshot);
          }
          if (snapHasError) {
            final String err = utils.capitalize(AppLocalizations.of(context)?.sentence ?? 'Error');
            return LinearLoadingWidget(isError: true, info: err);
          }
          return const Center(child: CircularProgressIndicator.adaptive());
        });
  }

  Widget _buildContent(BuildContext context, StatisticsProvider sp, AsyncSnapshot snap) {
    final String quizScore =
        AppLocalizations.of(context)?.statsQuizScore ?? 'The highest quiz score.';
    final String w = AppLocalizations.of(context)?.words.toUpperCase() ?? 'WORDS';
    final String s = AppLocalizations.of(context)?.sentences.toUpperCase() ?? 'SENTENCES';
    final String allW = utils.capitalize(AppLocalizations.of(context)?.statsWords ?? 'All words');
    final String allS =
        utils.capitalize(AppLocalizations.of(context)?.statsSentences ?? 'All sentences');
    final String p = utils.capitalize(AppLocalizations.of(context)?.points ?? 'Points');
    final String quiz = AppLocalizations.of(context)?.quizScore.toUpperCase() ?? 'QUIZ SCORE';
    final String best = AppLocalizations.of(context)?.best.toUpperCase() ?? 'BEST';
    final String weak = AppLocalizations.of(context)?.weakest.toUpperCase() ?? 'WEAKEST';
    DavarStatistic stats = snap.data;
    return _layoutBuilderWrapper([
      _buildUpdateCard(context, value: stats.date),
      _buildStatisticCard(context,
          color: const Color(0xFFED4140),
          title: quiz,
          subtitle: quizScore,
          value: '${stats.highestQuizScore}'),
      _buildStatisticCard(context,
          color: theme.DavarColors.wordColors2[0],
          title: w,
          subtitle: '$allW.',
          value: '${stats.wordsNumber}'),
      _buildStatisticCard(context,
          color: theme.DavarColors.sentenceColors2[0],
          title: s,
          subtitle: '$allS.',
          value: '${stats.sentencesNumber}'),
      _buildStatisticCard(context,
          color: Colors.teal[400] ?? Colors.teal,
          title: best,
          subtitle: '$p: ${stats.mostPointsWord[1]}',
          value: stats.mostPointsWord[0]),
      _buildStatisticCard(context,
          color: Colors.teal[600] ?? Colors.teal,
          title: weak,
          subtitle: '$p: ${stats.leastPointsWord[1]}',
          value: stats.leastPointsWord[0]),
    ]);
  }

  LayoutBuilder _layoutBuilderWrapper(List<Widget> children) {
    return LayoutBuilder(builder: (context, constraint) {
      final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
      return GridView.count(
        primary: false,
        padding: const EdgeInsets.all(15),
        crossAxisSpacing: isPortrait ? 10 : 30,
        mainAxisSpacing: 26,
        crossAxisCount: isPortrait ? 2 : 3,
        childAspectRatio: isPortrait ? 1 : 3 / 2,
        children: children,
      );
    });
  }

  Widget _buildStatisticCard(
    BuildContext context, {
    Color color = Colors.teal,
    required String title,
    required String subtitle,
    String value = '-',
  }) {
    final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      decoration: BoxDecoration(
          // color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(0.5, 1.2),
              blurStyle: BlurStyle.outer,
            ),
          ]),
      padding: const EdgeInsets.all(8),

      // color: Colors.teal[100],
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        FittedBox(
            child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        )),
        FittedBox(
            child: Text(
          utils.trimTextIfLong(value, maxCharacters: isPortrait ? 18 : 35),
          softWrap: true,
          overflow: TextOverflow.clip,
          style: Theme.of(context).textTheme.headlineMedium,
        )),
        Text(subtitle),
      ]),
    );
  }

  Widget _buildUpdateCard(BuildContext context,
      {Color? color = Colors.white70, required String value}) {
    final String updated =
        utils.capitalize(AppLocalizations.of(context)?.statsUpdate ?? 'Last update');
    final String refresh =
        utils.capitalize(AppLocalizations.of(context)?.statsRefresh ?? 'Refresh');
    // the value inside FittedBox(child: Text(value)) cannot be an empty String!
    if (value.isEmpty) value = '--';
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20), boxShadow: const [
        BoxShadow(
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0.5, 1.2),
        ),
      ]),
      padding: const EdgeInsets.all(8),

      // color: Colors.teal[100],
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        FittedBox(
            child: Text(
          '$updated:',
          style: Theme.of(context).textTheme.bodyLarge,
        )),
        FittedBox(child: Text(value)),
        Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
          Text('$refresh:'),
          IconButton(
              onPressed: () => _refresh(),
              icon: Container(
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2.0),
                ),
                child: Icon(Icons.refresh, color: Colors.green[800]),
              )),
        ]),
      ]),
    );
  }

  void _refresh() {
    setState(() {
      _futureStatistics =
          Provider.of<StatisticsProvider>(context, listen: false).refreshStatistics();
    });
  }
}
