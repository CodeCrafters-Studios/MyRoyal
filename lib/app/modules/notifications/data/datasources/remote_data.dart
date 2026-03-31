import 'package:MyRoyal/app/modules/notifications/data/models/notification_model.dart';
import 'package:MyRoyal/app/modules/notifications/data/models/tap_notification_model.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/services/http_service.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';

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
        params: {'page': params},
        method: Method.GET,
      );
      if (r == null) {
        throw ApiException('No response from server');
      }

      final code = r['code'];
      final message = r['message'] ?? 'Unknown error occurred';

      if (code != 200) {
        throw ApiException(message);
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
        params: {'notification_id': params},
      );
      if (r == null) {
        throw ApiException('No response from server');
      }

      final code = r['code'];
      final message = r['message'] ?? 'Unknown error occurred';

      if (code != 200) {
        throw ApiException(message);
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
