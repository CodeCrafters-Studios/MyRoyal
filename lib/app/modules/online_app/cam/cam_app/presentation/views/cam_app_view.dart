import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/others/online_app_icon.dart';

import '../controllers/cam_app_controller.dart';

class CamAppView extends GetView<CamAppController> {
  const CamAppView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        backgroundColor: primary,
        iconTheme: IconThemeData(color: white),
        toolbarHeight: 70.h,
        title: Text(
          'CAM App',
          style: TS.titleSmall.copyWith(color: white),
          textAlign: TextAlign.start,
        ),
      ),
      body: Stack(children: [
        Image.asset(
          'assets/images/img_bg_page.png',
          fit: BoxFit.cover,
        ),
        RPadding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: 10),
              ExpansionTile(
                initiallyExpanded: true,
                collapsedIconColor: primary,
                iconColor: primary,
                title: Text('Tracking', style: TS.titleMedium),
                children: [
                  SizedBox(
                    height: 200,
                    child: GridView.count(
                      shrinkWrap: true,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      children: [
                        OnlineAppIcon(
                          imgUrl: 'assets/icons/ic_cam_reserved_by.svg',
                          title: 'Reserved By',
                          onTap: () => Get.toNamed(Routes.CAM_APP_RESERVED_BY),
                        ),
                        OnlineAppIcon(
                          imgUrl: 'assets/icons/ic_cam_trace_serial.svg',
                          title: 'Trace Serial',
                          onTap: () => Get.toNamed(Routes.CAM_APP_TRACE_SERIAL),
                        ),
                        // OnlineAppIcon(
                        //   imgUrl: 'assets/icons/ic_trace_item.png',
                        //   title: 'Trace Item',
                        //   onTap: () => Get.to(() => ComingSoonScreen()),
                        // ),
                        OnlineAppIcon(
                          imgUrl: 'assets/icons/ic_cam_release_order.svg',
                          title: 'Release Order',
                          onTap: () =>
                              Get.toNamed(Routes.CAM_APP_RELEASE_ORDER),
                        ),
                        // OnlineAppIcon(
                        //   imgUrl: 'assets/icons/ic_trace_pick_slip.png',
                        //   title: 'Trace Pick Slip',
                        //   onTap: () => Get.to(() => ComingSoonScreen()),
                        // ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ]),
    );
  }
}
