import 'dart:io';

import 'package:dio/dio.dart';
import 'package:iroyal/base/initialization/notification_services.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/permission/app_permission.dart';
// import 'package:open_file/open_file.dart';
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
      // final directory = await getDownloadsDirectory();
      const filePath = '/storage/emulated/0/Download/downloaded_file.pdf';

      AppUtils.logApp(filePath);

      Response response = await dio.get(
        url,
        onReceiveProgress: (received, total) async {
          NotificationService notificationService = NotificationService();

          if (total != -1) {
            AppUtils.logApp('${(received / total * 100).toStringAsFixed(0)}%');
          }
          await Future.delayed(const Duration(seconds: 1), () {
            notificationService.createNotification(
                100, ((received / total) * 100).toInt(), 0);
          });
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
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
      return true;
    } catch (e) {
      AppUtils.logApp(e.toString());
      rethrow;
    }
  }
}
