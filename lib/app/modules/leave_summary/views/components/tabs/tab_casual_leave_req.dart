import 'package:flutter/material.dart';
import 'package:iroyal/app/modules/leave_summary/controllers/leave_summary_controller.dart';
import 'package:iroyal/app/modules/leave_summary/views/components/shared/leave_request_card.dart';

class TabCasualLeaveRequest extends StatelessWidget {
  const TabCasualLeaveRequest({super.key, required this.controller});

  final LeaveSummaryController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.listCasualDummy.length,
        itemBuilder: (_, index) {
          final r = controller.listCasualDummy[index];
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
