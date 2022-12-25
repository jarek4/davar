import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/quiz/quiz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

// flutter pub run build_runner build --delete-conflicting-outputs

@GenerateNiceMocks([MockSpec<WordsProvider>(as: #MockWordsProvider)])
import 'quiz_provide_test.mocks.dart';

void main() {
  late QuizProvider sut;
  late WordsProvider wp;

  // const List<Word> words = [
  //   Word(catchword: 'c', id: 176, userId: 2, userTranslation: 'T'),
  //   Word(catchword: 'c2', id: 18, userId: 2, userTranslation: 'T2'),
  //   Word(catchword: 'c3', id: 26, userId: 2, userTranslation: 'T3'),
  // ];

  // setUp(() {
  // });
  // tearDownAll(() => locator.unregister<IWordsLocalDb<Map<String, dynamic>>>());

  group('Quiz Provider:', () {
    group('initial values', () {
      setUp(() {
        wp = MockWordsProvider();
        // locator.registerSingleton<IWordsRepository<Word>>(repository);
        sut = QuizProvider(wp);
      });

      test('error message = empty string', () async {
        expect(sut.errorMsg, '');
      });
      test('status = QuizProviderStatus.loading', () async {
        expect(sut.status, QuizProviderStatus.loading);
      });
    });
  });
}
