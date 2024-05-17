import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/app_divider.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';

import '../controllers/help_and_support_controller.dart';

class HelpAndSupportView extends GetView<HelpAndSupportController> {
  const HelpAndSupportView({super.key});
  @override
  Widget build(BuildContext context) {
    return HelpAndSupportViewImpl(controller: controller);
  }
}

class HelpAndSupportViewImpl extends StatelessWidget {
  const HelpAndSupportViewImpl({
    super.key,
    required this.controller,
  });

  final HelpAndSupportController controller;

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'Help & Support',
      child: SingleChildScrollView(
        child: EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppbarSpacer(),
              Text(
                'Hello! How can we help you today?',
                style: TS.titleLarge,
                textAlign: TextAlign.start,
              ),
              10.verticalSpace,
              Text(
                "Do you have any questions? Need an answer? We're here for you.",
                style: TS.labelLarge.copyWith(
                  color: greyText,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.start,
              ),
              20.verticalSpace,
              Text(
                'Popular Questions:',
                style: TS.titleLarge,
                textAlign: TextAlign.start,
              ),
              15.verticalSpace,
              SizedBox(
                height: 900.h,
                child: ListView.separated(
                  separatorBuilder: (_, __) => const IntrinsicHeight(
                    child: AppDivider(
                      color: grey,
                    ),
                  ),
                  padding: EdgeInsets.only(bottom: 150.h),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.listPopularQuestions.length,
                  itemBuilder: (ctx, index) {
                    final r = controller.listPopularQuestions[index];

                    return Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.zero,
                        title: Text(
                          r.title,
                          style: TS.bodyMedium
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        backgroundColor: white,
                        collapsedBackgroundColor: white,
                        iconColor: black,
                        collapsedIconColor: black,
                        children: <Widget>[
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(r.description),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
