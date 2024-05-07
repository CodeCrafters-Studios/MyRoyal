import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/webtel/presentation/views/components/card_branch.dart';
import 'package:iroyal/app/modules/webtel/presentation/views/components/page_branch.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/webtel_controller.dart';

class WebtelView extends GetView<WebtelController> {
  const WebtelView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: true,
      title: 'Webtel',
      child: Obx(
        () => WebtelViewImpl(controller: controller),
      ),
    );
  }
}

class WebtelViewImpl extends StatelessWidget {
  const WebtelViewImpl({super.key, required this.controller});

  final WebtelController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppbarSpacer(),
        Expanded(
          child: controller.isLoading.value
              ? _buildShimmerGridView()
              : _buildDataGridView(),
        ),
      ],
    );
  }

  Widget _buildShimmerGridView() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.branchData.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          return BranchCard(
            onTap: () {},
            branchName: '',
            branchCode: '',
            logo: 'assets/images/img_placeholder.png',
            totalbranch: '',
            color: Colors.grey,
          );
        },
      ),
    );
  }

  Widget _buildDataGridView() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: controller.branchData.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final data = controller.branchData[index];
        final rasItems = controller.rasData.length.toString();
        final bmItems = controller.bmData.length.toString();
        final acaItems = controller.acaData.length.toString();

        return BranchCard(
          onTap: () {
            switch (data.code) {
              case 'RAS':
                Get.to(
                  () => BranchPage(
                    title: 'PT Royal Abadi Sejahtera',
                    controller: controller,
                    data: controller.filterRasData,
                  ),
                );
                break;
              case 'BM':
                Get.to(
                  () => BranchPage(
                    title: 'PT Bestari Mulia',
                    controller: controller,
                    data: controller.filterBmData,
                  ),
                );
                break;
              default:
                Get.to(
                  () => BranchPage(
                    title: 'PT Cemerlang Abadi Mulia',
                    controller: controller,
                    data: controller.filterAcaData,
                  ),
                );
                break;
            }
          },
          branchName: data.branchName,
          branchCode: data.code,
          logo: data.logo,
          totalbranch: data.code == 'RAS'
              ? rasItems
              : data.code == 'BM'
                  ? bmItems
                  : acaItems,
          color: data.color,
        );
      },
    );
  }
}
