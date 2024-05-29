import 'package:flutter/material.dart';

class StatusApprovalEntity {
  StatusApprovalEntity({
    required this.icon,
    required this.status,
    required this.iconColor,
    required this.statusColor,
    required this.borderColor,
    required this.decorationColor,
    required this.isIcon,
  });

  final String icon;
  final String status;
  final Color iconColor;
  final Color statusColor;
  final Color borderColor;
  final Color decorationColor;
  final bool isIcon;
}
