abstract class IUserLocalDb<T> {

  /// returns created user id, or -1 if email is taken, 0 if conflict
  Future<int> createUser(T newUser);

  /// returns List of records as List<Map<String, dynamic>>
  Future<List<T?>> selectUser({required List<String> where, required List<dynamic> values});

  Future<int> rawUpdateUser({
    required List<String> columns,
    required List<dynamic> values,
    required int id,
  });

  /// Returns the number of changes made
  Future<int> updateUser(T u, int userId);

  Future<int> deleteUser(int userId);
}
