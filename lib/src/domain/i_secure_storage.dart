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
