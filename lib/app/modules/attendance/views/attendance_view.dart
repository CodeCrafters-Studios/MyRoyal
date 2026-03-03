import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iroyal/app/modules/attendance/controllers/attendance_controller.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/app_divider.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';

class AttendanceView extends GetView<AttendanceController> {
  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      showIconBack: false,
      centeredTitle: true,
      title: 'Attendance',
      textStyle: TS.headlineSmall.copyWith(color: white),
      child: SingleChildScrollView(
        padding: REdgeInsets.only(bottom: 100),
        child: EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Obx(
            () => Column(
              children: [
                const AppbarSpacer(),
                5.verticalSpace,
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
        // _buildBackgroundImage(controller),
        if (!controller.isCheckIn.value)
          _buildGoogleMapsLocation(controller)
        else
          // _buildPhotoPreview(controller),
          _buildBackgroundImage(controller),
        10.verticalSpace,
        _buildTimeDisplay(controller),
        _buildTimesInfo(controller),
        20.verticalSpace,
        _buildActionButton(controller),
      ],
    );
  }

  Widget _buildGoogleMapsLocation(AttendanceController controller) {
    return SizedBox(
      height: 300.h,
      width: Get.width,
      child: Obx(() {
        if (controller.currentPosition.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                initialCenter: controller.currentPosition.value!,
                initialZoom: 17,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.iroyal.dev',
                ),

                /// RADIUS KANTOR
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: controller.officeLocation,
                      radius: controller.officeRadius,
                      useRadiusInMeter: true,
                      color: controller.isLocationValid.value
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      borderColor: controller.isLocationValid.value
                          ? Colors.green
                          : Colors.red,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),

                /// MARKER
                MarkerLayer(
                  markers: [
                    Marker(
                      point: controller.officeLocation,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                    Marker(
                      point: controller.currentPosition.value!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.person_pin_circle,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            /// GPS STATUS
            Positioned(
              top: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: controller.isGpsActive.value
                          ? Colors.green
                          : Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      controller.isGpsActive.value ? "GPS ACTIVE" : "GPS OFF",
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 6),

                  /// FAKE GPS INDICATOR
                  if (controller.isGpsSpoofing.value)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "SUSPICIOUS LOCATION",
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
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
                  text: 'End Break',
                  textColor: primary,
                  borderSide: const BorderSide(color: primary),
                )
              else
                controller.hasTakenBreak.value
                    ? ButtonPrimary(
                        padding:
                            REdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        color: white,
                        onPressed: controller.checkOut,
                        text: 'Check Out',
                        textColor: primary,
                        borderSide: const BorderSide(color: primary),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonPrimary(
                            padding: REdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            color: white,
                            onPressed: controller.checkOut,
                            text: 'Check Out',
                            textColor: primary,
                            borderSide: const BorderSide(color: primary),
                          ),
                          10.horizontalSpace,
                          ButtonPrimary(
                            padding: REdgeInsets.symmetric(
                                horizontal: 22, vertical: 5),
                            onPressed: controller.startBreakTime,
                            text: 'Take a Break',
                          ),
                        ],
                      ),
            20.verticalSpace,
            const AppDivider(thickness: 2),
            _buildAttendanceInfo(controller),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          Obx(() => CircleAvatar(
                backgroundColor: primary30.withOpacity(0.2),
                radius: 80.r,
                child: InkWellTap(
                  radius: 72.r,
                  color: controller.isLocationValid.value
                      ? primary.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.3),
                  onTap: controller.isLocationValid.value
                      ? controller.checkIn
                      : null,
                  child: CircleAvatar(
                    backgroundColor: controller.isLocationValid.value
                        ? primary
                        : Colors.grey,
                    radius: 72.r,
                    child: Text(
                      'Check in',
                      style: TS.bodyLarge.copyWith(color: white),
                    ),
                  ),
                ),
              )),
          10.verticalSpace,

          /// STATUS MESSAGE
          Obx(() {
            if (controller.isGpsSpoofing.value) {
              return Text(
                "Terdeteksi manipulasi lokasi.",
                style: TS.bodyMedium.copyWith(color: Colors.orange),
                textAlign: TextAlign.center,
              );
            }

            if (!controller.isGpsActive.value) {
              return Text(
                "GPS tidak aktif.",
                style: TS.bodyMedium.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              );
            }

            if (!controller.isLocationValid.value) {
              return Text(
                "Anda berada di luar radius kantor.",
                style: TS.bodyMedium.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              );
            }

            return Text(
              "Check in dan mulai hari produktif Anda.",
              style: TS.bodyMedium,
              textAlign: TextAlign.center,
            );
          }),
        ],
      );
    }
  }

  Widget _buildAttendanceInfo(AttendanceController controller) {
    return Column(
      children: [
        _buildBreakInfo(controller),
        30.verticalSpace,
        Row(
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

  Widget _buildBreakInfo(AttendanceController controller) {
    return Obx(() {
      if (controller.breakEndTime.value == null) {
        return const SizedBox();
      }

      return Container(
        width: Get.width,
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: secondary2.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              "Break Time",
              style: TS.titleSmall.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "${DateFormat('hh:mm a').format(controller.breakTime.value)}"
              " - "
              "${DateFormat('hh:mm a').format(controller.breakEndTime.value!)}",
              style: TS.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              "Duration: ${controller.breakDuration.value}",
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    });
  }
}
