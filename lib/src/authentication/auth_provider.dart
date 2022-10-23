// ignore_for_file: avoid_print

import 'dart:async';

import 'package:davar/locator.dart';
import 'package:davar/src/domain/i_authentication_repository.dart';
import 'package:davar/src/utils/utils.dart';
import 'package:flutter/foundation.dart';

import '../data/models/models.dart';

// default User == emptyUser returned when unauthenticated [AppConst.emptyUser]:
// emptyUser (email: 'empty' , id: 1, name: 'empty', password: '', authToken: null);
// unknownUser=(createdAt: '-11111:-11:-11', email: 'unknown', id: -1, name: 'unknown');

enum AuthenticationStatus {
  authenticated,
  error,
  forgotPassword,
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

  void _onUserChange(User user) {
    final String m = 'AuthProvider _onUserChange [user.id: ${user.id}, user.name: ${user.name}]';
    print(m);
    // if (user == _user) return; // it may case error - stacks at status unknown
    if (user == AppConst.emptyUser) {
      _errorMsg = '';
      _status = AuthenticationStatus.unauthenticated;
      print('1 _onUserChange AuthenticationStatus.unauthenticated _user.id: ${_user.id}');
    } else if (user != AppConst.unknownUser) {
      // else if (user != AppConst.emptyUser && user != AppConst.unknownUser)
      _status = AuthenticationStatus.authenticated;
      _errorMsg = '';
      print('2 _onUserChange AuthenticationStatus.authenticated id: ${_user.id}');
    } else {
      _status = AuthenticationStatus.unknown;
      _errorMsg = '';
      print('3 _onUserChange AuthenticationStatus.unknown id: ${_user.id}');
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

  void onForgotPasswordRequest() {
    _status = AuthenticationStatus.forgotPassword;
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
      /// TODO: delete delay
      await Future.delayed(const Duration(seconds: 1), () {
        print('delay 1 sec');
      });
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

      /// TODO: delete delay
      await Future.delayed(const Duration(seconds: 2), () {
        print('delay 2 sec');
      });
      _status = AuthenticationStatus.loggedOut;
      notifyListeners();
    } catch (e) {
      final String err = e.toString();
      final String msg = 'Sorry! You maybe still logged in.\n$err';
      _errorMsg = msg;
      _status = AuthenticationStatus.error;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _errorMsg = '';
    _authRepositorySubscription.cancel();
  }
}
