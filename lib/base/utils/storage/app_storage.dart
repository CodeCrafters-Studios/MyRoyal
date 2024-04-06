import 'package:flutter_api0v2_storage/flutter_api0v2_storage.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum StorageType { hive, api0 }

class AppStorage extends GetxService {
  AppStorage({required this.box, required this.api0});

  final Box box;
  final FlutterApi0v2Storage api0;

  Future<void> write(
    String key,
    String value, {
    StorageType type = StorageType.hive,
  }) async {
    switch (type) {
      case StorageType.hive:
        await box.put(key, value);
        break;
      case StorageType.api0:
        await api0.secureStorageWrite(
          key: key,
          value: value,
        );
        break;
    }
  }

  Future<String?> read(
    String key, {
    StorageType type = StorageType.hive,
  }) async {
    switch (type) {
      case StorageType.hive:
        return box.get(key);
      case StorageType.api0:
        return api0.secureStorageRead(
          key: key,
        );
    }
  }

  Future<void> delete(
    String key, {
    StorageType type = StorageType.hive,
  }) async {
    switch (type) {
      case StorageType.hive:
        await box.delete(key);
        break;
      case StorageType.api0:
        await api0.secureStorageDelete(
          key: key,
        );
        break;
    }
  }

  Future<bool> isContain(
    String key, {
    StorageType type = StorageType.hive,
  }) async {
    switch (type) {
      case StorageType.hive:
        return box.containsKey(key);
      case StorageType.api0:
        return api0.secureStorageContainsKey(
          key: key,
        );
    }
  }
}
