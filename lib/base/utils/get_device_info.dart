import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfo extends GetxService {
  DeviceInfo({
    required this.deviceInfoPlugin,
    required this.packageInfo,
  });

  final DeviceInfoPlugin deviceInfoPlugin;
  final PackageInfo packageInfo;

  Future<DeviceInfoModel> info() async {
    if (Platform.isAndroid) {
      final dInfo = await deviceInfoPlugin.androidInfo;
      return DeviceInfoModel(
        board: dInfo.board,
        brand: dInfo.brand,
        device: dInfo.device,
        hardware: dInfo.hardware,
        host: dInfo.host,
        id: dInfo.id,
        manufacturer: dInfo.manufacturer,
        model: dInfo.model,
        osVersion: dInfo.version.release,
        appVersion: packageInfo.version,
        buildNumber: packageInfo.buildNumber,
        os: 'Android',
      );
    } else {
      final dInfo = await deviceInfoPlugin.iosInfo;
      return DeviceInfoModel(
        board: dInfo.utsname.nodename,
        brand: 'Apple',
        device: dInfo.utsname.release,
        hardware: dInfo.utsname.machine,
        host: dInfo.utsname.sysname,
        id: dInfo.utsname.machine,
        manufacturer: 'Apple',
        model: dInfo.model,
        osVersion: dInfo.utsname.release,
        appVersion: packageInfo.version,
        buildNumber: packageInfo.buildNumber,
        os: 'iOS',
      );
    }
  }
}

class DeviceInfoModel {
  String board;
  String brand;
  String device;
  String hardware;
  String host;
  String id;
  String manufacturer;
  String model;
  String osVersion;
  String appVersion;
  String buildNumber;
  String os;
  DeviceInfoModel({
    required this.board,
    required this.brand,
    required this.device,
    required this.hardware,
    required this.host,
    required this.id,
    required this.manufacturer,
    required this.model,
    required this.osVersion,
    required this.appVersion,
    required this.buildNumber,
    required this.os,
  });
}
