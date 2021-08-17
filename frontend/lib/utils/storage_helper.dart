import 'package:hive_flutter/hive_flutter.dart';

abstract class _StorageHelper {
  Future<void> init();
  Future<Object> getData(String key, String boxName);
  Future<void> writeData(String key, Object value, String boxName);
  Future<void> removeItem(String key, String boxName);
}

class StorageHelper extends _StorageHelper {
  factory StorageHelper() => _instance;

  StorageHelper._init();

  static final StorageHelper _instance = StorageHelper._init();

  final _hive = Hive;

  @override
  Future<void> init() async {
    await _hive.initFlutter();
  }

  @override
  Future<Object> getData(String key, String boxName) async {
    final box = await _hive.openBox(boxName);
    final data = box.get(key);
    // await box.close();
    return data;
  }

  @override
  Future<void> writeData(String key, Object value, String boxName) async {
    final box = await _hive.openBox(boxName);
    await box.put(key, value);
    await box.close();
  }

  @override
  Future<void> removeItem(String key, String boxName) async {
    final box = await _hive.openBox(boxName);
    await box.delete(key);
    await box.close();
  }
}
