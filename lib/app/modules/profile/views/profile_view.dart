import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/home_user_card.dart';
import 'package:iroyal/app/modules/settings/presentation/views/components/item_menu_settings.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: Image.asset(
              'assets/images/bg_profile.png',
              width: Get.width,
              height: .22.sh,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              const AppbarSpacer(),
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(90),
                ),
                child: Image.asset(
                  'assets/images/img_profile.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  Text(
                    'Silvia Ibrahim',
                    style: TS.titleMedium.copyWith(
                      color: primary,
                    ),
                  ),
                  Text(
                    '1974-07-05',
                    style: TS.titleMedium.copyWith(
                      color: primary,
                    ),
                  ),
                  Text(
                    'Female',
                    style: TS.titleMedium.copyWith(
                      color: primary,
                    ),
                  ),
                  Text(
                    'Section Head',
                    style: TS.titleMedium.copyWith(
                      color: primary,
                    ),
                  ),
                ],
              ),
              // CardApp(
              //   color: primary,
              //   isShadow: true,
              //   shadows: Shadows.small,
              //   padding: REdgeInsets.all(8),
              //   margin: REdgeInsets.all(16),
              //   child: Column(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       EPadding(
              //         padding: const EdgeInsets.symmetric(
              //           horizontal: 8,
              //           vertical: 10,
              //         ),
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             ClipRRect(
              //               borderRadius: const BorderRadius.all(
              //                 Radius.circular(90),
              //               ),
              //               child: Image.asset(
              //                 'assets/images/img_profile.png',
              //                 height: 68,
              //                 width: 68,
              //                 fit: BoxFit.cover,
              //               ),
              //             ),
              //             12.horizontalSpace,
              //             Expanded(
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text(
              //                     'Full Name: Silvia Ibrahim',
              //                     style: TS.labelMedium.copyWith(
              //                       color: white,
              //                     ),
              //                   ),
              //                   Text(
              //                     'Birthdate: 1974-07-05',
              //                     style: TS.labelMedium.copyWith(
              //                       color: white,
              //                     ),
              //                   ),
              //                   Text(
              //                     'Gender: Female',
              //                     style: TS.labelMedium.copyWith(
              //                       color: white,
              //                     ),
              //                   ),
              //                   Text(
              //                     'Position: Section Head',
              //                     style: TS.labelMedium.copyWith(
              //                       color: white,
              //                     ),
              //                   )
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              20.verticalSpace,
              SizedBox(
                width: Get.width,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '-',
                            style: TS.headlineSmall,
                          ),
                          10.verticalSpace,
                          Text(
                            'Izin',
                            style: TS.bodyMedium,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '12',
                            style: TS.headlineSmall,
                          ),
                          10.verticalSpace,
                          Text(
                            'Cuti tersedia',
                            style: TS.bodyMedium,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '-',
                            style: TS.headlineSmall,
                          ),
                          10.verticalSpace,
                          Text(
                            'Masa Kerja',
                            style: TS.bodyMedium,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              40.verticalSpace,
              EPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    ItemMenuSettings(
                      assetSvg: 'assets/icons/ic_change_password.svg',
                      text: 'Change Password',
                      withTrailing: true,
                      onTap: () {},
                    ),
                    ItemMenuSettings(
                      assetSvg: 'assets/icons/ic_download_doc.svg',
                      text: 'Download Slip Gaji',
                      withTrailing: true,
                      onTap: () {},
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
