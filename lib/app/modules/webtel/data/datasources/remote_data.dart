import 'package:iroyal/app/modules/webtel/data/models/webtel_model.dart';
import 'package:iroyal/app/modules/webtel/domain/entities/webtel.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class WebtelRemoteDataSources {
  Future<Webtel> getWebtel();
}

class WebtelRemoteDataSourcesImpl extends WebtelRemoteDataSources {
  WebtelRemoteDataSourcesImpl({required this.httpService});

  final HttpService httpService;
  @override
  Future<Webtel> getWebtel() async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'webtel/getAll',
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

      final response = WebtelModel.fromJson(r);
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
