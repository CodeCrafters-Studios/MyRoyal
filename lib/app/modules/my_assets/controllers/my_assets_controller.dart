import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';
import 'package:signature/signature.dart';

class MyAssetsController extends GetxController {
  SignatureController signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: black,
    exportBackgroundColor: white,
  );

  List<String> status = [
    "Semua status",
    "Belum dikonfirmasi",
    "Sudah dikonfirmasi",
    "Dilaporkan",
  ];

  List<String> reportType = [
    "Aset tidak ada / tidak diterima",
    "Spesifikasi tidak sesuai",
    "Aset rusak / tidak berfungsi",
    "Aset berbeda dengan yang tercatat",
  ];

  List<Map<String, dynamic>> dummyDataAssets = [
    {
      'title': 'MacBook Pro 13"',
      'category': 'Laptop',
      'serial': 'MBP2023-001-ABC0',
      'status': 'Belum dikonfirmasi',
    },
    {
      'title': 'iPhone 15 Pro',
      'category': 'Handphone',
      'serial': 'IPH2023-025-XYZ',
      'status': 'Sudah dikonfirmasi',
    },
    {
      'title': 'Dell Monitor 24"',
      'category': 'Monitor',
      'serial': 'DLL2023-099-MON',
      'status': 'Dilaporkan',
    }
  ];

  RxString selectedStatusValue = 'Semua status'.obs;
  RxString selectedReportTypeValue = 'Aset tidak ada / tidak diterima'.obs;
  RxList<Map<String, dynamic>> filterdataAssets = <Map<String, dynamic>>[].obs;
  RxBool isSignatureEmpty = true.obs;
  Rx<File?> selectedImage = Rx<File?>(null);
  Uint8List? signature;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    filterdataAssets.addAll(dummyDataAssets);
    signatureController.addListener(() {
      isSignatureEmpty.value = signatureController.isEmpty;
    });
    super.onInit();
  }

  @override
  void dispose() {
    signatureController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    filterdataAssets.addAll(dummyDataAssets);
  }

  void filterDataAssets(String status) {
    selectedStatusValue.value = status;
    filterdataAssets.clear();

    if (status != 'Semua status') {
      filterdataAssets
          .addAll(dummyDataAssets.where((e) => e['status'] == status).toList());
    } else {
      filterdataAssets.addAll(dummyDataAssets);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  void cancelReport() {
    selectedImage = Rx<File?>(null);
    Get.back(result: true);
  }

  void sentReport() {
    selectedImage = Rx<File?>(null);
    Get.back(result: true);
    AppDialogImpl()
        .showSuccessSnackBar(description: 'Laporan berhasil terkirim!');
  }
}
