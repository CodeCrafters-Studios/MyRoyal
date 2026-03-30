import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/tracking_document/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/tracking_document/data/repositories/tracking_document_repositories_impl.dart';
import 'package:MyRoyal/app/modules/tracking_document/domain/usecase/get_tracking_document_history.dart';
import 'package:MyRoyal/app/modules/tracking_document/domain/usecase/get_tracking_document_on_progress.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';

import '../controllers/tracking_document_controller.dart';

class TrackingDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get
      // Tracking Document
      ..lazyPut<TrackingDocumentController>(
        () => TrackingDocumentController(
          getTrackingDocumentOnProgress: Get.find(),
          getTrackingDocumentHistory: Get.find(),
          appDialog: Get.find<AppDialogImpl>(),
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
        () => GetTrackingDocumentOnProgress(
          Get.find<TrackingDocumentRepositoriesImpl>(),
        ),
      )
      ..lazyPut(
        () => GetTrackingDocumentHistory(
          Get.find<TrackingDocumentRepositoriesImpl>(),
        ),
      );
  }
}
