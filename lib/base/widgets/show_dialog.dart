import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/card_app.dart';

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
              const SizedBox(),
            const SizedBox(height: 12),
            Text(
              description ?? '',
              style: TS.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
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
            SizedBox(height: 20.h),
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
              const SizedBox(),
            const SizedBox(height: 12),
            Text(
              description ?? '',
              style: TS.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
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
            SizedBox(height: 20.h),
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
                style: TS.titleMedium,
                textAlign: TextAlign.center,
              ),
            const Icon(Icons.close, color: Colors.red),
            24.verticalSpace,
            Text(
              description ?? '',
              style: TS.bodyLarge,
              textAlign: TextAlign.center,
            ),
            ButtonPrimary(
              isOutline: true,
              outlineColor: Colors.transparent,
              textColor: primaryColor,
              onPressed: () {
                Get.back();
                if (onPress != null) {
                  onPress();
                }
              },
              text: labelButton ?? 'TUTUP',
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
              const SizedBox(),
            SizedBox(height: 12.sp),
            Text(
              description ?? '',
              style: TS.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 36.sp),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.sp),
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
            SizedBox(height: 12.sp),
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
              const SizedBox(),
            SizedBox(height: 12.sp),
            Text(
              description ?? '',
              style: TS.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 36.sp),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.sp),
              child: ButtonPrimary(
                key: const Key('yesDialogConfirm'),
                onPressed: onConfirm,
                text: labelPositif ?? 'OK',
                fullWidth: true,
              ),
            ),
            SizedBox(height: 12.sp),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.sp),
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
