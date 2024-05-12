import 'package:get/get.dart';
import 'package:iroyal/app/modules/tracking_document/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/tracking_document/data/repositories/tracking_document_repositories_impl.dart';
import 'package:iroyal/app/modules/tracking_document/domain/usecase/get_tracking_document.dart';

import '../controllers/tracking_document_controller.dart';

class TrackingDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get
      // Tracking Document
      ..lazyPut<TrackingDocumentController>(
        () => TrackingDocumentController(
          getTrackingDocument: Get.find(),
        ),
      )
      ..lazyPut<TrackingDocumentRemoteDataSourcesImpl>(
        () => TrackingDocumentRemoteDataSourcesImpl(
          httpService: Get.find(),
        ),
      )
      ..lazyPut<TrackingDocumentRepositoriesImpl>(
        () => TrackingDocumentRepositoriesImpl(
          remoteData: Get.find<TrackingDocumentRemoteDataSourcesImpl>(),
        ),
      )
      ..lazyPut(
        () => GetTrackingDocument(
          Get.find<TrackingDocumentRepositoriesImpl>(),
        ),
      );
  }
}
