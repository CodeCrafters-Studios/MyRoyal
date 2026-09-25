import 'package:MyRoyal/app/modules/payroll/data/models/generate_code_param_model.dart';
import 'package:MyRoyal/app/modules/payroll/domain/usecases/generate_code_payroll_usecase.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/widgets/buttons/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/payroll/data/models/payroll_data_overview_model.dart';
import 'package:MyRoyal/app/modules/payroll/data/models/payroll_download_url_model.dart';
import 'package:MyRoyal/app/modules/payroll/data/models/payroll_period_params_model.dart';
import 'package:MyRoyal/app/modules/payroll/data/models/payroll_period_model.dart';
import 'package:MyRoyal/app/modules/payroll/domain/entities/payroll_data_overview_entity.dart';
import 'package:MyRoyal/app/modules/payroll/domain/entities/payroll_download_url_entity.dart';
import 'package:MyRoyal/app/modules/payroll/domain/entities/payroll_period_entity.dart';
import 'package:MyRoyal/app/modules/payroll/domain/usecases/get_payroll_periode_usecase.dart';
import 'package:MyRoyal/app/modules/payroll/domain/usecases/payroll_data_overview_usecase.dart';
import 'package:MyRoyal/app/modules/payroll/domain/usecases/payroll_download_url_usecase.dart';
import 'package:MyRoyal/app/modules/profile/domain/usecases/download_file.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';

class PayrollController extends GetxController {
  final DownloadFile downloadFile;
  final AppDialog appDialog;
  final GetPayrollPeriodeUsecase getPayrollPeriodeUsecase;
  final PayrollDownloadUrlUsecase payrollDownloadUrlUsecase;
  final PayrollDataOverviewUsecase payrollDataOverviewUsecase;
  final GenerateCodePayrollUsecase generateCodePayrollUsecase;

  PayrollController({
    required this.downloadFile,
    required this.appDialog,
    required this.getPayrollPeriodeUsecase,
    required this.payrollDownloadUrlUsecase,
    required this.payrollDataOverviewUsecase,
    required this.generateCodePayrollUsecase,
  });

  RxString payrollPeriod = ''.obs;
  RxString selectedPeriodId = ''.obs;
  RxString selectedFilename = ''.obs;
  RxString generateCodeRes = ''.obs;

  RxInt selectedIndex = 0.obs;

  RxBool isLoading = false.obs;
  RxBool isObsecureText = true.obs;
  RxBool isCopied = false.obs;

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

  final bottomPadding = MediaQuery.of(Get.context!).viewInsets.bottom;

  @override
  void onInit() async {
    super.onInit();
    await _getPayrollPeriod();
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

  void selectedPeriod(
      int index, String periodId, String value, String filename) {
    generateCodeRes.value = '';

    selectedIndex.value = index;
    selectedPeriodId.value = periodId;
    payrollPeriod.value = value;
    selectedFilename.value = filename;
  }

  void toggleShow() {
    isObsecureText.value = !isObsecureText.value;
  }

  Future<void> downloadSlipUrl(
      String payrollPeriod, String fileName, String payrollPeriodID) async {
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

Format Password PDF: bersumber dari pembuatan kata sandi
''',
      textButton: 'Unduh',
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
              periodID: payrollPeriodID,
            ),
          );

          result.fold(
            (l) {
              final error = l.properties.first;

              if (error is ApiException) {
                AppUtils.logApp('SERVER ERROR ::: ${error.message}');
              } else {
                AppUtils.logApp('SERVER ERROR ::: $error');
              }
            },
            (r) => appDialog.showSuccessSnackBar(
                description: 'Berhasil Mengunduh Dokumen'),
          );
        } catch (e) {
          AppUtils.logApp("Controller error: $e");
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  Future<void> generateCode(String payrollPeriodID, String valueMonth) async {
    isLoading.value = true;

    await Future.delayed(Duration(milliseconds: 200));

    try {
      final result = await generateCodePayrollUsecase(
        GenerateCodeParamModel(
          valueMonth: valueMonth,
          payrollPeriodId: payrollPeriodID,
        ),
      );

      result.fold((l) {
        final error = l.properties.isNotEmpty ? l.properties.first : null;

        if (error is ApiException) {
          AppUtils.logApp('SERVER ERROR ::: ${error.message}');
        } else {
          AppUtils.logApp('SERVER ERROR ::: $error');
        }
      }, (r) {
        generateCodeRes.value = r.password.toString();
        showModalBottomSheet<void>(
          context: Get.context!,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            padding: EdgeInsets.only(bottom: bottomPadding),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(28.r),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Grab handle bar
                    Center(
                      child: Container(
                        width: 38,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: grey,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),

                    Column(
                      children: [
                        Text(
                          'Kata Sandi',
                          style: TS.titleMedium,
                        ),
                        4.verticalSpace,

                        // Large Code Box
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 13, horizontal: 16),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                generateCodeRes.value,
                                style: TS.headlineMedium,
                              ),
                            ],
                          ),
                        ),
                        12.verticalSpace,

                        Text(
                          'Gunakan password ini untuk membuka slip gaji',
                          style: TS.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        16.verticalSpace,

                        // Action Buttons
                        Obx(
                          () => ButtonPrimary(
                            fullWidth: true,
                            margin: const EdgeInsets.only(bottom: 30),
                            color: isCopied.value ? white : primary,
                            textColor: isCopied.value ? primary : white,
                            borderSide: isCopied.value
                                ? BorderSide(color: primary)
                                : BorderSide.none,
                            onPressed: copyGenerateCode,
                            text: isCopied.value
                                ? 'Berhasil disalin'
                                : 'Salin kata sandi',
                          ),
                        ),
                      ],
                    ),

                    12.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        );
      });
    } catch (e) {
      AppUtils.logApp("Controller error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void copyGenerateCode() {
    Clipboard.setData(ClipboardData(text: generateCodeRes.value));
    isCopied.value = true;

    Future.delayed(const Duration(seconds: 3), () {
      isCopied.value = false;
    });
  }
}
