import 'package:MyRoyal/app/modules/approval/data/models/approval_model.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/services/http_service.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';

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
      if (r == null) {
        throw ApiException('No response from server');
      }

      final code = r['code'];
      final message = r['message'] ?? 'Unknown error occurred';

      if (code != 200) {
        throw ApiException(message);
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
