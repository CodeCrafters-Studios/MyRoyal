import 'package:iroyal/app/modules/cam_app_reserved_by/data/models/reserved_by_model.dart';
import 'package:iroyal/app/modules/cam_app_reserved_by/data/models/update_reserved_by_model.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class ReservedByRemoteDatasource {
  Future<ReservedByModel> getReservedBy(params);
  Future<UpdateReservedByModel> updateReservedBy(params);
}

class ReservedByRemoteDatasoureceImpl implements ReservedByRemoteDatasource {
  ReservedByRemoteDatasoureceImpl({required this.httpService});

  final HttpService httpService;

  @override
  Future<ReservedByModel> getReservedBy(params) async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'trackproduct/getDataReserved',
        showPopUp: true,
        params: params,
      );

      if (r['code'] != 200) {
        throw ApiException(r['message']);
      }
      final response = ReservedByModel.fromJson(r);
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
  Future<UpdateReservedByModel> updateReservedBy(params) async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'trackproduct/updateReservedBy',
        showPopUp: true,
        params: params,
      );

      if (r['code'] != 200) {
        throw ApiException(r['message']);
      }
      final response = UpdateReservedByModel.fromJson(r);
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
