// ignore_for_file: avoid_print

import 'dart:async';

import 'package:davar/locator.dart';
import 'package:davar/src/domain/i_authentication_repository.dart';
import 'package:davar/src/utils/utils.dart';
import 'package:flutter/foundation.dart';

import '../data/models/models.dart';

// empty User(email: 'empty' , id: -1, authToken: null);

class AuthProvider with ChangeNotifier {
  AuthProvider() : super() {
    _authRepositorySubscription = _authRepository.user.listen((user) {
      _onUserChange(user);
    });
  }

  User _user = AppConst.emptyUser;
  bool _isLoading = true;

  final IAuthenticationRepository<User> _authRepository =
      locator<IAuthenticationRepository<User>>();
  late StreamSubscription<User> _authRepositorySubscription;

  User get user => _user;
  bool get isLoading => _isLoading;

  bool get isCurrentUserAnEmptyUser => (_user.id == AppConst.emptyUser.id &&
      _user.authToken == AppConst.emptyUser.authToken &&
      _user.email == AppConst.emptyUser.email);

  void _onUserChange(User user) {
    if(user == _user) return;
    _user = user;
    _isLoading = false;
    notifyListeners();
  }
  void register() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2), () {print('delay 2 sec');});
    User u = const User(email: 'test1@test.eu', name: 'Test1', password: 'Aa12345');
    print('AuthProvider register');
    await _authRepository.register(u);
    _isLoading = false;
    notifyListeners();
  }
  void login() async {
    _isLoading = true;
    notifyListeners();
    await _authRepository.signOut();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> tryToAuthenticate() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2), () {print('delay 2 sec');});
    await _authRepository.tryToAuthenticate();
    _isLoading = false;
    notifyListeners();
  }

  void signOut() async {
    _isLoading = true;
    notifyListeners();
    await _authRepository.signOut();
    _isLoading = false;
    notifyListeners();
  }

  void permanentlyRemoveCurrentUser() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2), () {print('delay 2 sec');});
    print('AuthProvider permanentlyRemoveCurrentUser');
    int records = await _authRepository.permanentlyRemoveCurrentUser();
    _isLoading = false;
    notifyListeners();
    print('AuthProvider permanentlyRemoveCurrentUser; deleted records: $records');
  }

  @override
  void dispose() {
    super.dispose();
    _authRepositorySubscription.cancel();
  }
}
