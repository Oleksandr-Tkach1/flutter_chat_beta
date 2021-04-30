import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = FlutterSecureStorage ();

  Future writeSecureData(String key, String value)  async {
    var writeData = await _storage.write(key: key, value: value);
    return writeData;
  }
}