import 'package:flutter/material.dart';
import 'package:iroyal/app/modules/attendance_summary/controllers/attendance_summary_controller.dart';
import 'package:iroyal/app/modules/attendance_summary/views/components/shared/leave_request_card.dart';

class TabSickLeaveRequest extends StatelessWidget {
  const TabSickLeaveRequest({super.key, required this.controller});

  final AttendanceSummaryController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.listSickDummy.length,
        itemBuilder: (_, index) {
          final r = controller.listSickDummy[index];
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
