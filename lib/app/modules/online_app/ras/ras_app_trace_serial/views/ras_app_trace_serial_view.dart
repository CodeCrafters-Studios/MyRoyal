import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/card/mutation_card.dart';
import 'package:iroyal/base/widgets/card/status_stock_card.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';

import '../controllers/ras_app_trace_serial_controller.dart';

class RasAppTraceSerialView extends GetView<RasAppTraceSerialController> {
  const RasAppTraceSerialView({super.key});
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
          'Tracking Serial RAS',
          style: TS.titleSmall.copyWith(color: white),
          textAlign: TextAlign.start,
        ),
      ),
      body: EPadding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Obx(
          () => controller.isLoading.value
              ? Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: ShimmerText(
                          width: 160,
                          height: 50,
                        )),
                        SizedBox(width: 10),
                        ShimmerText(
                          width: 80,
                          height: 50,
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    ShimmerText(width: Get.width, height: 60),
                    SizedBox(height: 15),
                    ShimmerText(width: Get.width, height: 60),
                  ],
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: InputPrimary(
                              controller: controller.textEditingController,
                              hint: 'eg. 0231IUISAUDHIA',
                              onChanged: (e) {},
                              color: white,
                              outlineColor: grey,
                              suffixIcon: IconButton(
                                onPressed: controller
                                        .textEditingController.text.isEmpty
                                    ? null
                                    : controller.getTraceSerial,
                                icon: const Icon(Icons.search),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => controller.openScanner(),
                            child: Container(
                              height: 50,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: grey)),
                              child: Center(
                                child: Icon(
                                  Icons.qr_code_2_rounded,
                                  size: 28,
                                  color: secondary,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.isExpand.value =
                                  !controller.isExpand.value;
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 5),
                              height: 60,
                              width: Get.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: primary,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Mutation',
                                    style:
                                        TS.titleMedium.copyWith(color: white),
                                  ),
                                  Obx(
                                    () => SvgPicture.asset(
                                      height: 30,
                                      width: 30,
                                      controller.isExpand.value
                                          ? 'assets/icons/ic_arrow-circle-up.svg'
                                          : 'assets/icons/ic_arrow-circle-down.svg',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Visibility(
                              visible: controller.isExpand.value,
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: controller.traceSerialData.value
                                          .data?.mutasi?.length ??
                                      0,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 20),
                                  itemBuilder: (context, index) {
                                    final data = controller.traceSerialData
                                        .value.data!.mutasi![index];

                                    return MutationCard(
                                      noOV: data.nobukti ?? '',
                                      date: data.tanggal ?? '',
                                      transaction: data.transaksi ?? '',
                                      customer: data.customer ?? '',
                                      note: data.ket ?? '',
                                      jde: data.kodebrg ?? '',
                                      name: data.namabrg ?? '',
                                      serial: data.serial ?? '',
                                      containerID: data.exsjPick ?? '',
                                      orderType: data.orderPo ?? '',
                                      color: data.warnaTransaksi == 0
                                          ? Color(0xFF56597D).withOpacity(0.1)
                                          : Color(0x26FF8D8D).withOpacity(0.1),
                                      colorContainerTransaction:
                                          data.warnaTransaksi == 0
                                              ? Color(0xFF2E7D31)
                                              : red,
                                      colorTextTransaction:
                                          data.warnaTransaksi == 0
                                              ? Color(0xFF2E7D31)
                                              : red,
                                    );
                                  })),
                          controller.isExpand.value &&
                                  controller.traceSerialData.value.data?.mutasi
                                          ?.isNotEmpty ==
                                      true
                              ? SizedBox(height: 20)
                              : SizedBox(),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.isExpandStatus.value =
                                  !controller.isExpandStatus.value;
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 5),
                              height: 60,
                              width: Get.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: primary,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Status Stock',
                                    style:
                                        TS.titleMedium.copyWith(color: white),
                                  ),
                                  Obx(
                                    () => SvgPicture.asset(
                                        height: 30,
                                        width: 30,
                                        controller.isExpandStatus.value
                                            ? 'assets/icons/ic_arrow-circle-up.svg'
                                            : 'assets/icons/ic_arrow-circle-down.svg'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Visibility(
                              visible: controller.isExpandStatus.value,
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller.traceSerialData.value.data
                                        ?.stock?.length ??
                                    0,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 20),
                                itemBuilder: (context, index) {
                                  final data = controller.traceSerialData.value
                                      .data!.stock![index];

                                  return StatusStockCard(
                                    serial: data.serial ?? '',
                                    branch: data.branch ?? '',
                                    itemNumber: data.itemNumber ?? '',
                                    onHand: data.onHand ?? '',
                                    commit: data.commit ?? '',
                                    intransit: data.intransit ?? '',
                                    receipt: data.receipt ?? '',
                                    expiredDate:
                                        data.expiredDate.toString() == '0'
                                            ? '-'
                                            : data.expiredDate.toString(),
                                  );
                                },
                              )),
                        ],
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
