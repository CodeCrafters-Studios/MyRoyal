import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/domain/entities/menu.dart';
import 'package:iroyal/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/home_icon_menu.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:shimmer/shimmer.dart';

class HomeUserMenu extends GetView<HomeController> {
  const HomeUserMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SliverToBoxAdapter(
        child: controller.isLoading.value == true
            ? CardApp(
                width: Get.width,
                padding: REdgeInsets.all(14),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: GridView.count(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    children: const [
                      // HomeIconMenu(
                      //   menu: Menu(
                      //     code: 'ic_dashboard',
                      //     name: 'Dashboard',
                      //     isVisible: false,
                      //   ),
                      // ),
                      HomeIconMenu(
                        menu: Menu(
                          code: 'ic_task',
                          name: 'Tasks',
                          isVisible: true,
                        ),
                      ),
                      HomeIconMenu(
                        menu: Menu(
                          code: 'ic_tracking_documents',
                          name: 'Tracking Documents',
                          isVisible: true,
                        ),
                      ),
                      HomeIconMenu(
                        menu: Menu(
                          code: 'ic_visit',
                          name: 'Visit',
                          isVisible: true,
                        ),
                      ),
                      HomeIconMenu(
                        menu: Menu(
                          code: 'ic_teams',
                          name: 'My Teams',
                          isVisible: true,
                        ),
                      ),
                    ],
                  ),
                ))
            : CardApp(
                width: Get.width,
                padding: REdgeInsets.all(14),
                child: GridView.count(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  children: const [
                    // HomeIconMenu(
                    //   menu: Menu(
                    //     code: 'ic_dashboard',
                    //     name: 'Dashboard',
                    //     isVisible: false,
                    //   ),
                    // ),
                    HomeIconMenu(
                      menu: Menu(
                        code: 'ic_task',
                        name: 'Tasks',
                        isVisible: true,
                      ),
                    ),
                    HomeIconMenu(
                      menu: Menu(
                        code: 'ic_tracking_documents',
                        name: 'Tracking Documents',
                        isVisible: true,
                      ),
                    ),
                    HomeIconMenu(
                      menu: Menu(
                        code: 'ic_visit',
                        name: 'Visit',
                        isVisible: true,
                      ),
                    ),
                    HomeIconMenu(
                      menu: Menu(
                        code: 'ic_teams',
                        name: 'My Teams',
                        isVisible: true,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
