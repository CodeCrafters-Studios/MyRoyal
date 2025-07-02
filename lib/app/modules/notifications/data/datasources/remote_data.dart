import 'package:iroyal/app/modules/notifications/data/models/notification_model.dart';
import 'package:iroyal/app/modules/notifications/data/models/tap_notification_model.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class NotificationsDataSources {
  Future<NotificationModel> getNotifications(params);
  Future<TapNotificationModel> tapNotification(params);
}

class NotificationsRemoteDataSourcesImpl implements NotificationsDataSources {
  NotificationsRemoteDataSourcesImpl({required this.httpService});

  final HttpService httpService;

  @override
  Future<NotificationModel> getNotifications(params) async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'notification/notifyPagination',
        method: Method.GET,
        showPopUp: true,
        params: {'page': params},
      );
      if (r['code'] != 200) {
        throw ApiException(r['message']);
      }
      final response = NotificationModel.fromJson(r);
      return response;
    } on ServerFailure {
      throw ApiException('Server error occurred');
    } on ApiException catch (e) {
      AppUtils.logApp('CATCH ERR ::: ${e.message}');
      throw ApiException(e.message ?? 'An error occurred');
    } catch (e, stackTrace) {
      AppUtils.logApp('Error parsing JSON: $e\n$stackTrace');
      rethrow;
    }
  }

  @override
  Future<TapNotificationModel> tapNotification(params) async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'notification/clickNotification',
        showPopUp: true,
        params: {'notification_id': params},
      );
      if (r['code'] != 200) {
        throw ApiException(r['message']);
      }
      final response = TapNotificationModel.fromJson(r);
      return response;
    } on ServerFailure {
      throw ApiException('Server error occurred');
    } on ApiException catch (e) {
      AppUtils.logApp('CATCH ERR ::: ${e.message}');
      throw ApiException(e.message ?? 'An error occurred');
    } catch (e, stackTrace) {
      AppUtils.logApp('Error parsing JSON: $e\n$stackTrace');
      rethrow;
    }
  }
}
