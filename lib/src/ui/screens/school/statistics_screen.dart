import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/ui/widgets/widgets.dart';
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
        return Consumer<StatisticsProvider>(builder: (BuildContext context, StatisticsProvider sp, _) {
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
      }
    );
  }

  Widget _buildScreenBody(BuildContext context, StatisticsProvider sp) {
    return FutureBuilder<DavarStatistic>(
      initialData: DavarStatistic(
          date: DateTime.now(),
          wordsNumber: 0,
          sentencesNumber: 0,
          mostPointsWords3: [],
          leastPointsWords3: [],
          highestQuizScore: 0),
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
    return _layoutBuilderWrapper(SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: 8.0),
        Text('words number: ${stats.wordsNumber}'),
        Text('sentences number ${stats.sentencesNumber}'),
        Text('highest quiz score ${stats.highestQuizScore}'),
        Text('mostPointsWords3 ${stats.mostPointsWords3}'),
        SizedBox(height: 10,),
        Text('leastPointsWords3 ${stats.leastPointsWords3}'),
        Text('Date ${stats.date}'),
      ]),
    ));
  }

  LayoutBuilder _layoutBuilderWrapper(Widget child) {
    return LayoutBuilder(builder: (context, constraint) {
      final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
      final double maxWidth = constraint.maxWidth;
      final double landscapeMaxW = (maxWidth * 3) / 4;
      return SizedBox(width: isPortrait ? maxWidth - 30 : landscapeMaxW, child: child);
    });
  }
}
