import 'package:get/get.dart';

import '../controllers/tracking_document_controller.dart';

class TrackingDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackingDocumentController>(
      () => TrackingDocumentController(),
    );
  }
}
