import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/webtel/data/models/webtel_data_model.dart';
import 'package:iroyal/app/modules/webtel/domain/entities/branch.dart';
import 'package:iroyal/app/modules/webtel/domain/entities/webtel.dart';
import 'package:iroyal/app/modules/webtel/domain/usecases/get_webtel.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/utils/app_utils.dart';

class WebtelController extends GetxController {
  WebtelController({required this.getWebtel});

  TextEditingController searchR = TextEditingController();
  TextEditingController searchB = TextEditingController();
  TextEditingController searchA = TextEditingController();
  TextEditingController searchC = TextEditingController();
  TextEditingController searchBC = TextEditingController();

  final GetWebtel getWebtel;

  String webtelState = '';

  RxBool isLoading = false.obs;
  RxString valueListener = ''.obs;

  List<Branch> branchData = [
    Branch(
      branchName: 'PT Royal Abadi Sejahtera',
      code: 'RAS',
      color: white,
      logo: 'assets/images/img_logo.png',
    ),
    Branch(
      branchName: 'PT BM',
      code: 'BM',
      color: white,
      logo: 'assets/images/img_logo_bm.JPG',
    ),
    Branch(
      branchName: 'PT ACA',
      code: 'ACA',
      color: white,
      logo: 'assets/images/img_logo_aca.png',
    ),
    Branch(
      branchName: 'PT CAM',
      code: 'CAM',
      color: white,
      logo: 'assets/images/img_logo_cam.png',
    ),
    Branch(
      branchName: 'PT BCP',
      code: 'BCP',
      color: white,
      logo: 'assets/images/img_logo_bcp.png',
    ),
  ];

  Rx<Webtel> webtelData = const Webtel(code: 0, message: '', data: {}).obs;
  RxList<WebtelDataModel> rasData = <WebtelDataModel>[].obs;
  RxList<WebtelDataModel> bmData = <WebtelDataModel>[].obs;
  RxList<WebtelDataModel> acaData = <WebtelDataModel>[].obs;
  RxList<WebtelDataModel> camData = <WebtelDataModel>[].obs;
  RxList<WebtelDataModel> bcpData = <WebtelDataModel>[].obs;

  RxList<WebtelDataModel> filterRasData = <WebtelDataModel>[].obs;
  RxList<WebtelDataModel> filterBmData = <WebtelDataModel>[].obs;
  RxList<WebtelDataModel> filterAcaData = <WebtelDataModel>[].obs;
  RxList<WebtelDataModel> filterCamData = <WebtelDataModel>[].obs;
  RxList<WebtelDataModel> filterBcpData = <WebtelDataModel>[].obs;

  @override
  void onInit() {
    _getDataWebtel();
    super.onInit();
  }

  void clear() {
    searchR.clear();
    searchB.clear();
    searchA.clear();
    searchC.clear();
    searchBC.clear();
    filterRasData(rasData);
    filterBmData(bmData);
    filterAcaData(acaData);
    filterCamData(camData);
    filterBcpData(bcpData);
    valueListener.value = '';
  }

  Future<void> _getDataWebtel() async {
    isLoading(true);

    final r = await getWebtel();
    isLoading(false);
    r.fold(
      (l) => AppUtils.logApp(l.toString()),
      (r) {
        webtelState = 'getPromSuccess';
        webtelData(r);
        rasData(r.data['PT RAS']);
        bmData(r.data['PT BM']);
        acaData(r.data['PT ACA']);
        camData(r.data['PT CAM']);
        bcpData(r.data['PT BCP']);
        filterRasData(rasData);
        filterBmData(bmData);
        filterAcaData(acaData);
        filterCamData(camData);
        filterBcpData(bcpData);
      },
    );
  }

  void onChangedR(String value) {
    valueListener.value = value;
    _filterData(value, rasData, filterRasData);
  }

  void onChangedB(String value) {
    valueListener.value = value;
    _filterData(value, bmData, filterBmData);
  }

  void onChangedA(String value) {
    valueListener.value = value;
    _filterData(value, acaData, filterAcaData);
  }

  void onChangedC(String value) {
    valueListener.value = value;
    _filterData(value, camData, filterCamData);
  }

  void onChangedBC(String value) {
    valueListener.value = value;
    _filterData(value, bcpData, filterBcpData);
  }

  void _filterData(String value, RxList<WebtelDataModel> data,
      RxList<WebtelDataModel> filterData) {
    if (value.isEmpty) {
      filterData.value = data;
      AppUtils.logApp('${filterData.length}');
    } else {
      filterData.value = data
          .where((e) =>
              e.fullName.toLowerCase().contains(value.toLowerCase()) ||
              e.extentionNumber
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              e.departmentName
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              e.workEmail
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase()))
          .toList();
      AppUtils.logApp('${filterData.length}');
    }
  }
}
