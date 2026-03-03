// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:iroyal/base/design/colors.dart';
// import 'package:iroyal/base/design/styles.dart';
// import 'package:iroyal/base/widgets/app_divider.dart';
// import 'package:iroyal/base/widgets/appbar_spacer.dart';
// import 'package:iroyal/base/widgets/buttons/button_primary.dart';
// import 'package:iroyal/base/widgets/inkwell_tap.dart';
// import 'package:iroyal/base/widgets/padding.dart';
// import 'package:iroyal/base/widgets/page_base.dart';
// import '../controllers/attendance_controller.dart';

// class AttendanceView2 extends GetView<AttendanceController> {
//   const AttendanceView2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return PageBase(
//       showBackground: false,
//       showIconBack: false,
//       centeredTitle: true,
//       title: 'Attendance',
//       textStyle: TS.headlineSmall.copyWith(color: white),
//       child: SingleChildScrollView(
//         padding: REdgeInsets.only(bottom: 100),
//         child: EPadding(
//           padding: const EdgeInsets.symmetric(horizontal: 14),
//           child: Obx(
//             () => Column(
//               children: [
//                 const AppbarSpacer(),
//                 5.verticalSpace,
//                 _buildGreeting(controller),
//                 15.verticalSpace,
//                 _buildAttendanceContent(controller),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGreeting(AttendanceController controller) {
//     if (controller.isCheckOut.value) {
//       return Align(
//         alignment: Alignment.center,
//         child: Text(
//           'The End Of The Day!',
//           style: TS.titleMedium.copyWith(fontWeight: FontWeight.w600),
//           textAlign: TextAlign.start,
//         ),
//       );
//     } else if (controller.isBreakTime.value) {
//       return Align(
//         alignment: Alignment.center,
//         child: Text(
//           "It's Your Break Time!",
//           style: TS.titleMedium.copyWith(fontWeight: FontWeight.w600),
//           textAlign: TextAlign.start,
//         ),
//       );
//     } else {
//       return Align(
//         alignment: Alignment.centerLeft,
//         child: Text(
//           'Today Attendance',
//           style: TS.titleMedium.copyWith(fontWeight: FontWeight.w600),
//           textAlign: TextAlign.start,
//         ),
//       );
//     }
//   }

//   Widget _buildAttendanceContent(AttendanceController controller) {
//     return Column(
//       children: [
//         // _buildBackgroundImage(controller),
//         if (!controller.isCheckIn.value)
//           _buildGoogleMapsLocation(controller)
//         else
//           // _buildPhotoPreview(controller),
//           _buildBackgroundImage(controller),
//         10.verticalSpace,
//         _buildTimeDisplay(controller),
//         _buildTimesInfo(controller),
//         20.verticalSpace,
//         _buildActionButton(controller),
//       ],
//     );
//   }

//   Widget _buildGoogleMapsLocation(AttendanceController controller) {
//     return SizedBox(
//       height: 300.h,
//       width: Get.width,
//       child: Obx(() {
//         // Show loading indicator until currentPosition is available
//         if (controller.currentPosition.value == null) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         return GoogleMap(
//           myLocationEnabled: true,
//           myLocationButtonEnabled: true,
//           initialCameraPosition: CameraPosition(
//             target: controller.currentPosition.value!,
//             zoom: 17,
//           ),
//           onMapCreated: controller.onMapCreated,
//           circles: {
//             Circle(
//               circleId: const CircleId('office_radius'),
//               center: controller.officeLocation,
//               radius: controller.officeRadius,
//               strokeColor: Colors.green,
//               strokeWidth: 2,
//               fillColor: Colors.green.withOpacity(0.2),
//             ),
//           },
//           markers: {
//             Marker(
//               markerId: const MarkerId('office_marker'),
//               position: controller.officeLocation,
//             ),
//             Marker(
//               markerId: const MarkerId('user_marker'),
//               position: controller.currentPosition.value!,
//               icon: BitmapDescriptor.defaultMarkerWithHue(
//                   BitmapDescriptor.hueBlue),
//             ),
//           },
//         );
//       }),
//     );
//   }

//   Widget _buildPhotoPreview(AttendanceController controller) {
//     return SizedBox(
//       height: 300.h,
//       width: Get.width,
//       child: Obx(() {
//         if (controller.takenPhoto.value == null) {
//           return const Center(child: Text('No Photo Taken'));
//         }
//         return Image.file(
//           controller.takenPhoto.value!,
//           fit: BoxFit.cover,
//         );
//       }),
//     );
//   }

//   Widget _buildBackgroundImage(AttendanceController controller) {
//     if (controller.isCheckOut.value) {
//       return Container(
//         padding: REdgeInsets.only(bottom: 5),
//         height: 258.h,
//         child: Image.asset('assets/images/img_bg_checkout.jpg'),
//       );
//     } else if (controller.isBreakTime.value) {
//       return Container(
//         padding: REdgeInsets.only(left: 20, bottom: 5),
//         height: 200.h,
//         child: Image.asset('assets/images/img_bg_coffe_break.png'),
//       );
//     } else if (controller.isCheckIn.value) {
//       return Container(
//         padding: REdgeInsets.only(bottom: 5),
//         height: 188.h,
//         child: Image.asset('assets/images/img_bg_working_time.png'),
//       );
//     } else {
//       return const SizedBox.shrink();
//     }
//   }

//   Widget _buildTimeDisplay(AttendanceController controller) {
//     if (controller.isCheckOut.value) {
//       return Text(
//         DateFormat('hh:mm:ss a').format(controller.checkOutTime.value),
//         style: TS.headlineSmall,
//       );
//     } else if (controller.isBreakTime.value) {
//       return Text(
//         controller.countTimes.value,
//         style: TS.headlineSmall,
//       );
//     } else {
//       return Text(
//         DateFormat('hh:mm:ss a').format(controller.currentTime.value),
//         style: TS.headlineSmall,
//       );
//     }
//   }

//   Widget _buildTimesInfo(AttendanceController controller) {
//     if (controller.isBreakTime.value) {
//       return Text.rich(
//         TextSpan(
//           children: [
//             TextSpan(text: 'Your break time start from ', style: TS.bodyMedium),
//             TextSpan(
//               text: DateFormat('hh:mm a').format(controller.breakTime.value),
//               style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       );
//     } else {
//       return Text(
//         DateFormat('MMMM dd, yyyy - EEEE').format(DateTime.now()),
//         style: TS.bodyMedium,
//       );
//     }
//   }

//   Widget _buildActionButton(AttendanceController controller) {
//     if (controller.isCheckIn.value) {
//       return SizedBox(
//         width: Get.width,
//         child: Column(
//           children: [
//             if (!controller.isCheckOut.value)
//               if (controller.isBreakTime.value)
//                 ButtonPrimary(
//                   padding: REdgeInsets.symmetric(vertical: 5),
//                   fullWidth: true,
//                   color: white,
//                   onPressed: controller.endBreakTime,
//                   text: 'End Break',
//                   textColor: primary,
//                   borderSide: const BorderSide(color: primary),
//                 )
//               else
//                 controller.hasTakenBreak.value
//                     ? ButtonPrimary(
//                         padding:
//                             REdgeInsets.symmetric(horizontal: 8, vertical: 5),
//                         color: white,
//                         onPressed: controller.checkOut,
//                         text: 'Check Out',
//                         textColor: primary,
//                         borderSide: const BorderSide(color: primary),
//                       )
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ButtonPrimary(
//                             padding: REdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 5),
//                             color: white,
//                             onPressed: controller.checkOut,
//                             text: 'Check Out',
//                             textColor: primary,
//                             borderSide: const BorderSide(color: primary),
//                           ),
//                           10.horizontalSpace,
//                           ButtonPrimary(
//                             padding: REdgeInsets.symmetric(
//                                 horizontal: 22, vertical: 5),
//                             onPressed: controller.startBreakTime,
//                             text: 'Take a Break',
//                           ),
//                         ],
//                       ),
//             20.verticalSpace,
//             const AppDivider(thickness: 2),
//             _buildAttendanceInfo(controller),
//           ],
//         ),
//       );
//     } else {
//       return Column(
//         children: [
//           Obx(() => CircleAvatar(
//                 backgroundColor: primary30.withOpacity(0.2),
//                 radius: 80.r,
//                 child: InkWellTap(
//                   radius: 72.r,
//                   color: controller.isLocationValid.value
//                       ? primary.withOpacity(0.3)
//                       : Colors.grey.withOpacity(0.3),
//                   onTap: controller.isLocationValid.value
//                       ? controller.checkIn
//                       : null,
//                   child: CircleAvatar(
//                     backgroundColor: controller.isLocationValid.value
//                         ? primary
//                         : Colors.grey,
//                     radius: 72.r,
//                     child: Text(
//                       'Check in',
//                       style: TS.bodyLarge.copyWith(color: white),
//                     ),
//                   ),
//                 ),
//               )),
//           10.verticalSpace,
//           Obx(() => Text(
//                 controller.isLocationValid.value
//                     ? "Check in and get started on your successful day."
//                     : "Anda berada di luar radius kantor.",
//                 style: TS.bodyMedium.copyWith(
//                     color: controller.isLocationValid.value
//                         ? Colors.black
//                         : Colors.red),
//                 textAlign: TextAlign.center,
//               )),
//         ],
//       );
//     }
//   }

//   Widget _buildAttendanceInfo(AttendanceController controller) {
//     return Column(
//       children: [
//         _buildBreakInfo(controller),
//         30.verticalSpace,
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildAttendanceDetail(
//               icon: Icons.more_time_outlined,
//               time: controller.isCheckIn.value
//                   ? DateFormat('hh:mm a').format(controller.checkInTime.value)
//                   : '--:-- AM',
//               label: 'Check in',
//             ),
//             _buildAttendanceDetail(
//               icon: Icons.timer_off_outlined,
//               time: controller.isCheckOut.value
//                   ? DateFormat('hh:mm a').format(controller.checkOutTime.value)
//                   : '--:-- PM',
//               label: 'Check out',
//             ),
//             _buildAttendanceDetail(
//               icon: Icons.check_circle_outline_rounded,
//               time: controller.isCheckOut.value
//                   ? controller.totalHours.value
//                   : '--h --m',
//               label: 'Total Hours',
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildAttendanceDetail(
//       {required IconData icon, required String time, required String label}) {
//     return Column(
//       children: [
//         Icon(icon),
//         5.verticalSpace,
//         Text(time, style: TS.titleSmall),
//         Text(label, style: TS.bodyMedium),
//       ],
//     );
//   }

//   Widget _buildBreakInfo(AttendanceController controller) {
//     return Obx(() {
//       if (controller.breakEndTime.value == null) {
//         return const SizedBox();
//       }

//       return Container(
//         width: Get.width,
//         margin: const EdgeInsets.only(top: 20),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: secondary2.withValues(alpha: 0.5),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           children: [
//             Text(
//               "Break Time",
//               style: TS.titleSmall.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "${DateFormat('hh:mm a').format(controller.breakTime.value)}"
//               " - "
//               "${DateFormat('hh:mm a').format(controller.breakEndTime.value!)}",
//               style: TS.bodyMedium,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               "Duration: ${controller.breakDuration.value}",
//               style: TS.bodyMedium.copyWith(fontWeight: FontWeight.w600),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
