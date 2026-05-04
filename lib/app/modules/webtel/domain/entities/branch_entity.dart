import 'package:flutter/material.dart';

class BranchEntity {
  BranchEntity({
    required this.branchName,
    required this.code,
    required this.logo,
    required this.color,
  });

  final String branchName;
  final String code;
  final String logo;
  final Color color;
}
