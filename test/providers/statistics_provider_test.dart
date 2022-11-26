import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/statistics_services/statistics_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'search_words_prowider_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WordsProvider>(as: #MockWordsProviderImpl)])
void main() {
  late WordsProvider wp;
  late StatisticsProvider sut;

  setUpAll(() {
    wp = MockWordsProviderImpl();
    sut = StatisticsProvider(wp);
  });

  group('StatisticsProvider:', () {
    group('should emit default values', () {
      /*  setUp(() {
        wp = MockWordsProviderImpl();
        sut = StatisticsProvider(wp);
      });*/

      test('status StatisticsProviderStatus.success', () async {
        // arrange // act
        // assert
        expect(sut.status, StatisticsProviderStatus.success);
      });
      test('statistics = const DavarStatistic()', () async {
        expect(sut.statistics, const DavarStatistic());
      });
    });

    group('methods should returns proper types', () {
      test('loadPreviewsStatistics return type Future<DavarStatistic>', () async {
        expect(sut.loadPreviewsStatistics(), isA<Future<DavarStatistic>>());
      });
      test('refreshStatistics() return type Future<DavarStatistic>', () async {
        expect(sut.refreshStatistics(), isA<Future<DavarStatistic>>());
      });
    });
  });
}
