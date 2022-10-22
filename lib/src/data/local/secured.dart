import 'package:davar/src/domain/i_secure_storage.dart';
import 'package:davar/src/errors_reporter/errors_reporter.dart';
import 'package:flutter/services.dart';
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
    try {
      return await _storage.deleteAll();
    } on PlatformException catch (err, stackTrace) {
      await ErrorsReporter.genericThrow(
        err.toString(),
        PlatformException(code: err.code),
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
        e.toString(),
        Exception('Secured deleteAll'),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> deleteEmail() async {
    try {
      return await _storage.delete(key: _emailKey);
    } on PlatformException catch (err, stackTrace) {
      await ErrorsReporter.genericThrow(
        err.toString(),
        PlatformException(code: err.code),
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
        e.toString(),
        Exception('Secured deleteEmail'),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> deletePassword() async {
    try {
      return await _storage.delete(key: _pwdKey);
    } on PlatformException catch (err, stackTrace) {
      await ErrorsReporter.genericThrow(
        err.toString(),
        PlatformException(code: err.code),
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
        e.toString(),
        Exception('Secured deletePassword'),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<String?> getEmail() async {
    try {
      String? value = await _storage.read(key: _emailKey);
      return value?.toString();
    } on PlatformException catch (err, stackTrace) {
      await ErrorsReporter.genericThrow(
        err.toString(),
        PlatformException(code: err.code),
        stackTrace: stackTrace,
      );
      return null;
    } catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
        e.toString(),
        Exception('Secured getEmail'),
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  @override
  Future<String?> getPassword() async {
    try {
      String? value = await _storage.read(key: _pwdKey);
      return value?.toString();
    } on PlatformException catch (err, stackTrace) {
      await ErrorsReporter.genericThrow(
        err.toString(),
        PlatformException(code: err.code),
        stackTrace: stackTrace,
      );
      return null;
    } catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
        e.toString(),
        Exception('Secured getPassword'),
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  @override
  Future<void> persistEmail(String email) async {
    try {
      await _storage.write(key: _emailKey, value: email);
    } on PlatformException catch (err, stackTrace) {
      await ErrorsReporter.genericThrow(
        err.toString(),
        PlatformException(code: err.code),
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
        e.toString(),
        Exception('Secured persistEmail'),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> persistPassword(String pwd) async {
    try {
      await _storage.write(key: _pwdKey, value: pwd);
    } on PlatformException catch (err, stackTrace) {
      await ErrorsReporter.genericThrow(
        err.toString(),
        PlatformException(code: err.code),
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
        e.toString(),
        Exception('Secured persistPassword'),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      return await _storage.delete(key: _tokenKey);
    } on PlatformException catch (err, stackTrace) {
      await ErrorsReporter.genericThrow(
        err.toString(),
        PlatformException(code: err.code),
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
        e.toString(),
        Exception('Secured deleteToken'),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      String? value = await _storage.read(key: _tokenKey);
      return value?.toString();
    } on PlatformException catch (err, stackTrace) {
      await ErrorsReporter.genericThrow(
        err.toString(),
        PlatformException(code: err.code),
        stackTrace: stackTrace,
      );
      return null;
    } catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
        e.toString(),
        Exception('Secured getToken'),
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  @override
  Future<void> persistToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
    } on PlatformException catch (err, stackTrace) {
      await ErrorsReporter.genericThrow(
        err.toString(),
        PlatformException(code: err.code),
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      await ErrorsReporter.genericThrow(
        e.toString(),
        Exception('Secured persistToken'),
        stackTrace: stackTrace,
      );
    }
  }
}
