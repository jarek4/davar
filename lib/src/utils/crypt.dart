import 'dart:convert'; // for the utf8.encode method
import 'package:crypto/crypto.dart';

class Crypt {

  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  static String generateSha1(String input) {
    final List<int> bytes = utf8.encode(input); // data being hashed
    return sha1.convert(bytes).toString();

  }
}