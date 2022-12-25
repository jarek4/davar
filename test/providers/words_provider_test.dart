import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/data/repositories/words_repository.dart';
import 'package:davar/src/domain/i_words_repository.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// flutter pub run build_runner build --delete-conflicting-outputs

@GenerateNiceMocks([MockSpec<WordsRepository>(as: #MockWordsRepository)])
import 'words_provider_test.mocks.dart';

void main() {
  late WordsProvider sut;
  late IWordsRepository<Word> repository;

  const User u = User(id: 5, learning: 'l', native: 'n');
  const List<Word> words = [
    Word(catchword: 'c', id: 176, userId: 2, userTranslation: 'T'),
    Word(catchword: 'c2', id: 18, userId: 2, userTranslation: 'T2'),
  ];

  setUp(() {
    setupLocator();
    locator.allowReassignment = true;
  });
  // tearDownAll(() => locator.unregister<IWordsLocalDb<Map<String, dynamic>>>());

  group('WordsProvider:', () {
    group('initial values', () {
      setUp(() {
        repository = MockWordsRepository();
        locator.registerSingleton<IWordsRepository<Word>>(repository);
        sut = WordsProvider(u);
      });

      test('error message = empty string', () async {
        expect(sut.wordsErrorMsg, '');
      });
      test('status = WordsProviderStatus.success', () async {
        expect(sut.status, WordsProviderStatus.success);
      });
    });
    group('readAllWords method', () {
      setUp(() {
        repository = MockWordsRepository();
        locator.registerSingleton<IWordsRepository<Word>>(repository);
        sut = WordsProvider(u);
      });

      test('returns type Future<List<Word>>', () async {
        when(repository.readAll(u.id)).thenAnswer((_) => Future.value(words));
        expect(sut.readAllWords(), isA<Future<List<Word>>>());
        verify(sut.readAllWords()).called(1);
        // verify(repository.readAll(u.id)).called(1);
      });
      test('data from repository', () async {
        when(repository.readAll(u.id)).thenAnswer((_) => Future.value(words));
        expect(await sut.readAllWords(), words);
        verify(sut.readAllWords()).called(1);
      });
      test('data from repository 2', () async {
        List<Word> words2 = [...words, ...words];
        // arrange
        when(repository.readAll(u.id)).thenAnswer((_) => Future.value(words2));
        expect(await sut.readAllWords(), words2);
        verify(sut.readAllWords()).called(1);
      });
      test('returns empty array when repository throws exception', () async {
        // List<Word> words2 = [...words, ...words];
        // arrange
        when(repository.readAll(u.id)).thenThrow(Exception('e'));
        expect(await sut.readAllWords(), []);
        verify(sut.readAllWords()).called(1);
      });
      test('sets WordsProviderStatus.success when repository throws exception', () async {
        // arrange
        when(repository.readAll(u.id)).thenThrow(Exception('e2'));
        // act
        await sut.readAllWords();
        expect(sut.status, WordsProviderStatus.success);
        verify(sut.readAllWords()).called(1);
      });
    });
   /* group('create method', () {
      setUp(() {
        repository = MockWordsRepository();
        locator.registerSingleton<IWordsRepository<Word>>(repository);
        sut = WordsProvider(u);
      });
      test('', () async {});
    });*/
  });
}
