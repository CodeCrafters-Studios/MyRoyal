import 'package:iroyal/app/modules/leave_summary/data/models/leave_model.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class LeaveRemoteDataSources {
  Future<LeaveModel> getLeave();
}

class LeaveRemoteDataSourcesImpl implements LeaveRemoteDataSources {
  LeaveRemoteDataSourcesImpl({required this.httpService});

  final HttpService httpService;

  @override
  Future<LeaveModel> getLeave() async {
    try {
      final r = await httpService.request(
        withToken: true,
        enpoint: 'attendance/getDataLeave',
        method: Method.GET,
      );
      if (r['code'] != 200) {
        throw ApiException(r['message']);
      }
      final response = LeaveModel.fromJson(r);
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
