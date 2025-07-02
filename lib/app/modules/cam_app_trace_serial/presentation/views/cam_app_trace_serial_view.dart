import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';

import '../controllers/cam_app_trace_serial_controller.dart';

class CamAppTraceSerialView extends GetView<CamAppTraceSerialController> {
  const CamAppTraceSerialView({super.key});
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
          'Tracking Serial',
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
                                onPressed: controller.getTraceSerial,
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
                                            : 'assets/icons/ic_arrow-circle-down.svg'),
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

class StatusStockCard extends StatelessWidget {
  const StatusStockCard({
    super.key,
    required this.serial,
    required this.branch,
    required this.itemNumber,
    required this.onHand,
    required this.commit,
    required this.intransit,
    required this.receipt,
    required this.expiredDate,
  });

  final String serial,
      branch,
      itemNumber,
      onHand,
      commit,
      intransit,
      receipt,
      expiredDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: greySecond),
        boxShadow: Shadows.small,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Container(
          //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //       decoration: ShapeDecoration(
          //         color: const Color(0x33FF7400),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(100),
          //         ),
          //       ),
          //       child: Text(status),
          //     ),
          //     Container(
          //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //       decoration: ShapeDecoration(
          //         color: const Color(0xFFE73232),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(100),
          //         ),
          //       ),
          //       child: Text('Exp: $expired'),
          //     )
          //   ],
          // ),
          // SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 87,
            dense: true,
            minVerticalPadding: 0,
            minTileHeight: 0,
            minLeadingWidth: 0,
            leading: Text(
              'Serial',
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            title: Text(
              ': $serial',
              style: TS.bodyMedium
                  .copyWith(fontWeight: FontWeight.bold, color: primary),
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 74,
            dense: true,
            minVerticalPadding: 0,
            minTileHeight: 0,
            minLeadingWidth: 0,
            leading: Text(
              'Branch',
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            title: Text(
              ': $branch',
              style: TS.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 25,
            dense: true,
            minVerticalPadding: 0,
            minTileHeight: 0,
            minLeadingWidth: 0,
            leading: Text(
              'Item Number',
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            title: Text(
              ': $itemNumber',
              style: TS.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 60,
            dense: true,
            minVerticalPadding: 0,
            minTileHeight: 0,
            minLeadingWidth: 0,
            leading: Text(
              'On Hand',
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            title: Text(
              ': $onHand',
              style: TS.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 64,
            dense: true,
            minVerticalPadding: 0,
            minTileHeight: 0,
            minLeadingWidth: 0,
            leading: Text(
              'Commit',
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            title: Text(
              ': $commit',
              style: TS.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 60,
            dense: true,
            minVerticalPadding: 0,
            minTileHeight: 0,
            minLeadingWidth: 0,
            leading: Text(
              'Intransit',
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            title: Text(
              ': $intransit',
              style: TS.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 66,
            dense: true,
            minVerticalPadding: 0,
            minTileHeight: 0,
            minLeadingWidth: 0,
            leading: Text(
              'Receipt',
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            title: Text(
              ': $receipt',
              style: TS.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Expired Date',
                style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 30),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                width: 90,
                decoration: BoxDecoration(
                  color: red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Center(
                  child: Text(
                    expiredDate,
                    style: TS.titleSmall.copyWith(color: red),
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MutationCard extends StatelessWidget {
  const MutationCard({
    super.key,
    required this.noOV,
    required this.date,
    required this.transaction,
    required this.customer,
    required this.note,
    required this.jde,
    required this.name,
    required this.serial,
    required this.containerID,
    required this.orderType,
    required this.color,
    required this.colorContainerTransaction,
    required this.colorTextTransaction,
  });

  final String noOV,
      date,
      transaction,
      customer,
      note,
      jde,
      name,
      serial,
      containerID,
      orderType;
  final Color color, colorContainerTransaction, colorTextTransaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 80,
            dense: true,
            minVerticalPadding: 0,
            minTileHeight: 0,
            minLeadingWidth: 0,
            leading: Text(
              'No OV',
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            title: Text(
              ': $noOV',
              style: TS.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 92,
            dense: true,
            minVerticalPadding: 0,
            minTileHeight: 0,
            minLeadingWidth: 0,
            leading: Text(
              'Date',
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            title: Text(
              ': $date',
              style: TS.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Transaction',
                style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 30),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                width: 90,
                decoration: BoxDecoration(
                  color: colorContainerTransaction.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Center(
                  child: Text(
                    'IN $transaction',
                    style: TS.titleSmall.copyWith(color: colorTextTransaction),
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 53,
            dense: true,
            minVerticalPadding: 0,
            minTileHeight: 0,
            minLeadingWidth: 0,
            leading: Text(
              'Customer',
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            title: Text(
              ': $customer',
              style: TS.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 91,
            dense: true,
            minVerticalPadding: 0,
            minTileHeight: 0,
            minLeadingWidth: 0,
            leading: Text(
              'Note',
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            title: Text(
              ': $note',
              style: TS.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 15,
            dense: true,
            minVerticalPadding: 0,
            minTileHeight: 0,
            minLeadingWidth: 0,
            leading: Text(
              'JDE & RICHIES\nCODE',
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              maxLines: 2,
            ),
            title: Text(
              softWrap: true,
              ''': $jde''',
              style: TS.bodyMedium,
              maxLines: 6,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 80,
            dense: true,
            minVerticalPadding: 0,
            minTileHeight: 0,
            minLeadingWidth: 0,
            leading: Text(
              'Name',
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            title: Text(
              ': $name',
              style: TS.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 85,
            dense: true,
            minVerticalPadding: 0,
            minTileHeight: 0,
            minLeadingWidth: 0,
            leading: Text(
              'Serial',
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            title: Text(
              ': $serial',
              style: TS.titleSmall.copyWith(color: primary),
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 32,
            dense: true,
            minVerticalPadding: 0,
            minTileHeight: 0,
            minLeadingWidth: 0,
            leading: Text(
              'ExSJ Pick/\nContainer ID',
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            title: Text(
              ': $containerID',
              style: TS.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 43,
            dense: true,
            minVerticalPadding: 0,
            minTileHeight: 0,
            minLeadingWidth: 0,
            leading: Text(
              'Order Type',
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            title: Text(
              ': $orderType',
              style: TS.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
