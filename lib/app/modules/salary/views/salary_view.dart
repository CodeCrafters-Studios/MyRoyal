import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/app_divider.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';

import '../controllers/salary_controller.dart';

class SalaryView extends GetView<SalaryController> {
  const SalaryView({super.key});
  @override
  Widget build(BuildContext context) {
    return PageBase(
      appbarColor: grey50,
      bgColors: grey50,
      showBackground: false,
      title: 'Salary',
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppbarSpacer(),
            CardApp(
              color: white,
              outlineColor: white,
              padding: REdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'The current net salary based on ',
                              style: TS.bodyMedium.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: '\nMay 2024',
                              style: TS.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.calendar_month_outlined),
                    ],
                  ),
                  40.verticalSpace,
                  Center(
                    child: Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Rp. 20,000,000',
                            style: TS.headlineMedium,
                          ),
                          TextSpan(
                            text: '/Month',
                            style: TS.bodyMedium.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  Center(
                    child: Text(
                      'Twenty million rupiah per month',
                      style: TS.bodyMedium.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            CardApp(
              color: white,
              outlineColor: white,
              padding: REdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Details',
                    style: TS.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Earning & Deductions',
                    style: TS.bodyMedium.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  20.verticalSpace,
                  const RowDetailsEarningAndDeductions(
                    title: 'Basic',
                    value: '16,000,000',
                  ),
                  const RowDetailsEarningAndDeductions(
                    title: 'Incentive Pay',
                    value: '1,200,000',
                    withBackground: true,
                  ),
                  const RowDetailsEarningAndDeductions(
                    title: 'House Rent Allowance',
                    value: '2,000,000',
                  ),
                  const RowDetailsEarningAndDeductions(
                    title: 'Meal Allowance',
                    value: '300,000',
                    withBackground: true,
                  ),
                  const RowDetailsEarningAndDeductions(
                    title: 'Overtime',
                    value: '500,000',
                  ),
                  RowDetailsEarningAndDeductions(
                    title: 'Provident Fund  (0.5%)',
                    value: '- 100,000',
                    valueStyle: TS.bodyMedium.copyWith(
                      color: redPrimary,
                    ),
                    withBackground: true,
                  ),
                  RowDetailsEarningAndDeductions(
                    title: 'Professional Tax  (0.5%)',
                    value: '- 100,000',
                    valueStyle: TS.bodyMedium.copyWith(
                      color: redPrimary,
                    ),
                  ),
                  RowDetailsEarningAndDeductions(
                    title: 'Loan',
                    value: '- 1,800,000',
                    withBackground: true,
                    valueStyle: TS.bodyMedium.copyWith(
                      color: redPrimary,
                    ),
                  ),
                  10.verticalSpace,
                  const AppDivider(),
                  RowDetailsEarningAndDeductions(
                    title: 'Total',
                    titleStyle: TS.titleSmall,
                    value: '18,000,000',
                    valueStyle: TS.titleSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RowDetailsEarningAndDeductions extends StatelessWidget {
  const RowDetailsEarningAndDeductions({
    super.key,
    required this.title,
    required this.value,
    this.titleStyle,
    this.valueStyle,
    this.withBackground = false,
  });

  final String title;
  final String value;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final bool withBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.symmetric(horizontal: 4),
      height: 40.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8.r),
        ),
        color: withBackground ? grey50 : white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: titleStyle ?? TS.bodyMedium,
          ),
          Text(
            value,
            style: valueStyle ?? TS.bodyMedium,
          ),
        ],
      ),
    );
  }
}
