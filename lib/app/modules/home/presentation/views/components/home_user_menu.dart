import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/loading_main_menu.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/card/card_app.dart';
import 'package:iroyal/base/widgets/padding.dart';

class HomeUserMenu extends GetView<HomeController> {
  const HomeUserMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controller.isLoading.value
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: EPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: ShimmerText(
                          width: 150.w,
                        ),
                      ),
                    )
                  : _buildAllFeatures(),
              CardApp(
                color: Colors.transparent,
                width: Get.width,
                padding: REdgeInsets.all(14),
                child: controller.isLoading.value
                    ? const LoadingMainMenu()
                    : GridView.count(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        children: controller.mainMenu,
                      ),
              ),
            ],
          )),
    );
  }

  Widget _buildAllFeatures() {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: Text('All Features', style: TS.titleMedium),
    );
  }
}
