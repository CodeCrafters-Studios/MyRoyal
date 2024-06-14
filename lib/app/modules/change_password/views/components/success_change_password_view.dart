import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';

class SuccessChangePasswordView extends StatelessWidget {
  const SuccessChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
        title: '',
        showBackground: false,
        showIconBack: false,
        child: EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppbarSpacer(),
              Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150.h,
                      width: 150.h,
                      child:
                          Image.asset('assets/images/img_change_password.png'),
                    ),
                    20.verticalSpace,
                    Text(
                      'Your Password has been change',
                      style: TS.bodyLarge.copyWith(color: greyIcon),
                    ),
                    10.verticalSpace,
                    Text(
                      'Successfully',
                      style: TS.titleMedium,
                    ),
                  ],
                ),
              ),
              50.verticalSpace,
              ButtonPrimary(
                fullWidth: true,
                margin: REdgeInsets.only(bottom: 20),
                text: 'Go to home',
                onPressed: () => Get.offAllNamed(Routes.BOTTOMNAVBAR),
              )
            ],
          ),
        ));
  }
}
