import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/my_teams/presentation/views/components/expansion_tile.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';
import 'package:iroyal/base/widgets/others/no_result_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/my_teams_controller.dart';

class MyTeamsView extends GetView<MyTeamsController> {
  const MyTeamsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'My Teams',
      child: SingleChildScrollView(
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AppbarSpacer(),
              _buildSearchInput(),
              _buildListView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchInput() {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InputPrimary(
        controller: controller.searchE,
        key: const Key('searchUser'),
        label: '',
        hint: 'Search',
        onChanged: controller.onChanged,
        color: white,
        outlineColor: primary,
        prefixIcon: EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SvgPicture.asset(
            'assets/icons/ic_search.svg',
            width: 20.w,
            height: 20.w,
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return controller.isLoading.value
        ? _buildLoadingList()
        : controller.filteredList.isNotEmpty
            ? _buildFilteredList()
            : SizedBox(
                height: 250.h,
                child: const NoResultWidget(),
              );
  }

  Widget _buildLoadingList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SizedBox(
        height: 400.h,
        child: ListView.builder(
          padding: REdgeInsets.symmetric(horizontal: 4),
          itemCount: 10,
          itemBuilder: (context, index) {
            return const ExpansionTileControllerApp(
              imgAvatar: '',
              username: '',
              departement: '',
              email: '',
              children: [],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilteredList() {
    return SizedBox(
      height: 400.h,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.filteredList.length,
        itemBuilder: (context, index) {
          final String name = controller.filteredList[index].fullName;
          final split = name.split(' ');
          final firstChar = split.first.substring(0, 1).toUpperCase();
          final secondChar = split.last.substring(0, 1).toUpperCase();
          return ExpansionTileControllerApp(
            imgAvatar: firstChar + secondChar,
            username: controller.filteredList[index].fullName,
            departement: controller.filteredList[index].job.position,
            email: controller.filteredList[index].job.workEmail,
            children: controller.filteredList[index].children,
          );
        },
      ),
    );
  }
}
