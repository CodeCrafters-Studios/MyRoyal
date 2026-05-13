import 'package:MyRoyal/app/modules/attendance/presentation/views/components/user_marker_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:MyRoyal/app/modules/attendance/presentation/controllers/attendance_controller.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/services/http_service.dart';
import 'package:MyRoyal/base/widgets/app_divider.dart';
import 'package:MyRoyal/base/widgets/buttons/button_primary.dart';
import 'package:MyRoyal/base/widgets/inkwell_tap.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:latlong2/latlong.dart';
import 'package:shimmer/shimmer.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          title:
              Text('Kehadiran', style: TS.headlineSmall.copyWith(color: white)),
          backgroundColor: primary,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 70.h,
        ),
        body: Obx(() {
          final http = Get.find<HttpService>();

          if (http.connectionStatus.value == "No connection" ||
              controller.isLoadingAttendance.value) {
            return _buildShimmer();
          }

          return RefreshIndicator(
            backgroundColor: white,
            color: primary,
            onRefresh: controller.onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  if (controller.attendanceStatus.value ==
                      AttendanceStatus.checkedOut) ...[
                    10.verticalSpace,
                    _buildGreeting(),
                    10.verticalSpace,
                  ],
                  _buildAttendanceContent(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildGreeting() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        'The End Of The Day!',
        style: TS.titleMedium.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildAttendanceContent() {
    final status = controller.attendanceStatus.value;

    return Column(
      children: [
        status == AttendanceStatus.checkedOut
            ? _buildCheckoutImage()
            : _buildMap(),
        if (status != AttendanceStatus.checkedOut) 10.verticalSpace,
        if (status != AttendanceStatus.checkedOut) _buildTimeDisplay(),
        if (status != AttendanceStatus.checkedOut) _buildTimesInfo(),
        if (status != AttendanceStatus.checkedOut) 10.verticalSpace,
        _buildActionSection(),
      ],
    );
  }

  Widget _buildMap() {
    return SizedBox(
      height: 330.h,
      child: controller.currentPosition.value == null
          ? _buildMapShimmer()
          : AttendanceMap(controller),
    );
  }

  Widget _buildCheckoutImage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 5, 14, 0),
          child: Text(
            '"${controller.endDayMessage.value}"',
            style: TS.bodyMedium.copyWith(fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: REdgeInsets.only(bottom: 5),
          height: 258.h,
          child: Image.asset('assets/images/img_bg_checkout.jpg'),
        ),
      ],
    );
  }

  Widget _buildMapShimmer() {
    return Shimmer.fromColors(
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
    );
  }

  Widget _buildTimeDisplay() {
    return Obx(() {
      return Text(controller.formattedDisplayTime, style: TS.headlineSmall);
    });
  }

  Widget _buildTimesInfo() {
    return Obx(() {
      final breakStart = controller.breakTime.value;

      if (controller.attendanceStatus.value == AttendanceStatus.breakStart &&
          breakStart != null) {
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Your break time start from ',
                style: TS.bodyMedium,
              ),
              TextSpan(
                text: DateFormat('hh:mm a').format(breakStart),
                style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }

      return Text(
        DateFormat('EEEE - MMMM dd, yyyy', "id_ID").format(DateTime.now()),
        style: TS.bodyMedium,
      );
    });
  }

  Widget _buildActionSection() {
    final status = controller.attendanceStatus.value;

    if (status == AttendanceStatus.notStarted) {
      return _buildCheckInButton();
    }

    return Column(
      children: [
        _buildActionButtons(status),
        status != AttendanceStatus.checkedOut
            ? 20.verticalSpace
            : const SizedBox.shrink(),
        const AppDivider(thickness: 2),
        status != AttendanceStatus.checkedOut
            ? 20.verticalSpace
            : 30.verticalSpace,
        _buildAttendanceInfo(),
      ],
    );
  }

  Widget _buildAttendanceInfo() {
    return Obx(() {
      return EPadding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 150),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAttendanceDetail(
                  icon: Icons.login_outlined,
                  color: green,
                  time: controller.formatApiTime(
                    controller.attendanceTodayRes.value.checkedInTime,
                  ),
                  label: 'Check-in',
                ),
                50.horizontalSpace,
                _buildAttendanceDetail(
                  icon: Icons.logout_outlined,
                  color: red,
                  time: controller.formatApiTime(
                    controller.attendanceTodayRes.value.checkedOutTime,
                  ),
                  label: 'Check-out',
                ),
                50.horizontalSpace,
                _buildAttendanceDetail(
                  icon: Icons.access_time_rounded,
                  color: primary30,
                  time: controller.liveWorkDuration.value,
                  label: 'Durasi Kerja',
                ),
              ],
            ),
            35.verticalSpace,
            _buildBreakInfo(controller),
          ],
        ),
      );
    });
  }

  Widget _buildAttendanceDetail({
    required IconData icon,
    required String time,
    required String label,
    Color? color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
        ),
        5.verticalSpace,
        Text(
          time,
          style: TS.titleSmall,
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: TS.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBreakInfo(AttendanceController controller) {
    return Obx(() {
      final status = controller.attendanceStatus.value;

      final hasBreak =
          controller.attendanceTodayRes.value.breakStartTime != null &&
              controller.attendanceTodayRes.value.breakEndTime != null;

      if (status == AttendanceStatus.notStarted ||
          status == AttendanceStatus.checkedIn) {
        return const SizedBox();
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAttendanceDetail(
            icon: Icons.restaurant_rounded,
            color: primaryAccent,
            time: controller.formatApiTime(
              controller.attendanceTodayRes.value.breakStartTime,
            ),
            label: 'Mulai\nIstirahat',
          ),
          50.horizontalSpace,
          _buildAttendanceDetail(
            icon: Icons.timer_off_outlined,
            color: urgentColor,
            time: controller.formatApiTime(
              controller.attendanceTodayRes.value.breakEndTime,
            ),
            label: 'Selesai\nIstirahat',
          ),
          50.horizontalSpace,
          _buildAttendanceDetail(
            icon: Icons.access_time_rounded,
            color: primary30,
            time: hasBreak ? controller.breakDuration.value : '--h --m',
            label: 'Durasi\nIstirahat',
          ),
        ],
      );
    });
  }

  Widget _buildActionButtons(AttendanceStatus status) {
    if (status == AttendanceStatus.breakStart) {
      return _buildEndBreakButton();
    }

    if (status == AttendanceStatus.checkedIn) {
      return _buildCheckOutBreakRow();
    }

    if (status == AttendanceStatus.breakEnd) {
      return _buildCheckOutButton();
    }

    return const SizedBox();
  }

  Widget _buildCheckInButton() {
    return Obx(() {
      if (controller.isLoadingAttendance.value) {
        return const Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        );
      }

      final enabled = controller.isLocationValid.value;

      return Column(
        children: [
          CircleAvatar(
            backgroundColor: primary30.withOpacity(0.2),
            radius: 80.r,
            child: InkWellTap(
              radius: 72.r,
              color: enabled
                  ? primary.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.3),
              onTap: enabled
                  ? () => controller.validationSelfie('checked_in')
                  : null,
              child: CircleAvatar(
                backgroundColor: enabled ? primary : Colors.grey,
                radius: 72.r,
                child: Text(
                  'Check-in',
                  style: TS.bodyLarge.copyWith(color: white),
                ),
              ),
            ),
          ),
          10.verticalSpace,
          Text(
            enabled
                ? "Lakukan check-in dan mulailah hari Anda yang produktif."
                : "Anda berada di luar radius kantor.",
            style: TS.bodyMedium.copyWith(
              color: enabled ? Colors.black : Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          10.verticalSpace,
        ],
      );
    });
  }

  Widget _buildCheckOutBreakRow() {
    final enabled = controller.isLocationValid.value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonPrimary(
          text: 'Check Out',
          color: enabled ? white : Colors.grey,
          borderSide: enabled ? BorderSide(color: primary) : null,
          textColor: enabled ? primary : Colors.white,
          onPressed:
              enabled ? () => controller.validationSelfie('checked_out') : null,
        ),
        10.horizontalSpace,
        ButtonPrimary(
          text: 'Take a Break',
          color: enabled ? primary : Colors.grey,
          onPressed: enabled ? controller.startBreakTime : null,
        ),
      ],
    );
  }

  Widget _buildEndBreakButton() {
    final enabled = controller.isLocationValid.value;

    return ButtonPrimary(
      fullWidth: true,
      margin: EdgeInsets.symmetric(horizontal: 14),
      text: 'End Break',
      color: enabled ? white : Colors.grey,
      textColor: enabled ? primary : Colors.grey,
      borderSide: BorderSide(
        color: enabled ? primary : Colors.grey,
      ),
      onPressed: enabled ? controller.endBreakTime : null,
    );
  }

  Widget _buildCheckOutButton() {
    final enabled = controller.isLocationValid.value;

    return ButtonPrimary(
      text: 'Check Out',
      color: enabled ? white : Colors.grey,
      textColor: enabled ? primary : Colors.grey,
      borderSide: BorderSide(
        color: enabled ? primary : Colors.grey,
      ),
      onPressed:
          enabled ? () => controller.validationSelfie('checked_out') : null,
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
}

class AttendanceMap extends StatefulWidget {
  final AttendanceController controller;
  const AttendanceMap(this.controller, {super.key});

  @override
  State<AttendanceMap> createState() => _AttendanceMapState();
}

class _AttendanceMapState extends State<AttendanceMap>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
        begin: widget.controller.mapController.camera.center.latitude,
        end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: widget.controller.mapController.camera.center.longitude,
        end: destLocation.longitude);
    final zoomTween = Tween<double>(
        begin: widget.controller.mapController.camera.zoom, end: destZoom);

    final animController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    final Animation<double> animation =
        CurvedAnimation(parent: animController, curve: Curves.fastOutSlowIn);

    animController.addListener(() {
      widget.controller.mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        animController.dispose();
      }
    });

    animController.forward();
  }

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
            initialRotation: 0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.myroyal',
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
            const UserMarkerLayer(),
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
                                ? "DI DALAM AREA ${office.locationName}"
                                : "DI LUAR AREA ${office.locationName} (${office.distanceToBoundary.toStringAsFixed(1)} m)",
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
                              ? "GPS AKTIF"
                              : "GPS MATI",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  /// ACCURACY
                  Text(
                    "Akurasi: ± ${accuracy.toStringAsFixed(1)} m",
                    style: const TextStyle(fontSize: 10),
                  ),

                  /// DISTANCE
                  Text(
                    "Jarak ke titik pusat: ${office.distanceToCenter.toStringAsFixed(1)} m",
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

        Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            onPressed: () {
              final pos = widget.controller.currentPosition.value;
              if (pos != null) {
                _animatedMapMove(pos, 18);
              }
            },
            child: const Icon(
              Icons.my_location,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
