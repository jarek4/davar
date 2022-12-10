// Mocks generated by Mockito 5.3.1 from annotations
// in davar/test/quiz/quiz_provide_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;
import 'dart:ui' as _i5;

import 'package:davar/src/data/models/models.dart' as _i4;
import 'package:davar/src/providers/words_provider.dart' as _i2;
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

/// A class which mocks [WordsProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockWordsProvider extends _i1.Mock implements _i2.WordsProvider {
  @override
  _i2.WordsProviderStatus get status => (super.noSuchMethod(
        Invocation.getter(#status),
        returnValue: _i2.WordsProviderStatus.error,
        returnValueForMissingStub: _i2.WordsProviderStatus.error,
      ) as _i2.WordsProviderStatus);
  @override
  String get wordsErrorMsg => (super.noSuchMethod(
        Invocation.getter(#wordsErrorMsg),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
  @override
  set errorMsg(String? value) => super.noSuchMethod(
        Invocation.setter(
          #errorMsg,
          value,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i3.Future<List<int>> get wordsIds => (super.noSuchMethod(
        Invocation.getter(#wordsIds),
        returnValue: _i3.Future<List<int>>.value(<int>[]),
        returnValueForMissingStub: _i3.Future<List<int>>.value(<int>[]),
      ) as _i3.Future<List<int>>);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  _i3.Future<List<_i4.Word>> readAllWords() => (super.noSuchMethod(
        Invocation.method(
          #readAllWords,
          [],
        ),
        returnValue: _i3.Future<List<_i4.Word>>.value(<_i4.Word>[]),
        returnValueForMissingStub:
            _i3.Future<List<_i4.Word>>.value(<_i4.Word>[]),
      ) as _i3.Future<List<_i4.Word>>);
  @override
  _i3.Future<List<_i4.Word>> readPaginated({
    int? offset = 0,
    List<String>? where = const [],
    List<dynamic>? whereValues = const [],
    int? limit = 10,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #readPaginated,
          [],
          {
            #offset: offset,
            #where: where,
            #whereValues: whereValues,
            #limit: limit,
          },
        ),
        returnValue: _i3.Future<List<_i4.Word>>.value(<_i4.Word>[]),
        returnValueForMissingStub:
            _i3.Future<List<_i4.Word>>.value(<_i4.Word>[]),
      ) as _i3.Future<List<_i4.Word>>);
  @override
  _i3.Future<List<_i4.Word>> rawQuerySearch(String? queryString) =>
      (super.noSuchMethod(
        Invocation.method(
          #rawQuerySearch,
          [queryString],
        ),
        returnValue: _i3.Future<List<_i4.Word>>.value(<_i4.Word>[]),
        returnValueForMissingStub:
            _i3.Future<List<_i4.Word>>.value(<_i4.Word>[]),
      ) as _i3.Future<List<_i4.Word>>);
  @override
  _i3.Future<void> create(_i4.Word? word) => (super.noSuchMethod(
        Invocation.method(
          #create,
          [word],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> delete(int? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> reverseIsFavorite(_i4.Word? item) => (super.noSuchMethod(
        Invocation.method(
          #reverseIsFavorite,
          [item],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> update(_i4.Word? item) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [item],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void addListener(_i5.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i5.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
