import 'package:iroyal/app/modules/tracking_document/data/models/tracking_document_models.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class TrackingDocumentRemoteDataSources {
  Future<List<TrackingDocumentModel>> getTrackingDocument();
}

class TrackingDocumentRemoteDataSourcesImpl
    extends TrackingDocumentRemoteDataSources {
  TrackingDocumentRemoteDataSourcesImpl({required this.httpService});

  final HttpService httpService;
  @override
  Future<List<TrackingDocumentModel>> getTrackingDocument() async {
    try {
      final r = await httpService.request(
        withToken: true,
        enpoint: '/api/v1/list_labor_approvals',
        method: Method.GET,
      );

      if (r is List) {
        final List<TrackingDocumentModel> trackingDocuments =
            r.map((e) => TrackingDocumentModel.fromJson(e)).toList();
        AppUtils.logApp('$trackingDocuments');
        return trackingDocuments;
      } else {
        throw ApiException('Invalid response format');
      }
    } on ApiException {
      rethrow;
    }
  }
}
