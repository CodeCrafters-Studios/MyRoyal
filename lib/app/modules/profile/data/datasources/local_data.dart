import 'dart:io';

import 'package:dio/dio.dart';
import 'package:iroyal/base/initialization/notification_services.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/permission/app_permission.dart';
import 'package:path_provider/path_provider.dart';

abstract class ProfileLocalDataSources {
  Future<bool> downloadFile(String url);
}

class ProfileLocalDataSourcesImpl extends ProfileLocalDataSources {
  ProfileLocalDataSourcesImpl({required this.appPermission, required this.dio});

  final AppPermission appPermission;
  final Dio dio;

  @override
  Future<bool> downloadFile(String url) async {
    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) return false;

    try {
      final directory = await _getDownloadDirectory();
      if (directory == null) {
        AppUtils.logApp('ERROR: External storage directory is null');
        return false;
      }

      final filePath = '${directory.path}/downloaded_file.pdf';
      AppUtils.logApp(filePath);

      NotificationService notificationService = NotificationService();
      final response = await dio.get(
        url,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toInt();
            AppUtils.logApp('$progress%');
            notificationService.updateProgressNotification(
              100,
              progress,
              0,
              filePath,
            );
          }
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );

      final file = File(filePath);
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return true;
    } catch (e) {
      AppUtils.logApp('ERROR HERE :::: $e');
      rethrow;
    }
  }

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
}
