import 'dart:async';

// default or empty User is returned when there is NO User:
// empty-User(email: 'empty', id: -1, authToken: null)

abstract class IAuthenticationRepository<T> {
  ///Stream<User> get user.
  ///[User(email: 'empty', id: -1, name: 'empty', password: '', authToken: null)] if the user is not authenticated.
  Stream<T> get user;

  Future<void> loginWithEmailAndPassword(
      {required String email, required String password});

  Future<void> register(T user);

  Future<void> signOut();

  /// authenticate user with credentials stored in application.
  /// If unauthenticated returns "empty user"
  Future<void> tryToAuthenticate();
  Future<int> permanentlyRemoveCurrentUser();

  void dispose();
}
