import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:MyRoyal/app/modules/profile/data/models/download_params_model.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/utils/permission/app_permission.dart';
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
    if (Platform.isAndroid && await Permission.storage.isGranted) {
      if (Platform.version.compareTo('30') >= 0) {
        return true;
      } else {
        final result = await Permission.storage.request();
        return result == PermissionStatus.granted;
      }
    }
    return true;
  }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await getExternalStorageDirectory();
    } else {
      return await getDownloadsDirectory();
    }
  }

  Future<String> _getUniqueFilePath(
      String directoryPath, String fileName) async {
    var filePath = path.join(directoryPath, fileName);
    var file = File(filePath);
    int counter = 1;

    while (await file.exists()) {
      final newFileName =
          '${path.basenameWithoutExtension(fileName)}($counter)${path.extension(fileName)}';
      filePath = path.join(directoryPath, newFileName);
      file = File(filePath);
      counter++;
    }
    return filePath;
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

      final uniqueFilePath = await _getUniqueFilePath(directory.path, fileName);

      await FlutterDownloader.enqueue(
        url: url,
        savedDir: directory.path,
        fileName: path.basename(uniqueFilePath),
        showNotification: true,
        openFileFromNotification: true,
        saveInPublicStorage: true,
      );

      return DownloadParamsModel(url: url, fileName: fileName);
    } catch (e) {
      AppUtils.logApp('ERROR HERE :::: $e');
      rethrow;
    }
  }
}
