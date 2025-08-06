import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/others/no_result_widget.dart';

import '../controllers/cam_app_reserved_by_controller.dart';

class CamAppReservedByView extends GetView<CamAppReservedByController> {
  const CamAppReservedByView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        backgroundColor: primary,
        iconTheme: IconThemeData(color: white),
        toolbarHeight: 70.h,
        title: Text(
          'Reserved By CAM',
          style: TS.titleSmall.copyWith(color: white),
          textAlign: TextAlign.start,
        ),
      ),
      body: RPadding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Obx(
          () => controller.isLoading.value
              ? ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  itemCount: 10,
                  itemBuilder: (_, __) => ShimmerText(
                    width: Get.width,
                    height: 128,
                  ),
                )
              : controller.reservedByData.value.data?.data.isEmpty == true
                  ? Center(
                      child: NoResultWidget(
                        description:
                            "We'are sorry what you were looking for.\nNo Data found.",
                      ),
                    )
                  : ListView.builder(
                      itemCount:
                          controller.reservedByData.value.data!.data.length,
                      itemBuilder: (context, index) {
                        final item =
                            controller.reservedByData.value.data!.data[index];

                        return Slidable(
                          key: ValueKey(item.genericKey),
                          endActionPane: ActionPane(
                            dismissible: DismissiblePane(
                              key: ValueKey(
                                  'dismissible_pane_${item.genericKey}'),
                              onDismissed: () =>
                                  // controller.updateReservedByData(item.genericKey),
                                  controller.updateReservedByData(
                                      item.genericKey, index),
                            ),
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                borderRadius: BorderRadius.circular(20),
                                onPressed: (context) =>
                                    controller.updateReservedByData(
                                        item.genericKey, index),
                                backgroundColor: const Color(0xFF2E7D31),
                                foregroundColor: Colors.white,
                                icon: Icons.check_circle_outline,
                                label: 'Release',
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                              ),
                              // SlidableAction(
                              //   borderRadius: BorderRadius.circular(25),
                              //   onPressed: (context) {
                              //     controller.removeItem(index);
                              //   },
                              //   backgroundColor: const Color(0xFFE83232),
                              //   foregroundColor: Colors.white,
                              //   icon: Icons.watch_later_outlined,
                              //   label: 'Later',
                              // ),
                            ],
                          ),
                          child: Card(
                            margin: EdgeInsets.symmetric(vertical: 8.h),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Username / ID',
                                              style: TS.titleSmall,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(': ${item.userId}',
                                                  style: TS.bodyMedium),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text(
                                              'Generic Key',
                                              style: TS.titleSmall,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                ': ${item.genericKey}',
                                                style: TS.bodyMedium,
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text(
                                              'Date',
                                              style: TS.titleSmall,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                ': ${item.date}',
                                                style: TS.bodyMedium,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text('Time', style: TS.titleSmall),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                ': ${item.time}',
                                                style: TS.bodyMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  RPadding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/ic_check.svg',
                                          height: 30,
                                          width: 30,
                                        ),
                                        Text(
                                          'Swipe',
                                          style: TS.titleSmall.copyWith(
                                            color: secondary,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
