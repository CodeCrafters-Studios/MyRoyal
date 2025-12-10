import 'package:flutter/material.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';

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
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorContainerTransaction.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Center(
                  child: Text(
                    'IN $transaction',
                    style:
                        TS.bodyMediumBold.copyWith(color: colorTextTransaction),
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
              style: TS.bodyMediumBold.copyWith(color: primary),
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
