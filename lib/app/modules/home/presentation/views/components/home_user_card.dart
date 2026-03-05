import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/widgets/padding.dart';

class HomeUserCard extends StatelessWidget {
  const HomeUserCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.initial,
    required this.isThridLine,
    this.isImageAvailable = false,
    this.withAvatar = false,
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
  final bool isImageAvailable;
  final bool withAvatar;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderSideColor;
  final bool? shapeBorder;

  @override
  Widget build(BuildContext context) {
    return EPadding(
      padding: EdgeInsets.fromLTRB(isImageAvailable ? 5 : 12, 10, 0, 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          withAvatar
              ? CircleAvatar(
                  radius: 30,
                  backgroundColor: isImageAvailable ? white : secondary,
                  child: isImageAvailable
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: avatarPicture,
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                            errorWidget: (context, url, error) {
                              AppUtils.logApp(error.toString());
                              return Image.network(
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                'https://avatar.iran.liara.run/public',
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return const Icon(
                                    Icons.error,
                                    size: 40,
                                    color: red,
                                  );
                                },
                              );
                            },
                          ),
                        )
                      : Text(
                          initial ?? '',
                          style: TS.titleLarge,
                        ),
                )
              : emptyBox,
          withAvatar ? 12.horizontalSpace : emptyBox,
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
