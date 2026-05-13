import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/card/card_app.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:shimmer/shimmer.dart';

class HomeUserInfo extends GetView<HomeController> {
  const HomeUserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Obx(
        () => EPadding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: controller.isLoading.value ? _buildLoading() : _buildCard(),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Container(
        height: 86.h,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }

  Widget _buildCard() {
    final userData = controller.userData().data;
    final isImageAvailable = controller.isImageAvailable.value;

    return CardApp(
      color: white,
      radius: 16,
      onTap: () => Get.toNamed(Routes.PROFILE),
      padding: REdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar with gold ring
          _buildAvatar(
              userData.profilePicture, userData.initialName, isImageAvailable),
          12.horizontalSpace,
          // User info — wrapped in Expanded to bound the width for its inner Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userData.email.isNotEmpty ? userData.email : '-',
                  style: TS.titleSmall.copyWith(color: primary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                4.verticalSpace,
                Text(
                  '${userData.employeeNumber} | ${userData.position}',
                  style: TS.labelSmall.copyWith(color: greyText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (userData.joinDate.isNotEmpty) ...[
                  3.verticalSpace,
                  Text(
                    'Joined: ${userData.joinDate}',
                    style: TS.caption.copyWith(color: greyText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          8.horizontalSpace,
          // Department pill badge
          if (userData.department.isNotEmpty)
            Container(
              constraints: BoxConstraints(maxWidth: 90.w),
              padding: REdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                userData.department,
                style: TS.caption.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          6.horizontalSpace,
          Icon(
            Icons.chevron_right_rounded,
            color: greyText,
            size: 18.w,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(
      String pictureUrl, String initial, bool isImageAvailable) {
    final Widget content = isImageAvailable && pictureUrl.isNotEmpty
        ? ClipOval(
            child: CachedNetworkImage(
              imageUrl: pictureUrl,
              width: 44.r,
              height: 44.r,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => _initialAvatar(initial),
            ),
          )
        : _initialAvatar(initial);

    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: Gradients.gold(),
      ),
      child: CircleAvatar(
        radius: 22.r,
        backgroundColor: isImageAvailable ? white : secondary.withOpacity(0.25),
        child: content,
      ),
    );
  }

  Widget _initialAvatar(String initial) {
    return Center(
      child: Text(
        initial.isNotEmpty ? initial : '?',
        style:
            TS.titleSmall.copyWith(color: primary, fontWeight: FontWeight.w800),
      ),
    );
  }
}
