import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/appbar_spacer.dart';
import 'package:MyRoyal/base/widgets/buttons/button_primary.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';

import '../controllers/payroll_controller.dart';

class PayrollView extends GetView<PayrollController> {
  const PayrollView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      appbarColor: primary,
      showBackground: false,
      title: 'Slip Gaji',
      child: Obx(
        () => EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppbarSpacer(),
              Flexible(
                child: ListView.separated(
                    padding: EdgeInsets.zero,
                    separatorBuilder: (_, __) {
                      return Divider(
                        color: grey,
                      );
                    },
                    itemCount: controller.payrollPeriodListRes.length,
                    itemBuilder: (context, index) {
                      return Obx(
                        () => InkWell(
                          onTap: () => controller.selectedPeriod(
                            index,
                            controller.payrollPeriodListRes[index].value,
                            controller.payrollPeriodListRes[index].filename,
                          ),
                          child: Container(
                            color: controller.selectedIndex.value == index
                                ? grey50
                                : null,
                            child: ListTile(
                                title: Text(
                                  controller.payrollPeriodListRes[index].label,
                                  style: controller.selectedIndex.value == index
                                      ? TS.bodyMedium
                                          .copyWith(fontWeight: FontWeight.bold)
                                      : TS.bodyMedium,
                                ),
                                trailing: index == 0
                                    ? Text(
                                        'Terbaru',
                                        style: TS.bodyMini
                                            .copyWith(color: greyIcon),
                                      )
                                    : null),
                          ),
                        ),
                      );
                    }),
              ),
              ButtonPrimary(
                fullWidth: true,
                isLoading: controller.isLoading.value,
                margin: const EdgeInsets.only(bottom: 30),
                onPressed: () => controller.downloadSlipUrl(
                  controller.payrollPeriod.value.isEmpty
                      ? controller.payrollPeriodListRes[0].value
                      : controller.payrollPeriod.value,
                  controller.payrollPeriod.value.isEmpty
                      ? controller.payrollPeriodListRes[0].filename
                      : controller.selectedFilename.value,
                ),
                text: 'Lanjut',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
