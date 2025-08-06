import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';

import '../controllers/ras_app_release_order_controller.dart';

class RasAppReleaseOrderView extends GetView<RasAppReleaseOrderController> {
  const RasAppReleaseOrderView({super.key});
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
          'Release Order RAS',
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
              : Column(
                  children: [
                    SizedBox(height: 20),
                    InputPrimary(
                      controller: controller.textEditingController,
                      hint: 'eg. 1234',
                      onChanged: (e) {},
                      color: white,
                      outlineColor: grey,
                      suffixIcon: IconButton(
                        onPressed: controller.getReleaseOrder,
                        icon: const Icon(Icons.search),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            controller.releaseOrderData.value.data.data.length,
                        itemBuilder: (context, index) {
                          final item = controller
                              .releaseOrderData.value.data.data[index];

                          final time =
                              controller.formatJamRelease(item.jamRelease);

                          return item.button
                              ? Slidable(
                                  key: ValueKey(item.branchPlant),
                                  endActionPane: ActionPane(
                                    dismissible: DismissiblePane(
                                      key: ValueKey(
                                          'dismissible_pane_${item.branchPlant}'),
                                      onDismissed: () =>
                                          controller.updateReleaseOrder(
                                        item.branchPlant,
                                        item.kodeHold,
                                        item.nomorOrder,
                                        item.tipeOrder,
                                        index,
                                      ),
                                    ),
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        borderRadius: BorderRadius.circular(20),
                                        onPressed: (context) =>
                                            controller.updateReleaseOrder(
                                          item.branchPlant,
                                          item.kodeHold,
                                          item.nomorOrder,
                                          item.tipeOrder,
                                          index,
                                        ),
                                        backgroundColor:
                                            const Color(0xFF2E7D31),
                                        foregroundColor: Colors.white,
                                        icon: Icons.check_circle_outline,
                                        label: 'Release',
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                      ),
                                    ],
                                  ),
                                  child: Card(
                                    margin: EdgeInsets.symmetric(vertical: 8.h),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Branch Plant',
                                                      style: TS.titleSmall,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        item.branchPlant.isEmpty
                                                            ? ': -'
                                                            : ': ${item.branchPlant}',
                                                        style: TS.bodyMedium,
                                                        maxLines: 4,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Nomor Order',
                                                      style: TS.titleSmall,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                          item.nomorOrder
                                                                  .isEmpty
                                                              ? ': -'
                                                              : ': ${item.nomorOrder}',
                                                          style: TS.bodyMedium),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Tipe Order',
                                                      style: TS.titleSmall,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                          item.tipeOrder.isEmpty
                                                              ? ': -'
                                                              : ': ${item.tipeOrder}',
                                                          style: TS.bodyMedium),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Kode Hold',
                                                      style: TS.titleSmall,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                          item.kodeHold.isEmpty
                                                              ? ': -'
                                                              : ': ${item.kodeHold}',
                                                          style: TS.bodyMedium),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Nomor RMA',
                                                      style: TS.titleSmall,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                          item.nomorRma.isEmpty
                                                              ? ': -'
                                                              : ': ${item.nomorRma}',
                                                          style: TS.bodyMedium),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Date Release',
                                                      style: TS.titleSmall,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        item.tanggalRelease
                                                                .isEmpty
                                                            ? ': -'
                                                            : ': ${item.tanggalRelease}',
                                                        style: TS.bodyMedium,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Text('Time Release',
                                                        style: TS.titleSmall),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        ': $time',
                                                        style: TS.bodyMedium,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'User Release',
                                                      style: TS.titleSmall,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                          item.userRelease
                                                                  .isEmpty
                                                              ? ': -'
                                                              : ': ${item.userRelease}',
                                                          style: TS.bodyMedium),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          RPadding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
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
                                                    fontWeight:
                                                        FontWeight.normal,
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
                                )
                              : Card(
                                  margin: EdgeInsets.symmetric(vertical: 8.h),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Branch Plant',
                                                    style: TS.titleSmall,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      item.branchPlant.isEmpty
                                                          ? ': -'
                                                          : ': ${item.branchPlant}',
                                                      style: TS.bodyMedium,
                                                      maxLines: 4,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Nomor Order',
                                                    style: TS.titleSmall,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                        item.nomorOrder.isEmpty
                                                            ? ': -'
                                                            : ': ${item.nomorOrder}',
                                                        style: TS.bodyMedium),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Tipe Order',
                                                    style: TS.titleSmall,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                        item.tipeOrder.isEmpty
                                                            ? ': -'
                                                            : ': ${item.tipeOrder}',
                                                        style: TS.bodyMedium),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Kode Hold',
                                                    style: TS.titleSmall,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                        item.kodeHold.isEmpty
                                                            ? ': -'
                                                            : ': ${item.kodeHold}',
                                                        style: TS.bodyMedium),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Nomor RMA',
                                                    style: TS.titleSmall,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                        item.nomorRma.isEmpty
                                                            ? ': -'
                                                            : ': ${item.nomorRma}',
                                                        style: TS.bodyMedium),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Date Release',
                                                    style: TS.titleSmall,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      item.tanggalRelease
                                                              .isEmpty
                                                          ? ': -'
                                                          : ': ${item.tanggalRelease}',
                                                      style: TS.bodyMedium,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text('Time Release',
                                                      style: TS.titleSmall),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      ': $time',
                                                      style: TS.bodyMedium,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text(
                                                    'User Release',
                                                    style: TS.titleSmall,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                        item.userRelease.isEmpty
                                                            ? ': -'
                                                            : ': ${item.userRelease}',
                                                        style: TS.bodyMedium),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        RPadding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Column(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/ic_approved_detail_summary.svg',
                                                height: 30,
                                                width: 30,
                                              ),
                                              Text(
                                                'Release',
                                                style: TS.titleSmall.copyWith(
                                                  color: successColor,
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
                                );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
