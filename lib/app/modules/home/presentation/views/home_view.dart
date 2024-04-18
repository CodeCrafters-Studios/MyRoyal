import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/home_user_info.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/home_user_menu.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/home_user_status.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/image.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: false,
        scrolledUnderElevation: 0.0,
        backgroundColor: white,
        automaticallyImplyLeading: false,
        toolbarHeight: 70.h,
        title: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back!👋",
                style: TS.labelLarge,
              ),
              Text(
                "Alghany Kennedy",
                style: TS.labelMedium,
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: EImages(
              name: "assets/images/img_logo.png",
              height: 55.h,
            ),
          )
        ],
      ),
      body: const CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          HomeUserInfo(),
          HomeUserStatus(),
          HomeUserMenu(),
          // HomeListNews(),
        ],
      ),
    );
  }
}
