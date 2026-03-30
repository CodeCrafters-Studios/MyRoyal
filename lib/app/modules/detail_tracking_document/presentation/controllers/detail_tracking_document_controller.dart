import 'package:another_stepper/dto/stepper_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/detail_tracking_document/data/models/detail_tracking_document_model.dart';
import 'package:MyRoyal/app/modules/detail_tracking_document/domain/usecases/action_tracking_document.dart';
import 'package:MyRoyal/app/modules/detail_tracking_document/domain/usecases/get_detail_tracking_document.dart';
import 'package:MyRoyal/app/modules/tracking_document/presentation/controllers/tracking_document_controller.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';
import 'package:MyRoyal/base/widgets/others/ticker_provider.dart';

class DetailTrackingDocumentController extends GetxController {
  DetailTrackingDocumentController({
    required this.getDetailTrackingDocumentUseCase,
    required this.postActionTrackingDocument,
    required this.appDialog,
  });

  late final TabController tabController;
  dynamic trackingDocumentListData = Get.arguments;
  TextEditingController reason = TextEditingController();
  final TrackingDocumentController controllerTrackingDocument =
      Get.find<TrackingDocumentController>();
  final AppDialog appDialog;

  RxBool isLoading = false.obs;
  RxString reasonText = ''.obs;

  Rx<DetailTrackingDocumentModel> detailTrackingDocDataModel =
      DetailTrackingDocumentModel.empty().obs;
  RxList<StepperData> stepperData = <StepperData>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: TicckerProvider());
    _getDetailDocument(trackingDocumentListData.id);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  final GetDetailTrackingDocument getDetailTrackingDocumentUseCase;
  final ActionTrackingDocument postActionTrackingDocument;

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
        case "Closed":
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

  Future<void> postActionDocument(
      int laborId, String type, String feedback) async {
    isLoading.value = true;

    final result = await postActionTrackingDocument({
      'labor_id': laborId,
      'type': type,
      'feedback': feedback,
    });

    result.fold(
      (l) {
        isLoading.value = false;
      },
      (r) {
        isLoading.value = false;
        Get.back();
        Get.back();
        AppDialogImpl().showSuccessSnackBar(
          description: type == 'approve'
              ? 'Document Successfully Approved'
              : 'Document Successfully Rejected',
        );
        controllerTrackingDocument.loadTrackingDocuments();
      },
    );
  }
}
