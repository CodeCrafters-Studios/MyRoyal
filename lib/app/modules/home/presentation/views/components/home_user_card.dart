import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/padding.dart';

class HomeUserCard extends StatelessWidget {
  const HomeUserCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isThridLine,
    required this.isAvatarPicture,
    this.textColor,
    this.backgroundColor,
    this.borderSideColor,
    this.shapeBorder,
    this.thridLineTitle,
    this.thridLineSubtitle,
    required this.suffixIcon,
    this.avatarPicture,
  });

  final String title;
  final String subtitle;
  final String? thridLineTitle;
  final String? thridLineSubtitle;
  final String? avatarPicture;
  final bool isThridLine;
  final bool isAvatarPicture;
  final bool suffixIcon;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderSideColor;
  final bool? shapeBorder;

  @override
  Widget build(BuildContext context) {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isAvatarPicture == true
              ? ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(90),
                  ),
                  child: Image.asset(
                    avatarPicture ?? 'assets/images/img_profile.png',
                    height: 68,
                    width: 68,
                    fit: BoxFit.cover,
                  ),
                )
              : const SizedBox(),
          isAvatarPicture == true ? 12.horizontalSpace : const SizedBox(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TS.labelLarge.copyWith(
                  color: textColor ?? white,
                ),
              ),
              Text(
                subtitle,
                style: TS.labelMedium.copyWith(
                  color: textColor ?? white,
                  height: 2,
                ),
              ),
              isThridLine == true
                  ? Text(
                      thridLineTitle ?? "No. Badge | Jabatan",
                      style: TS.labelMedium.copyWith(
                        color: textColor ?? white,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          suffixIcon == true
              ? const EPadding(
                  padding: EdgeInsets.only(left: 45, top: 20),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
