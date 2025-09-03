import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/buttons/button_primary_outlined.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class AppDialog {
  Future<bool> showPermissionDialog({
    String? imagePath,
    String title = 'Permission',
    String? description,
    String textYes = 'Yes',
    String textNo = 'No',
  });

  Future<void> showErrorDialog({
    String? imagePath,
    String title = 'Error',
    String? description,
    String textButton = 'Ok',
    Function()? onPress,
  });

  Future<void> showSuccessDialog({
    String? imagePath,
    String title = 'Success',
    String? description,
    String textButton = 'Ok',
    Function()? onPress,
  });

  Future<bool> showChoiceDialog({
    String? imagePath,
    String? title,
    String? description,
    String? textYes,
    String? textNo,
    Color? buttonColor,
    Function()? onPressedYes,
    Function()? onPressedNo,
  });

  Future<void> showErrorSnackBar({
    required String description,
  });

  Future<void> showInfoSnackbar({
    required String description,
    required String title,
    String? assetIcon,
    Function()? onClose,
  });

  Future<void> showInfoDialog({
    String? imagePath,
    String? title,
    String? description,
    String? textButton,
    double? height,
    double? width,
    bool? isLoading,
    Function()? onPress,
  });

  Future<void> showSuccessSnackBar({
    required String description,
  });

  Future<void> showAppVersionInfoDialog({
    String? title,
    String description,
    String? textButton,
    double? height,
    double? width,
    bool isForceUpdateVersion,
    Function()? onPressLater,
    Function()? onPressUpdate,
  });

  Future<void> showCustomInfoDialog({
    String? imagePath,
    String? title,
    String? description,
    String? textButton,
    double? height,
    double? width,
    Function()? onPress,
  });

  Future<void> showForgotPasswordDialog({
    String? imagePath,
    String? title,
    String? phoneNumber,
    String? phoneNumber2,
    String? description,
    String? textButton,
    double? height,
    double? width,
    Function()? onPress,
  });

  Future<void> showEventDialog({
    String? imagePath,
    bool? isImg,
    Function()? onPress,
  });

  Future<void> showLiquidGlassDialog({
    String? imagePath,
    Widget? child,
    Function()? onPress,
  });

  Future<void> showLiquidGlassInfo({
    String? imagePath,
    String title,
  });

  Future<void> showWhatsNewDialog({
    String? title,
    String? description,
    String? textButton,
    double? height,
    double? width,
    List<Widget>? children,
    Function()? onPress,
  });

  Future<void> showLoading({String title});
}

class AppDialogImpl implements AppDialog {
  @override
  Future<bool> showChoiceDialog({
    String? imagePath,
    String? title,
    String? description,
    String? textYes,
    String? textNo,
    Color? buttonColor,
    Function()? onPressedYes,
    Function()? onPressedNo,
  }) async {
    final r = await Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: REdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            Insets.xl,
            Insets.xl,
            Insets.xl,
            Insets.xs,
          ),
          decoration: BoxDecoration(
            borderRadius: Corners.smBorder,
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? 'Confirmation',
                style: TS.titleMedium,
                textAlign: TextAlign.center,
              ),
              if (imagePath != null)
                Image.asset(
                  imagePath,
                  height: 150.w,
                  width: 150.w,
                ),
              12.verticalSpace,
              if (description != null)
                Text(
                  description,
                  style: TS.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              description != null ? 28.verticalSpace : 20.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: ButtonPrimary(
                      color: buttonColor ?? primary,
                      onPressed: onPressedYes ?? () => Get.back(result: true),
                      text: textYes ?? 'Yes',
                      fullWidth: true,
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: ButtonPrimaryOutlined(
                      onPressed: onPressedNo ?? () => Get.back(result: false),
                      text: textNo ?? 'No',
                      textColor: primary,
                      isOutline: true,
                      fullWidth: true,
                      outlineColor: primary,
                    ),
                  ),
                ],
              ),
              16.verticalSpace,
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
    return r != null && r == true;
  }

  @override
  Future<void> showSuccessDialog({
    String? imagePath,
    String title = 'Success',
    String? description,
    String textButton = 'Continue',
    Function()? onPress,
  }) async {
    await Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: REdgeInsets.symmetric(horizontal: 40),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            Insets.med,
            Insets.xl,
            Insets.med,
            Insets.xs,
          ),
          decoration: BoxDecoration(
            borderRadius: Corners.smBorder,
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imagePath ?? 'assets/icons/ic_success.png',
                height: 50.w,
                width: 50.w,
              ),
              10.verticalSpace,
              Text(
                title,
                style: TS.titleMedium.copyWith(color: green),
                textAlign: TextAlign.center,
              ),
              10.verticalSpace,
              if (description != null)
                Text(
                  description,
                  style: TS.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              28.verticalSpace,
              ButtonPrimary(
                onPressed: onPress ?? Get.back,
                text: textButton,
                fullWidth: true,
                color: green,
              ),
              16.verticalSpace,
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Future<void> showErrorDialog({
    String? imagePath,
    String title = 'Error!',
    String? description = 'Please try again to complete the request',
    String textButton = 'Try Again',
    Function()? onPress,
  }) async {
    await Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: REdgeInsets.symmetric(horizontal: 40),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            Insets.med,
            Insets.xl,
            Insets.med,
            Insets.xs,
          ),
          decoration: BoxDecoration(
            borderRadius: Corners.smBorder,
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                imagePath ?? 'assets/json/lottie_error_dialog.json',
                height: 85.w,
                width: 85.w,
              ),
              10.verticalSpace,
              Text(
                title,
                style: TS.titleMedium.copyWith(color: red),
                textAlign: TextAlign.center,
              ),
              10.verticalSpace,
              if (description != null)
                Text(
                  description,
                  style: TS.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              28.verticalSpace,
              ButtonPrimary(
                onPressed: onPress ?? Get.back,
                text: textButton,
                fullWidth: true,
                color: red,
              ),
              16.verticalSpace,
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Future<bool> showPermissionDialog({
    String? imagePath,
    String title = 'Permission',
    String? description,
    String textYes = 'Yes',
    String textNo = 'No',
  }) async {
    final r = await Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: REdgeInsets.symmetric(horizontal: 40),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            Insets.med,
            Insets.xl,
            Insets.med,
            Insets.xs,
          ),
          decoration: BoxDecoration(
            borderRadius: Corners.smBorder,
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TS.titleMedium,
                textAlign: TextAlign.center,
              ),
              if (imagePath != null)
                Image.asset(
                  imagePath,
                  height: 150.w,
                  width: 150.w,
                ),
              12.verticalSpace,
              if (description != null)
                Text(
                  description,
                  style: TS.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              28.verticalSpace,
              ButtonPrimary(
                onPressed: () => Get.back(result: true),
                text: textYes,
                fullWidth: true,
              ),
              12.verticalSpace,
              ButtonPrimaryOutlined(
                onPressed: () => Get.back(result: false),
                text: textNo,
                fullWidth: true,
              ),
              16.verticalSpace,
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
    return r != null && r == true;
  }

  @override
  Future<void> showInfoDialog({
    String? imagePath,
    String? title,
    String? description,
    String? textButton,
    double? height,
    double? width,
    bool? isLoading,
    Function()? onPress,
  }) async {
    await Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: REdgeInsets.symmetric(horizontal: 40),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            Insets.med,
            Insets.xl,
            Insets.med,
            Insets.xs,
          ),
          decoration: BoxDecoration(
            borderRadius: Corners.smBorder,
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (imagePath != null)
                  SvgPicture.asset(
                    imagePath,
                    height: height ?? 40.w,
                    width: width ?? 40.w,
                  ),
                description == null ? 28.verticalSpace : 5.verticalSpace,
                Text(
                  title ?? 'Information',
                  style: TS.titleMedium,
                  textAlign: TextAlign.center,
                ),
                12.verticalSpace,
                if (description != null)
                  Text(
                    description,
                    style: TS.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                28.verticalSpace,
                ButtonPrimary(
                  onPressed: onPress ?? Get.back,
                  text: textButton ?? 'Okay',
                  fullWidth: true,
                  isLoading: isLoading ?? false,
                ),
                16.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> showErrorSnackBar({
    required String description,
  }) async {
    if (Get.isSnackbarOpen) {
      return;
    }
    Get.snackbar(
      '',
      '',
      backgroundColor: errorColor,
      borderRadius: 10,
      colorText: Colors.white,
      duration: const Duration(milliseconds: 1500),
      margin: REdgeInsets.only(top: 20, left: 20, right: 20),
      maxWidth: Get.width * .8,
      animationDuration: const Duration(milliseconds: 500),
      snackStyle: SnackStyle.FLOATING,
      messageText: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/ic_danger.png',
              width: 20.w,
              height: 20.h,
            ),
            10.horizontalSpace,
            Text(
              description,
              style: TS.caption.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      titleText: const SizedBox(),
      padding: REdgeInsets.all(12),
      dismissDirection: DismissDirection.vertical,
    );
  }

  @override
  Future<void> showInfoSnackbar({
    required String description,
    required String title,
    String? assetIcon,
    Function()? onClose,
  }) async {
    if (Get.isSnackbarOpen) {
      return;
    }
    Get.snackbar(
      '',
      '',
      backgroundColor: Colors.white,
      borderRadius: 10,
      colorText: Colors.white,
      duration: const Duration(milliseconds: 1500),
      margin: REdgeInsets.only(top: 40, left: 20, right: 20),
      maxWidth: Get.width * .8,
      animationDuration: const Duration(milliseconds: 500),
      snackStyle: SnackStyle.FLOATING,
      messageText: Center(
        child: Row(
          children: [
            if (assetIcon != null)
              Image.asset(
                assetIcon,
                width: 36.w,
                height: 36.w,
              ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TS.titleSmall.copyWith(color: primaryColor),
                  ),
                  Text(
                    description,
                    style: TS.labelMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      titleText: const SizedBox(),
      padding: REdgeInsets.all(12),
      dismissDirection: DismissDirection.vertical,
    );
  }

  @override
  Future<void> showSuccessSnackBar({
    required String description,
  }) async {
    if (Get.isSnackbarOpen) {
      return;
    }
    Get.snackbar(
      '',
      '',
      backgroundColor: successColor,
      borderRadius: 10,
      colorText: Colors.white,
      duration: const Duration(milliseconds: 1500),
      margin: REdgeInsets.only(top: 20, left: 20, right: 20),
      maxWidth: Get.width * .8,
      animationDuration: const Duration(milliseconds: 500),
      snackStyle: SnackStyle.FLOATING,
      messageText: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check,
              color: white,
            ),
            10.horizontalSpace,
            Text(
              description,
              style: TS.caption.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      titleText: const SizedBox(),
      padding: REdgeInsets.all(12),
      dismissDirection: DismissDirection.vertical,
    );
  }

  @override
  Future<void> showAppVersionInfoDialog({
    String? title,
    String description = '',
    String? textButton,
    double? height,
    double? width,
    bool isForceUpdateVersion = false,
    Function()? onPressLater,
    Function()? onPressUpdate,
  }) async {
    await Get.dialog(
      PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: REdgeInsets.symmetric(horizontal: 40),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              Insets.med,
              Insets.xl,
              Insets.med,
              Insets.xs,
            ),
            decoration: BoxDecoration(
              borderRadius: Corners.smBorder,
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? 'Information',
                  style: TS.titleMedium,
                ),
                15.verticalSpace,
                Text(
                  description,
                  style: TS.bodyMedium,
                ),
                28.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    isForceUpdateVersion
                        ? emptyBox
                        : TextButton(
                            onPressed: onPressLater,
                            child: Text(
                              'Later',
                              style: TS.titleSmall.copyWith(color: red),
                            ),
                          ),
                    15.horizontalSpace,
                    InkWell(
                      onTap: onPressUpdate,
                      child: Container(
                        padding: REdgeInsets.fromLTRB(12, 8, 12, 8),
                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Text(
                          'Update',
                          style: TS.titleSmall.copyWith(color: white),
                        ),
                      ),
                    ),
                  ],
                ),
                5.verticalSpace,
                const Divider(color: grey),
                5.verticalSpace,
                Row(
                  children: [
                    Image.asset(
                      height: 30.w,
                      'assets/images/img_googleplay.png',
                    ),
                    10.horizontalSpace,
                    Text(
                      'Google Play',
                      style: TS.titleMedium.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
                16.verticalSpace,
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Future<void> showCustomInfoDialog(
      {String? imagePath,
      String? title,
      String? description,
      String? textButton,
      double? height,
      double? width,
      Function()? onPress}) async {
    await Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: REdgeInsets.symmetric(horizontal: 10),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            Insets.med,
            Insets.xl,
            Insets.med,
            Insets.xs,
          ),
          decoration: BoxDecoration(
            borderRadius: Corners.smBorder,
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? 'Information',
                style: TS.titleSmall,
                textAlign: TextAlign.center,
              ),
              if (imagePath != null)
                Lottie.asset(
                  imagePath,
                  height: height,
                  width: width,
                ),
              if (description != null) 12.verticalSpace,
              if (description != null)
                Text(
                  description,
                  style: TS.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ButtonPrimary(
                onPressed: onPress ?? Get.back,
                text: textButton ?? 'Okay',
                fullWidth: true,
              ),
              16.verticalSpace,
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Future<void> showForgotPasswordDialog({
    String? imagePath,
    String? title,
    String? phoneNumber,
    String? phoneNumber2,
    String? description,
    String? textButton,
    double? height,
    double? width,
    Function()? onPress,
  }) async {
    await Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: REdgeInsets.symmetric(horizontal: 40),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            Insets.med,
            Insets.xl,
            Insets.med,
            Insets.xs,
          ),
          decoration: BoxDecoration(
            borderRadius: Corners.smBorder,
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imagePath != null)
                SvgPicture.asset(
                  imagePath,
                  height: height ?? 40.w,
                  width: width ?? 40.w,
                ),
              description == null ? 28.verticalSpace : 5.verticalSpace,
              Text(
                title ?? 'Information',
                style: TS.titleMedium,
                textAlign: TextAlign.center,
              ),
              12.verticalSpace,
              if (description != null)
                Text.rich(
                  TextSpan(
                    text: description,
                    style: TS.bodyMedium,
                    children: [
                      TextSpan(
                          text: '\n\nCall',
                          style: TS.bodyMedium.copyWith(color: primary),
                          children: [
                            TextSpan(
                              text: ' $phoneNumber',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  String url = "https://wa.me/628112465515";
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url),
                                        mode: LaunchMode.externalApplication);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                              style: TS.bodyMedium.copyWith(color: Colors.blue),
                              children: [
                                TextSpan(
                                    text: ' or ',
                                    style:
                                        TS.bodyMedium.copyWith(color: primary),
                                    children: [
                                      TextSpan(
                                        text: '$phoneNumber2',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            String url =
                                                "https://wa.me/6281120005071";
                                            if (await canLaunchUrl(
                                                Uri.parse(url))) {
                                              await launchUrl(Uri.parse(url),
                                                  mode: LaunchMode
                                                      .externalApplication);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          },
                                        style: TS.bodyMedium
                                            .copyWith(color: Colors.blue),
                                      ),
                                    ]),
                              ],
                            )
                          ]),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              28.verticalSpace,
              ButtonPrimary(
                onPressed: onPress ?? Get.back,
                text: textButton ?? 'Okay',
                fullWidth: true,
              ),
              16.verticalSpace,
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Future<void> showEventDialog({
    String? imagePath,
    bool? isImg,
    Function()? onPress,
  }) async {
    await Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: REdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isImg == true
                ? Image.asset(imagePath.toString())
                : Lottie.asset(
                    imagePath.toString(),
                    height: 500.h,
                  ),
            15.verticalSpace,
            InkWellTap(
              radius: Corners.xxl,
              color: Colors.transparent,
              onTap: () => Get.back(),
              child: Image.asset(
                'assets/images/img_icon_close_banner.png',
                height: 48.h,
              ),
            )
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Future<void> showLiquidGlassDialog(
      {String? imagePath, Widget? child, Function()? onPress}) async {
    await Get.dialog(
      barrierColor: Colors.white12.withOpacity(0.2),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: REdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: 100,
            height: 225,
            padding: EdgeInsets.fromLTRB(
              Insets.med,
              Insets.med,
              Insets.med,
              Insets.xs,
            ),
            decoration: BoxDecoration(
              borderRadius: Corners.smBorder,
              color: Color(0xFFC0C0C0).withOpacity(0.25),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Future<void> showLiquidGlassInfo({
    String? imagePath,
    String? title,
  }) async {
    await Get.dialog(
      barrierColor: Colors.white12.withOpacity(0.2),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: REdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 120,
            width: 60,
            padding: EdgeInsets.all(
              Insets.med,
            ),
            decoration: BoxDecoration(
              borderRadius: Corners.smBorder,
              color: Color(0xFFC0C0C0).withOpacity(0.25),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (imagePath != null)
                  SvgPicture.asset(
                    imagePath,
                    height: 45.w,
                    width: 45.w,
                  ),
                SizedBox(height: 5),
                if (title != null)
                  Text(
                    title,
                    style: TS.titleMedium,
                    textAlign: TextAlign.center,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> showLoading({String title = 'Please Wait'}) async {
    await Get.dialog(
      PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          elevation: 0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                height: 55,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SpinKitWave(
                      color: primary,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      title,
                      style: TS.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  @override
  Future<void> showWhatsNewDialog({
    String? title,
    String? description,
    String? textButton,
    double? height,
    double? width,
    List<Widget>? children,
    Function()? onPress,
  }) async {
    await Get.dialog(
      barrierColor: Colors.transparent,
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: REdgeInsets.symmetric(horizontal: 10),
        child: Container(
          padding: EdgeInsets.all(
            Insets.xl,
          ),
          decoration: BoxDecoration(
            borderRadius: Corners.smBorder,
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  Text(
                    title ?? 'Information',
                    style: TS.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    description ?? '',
                    style: TS.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: children ?? [],
              ),
              SizedBox(height: 20),
              ButtonPrimary(
                onPressed: onPress ?? Get.back,
                text: textButton ?? 'Lanjutkan',
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
