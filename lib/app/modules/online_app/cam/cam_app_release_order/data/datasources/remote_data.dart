import 'package:iroyal/app/modules/online_app/cam/cam_app_release_order/data/models/release_order_model.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_release_order/data/models/update_release_order_model.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class ReleaseOrderRemoteDatasource {
  Future<ReleaseOrderModel> getReleaseOrder(params);
  Future<UpdateReleaseOrderModel> updateReleaseOrder(params);
}

class ReleaseOrderRemoteDatasourceImpl implements ReleaseOrderRemoteDatasource {
  ReleaseOrderRemoteDatasourceImpl(this.httpService);

  final HttpService httpService;

  @override
  Future<ReleaseOrderModel> getReleaseOrder(params) async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'trackproduct/getDataReleaseOrder',
        showPopUp: true,
        params: params,
      );
      final response = ReleaseOrderModel.fromJson(r);
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
  Future<UpdateReleaseOrderModel> updateReleaseOrder(params) async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'trackproduct/updateReleaseOrder',
        showPopUp: true,
        params: params,
      );
      final response = UpdateReleaseOrderModel.fromJson(r);
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
