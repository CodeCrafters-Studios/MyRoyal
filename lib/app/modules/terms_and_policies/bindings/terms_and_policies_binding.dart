import 'package:get/get.dart';

import '../controllers/terms_and_policies_controller.dart';

class TermsAndPoliciesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsAndPoliciesController>(
      () => TermsAndPoliciesController(),
    );
  }
}
