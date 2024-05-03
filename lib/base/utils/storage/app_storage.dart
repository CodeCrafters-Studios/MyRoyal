import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum StorageType { hive }

class AppStorage extends GetxService {
  AppStorage({required this.box});

  final Box box;

  Future<void> write(
    String key,
    String value, {
    StorageType type = StorageType.hive,
  }) async {
    switch (type) {
      case StorageType.hive:
        await box.put(key, value);
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
    }
  }

  Future<bool> isContain(
    String key, {
    StorageType type = StorageType.hive,
  }) async {
    switch (type) {
      case StorageType.hive:
        return box.containsKey(key);
    }
  }
}
