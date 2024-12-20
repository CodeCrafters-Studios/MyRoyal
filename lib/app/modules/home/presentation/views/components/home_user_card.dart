import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/padding.dart';

class HomeUserCard extends StatelessWidget {
  const HomeUserCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.initial,
    required this.isThridLine,
    required this.isAvatarPicture,
    this.isImageAvailable = false,
    this.textColor,
    this.backgroundColor,
    this.borderSideColor,
    this.shapeBorder,
    this.thridLineTitle,
    this.thridLineSubtitle,
    this.avatarPicture = '',
  });

  final String title;
  final String subtitle;
  final String? initial;
  final String? thridLineTitle;
  final String? thridLineSubtitle;
  final String avatarPicture;
  final bool isThridLine;
  final bool isAvatarPicture;
  final bool isImageAvailable;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderSideColor;
  final bool? shapeBorder;

  @override
  Widget build(BuildContext context) {
    return EPadding(
      padding: EdgeInsets.fromLTRB(isAvatarPicture ? 5 : 12, 10, 0, 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isAvatarPicture
              ? CircleAvatar(
                  backgroundColor: isImageAvailable ? null : secondary,
                  backgroundImage: isImageAvailable
                      ? CachedNetworkImageProvider(
                          avatarPicture.isNotEmpty
                              ? avatarPicture
                              : 'https://via.placeholder.com/150',
                        )
                      : null,
                  radius: 30,
                  child: isImageAvailable
                      ? emptyBox
                      : Text(
                          initial ?? '',
                          style: TS.titleLarge,
                        ))
              : emptyBox,
          isAvatarPicture == true ? 12.horizontalSpace : emptyBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TS.titleSmall.copyWith(
                    color: textColor ?? primary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TS.labelMedium.copyWith(
                    color: textColor ?? primary,
                    height: 2,
                  ),
                ),
                isThridLine == true
                    ? Text(
                        thridLineTitle ?? "No. Badge | Jabatan",
                        style: TS.labelMedium.copyWith(
                          color: textColor ?? primary,
                        ),
                      )
                    : emptyBox,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
