import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/tracking_document/domain/entities/approval_document.dart';
import 'package:iroyal/app/modules/tracking_document/domain/entities/status_approval_entities.dart';
import 'package:iroyal/app/modules/tracking_document/domain/entities/tracking_document.dart';
import 'package:iroyal/app/modules/tracking_document/domain/usecase/get_tracking_document.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/utils/app_utils.dart';

class TrackingDocumentController extends GetxController {
  TrackingDocumentController({required this.getTrackingDocument});

  TextEditingController searchDoc = TextEditingController();

  RxList<ApprovalDocument> statusOverdue = <ApprovalDocument>[].obs;
  RxList<ApprovalDocument> statusUrgent = <ApprovalDocument>[].obs;
  RxList<TrackingDocument> trackingDocData = <TrackingDocument>[].obs;
  RxList<TrackingDocument> filterDoc = <TrackingDocument>[].obs;

  final GetTrackingDocument getTrackingDocument;

  RxBool isLoading = false.obs;

  String trackingDocumentState = '';
  RxString valueListener = ''.obs;

  List<ApprovalDocument> listApproval = <ApprovalDocument>[
    ApprovalDocument(
      title: 'Request for man power replacement',
      body: 'body',
      status: [
        StatusApprovalEntity(
          borderColor: primary50,
          decorationColor: primary50,
          icon: '!',
          iconColor: primary50,
          isIcon: false,
          status: 'OVERDUE',
          statusColor: primary50,
        ),
        StatusApprovalEntity(
          borderColor: secondary,
          decorationColor: secondary,
          icon: '',
          iconColor: secondary,
          isIcon: true,
          status: 'URGENT',
          statusColor: secondary,
        ),
      ],
      date: '08.05.2021',
      attachment: 2,
    ),
    ApprovalDocument(
      title: 'Request for man power replacement',
      body: 'body',
      status: [
        StatusApprovalEntity(
          borderColor: primary50,
          decorationColor: primary50,
          icon: '!',
          iconColor: primary50,
          isIcon: false,
          status: 'OVERDUE',
          statusColor: primary50,
        ),
      ],
      date: '08.05.2021',
      attachment: 2,
    ),
    ApprovalDocument(
      title: 'Request for man power replacement',
      body: 'body',
      status: [
        StatusApprovalEntity(
          borderColor: secondary,
          decorationColor: secondary,
          icon: '',
          iconColor: secondary,
          isIcon: true,
          status: 'URGENT',
          statusColor: secondary,
        ),
      ],
      date: '08.05.2021',
      attachment: 2,
    ),
    ApprovalDocument(
      title: 'Request for man power replacement',
      body: 'body',
      status: [],
      date: '08.05.2021',
      attachment: 2,
    ),
  ];

  List<StatusApprovalEntity> listStatus = <StatusApprovalEntity>[
    StatusApprovalEntity(
      borderColor: primary50,
      decorationColor: primary50,
      icon: '!',
      iconColor: primary50,
      isIcon: false,
      status: 'OVERDUE',
      statusColor: primary50,
    ),
    StatusApprovalEntity(
      borderColor: secondary,
      decorationColor: secondary,
      icon: '',
      iconColor: secondary,
      isIcon: true,
      status: 'URGENT',
      statusColor: secondary,
    ),
  ];
  @override
  void onInit() {
    _filterStatusApproval();
    _getDataTrackingDocument();
    super.onInit();
  }

  Future<void> _getDataTrackingDocument() async {
    isLoading.value = true;

    final r = await getTrackingDocument();
    isLoading.value = false;
    r.fold(
      (l) => trackingDocumentState = 'getTrackDocFailed',
      (r) {
        trackingDocumentState = 'getTrackDocSuccess';
        trackingDocData.value = r;
        filterDoc.value = r;
      },
    );
  }

  void _filterStatusApproval() {
    statusOverdue.value = generateOverdue();
    statusUrgent.value = generateUrgent();
  }

  List<ApprovalDocument> generateOverdue() {
    final urgent = <ApprovalDocument>[];

    for (var data in listApproval) {
      if (data.status.any((status) => status.status == 'OVERDUE')) {
        AppUtils.logApp('OVERDUE ::::${data.status.length}');
        urgent.add(data);
      }
    }

    AppUtils.logApp('${urgent.length}');
    return urgent;
  }

  List<ApprovalDocument> generateUrgent() {
    final urgent = <ApprovalDocument>[];

    for (var menu in listApproval) {
      if (menu.status.any((status) => status.status == 'URGENT')) {
        AppUtils.logApp('URGENT ::::${menu.status.length}');
        urgent.add(menu);
      }
    }

    AppUtils.logApp('${urgent.length}');
    return urgent;
  }

  void clear() {
    searchDoc.clear();
    filterDoc(trackingDocData);
    valueListener.value = '';
  }

  void onChangedD(String value) {
    valueListener.value = value;
    _filterData(value, trackingDocData, filterDoc);
  }

  void _filterData(String value, RxList<TrackingDocument> data,
      RxList<TrackingDocument> filterData) {
    if (value.isEmpty) {
      filterData.value = data;
      AppUtils.logApp('${filterData.length}');
    } else {
      filterData.value = data
          .where((e) =>
              e.title.toLowerCase().contains(value.toLowerCase()) ||
              e.department
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              e.serialNumber
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase()))
          .toList();
      AppUtils.logApp('${filterData.length}');
    }
  }
}
