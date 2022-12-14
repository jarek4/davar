// Mocks generated by Mockito 5.3.1 from annotations
// in davar/test/data/repositories/words_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:davar/src/data/local/database/db.dart' as _i2;
import 'package:davar/src/data/local/database/words_db.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDB_0 extends _i1.SmartFake implements _i2.DB {
  _FakeDB_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [WordsDb].
///
/// See the documentation for Mockito's code generation for more information.
class MockWordsDb extends _i1.Mock implements _i3.WordsDb {
  @override
  _i2.DB get instance => (super.noSuchMethod(
        Invocation.getter(#instance),
        returnValue: _FakeDB_0(
          this,
          Invocation.getter(#instance),
        ),
        returnValueForMissingStub: _FakeDB_0(
          this,
          Invocation.getter(#instance),
        ),
      ) as _i2.DB);
  @override
  _i4.Future<int> createWord(Map<String, dynamic>? word) => (super.noSuchMethod(
        Invocation.method(
          #createWord,
          [word],
        ),
        returnValue: _i4.Future<int>.value(0),
        returnValueForMissingStub: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);
  @override
  _i4.Future<int> deleteWord(int? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteWord,
          [id],
        ),
        returnValue: _i4.Future<int>.value(0),
        returnValueForMissingStub: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);
  @override
  _i4.Future<int> rawWordUpdate({
    required List<String>? columns,
    required List<dynamic>? values,
    required int? wordId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #rawWordUpdate,
          [],
          {
            #columns: columns,
            #values: values,
            #wordId: wordId,
          },
        ),
        returnValue: _i4.Future<int>.value(0),
        returnValueForMissingStub: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);
  @override
  _i4.Future<List<Map<String, dynamic>>> readAllWords(int? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #readAllWords,
          [userId],
        ),
        returnValue: _i4.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
        returnValueForMissingStub: _i4.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i4.Future<List<Map<String, dynamic>>>);
  @override
  _i4.Future<Map<String, dynamic>> readWord(int? id) => (super.noSuchMethod(
        Invocation.method(
          #readWord,
          [id],
        ),
        returnValue:
            _i4.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
        returnValueForMissingStub:
            _i4.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i4.Future<Map<String, dynamic>>);
  @override
  _i4.Future<int> updateWord(Map<String, dynamic>? word) => (super.noSuchMethod(
        Invocation.method(
          #updateWord,
          [word],
        ),
        returnValue: _i4.Future<int>.value(0),
        returnValueForMissingStub: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);
  @override
  _i4.Future<List<Map<String, dynamic>>> rawQueryWords(
    String? query,
    List<dynamic>? args,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #rawQueryWords,
          [
            query,
            args,
          ],
        ),
        returnValue: _i4.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
        returnValueForMissingStub: _i4.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i4.Future<List<Map<String, dynamic>>>);
  @override
  _i4.Future<List<Map<String, dynamic>>> readWordsPaginatedOrderedByCreated({
    required int? userId,
    required int? offset,
    List<String>? where = const [],
    List<dynamic>? whereValues = const [],
    String? like,
    dynamic likeValue,
    int? limit = 10,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #readWordsPaginatedOrderedByCreated,
          [],
          {
            #userId: userId,
            #offset: offset,
            #where: where,
            #whereValues: whereValues,
            #like: like,
            #likeValue: likeValue,
            #limit: limit,
          },
        ),
        returnValue: _i4.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
        returnValueForMissingStub: _i4.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i4.Future<List<Map<String, dynamic>>>);
}
