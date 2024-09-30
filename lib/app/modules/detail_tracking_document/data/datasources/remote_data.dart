import 'package:iroyal/app/modules/detail_tracking_document/data/models/action_tracking_document_model.dart';
import 'package:iroyal/app/modules/detail_tracking_document/data/models/detail_tracking_document_model.dart';
import 'package:iroyal/app/modules/detail_tracking_document/domain/entities/action_tracking_document_entity.dart';
import 'package:iroyal/app/modules/detail_tracking_document/domain/entities/detail_tracking_document_entity.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class DetailTrackingDocumentRemoteDataSources {
  Future<DetailTrackingDocumentEntity> getDetailTrackingDocument(params);
  Future<ActionTrackingDocumentEntity> actionDetailTrackingDocument(
      Map<String, dynamic> params);
}

class DetailTrackingDocumentRemoteDataSourcesImpl
    implements DetailTrackingDocumentRemoteDataSources {
  DetailTrackingDocumentRemoteDataSourcesImpl({required this.httpService});

  final HttpService httpService;

  @override
  Future<DetailTrackingDocumentEntity> getDetailTrackingDocument(params) async {
    try {
      final r = await httpService.request(
        withToken: true,
        enpoint: 'ptk/detail',
        method: Method.GET,
        showPopUp: true,
        params: {'labor_id': params},
      );
      if (r['code'] != 200) {
        throw ApiException(r['message']);
      }
      final response = DetailTrackingDocumentModel.fromJson(r);
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
  Future<ActionTrackingDocumentEntity> actionDetailTrackingDocument(
      Map<String, dynamic> params) async {
    try {
      final r = await httpService.request(
        withToken: true,
        enpoint: 'ptk/approval',
        method: Method.GET,
        showPopUp: true,
        params: params,
      );
      if (r['code'] != 200) {
        throw ApiException(r['message']);
      }
      final response = ActionTrackingDocumentModel.fromJson(r);
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
