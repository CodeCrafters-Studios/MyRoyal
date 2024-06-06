import 'dart:io';

import 'package:dio/dio.dart';
import 'package:iroyal/base/initialization/notification_services.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/permission/app_permission.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
          double progress = (received / total * 100);
          if (total != -1) {
            AppUtils.logApp('${(received / total * 100).toStringAsFixed(0)}%');
            AppUtils.logApp('${progress.toStringAsFixed(0)}%');
            if (total != -1) {
              notificationService.updateProgressNotification(
                100,
                ((received / total * 100).toInt()),
                (progress.toInt()),
                filePath,
              );
            }
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

  // Future<Directory?> _getDownloadDirectory() async {
  //   if (Platform.isAndroid) {
  //     return Directory('/storage/emulated/0/Download');
  //   } else {
  //     return await getDownloadsDirectory();
  //   }
  // }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        return Directory('/storage/emulated/0/Download');
      }
      return await getExternalStorageDirectory();
    } else {
      return await getDownloadsDirectory();
    }
  }
}
