import 'package:flutter/material.dart';
import 'package:iroyal/app/modules/leave_summary/controllers/leave_summary_controller.dart';
import 'package:iroyal/app/modules/leave_summary/views/components/shared/leave_request_card.dart';

class TabAllLeaveRequest extends StatelessWidget {
  const TabAllLeaveRequest({super.key, required this.controller});

  final LeaveSummaryController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.listAllLeaveRequestDummy.length,
        itemBuilder: (_, index) {
          final r = controller.listAllLeaveRequestDummy[index];
          return LeaveRequestCard(
            onTap: () {},
            date: r.date,
            status: r.status,
            iconStatus: r.iconStatus,
            description: r.description,
            statusColor: r.statusColor,
            types: r.types,
          );
        },
      ),
    );
  }
}
