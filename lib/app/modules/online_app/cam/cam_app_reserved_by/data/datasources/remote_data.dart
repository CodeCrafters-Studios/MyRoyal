import 'package:MyRoyal/app/modules/online_app/cam/cam_app_reserved_by/data/models/reserved_by_model.dart';
import 'package:MyRoyal/app/modules/online_app/cam/cam_app_reserved_by/data/models/update_reserved_by_model.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/services/http_service.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';

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
        params: params,
      );
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
        params: params,
      );
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
