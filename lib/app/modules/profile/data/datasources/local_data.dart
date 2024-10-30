import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:iroyal/app/modules/profile/data/models/download_params_model.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/permission/app_permission.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

abstract class ProfileLocalDataSources {
  Future<DownloadParamsModel> downloadFile({
    required String url,
    required String fileName,
  });
}

class ProfileLocalDataSourcesImpl extends ProfileLocalDataSources {
  ProfileLocalDataSourcesImpl({required this.appPermission, required this.dio});

  final AppPermission appPermission;
  final Dio dio;

  Future<bool> _requestStoragePermission() async {
    if (await Permission.storage.isGranted) {
      return true;
    }
    final result = await Permission.storage.request();
    return result == PermissionStatus.granted;
  }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await getExternalStorageDirectory();
    } else {
      return await getDownloadsDirectory();
    }
  }

  @override
  Future<DownloadParamsModel> downloadFile({
    required String url,
    required String fileName,
  }) async {
    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) {
      throw Exception('Storage permission denied');
    }

    try {
      final directory = await _getDownloadDirectory();
      if (directory == null) {
        throw Exception('Download directory not available');
      }

      path.join(directory.path, fileName);

      await FlutterDownloader.enqueue(
        url: url,
        savedDir: directory.path,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );

      return DownloadParamsModel(url: url, fileName: fileName);
    } catch (e) {
      AppUtils.logApp('ERROR HERE :::: $e');
      rethrow;
    }
  }
}
