import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/webtel/data/models/webtel_model.dart';
import 'package:iroyal/app/modules/webtel/domain/entities/webtel.dart';
import 'package:iroyal/app/modules/webtel/domain/usecases/get_webtel.dart';
import 'package:iroyal/base/utils/app_utils.dart';

class WebtelController extends GetxController {
  WebtelController({required this.getWebtel});

  final GetWebtel getWebtel;
  late ScrollController scrollController;

  RxBool isLoading = false.obs;

  String webtelState = '';

  List<Webtel> listData = <Webtel>[
    const Webtel(
        ext: 162,
        fullname: 'Dhian Artanto Nugroho',
        departmentName: 'Marketing Design',
        branchName: 'ACA',
        id: ''),
    const Webtel(
        ext: 146,
        fullname: 'Yosua Putera Elia Supardi Bunawan',
        departmentName: 'Scan In LowEnd dan HighEnd',
        branchName: 'LDAP',
        id: ''),
    const Webtel(
        ext: 001,
        fullname: 'Alghany Kennedy Adam',
        departmentName: 'IT',
        branchName: 'Vendor',
        id: ''),
    const Webtel(
        ext: 001,
        fullname: 'Alghany Kennedy Adam',
        departmentName: 'IT',
        branchName: 'Vendor',
        id: ''),
    const Webtel(
        ext: 001,
        fullname: 'Alghany Kennedy Adam',
        departmentName: 'IT',
        branchName: 'Vendor',
        id: ''),
  ];

  RxList<Webtel> webtelData = <WebtelModel>[].obs;
  RxList<Webtel> rasData = <Webtel>[].obs;
  RxList<Webtel> bmData = <Webtel>[].obs;
  RxList<Webtel> acaData = <Webtel>[].obs;

  @override
  void onInit() {
    _getDataWebtel();
    scrollController = ScrollController();
    scrollController.addListener(() {
      update();
    });
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
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
        rasData(_generateBranchRAS(r));
        bmData(_generateBranchBM(r));
        acaData(_generateBranchACA(r));
        AppUtils.logApp('RAS :::::${rasData.length}');
      },
    );
  }

  List<Webtel> _generateBranchRAS(List<Webtel> getBranch) {
    final branchRAS = <Webtel>[];

    getBranch.where((x) => x.branchName == 'PT RAS').forEach((x) {
      branchRAS.add(
        Webtel(
          fullname: x.fullname,
          departmentName: x.departmentName,
          ext: x.ext,
          branchName: x.branchName,
          id: x.id,
        ),
      );
    });
    AppUtils.logApp('PT RAS :::::$branchRAS');

    return branchRAS;
  }

  List<Webtel> _generateBranchBM(List<Webtel> getBranch) {
    final branchBM = <Webtel>[];

    getBranch.where((x) => x.branchName == 'PT BM').forEach((x) {
      branchBM.add(
        Webtel(
          fullname: x.fullname,
          departmentName: x.departmentName,
          ext: x.ext,
          branchName: x.branchName,
          id: x.id,
        ),
      );
    });
    AppUtils.logApp('PT BM :::::$branchBM');

    return branchBM;
  }

  List<Webtel> _generateBranchACA(List<Webtel> getBranch) {
    final branchACA = <Webtel>[];

    getBranch.where((x) => x.branchName == 'PT ACA').forEach((x) {
      branchACA.add(
        Webtel(
          fullname: x.fullname,
          departmentName: x.departmentName,
          ext: x.ext,
          branchName: x.branchName,
          id: x.id,
        ),
      );
    });
    AppUtils.logApp('PT ACA :::::$branchACA');

    return branchACA;
  }
}
