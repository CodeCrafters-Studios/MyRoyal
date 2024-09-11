import 'package:iroyal/app/modules/tracking_document/data/models/tracking_document_on_progress_model.dart';
import 'package:iroyal/app/modules/tracking_document/domain/entities/tracking_document_on_progress.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class TrackingDocumentRemoteDataSources {
  Future<TrackingDocumentOnProgress> getTrackingDocumentOnProgress();
}

class TrackingDocumentRemoteDataSourcesImpl
    extends TrackingDocumentRemoteDataSources {
  TrackingDocumentRemoteDataSourcesImpl({required this.httpService});

  final HttpService httpService;

  @override
  Future<TrackingDocumentOnProgress> getTrackingDocumentOnProgress() async {
    try {
      final r = await httpService.request(
        withToken: true,
        enpoint: 'ptk/allPtkOnProgress',
        method: Method.GET,
        showPopUp: true,
      );
      if (r['code'] != 200) {
        throw ApiException(r['message']);
      }
      final response = TrackingDocumentOnProgressModel.fromJson(r);
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
