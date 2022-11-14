// Mocks generated by Mockito 5.3.1 from annotations
// in davar/test/providers/search_words_prowider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:davar/src/data/models/models.dart' as _i3;
import 'package:davar/src/data/repositories/words_repository.dart' as _i5;
import 'package:davar/src/domain/i_words_repository.dart' as _i2;
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

/// A class which mocks [IWordsRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockWordsRepo extends _i1.Mock implements _i2.IWordsRepository<_i3.Word> {
  @override
  _i4.Future<int> create(_i3.Word? item) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [item],
        ),
        returnValue: _i4.Future<int>.value(0),
        returnValueForMissingStub: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);
  @override
  _i4.Future<List<_i3.Word>> readAll(int? userId) => (super.noSuchMethod(
        Invocation.method(
          #readAll,
          [userId],
        ),
        returnValue: _i4.Future<List<_i3.Word>>.value(<_i3.Word>[]),
        returnValueForMissingStub:
            _i4.Future<List<_i3.Word>>.value(<_i3.Word>[]),
      ) as _i4.Future<List<_i3.Word>>);
  @override
  _i4.Future<_i3.Word?> readSingle(int? id) => (super.noSuchMethod(
        Invocation.method(
          #readSingle,
          [id],
        ),
        returnValue: _i4.Future<_i3.Word?>.value(),
        returnValueForMissingStub: _i4.Future<_i3.Word?>.value(),
      ) as _i4.Future<_i3.Word?>);
  @override
  _i4.Future<List<_i3.Word>> readAllPaginated({
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
          #readAllPaginated,
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
        returnValue: _i4.Future<List<_i3.Word>>.value(<_i3.Word>[]),
        returnValueForMissingStub:
            _i4.Future<List<_i3.Word>>.value(<_i3.Word>[]),
      ) as _i4.Future<List<_i3.Word>>);
  @override
  _i4.Future<List<Map<String, dynamic>>?> rawQuery(
    String? query,
    List<dynamic>? arguments,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #rawQuery,
          [
            query,
            arguments,
          ],
        ),
        returnValue: _i4.Future<List<Map<String, dynamic>>?>.value(),
        returnValueForMissingStub:
            _i4.Future<List<Map<String, dynamic>>?>.value(),
      ) as _i4.Future<List<Map<String, dynamic>>?>);
  @override
  _i4.Future<int> update(_i3.Word? item) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [item],
        ),
        returnValue: _i4.Future<int>.value(0),
        returnValueForMissingStub: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);
  @override
  _i4.Future<int?> rawUpdate(
    List<String>? columns,
    List<dynamic>? arguments,
    int? wordId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #rawUpdate,
          [
            columns,
            arguments,
            wordId,
          ],
        ),
        returnValue: _i4.Future<int?>.value(),
        returnValueForMissingStub: _i4.Future<int?>.value(),
      ) as _i4.Future<int?>);
  @override
  _i4.Future<int> delete(int? itemId) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [itemId],
        ),
        returnValue: _i4.Future<int>.value(0),
        returnValueForMissingStub: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);
}

/// A class which mocks [WordsRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockWordsRepoImpl extends _i1.Mock implements _i5.WordsRepository {
  @override
  _i4.Future<int> create(_i3.Word? item) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [item],
        ),
        returnValue: _i4.Future<int>.value(0),
        returnValueForMissingStub: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);
  @override
  _i4.Future<int> delete(int? itemId) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [itemId],
        ),
        returnValue: _i4.Future<int>.value(0),
        returnValueForMissingStub: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);
  @override
  _i4.Future<List<Map<String, dynamic>>?> rawQuery(
    String? query,
    List<dynamic>? arguments,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #rawQuery,
          [
            query,
            arguments,
          ],
        ),
        returnValue: _i4.Future<List<Map<String, dynamic>>?>.value(),
        returnValueForMissingStub:
            _i4.Future<List<Map<String, dynamic>>?>.value(),
      ) as _i4.Future<List<Map<String, dynamic>>?>);
  @override
  _i4.Future<int?> rawUpdate(
    List<String>? columns,
    List<dynamic>? arguments,
    int? wordId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #rawUpdate,
          [
            columns,
            arguments,
            wordId,
          ],
        ),
        returnValue: _i4.Future<int?>.value(),
        returnValueForMissingStub: _i4.Future<int?>.value(),
      ) as _i4.Future<int?>);
  @override
  _i4.Future<List<_i3.Word>> readAll(int? userId) => (super.noSuchMethod(
        Invocation.method(
          #readAll,
          [userId],
        ),
        returnValue: _i4.Future<List<_i3.Word>>.value(<_i3.Word>[]),
        returnValueForMissingStub:
            _i4.Future<List<_i3.Word>>.value(<_i3.Word>[]),
      ) as _i4.Future<List<_i3.Word>>);
  @override
  _i4.Future<int> update(_i3.Word? item) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [item],
        ),
        returnValue: _i4.Future<int>.value(0),
        returnValueForMissingStub: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);
  @override
  _i4.Future<List<_i3.Word>> readAllPaginated({
    required int? userId,
    int? offset = 0,
    List<String>? where = const [],
    List<dynamic>? whereValues = const [],
    String? like,
    dynamic likeValue,
    int? limit = 10,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #readAllPaginated,
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
        returnValue: _i4.Future<List<_i3.Word>>.value(<_i3.Word>[]),
        returnValueForMissingStub:
            _i4.Future<List<_i3.Word>>.value(<_i3.Word>[]),
      ) as _i4.Future<List<_i3.Word>>);
  @override
  _i4.Future<_i3.Word?> readSingle(int? id) => (super.noSuchMethod(
        Invocation.method(
          #readSingle,
          [id],
        ),
        returnValue: _i4.Future<_i3.Word?>.value(),
        returnValueForMissingStub: _i4.Future<_i3.Word?>.value(),
      ) as _i4.Future<_i3.Word?>);
}
