import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_release_order/data/models/release_order_model.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_release_order/data/models/release_order_params_model.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_release_order/data/models/update_release_order_params_model.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_release_order/domain/usecases/get_release_order_usecase.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_release_order/domain/usecases/update_release_order_usecase.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

class RasAppReleaseOrderController extends GetxController {
  RasAppReleaseOrderController({
    required this.getReleaseOrderUsecase,
    required this.updateReleaseOrderUsecase,
    required this.appStorage,
  });

  final GetReleaseOrderUsecase getReleaseOrderUsecase;
  final UpdateReleaseOrderUsecase updateReleaseOrderUsecase;
  final AppStorage appStorage;

  final Rx<ReleaseOrderModel> releaseOrderData = ReleaseOrderModel.empty().obs;

  final TextEditingController textEditingController = TextEditingController();

  RxBool isLoading = false.obs;
  RxString serial = ''.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   getReleaseOrder();
  // }

  Future<void> getReleaseOrder() async {
    isLoading.value = true;

    final result = await getReleaseOrderUsecase.call(
      ReleaseOrderParamsModel(
          orderid: textEditingController.text, company: 'RAS'),
    );

    result.fold(
      (l) {
        isLoading.value = false;
      },
      (r) async {
        isLoading.value = false;
        releaseOrderData.value = r;
      },
    );
  }

  Future<void> updateReleaseOrder(String branchPlant, String kodeHold,
      String nomorOrder, String tipeOrder, int index) async {
    isLoading.value = true;

    final userIdJde = await appStorage.read(USER_ID_JDE);
    final result = await updateReleaseOrderUsecase.call(
      UpdateReleaseOrderParamsModel(
        branchPlant: branchPlant,
        company: 'RAS',
        kodeHold: kodeHold,
        nomorOrder: nomorOrder,
        tipeOrder: tipeOrder,
        userJde: userIdJde.toString(),
      ),
    );

    result.fold(
      (l) {
        isLoading.value = false;
        AppUtils.logApp('ERROR $l');
      },
      (r) async {
        isLoading.value = false;
        getReleaseOrder();
        await Future.delayed(Duration(seconds: 2));
        AppDialogImpl().showLiquidGlassInfo(
          imagePath: 'assets/icons/ic_copy_success.svg',
          title: 'Release',
        );
      },
    );
  }

  String formatJamRelease(String jamReleaseString) {
    if (jamReleaseString.length != 6) {
      return '-';
    }

    try {
      final String hours = jamReleaseString.substring(0, 2);
      final String minutes = jamReleaseString.substring(2, 4);
      final String seconds = jamReleaseString.substring(4, 6);

      final DateTime dummyDateTime = DateTime(
        2000,
        1,
        1,
        int.parse(hours),
        int.parse(minutes),
        int.parse(seconds),
      );
      return DateFormat('HH:mm:ss').format(dummyDateTime);
    } catch (e) {
      return 'Error formatting time: $e';
    }
  }
}
