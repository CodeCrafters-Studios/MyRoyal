import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/app_divider.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import '../controllers/attendance_controller.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      showIconBack: false,
      centeredTitle: true,
      title: 'Attendance',
      textStyle: TS.headlineSmall,
      child: SingleChildScrollView(
        padding: REdgeInsets.only(bottom: 100),
        child: EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Obx(
            () => Column(
              children: [
                const AppbarSpacer(),

                // Horizontal Date
                // EasyDateTimeLine(
                //   initialDate: DateTime.now(),
                //   onDateChange: (selectedDate) {},
                //   activeColor: primary,
                //   headerProps: EasyHeaderProps(
                //     padding: EdgeInsets.zero,
                //     monthPickerType: MonthPickerType.switcher,
                //     monthStyle: TS.titleMedium,
                //     dateFormatter: const DateFormatter.custom(""),
                //   ),
                //   dayProps: EasyDayProps(
                //     height: 56.h,
                //     width: 56.w,
                //     dayStructure: DayStructure.dayStrDayNum,
                //     inactiveDayStyle: DayStyle(
                //       borderRadius: 48.0,
                //       dayNumStyle: TS.titleLarge,
                //     ),
                //     activeDayStyle: DayStyle(
                //       dayNumStyle: TS.titleLarge.copyWith(
                //         color: white,
                //       ),
                //     ),
                //   ),
                //   timeLineProps: EasyTimeLineProps(
                //     hPadding: 8.w, // padding from left and right
                //     separatorPadding: 16.w, // padding between days
                //   ),
                // ),
                // 20.verticalSpace,

                // Greetings
                controller.isCheckOut.value
                    ? Align(
                        alignment: Alignment.center,
                        child: Text(
                          'The End Of The Day!',
                          style: TS.titleMedium
                              .copyWith(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.start,
                        ),
                      )
                    : controller.isBreakTime.value
                        ? Align(
                            alignment: Alignment.center,
                            child: Text(
                              "It's Your Break Time!",
                              style: TS.titleMedium
                                  .copyWith(fontWeight: FontWeight.w600),
                              textAlign: TextAlign.start,
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Today Attendance',
                              style: TS.titleMedium
                                  .copyWith(fontWeight: FontWeight.w600),
                              textAlign: TextAlign.start,
                            ),
                          ),
                15.verticalSpace,

                Column(
                  children: [
                    // Background Images
                    controller.isCheckOut.value
                        ? Container(
                            padding: REdgeInsets.only(bottom: 5),
                            height: 220.h,
                            child: Image.asset(
                              'assets/images/img_bg_checkout.jpg',
                            ),
                          )
                        : controller.isBreakTime.value
                            ? Container(
                                padding: REdgeInsets.only(left: 20, bottom: 5),
                                height: 200.h,
                                child: Image.asset(
                                  'assets/images/img_bg_coffe_break.png',
                                ),
                              )
                            : const SizedBox.shrink(),

                    // Show Time
                    controller.isCheckOut.value
                        ? Text(
                            DateFormat('hh:mm:ss a')
                                .format(controller.checkOutTime.value),
                            style: TS.headlineSmall,
                          )
                        : controller.isBreakTime.value
                            ? Text(
                                controller.countTimes.value,
                                style: TS.headlineSmall,
                              )
                            : Text(
                                DateFormat('hh:mm:ss a')
                                    .format(controller.currentTime.value),
                                style: TS.headlineSmall,
                              ),
                    5.verticalSpace,

                    // Times Info
                    controller.isBreakTime.value
                        ? Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Your break time start from ',
                                    style: TS.bodyMedium),
                                TextSpan(
                                  text: DateFormat('hh:mm a').format(
                                    controller.breakTime.value,
                                  ),
                                  style: TS.bodyMedium
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        : Text(
                            DateFormat('MMMM dd, yyyy - EEEE').format(
                              DateTime.now(),
                            ),
                            style: TS.bodyMedium,
                          ),
                    20.verticalSpace,
                    controller.isCheckIn.value
                        ? SizedBox(
                            width: Get.width,
                            child: Column(
                              children: [
                                // Button
                                controller.isCheckOut.value
                                    ? const SizedBox.shrink()
                                    : controller.isBreakTime.value
                                        ? ButtonPrimary(
                                            padding: REdgeInsets.symmetric(
                                              vertical: 5,
                                            ),
                                            fullWidth: true,
                                            color: white,
                                            onPressed: controller.endBreakTime,
                                            text: 'End',
                                            textColor: primary,
                                            borderSide: const BorderSide(
                                              color: primary,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ButtonPrimary(
                                                padding: REdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 5,
                                                ),
                                                color: white,
                                                onPressed: controller.checkOut,
                                                text: 'Check Out',
                                                textColor: primary,
                                                borderSide: const BorderSide(
                                                  color: primary,
                                                ),
                                              ),
                                              10.horizontalSpace,
                                              ButtonPrimary(
                                                padding: REdgeInsets.symmetric(
                                                  horizontal: 22,
                                                  vertical: 5,
                                                ),
                                                onPressed:
                                                    controller.startBreakTime,
                                                text: 'Take a Break',
                                              ),
                                            ],
                                          ),
                                controller.isCheckOut.value
                                    ? const SizedBox.shrink()
                                    : controller.isBreakTime.value
                                        ? 8.verticalSpace
                                        : 20.verticalSpace,
                                const AppDivider(
                                  thickness: 2,
                                ),
                                20.verticalSpace,

                                // Attendance Info
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        const Icon(Icons.more_time_outlined),
                                        5.verticalSpace,
                                        Text(
                                          controller.isCheckIn.value
                                              ? DateFormat('hh:mm a').format(
                                                  controller.checkInTime.value)
                                              : '--:-- AM',
                                          style: TS.titleSmall,
                                        ),
                                        Text(
                                          'Check in',
                                          style: TS.bodyMedium,
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Icon(Icons.timer_off_outlined),
                                        5.verticalSpace,
                                        Text(
                                          controller.isCheckOut.value
                                              ? DateFormat('hh:mm a').format(
                                                  controller.checkOutTime.value)
                                              : '--:-- PM',
                                          style: TS.titleSmall,
                                        ),
                                        Text(
                                          'Check out',
                                          style: TS.bodyMedium,
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_outline_rounded,
                                        ),
                                        5.verticalSpace,
                                        Text(
                                          controller.isCheckOut.value
                                              ? controller.totalHours.value
                                              : '--h --m',
                                          style: TS.titleSmall,
                                        ),
                                        Text(
                                          'Total Hours',
                                          style: TS.bodyMedium,
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        : // Before Checkin
                        Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: primary30.withOpacity(0.2),
                                radius: 78.r,
                                child: InkWellTap(
                                  color: primary.withOpacity(0.3),
                                  radius: 80,
                                  onTap: controller.checkIn,
                                  child: Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(80),
                                      boxShadow: Shadows.small,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Check in',
                                        style:
                                            TS.bodyLarge.copyWith(color: white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              10.verticalSpace,
                              Text(
                                "Check in and get started on your successful day.",
                                style: TS.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                    20.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Attendance Summary',
                          style: TS.titleMedium,
                        ),
                        InkWellTap(
                            onTap: () {},
                            child: const Icon(Icons.arrow_forward_rounded))
                      ],
                    ),
                    GridView.count(
                      childAspectRatio: 2.5,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      children: const [
                        AttendanceCard(
                          backgroundColor: primary,
                          title: '02',
                          subTitle: 'Early Leaves',
                        ),
                        AttendanceCard(
                          backgroundColor: secondary70,
                          title: '05',
                          subTitle: 'Absents',
                        ),
                        AttendanceCard(
                          backgroundColor: red,
                          title: '0',
                          subTitle: 'Late in',
                        ),
                        AttendanceCard(
                          backgroundColor: Colors.orange,
                          title: '08',
                          subTitle: 'Leaves',
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AttendanceCard extends StatelessWidget {
  const AttendanceCard({
    super.key,
    required this.backgroundColor,
    required this.title,
    required this.subTitle,
  });

  final Color backgroundColor;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.all(8.0),
      width: 150.w,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.2),
        border: Border(
          top: BorderSide(
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: backgroundColor,
          ),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(Corners.sm),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TS.titleSmall,
          ),
          8.verticalSpace,
          Text(
            subTitle,
            style: TS.bodyLarge.copyWith(
              color: backgroundColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
