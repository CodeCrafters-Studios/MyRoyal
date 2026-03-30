import 'package:MyRoyal/app/modules/tracking_document/data/models/tracking_document_history_model.dart';
import 'package:MyRoyal/app/modules/tracking_document/data/models/tracking_document_on_progress_model.dart';
import 'package:MyRoyal/app/modules/tracking_document/domain/entities/tracking_document_history.dart';
import 'package:MyRoyal/app/modules/tracking_document/domain/entities/tracking_document_on_progress.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/services/http_service.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';

abstract class TrackingDocumentRemoteDataSources {
  Future<TrackingDocumentOnProgress> getTrackingDocumentOnProgress();
  Future<TrackingDocumentHistory> getTrackingDocumentHistory();
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
        endpoint: 'ptk/allPtkOnProgress',
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

  @override
  Future<TrackingDocumentHistory> getTrackingDocumentHistory() async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'ptk/allPtkComplete',
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

      final response = TrackingDocumentHistoryModel.fromJson(r);
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
