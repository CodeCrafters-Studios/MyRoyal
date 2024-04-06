import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
}

class AppDialogImpl implements AppDialog {
  @override
  Future<bool> showChoiceDialog({
    String? imagePath,
    String? title,
    String? description,
    String? textYes,
    String? textNo,
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
                title ?? 'confirmation'.tr,
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
                      onPressed: () => Get.back(result: false),
                      text: textNo ?? 'no'.tr,
                      fullWidth: true,
                      outlineColor: Colors.transparent,
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: ButtonPrimary(
                      onPressed: () => Get.back(result: true),
                      text: textYes ?? 'yes'.tr,
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
  Future<void> showErrorDialog({
    String? imagePath,
    String title = 'Error',
    String? description,
    String textButton = 'Ok',
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
                onPressed: onPress ?? Get.back,
                text: textButton,
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
  Future<void> showSuccessDialog({
    String? imagePath,
    String title = 'Success',
    String? description,
    String textButton = 'Okay',
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
                onPressed: onPress ?? Get.back,
                text: textButton,
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
      margin: REdgeInsets.only(top: 40, left: 20, right: 20),
      maxWidth: Get.width * .8,
      animationDuration: const Duration(milliseconds: 500),
      snackStyle: SnackStyle.FLOATING,
      messageText: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/ic_danger.png',
              width: 20,
              height: 20,
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
      padding: const EdgeInsets.all(12),
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
      padding: const EdgeInsets.all(12),
      dismissDirection: DismissDirection.vertical,
    );
  }
}
