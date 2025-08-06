import 'package:get/get.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_reserved_by/data/models/reserved_by_model.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_reserved_by/data/models/reserved_by_params_model.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_reserved_by/data/models/update_reserved_by_params_model.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_reserved_by/domain/usecases/get_reserved_by_usecase.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_reserved_by/domain/usecases/update_reserved_by_usecase.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

class RasAppReservedByController extends GetxController {
  RasAppReservedByController({
    required this.getReservedByUsecase,
    required this.updateReservedByUsecase,
    required this.appStorage,
  });

  RxBool isLoading = false.obs;

  final Rx<ReservedByModel> reservedByData = ReservedByModel.empty().obs;

  final GetReservedByUsecase getReservedByUsecase;
  final UpdateReservedByUsecase updateReservedByUsecase;
  final AppStorage appStorage;

  @override
  void onInit() {
    super.onInit();
    getReservedByData();
  }

  Future<void> getReservedByData() async {
    isLoading.value = true;

    final userIdJde = await appStorage.read(USER_ID_JDE);
    final result = await getReservedByUsecase.call(
      ReservedByParamsModel(userJde: userIdJde.toString(), company: 'RAS'),
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
        company: 'RAS',
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
