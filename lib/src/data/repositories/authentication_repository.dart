// ignore_for_file: avoid_print

import 'dart:async';

import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_authentication_repository.dart';
import 'package:davar/src/domain/i_user_local_db.dart';
import 'package:davar/src/errors_reporter/errors_reporter.dart';
import 'package:davar/src/utils/utils.dart';

import '../../domain/i_secure_storage.dart';

// User() == emptyUser [AppConst.emptyUser]
// emptyUser=(email: 'empty', id: 1, password: '', authToken: null);
// unknownUser=(createdAt: '-11111:-11:-11', email: 'unknown', id: -1, name: 'unknown');
// emptyUser if unauthenticated, unknownUser if status unknown (starting app, logged out)

class AuthenticationRepository implements IAuthenticationRepository<User> {
  User _user = AppConst.unknownUser; // cant be emptyUser!

  final _controller = StreamController<User>.broadcast();

  final ISecureStorage _ss = locator<ISecureStorage>();
  final IUserLocalDb _localDB = locator<IUserLocalDb<Map<String, dynamic>>>();

  @override
  Future<int?> loginWithEmailAndPassword({required String email, required String password}) async {
    try {
      Map<String, dynamic> searchResult = await _selectUserFromDatabase(email, password);
      print('log in - isNotEmpty? -> ${searchResult.isNotEmpty}');
      if (searchResult.isEmpty) {
        // this check allows to show login error info during logging in process
        print('isE: ${_user == AppConst.emptyUser}; isU: ${_user == AppConst.unknownUser}');
        if (_user != AppConst.emptyUser && _user != AppConst.unknownUser) {
          _controller.add(_user = AppConst.emptyUser);
        }
        return null;
      }
      User foundUser = User.fromJson(searchResult);
      await _ss.persistEmail(email);
      await _ss.persistPassword(password);
      print('AuthenticationRepository loginWithEmailAndPassword');
      _controller.add(_user = foundUser);
      return foundUser.id;
      // _controller.add(_user = const User(id: 3, name: 'testUser3', email: 'new3@email.eu', password: 'ppp')); // TESTS!

    } catch (e, stackTrace) {
      Exception exception = Exception('Bad connection to the database! Not able to log in.');
      await ErrorsReporter.genericThrow(
        e.toString(),
        exception,
        stackTrace: stackTrace,
      );
      throw exception;
    }
  }

  @override

  /// Returns created user id or null. If email is taken returns -1
  Future<int?> register(User user) async {
    if (await _isEmailTaken(user.email)) {
      return -1;
    }
    Map<String, dynamic> userAsJson = user.toJson();
    //id is auto increment by DB, createdAt is set by DB
    userAsJson.remove('id');
    userAsJson.remove('createdAt');
    print('AuthenticationRepository register userToJson.remove: $userAsJson\n');
    try {
      final int id = await _localDB.createUser(userAsJson);
      print('AuthenticationRepository register - created user id: $id\n');
      Map<String, dynamic> lastInserted = await _selectUserFromDatabase(user.email, user.password);
      print('registeredUser.isNotEmpty: ${lastInserted.isNotEmpty}');
      if (lastInserted.isEmpty) return 0;
      final User registered = User.fromJson(lastInserted);
      await _ss.persistEmail(user.email);
      await _ss.persistPassword(user.password);
      print(
          'AuthenticationRepository register newUser.fromJson createdAt: ${registered.createdAt}\n');
      _controller.add(_user = registered);
      return registered.id;
    } catch (e, stackTrace) {
      const String msg =
          'AuthenticationRepository register Exception! Bad connection to the database! Not able to sign up.';
      Exception exception = Exception(msg);
      await ErrorsReporter.genericThrow(
        e.toString(),
        exception,
        stackTrace: stackTrace,
      );
      throw exception;
    }
  }

  /// Checks if user with given email already exists in database. Returns false if not taken.
  Future<bool> _isEmailTaken(String email) async {
    final List<dynamic> res = await _localDB.selectUser(where: ['email'], values: [email]);
    if (res.isNotEmpty) return true;
    return false;
  }

  @override
  Future<void> signOut() async {
    print('AuthenticationRepository -> signOut()');
    await _ss.deleteAll();
    // important
    //if _user=AppConst.emptyUser then there is no loggedOut view shown, but onboarding screen!
    _controller.add(_user = AppConst.unknownUser);
  }

// Attention!
  @override
  Future<void> tryToAuthenticate() async {
    print('AuthenticationRepository -> tryToAuthenticate()1');
    // User u2 = const User(id: 3, name: 'testUser3', email: 'new3@email.eu', password: 'password');
    final List<String>? emailAndPassword = await _checkStoredCredentials();
    if (emailAndPassword == null || emailAndPassword.isEmpty) {
      print('AuthenticationRepository -> tryToAuthenticate()2 -> emailOrPassword == null');
      _controller.add(_user = AppConst.emptyUser);
      return;
    }
    try {
      print('AuthenticationRepository -> tryToAuthenticate()3');
      final Map<String, dynamic> searchResult =
          await _selectUserFromDatabase(emailAndPassword[0], emailAndPassword[1]);

      if (searchResult.isEmpty) return _controller.add(_user = AppConst.emptyUser);

      _controller.add(_user = User.fromJson(searchResult));
    } catch (e, stackTrace) {
      print('tryToAuthenticate4 Exception: \n----------\n$e');
      Exception exception = Exception('AuthenticationRepository tryToAuthenticate');
      await ErrorsReporter.genericThrow(
        e.toString(),
        exception,
        stackTrace: stackTrace,
      );
      // not authenticated!
      // _controller.add(_user = AppConst.emptyUser);

    }
  }

  Future<List<String>?> _checkStoredCredentials() async {
    print('AuthenticationRepository -> _checkStoredCredentials()');
    try {
      final String? email = await _ss.getEmail();
      final String? pwd = await _ss.getPassword();
      final bool hasCredentials =
          (email != null && pwd != null && email.isNotEmpty && pwd.isNotEmpty);

      if (!hasCredentials) return null;
      print('AuthenticationRepository -> _checkStoredCredentials()[email, pwd] = [$email, $pwd]');
      return [email, pwd];
    } catch (e, stackTrace) {
      print(' \n----------\ncheck stored credentials Exception: $e');
      Exception exception = Exception('AuthenticationRepository check stored credentials');
      await ErrorsReporter.genericThrow(
        e.toString(),
        exception,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// If there is no matching user may return an empty Map.
  /// selectUserFromDatabase(String email, String pwd)
  Future<Map<String, dynamic>> _selectUserFromDatabase(String email, String pwd) async {
    print(
        '\n----------\nAuthenticationRepository-> _selectUserFromDatabase [email, password]: $email, $pwd');
    try {
      List<Map<String, dynamic>?> res = await _localDB.selectUser(
        where: ['email', 'password'],
        values: [email, pwd],
      ) as List<Map<String, dynamic>>;
      print('\n----------\nAuthenticationRepository-> _selectUserFromDatabase res: $res');
      if (res.isEmpty || res[0] == null || res[0]!.isEmpty) return {};
      final Map<String, dynamic> firstFound = res.first!;
      print('AuthenticationRepository-> _selectUserFromDatabase user id: ${res[0]?['id']}');
      if (res.first!.isEmpty) return {};
      return firstFound;
    } catch (e, stackTrace) {
      Exception exception = Exception('AuthenticationRepository register selectUserFromDatabase');
      await ErrorsReporter.genericThrow(
        e.toString(),
        exception,
        stackTrace: stackTrace,
      );
      print('\n----------\nAuthenticationRepository-> _selectUserFromDatabase Exception: $e');
      return {};
    }
  }

  @override
  Stream<User> get user async* {
    print(
        'AuthenticationRepository Stream<User> get user async* [ id: ${_user.id}, name: ${_user.name}]');
    yield _user;
    yield* _controller.stream;
  }

  @override
  Future<int> permanentlyRemoveCurrentUser() async {
    try {
      final int res = await _localDB.deleteUser(_user.id);
      await _ss.deleteAll();
      _controller.add(_user = AppConst.emptyUser);
      return res;
    } catch (e, stackTrace) {
      print(
          'AuthenticationRepository-> permanentlyRemoveCurrentUser(id: ${_user.id}) Exception: \n----------\n$e');
      Exception exception = Exception('AuthenticationRepository permanentlyRemoveCurrentUser');
      await ErrorsReporter.genericThrow(
        e.toString(),
        exception,
        stackTrace: stackTrace,
      );
      return 0;
    }
  }

  @override
  void dispose() => _controller.close();
}
