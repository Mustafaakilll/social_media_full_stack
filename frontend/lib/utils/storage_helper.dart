import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _StorageHelper {
  Object getData(key);
  void writeData(key, value);
}

class StorageHelper extends _StorageHelper {
  factory StorageHelper() => _instance;

  StorageHelper._init();

  static final StorageHelper _instance = StorageHelper._init();

  static const _storage = FlutterSecureStorage();

  @override
  Future<void> writeData(key, value) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> getData(key) async {
    return await _storage.read(key: key);
  }

  Future<void> removeItem(String key) async {
    return await _storage.delete(key: key);
  }
}
