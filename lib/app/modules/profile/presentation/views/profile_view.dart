import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/home/presentation/views/components/shimmer_text.dart';

import 'package:MyRoyal/app/modules/profile/presentation/views/components/tabs/tab_documents.dart';
import 'package:MyRoyal/app/modules/profile/presentation/views/components/tabs/tab_personal.dart';
import 'package:MyRoyal/app/modules/profile/presentation/views/components/tabs/tab_professional.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/appbar_spacer.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'Profile',
      actions: [_editProfile()],
      child: ProfileViewImpl(controller: controller),
    );
  }

  Widget _editProfile() {
    return EPadding(
      padding: const EdgeInsets.only(right: 10),
      child: Obx(
        () => controller.isLoading.value
            ? ShimmerText(
                height: 20.h,
                width: 100.w,
              )
            : TextButton(
                child: Text(
                  'Edit Profile',
                  style: TS.bodyMedium.copyWith(
                    color: secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () async {
                  await Get.toNamed(
                    Routes.EDIT_PROFILE,
                    arguments: [
                      controller.profileData(),
                      controller.id.value,
                      controller.userData()
                    ],
                  )?.then((value) {
                    if (value == true) {
                      controller.refreshProfile();
                    }
                  });
                },
              ),
      ),
    );
  }
}

class ProfileViewImpl extends StatelessWidget {
  const ProfileViewImpl({
    super.key,
    required this.controller,
  });

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppbarSpacer(),
        _buildProfilePicture(),
        _buildTabBar(),
        _buildTabBarView(),
      ],
    );
  }

  Widget _buildProfilePicture() {
    return Obx(
      () => controller.isLoading.value
          ? _loadingShimmerProfilePicture()
          : _loadedProfilePicture(),
    );
  }

  Widget _loadedProfilePicture() {
    return ListTile(
      horizontalTitleGap: 5,
      leading: CircleAvatar(
        radius: 30,
        backgroundColor:
            controller.profileData().data.personal.profilePicture.isNotEmpty
                ? white
                : secondary,
        child: controller.profileData().data.personal.profilePicture.isNotEmpty
            ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl:
                      controller.profileData().data.personal.profilePicture,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return Image.network(
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      'https://avatar.iran.liara.run/public',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return CachedNetworkImage(
                          imageUrl:
                              "https://api.dicebear.com/7.x/initials/png?seed=${controller.userData.value.initialName}",
                        );
                      },
                    );
                  },
                ),
              )
            : Text(
                controller.userData().initialName,
                style: TS.titleLarge,
              ),
      ),
      title: Text(
        controller.profileData().data.personal.fullName.isNotEmpty
            ? controller.profileData().data.personal.fullName
            : '',
        style: TS.titleSmall,
      ),
      subtitle: Text(
        controller.profileData().data.professional.workEmail.isNotEmpty
            ? controller.profileData().data.professional.workEmail
            : '',
        style: TS.bodyMedium,
      ),
    );
  }

  Widget _loadingShimmerProfilePicture() {
    return ListTile(
        horizontalTitleGap: 5,
        leading: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: const CircleAvatar(
            radius: 30,
          ),
        ),
        title: ShimmerText(width: 100.w),
        subtitle: ShimmerText(width: 100.w));
  }

  Widget _buildTabBar() {
    return Stack(
      fit: StackFit.passthrough,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: grey, width: 2.0),
            ),
          ),
        ),
        TabBar(
          tabAlignment: TabAlignment.center,
          padding: EdgeInsets.zero,
          isScrollable: true,
          controller: controller.tabController,
          indicator: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 2),
            ),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: TS.bodyMedium.copyWith(color: primary),
          unselectedLabelStyle: TS.bodyMedium.copyWith(color: primary),
          unselectedLabelColor: primary,
          tabs: const [
            Tab(text: 'Personal'),
            Tab(text: 'Professional'),
            Tab(text: 'Documents'),
          ],
        ),
      ],
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: controller.tabController,
        children: [
          TabPersonalView(controller: controller),
          TabProfessionalView(controller: controller),
          TabDocumentsView(controller: controller),
        ],
      ),
    );
  }
}
