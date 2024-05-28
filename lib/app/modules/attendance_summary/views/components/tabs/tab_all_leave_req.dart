import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/app/modules/attendance_summary/controllers/attendance_summary_controller.dart';
import 'package:iroyal/app/modules/attendance_summary/views/components/shared/leave_request_card.dart';

class TabAllLeaveRequest extends StatelessWidget {
  const TabAllLeaveRequest({super.key, required this.controller});

  final AttendanceSummaryController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.listAllLeaveRequestDummy.length,
        itemBuilder: (_, index) {
          final r = controller.listAllLeaveRequestDummy[index];
          return LeaveRequestCard(
            onTap: () {},
            date: r.date,
            status: r.status,
            description: r.description,
            statusColor: r.statusColor,
            types: r.types,
          );
        },
      ),
    );
  }
}
