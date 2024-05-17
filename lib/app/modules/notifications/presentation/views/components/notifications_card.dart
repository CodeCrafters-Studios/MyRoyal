import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/padding.dart';

class NotificationsCard extends StatelessWidget {
  const NotificationsCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.isNew,
  });

  final String title;
  final String description;
  final String date;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.symmetric(horizontal: 14),
      color: isNew ? greySecond.withOpacity(0.2) : white,
      child: ListTile(
        leading: Badge(
          smallSize: 14,
          isLabelVisible: isNew,
          child: const CircleAvatar(),
        ),
        title: EPadding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            title,
            style: TS.labelLarge,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: TS.bodyMedium,
            ),
            5.verticalSpace,
            Text(
              date,
              style: TS.bodyMedium.copyWith(
                color: greyText,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
