import 'package:MyRoyal/app/modules/online_app/cam/cam_app_trace_serial/data/models/trace_serial_model.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/services/http_service.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';

abstract class TraceSerialDataSources {
  Future<TraceSerialModel> getTraceSerial(params);
}

class TraceSerialDataSourcesImpl implements TraceSerialDataSources {
  TraceSerialDataSourcesImpl({required this.httpService});

  final HttpService httpService;

  @override
  Future<TraceSerialModel> getTraceSerial(params) async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'trackproduct/getDataProduct',
        showPopUp: true,
        params: params,
      );
      final response = TraceSerialModel.fromJson(r);
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
