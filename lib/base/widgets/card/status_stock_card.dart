import 'package:flutter/material.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';

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
