import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/home/domain/entities/menu.dart';
import 'package:MyRoyal/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';
import 'package:MyRoyal/base/utils/storage/app_storage.dart';
import 'package:MyRoyal/base/widgets/inkwell_tap.dart';
import 'package:MyRoyal/base/widgets/others/coming_soon.dart';

class HomeMenu extends GetView<HomeController> {
  HomeMenu({
    super.key,
    required this.menu,
    required this.appStorage,
  });

  final Menu menu;
  final AppStorage appStorage;

  @override
  Widget build(BuildContext context) {
    return InkWellTap(
      onTap: () async {
        switch (menu.id) {
          case 1:
            Get.toNamed(Routes.DASHBOARD);
            break;
          case 2:
            if (controller.userData.value.data.canSubmissionLeave) {
              Get.toNamed(Routes.LEAVE_SUMMARY);
            } else {
              AppDialogImpl().showErrorDialog(
                title: 'Perhatian',
                description:
                    'Shift kerja belum terdaftar, harap hubungi bagian personalia.',
                textButton: 'Close',
              );
            }
            break;
          // case 'Tasks':
          //   Get.to(() => const ComingSoonScreen());
          //   // Get.toNamed(Routes.TASKS);
          //   break;
          case 3:
            Get.toNamed(Routes.CHECK_PASSWORD);
            break;
          // case 'Visit':
          //   Get.to(() => const ComingSoonScreen());
          //   // Get.toNamed(Routes.VISIT);
          //   break;
          case 4:
            Get.toNamed(Routes.WEBTEL);
            break;
          case 5:
            Get.toNamed(Routes.TRACKING_DOCUMENT);
            break;
          // case 'My Teams':
          //   Get.toNamed(Routes.MY_TEAMS);
          //   break;
          case 6:
            AppDialogImpl().showLiquidGlassDialog(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => controller.getUserJDE(
                        'RAS', controller.userData.value.data.username),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 54.h,
                          padding: REdgeInsets.all(4),
                          child: Center(
                            child: Image.asset('assets/icons/ic_ras_app.png'),
                          ),
                        ),
                        Text(
                          'RAS App',
                          textAlign: TextAlign.center,
                          style: TS.caption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 30),
                  GestureDetector(
                    onTap: () => controller.getUserJDE(
                        'CAM', controller.userData.value.data.username),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 54.h,
                          padding: REdgeInsets.all(4),
                          child: Center(
                            child: Image.asset('assets/icons/ic_cam_app.png'),
                          ),
                        ),
                        Text(
                          'CAM App',
                          textAlign: TextAlign.center,
                          style: TS.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
            break;
          case 7:
            Get.toNamed(Routes.APPROVAL);
            break;
          case 8:
            Get.toNamed(Routes.OCR);
            break;
          default:
            Get.to(() => const ComingSoonScreen());
            break;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 46.h,
            padding: REdgeInsets.all(4),
            child: Center(
              child: SvgPicture.asset('assets/icons/${menu.code}.svg'),
            ),
          ),
          Text(
            menu.name,
            textAlign: TextAlign.center,
            style: TS.caption,
          ),
        ],
      ),
    );
  }
}
