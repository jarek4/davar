import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WordsProvider wp = Provider.of<WordsProvider>(context);
    return ChangeNotifierProvider<StatisticsProvider>(
        create: (context) => StatisticsProvider(wp),
        builder: (context, _) {
          return Consumer<StatisticsProvider>(
              builder: (BuildContext context, StatisticsProvider sp, _) {
            switch (sp.status) {
              case StatisticsProviderStatus.loading:
                return const LinearLoadingWidget(info: 'Loading wait...');
              case StatisticsProviderStatus.success:
                return _buildScreenBody(context, sp);
              case StatisticsProviderStatus.error:
                String e = sp.errorMsg;
                return LinearLoadingWidget(isError: true, info: e.isNotEmpty ? e : 'Error');
              default:
                return const Center(child: CircularProgressIndicator.adaptive());
            }
          });
        });
  }

  Widget _buildScreenBody(BuildContext context, StatisticsProvider sp) {
    return FutureBuilder<DavarStatistic>(
        initialData: const DavarStatistic(),
        future: sp.loadStatistics(),
        builder: (context, snapshot) {
          final bool snapHasError = snapshot.hasError;
          ConnectionState connection = snapshot.connectionState;
          if (connection == ConnectionState.done && !snapHasError) {
            return _buildContent(context, sp, snapshot);
          }
          if (snapHasError) {
            return const LinearLoadingWidget(isError: true, info: 'Error occurs');
          }
          return const Center(child: CircularProgressIndicator.adaptive());
        });
  }

  Widget _buildContent(BuildContext context, StatisticsProvider sp, AsyncSnapshot snap) {
    DavarStatistic stats = snap.data;
    return _layoutBuilderWrapper([
      _buildUpdateCard(context, value: stats.date),
      _buildStatisticCard(context,
          color: Colors.teal[100],
          title: 'WORDS',
          subtitle: 'The number of all your words.',
          value: stats.wordsNumber.toString()),
      _buildStatisticCard(context,
          color: Colors.teal[200],
          title: 'SENTENCES',
          subtitle: 'The number of all your sentences.',
          value: stats.sentencesNumber.toString()),
      _buildStatisticCard(context,
          color: Colors.teal[300],
          title: 'QUIZ SCORE',
          subtitle: 'The highest quiz score.',
          value: stats.highestQuizScore.toString()),
      _buildStatisticCard(context,
          color: Colors.teal[400],
          title: 'THE BEST',
          subtitle: 'The word or sentence with the highest number of points.',
          value: stats.mostPointsWord?.catchword ?? ''),
      _buildStatisticCard(context,
          color: Colors.teal[500],
          title: 'THE WEAKEST',
          subtitle: 'The word or sentence with the lowest number of points.',
          value: '${stats.leastPointsWord?.catchword} stats.leastPointsWord' ?? ''),
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
    Color? color = Colors.teal,
    required String title,
    required String subtitle,
    String value = '-',
  }) {
    final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0.5, 1.2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),

      // color: Colors.teal[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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
        ],
      ),
    );
  }

  Widget _buildUpdateCard(BuildContext context,
      {Color? color = Colors.white70, required String value}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0.5, 1.2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),

      // color: Colors.teal[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FittedBox(
              child: Text(
            'Last update:',
            style: Theme.of(context).textTheme.bodyLarge,
          )),
          FittedBox(child: Text(value)),
          Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
            const Text('Refresh:'),
            IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
          ]),
        ],
      ),
    );
  }
}
