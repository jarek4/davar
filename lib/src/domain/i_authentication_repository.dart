import 'dart:async';

// emptyUser=(email: 'empty', id: 1, password: '', authToken: null);
// unknownUser=(createdAt: '-11111:-11:-11', email: 'unknown', id: -1, name: 'unknown');
// emptyUser if unauthenticated, unknownUser if status unknown (starting app, logged out)

abstract class IAuthenticationRepository<T> {
  ///Stream<User> get user.
  ///[User(email: 'empty', id: -1, name: 'empty', password: '', authToken: null)] if the user is not authenticated.
  Stream<T> get user;

  /// Returns logged in user id or 0. Returns null on error.
  Future<int?> loginWithEmailAndPassword(
      {required String email, required String password});

  /// Returns created user id or 0. If email is taken returns -1. Returns null on error!
  Future<int?> register(T user);


  /// Throws Exception!
  Future<void> signOut();

  /// authenticate user with credentials stored in application. Throws Exception!
  Future<void> tryToAuthenticate();

  void dispose();
}
