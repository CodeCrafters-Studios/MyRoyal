import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:MyRoyal/app/modules/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:MyRoyal/app/modules/dashboard/presentation/views/widgets/custom_detail_card.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/widgets/appbar_spacer.dart';
import 'package:MyRoyal/base/widgets/others/empty_data_widget.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';

class DetailLateCheckInView extends GetView<DashboardController> {
  const DetailLateCheckInView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'Terlambat Check-in',
      child: Obx(
        () => controller.detailLateData().data.isEmpty
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
                            itemCount: controller.detailLateData().data.length,
                            itemBuilder: (_, index) {
                              final data =
                                  controller.detailLateData().data[index];

                              return CustomDetailCard(
                                borderSideColor: errorColor,
                                time: data.shiftstartAbsence.time,
                                dateStart: DateFormat('dd MMMM yyyy')
                                    .format(data.shiftstartAbsence.date),
                                dateEnd: '',
                                typeRequest: 'Late',
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
