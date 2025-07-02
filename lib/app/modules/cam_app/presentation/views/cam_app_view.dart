import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/others/coming_soon.dart';

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
                        CamAppIcon(
                          imgUrl: 'assets/icons/ic_reserved_by.png',
                          title: 'Reserved By',
                          onTap: () => Get.toNamed(Routes.CAM_APP_RESERVED_BY),
                        ),
                        CamAppIcon(
                          imgUrl: 'assets/icons/ic_trace_serial.png',
                          title: 'Trace Serial',
                          onTap: () => Get.toNamed(Routes.CAM_APP_TRACE_SERIAL),
                        ),
                        CamAppIcon(
                          imgUrl: 'assets/icons/ic_trace_item.png',
                          title: 'Trace Item',
                          onTap: () => Get.to(ComingSoonScreen()),
                        ),
                        CamAppIcon(
                          imgUrl: 'assets/icons/ic_release_order.png',
                          title: 'Release Order',
                          onTap: () => Get.to(ComingSoonScreen()),
                        ),
                        CamAppIcon(
                          imgUrl: 'assets/icons/ic_trace_pick_slip.png',
                          title: 'Trace Pick Slip',
                          onTap: () => Get.to(ComingSoonScreen()),
                        ),
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

class CamAppIcon extends StatelessWidget {
  const CamAppIcon({
    super.key,
    this.onTap,
    required this.imgUrl,
    required this.title,
  });

  final void Function()? onTap;
  final String imgUrl, title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 54.h,
            padding: REdgeInsets.all(4),
            child: Center(
              child: Image.asset(imgUrl),
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TS.caption,
          ),
        ],
      ),
    );
  }
}
