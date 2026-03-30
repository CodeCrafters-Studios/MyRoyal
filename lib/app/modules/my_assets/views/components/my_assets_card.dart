import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/buttons/button_primary.dart';
import 'package:MyRoyal/base/widgets/card/card_app.dart';
import 'package:MyRoyal/base/widgets/padding.dart';

class MyAssetsCard extends StatelessWidget {
  const MyAssetsCard({
    super.key,
    required this.title,
    required this.category,
    required this.serial,
    required this.status,
    this.onTap,
    this.onPressedConfirm,
    this.onPressedReport,
  });

  final String title, category, serial, status;
  final dynamic Function()? onTap, onPressedConfirm, onPressedReport;
  @override
  Widget build(BuildContext context) {
    return CardApp(
      onTap: onTap,
      margin: REdgeInsets.fromLTRB(14, 0, 14, 0),
      padding: EdgeInsets.only(top: 5, bottom: 10),
      borderWidth: 1,
      isOutlined: true,
      width: Get.width,
      isShadow: true,
      shadows: Shadows.small,
      color: white.withOpacity(0.8),
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TS.titleSmall,
            ),
            5.verticalSpace,
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                category,
                style: TS.bodyMedium.copyWith(fontWeight: FontWeight.normal),
              ),
            ),
            15.verticalSpace,
            Text(
              'Serial: $serial',
              style: TS.bodyMedium.copyWith(
                color: greyText,
                fontWeight: FontWeight.normal,
              ),
            ),
            10.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: status == 'Sudah dikonfirmasi'
                    ? green.withOpacity(0.3)
                    : status == 'Belum dikonfirmasi'
                        ? const Color.fromARGB(255, 247, 207, 108)
                            .withOpacity(0.3)
                        : red.withOpacity(0.3),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Text(
                status.toUpperCase(),
                style: TS.bodyMedium.copyWith(
                  color: status == 'Sudah dikonfirmasi'
                      ? green
                      : status == 'Belum dikonfirmasi'
                          ? const Color.fromARGB(255, 150, 115, 29)
                          : red,
                ),
              ),
            ),
            15.verticalSpace,
            status == 'Sudah dikonfirmasi' || status == 'Dilaporkan'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        status == 'Sudah dikonfirmasi'
                            ? Icons.check
                            : Icons.warning,
                        color: status == 'Sudah dikonfirmasi' ? green : red,
                      ),
                      4.horizontalSpace,
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          status == 'Sudah dikonfirmasi'
                              ? 'Terkonfirmasi'
                              : 'Tidak Sesuai Spesifikasi',
                          style: TS.bodySmall.copyWith(
                            color: status == 'Sudah dikonfirmasi' ? green : red,
                            fontWeight: FontWeight.w600,
                          ),
                          softWrap: false,
                          overflow: TextOverflow.visible,
                        ),
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonPrimary(
                        text: 'Konfirmasi',
                        onPressed: onPressedConfirm,
                      ),
                      15.horizontalSpace,
                      ButtonPrimary(
                        text: 'Laporkan',
                        color: red,
                        onPressed: onPressedReport,
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
