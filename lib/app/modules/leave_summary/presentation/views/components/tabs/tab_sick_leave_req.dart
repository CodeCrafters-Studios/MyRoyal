import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/app/modules/leave_summary/presentation/controllers/leave_summary_controller.dart';
import 'package:iroyal/app/modules/leave_summary/presentation/views/components/shared/leave_request_card.dart';

class TabSickLeaveRequest extends StatelessWidget {
  const TabSickLeaveRequest({super.key, required this.controller});

  final LeaveSummaryController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
        padding: REdgeInsets.only(bottom: 280),
        itemCount: controller.listSickDummy.length,
        itemBuilder: (_, index) {
          final r = controller.listSickDummy[index];
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
