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

  tearDown(() {
    // authStatusCtr.close();
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
  });
  group('when register method is called should:', () {
    group('Throw exception when', () {
      setUp(() {
        ss = MockSecureStorage();
        db = MockLocalDb();
        locator.registerSingleton<ISecureStorage>(ss);
        locator.registerSingleton<IUserLocalDb<Map<String, dynamic>>>(db);
        aR = AuthenticationRepository();
      });
      test('given email is taken', () async {
        // arrange
        const User newUser = User(email: 'test@test.test', password: 'pwd', name: 'test');
        when(db.select(where: ['email'], values: [newUser.email]))
            .thenThrow(Exception('User with this email: ${newUser.email} already exists'));
        // act
        // assert
        expect(aR.register(newUser), throwsException);
      });
      test('Local database createUser function throws Exception', () async {
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
  });
}
