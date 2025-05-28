import 'package:iroyal/app/modules/approval/data/models/approval_model.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class ApprovalRemoteDataSource {
  Future<List<ApprovalModel>> getLeaveApproval();
}

class ApprovalRemoteDataSourceImpl implements ApprovalRemoteDataSource {
  ApprovalRemoteDataSourceImpl({required this.httpService});

  final HttpService httpService;

  @override
  Future<List<ApprovalModel>> getLeaveApproval() async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'attendance/getDataLeaveApproval',
        method: Method.GET,
        showPopUp: true,
      );
      if (r['code'] != 200) {
        throw ApiException(r['message']);
      }
      final List<ApprovalModel> response =
          (r['data'] as List).map((x) => ApprovalModel.fromJson(x)).toList();
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
