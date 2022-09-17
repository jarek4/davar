// ignore_for_file: avoid_print

import 'dart:async';

import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_authentication_repository.dart';
import 'package:davar/src/domain/i_user_local_db.dart';
import 'package:davar/src/utils/utils.dart';

import '../../domain/i_secure_storage.dart';

// default or empty User is returned when there is NO User:
// AppConst.emptyUser = User(email: 'empty', id: -1, authToken: null);

class AuthenticationRepository implements IAuthenticationRepository<User> {
  User _user = AppConst.emptyUser; // emptyUser == not authenticated

  final _controller = StreamController<User>.broadcast();

  final ISecureStorage _ss = locator<ISecureStorage>();
  final IUserLocalDb _localDB = locator<IUserLocalDb<Map<String, dynamic>>>();

  @override
  Future<void> loginWithEmailAndPassword(
      {required String email, required String password}) {
    // TODO: implement loginWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<void> register(User user) async {
    if (await _isEmailTaken(user.email)) {
      throw Exception('User with this email: ${user.email} already exists');
    }
    // String timeStamp = DateTime.now().toIso8601String();
    // User userWithTimeStamp = user.copyWith(createdAt: timeStamp);
    Map<String, dynamic> userToJson = user.toJson();
    // remove id, createdAt keys:
    userToJson.remove('id');
    userToJson.remove('createdAt');
    print('AuthenticationRepository register userToJson.remove: $userToJson\n');
    try {
      final int id = await _localDB.createUser(userToJson);
      print('AuthenticationRepository register created user id: $id\n');
      Map<String, dynamic> registeredUser =
          await _selectUserFromDatabase(user.email, user.password);
      if (registeredUser.isNotEmpty) {
        User newUser = User.fromJson(registeredUser);
        await _ss.persistEmail(user.email);
        await _ss.persistPassword(user.password);
        print(
            'AuthenticationRepository register newUser.fromJson createdAt: ${newUser.createdAt}\n');
        _controller.add(_user = newUser);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // check if user with given email already exists in database
  Future<bool> _isEmailTaken(String email) async {
    try {
      final List<dynamic> res =
          await _localDB.select(where: ['email'], values: [email]);
      if (res.isNotEmpty) return true;
      return false;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> signOut() async {
    print('AuthenticationRepository -> signOut()');
    await _ss.deleteAll();
    _controller.add(_user = AppConst.emptyUser);
  }

// Attention!
  @override
  Future<void> tryToAuthenticate() async {
    List<String>? emailAndPassword = await _checkStoredCredentials();
    if (emailAndPassword == null) {
      print('AuthenticationRepository -> tryToAuthenticate() -> emailAndPassword == null');
      // print(
      //     'StoredCredentials == null -> User(id: 87, name: TestUser, email: test@email, authToken: token)');
      // For tests:
      // _controller.add(_user = AppConst.emptyUser);
      // User testUser = const User(
      //     id: 87, name: 'TestUser', email: 'test@email', authToken: 'token');
      // _controller.add(_user = testUser);
      _controller.add(_user = AppConst.emptyUser);
      return;
    }
    try {
      print('AuthenticationRepository -> tryToAuthenticate()');
      Map<String, dynamic> jsonUser = await _selectUserFromDatabase(
          emailAndPassword[0], emailAndPassword[1]);

      if (jsonUser.isEmpty) return _controller.add(_user = AppConst.emptyUser);

      _controller.add(_user = User.fromJson(jsonUser));
    } catch (e) {
      print('tryToAuthenticate Exception: \n----------\n$e');
      _controller.add(_user = AppConst.emptyUser);
      // not authenticated!
    }
  }

  Future<List<String>?> _checkStoredCredentials() async {
    print('AuthenticationRepository -> _checkStoredCredentials()');
    try {
      String? email = await _ss.getEmail();
      String? pwd = await _ss.getPassword();
      bool hasCredentials =
          (email != null && pwd != null && email.isNotEmpty && pwd.isNotEmpty);

      if (!hasCredentials) return null;
      print('AuthenticationRepository -> _checkStoredCredentials()[email, pwd] = [$email, $pwd]');
      return [email, pwd];
    } catch (e) {
      print('check stored credentials Exception: \n----------\n$e');
      return null;
    }
  }

  /// If there is no matching user may return an empty Map.
  /// selectUserFromDatabase(String email, String pwd)
  Future<Map<String, dynamic>> _selectUserFromDatabase(
      String email, String pwd) async {
    try {
      List<Map<String, dynamic>> res = await _localDB.select(
        where: ['email', 'password'],
        values: [email, pwd],
      ) as List<Map<String, dynamic>>;
      print('AuthenticationRepository-> _selectUserFromDatabase user id: ${res[0]['id']}');
      return res[0];
    } catch (e) {
      print('AuthenticationRepository-> _selectUserFromDatabase Exception: \n----------\n$e');
      return {};
    }
  }

  @override
  Stream<User> get user async* {
    yield _user;
    yield* _controller.stream;
  }

  @override
  Future<int> permanentlyRemoveCurrentUser() async {

    try {
      int res = await _localDB.deleteUser(_user.id);
      await _ss.deleteAll();
      _controller.add(_user = AppConst.emptyUser);
      return res;
    } catch (e) {
      print(
          'AuthenticationRepository-> permanentlyRemoveCurrentUser(id: ${_user.id}) Exception: \n----------\n$e');
      return 0;
    }

  }

  @override
  void dispose() => _controller.close();
}
