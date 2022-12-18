import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_authentication_repository.dart';
import 'package:flutter/material.dart';

enum LoginStatus { submitting, error, success }

class LoginProvider with ChangeNotifier {
  final IAuthenticationRepository<User> _authRepository =
      locator<IAuthenticationRepository<User>>();

  LoginStatus _status = LoginStatus.success;
  String _errorMsg = '';

  String _email = '';
  String _password = '';

  LoginStatus get status => _status;

  String get loginError => _errorMsg;

  String get email => _email;

  String get password => _password;

  void confirmReadErrorMsg() {
    if(_errorMsg.isNotEmpty) {
      _errorMsg = '';
      notifyListeners();
    }
  }

  void onSubmit() async {
    _status = LoginStatus.submitting;
    _errorMsg = '';
    notifyListeners();
    try {
      final int? id =
          await _authRepository.loginWithEmailAndPassword(email: _email, password: _password);
      // unknown user id=-1,  empty user id=1
      if (id == null || id <= 1) {
        _errorMsg = 'Email or password is incorrect.\nPlease try again';
      }
      _status = LoginStatus.success;
      notifyListeners();
    } catch (e) {
      _errorMsg = 'Sorry! Something went wrong.';
      _status = LoginStatus.error;
      notifyListeners();
    }
  }

  void onEmailChange(String email) {
    if (_email != email) {
      _email = email;
    }
  }

  void onPasswordChange(String password) {
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
        _errorMsg = 'User with this email do not exists.';
      }
      _status = LoginStatus.success;
      notifyListeners();
      return user;
    } catch (e) {
      _errorMsg = 'Nothing found, please register new user';
      _status = LoginStatus.success;
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
      _status = LoginStatus.success;
      notifyListeners();
      return false;
    }
    return true;
  }
}
