import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iroyal/app/modules/attendance/presentation/controllers/attendance_controller.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/widgets/app_divider.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:latlong2/latlong.dart';
import 'package:shimmer/shimmer.dart';

class AttendanceView3 extends GetView<AttendanceController> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          title: Text(
            'Attendance',
            style: TS.headlineSmall.copyWith(color: white),
          ),
          scrolledUnderElevation: 0.0,
          backgroundColor: primary,
          automaticallyImplyLeading: false,
          toolbarHeight: 70.h,
        ),
        body: Obx(
          () {
            final httpService = Get.find<HttpService>();

            if (httpService.connectionStatus.value == "No connection") {
              return _buildShimmer();
            }

            if (controller.isLoadingAttendance.value) {
              return _buildShimmer();
            }
            return RefreshIndicator(
              backgroundColor: white,
              color: primary,
              onRefresh: controller.refreshOfficeLocation,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: EPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    children: [
                      controller.attendanceStatus.value ==
                              AttendanceStatus.notStarted
                          ? SizedBox()
                          : 5.verticalSpace,
                      _buildGreeting(controller),
                      controller.attendanceStatus.value ==
                              AttendanceStatus.notStarted
                          ? emptyBox
                          : 15.verticalSpace,
                      _buildAttendanceContent(controller),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Column(
      children: [
        10.verticalSpace,

        /// TITLE
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 20,
            width: 160,
            color: Colors.white,
          ),
        ),

        20.verticalSpace,

        /// MAP / IMAGE PLACEHOLDER
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 300.h,
            width: Get.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        20.verticalSpace,

        /// CLOCK
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 28,
            width: 120,
            color: Colors.white,
          ),
        ),

        15.verticalSpace,

        /// DATE
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 16,
            width: 200,
            color: Colors.white,
          ),
        ),

        30.verticalSpace,

        /// BUTTON
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 120,
            width: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGreeting(AttendanceController controller) {
    switch (controller.attendanceStatus.value) {
      case AttendanceStatus.checkedOut:
        return Align(
          alignment: Alignment.center,
          child: Text(
            'The End Of The Day!',
            style: TS.titleMedium.copyWith(fontWeight: FontWeight.w600),
          ),
        );

      case AttendanceStatus.breakStart:
        return Align(
          alignment: Alignment.center,
          child: Text(
            "It's Your Break Time!",
            style: TS.titleMedium.copyWith(fontWeight: FontWeight.w600),
          ),
        );

      default:
        return SizedBox();
    }
  }

  Widget _buildAttendanceContent(AttendanceController controller) {
    final status = controller.attendanceStatus.value;

    return Column(
      children: [
        if (status == AttendanceStatus.notStarted)
          _buildGoogleMapsLocation(controller)
        else
          _buildBackgroundImage(controller),
        status == AttendanceStatus.checkedOut ? emptyBox : 10.verticalSpace,
        _buildTimeDisplay(controller),
        _buildTimesInfo(controller),
        status == AttendanceStatus.checkedOut ? emptyBox : 10.verticalSpace,
        _buildActionButton(controller),
      ],
    );
  }

  Widget _buildGoogleMapsLocation(AttendanceController controller) {
    return SizedBox(
      height: 330.h,
      width: Get.width,
      child: controller.currentPosition.value == null
          ? Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 300.h,
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
              ),
            )
          : AttendanceMap(controller),
    );
  }

  Widget _buildBackgroundImage(AttendanceController controller) {
    switch (controller.attendanceStatus.value) {
      case AttendanceStatus.checkedOut:
        return Container(
          padding: REdgeInsets.only(bottom: 5),
          height: 258.h,
          child: Image.asset('assets/images/img_bg_checkout.jpg'),
        );

      case AttendanceStatus.breakStart:
        return Container(
          padding: REdgeInsets.only(left: 20, bottom: 5),
          height: 200.h,
          child: Image.asset('assets/images/img_bg_coffe_break.png'),
        );

      case AttendanceStatus.checkedIn:
      case AttendanceStatus.breakEnd:
        return Container(
          padding: REdgeInsets.only(bottom: 5),
          height: 188.h,
          child: Image.asset('assets/images/img_bg_working_time.png'),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTimeDisplay(AttendanceController controller) {
    return Obx(() {
      final status = controller.attendanceStatus.value;

      if (status == AttendanceStatus.checkedOut) {
        return Text(
          DateFormat('hh:mm:ss a').format(controller.breakTime.value!),
          style: TS.headlineSmall,
        );
      }

      if (status == AttendanceStatus.breakStart) {
        return Text(
          controller.countTimes.value,
          style: TS.headlineSmall,
        );
      }

      return Text(
        DateFormat('hh:mm:ss a').format(controller.currentTime.value),
        style: TS.headlineSmall,
      );
    });
  }

  Widget _buildTimesInfo(AttendanceController controller) {
    final status = controller.attendanceStatus.value;

    if (status == AttendanceStatus.breakStart) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: 'Your break time start from ', style: TS.bodyMedium),
            TextSpan(
              text: DateFormat('hh:mm a').format(controller.breakTime.value!),
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    return Text(
      DateFormat('MMMM dd, yyyy - EEEE').format(DateTime.now()),
      style: TS.bodyMedium,
    );
  }

  Widget _buildActionButton(AttendanceController controller) {
    final status = controller.attendanceStatus.value;

    if (status == AttendanceStatus.notStarted) {
      return _buildCheckInButton(controller);
    }

    return SizedBox(
      width: Get.width,
      child: Column(
        children: [
          if (status == AttendanceStatus.breakStart)
            ButtonPrimary(
              padding: REdgeInsets.symmetric(vertical: 5),
              fullWidth: true,
              color: white,
              onPressed: controller.endBreakTime,
              text: 'End Break',
              textColor: primary,
              borderSide: const BorderSide(color: primary),
            )
          else if (status == AttendanceStatus.checkedIn)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonPrimary(
                  padding: REdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  color: white,
                  onPressed: () => controller.validationSelfie('checked_out'),
                  text: 'Check Out',
                  textColor: primary,
                  borderSide: const BorderSide(color: primary),
                ),
                10.horizontalSpace,
                ButtonPrimary(
                  padding: REdgeInsets.symmetric(horizontal: 22, vertical: 5),
                  onPressed: controller.startBreakTime,
                  text: 'Take a Break',
                ),
              ],
            )
          else if (status == AttendanceStatus.breakEnd)
            ButtonPrimary(
              padding: REdgeInsets.symmetric(horizontal: 8, vertical: 5),
              color: white,
              onPressed: () => controller.validationSelfie('checked_out'),
              text: 'Check Out',
              textColor: primary,
              borderSide: const BorderSide(color: primary),
            ),
          20.verticalSpace,
          const AppDivider(thickness: 2),
          _buildAttendanceInfo(controller),
        ],
      ),
    );
  }

  Widget _buildCheckInButton(AttendanceController controller) {
    return Column(
      children: [
        Obx(() {
          if (controller.isLoadingAttendance.value) {
            return const Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              CircleAvatar(
                backgroundColor: primary30.withOpacity(0.2),
                radius: 80.r,
                child: InkWellTap(
                  radius: 72.r,
                  color: controller.isLocationValid.value
                      ? primary.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.3),
                  onTap: controller.isLocationValid.value
                      ? () => controller.validationSelfie('checked_in')
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
              ),
              10.verticalSpace,
              Text(
                controller.isLocationValid.value
                    ? "Check in and get started on your successful day."
                    : "Anda berada di luar radius kantor.",
                style: TS.bodyMedium.copyWith(
                  color: controller.isLocationValid.value
                      ? Colors.black
                      : Colors.red,
                ),
                textAlign: TextAlign.center,
              )
            ],
          );
        }),
        10.verticalSpace,
      ],
    );
  }

  Widget _buildAttendanceInfo(AttendanceController controller) {
    return Obx(() {
      final status = controller.attendanceStatus.value;

      final hasCheckIn = status != AttendanceStatus.notStarted;
      final hasCheckOut = status == AttendanceStatus.checkedOut;

      return Column(
        children: [
          _buildBreakInfo(controller),
          30.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAttendanceDetail(
                icon: Icons.more_time_outlined,
                time: hasCheckIn
                    ? DateFormat('hh:mm a').format(controller.checkInTime.value)
                    : '--:-- AM',
                label: 'Check in',
              ),
              _buildAttendanceDetail(
                icon: Icons.timer_off_outlined,
                time: hasCheckOut
                    ? DateFormat('hh:mm a')
                        .format(controller.checkOutTime.value)
                    : '--:-- PM',
                label: 'Check out',
              ),
              _buildAttendanceDetail(
                icon: Icons.check_circle_outline_rounded,
                time: hasCheckOut ? controller.totalHours.value : '--h --m',
                label: 'Total Hours',
              ),
            ],
          ),
        ],
      );
    });
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
      final breakEnd = controller.breakEndTime.value;

      if (breakEnd == null) {
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
              "${DateFormat('hh:mm a').format(controller.breakTime.value!)}"
              " - "
              "${DateFormat('hh:mm a').format(breakEnd)}",
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

class AttendanceMap extends StatefulWidget {
  final AttendanceController controller;
  const AttendanceMap(this.controller, {super.key});

  @override
  State<AttendanceMap> createState() => _AttendanceMapState();
}

class _AttendanceMapState extends State<AttendanceMap>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        FlutterMap(
          mapController: widget.controller.mapController,
          options: MapOptions(
            initialCenter: widget.controller.currentPosition.value ??
                const LatLng(-6.8621, 107.5006),
            initialZoom: 17,
            onMapReady: () => widget.controller.isMapReady.value = true,
            maxZoom: 18,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.iroyal',
              maxNativeZoom: 19,
            ),

            // Static office layers (never rebuild)
            CircleLayer(circles: widget.controller.officeCircles),

            PolygonLayer(
              polygons: widget.controller.officePolygons,
              polygonCulling: true,
              useAltRendering: true,
              simplificationTolerance: 1.2,
            ),

            // Static office markers
            MarkerLayer(markers: widget.controller.officeMarkers),

            // ONLY the user marker rebuilds (super cheap)
            Obx(() => MarkerLayer(
                  markers: [
                    if (widget.controller.currentPosition.value != null)
                      Marker(
                        point: widget.controller.currentPosition.value!,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.person_pin_circle,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                  ],
                )),
          ],
        ),

        // GPS status (unchanged)
        Positioned(
          top: 10,
          right: 10,
          child: Obx(
            () {
              final accuracy = widget.controller.gpsAccuracy.value;
              final office = widget.controller.nearestOffice.value;

              if (office == null) return const SizedBox();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      /// STATUS INSIDE / OUTSIDE
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: office.inside ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            office.inside
                                ? "INSIDE ${office.locationName}"
                                : "NEAREST ${office.locationName} (${office.distanceToBoundary.toStringAsFixed(1)} m)",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.controller.isGpsActive.value
                              ? Colors.green
                              : Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.controller.isGpsActive.value
                              ? "GPS ACTIVE"
                              : "GPS OFF",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  /// ACCURACY
                  Text(
                    "Accuracy: ± ${accuracy.toStringAsFixed(1)} m",
                    style: const TextStyle(fontSize: 10),
                  ),

                  /// DISTANCE
                  Text(
                    "Distance to center: ${office.distanceToCenter.toStringAsFixed(1)} m",
                    style: const TextStyle(fontSize: 10),
                  ),

                  /// RADIUS
                  if (office.type == "radius")
                    Text(
                      "Radius: ${office.radius.toStringAsFixed(0)} m",
                      style: const TextStyle(fontSize: 10),
                    ),

                  const SizedBox(height: 4),

                  if (widget.controller.isGpsSpoofing.value)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text("SUSPICIOUS",
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
