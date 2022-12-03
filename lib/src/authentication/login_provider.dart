import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_authentication_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum LoginStatus { submitting, error, success }

class LoginProvider with ChangeNotifier {
  final IAuthenticationRepository<User> _authRepository =
      locator<IAuthenticationRepository<User>>();

  LoginStatus _status = LoginStatus.success;
  String _errorMsg = '';

  set loginErrorMsg(String value) {
    _errorMsg = value;
    notifyListeners();
  }

  String _email = '';
  String _password = '';

  LoginStatus get status => _status;

  String get loginError => _errorMsg;

  String get email => _email;

  String get password => _password;

  void onSubmit() async {
    if (kDebugMode) print('login submit with @: $_email, pwr: $_password');
    _status = LoginStatus.submitting;
    _errorMsg = '';
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1), () {
      if (kDebugMode) print('delay 1 sec');
    });
    try {
      final int? id =
          await _authRepository.loginWithEmailAndPassword(email: _email, password: _password);
      if (id == 0) {
        _errorMsg = 'Email or password is incorrect.\nPlease try again';
        _status = LoginStatus.success; // error
        notifyListeners();
      } else if (id != null && id > 0) {
        _errorMsg = '';
        _status = LoginStatus.success;
        notifyListeners();
      }
      if (id == null) {
        _errorMsg = 'Email or password is incorrect.\nPlease try again';
        _status = LoginStatus.success; // error
        notifyListeners();
      }

      if (kDebugMode) print('LoginProvider onSubmit LoginStatus=$_status');
      //  _status = LoginStatus.success;
      //  notifyListeners();
    } catch (e) {
      String err = e.toString();
      String msg = 'Sorry! Something is wrong.\n$err';
      _errorMsg = msg;
      _status = LoginStatus.error;
      notifyListeners();
    }
  }

  void onEmailChange(String email) {
    if (kDebugMode) print('PROVIDER @ change: $email');
    if (_email != email) {
      _email = email;
    }
  }

  void onPasswordChange(String password) {
    if (kDebugMode) print('PROVIDER PWD change: $password');
    if (_password != password) {
      _password = password;
    }
  }

  // to reset password user has to provide proper email,
  // then will have to provide: username and language that he is learning.
  Future<User?> onForgotPassword() async {
    // if user entered email try to found user in database by email
    // if no user found show information
    // if found open password change form
    if (!_validateEmail()) return null;
    _status = LoginStatus.submitting;
    _errorMsg = '';
    notifyListeners();
    try {
      User? user = await _authRepository.findUserByEmail(_email);
      // unknown user id=-1,  empty user id=1
      if (user == null || user.id <= 1) {
        _errorMsg = 'User with this email do not exists. Sorry! 2';
      }
      _status = LoginStatus.success; // error
      notifyListeners();
      return user;
    } catch (e) {
      if (kDebugMode) print(e);
      _errorMsg = 'Nothing found, please register new user';
      _status = LoginStatus.success; // error
      notifyListeners();
      return null;
    }
  }

  bool _validateEmail() {
    if (_email.isEmpty) {
      _errorMsg = 'Email cannot be empty';
      _status = LoginStatus.success;
      notifyListeners();
      return false;
    }
    final int emailCharacters = _email.characters.length;
    if (emailCharacters < 6 || !email.contains('@') || !email.contains('.')) {
      _errorMsg = 'invalid email';
      _status = LoginStatus.success; // error
      notifyListeners();
      return false;
    }
    return true;
  }
}
