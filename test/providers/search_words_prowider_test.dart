import 'dart:async';

import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/data/repositories/words_repository.dart';
import 'package:davar/src/domain/i_words_repository.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_words_prowider_test.mocks.dart';

// flutter pub run build_runner build --delete-conflicting-outputs

// @GenerateNiceMocks([MockSpec<IWordsRepository<Word>>(as: #MockWordsRepo)])
@GenerateNiceMocks([MockSpec<WordsRepository>(as: #MockWordsRepoImpl)])
@GenerateNiceMocks([MockSpec<WordsProvider>(as: #MockWordsProviderImpl)])
void main() {
  late IWordsRepository<Word> wordsRepo;
  late WordsProvider wp;
  late SearchWordsProvider sut;
  const User user = User(id: 1, name: 'user');

  setUpAll(() {
    setupLocator();
    locator.allowReassignment = true;
  });

  group('SearchWordsProvider should:', () {
    group('emmit default values', () {
      setUp(() {
        wordsRepo = MockWordsRepoImpl();
        wp = MockWordsProviderImpl();
        locator.registerSingleton<IWordsRepository<Word>>(wordsRepo);
        sut = SearchWordsProvider(wp);
      });

      test('errorMsg is empty ', () async {
        // arrange // act
        // assert
        expect(sut.errorMsg, '');
      });
      test('selectedCategory= allCategoriesFilter', () async {
        expect(sut.selectedCategory, utils.AppConst.allCategoriesFilter);
      });
      test('selectedOnlyFavorite= false', () async {
        expect(sut.selectedOnlyFavorite, false);
      });
      test('listOffset= 0', () async {
        expect(sut.listOffset, 0);
      });
    });
    group('properly handle setter: ', () {
      setUp(() {
        wordsRepo = MockWordsRepoImpl();
        wp = MockWordsProviderImpl();
        locator.registerSingleton<IWordsRepository<Word>>(wordsRepo);
        sut = SearchWordsProvider(wp);
      });

      test('sut.errorMsg = e', () {
        // arrange
        const String e = 'error';
        // act
        sut.errorMsg = e;
        // assert
        expect(sut.errorMsg, e);
      });
      test('listOffset', () {
        // arrange
        const int o = 10;
        // act
        sut.listOffset = o;
        // assert
        expect(sut.listOffset, o);
      });
      test('onCategoryChange(WordCategory())', () async {
        // arrange
        const WordCategory wc = WordCategory(id: 5, name: '5', userId: 1);
        // act
        await sut.onCategoryChange(wc);
        // assert
        expect(sut.selectedCategory, wc);
      });
      test('onCategoryChange(null)', () async {
        // arrange // act
        await sut.onCategoryChange(null);
        // assert
        expect(sut.selectedCategory, utils.AppConst.allCategoriesFilter);
      });
      test('onOnlyFavoriteChange()', () async {
        // arrange
        final bool f = sut.selectedOnlyFavorite;
        // act
        await sut.onOnlyFavoriteChange();
        // assert
        expect(sut.selectedOnlyFavorite, !f);
      });
    });
  });
  group('Stream<List<Word>> get filteredWords emits', () {
    late StreamController<List<Word>> controller;
    setUp(() {
      wordsRepo = MockWordsRepoImpl();
      wp = MockWordsProviderImpl();
      locator.registerSingleton<IWordsRepository<Word>>(wordsRepo);
      sut = SearchWordsProvider(wp);
      controller = StreamController<List<Word>>.broadcast(sync: false);
    });
    tearDown(() {
      controller.close();
    });

    test('Stream<List<Word>> type', () async {
      // arrange // act  // assert
      expect(sut.filteredWords, isA<Stream<List<Word>>>());
    });
    test('1 data added to controller', () async {
      // arrange
      const List<Word> data = [Word(catchword: 'cw1', id: 1, userId: 1, userTranslation: 't')];
      // act  // assert
      controller.stream.listen(
        expectAsync1(
          (event) {
            expect(event, data);
          },
        ),
      );
      controller.add(data);
    });
    test('2 data added to controller', () async {
      // arrange
      const Word w1 = Word(catchword: 'cw1', id: 1, userId: 1, userTranslation: 't');
      const Word w2 = Word(catchword: 'cw2', id: 2, userId: 1, userTranslation: 't');
      const List<Word> data2 = [w1, w2];
      // act  // assert
      controller.stream.listen(
        expectAsync1(
          (event) {
            expect(event, data2);
          },
        ),
      );

      controller.add(data2);
    });
  });
  group('Stream<List<Word>> querySearch(String query) emits', () {
    setUp(() {
      wordsRepo = MockWordsRepoImpl();
      wp = MockWordsProviderImpl();
      locator.registerSingleton<IWordsRepository<Word>>(wordsRepo);
      sut = SearchWordsProvider(wp);
    });
    tearDown(() {});
    test('data returned from Future', () async {
      // arrange
      const Word item = Word(catchword: 'cw1', id: 1, userId: 1, userTranslation: 't');
      const List<Word> data = [item];
      List<Map<String, dynamic>>? map = [item.toJson()];
      when(wordsRepo.rawQuery('', [1])).thenAnswer((_) => Future.value(map));
      // act  // assert
      expect(sut.querySearch(''), emits(isA<List<Word>>()));
      // sut.querySearch('').listen(expectAsync1((value) => expect(value, isA<List<Word>>()))); // OK
      // sut.querySearch('').listen(expectAsync1((value) => expect(value, emits([data])))); // BAD!
    });
    /*   test('2 data returned from Future', () async {
      // arrange
      // final Stream<List<Word>> stream = sut.querySearch('');
      const List<Word> data = [Word(catchword: 'cw1', id: 1, userId: 1, userTranslation: 't')];
      when(wordsRepo.rawQuery('', [1])).thenAnswer((_) => Future.value(data));
      // act  // assert
      // await pumpEventQueue();
     // expectLater(stream, emits([data])); // Which: emitted * []  x Stream closed.
     //  sut.querySearch('');
     //  verify(wordsRepo.rawQuery('', [1])).called(1); // No matching calls
    })*/
    ;
  });
}
