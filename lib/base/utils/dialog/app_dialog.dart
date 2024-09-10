import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/buttons/button_primary_outlined.dart';

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
    String title,
    String? description,
    String textButton,
    Function()? onPress,
  });

  Future<void> showSuccessSnackBar({
    required String description,
  });
}

class AppDialogImpl implements AppDialog {
  @override
  Future<bool> showChoiceDialog({
    String? imagePath,
    String? title,
    String? description,
    String? textYes,
    String? textNo,
    Function()? onPressedYes,
    Function()? onPressedNo,
  }) async {
    final r = await Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: REdgeInsets.symmetric(horizontal: 40),
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
              28.verticalSpace,
              Row(
                children: [
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
                  12.horizontalSpace,
                  Expanded(
                    child: ButtonPrimary(
                      onPressed: onPressedYes ?? () => Get.back(result: true),
                      text: textYes ?? 'Yes',
                      fullWidth: true,
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
              Image.asset(
                imagePath ?? 'assets/icons/ic_error.png',
                height: 50.w,
                width: 50.w,
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
                color: redPrimary,
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
}
