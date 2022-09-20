import 'package:davar/src/domain/i_secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Secured implements ISecureStorage {
  static Secured? _instance;

  factory Secured() => _instance ??= Secured._(const FlutterSecureStorage());

  Secured._(this._storage);

  final FlutterSecureStorage _storage;
  static const _tokenKey = 'TOKEN';
  static const _emailKey = 'EMAIL';
  static const _pwdKey = 'PASSWORD';

  @override
  Future<void> deleteAll() async {
    return await _storage.deleteAll();
  }

  @override
  Future<void> deleteEmail() async {
    return await _storage.delete(key: _emailKey);
  }

  @override
  Future<void> deletePassword() async {
    return await _storage.delete(key: _pwdKey);
  }

  @override
  Future<String?> getEmail() async {
    String? value = await _storage.read(key: _emailKey);
    return value?.toString();
  }

  @override
  Future<String?> getPassword() async {
    String? value = await _storage.read(key: _pwdKey);
    return value?.toString();
  }

  @override
  Future<void> persistEmail(String email) async {
    await _storage.write(key: _emailKey, value: email);
  }

  @override
  Future<void> persistPassword(String pwd) async {
    await _storage.write(key: _pwdKey, value: pwd);
  }

  @override
  Future<void> deleteToken() async {
    return await _storage.delete(key: _tokenKey);
  }

  @override
  Future<String?> getToken() async {
    String? value = await _storage.read(key: _tokenKey);
    return value?.toString();
  }

  @override
  Future<void> persistToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }
}
