import 'package:get/get.dart';
import 'package:iroyal/app/modules/cam_app_reserved_by/data/models/reserved_by_model.dart';
import 'package:iroyal/app/modules/cam_app_reserved_by/data/models/reserved_by_params_model.dart';
import 'package:iroyal/app/modules/cam_app_reserved_by/data/models/update_reserved_by_params_model.dart';
import 'package:iroyal/app/modules/cam_app_reserved_by/domain/usecases/get_reserved_by_usecase.dart';
import 'package:iroyal/app/modules/cam_app_reserved_by/domain/usecases/update_reserved_by_usecase.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

class CamAppReservedByController extends GetxController {
  CamAppReservedByController({
    required this.getReservedByUsecase,
    required this.updateReservedByUsecase,
    required this.appStorage,
  });

  final GetReservedByUsecase getReservedByUsecase;
  final UpdateReservedByUsecase updateReservedByUsecase;
  final AppStorage appStorage;

  final Rx<ReservedByModel> reservedByData = ReservedByModel.empty().obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getReservedByData();
  }

  // void loadDummyData() {
  //   reservedItems.addAll([
  //     ReservedItemEntity(
  //       username: 'alghany.adam',
  //       genericKey: '732891SYH6121',
  //       date: 'Thursday 12 June 2025',
  //       time: '14.33 WIB',
  //     ),
  //     ReservedItemEntity(
  //       username: 'john.doe',
  //       genericKey: 'ABCDE12345XYZ',
  //       date: 'Friday 13 June 2025',
  //       time: '10.00 WIB',
  //     ),
  //     ReservedItemEntity(
  //       username: 'jane.smith',
  //       genericKey: '98765ZYXWVU',
  //       date: 'Saturday 14 June 2025',
  //       time: '16.45 WIB',
  //     ),
  //   ]);
  // }

  void releaseItem(int index) {
    AppDialogImpl().showLiquidGlassInfo(
      imagePath: 'assets/icons/ic_copy_success.svg',
      title: 'Release',
    );
    if (index >= 0 && index < reservedByData.value.data!.data.length) {
      reservedByData.value.data!.data.removeAt(index);
    }
  }

  void removeItem(int index) {
    AppDialogImpl().showLiquidGlassInfo(
      imagePath: 'assets/icons/ic_clipboard_close.svg',
      title: 'Canceled',
    );
    if (index >= 0 && index < reservedByData.value.data!.data.length) {
      reservedByData.value.data!.data.removeAt(index);
    }
  }

  Future<void> getReservedByData() async {
    isLoading.value = true;

    final userIdJde = await appStorage.read(USER_ID_JDE);
    final result = await getReservedByUsecase.call(
      ReservedByParamsModel(userJde: userIdJde.toString(), company: 'CAM'),
    );

    result.fold(
      (l) {
        isLoading.value = false;
        AppUtils.logApp('ERROR $l');
        // final m = l.properties[0] as ApiException;
        // AppDialogImpl().showErrorDialog(description: m.message);
      },
      (r) async {
        isLoading.value = false;
        reservedByData.value = r;
      },
    );
  }

  Future<void> updateReservedByData(String genericKey, int index) async {
    isLoading.value = true;

    final userIdJde = await appStorage.read(USER_ID_JDE);
    final result = await updateReservedByUsecase.call(
      UpdateReservedByParamsModel(
        userJde: userIdJde.toString(),
        company: 'CAM',
        genericKey: genericKey,
      ),
    );

    result.fold(
      (l) {
        isLoading.value = false;
        AppUtils.logApp('ERROR $l');
        // final m = l.properties[0] as ApiException;
        // AppDialogImpl().showErrorDialog(description: m.message);
      },
      (r) async {
        isLoading.value = false;
        getReservedByData();
        await Future.delayed(Duration(seconds: 2));
        AppDialogImpl().showLiquidGlassInfo(
          imagePath: 'assets/icons/ic_copy_success.svg',
          title: 'Release',
        );
      },
    );
  }
}
