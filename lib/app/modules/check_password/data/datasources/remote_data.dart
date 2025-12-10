import 'package:iroyal/app/modules/check_password/data/models/check_password_model.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class CheckPasswordRemoteDataSource {
  Future<CheckPasswordModel> checkPassword(Map<String, dynamic> params);
}

class CheckPasswordRemoteDataSourceImpl
    implements CheckPasswordRemoteDataSource {
  CheckPasswordRemoteDataSourceImpl({required this.httpService});

  final HttpService httpService;

  @override
  Future<CheckPasswordModel> checkPassword(Map<String, dynamic> params) async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'user/checkPassword',
        params: params,
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

      final response = CheckPasswordModel.fromJson(r);
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
