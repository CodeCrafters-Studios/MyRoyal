import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';

import '../controllers/tracking_document_controller.dart';

class TrackingDocumentView extends GetView<TrackingDocumentController> {
  const TrackingDocumentView({super.key});
  @override
  Widget build(BuildContext context) {
    return TrackingDocumentImplView(
      controller: controller,
    );
  }
}

class TrackingDocumentImplView extends StatelessWidget {
  const TrackingDocumentImplView({super.key, required this.controller});

  final TrackingDocumentController controller;
  @override
  Widget build(BuildContext context) {
    return PageBase(
      title: 'Tracking Document',
      child: Column(
        children: [
          const AppbarSpacer(),
          CardApp(
            onTap: () => Get.to(() => ApprovalView(controller: controller)),
            padding: REdgeInsets.symmetric(vertical: 10),
            width: 335.w,
            borderWidth: 1,
            isShadow: true,
            isOutlined: true,
            shadows: Shadows.universal,
            color: white.withOpacity(0.8),
            child: EPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Approval',
                    style: TS.labelLarge.copyWith(
                      color: black,
                    ),
                  ),
                  Text(
                    'Number of pending approval',
                    style: TS.labelMedium.copyWith(
                      color: greyText,
                      fontWeight: FontWeight.w400,
                      height: 2,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        controller.listApproval.length.toString(),
                        style: TS.displayMedium.copyWith(color: primary10),
                      ),
                      10.horizontalSpace,
                      Text(
                        'Items',
                        style: TS.labelMedium.copyWith(
                          color: greyText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  SizedBox(
                    width: 280.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: REdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: primary50),
                                  color: primary50.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(24)),
                              child: Row(
                                children: [
                                  Text(
                                    '!',
                                    style: TS.labelLarge
                                        .copyWith(color: primary50),
                                  ),
                                  5.horizontalSpace,
                                  Text(
                                    'OVERDUE',
                                    style: TS.labelMedium
                                        .copyWith(color: primary50),
                                  ),
                                ],
                              ),
                            ),
                            8.horizontalSpace,
                            Text(
                              controller.statusOverdue.length.toString(),
                              style: TS.labelLarge.copyWith(color: primary50),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: REdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: secondary),
                                  color: secondary.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(24)),
                              child: Row(
                                children: [
                                  const Icon(
                                    applyTextScaling: true,
                                    Icons.bolt,
                                    color: secondary,
                                    size: 20,
                                  ),
                                  Text(
                                    'URGENT',
                                    style: TS.labelMedium
                                        .copyWith(color: secondary),
                                  )
                                ],
                              ),
                            ),
                            8.horizontalSpace,
                            Text(
                              controller.statusUrgent.length.toString(),
                              style: TS.labelLarge.copyWith(
                                color: secondary.withOpacity(0.8),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  5.verticalSpace,
                ],
              ),
            ),
          ),
          15.verticalSpace,
          CardApp(
            padding: REdgeInsets.symmetric(vertical: 10),
            width: 335.w,
            borderWidth: 1,
            isShadow: true,
            isOutlined: true,
            shadows: Shadows.universal,
            color: white.withOpacity(0.8),
            child: EPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'History',
                    style: TS.labelLarge.copyWith(
                      color: black,
                    ),
                  ),
                  Text(
                    'Number of approved',
                    style: TS.labelMedium.copyWith(
                      color: greyText,
                      fontWeight: FontWeight.w400,
                      height: 2,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '0',
                        style: TS.displayMedium.copyWith(color: primary10),
                      ),
                      10.horizontalSpace,
                      Text(
                        'Items',
                        style: TS.labelMedium.copyWith(
                          color: greyText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  SizedBox(
                    width: 305.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: REdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: green),
                                  color: green.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(24)),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check,
                                    color: focusColor,
                                    size: 20,
                                  ),
                                  5.horizontalSpace,
                                  Text(
                                    'APPROVED',
                                    style:
                                        TS.labelMedium.copyWith(color: green),
                                  )
                                ],
                              ),
                            ),
                            5.horizontalSpace,
                            Text(
                              '300',
                              style: TS.labelLarge.copyWith(
                                fontWeight: FontWeight.w700,
                                color: green,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: REdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: red),
                                  color: red.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(24)),
                              child: Row(
                                children: [
                                  const Icon(
                                    applyTextScaling: true,
                                    Icons.close,
                                    color: red,
                                    size: 20,
                                  ),
                                  5.horizontalSpace,
                                  Text(
                                    'REJECTED',
                                    style: TS.labelMedium.copyWith(color: red),
                                  )
                                ],
                              ),
                            ),
                            5.horizontalSpace,
                            Text(
                              '100',
                              style: TS.labelLarge.copyWith(
                                color: red.withOpacity(0.8),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  5.verticalSpace,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ApprovalView extends StatelessWidget {
  const ApprovalView({super.key, required this.controller});

  final TrackingDocumentController controller;

  @override
  Widget build(BuildContext context) {
    return PageBase(
      title: 'Approval',
      textStyle: TS.titleMedium,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppbarSpacer(),
            EPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildInputPrimary(),
            ),
            _buildListView(controller.listApproval),
          ],
        ),
      ),
    );
  }

  Widget _buildInputPrimary() {
    return InputPrimary(
      // controller: _getSearchController(),
      // key: _getSearchKey(),
      label: '',
      hint: 'Search',
      // onChanged: _getOnChangedCallback(),
      color: white,
      outlineColor: primary,
      prefixIcon: _buildPrefixIcon(),
      // suffixIcon: _buildSuffixIcon(),
    );
  }

  Widget _buildPrefixIcon() {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SvgPicture.asset(
        'assets/icons/ic_search.svg',
        width: 20.w,
        height: 20.w,
      ),
    );
  }

  // Widget? _buildSuffixIcon() {
  //   // final valueListener = controller.valueListener.value;
  //   return valueListener.isNotEmpty
  //       ? IconButton(
  //           onPressed: controller.clear,
  //           icon: const Icon(Icons.clear),
  //         )
  //       : null;
  // }

  Widget _buildListView(List data) {
    return SizedBox(
      height: Get.height,
      child: ListView.separated(
        separatorBuilder: (_, __) {
          return 15.verticalSpace;
        },
        padding: REdgeInsets.fromLTRB(16, 10, 16, 10),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final d = data[index];
          return CardApp(
            onTap: () => Get.toNamed(Routes.DETAIL_TRACKING_DOCUMENT),
            padding: REdgeInsets.symmetric(vertical: 10),
            width: 335.w,
            borderWidth: 1,
            isShadow: true,
            isOutlined: true,
            shadows: Shadows.universal,
            color: white.withOpacity(0.8),
            child: EPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: Get.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'General Affair - PT Royal Abadi Sejahtera',
                          style: TS.labelMedium.copyWith(
                            color: greyText,
                            fontWeight: FontWeight.w400,
                            height: 2,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.attach_file,
                              size: 15,
                            ),
                            Text(
                              '2',
                              style: TS.bodyLarge,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    d.title,
                    style: TS.labelLarge.copyWith(
                      color: black,
                    ),
                  ),
                  d.status.isEmpty ? const SizedBox() : 20.verticalSpace,
                  SizedBox(
                    width: Get.width,
                    height: 25.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: d.status.length,
                      itemBuilder: (context, index) {
                        final f = d.status[index];
                        return StatusApproval(
                          borderColor: f.borderColor,
                          decorationColor: f.decorationColor,
                          icon: f.icon,
                          iconColor: f.iconColor,
                          status: f.status,
                          statusColor: f.statusColor,
                          isIcon: f.isIcon,
                        );
                      },
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     Container(
                  //       padding: REdgeInsets.symmetric(horizontal: 10),
                  //       decoration: BoxDecoration(
                  //           border: Border.all(color: primary50),
                  //           color: primary50.withOpacity(0.3),
                  //           borderRadius: BorderRadius.circular(24)),
                  //       child: Row(
                  //         children: [
                  //           Text(
                  //             '!',
                  //             style: TS.labelLarge.copyWith(color: primary50),
                  //           ),
                  //           5.horizontalSpace,
                  //           Text(
                  //             'OVERDUE',
                  //             style: TS.labelMedium.copyWith(color: primary50),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //     10.horizontalSpace,
                  //     Container(
                  //       padding: REdgeInsets.symmetric(horizontal: 10),
                  //       decoration: BoxDecoration(
                  //           border: Border.all(color: secondary),
                  //           color: secondary.withOpacity(0.3),
                  //           borderRadius: BorderRadius.circular(24)),
                  //       child: Row(
                  //         children: [
                  //           const Icon(
                  //             applyTextScaling: true,
                  //             Icons.bolt,
                  //             color: secondary,
                  //             size: 20,
                  //           ),
                  //           Text(
                  //             'URGENT',
                  //             style: TS.labelMedium.copyWith(color: secondary),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  d.status.isEmpty ? const SizedBox() : 20.verticalSpace,
                  SizedBox(
                    width: Get.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircleAvatar(),
                            ),
                            5.horizontalSpace,
                            const Text('Alghany Kennedy Adam')
                          ],
                        ),
                        Text(d.date)
                      ],
                    ),
                  ),
                  5.verticalSpace,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class StatusApproval extends StatelessWidget {
  const StatusApproval({
    super.key,
    required this.icon,
    required this.status,
    required this.iconColor,
    required this.statusColor,
    required this.borderColor,
    this.isIcon = false,
    required this.decorationColor,
  });

  final String icon;
  final String status;
  final Color iconColor;
  final Color statusColor;
  final Color borderColor;
  final Color decorationColor;
  final bool isIcon;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        padding: REdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            color: decorationColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(24)),
        child: Row(
          children: [
            isIcon
                ? const Icon(
                    applyTextScaling: true,
                    Icons.bolt,
                    color: secondary,
                    size: 20,
                  )
                : Text(
                    icon,
                    style: TS.labelLarge.copyWith(color: iconColor),
                  ),
            5.horizontalSpace,
            Text(
              status,
              style: TS.labelMedium.copyWith(color: statusColor),
            )
          ],
        ),
      ),
      10.horizontalSpace,
    ]);
  }
}
