import 'package:iroyal/app/modules/webtel/data/models/webtel_model.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class WebtelRemoteDataSources {
  Future<List<WebtelModel>> getWebtel();
}

class WebtelRemoteDataSourcesImpl extends WebtelRemoteDataSources {
  WebtelRemoteDataSourcesImpl({required this.httpService});

  final HttpService httpService;
  @override
  Future<List<WebtelModel>> getWebtel() async {
    try {
      final r = await httpService.request(
        withToken: true,
        enpoint: '/api/v1/list_employee_extensions',
        method: Method.GET,
      );

      if (r is List) {
        final List<WebtelModel> webtels =
            r.map((e) => WebtelModel.fromJson(e)).toList();
        AppUtils.logApp('$webtels');
        return webtels;
      } else {
        throw ApiException('Invalid response format');
      }
    } on ApiException {
      rethrow;
    }
  }
}
