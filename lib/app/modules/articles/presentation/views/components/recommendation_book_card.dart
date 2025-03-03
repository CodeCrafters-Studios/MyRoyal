import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';

class RecommendationBookCard extends StatelessWidget {
  const RecommendationBookCard({
    super.key,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.onTap,
  });

  final String title, description;
  final DateTime createdAt;
  final dynamic Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWellTap(
      onTap: onTap,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: TS.labelMedium,
        ),
        subtitle: Text(
          'Created at: ${DateFormat('dd MMM yyyy').format(createdAt)}',
          style: TS.bodyMini.copyWith(color: secondary),
        ),
      ),
    );
  }
}
