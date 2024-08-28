import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/padding.dart';

void showPopUpInfo({
  String? title,
  String? description,
  String? labelButton,
  String? imageUri,
  double? imageSize,
  bool? dismissible,
  Function()? onPress,
}) {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 40.sp),
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
              title ?? '',
              style: TS.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (imageUri != null)
              Image.asset(
                imageUri,
                height: imageSize ?? IconSizes.xxl,
                width: imageSize ?? IconSizes.xxl,
              )
            else
              emptyBox,
            12.verticalSpace,
            Text(
              description ?? '',
              style: TS.bodyMedium,
              textAlign: TextAlign.center,
            ),
            28.verticalSpace,
            ButtonPrimary(
              onPressed: () {
                Get.back();
                if (onPress != null) {
                  onPress();
                }
              },
              text: labelButton ?? 'OK',
              fullWidth: true,
            ),
            20.verticalSpace,
          ],
        ),
      ),
    ),
    barrierDismissible: dismissible ?? true,
  );
}

void showPopUpSuccess({
  String? title,
  String? description,
  String? labelButton,
  String? imageUri,
  double? imageSize,
  bool? dismissible,
  Function()? onPress,
}) {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 40.sp),
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
              title ?? '',
              style: TS.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (imageUri != null)
              Image.asset(
                imageUri,
                height: imageSize ?? IconSizes.xxl,
                width: imageSize ?? IconSizes.xxl,
              )
            else
              emptyBox,
            12.verticalSpace,
            Text(
              description ?? '',
              style: TS.bodyMedium,
              textAlign: TextAlign.center,
            ),
            28.verticalSpace,
            ButtonPrimary(
              onPressed: () {
                Get.back();
                if (onPress != null) {
                  onPress();
                }
              },
              text: labelButton ?? 'OK',
              fullWidth: true,
            ),
            20.verticalSpace,
          ],
        ),
      ),
    ),
    barrierDismissible: dismissible ?? true,
  );
}

void showPopUpFailed({
  String? title,
  String? description,
  String? labelButton,
  String? imageUri,
  double? imageSize,
  bool? dismissible,
  Function()? onPress,
}) {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 40.sp),
      child: CardApp(
        padding: EdgeInsets.fromLTRB(
          Insets.lg,
          Insets.xl,
          Insets.lg,
          Insets.xs,
        ),
        radius: 24.r,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Text(
                title,
                style: TS.titleMedium.copyWith(color: red),
                textAlign: TextAlign.center,
              ),
            10.verticalSpace,
            Text(
              description ?? '',
              style: TS.bodyLarge,
              textAlign: TextAlign.center,
            ),
            25.verticalSpace,
            ButtonPrimary(
              margin: REdgeInsets.only(bottom: 10),
              color: Colors.red,
              textColor: white,
              onPressed: () {
                Get.back();
                Get.back();
                if (onPress != null) {
                  onPress();
                }
              },
              text: labelButton ?? 'Close',
              fullWidth: true,
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: dismissible ?? true,
  );
}

Future<void> showPopUpChoice({
  String? title,
  String? description,
  String? labelNegatif,
  String? labelPositif,
  String? imageUri,
  double? imageSize,
  bool? dismissible,
  Function()? onConfirm,
  Function()? onCancel,
}) async {
  await Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 48.sp),
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.xl),
        decoration: BoxDecoration(
          borderRadius: Corners.medBorder,
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title ?? 'Konfirmasi',
              style: TS.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (imageUri != null)
              Image.asset(
                imageUri,
                height: imageSize ?? IconSizes.xxl,
                width: imageSize ?? IconSizes.xxl,
              )
            else
              emptyBox,
            12.verticalSpace,
            Text(
              description ?? '',
              style: TS.bodyMedium,
              textAlign: TextAlign.center,
            ),
            36.verticalSpace,
            EPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ButtonPrimary(
                onPressed: () {
                  Get.back();
                  if (onConfirm != null) {
                    onConfirm();
                  }
                },
                text: labelPositif ?? 'OK',
                fullWidth: true,
              ),
            ),
            12.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.sp),
              child: ButtonPrimary(
                isOutline: true,
                outlineColor: Colors.transparent,
                textColor: primaryColor,
                onPressed: () {
                  Get.back();
                  if (onCancel != null) {
                    onCancel();
                  }
                },
                text: labelNegatif ?? 'cancel'.tr,
                fullWidth: true,
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: dismissible ?? true,
  );
}

Future showPopUpPermission({
  String? title,
  String? description,
  String? labelNegatif,
  String? labelPositif,
  String? imageUri,
  double? imageSize,
  required Function() onConfirm,
  required Function() onCancel,
}) async {
  await Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 48.sp),
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.xl),
        decoration: BoxDecoration(
          borderRadius: Corners.medBorder,
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title ?? 'Konfirmasi',
              style: TS.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (imageUri != null)
              Image.asset(
                imageUri,
                height: imageSize ?? IconSizes.xxl,
                width: imageSize ?? IconSizes.xxl,
              )
            else
              emptyBox,
            12.verticalSpace,
            Text(
              description ?? '',
              style: TS.bodyMedium,
              textAlign: TextAlign.center,
            ),
            36.verticalSpace,
            EPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ButtonPrimary(
                key: const Key('yesDialogConfirm'),
                onPressed: onConfirm,
                text: labelPositif ?? 'OK',
                fullWidth: true,
              ),
            ),
            12.verticalSpace,
            EPadding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ButtonPrimary(
                key: const Key('noDialogConfirm'),
                isOutline: true,
                outlineColor: Colors.transparent,
                textColor: primaryColor,
                onPressed: onCancel,
                text: labelNegatif ?? 'cancel'.tr,
                fullWidth: true,
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
