import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/inkwell_tap.dart';
import 'package:MyRoyal/base/widgets/padding.dart';

class NotificationsCard extends StatelessWidget {
  const NotificationsCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.isRead,
    required this.onTap,
  });

  final String title;
  final String description;
  final String date;
  final bool isRead;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWellTap(
      onTap: onTap,
      child: Container(
        padding: REdgeInsets.symmetric(horizontal: 4, vertical: 2),
        color: isRead ? white : primary.withOpacity(0.1),
        child: ListTile(
          title: EPadding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              title,
              style: TS.labelLarge,
            ),
          ),
          subtitle: Text(
            description,
            style: TS.bodyMedium,
          ),
          isThreeLine: true,
          trailing: Text(
            date,
            style: TS.bodySmall.copyWith(
              color: greyText,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}
