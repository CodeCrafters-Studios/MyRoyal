import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:iroyal/base/config/app_constants.dart';
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
        physics: const NeverScrollableScrollPhysics(),
        padding: REdgeInsets.only(bottom: 100),
        child: EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Obx(
            () => Column(
              children: [
                const AppbarSpacer(),
                _buildGreeting(controller),
                15.verticalSpace,
                _buildAttendanceContent(controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(AttendanceController controller) {
    if (controller.isCheckOut.value) {
      return Align(
        alignment: Alignment.center,
        child: Text(
          'The End Of The Day!',
          style: TS.titleMedium.copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.start,
        ),
      );
    } else if (controller.isBreakTime.value) {
      return Align(
        alignment: Alignment.center,
        child: Text(
          "It's Your Break Time!",
          style: TS.titleMedium.copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.start,
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Today Attendance',
          style: TS.titleMedium.copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.start,
        ),
      );
    }
  }

  Widget _buildAttendanceContent(AttendanceController controller) {
    return Column(
      children: [
        _buildBackgroundImage(controller),
        _buildGoogleMapsLocation(controller),
        10.verticalSpace,
        _buildTimeDisplay(controller),
        _buildTimesInfo(controller),
        20.verticalSpace,
        _buildActionButton(controller),
      ],
    );
  }

  Widget _buildGoogleMapsLocation(AttendanceController controller) {
    return Obx(() {
      // Wait until currentPosition is not null
      if (controller.currentPosition.value == null) {
        return const Center(child: CircularProgressIndicator());
      }
      return controller.isCheckIn.value
          ? emptyBox
          : SizedBox(
              height: 300.h,
              width: Get.width,
              child: GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: controller.currentPosition.value!,
                  zoom: 18,
                ),
                onMapCreated: controller.onMapCreated,
                circles: {
                  Circle(
                    strokeWidth: 1,
                    fillColor: green.withOpacity(0.3),
                    radius: 18.r,
                    visible: true,
                    strokeColor: green,
                    circleId: const CircleId('royal'),
                    center: const LatLng(-6.8617228, 107.5010659),
                  )
                },
                markers: {
                  const Marker(
                    markerId: MarkerId('royal'),
                    position: LatLng(-6.8617228, 107.5010659),
                  ),
                  // Add more markers here
                },

                // ToDo: Add polygon
              ),
            );
    });
  }

  Widget _buildBackgroundImage(AttendanceController controller) {
    if (controller.isCheckOut.value) {
      return Container(
        padding: REdgeInsets.only(bottom: 5),
        height: 258.h,
        child: Image.asset('assets/images/img_bg_checkout.jpg'),
      );
    } else if (controller.isBreakTime.value) {
      return Container(
        padding: REdgeInsets.only(left: 20, bottom: 5),
        height: 200.h,
        child: Image.asset('assets/images/img_bg_coffe_break.png'),
      );
    } else if (controller.isCheckIn.value) {
      return Container(
        padding: REdgeInsets.only(bottom: 5),
        height: 188.h,
        child: Image.asset('assets/images/img_bg_working_time.png'),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildTimeDisplay(AttendanceController controller) {
    if (controller.isCheckOut.value) {
      return Text(
        DateFormat('hh:mm:ss a').format(controller.checkOutTime.value),
        style: TS.headlineSmall,
      );
    } else if (controller.isBreakTime.value) {
      return Text(
        controller.countTimes.value,
        style: TS.headlineSmall,
      );
    } else {
      return Text(
        DateFormat('hh:mm:ss a').format(controller.currentTime.value),
        style: TS.headlineSmall,
      );
    }
  }

  Widget _buildTimesInfo(AttendanceController controller) {
    if (controller.isBreakTime.value) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: 'Your break time start from ', style: TS.bodyMedium),
            TextSpan(
              text: DateFormat('hh:mm a').format(controller.breakTime.value),
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    } else {
      return Text(
        DateFormat('MMMM dd, yyyy - EEEE').format(DateTime.now()),
        style: TS.bodyMedium,
      );
    }
  }

  Widget _buildActionButton(AttendanceController controller) {
    if (controller.isCheckIn.value) {
      return SizedBox(
        width: Get.width,
        child: Column(
          children: [
            if (!controller.isCheckOut.value)
              if (controller.isBreakTime.value)
                ButtonPrimary(
                  padding: REdgeInsets.symmetric(vertical: 5),
                  fullWidth: true,
                  color: white,
                  onPressed: controller.endBreakTime,
                  text: 'End',
                  textColor: primary,
                  borderSide: const BorderSide(color: primary),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonPrimary(
                      padding:
                          REdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      color: white,
                      onPressed: controller.checkOut,
                      text: 'Check Out',
                      textColor: primary,
                      borderSide: const BorderSide(color: primary),
                    ),
                    10.horizontalSpace,
                    ButtonPrimary(
                      padding:
                          REdgeInsets.symmetric(horizontal: 22, vertical: 5),
                      onPressed: controller.startBreakTime,
                      text: 'Take a Break',
                    ),
                  ],
                ),
            20.verticalSpace,
            const AppDivider(thickness: 2),
            20.verticalSpace,
            _buildAttendanceInfo(controller),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          CircleAvatar(
            backgroundColor: primary30.withOpacity(0.2),
            radius: 80.r,
            child: InkWellTap(
              radius: 72.r,
              color: primary.withOpacity(0.3),
              onTap: controller.checkIn,
              child: CircleAvatar(
                backgroundColor: primary,
                radius: 72.r,
                child: Text(
                  'Check in',
                  style: TS.bodyLarge.copyWith(color: white),
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
      );
    }
  }

  Widget _buildAttendanceInfo(AttendanceController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildAttendanceDetail(
          icon: Icons.more_time_outlined,
          time: controller.isCheckIn.value
              ? DateFormat('hh:mm a').format(controller.checkInTime.value)
              : '--:-- AM',
          label: 'Check in',
        ),
        _buildAttendanceDetail(
          icon: Icons.timer_off_outlined,
          time: controller.isCheckOut.value
              ? DateFormat('hh:mm a').format(controller.checkOutTime.value)
              : '--:-- PM',
          label: 'Check out',
        ),
        _buildAttendanceDetail(
          icon: Icons.check_circle_outline_rounded,
          time: controller.isCheckOut.value
              ? controller.totalHours.value
              : '--h --m',
          label: 'Total Hours',
        ),
      ],
    );
  }

  Widget _buildAttendanceDetail(
      {required IconData icon, required String time, required String label}) {
    return Column(
      children: [
        Icon(icon),
        5.verticalSpace,
        Text(time, style: TS.titleSmall),
        Text(label, style: TS.bodyMedium),
      ],
    );
  }
}
