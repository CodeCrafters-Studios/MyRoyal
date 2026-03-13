import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iroyal/app/modules/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:iroyal/app/modules/dashboard/presentation/views/widgets/custom_detail_card.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/others/empty_data_widget.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';

class DetailLateCheckInView extends GetView<DashboardController> {
  const DetailLateCheckInView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'Late Check-In',
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
