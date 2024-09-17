import 'package:another_stepper/dto/stepper_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/detail_tracking_document/data/models/detail_tracking_document_model.dart';
import 'package:iroyal/app/modules/detail_tracking_document/domain/usecases/get_detail_tracking_document.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/others/ticker_provider.dart';

class DetailTrackingDocumentController extends GetxController {
  DetailTrackingDocumentController(
      {required this.getDetailTrackingDocumentUseCase});

  late final TabController tabController;
  String checkRoutes = Get.arguments[1];
  late dynamic trackingDocumentListData;

  RxBool isLoading = false.obs;

  Rx<DetailTrackingDocumentModel> detailTrackingDocDataModel =
      DetailTrackingDocumentModel.empty().obs;
  RxList<StepperData> stepperData = <StepperData>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: TicckerProvider());
    _checkRoutes();
    _getDetailDocument(trackingDocumentListData.id);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  final GetDetailTrackingDocument getDetailTrackingDocumentUseCase;

  void _checkRoutes() {
    if (checkRoutes == 'Approval') {
      trackingDocumentListData = Get.arguments[0];
    } else {
      trackingDocumentListData = Get.arguments[0];
    }
  }

  Future<void> _getDetailDocument(int id) async {
    isLoading.value = true;

    final result = await getDetailTrackingDocumentUseCase(id);

    result.fold(
      (l) {
        isLoading.value = false;
      },
      (r) {
        isLoading.value = false;
        detailTrackingDocDataModel.value = r;
        _initializeStepperData();
      },
    );
  }

  void _initializeStepperData() {
    stepperData.value = detailTrackingDocDataModel.value.data.detailProgress
        .map((progressItem) {
      String firstName = progressItem.fullName.split(' ').first.isNotEmpty
          ? progressItem.fullName.split(' ').first[0]
          : '';
      String lastName = progressItem.fullName.split(' ').last.isNotEmpty
          ? progressItem.fullName.split(' ').last[0]
          : '';
      String initials = firstName + lastName;
      Color iconColor;

      switch (progressItem.forLabel) {
        case "Approved":
          iconColor = Colors.green;
          break;
        case "Rejected":
          iconColor = Colors.red;
          break;
        case "Waiting For Approval":
          iconColor = Colors.grey;
          break;
        case "Done":
          iconColor = Colors.blue;
          break;
        default:
          iconColor = Colors.brown;
          break;
      }

      return StepperData(
        title: StepperText(
          progressItem.fullName.isNotEmpty
              ? "${progressItem.fullName}\n${progressItem.positionName} ${progressItem.sectionName}"
              : progressItem.forLabel.toUpperCase(),
          textStyle: TS.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: progressItem.fullName.isNotEmpty ? black : Colors.blue),
        ),
        subtitle: progressItem.fullName.isNotEmpty
            ? StepperText(
                progressItem.forLabel.toUpperCase(),
                textStyle: TS.bodySmall.copyWith(
                  color: iconColor,
                ),
              )
            : null,
        iconWidget: Container(
          padding: REdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: Center(
              child: progressItem.fullName.isNotEmpty
                  ? Text(
                      initials,
                      style: TS.labelMedium.copyWith(
                        color: white,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : const Icon(
                      Icons.flag,
                      color: Colors.white,
                    )),
        ),
      );
    }).toList();
  }
}
