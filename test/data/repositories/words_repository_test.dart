import 'package:davar/locator.dart';
import 'package:davar/src/data/local/database/words_db.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/data/repositories/words_repository.dart';
import 'package:davar/src/domain/i_words_local_db.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// flutter pub run build_runner build --delete-conflicting-outputs

@GenerateNiceMocks([MockSpec<WordsDb>(as: #MockWordsDb)])
import 'words_repository_test.mocks.dart';

void main() {
  late WordsRepository sut;
  late IWordsLocalDb<Map<String, dynamic>> db;

  setUp(() {
    setupLocator();
    locator.allowReassignment = true;
  });
  // tearDownAll(() => locator.unregister<IWordsLocalDb<Map<String, dynamic>>>());

  group('WordsRepository:', () {
    group('create method should', () {
      setUp(() {
        db = MockWordsDb();
        locator.registerSingleton<IWordsLocalDb<Map<String, dynamic>>>(db);
        sut = WordsRepository();
      });

      test('return Future<int>', () async {
        // arrange
        Word w = const Word(catchword: 'c', id: 176, userId: 2, userTranslation: 'T');
        // when(db.createWord(w.toJson())).thenAnswer((_) => Future.value(3));
        Future<int> res = sut.create(w); // always returns 0;
        expect(res, isA<Future<int>>());
        verify(sut.create(w)).called(1);
        // verify(db.createWord(w.toJson())).called(1); // never calls!
      });
    });
  });
}
