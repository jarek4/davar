import 'dart:async';

import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_authentication_repository.dart';
import 'package:davar/src/utils/utils.dart';
import 'package:flutter/foundation.dart';

// default User == emptyUser returned when unauthenticated [AppConst.emptyUser]:
// emptyUser (email: 'empty' , id: 1, name: 'empty', password: '', authToken: null);
// unknownUser=(createdAt: '-11111:-11:-11', email: 'unknown', id: -1, name: 'unknown');

enum AuthenticationStatus {
  authenticated,
  error,
  loggedOut,
  login,
  register,
  unauthenticated,
  unknown
}

class AuthProvider with ChangeNotifier {
  AuthProvider() : super() {
    _authRepositorySubscription = _authRepository.user.listen((user) => _onUserChange(user));
  }

  AuthenticationStatus _status = AuthenticationStatus.unknown;
  User _user = AppConst.emptyUser; // User _user = AppConst.unknownUser;
  String _errorMsg = '';

  final IAuthenticationRepository<User> _authRepository =
      locator<IAuthenticationRepository<User>>();
  late StreamSubscription<User> _authRepositorySubscription;

  AuthenticationStatus get status => _status;

  User get user => _user;

  String get authenticationError => _errorMsg;

  // User? _forgotPasswordUserFound;

  void _onUserChange(User user) {
    // if (user == _user) return; // it may case error - stacks at status unknown
    if (user == AppConst.emptyUser) {
      _errorMsg = '';
      _status = AuthenticationStatus.unauthenticated;
    } else if (user != AppConst.unknownUser) {
      // else if (user != AppConst.emptyUser && user != AppConst.unknownUser)
      _status = AuthenticationStatus.authenticated;
      _errorMsg = '';
    } else {
      _status = AuthenticationStatus.unknown;
      _errorMsg = '';
    }
    _user = user;
    notifyListeners();
  }

  void onLoginRequest() {
    _status = AuthenticationStatus.login;
    notifyListeners();
  }

  void onRegisterRequest() {
    _status = AuthenticationStatus.register;
    notifyListeners();
  }

  void onCancelAuthenticationRequest() {
    _status = AuthenticationStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> tryToAuthenticate() async {
    if (_status == AuthenticationStatus.authenticated) return;
    _errorMsg = '';
    _status = AuthenticationStatus.unknown;
    notifyListeners();
    try {
      await _authRepository.tryToAuthenticate();
    } catch (e) {
      String err = e.toString();
      List<String> removerExceptionTitle = err.split('Exception:');
      removerExceptionTitle.removeAt(0);
      String msg = '${removerExceptionTitle.join(',')}\nGo back and try again';
      _errorMsg = msg;
      _status = AuthenticationStatus.error;
      notifyListeners();
    }
  }

  void signOut() async {
    _errorMsg = '';
    _status = AuthenticationStatus.unknown;
    notifyListeners();
    try {
      await _authRepository.signOut();
      // _authRepository.signOut() don't emit stream with auth status!
      _status = AuthenticationStatus.loggedOut;
      notifyListeners();
    } catch (e) {
      final String err = e.toString();
      final String msg = 'Perhaps you are still logged in.\n$err';
      _errorMsg = msg;
      _status = AuthenticationStatus.error;
      notifyListeners();
    }
  }

  Future<int> updateUser(User u) async {
    if (_errorMsg.isNotEmpty) {
      _errorMsg = '';
      notifyListeners();
    }
    try {
      final int res = await _authRepository.updateUser(u);
      return res;
    } catch (e) {
      final String err = e.toString();
      final String msg = 'User data was not updated.\n$err';
      _errorMsg = msg;
      _status = AuthenticationStatus.error;
      notifyListeners();
      return 0;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _errorMsg = '';
    _user = AppConst.emptyUser;
    _authRepositorySubscription.cancel();
  }
}
