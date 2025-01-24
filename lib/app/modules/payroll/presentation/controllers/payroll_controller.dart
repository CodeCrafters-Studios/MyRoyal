import 'package:get/get.dart';
import 'package:iroyal/app/modules/payroll/data/models/payroll_data_overview_model.dart';
import 'package:iroyal/app/modules/payroll/data/models/payroll_download_url_model.dart';
import 'package:iroyal/app/modules/payroll/data/models/payroll_id_params_model.dart';
import 'package:iroyal/app/modules/payroll/data/models/payroll_period_model.dart';
import 'package:iroyal/app/modules/payroll/domain/entities/payroll_data_overview_entity.dart';
import 'package:iroyal/app/modules/payroll/domain/entities/payroll_download_url_entity.dart';
import 'package:iroyal/app/modules/payroll/domain/entities/payroll_period_entity.dart';
import 'package:iroyal/app/modules/payroll/domain/usecases/get_payroll_periode_usecase.dart';
import 'package:iroyal/app/modules/payroll/domain/usecases/payroll_data_overview_usecase.dart';
import 'package:iroyal/app/modules/payroll/domain/usecases/payroll_download_url_usecase.dart';
import 'package:iroyal/app/modules/profile/domain/usecases/download_file.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';

class PayrollController extends GetxController {
  final DownloadFile downloadFile;
  final AppDialog appDialog;
  final GetPayrollPeriodeUsecase getPayrollPeriodeUsecase;
  final PayrollDownloadUrlUsecase payrollDownloadUrlUsecase;
  final PayrollDataOverviewUsecase payrollDataOverviewUsecase;

  PayrollController({
    required this.downloadFile,
    required this.appDialog,
    required this.getPayrollPeriodeUsecase,
    required this.payrollDownloadUrlUsecase,
    required this.payrollDataOverviewUsecase,
  });

  RxString payrollPeriod = ''.obs;

  RxBool isLoading = false.obs;
  RxBool isObsecureText = true.obs;

  Rx<PayrollPeriodModel> payrollPeriodRes =
      PayrollPeriodModel(code: 0, message: '', data: []).obs;
  Rx<PayrollDownloadUrlModel> payrollDownloadUrlRes = PayrollDownloadUrlModel(
    code: 0,
    message: '',
    data: Data(pathUrl: ''),
  ).obs;
  Rx<PayrollDataOverviewModel> payrollDataOverviewRes =
      PayrollDataOverviewModel(
    data: DataOverview(
      gajiBersih: '',
      gajiPokok: '',
      totalPotongan: '',
      pembulatan: '',
      pendapatanSebelumPajak: '',
      pendapatanSesudahPajak: '',
      persentasePotonganPajak: '',
      potonganPajak: '',
    ),
  ).obs;

  RxList<PayrollPeriodData> payrollPeriodListRes = <PayrollPeriodData>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await _getPayrollPeriod();
    payrollDataOverview(payrollPeriodRes.value.data[0].id);
    downloadSlipUrl(payrollPeriodRes.value.data[0].id);
  }

  Future<void> _getPayrollPeriod() async {
    isLoading.value = true;

    final result = await getPayrollPeriodeUsecase();

    result.fold(
      (l) {
        isLoading.value = false;
        final m = l.properties[0] as ApiException;
        appDialog.showErrorDialog(description: m.message);
      },
      (r) {
        isLoading.value = false;
        payrollPeriodRes.value = r;
        payrollPeriodListRes.value = payrollPeriodRes.value.data;
      },
    );
  }

  Future<void> payrollDataOverview(int payrollId) async {
    final response = await payrollDataOverviewUsecase(
      PayrollIdParamsModel(payrollId: payrollId),
    );

    response.fold(
      (l) {
        isLoading.value = false;
      },
      (r) {
        isLoading.value = false;
        payrollDataOverviewRes.value = r;
      },
    );
  }

  Future<void> downloadSlipUrl(int payrollId) async {
    isLoading.value = true;

    final result = await payrollDownloadUrlUsecase(
      PayrollIdParamsModel(payrollId: payrollId),
    );

    result.fold(
      (l) {
        isLoading.value = false;
      },
      (r) {
        isLoading.value = false;
        payrollDownloadUrlRes.value = r;
      },
    );
  }

  Future<void> downloadFiles(String url, String fileName) async {
    final result = await downloadFile(
      ParamsDownload(url: url, fileName: fileName),
    );

    await result.fold(
      (failure) =>
          appDialog.showErrorSnackBar(description: 'Failed Download Document'),
      (success) async {
        await appDialog.showSuccessSnackBar(
          description: 'Success Download Document',
        );
      },
    );
  }

  void toggleShow() {
    isObsecureText.value = !isObsecureText.value;
  }
}
