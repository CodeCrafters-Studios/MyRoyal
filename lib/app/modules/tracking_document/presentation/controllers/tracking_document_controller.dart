import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/tracking_document/data/models/tracking_document_list_history_model.dart';
import 'package:MyRoyal/app/modules/tracking_document/data/models/tracking_document_list_on_progress_model.dart';
import 'package:MyRoyal/app/modules/tracking_document/domain/entities/tracking_document_history.dart';
import 'package:MyRoyal/app/modules/tracking_document/domain/entities/tracking_document_on_progress.dart';
import 'package:MyRoyal/app/modules/tracking_document/domain/usecase/get_tracking_document_history.dart';
import 'package:MyRoyal/app/modules/tracking_document/domain/usecase/get_tracking_document_on_progress.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';

class TrackingDocumentController extends GetxController {
  TrackingDocumentController({
    required this.getTrackingDocumentOnProgress,
    required this.getTrackingDocumentHistory,
    required this.appDialog,
  });

  final GetTrackingDocumentOnProgress getTrackingDocumentOnProgress;
  final GetTrackingDocumentHistory getTrackingDocumentHistory;
  final AppDialog appDialog;

  TextEditingController searchDocOnProgress = TextEditingController();
  TextEditingController searchDocHistory = TextEditingController();

  RxList<TrackingDocumentListOnProgressModel> filterDataOnProgress =
      <TrackingDocumentListOnProgressModel>[].obs;
  RxList<TrackingDocumentListHistoryModel> filterDataHistory =
      <TrackingDocumentListHistoryModel>[].obs;
  RxList<TrackingDocumentListOnProgressModel> listDataApproval =
      <TrackingDocumentListOnProgressModel>[].obs;
  RxList<TrackingDocumentListHistoryModel> listDataHistory =
      <TrackingDocumentListHistoryModel>[].obs;
  RxList<TrackingDocumentListOnProgressModel> listDataStatusOnTime =
      <TrackingDocumentListOnProgressModel>[].obs;
  RxList<TrackingDocumentListOnProgressModel> listDataStatusUrgent =
      <TrackingDocumentListOnProgressModel>[].obs;
  RxList<TrackingDocumentListOnProgressModel> listDataStatusOverdue =
      <TrackingDocumentListOnProgressModel>[].obs;
  RxList<TrackingDocumentListHistoryModel> listDataStatusApproved =
      <TrackingDocumentListHistoryModel>[].obs;
  RxList<TrackingDocumentListHistoryModel> listDataStatusRejected =
      <TrackingDocumentListHistoryModel>[].obs;
  RxList<TrackingDocumentListHistoryModel> listDataStatusClosed =
      <TrackingDocumentListHistoryModel>[].obs;

  Rx<TrackingDocumentOnProgress> trackingDocOnProgressData =
      const TrackingDocumentOnProgress(0, '', []).obs;

  Rx<TrackingDocumentHistory> trackingDocHistoryData =
      const TrackingDocumentHistory(code: 0, message: '', data: []).obs;
  RxBool isLoading = false.obs;
  RxString valueListenerOnProgress = ''.obs;
  RxString valueListenerHistory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadTrackingDocuments();
  }

  Future<void> onRefresh() async {
    loadTrackingDocuments();
  }

  Future<void> loadTrackingDocuments() async {
    isLoading.value = true;

    final resultOnProgress = await getTrackingDocumentOnProgress();
    final resultHistory = await getTrackingDocumentHistory();

    resultOnProgress.fold(
      (l) {
        isLoading.value = false;
      },
      (r) {
        isLoading.value = false;
        trackingDocOnProgressData.value = r;
        listDataApproval.value = r.data;
        _filterByStatus();
        _filterDataOnProgress();
      },
    );

    resultHistory.fold(
      (l) {
        isLoading.value = false;
      },
      (r) {
        isLoading.value = false;
        trackingDocHistoryData.value = r;
        listDataHistory.value = r.data;
        _filterByStatus();
        _filterDataHistory();
      },
    );
  }

  void _filterByStatus() {
    listDataStatusOnTime.value = _filterListByStatusOnProgress('On Time');
    listDataStatusUrgent.value = _filterListByStatusOnProgress('Urgent');
    listDataStatusOverdue.value = _filterListByStatusOnProgress('Overdue');
    listDataStatusApproved.value = _filterListByStatusHistory('Approved');
    listDataStatusRejected.value = _filterListByStatusHistory('Rejected');
    listDataStatusClosed.value = _filterListByStatusHistory('Closed');
  }

  List<TrackingDocumentListOnProgressModel> _filterListByStatusOnProgress(
      String status) {
    return listDataApproval
        .where((doc) => doc.stateTargetCompletionDate == status)
        .toList();
  }

  List<TrackingDocumentListHistoryModel> _filterListByStatusHistory(
      String status) {
    AppUtils.logApp(
        'STATUS ${listDataHistory.where((doc) => doc.state == status).toList()}');
    return listDataHistory.where((doc) => doc.state == status).toList();
  }

  void onSearchChangedOnProgress(String value) {
    valueListenerOnProgress.value = value;
    _filterDataOnProgress();
  }

  void onSearchChangedOnHistory(String value) {
    valueListenerHistory.value = value;
    _filterDataHistory();
  }

  void _filterDataOnProgress() {
    filterDataOnProgress.value = listDataApproval.where((doc) {
      final query = valueListenerOnProgress.value.toLowerCase();
      return doc.title.toLowerCase().contains(query) ||
          doc.departmentName.toLowerCase().contains(query) ||
          doc.serialNumber.toLowerCase().contains(query) ||
          doc.companyName.toLowerCase().contains(query) ||
          doc.createdAt.toLowerCase().contains(query) ||
          doc.stateTargetCompletionDate.toLowerCase().contains(query) ||
          doc.lastApprovalBy.toLowerCase().contains(query);
    }).toList();
  }

  void _filterDataHistory() {
    filterDataHistory.value = listDataHistory.where((doc) {
      final query = valueListenerHistory.value.toLowerCase();
      return doc.title.toLowerCase().contains(query) ||
          doc.state.toLowerCase().contains(query) ||
          doc.departmentName.toLowerCase().contains(query) ||
          doc.serialNumber.toLowerCase().contains(query) ||
          doc.companyName.toLowerCase().contains(query) ||
          doc.createdAt.toLowerCase().contains(query) ||
          doc.stateTargetCompletionDate.toLowerCase().contains(query) ||
          doc.lastApprovalBy.toLowerCase().contains(query);
    }).toList();
  }

  void clearSearch() {
    searchDocOnProgress.clear();
    searchDocHistory.clear();
    valueListenerOnProgress.value = '';
    valueListenerHistory.value = '';
    filterDataOnProgress.value = listDataApproval;
    filterDataHistory.value = listDataHistory;
  }
}
