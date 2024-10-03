import 'package:flutter/material.dart';

class LeaveRequestDummyData {
  LeaveRequestDummyData({
    required this.description,
    required this.status,
    required this.types,
    required this.iconStatus,
    required this.statusColor,
    required this.date,
  });

  final String description;
  final String status;
  final String types;
  final String iconStatus;
  final Color statusColor;
  final String date;
}
