import 'dart:async';
import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/data/repositories/authentication_repository.dart';
import 'package:davar/src/domain/i_secure_storage.dart';
import 'package:davar/src/domain/i_user_local_db.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// flutter pub run build_runner build

@GenerateNiceMocks([MockSpec<ISecureStorage>(as: #MockSecureStorage)])
@GenerateNiceMocks([MockSpec<IUserLocalDb<Map<String, dynamic>>>(as: #MockLocalDb)])
import 'authentication_repository_test.mocks.dart';

void main() {
  late AuthenticationRepository aR;
  late ISecureStorage ss;
  late IUserLocalDb<Map<String, dynamic>> db;

  setUpAll(() {
    setupLocator();
    locator.allowReassignment = true;
  });

  // group('call ISecureStorage method:', () {});

  group('AuthenticationRepository:', () {
    group('- should call ISecureStorage method:', () {
      setUp(() {
        ss = MockSecureStorage();
        db = MockLocalDb();
        locator.registerSingleton<ISecureStorage>(ss);
        locator.registerSingleton<IUserLocalDb<Map<String, dynamic>>>(db);
        aR = AuthenticationRepository();
      });

      test('deleteAll - on signOut', () async {
        // arrange
        // act
        await aR.signOut();
        // assert
        verify(ss.deleteAll()).called(1);
      });
      test('getEmail and getPassword - on tryToAuthenticate', () async {
        // arrange
        // act
        await aR.tryToAuthenticate();
        // assert
        verify(ss.getEmail());
        verify(ss.getPassword());
      });
      test('deleteAll - on permanentlyRemoveCurrentUser', () async {
        // arrange
        // act
        await aR.permanentlyRemoveCurrentUser();
        // assert
        verify(ss.deleteAll());
      });
    });
    group('- should NOT call ISecureStorage method:', () {
      setUp(() {
        ss = MockSecureStorage();
        db = MockLocalDb();
        locator.registerSingleton<ISecureStorage>(ss);
        locator.registerSingleton<IUserLocalDb<Map<String, dynamic>>>(db);
        aR = AuthenticationRepository();
      });

      test('getEmail - on signOut', () async {
        // arrange
        // act
        await aR.signOut();
        // assert
        verifyNever(ss.getEmail());
      });
      test('deleteAll - on tryToAuthenticate', () async {
        // arrange
        // act
        await aR.tryToAuthenticate();
        // assert
        verifyNever(ss.deleteAll());
      });
      test('deletePassword - on tryToAuthenticate', () async {
        // arrange
        // act
        await aR.tryToAuthenticate();
        // assert
        verifyNever(ss.deletePassword());
      });
      test('deleteEmail - on tryToAuthenticate', () async {
        // arrange
        // act
        await aR.tryToAuthenticate();
        // assert
        verifyNever(ss.deleteEmail());
      });
      test('persistPassword - on permanentlyRemoveCurrentUser', () async {
        // arrange
        // act
        await aR.permanentlyRemoveCurrentUser();
        // assert
        verifyNever(ss.persistPassword('password'));
      });
    });
    group('register method should:', () {
      setUp(() {
        ss = MockSecureStorage();
        db = MockLocalDb();
        locator.registerSingleton<ISecureStorage>(ss);
        locator.registerSingleton<IUserLocalDb<Map<String, dynamic>>>(db);
        aR = AuthenticationRepository();
      });

      test('return type Future<void> when given email is not taken', () async {
        // arrange
        const User newUser =
            User(email: 'test2@test.test', password: 'pwd2', name: 'test2', id: 13);
        final Map<String, dynamic> userAsJson = newUser.toJson();
        Future<List<Map<String, dynamic>>> isEmailTakenResponse = Future.value([]);
        Future<List<Map<String, dynamic>>> selectUserFromDbResponse = Future.value([userAsJson]);
        when(db.select(where: ['email'], values: [newUser.email]))
            .thenAnswer((_) => isEmailTakenResponse);
        when(db.createUser(userAsJson)).thenAnswer((_) => Future.value(newUser.id));
        when(db.select(where: ['email', 'password'], values: [newUser.email, newUser.password]))
            .thenAnswer((_) => selectUserFromDbResponse);
        // act
        // assert
        expect(aR.register(newUser), isA<Future<void>>());
      });
      test('throw exception when given email is taken', () async {
        // arrange
        const User newUser = User(email: 'test@test.test', password: 'pwd', name: 'test');
        when(db.select(where: ['email'], values: [newUser.email]))
            .thenThrow(Exception('User with this email: ${newUser.email} already exists'));
        // act
        // assert
        expect(aR.register(newUser), throwsException);
      });
      test('throw exception when Local database createUser function throws Exception', () async {
        // arrange
        const User newUser = User(email: 'test@test.test', password: 'pwd', name: 'test', id: 11);
        final Map<String, dynamic> json = newUser.toJson();
        when(db.createUser(json)).thenThrow(Exception());
        when(db.select(where: ['email', 'password'], values: [newUser.email, newUser.password]))
            .thenThrow(Exception());
        // act
        // assert
        expect(aR.register(newUser), throwsException);
      });
    });
    group('stream controller:', () {
      late StreamController<User> controller;
      setUp(() {
        ss = MockSecureStorage();
        db = MockLocalDb();
        locator.registerSingleton<ISecureStorage>(ss);
        locator.registerSingleton<IUserLocalDb<Map<String, dynamic>>>(db);
        aR = AuthenticationRepository();
        controller = StreamController<User>.broadcast(sync: false);
      });
      tearDown(() {
        controller.close();
      });
      test('emits empty user when controller.add(emptyUser)', () {
        Stream<User> stream = controller.stream;
        const User emptyUser = User();
        stream.listen((event) {
         // print(event);
        });

        expectLater(stream, emits(emptyUser));

        controller.add(emptyUser);
      });
      test('emits notEmptyUser when controller.add(notEmptyUser)', () {
        Stream<User> stream = controller.stream;
        const User notEmptyUser = User(id: 2, email: 'test', authToken: 'testToken');
        stream.listen(
          expectAsync1(
                (event) {
              expect(event, notEmptyUser);
            },
          ),
        );
        controller.add(notEmptyUser);
      });
      test('emits users in right order', () async {
       Stream<User> stream = controller.stream;
        const User emptyUser = User();
        const User notEmptyUser = User(id: 2, email: 'test', name: 'notEmptyUser', authToken: 'testToken');
        List<User> expectedRecords = [notEmptyUser, emptyUser, notEmptyUser];
        int i = 0;
        expect(stream, emitsInAnyOrder(expectedRecords));
       controller.add(notEmptyUser);
       controller.add(emptyUser);
       controller.add(notEmptyUser);
      });
    });
  });
}
