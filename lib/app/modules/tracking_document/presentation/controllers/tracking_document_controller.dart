import 'package:get/get.dart';
import 'package:iroyal/app/modules/tracking_document/domain/entities/approval_document.dart';
import 'package:iroyal/app/modules/tracking_document/domain/entities/status_approval_entities.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/utils/app_utils.dart';

class TrackingDocumentController extends GetxController {
  RxList<ApprovalDocument> statusOverdue = <ApprovalDocument>[].obs;
  RxList<ApprovalDocument> statusUrgent = <ApprovalDocument>[].obs;

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

  @override
  void onInit() {
    _filterStatusApproval();
    super.onInit();
  }

  void _filterStatusApproval() {
    statusOverdue.value = generateOverdue();
    statusUrgent.value = generateUrgent();
  }

  List<ApprovalDocument> generateOverdue() {
    final urgent = <ApprovalDocument>[];

    for (var menu in listApproval) {
      if (menu.status.any((status) => status.status == 'OVERDUE')) {
        AppUtils.logApp('OVERDUE ::::${menu.status.length}');
        urgent.add(menu);
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
}
