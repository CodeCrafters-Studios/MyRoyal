import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/dashboard/presentation/views/widgets/custom_detail_card.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/widgets/appbar_spacer.dart';
import 'package:MyRoyal/base/widgets/others/empty_data_widget.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';

import '../../controllers/dashboard_controller.dart';

class DetailPermitRequestView extends GetView<DashboardController> {
  const DetailPermitRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'Permintaan Izin',
      child: Obx(
        () => controller.detailPermitRequestData().data.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [EmptyDataWidget()],
              )
            : EPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AppbarSpacer(),
                      SizedBox(
                        height: Get.height,
                        child: RepaintBoundary(
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            separatorBuilder: (_, __) => 18.verticalSpace,
                            itemCount: controller
                                .detailPermitRequestData()
                                .data
                                .length,
                            itemBuilder: (_, index) {
                              return CustomDetailCard(
                                borderSideColor: primary20,
                                time: controller
                                    .detailPermitRequestData()
                                    .data[index]
                                    .periodTime
                                    .start,
                                dateStart: controller
                                    .detailPermitRequestData()
                                    .data[index]
                                    .periodDate
                                    .first,
                                dateEnd: controller
                                    .detailPermitRequestData()
                                    .data[index]
                                    .periodDate
                                    .last,
                                typeRequest: 'Permit',
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
