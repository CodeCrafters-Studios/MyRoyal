import 'package:flutter/material.dart';

class TasksDummyData {
  TasksDummyData({
    required this.title,
    required this.status,
    required this.progress,
    required this.progressColor,
    required this.taskStatusColor,
    required this.date,
    required this.member,
  });

  final String title;
  final String status;
  final double progress;
  final Color progressColor;
  final Color taskStatusColor;
  final String date;
  final String member;
}
