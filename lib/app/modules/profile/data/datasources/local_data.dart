import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:iroyal/app/modules/profile/data/models/download_params_model.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/permission/app_permission.dart';
import 'package:path_provider/path_provider.dart';

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
    final status = await appPermission.requestStorage();
    if (!status) {
      AppUtils.logApp('Storage permission denied');
      return false;
    }
    return true;
  }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      const storagePath = '/storage/emulated/0/Download';
      final directory = await Directory(storagePath).create();
      return directory;
    } else {
      return await getDownloadsDirectory();
    }
  }

  @override
  Future<DownloadParamsModel> downloadFile(
      {required String url, required String fileName}) async {
    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) {
      throw Exception('Storage permission denied');
    }

    try {
      final directory = await _getDownloadDirectory();
      if (directory == null) {
        AppUtils.logApp('ERROR: External storage directory is null');
        throw Exception('Download directory not available');
      }

      final filePath = directory.path;
      AppUtils.logApp(filePath);

      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: filePath,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );

      AppUtils.logApp('Download started with task ID: $taskId');

      return DownloadParamsModel(url: url, fileName: fileName);
    } catch (e) {
      AppUtils.logApp('ERROR HERE :::: $e');
      rethrow;
    }
  }
}
