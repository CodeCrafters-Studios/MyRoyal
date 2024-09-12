import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/tracking_document/data/models/tracking_document_list_on_progress_model.dart';
import 'package:iroyal/app/modules/tracking_document/domain/entities/tracking_document_on_progress.dart';
import 'package:iroyal/app/modules/tracking_document/domain/usecase/get_tracking_document_on_progress.dart';

class TrackingDocumentController extends GetxController {
  TrackingDocumentController({
    required this.getTrackingDocumentOnProgress,
  });

  final GetTrackingDocumentOnProgress getTrackingDocumentOnProgress;

  TextEditingController searchDoc = TextEditingController();
  RxList<TrackingDocumentListOnProgressModel> filterData =
      <TrackingDocumentListOnProgressModel>[].obs;
  RxList<TrackingDocumentListOnProgressModel> listDataApproval =
      <TrackingDocumentListOnProgressModel>[].obs;
  RxList<TrackingDocumentListOnProgressModel> listDataStatusOnTime =
      <TrackingDocumentListOnProgressModel>[].obs;
  RxList<TrackingDocumentListOnProgressModel> listDataStatusUrgent =
      <TrackingDocumentListOnProgressModel>[].obs;
  RxList<TrackingDocumentListOnProgressModel> listDataStatusOverdue =
      <TrackingDocumentListOnProgressModel>[].obs;

  Rx<TrackingDocumentOnProgress> trackingDocOnProgressData =
      const TrackingDocumentOnProgress(0, '', []).obs;
  RxBool isLoading = false.obs;
  RxString valueListener = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await _loadTrackingDocuments();
  }

  Future<void> _loadTrackingDocuments() async {
    isLoading.value = true;

    final result = await getTrackingDocumentOnProgress();
    result.fold(
      (l) {
        isLoading.value = false;
      },
      (r) {
        isLoading.value = false;
        trackingDocOnProgressData.value = r;
        listDataApproval.value = r.data;
        _filterByStatus();
        _filterData();
      },
    );
  }

  void _filterByStatus() {
    listDataStatusOnTime.value = _filterListByStatus('On Time');
    listDataStatusUrgent.value = _filterListByStatus('Urgent');
    listDataStatusOverdue.value = _filterListByStatus('Overdue');
  }

  List<TrackingDocumentListOnProgressModel> _filterListByStatus(String status) {
    return listDataApproval
        .where((doc) => doc.stateTargetCompletionDate == status)
        .toList();
  }

  void onSearchChanged(String value) {
    valueListener.value = value;
    _filterData();
  }

  void _filterData() {
    filterData.value = listDataApproval.where((doc) {
      final query = valueListener.value.toLowerCase();
      return doc.title.toLowerCase().contains(query) ||
          doc.departmentName.toLowerCase().contains(query) ||
          doc.serialNumber.toLowerCase().contains(query) ||
          doc.companyName.toLowerCase().contains(query) ||
          doc.createdAt.toLowerCase().contains(query) ||
          doc.stateTargetCompletionDate.toLowerCase().contains(query) ||
          doc.lastApprovalBy.toLowerCase().contains(query);
    }).toList();
  }

  void clearSearch() {
    searchDoc.clear();
    valueListener.value = '';
    filterData.value = listDataApproval;
  }
}
