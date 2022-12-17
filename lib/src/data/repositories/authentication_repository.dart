import 'dart:async';

import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_authentication_repository.dart';
import 'package:davar/src/domain/i_user_local_db.dart';
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

  /// Returns logged in user id or 0. Null on error!
  Future<int?> loginWithEmailAndPassword({required String email, required String password}) async {
    try {
      Map<String, dynamic> searchResult = await _selectUserFromDatabase(email, password);
      if (searchResult.isEmpty) {
        // this check allows to show login error info during logging in process
        if (_user != AppConst.emptyUser && _user != AppConst.unknownUser) {
          _controller.add(_user = AppConst.emptyUser);
        }
        return 0;
      }
      User foundUser = User.fromJson(searchResult);
      await _ss.persistEmail(email);
      await _ss.persistPassword(password);
      _controller.add(_user = foundUser);
      return foundUser.id;
    } catch (e) {
      return null;
    }
  }

  @override

  /// Returns created user id or 0. If email is taken returns -1. null on error!
  Future<int?> register(User user) async {
    try {
      if (await _isEmailTaken(user.email)) {
        return -1;
      }
      Map<String, dynamic> userAsJson = user.toJson();
      //id is auto increment by DB, createdAt is set by DB
      userAsJson.remove('id');
      userAsJson.remove('createdAt');
      final int id = await _localDB.createUser(userAsJson);

      if (id < 1) {
        // not created
        _controller.add(_user = AppConst.emptyUser);
        return null;
      }
      Map<String, dynamic>? lastInserted = await _selectUserFromDatabase(user.email, user.password);
      if (lastInserted.isEmpty) return 0;
      final User registered = User.fromJson(lastInserted);
      await _ss.persistEmail(user.email);
      await _ss.persistPassword(user.password);
      _controller.add(_user = registered);
      return registered.id;
    } catch (e) {
      return null;
    }
  }

  /// Checks if user with given email already exists in database. Returns false if not taken.
  Future<bool> _isEmailTaken(String email) async {
    try {
      final List<dynamic> res = await _localDB.selectUser(where: ['email'], values: [email]);
      if (res.isNotEmpty) return true;
      return false;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _ss.deleteAll();
    } catch (e) {
      throw Exception('Error when signing out!');
    }
    // important
    //if _user=AppConst.emptyUser then there is no loggedOut view shown, but onboarding screen!
    _controller.add(_user = AppConst.unknownUser);
  }

  @override

  /// Emits user or emptyUser/unknownUser. On error throws Exception!
  Future<void> tryToAuthenticate() async {
    try {
      final List<String>? emailAndPassword = await _checkStoredCredentials();
      if (emailAndPassword == null || emailAndPassword.isEmpty) {
        return _controller.add(_user = AppConst.emptyUser);
      }
      final Map<String, dynamic> searchResult =
          await _selectUserFromDatabase(emailAndPassword[0], emailAndPassword[1]);
      if (searchResult.isEmpty) {
        return _controller.add(_user = AppConst.emptyUser);
      }
      _controller.add(_user = User.fromJson(searchResult));
    } catch (e) {
      throw Exception('Error during authentication!');
    }
  }

  /// returns Array with email, pwd or empty. Null on error
  Future<List<String>?> _checkStoredCredentials() async {
    try {
      final String? email = await _ss.getEmail();
      final String? pwd = await _ss.getPassword();
      if (email == null || pwd == null || email.isEmpty || pwd.isEmpty) return [];
      return [email, pwd];
    } catch (e) {
      return null;
    }
  }

  /// If there is no matching user returns an empty Map. On error throws Exception!
  /// selectUserFromDatabase(String email, String password)
  Future<Map<String, dynamic>> _selectUserFromDatabase(String email, String pwd) async {
    try {
      List<Map<String, dynamic>?> res = await _localDB.selectUser(
        where: ['email', 'password'],
        values: [email, pwd],
      ) as List<Map<String, dynamic>>;
      if (res.isEmpty || res[0] == null || res[0]!.isEmpty) return {};
      final Map<String, dynamic> firstFound = res.first!;
      if (res.first!.isEmpty) return {};
      return firstFound;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User?> findUserByEmail(String email) async {
    try {
      final List<Map<String, dynamic>?> res = await _localDB
          .selectUser(where: ['email'], values: [email]) as List<Map<String, dynamic>?>;
      if (res.isEmpty) return null;
      if (res.first == null || res.first!.isEmpty) return null;
      final Map<String, dynamic> found = res.first!;
      return User.fromJson(found);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> updateUser(User user) async {
    try {
      final List<dynamic> u = await _localDB.selectUser(where: ['id'], values: [user.id]);
      if (u.isEmpty || u[0] == null) return 0;
      final int res = await _localDB.updateUser(user.toJson(), user.id);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<User> get user async* {
    yield _user;
    yield* _controller.stream;
  }

  @override
  void dispose() => _controller.close();
}
