import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/home_user_card.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/padding.dart';

class HomeUserInfo extends StatelessWidget {
  const HomeUserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: CardApp(
          color: primary,
          isShadow: true,
          shadows: Shadows.small,
          padding: REdgeInsets.all(8),
          margin: const EdgeInsets.all(16),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HomeUserCard(
                title: 'Alghany Kennedy Adam',
                subtitle: '1234567890',
                isThridLine: true,
                isAvatarPicture: true,
                suffixIcon: false,
              ),
            ],
          ),
        ),
        //      CustomCard(
        //   shapeBorder: true,
        //   isAvatarPicture: true,
        //   title: controller.userData.job.workEmail, // controller.email.value,
        //   subtitle:
        //       '${controller.userData.job.employeeNumber} | ${controller.userData.job.position} ${controller.userData.job.section} | ${controller.userData.job.department}',
        //   thridLineTitle:
        //       "Join date: ${controller.userData.job.joinDate.toString().split(' ')[0]}", //"${controller.code.value} | ${controller.name.value}",
        //   isThridLine: true,
        //   suffixIcon: false,
        // ),
      ),
    );
  }
}
