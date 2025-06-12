import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';

import '../controllers/payroll_controller.dart';

class PayrollView extends GetView<PayrollController> {
  const PayrollView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      appbarColor: primary,
      showBackground: false,
      title: 'Payroll',
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
                                        'Latest',
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
                text: 'Download',
              ),
              // controller.isLoading.value
              //     ? _buildLoadingSalaryCard()
              //     : _buildSalaryCard(),
              // 20.verticalSpace,
              // controller.isLoading.value
              //     ? _buildLoadingDetailsCard()
              //     : _buildDetailsCard(),
              // 20.verticalSpace,
              // controller.isLoading.value
              //     ? _buildLoadingTipsText()
              //     : _buildTipsText(),
              // Spacer(),
              // ButtonPrimary(
              //   fullWidth: true,
              //   isLoading: controller.isLoading.value,
              //   margin: const EdgeInsets.only(bottom: 30),
              //   onPressed: () =>
              //       controller.downloadSlipUrl(controller.payrollPeriod.value),
              //   text: 'Download',
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildTipsText() {
  //   return Text.rich(
  //     TextSpan(
  //       text: '* ',
  //       style: TS.bodyMedium.copyWith(
  //         color: red,
  //         fontWeight: FontWeight.w600,
  //       ),
  //       children: [
  //         TextSpan(
  //           text: 'Format password slip gaji yang diunduh: ',
  //           style: TS.bodyMedium
  //               .copyWith(fontWeight: FontWeight.w400, color: black),
  //         ),
  //         TextSpan(
  //           text: '\nddmmyyyy-nik karyawan',
  //           style: TS.bodyMedium
  //               .copyWith(fontWeight: FontWeight.w600, color: black),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildLoadingTipsText() => ShimmerText(width: Get.width, height: 40.h);

  // Widget _buildSalaryCard() {
  //   return Obx(
  //     () => CardApp(
  //       color: Colors.white,
  //       outlineColor: Colors.white,
  //       padding: REdgeInsets.all(12),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'The current net salary period',
  //                     style: TS.bodyMedium.copyWith(
  //                       fontWeight: FontWeight.w400,
  //                     ),
  //                   ),
  //                   DropdownButtonHideUnderline(
  //                     child: DropdownButton<String>(
  //                       isDense: true,
  //                       padding: EdgeInsets.zero,
  //                       dropdownColor: white,
  //                       items: controller.payrollPeriodListRes
  //                           .map<DropdownMenuItem<String>>(
  //                         (PayrollPeriodData data) {
  //                           return DropdownMenuItem<String>(
  //                             value: data.value,
  //                             child: Text(
  //                               data.label,
  //                               style: TS.bodyMedium.copyWith(
  //                                 fontWeight: FontWeight.w600,
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                       ).toList(),
  //                       value: controller.payrollPeriod.value.isEmpty
  //                           ? (controller.payrollPeriodRes().data.isNotEmpty
  //                               ? controller.payrollPeriodRes().data.first.value
  //                               : null)
  //                           : controller.payrollPeriod.value,
  //                       style: TS.bodyMedium.copyWith(
  //                         color: black,
  //                         fontWeight: FontWeight.w300,
  //                       ),
  //                       onChanged: (newValue) {
  //                         int oldIndex =
  //                             controller.payrollPeriodListRes.indexWhere(
  //                           (element) =>
  //                               element.label == controller.payrollPeriod.value,
  //                         );
  //                         int newIndex =
  //                             controller.payrollPeriodListRes.indexWhere(
  //                           (element) => element.label == newValue,
  //                         );

  //                         AppUtils.logApp('$oldIndex');
  //                         AppUtils.logApp('$newIndex');
  //                         AppUtils.logApp('$newValue');

  //                         controller.payrollPeriod.value = newValue ?? '';

  //                         // if (oldIndex != newIndex) {
  //                         //   controller
  //                         //       .downloadSlipUrl(selectedPayrollPeriod.value);
  //                         // controller
  //                         //     .payrollDataOverview(selectedPayrollPeriod.id);
  //                         // }
  //                       },
  //                       icon: const Icon(
  //                         Icons.arrow_drop_down,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               IconButton(
  //                 onPressed: () => controller.toggleShow(),
  //                 icon: Icon(
  //                   controller.isObsecureText.value
  //                       ? Icons.visibility
  //                       : Icons.visibility_off,
  //                   size: 30,
  //                   color: disabledColor,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           20.verticalSpace,
  //           Center(
  //             child: Text.rich(
  //               textAlign: TextAlign.center,
  //               TextSpan(
  //                 children: [
  //                   TextSpan(
  //                     text: controller.isObsecureText.value
  //                         ? 'Rp. ************'
  //                         : 'Rp. ${controller.payrollDataOverviewRes().data.gajiPokok}',
  //                     style: TS.titleLarge,
  //                   ),
  //                   TextSpan(
  //                     text: '/Month',
  //                     style: TS.bodyMedium.copyWith(
  //                       fontWeight: FontWeight.w400,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildDetailsCard() {
  //   return Obx(
  //     () => controller.isLoading.value
  //         ? ShimmerText(
  //             width: Get.width,
  //             height: 360.h,
  //           )
  //         : CardApp(
  //             isOutlined: true,
  //             borderWidth: 1.2,
  //             color: Colors.white,
  //             outlineColor: primary,
  //             padding: REdgeInsets.all(12),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   'Overview',
  //                   style: TS.bodyMedium.copyWith(
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //                 Text(
  //                   'Earning & Deductions',
  //                   style: TS.bodyMedium.copyWith(
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                 ),
  //                 20.verticalSpace,
  //                 RowDetailsEarningAndDeductions(
  //                   title: 'Income Before Tax',
  //                   value: controller.isObsecureText.value
  //                       ? '*************'
  //                       : controller
  //                           .payrollDataOverviewRes()
  //                           .data
  //                           .pendapatanSebelumPajak,
  //                 ),
  //                 RowDetailsEarningAndDeductions(
  //                   title:
  //                       'Tax Deduction (${controller.payrollDataOverviewRes().data.persentasePotonganPajak}%)',
  //                   value: controller.isObsecureText.value
  //                       ? '*************'
  //                       : '- ${controller.payrollDataOverviewRes().data.potonganPajak}',
  //                   valueStyle: TS.bodyMedium.copyWith(
  //                     color: red,
  //                   ),
  //                   withBackground: true,
  //                 ),
  //                 RowDetailsEarningAndDeductions(
  //                   title: 'Income After Tax',
  //                   value: controller.isObsecureText.value
  //                       ? '*************'
  //                       : controller
  //                           .payrollDataOverviewRes()
  //                           .data
  //                           .pendapatanSesudahPajak,
  //                 ),
  //                 RowDetailsEarningAndDeductions(
  //                   title: 'Total Deductions',
  //                   value: controller.isObsecureText.value
  //                       ? '*************'
  //                       : '- ${controller.payrollDataOverviewRes().data.totalPotongan}',
  //                   valueStyle: TS.bodyMedium.copyWith(
  //                     color: red,
  //                   ),
  //                   withBackground: true,
  //                 ),
  //                 RowDetailsEarningAndDeductions(
  //                   title: 'Rounding',
  //                   value: controller.isObsecureText.value
  //                       ? '*************'
  //                       : controller.payrollDataOverviewRes().data.pembulatan,
  //                   valueStyle: TS.bodyMedium.copyWith(
  //                     color: controller
  //                             .payrollDataOverviewRes()
  //                             .data
  //                             .pembulatan
  //                             .contains('-')
  //                         ? red
  //                         : black,
  //                   ),
  //                 ),
  //                 10.verticalSpace,
  //                 const AppDivider(),
  //                 RowDetailsEarningAndDeductions(
  //                   title: 'Net Salary',
  //                   titleStyle: TS.titleSmall,
  //                   value: controller.isObsecureText.value
  //                       ? '************'
  //                       : controller.payrollDataOverviewRes().data.gajiBersih,
  //                   valueStyle: TS.titleSmall,
  //                   withBackground: true,
  //                 ),
  //               ],
  //             ),
  //           ),
  //   );
  // }

  // Widget _buildLoadingSalaryCard() {
  //   return CardApp(
  //     color: Colors.white,
  //     outlineColor: Colors.white,
  //     padding: REdgeInsets.all(12),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         ShimmerText(width: 180.w),
  //         ShimmerText(width: 120.w),
  //         20.verticalSpace,
  //         Center(
  //           child: ShimmerText(
  //             width: 150.w,
  //             height: 34,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildLoadingDetailsCard() {
  //   return ShimmerText(
  //     width: Get.width,
  //     height: 360.h,
  //   );
  // }
}
