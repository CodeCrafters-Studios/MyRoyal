import 'package:get/get.dart';
import 'package:iroyal/app/modules/payroll/data/models/payroll_data_overview_model.dart';
import 'package:iroyal/app/modules/payroll/data/models/payroll_download_url_model.dart';
import 'package:iroyal/app/modules/payroll/data/models/payroll_period_params_model.dart';
import 'package:iroyal/app/modules/payroll/data/models/payroll_period_model.dart';
import 'package:iroyal/app/modules/payroll/domain/entities/payroll_data_overview_entity.dart';
import 'package:iroyal/app/modules/payroll/domain/entities/payroll_download_url_entity.dart';
import 'package:iroyal/app/modules/payroll/domain/entities/payroll_period_entity.dart';
import 'package:iroyal/app/modules/payroll/domain/usecases/get_payroll_periode_usecase.dart';
import 'package:iroyal/app/modules/payroll/domain/usecases/payroll_data_overview_usecase.dart';
import 'package:iroyal/app/modules/payroll/domain/usecases/payroll_download_url_usecase.dart';
import 'package:iroyal/app/modules/profile/domain/usecases/download_file.dart';
import 'package:iroyal/base/utils/app_utils.dart';
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
  RxString selectedFilename = ''.obs;

  RxInt selectedIndex = 0.obs;

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
    // payrollDataOverview(payrollPeriodRes.value.data[0].id);
  }

  Future<void> _getPayrollPeriod() async {
    isLoading.value = true;

    final result = await getPayrollPeriodeUsecase();

    result.fold(
      (l) {
        isLoading.value = false;
      },
      (r) {
        isLoading.value = false;
        payrollPeriodRes.value = r;
        payrollPeriodListRes.value = payrollPeriodRes.value.data;
      },
    );
  }

  void selectedPeriod(int index, String value, String filename) {
    selectedIndex.value = index;
    payrollPeriod.value = value;
    selectedFilename.value = filename;
  }
  // Future<void> payrollDataOverview(int payrollId) async {
  //   final response = await payrollDataOverviewUsecase(
  //     PayrollIdParamsModel(payrollId: payrollId),
  //   );

  //   response.fold(
  //     (l) {
  //       isLoading.value = false;
  //     },
  //     (r) {
  //       isLoading.value = false;
  //       payrollDataOverviewRes.value = r;
  //     },
  //   );
  // }

  Future<void> downloadSlipUrl(String payrollPeriod, String fileName) async {
    appDialog.showInfoDialog(
      title: 'Disclaimer',
      description: '''
🔒 DISCLAIMER – KERAHASIAAN SLIP GAJI

Slip gaji ini merupakan dokumen bersifat rahasia yang hanya diperuntukkan bagi karyawan yang bersangkutan dan tidak untuk disebarluaskan kepada pihak manapun di luar kepentingan pribadi dan internal perusahaan.

Dengan mengakses dan/atau mengunduh slip gaji ini, Anda menyatakan setuju untuk:

1. Menjaga kerahasiaan informasi yang tercantum di dalam slip gaji.
2. Tidak menggandakan, membagikan, atau memperlihatkan isi slip gaji kepada pihak lain tanpa izin tertulis dari manajemen perusahaan.
3. Bertanggung jawab penuh atas penyalahgunaan informasi apabila terjadi pelanggaran yang berasal dari pihak Anda.

Setiap pelanggaran terhadap kebijakan kerahasiaan ini akan dikenakan sanksi sesuai ketentuan perusahaan dan/atau hukum yang berlaku.

Format Password PDF: ddmmyy (tanggal bulan tahun lahir) / contoh: 010172
''',
      textButton: 'Download',
      isLoading: isLoading.value,
      onPress: () async {
        Get.back();

        isLoading.value = true;

        await Future.delayed(Duration(milliseconds: 200));

        try {
          final result = await payrollDownloadUrlUsecase(
            PayrollPeriodParamsModel(
              payrollPeriod: payrollPeriod,
              filename: fileName,
            ),
          );

          result.fold(
            (l) {},
            (r) {},
          );
        } catch (e) {
          AppUtils.logApp("Controller error: $e");
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  // Future<void> downloadFiles(String url, String fileName) async {
  //   final result = await downloadFile(
  //     ParamsDownload(url: url, fileName: fileName),
  //   );

  //   await result.fold(
  //     (failure) =>
  //         appDialog.showErrorSnackBar(description: 'Failed Download Document'),
  //     (success) async {
  //       await appDialog.showSuccessSnackBar(
  //         description: 'Success Download Document',
  //       );
  //     },
  //   );
  // }

  void toggleShow() {
    isObsecureText.value = !isObsecureText.value;
  }
}
