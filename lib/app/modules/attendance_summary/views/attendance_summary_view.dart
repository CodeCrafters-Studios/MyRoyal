import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/attendance_summary_controller.dart';

class AttendanceSummaryView extends GetView<AttendanceSummaryController> {
  const AttendanceSummaryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AttendanceSummaryView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AttendanceSummaryView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
