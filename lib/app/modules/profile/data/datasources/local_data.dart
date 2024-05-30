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
    await appPermission.requestStorage();
    final status = await appPermission.storageStatus;
    AppUtils.logApp('PERMISSION STORAGE ::::$status');
    if (!status) {
      return false;
    }

    try {
      final directory = await getDownloadsDirectory();
      if (directory == null) {
        AppUtils.logApp('ERROR: External storage directory is null');
        return false;
      }
      final filePath = '${directory.path}/downloaded_file.pdf';

      AppUtils.logApp(filePath);

      NotificationService notificationService = NotificationService();
      Response response = await dio.get(
        url,
        onReceiveProgress: (received, total) async {
          if (total != -1) {
            AppUtils.logApp('${(received / total * 100).toStringAsFixed(0)}%');
            notificationService.updateProgressNotification(
              100,
              ((received / total * 100).toInt()),
              0,
              filePath,
            );
          }
        },
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      File file = File(filePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return true;
    } catch (e) {
      AppUtils.logApp('ERROR HERE :::: $e');
      rethrow;
    }
  }
}
