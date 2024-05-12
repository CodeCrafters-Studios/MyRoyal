import 'package:get/get.dart';

import '../controllers/detail_tracking_document_controller.dart';

class DetailTrackingDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailTrackingDocumentController>(
      () => DetailTrackingDocumentController(),
    );
  }
}
