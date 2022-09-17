abstract class ISecureStorage {

  Future<void> persistEmail(String email);
  Future<void> persistPassword(String pwd);
  Future<void> persistToken(String token);

  Future<String?> getEmail();
  Future<String?> getPassword();
  Future<String?> getToken();

  Future<void> deletePassword();
  Future<void> deleteEmail();
  Future<void> deleteAll();
  Future<void> deleteToken();


}

// Future<bool> hasToken();
/*Future<bool> hasToken() async {
    String? value = await _storage.read(key: _tokenKey);
    return value != null;
  }*/