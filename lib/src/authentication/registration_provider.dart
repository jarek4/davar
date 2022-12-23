import 'package:davar/locator.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/domain/i_authentication_repository.dart';
import 'package:flutter/foundation.dart';

enum RegistrationStatus { submitting, error, success }

class RegistrationProvider with ChangeNotifier {
  final IAuthenticationRepository<User> _authRepository =
      locator<IAuthenticationRepository<User>>();

  String _email = '';

  String get email => _email;
  String _errorMsg = '';

  void confirmReadErrorMsg() {
    if(_errorMsg.isNotEmpty) {
      _errorMsg = '';
      notifyListeners();
    }
  }

  String _learning = '';
  String _name = '';
  String _native = '';
  String _password = '';
  RegistrationStatus _status = RegistrationStatus.success;

  RegistrationStatus get status => _status;

  String get registrationError => _errorMsg;

  String get name => _name;

  String get learning => _learning;

  String get native => _native;

  String get password => _password;

  void onEmailChange(String email) {
    if (_email != email) {
      _email = email;
    }
  }

  void onLearningChange(String learning) {
    if (_learning != learning) {
      _learning = learning;
      notifyListeners();
    }
  }

  void onNameChange(String name) {
    if (_name != name) {
      _name = name;
      notifyListeners();
    }
  }

  void onNativeChange(String native) {
    if (_native != native) {
      _native = native;
      notifyListeners();
    }
  }

  void onPasswordChange(String password) {
    if (_password != password) {
      _password = password;
      notifyListeners();
    }
  }

  Future<void> onSubmit() async {
    if(!_validateFormFields()) return;
    _status = RegistrationStatus.submitting;
    notifyListeners();
    User submittingUser = const User().copyWith(
        email: _email, name: _name, learning: _learning, native: _native, password: _password);
    try {
      final int? id = await _authRepository.register(submittingUser);
      if (id == -1) {
        // email is taken
        _status = RegistrationStatus.success;
        _errorMsg =
            'Sorry email: ${submittingUser.email} is taken.\n We cant create new user with this email!';
        notifyListeners();
        return;
      }
      if (id == null || id == 0) {
        // after insert to Db, query this new user from Db failed [id == 0]!
        _status = RegistrationStatus.success;
        _errorMsg =
            'Sorry it looks like there was an error!\nNew user [${submittingUser.name}] was not created ☹️';
        notifyListeners();
        return;
      }
      // success - new user created and authenticated
      _errorMsg = '';
      _status = RegistrationStatus.success;
      notifyListeners();
    } catch (e) {
      String err = e.toString();
      String msg = 'Sorry! New user is not created. Please try again.\n$err';
      _errorMsg = msg;
      _status = RegistrationStatus.error;
      notifyListeners();
    }
  }
  bool _validateFormFields() {
    bool areValid = true;
    _errorMsg = '';
    if(_name.isEmpty) {
      areValid = false;
      _errorMsg = 'Username is not valid.';
    }
    if(_email.length < 5) {
      areValid = false;
      _errorMsg = '$_errorMsg Email is not valid.';
    }
    if(_password.length < 4) {
      areValid = false;
      _errorMsg = '$_errorMsg Password is not valid.';
    }
    if(_native.isEmpty) {
      areValid = false;
      _errorMsg = '$_errorMsg Native language is not valid.';
    }
    if(_learning.isEmpty) {
      areValid = false;
      _errorMsg = '$_errorMsg Learning language is not valid.';
    }
    notifyListeners();
    return areValid;
  }
}
