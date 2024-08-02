import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/webtel/data/models/webtel_model.dart';
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

  final GetWebtel getWebtel;

  String webtelState = '';

  RxBool isLoading = false.obs;
  RxString valueListener = ''.obs;

  List<Branch> branchData = [
    Branch(
      branchName: 'PT Royal Abadi Sejahtera',
      code: 'RAS',
      color: primaryAccent,
      logo: 'assets/images/img_logo.png',
    ),
    Branch(
      branchName: 'PT BM',
      code: 'BM',
      color: primaryColor,
      logo: 'assets/images/img_logo_bm.png',
    ),
    Branch(
      branchName: 'PT ACA',
      code: 'ACA',
      color: Colors.pink,
      logo: 'assets/images/img_logo-aca.png.png',
    ),
    Branch(
      branchName: 'PT CAM',
      code: 'CAM',
      color: Colors.green,
      logo: 'assets/images/img_logo_cam.png',
    ),
  ];

  RxList<Webtel> webtelData = <WebtelModel>[].obs;
  RxList<Webtel> rasData = <Webtel>[].obs;
  RxList<Webtel> bmData = <Webtel>[].obs;
  RxList<Webtel> acaData = <Webtel>[].obs;
  RxList<Webtel> camData = <Webtel>[].obs;

  RxList<Webtel> filterRasData = <Webtel>[].obs;
  RxList<Webtel> filterBmData = <Webtel>[].obs;
  RxList<Webtel> filterAcaData = <Webtel>[].obs;
  RxList<Webtel> filterCamData = <Webtel>[].obs;

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
    filterRasData(rasData);
    filterBmData(bmData);
    filterAcaData(acaData);
    filterCamData(camData);
    valueListener.value = '';
  }

  Future<void> _getDataWebtel() async {
    isLoading(true);

    final r = await getWebtel();
    isLoading(false);
    r.fold(
      (l) => webtelState = 'getPromFailed',
      (r) {
        webtelState = 'getPromSuccess';
        webtelData(r);
        rasData(_generateBranch('PT RAS', r));
        bmData(_generateBranch('PT BM', r));
        acaData(_generateBranch('PT ACA', r));
        camData(_generateBranch('PT CAM', r));
        filterRasData(rasData);
        filterBmData(bmData);
        filterAcaData(acaData);
        filterCamData(camData);
        AppUtils.logApp('RAS :::::${rasData.length}');
        AppUtils.logApp('BM :::::${bmData.length}');
        AppUtils.logApp('ACA :::::${acaData.length}');
        AppUtils.logApp('CAM :::::${camData.length}');
      },
    );
  }

  List<Webtel> _generateBranch(String branchName, List<Webtel> getBranch) {
    final branchList = <Webtel>[];

    getBranch.where((x) => x.branchName == branchName).forEach((x) {
      branchList.add(
        Webtel(
          fullname: x.fullname,
          departmentName: x.departmentName,
          lineNumber: x.lineNumber,
          extentionNumber: x.extentionNumber,
          branchName: x.branchName,
          workEmail: x.workEmail,
        ),
      );
    });
    AppUtils.logApp('$branchName :::::$branchList');

    return branchList;
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

  void _filterData(
      String value, RxList<Webtel> data, RxList<Webtel> filterData) {
    if (value.isEmpty) {
      filterData.value = data;
      AppUtils.logApp('${filterData.length}');
    } else {
      filterData.value = data
          .where((e) =>
              e.fullname.toLowerCase().contains(value.toLowerCase()) ||
              e.extentionNumber
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              e.departmentName
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase()))
          .toList();
      AppUtils.logApp('${filterData.length}');
    }
  }
}
