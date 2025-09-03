import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iroyal/app/modules/my_assets/views/components/my_assets_card.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';
import 'package:signature/signature.dart';
import '../controllers/my_assets_controller.dart';

class MyAssetsView extends GetView<MyAssetsController> {
  const MyAssetsView({super.key});
  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'Daftar Assets IT',
      child: Obx(
        () => SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppbarSpacer(),
              5.verticalSpace,
              EPadding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  'Filter berdasarkan Status',
                  style: TS.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: greyText,
                  ),
                ),
              ),
              10.verticalSpace,
              EPadding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: Get.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: grey),
                      borderRadius: BorderRadius.circular(8)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isDense: true,
                      padding: EdgeInsets.zero,
                      dropdownColor: white,
                      items: controller.status
                          .toSet()
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value.isNotEmpty ? value : null,
                          child: Text(
                            value,
                            style: TS.bodyMedium,
                          ),
                        );
                      }).toList(),
                      value: controller.selectedStatusValue.value,
                      style: TS.bodyMedium.copyWith(
                        color: black,
                        fontWeight: FontWeight.w300,
                      ),
                      onChanged: (newValue) {
                        AppUtils.logApp(newValue.toString());
                        controller.filterDataAssets(newValue.toString());
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: black,
                      ),
                    ),
                  ),
                ),
              ),
              15.verticalSpace,
              Divider(color: grey),
              SizedBox(
                height: Get.height,
                child: RefreshIndicator(
                  backgroundColor: white,
                  color: primary,
                  onRefresh: controller.onRefresh,
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 5, bottom: 220),
                    itemCount: controller.filterdataAssets.length,
                    separatorBuilder: (_, __) => SizedBox(height: 15),
                    itemBuilder: (context, index) => MyAssetsCard(
                      title: controller.filterdataAssets[index]['title'],
                      category: controller.filterdataAssets[index]['category'],
                      serial: controller.filterdataAssets[index]['serial'],
                      status: controller.filterdataAssets[index]['status'],
                      onPressedConfirm: () => Get.dialog(
                        Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: REdgeInsets.all(10),
                          child: Container(
                            padding: EdgeInsets.all(Insets.xl),
                            decoration: BoxDecoration(
                              borderRadius: Corners.smBorder,
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    'Konfirmasi Penerimaan Asset',
                                    style: TS.titleMedium,
                                  ),
                                ),
                                10.verticalSpace,
                                Center(
                                  child: Text(
                                    'Tanda Tangan digital diperlukan',
                                    style: TS.bodyMedium,
                                  ),
                                ),
                                15.verticalSpace,
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: grey50.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(14)),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Nama Asset:',
                                            style: TS.bodyMedium
                                                .copyWith(color: greyText),
                                          ),
                                          Text(
                                            controller.filterdataAssets[index]
                                                ['title'],
                                            style: TS.bodyMedium.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      5.verticalSpace,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Tipe:',
                                            style: TS.bodyMedium
                                                .copyWith(color: greyText),
                                          ),
                                          Text(
                                            controller.filterdataAssets[index]
                                                ['category'],
                                            style: TS.bodyMedium.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      5.verticalSpace,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Serial Number:',
                                            style: TS.bodyMedium
                                                .copyWith(color: greyText),
                                          ),
                                          Text(
                                            controller.filterdataAssets[index]
                                                ['serial'],
                                            style: TS.bodyMedium.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                15.verticalSpace,
                                Text(
                                  'Tanda Tangan Digital:',
                                  style: TS.titleSmall,
                                  textAlign: TextAlign.start,
                                ),
                                10.verticalSpace,
                                DottedBorder(
                                  options: RectDottedBorderOptions(
                                    color: grey,
                                    dashPattern: [6, 6, 6, 6],
                                    strokeWidth: 2,
                                    borderPadding: EdgeInsets.all(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    child: Signature(
                                      controller:
                                          controller.signatureController,
                                      width: Get.width,
                                      height: 200,
                                      backgroundColor: grey50.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                                15.verticalSpace,
                                Obx(
                                  () => Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async => controller
                                            .signatureController
                                            .clear(),
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: red,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'Hapus',
                                            style: TS.bodyMedium
                                                .copyWith(color: white),
                                          ),
                                        ),
                                      ),
                                      10.horizontalSpace,
                                      CircleAvatar(
                                        radius: 8,
                                        backgroundColor:
                                            controller.isSignatureEmpty.value
                                                ? red
                                                : green,
                                      ),
                                      10.horizontalSpace,
                                      Text(
                                        controller.isSignatureEmpty.value
                                            ? 'Belum ada tanda tangan'
                                            : 'Tanda tangan valid',
                                        style: TS.bodyMedium
                                            .copyWith(color: greyText),
                                      )
                                    ],
                                  ),
                                ),
                                15.verticalSpace,
                                Center(
                                  child: Text(
                                    'Gunakan jari atau stylus untuk menggambar tanda tangan',
                                    style:
                                        TS.bodyMedium.copyWith(color: greyText),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                15.verticalSpace,
                                Row(
                                  children: [
                                    Expanded(
                                      child: ButtonPrimary(
                                        color: grey,
                                        onPressed: () => Get.back(result: true),
                                        text: 'Batal',
                                        fullWidth: true,
                                      ),
                                    ),
                                    12.horizontalSpace,
                                    Expanded(
                                      child: ButtonPrimary(
                                        onPressed: () async {
                                          controller.signature =
                                              await controller
                                                  .signatureController
                                                  .toPngBytes();
                                          final time = DateTime.now()
                                              .toIso8601String()
                                              .replaceAll('.', ':');
                                          final result =
                                              await ImageGallerySaverPlus
                                                  .saveImage(
                                                      controller.signature!,
                                                      name: 'signature_$time');
                                          AppUtils.logApp(result.toString());
                                          if (result['isSuccess']) {
                                            AppDialogImpl().showSuccessSnackBar(
                                                description:
                                                    'Ttd digital berhasil disimpan');
                                            controller.signatureController
                                                .clear();
                                            Get.back();
                                          }
                                        },
                                        text: 'Konfirmasi',
                                        textColor: white,
                                        fullWidth: true,
                                        outlineColor: primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      onPressedReport: () => Get.dialog(
                        Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: REdgeInsets.all(10),
                          child: Obx(
                            () => Container(
                              padding: EdgeInsets.all(Insets.xl),
                              decoration: BoxDecoration(
                                borderRadius: Corners.smBorder,
                                color: Colors.white,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        'Laporkan Ketidaksesuaian Asset',
                                        style: TS.titleMedium,
                                      ),
                                    ),
                                    10.verticalSpace,
                                    Center(
                                      child: Text(
                                        'Berikan detail masalah yang ditemukan',
                                        style: TS.bodyMedium,
                                      ),
                                    ),
                                    15.verticalSpace,
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: grey50.withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Nama Asset:',
                                                style: TS.bodyMedium
                                                    .copyWith(color: greyText),
                                              ),
                                              Text(
                                                controller
                                                        .filterdataAssets[index]
                                                    ['title'],
                                                style: TS.bodyMedium.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          5.verticalSpace,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Tipe:',
                                                style: TS.bodyMedium
                                                    .copyWith(color: greyText),
                                              ),
                                              Text(
                                                controller
                                                        .filterdataAssets[index]
                                                    ['category'],
                                                style: TS.bodyMedium.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          5.verticalSpace,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Serial Number:',
                                                style: TS.bodyMedium
                                                    .copyWith(color: greyText),
                                              ),
                                              Text(
                                                controller
                                                        .filterdataAssets[index]
                                                    ['serial'],
                                                style: TS.bodyMedium.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    15.verticalSpace,
                                    Text(
                                      'Jenis Ketidaksesuaian:',
                                      style: TS.titleSmall,
                                      textAlign: TextAlign.start,
                                    ),
                                    10.verticalSpace,
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: grey),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          isDense: true,
                                          padding: EdgeInsets.zero,
                                          dropdownColor: white,
                                          items: controller.reportType
                                              .toSet()
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value.isNotEmpty
                                                  ? value
                                                  : null,
                                              child: Text(
                                                value,
                                                style: TS.bodyMedium,
                                              ),
                                            );
                                          }).toList(),
                                          value: controller
                                              .selectedReportTypeValue.value,
                                          style: TS.bodyMedium.copyWith(
                                            color: black,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          onChanged: (newValue) {
                                            controller.selectedReportTypeValue
                                                .value = newValue.toString();
                                          },
                                          icon: const Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            color: black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    15.verticalSpace,
                                    Text(
                                      'Detail Masalah:',
                                      style: TS.titleSmall,
                                      textAlign: TextAlign.start,
                                    ),
                                    10.verticalSpace,
                                    InputPrimary(
                                      maxLines: 4,
                                      color: grey50.withOpacity(0.8),
                                    ),
                                    15.verticalSpace,
                                    Text(
                                      'Bukti Foto (Optional):',
                                      style: TS.titleSmall,
                                      textAlign: TextAlign.start,
                                    ),
                                    10.verticalSpace,
                                    controller.selectedImage.value == null
                                        ? DottedBorder(
                                            options: RectDottedBorderOptions(
                                              color: grey,
                                              dashPattern: [6, 6, 6, 6],
                                              strokeWidth: 2,
                                              borderPadding: EdgeInsets.all(8),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              child: Container(
                                                width: Get.width,
                                                height: 150,
                                                color: grey50.withOpacity(0.8),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () => controller
                                                          .pickImage(ImageSource
                                                              .gallery),
                                                      child: DottedBorder(
                                                        options:
                                                            RectDottedBorderOptions(
                                                          color: grey,
                                                          dashPattern: [
                                                            6,
                                                            6,
                                                            6,
                                                            6
                                                          ],
                                                          strokeWidth: 2,
                                                          borderPadding:
                                                              EdgeInsets.all(8),
                                                        ),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle),
                                                          child: Icon(
                                                            Icons.add,
                                                            color: grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    12.verticalSpace,
                                                    Text(
                                                      "Klik icon '+' untuk mengunggah foto",
                                                      style: TS.bodySmall,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : DottedBorder(
                                            options: RectDottedBorderOptions(
                                              color: grey,
                                              dashPattern: [6, 6, 6, 6],
                                              strokeWidth: 2,
                                              borderPadding: EdgeInsets.all(8),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              child: Container(
                                                  width: Get.width,
                                                  color:
                                                      grey50.withOpacity(0.8),
                                                  child: Center(
                                                    child: Image.file(
                                                      controller
                                                          .selectedImage.value!,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )),
                                            ),
                                          ),
                                    15.verticalSpace,
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ButtonPrimary(
                                            color: grey,
                                            onPressed: () =>
                                                controller.cancelReport(),
                                            text: 'Batal',
                                            fullWidth: true,
                                          ),
                                        ),
                                        12.horizontalSpace,
                                        Expanded(
                                          child: ButtonPrimary(
                                            onPressed: () =>
                                                controller.sentReport(),
                                            text: 'Kirim laporan',
                                            textColor: white,
                                            fullWidth: true,
                                            color: red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
