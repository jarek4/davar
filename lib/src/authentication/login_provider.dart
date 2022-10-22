import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_authentication_repository.dart';
import 'package:flutter/material.dart';

enum LoginStatus {submitting, error, success }

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
    print('login submit with @: $_email, pwr: $_password');
    _status = LoginStatus.submitting;
    _errorMsg = '';
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1), () {
      print('delay 1 sec');
    });
    try {
      final int? id = await _authRepository.loginWithEmailAndPassword(email: _email, password: _password);
      print('LoginProvider onSubmit id=$id');
      if(id == null) {
        _errorMsg = 'Email or password is incorrect.\nPlease try again';
        _status = LoginStatus.success; // error
        notifyListeners();
      }
      if(id != null && id > 0) {
        _errorMsg = '';
        _status = LoginStatus.success;
        notifyListeners();
      }
      print('LoginProvider onSubmit LoginStatus=$_status');
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
    print('PROVIDER @ chcnage: $email');
    if(_email != email) {
      _email = email;
    }
  }
  void onPasswordChange(String password) {
    print('PROVIDER PWD chcnage: $password');
   if(_password != password) {
      _password = password;
    }
  }

  void onForgotPassword() {
    final int emailCharacters = _email.characters.length;
    // final String invalid = '$';
    final String errorMsg = emailCharacters < 6 ? 'invalid email' : 'Sorry! under development.';
    print('onForgot password');
    _errorMsg = errorMsg;
    _status = LoginStatus.success; // error
    notifyListeners();
  }
  void onTryLoginAgain() {
    print('onTryLoginAgain');
    _errorMsg = '';
    _email = '';
    _password = '';
    _status = LoginStatus.success;
    notifyListeners();
  }
}
