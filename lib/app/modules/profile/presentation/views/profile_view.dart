import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:iroyal/app/modules/profile/presentation/views/components/tabs/tab_documents.dart';
import 'package:iroyal/app/modules/profile/presentation/views/components/tabs/tab_personal.dart';
import 'package:iroyal/app/modules/profile/presentation/views/components/tabs/tab_professional.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';

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
      child: TextButton(
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
      () => ListTile(
        horizontalTitleGap: 5,
        leading: CircleAvatar(
          backgroundColor: primary,
          radius: 35,
          backgroundImage: controller.userData().profilePicture.isNotEmpty
              ? CachedNetworkImageProvider(
                  controller.profileData().data.personal.profilePicture,
                )
              : null,
          child: controller.userData().profilePicture.isEmpty
              ? Text(
                  controller.userData().initialName,
                  style: TS.titleLarge,
                )
              : null,
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
      ),
    );
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
