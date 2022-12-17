import 'package:davar/src/authentication/authentication.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:flutter/foundation.dart';

enum ForgotPwdStatus { loading, error, success, passwordChanged, disabled }

class ForgotPwdProvider with ChangeNotifier {
  ForgotPwdProvider(this._authProvider, this._forgotPasswordUser);

  final AuthProvider _authProvider;
  final User _forgotPasswordUser;

  ForgotPwdStatus _status = ForgotPwdStatus.success;
  String _errorMsg = '';

  set error(String value) {
    _errorMsg = value;
    notifyListeners();
  }

  String _username = '';
  String _language = '';
  String _newPassword = '';

  ForgotPwdStatus get status => _status;

  String get error => _errorMsg;

  String get username => _username;

  String get language => _language;

  User get uss => _forgotPasswordUser;

  int _resetAttempts = 3;

  int get resetAttempts => _resetAttempts;

  void incrementResetAttempts() {
    --_resetAttempts;
    if (_resetAttempts < 1) {
      _status = ForgotPwdStatus.disabled;
    }
    notifyListeners();
  }

  void onUserNameChange(String name) {
    if (_username != name) {
      _username = name;
      if (_errorMsg.isNotEmpty) {
        _errorMsg = '';
      }
      notifyListeners();
    }
  }

  void onLanguageChange(String lang) {
    if (_language != lang) {
      _language = lang;
      if (_errorMsg.isNotEmpty) {
        _errorMsg = '';
      }
      notifyListeners();
    }
  }

  void onNewPasswordChange(String pwd) {
    if (_newPassword != pwd) {
      _newPassword = pwd;
      if (_errorMsg.isNotEmpty) {
        _errorMsg = '';
      }
      notifyListeners();
    }
  }

  // to reset password user has to provide proper username and language that he is learning
  bool onResetPasswordRequest() {
    incrementResetAttempts();
    if (_resetAttempts < 1) {
      _errorMsg = 'You can not try any more. Please register user';
      notifyListeners();
      return false;
    }
    _errorMsg = '';
    notifyListeners();
    final bool allowResetPassword = (validateLanguage() && validateUsername());
    if (!allowResetPassword) {
      _errorMsg = 'Sorry, the given data does not match';
      notifyListeners();
    }
    return allowResetPassword;
  }

  bool validateUsername() {
    if (_forgotPasswordUser.name.toLowerCase() == _username.toLowerCase()) return true;
    if (_username.isEmpty) {}
    return false;
  }

  bool validateLanguage() {
    if (_forgotPasswordUser.learning.toLowerCase() == _language.toLowerCase()) return true;
    if (_language.isNotEmpty) {}
    return false;
  }

  Future<bool> changePassword() async {
    if (_resetAttempts < 1) {
      _errorMsg = 'You can not try any more. Please register user';
      notifyListeners();
      return false;
    }
    _errorMsg = '';
    _status = ForgotPwdStatus.loading;
    notifyListeners();
    final User withNewPassword = _forgotPasswordUser.copyWith(password: _newPassword);

    try {
      final res = await _authProvider.updateUser(withNewPassword);
      if (res < 1) {
        _errorMsg = 'Your password has NOT been reset!';
        _status = ForgotPwdStatus.success;
        notifyListeners();
        return false;
      } else {
        _errorMsg = '';
        _status = ForgotPwdStatus.passwordChanged;
        notifyListeners();
      }
      return true;
    } catch (e) {
      if (kDebugMode) print(e);
      _errorMsg = 'Your password has NOT been changed! Error occurred';
      _status = ForgotPwdStatus.error; // error
      notifyListeners();
      return false;
    }
  }

  bool validateNewPassword() {
    if (_newPassword.length > 5) return true;
    _errorMsg = 'Password have to be strong';
    _status = ForgotPwdStatus.success; // error
    notifyListeners();
    return false;
  }

  void redirectToLoginPage() {
    _errorMsg = '';
    _status = ForgotPwdStatus.success;
    _authProvider.onLoginRequest();
    notifyListeners();
  }
}
