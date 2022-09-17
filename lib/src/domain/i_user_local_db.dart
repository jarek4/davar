abstract class IUserLocalDb<T> {

  Future<int> createUser(T newUser);

  /// returns List of records as List<Map<String, dynamic>>
  Future<List<T>> select({required List<String> where, required List<dynamic> values});

  Future<int> rawUpdateUser({
    required List<String> columns,
    required List<dynamic> values,
    required int id,
  });

  // Future<int> update(T user);

  Future<int> deleteUser(int userId);
}

// Future<T> getByEmail(String userEmail);
// Future<String> hasUser(String userEmail, String userPassword);
