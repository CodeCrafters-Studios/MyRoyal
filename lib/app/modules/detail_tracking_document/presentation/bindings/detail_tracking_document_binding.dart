import 'package:get/get.dart';
import 'package:iroyal/app/modules/detail_tracking_document/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/detail_tracking_document/data/repositories/detail_tracking_document_repositories_impl.dart';
import 'package:iroyal/app/modules/detail_tracking_document/domain/usecases/get_detail_tracking_document.dart';

import '../controllers/detail_tracking_document_controller.dart';

class DetailTrackingDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<DetailTrackingDocumentRemoteDataSourcesImpl>(
        () => DetailTrackingDocumentRemoteDataSourcesImpl(
          httpService: Get.find(),
        ),
      )
      ..lazyPut<DetailTrackingDocumentRepositoriesImpl>(
        () => DetailTrackingDocumentRepositoriesImpl(
          remoteData: Get.find<DetailTrackingDocumentRemoteDataSourcesImpl>(),
        ),
      )
      ..lazyPut<GetDetailTrackingDocument>(
        () => GetDetailTrackingDocument(
          Get.find<DetailTrackingDocumentRepositoriesImpl>(),
        ),
      )
      ..lazyPut<DetailTrackingDocumentController>(
        () => DetailTrackingDocumentController(
          getDetailTrackingDocumentUseCase:
              Get.find<GetDetailTrackingDocument>(),
        ),
      );
  }
}
