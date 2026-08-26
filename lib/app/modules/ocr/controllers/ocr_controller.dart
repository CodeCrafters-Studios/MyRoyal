import 'dart:developer' as developer;
import 'package:MyRoyal/app/modules/ocr/data/models/scan_ocr_response_model.dart';
import 'package:MyRoyal/app/modules/ocr/domain/entities/data_master_employee_os_entity.dart';
import 'package:MyRoyal/app/modules/ocr/domain/entities/employee_os_entity.dart';
import 'package:MyRoyal/app/modules/ocr/domain/usecases/get_data_master_employee_os_usecase.dart';
import 'package:MyRoyal/app/modules/ocr/domain/usecases/get_employee_os_usecase.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../core/ocr_pipeline.dart';
import '../data/models/scan_ocr_request_model.dart';
import '../data/models/data_master_employee_os_model.dart';
import '../data/models/save_employee_os_request_model.dart';
import '../domain/usecases/scan_ocr_usecase.dart';
import '../domain/usecases/save_employee_os_usecase.dart';
import '../models/ktp_result.dart';
import '../services/ktp_validator.dart';
import '../utils/ktp_dictionaries.dart';

class OcrController extends GetxController {
  final ScanOcrUseCase? _scanOcrUseCase;
  final GetEmployeeOsUsecase _getEmployeeOsUsecase;
  final GetDataMasterEmployeeOsUsecase _getDataMasterEmployeeOsUsecase;
  final SaveEmployeeOsUsecase? _saveEmployeeOsUsecase;

  OcrController(
      this._getEmployeeOsUsecase, this._getDataMasterEmployeeOsUsecase,
      {ScanOcrUseCase? scanOcrUseCase,
      SaveEmployeeOsUsecase? saveEmployeeOsUsecase})
      : _scanOcrUseCase = scanOcrUseCase,
        _saveEmployeeOsUsecase = saveEmployeeOsUsecase;

  RxBool isLoadingOCR = false.obs;
  RxBool isDataLoaded = false.obs;
  RxBool isDataLoadedFromBackend = false.obs;
  RxBool isLoading = false.obs;
  RxBool hasMoreData = true.obs;

  RxDouble readingProgress = 0.0.obs;
  RxString valueListener = ''.obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxInt selectedEmployeeIndex = (-1).obs;
  RxString maritalStatus = ''.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController birthPlaceController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController rtController = TextEditingController();
  final TextEditingController rwController = TextEditingController();
  final TextEditingController villageController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController maritalStatusController = TextEditingController();
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController mainSkillsController = TextEditingController();
  final TextEditingController additionalFirstSkillsController =
      TextEditingController();
  final TextEditingController additionalSecondSkillsController =
      TextEditingController();
  final TextEditingController workController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController joinDateController = TextEditingController();
  final TextEditingController search = TextEditingController();

  final Rxn<int> selectedReligionId = Rxn<int>();
  final Rxn<String> selectedReligionName = Rxn<String>();
  final Rxn<String> selectedBloodType = Rxn<String>();
  final Rxn<String> selectedGender = Rxn<String>();
  final Rxn<int> selectedMainSkillId = Rxn<int>();
  final Rxn<int> selectedAdditionalSkill1Id = Rxn<int>();
  final Rxn<int> selectedAdditionalSkill2Id = Rxn<int>();
  final RxnBool isDirect = RxnBool();
  final RxnBool isManufacturing = RxnBool();
  final RxBool isSubmitting = false.obs;

  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final OcrPipeline _pipeline = OcrPipeline();

  DocumentScanner? _documentScanner;

  // Track which fields were auto-corrected or inferred with low confidence
  RxMap<String, bool> lowConfidenceFields = <String, bool>{}.obs;

  RxString croppedImagePath = ''.obs;

  final Rx<EmployeeOsEntity> employeeData =
      EmployeeOsEntity(currentPage: 1, data: [], totalPage: 1).obs;

  final Rx<DataMasterEmployeeOsEntity> dataMasterEmployeeOs =
      DataMasterEmployeeOsEntity(
          religions: [], maritalStatuses: [], skills: [], bloodTypes: {}).obs;

  List<String> get maritalStatusOptions {
    final apiStatuses = dataMasterEmployeeOs.value.maritalStatuses
        .map((status) => status.name)
        .toList();
    return apiStatuses.isNotEmpty
        ? apiStatuses
        : KtpDictionaries.maritalStatuses;
  }

  final RxList<EmployeeOsDataEntity> employeeDataList =
      <EmployeeOsDataEntity>[].obs;
  final RxList<EmployeeOsDataEntity> filteredEmployeeDataList =
      <EmployeeOsDataEntity>[].obs;

  final RxBool isDifferent = false.obs;
  final Rxn<ScanOcrResponseDataModel> scanOcrResponseData =
      Rxn<ScanOcrResponseDataModel>();

  void setMaritalStatus(String value) => maritalStatus.value = value;

  void clearMaritalStatus() => maritalStatus.value = '';

  late Worker _differentWorker;

  @override
  void onInit() async {
    super.onInit();

    await _getEmployeesOS();
    await _getDataMasterEmployeeOs();

    _differentWorker = ever<bool>(
      isDifferent,
      (value) {
        if (value) {
          _showDifferentDataPopup();
        }
      },
    );

    _documentScanner = DocumentScanner(
      options: DocumentScannerOptions(
        mode: ScannerMode.filter,
        pageLimit: 1,
        isGalleryImport: true,
      ),
    );
  }

  @override
  void onClose() {
    _differentWorker.dispose();

    nameController.dispose();
    nikController.dispose();
    birthPlaceController.dispose();
    birthDateController.dispose();
    genderController.dispose();
    addressController.dispose();
    rtController.dispose();
    rwController.dispose();
    villageController.dispose();
    districtController.dispose();
    cityController.dispose();
    provinceController.dispose();
    religionController.dispose();
    maritalStatusController.dispose();
    workController.dispose();
    nationalityController.dispose();
    phoneController.dispose();
    bloodTypeController.dispose();
    mainSkillsController.dispose();
    additionalFirstSkillsController.dispose();
    additionalSecondSkillsController.dispose();
    joinDateController.dispose();
    search.dispose();

    _pipeline.dispose();
    _documentScanner?.close();

    super.onClose();
  }

  void _showDifferentDataPopup() {
    final responseData = scanOcrResponseData.value;
    if (responseData == null) return;

    final hrData = responseData.dataInputOsModel;
    final ocrData = responseData.dataOcr.data;

    Future.delayed(const Duration(milliseconds: 300), () {
      if (isClosed || Get.isDialogOpen == true) {
        return;
      }

      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Perbedaan Data Scan OCR Terdeteksi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hasil scan KTP tidak cocok dengan data pengajuan vendor yang terdaftar di sistem.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildComparisonTable(hrData, ocrData),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
    });
  }

  Widget _buildComparisonTable(
    DataInputOsModel? hrData,
    Map<String, ScanOcrFieldOutput>? ocrData,
  ) {
    final hrNIK = hrData != null ? "${hrData.idCard}" : "";
    final ocrNIK = (ocrData?['nik'] ?? ocrData?['nik'])?.value ?? '';
    final hrName =
        hrData != null ? "${hrData.firstName} ${hrData.lastName}".trim() : '';
    final ocrName = (ocrData?['nama'] ?? ocrData?['name'])?.value ?? '';

    final hrBirthDate = hrData != null
        ? "${hrData.dateOfBirth.day.toString().padLeft(2, '0')}/${hrData.dateOfBirth.month.toString().padLeft(2, '0')}/${hrData.dateOfBirth.year}"
        : '';
    final ocrBirthDate =
        (ocrData?['tanggal_lahir'] ?? ocrData?['birthDate'])?.value ?? '';

    final hrBirthPlace = hrData?.birthplace ?? '';
    final ocrBirthPlace =
        (ocrData?['tempat_lahir'] ?? ocrData?['birthPlace'])?.value ?? '';

    final hrGender = hrData?.gender ?? '';
    final ocrGender =
        (ocrData?['jenis_kelamin'] ?? ocrData?['gender'])?.value ?? '';

    final hrMaritalStatus = hrData?.maritalStatus ?? '';
    final ocrMaritalStatus =
        (ocrData?['status_perkawinan'] ?? ocrData?['maritalStatus'])?.value ??
            '';

    final rows = [
      {'label': 'NIK *', 'hr': hrNIK, 'ocr': ocrNIK},
      {'label': 'Nama Lengkap *', 'hr': hrName, 'ocr': ocrName},
      {'label': 'Tanggal Lahir', 'hr': hrBirthDate, 'ocr': ocrBirthDate},
      {'label': 'Tempat Lahir', 'hr': hrBirthPlace, 'ocr': ocrBirthPlace},
      {'label': 'Jenis Kelamin', 'hr': hrGender, 'ocr': ocrGender},
      {
        'label': 'Status Perkawinan',
        'hr': hrMaritalStatus,
        'ocr': ocrMaritalStatus
      },
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF00AFA6), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFEFEFEF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              children: const [
                Expanded(
                  flex: 3,
                  child: Text(
                    'BIDANG DATA',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  flex: 4,
                  child: Text(
                    'DATA SISTEM (HR)',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  flex: 4,
                  child: Text(
                    'HASIL SCAN KTP (OCR)',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Data Rows
          ...rows.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final hrVal = item['hr']!;
            final ocrVal = item['ocr']!;
            final isDiff = _isDifferentValue(hrVal, ocrVal);

            return Container(
              color: idx % 2 == 1 ? const Color(0xFFF8F9FA) : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      item['label']!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    flex: 4,
                    child: Text(
                      hrVal.isEmpty ? '-' : hrVal,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            isDiff ? FontWeight.bold : FontWeight.normal,
                        decoration: isDiff
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    flex: 4,
                    child: Text(
                      ocrVal.isEmpty ? '-' : ocrVal,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            isDiff ? FontWeight.bold : FontWeight.normal,
                        decoration: isDiff
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          // Action Row with Pilih Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
            child: Row(
              children: [
                const Expanded(flex: 3, child: SizedBox()),
                const SizedBox(width: 4),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: ElevatedButton(
                      onPressed:
                          hrData == null ? null : () => useHrData(hrData),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Pilih',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: ElevatedButton(
                      onPressed:
                          ocrData == null ? null : () => useOcrData(ocrData),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Pilih',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isDifferentValue(String val1, String val2) {
    final clean1 = val1.trim().toLowerCase();
    final clean2 = val2.trim().toLowerCase();
    if (clean1.isEmpty && clean2.isEmpty) return false;
    return clean1 != clean2;
  }

  void useHrData(DataInputOsModel hrData) {
    nameController.text = "${hrData.firstName} ${hrData.lastName}".trim();
    nikController.text = hrData.idCard;
    birthPlaceController.text = hrData.birthplace;
    birthDateController.text =
        "${hrData.dateOfBirth.day.toString().padLeft(2, '0')}/${hrData.dateOfBirth.month.toString().padLeft(2, '0')}/${hrData.dateOfBirth.year}";
    setGenderFromValue(hrData.gender);
    maritalStatusController.text = hrData.maritalStatus;
    maritalStatus.value = hrData.maritalStatus;
    setReligionFromValue(hrData.religionId);
    setBloodTypeFromValue(hrData.bloodType);
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  void useOcrData(Map<String, ScanOcrFieldOutput> ocrData) {
    _applyOcrData(ocrData);

    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  String normalizeValue(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');

  void setReligionFromValue(String value) {
    if (value.trim().isEmpty) return;
    final normalized = normalizeValue(value);
    final religion = dataMasterEmployeeOs.value.religions.firstWhereOrNull(
      (item) =>
          normalizeValue(item.name) == normalized ||
          item.id.toString() == value.trim(),
    );
    if (religion != null) {
      selectedReligionId.value = religion.id;
      selectedReligionName.value = religion.name;
      religionController.text = religion.name;
    }
  }

  void setBloodTypeFromValue(String value) {
    if (value.trim().isEmpty) return;
    final normalized = normalizeValue(value);
    final entry = dataMasterEmployeeOs.value.bloodTypes.entries
        .firstWhereOrNull((item) =>
            normalizeValue(item.key) == normalized ||
            normalizeValue(item.value) == normalized);
    if (entry != null) {
      selectedBloodType.value = entry.key;
      bloodTypeController.text = entry.value;
    }
  }

  void setGenderFromValue(String value) {
    final normalized = normalizeValue(value);
    if (normalized == 'lakilaki' || normalized == 'male') {
      selectedGender.value = 'Laki-laki';
      genderController.text = 'Laki-laki';
    } else if (normalized == 'perempuan' || normalized == 'female') {
      selectedGender.value = 'Perempuan';
      genderController.text = 'Perempuan';
    }
  }

  List<DatumModel> getAvailableSkills({int? excludeSelectedSkillId}) {
    final selected = {
      selectedMainSkillId.value,
      selectedAdditionalSkill1Id.value,
      selectedAdditionalSkill2Id.value,
    }..remove(null);
    if (excludeSelectedSkillId != null) selected.remove(excludeSelectedSkillId);
    return dataMasterEmployeeOs.value.skills
        .where((skill) => !selected.contains(skill.id))
        .toList();
  }

  void selectMainSkill(int? id) {
    selectedMainSkillId.value = id;
    mainSkillsController.text = _skillName(id);
    _clearConflictingSkills();
  }

  void selectAdditionalSkill1(int? id) {
    selectedAdditionalSkill1Id.value = id;
    additionalFirstSkillsController.text = _skillName(id);
    _clearConflictingSkills();
  }

  void selectAdditionalSkill2(int? id) {
    selectedAdditionalSkill2Id.value = id;
    additionalSecondSkillsController.text = _skillName(id);
    _clearConflictingSkills();
  }

  String _skillName(int? id) => id == null
      ? ''
      : dataMasterEmployeeOs.value.skills
              .firstWhereOrNull((skill) => skill.id == id)
              ?.name ??
          '';

  void _clearConflictingSkills() {
    final selected = <int>{};
    void clearIfDuplicate(Rxn<int> target, TextEditingController text) {
      final id = target.value;
      if (id != null && !selected.add(id)) {
        target.value = null;
        text.clear();
      }
    }

    clearIfDuplicate(selectedMainSkillId, mainSkillsController);
    clearIfDuplicate(
        selectedAdditionalSkill1Id, additionalFirstSkillsController);
    clearIfDuplicate(
        selectedAdditionalSkill2Id, additionalSecondSkillsController);
  }

  Future<void> pickJoinDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.tryParse(joinDateController.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      joinDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> pickBirthDate() async {
    final current = _parseDate(birthDateController.text) ?? DateTime.now();
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: current,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      birthDateController.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  DateTime? _parseDate(String value) {
    for (final format in ['dd-MM-yyyy', 'dd/MM/yyyy', 'yyyy-MM-dd']) {
      try {
        return DateFormat(format).parseStrict(value.trim());
      } catch (_) {}
    }
    return null;
  }

  void onChanged(String value) {
    valueListener.value = value;
    final query = value.trim().toLowerCase();
    if (query.isEmpty) {
      filteredEmployeeDataList.assignAll(employeeDataList);
      return;
    }

    filteredEmployeeDataList.assignAll(employeeDataList.where((employee) {
      return employee.fullName.toLowerCase().contains(query) ||
          employee.noRegistration.toLowerCase().contains(query) ||
          employee.idCard.toLowerCase().contains(query) ||
          employee.status.toLowerCase().contains(query);
    }));
  }

  void clear() {
    search.clear();
    valueListener.value = '';
    filteredEmployeeDataList.assignAll(employeeDataList);
  }

  Future<void> _getEmployeesOS() async {
    isLoading.value = true;

    final result = await _getEmployeeOsUsecase(currentPage.value);

    result.fold(
      (l) {
        isLoading.value = false;
      },
      (r) {
        isLoading.value = false;
        employeeData.value = r;
        employeeDataList.addAll(employeeData.value.data
            .map(
              (e) => EmployeeOsDataEntity(
                id: e.id,
                noRegistration: e.noRegistration,
                idCard: e.idCard,
                fullName: e.fullName,
                status: e.status,
              ),
            )
            .toList());
        filteredEmployeeDataList.assignAll(employeeDataList);

        totalPages.value = employeeData().totalPage;

        if (currentPage.value >= totalPages.value) {
          hasMoreData.value = false;
        }
      },
    );
  }

  Future<void> _getDataMasterEmployeeOs() async {
    isLoading.value = true;

    final result = await _getDataMasterEmployeeOsUsecase();

    result.fold(
      (l) {
        isLoading.value = false;
      },
      (r) {
        isLoading.value = false;
        dataMasterEmployeeOs.value = r;
      },
    );
  }

  Future<void> scanDocument() async {
    try {
      if (_documentScanner == null) return;
      final DocumentScanningResult? result =
          await _documentScanner!.scanDocument();
      if (result != null &&
          result.images != null &&
          result.images!.isNotEmpty) {
        String scannedPath = result.images!.first;
        croppedImagePath.value = scannedPath;
        await processImage(scannedPath);
      }
    } catch (e) {
      developer.log("Error scanning document: $e");
      Get.snackbar('Error', 'Gagal membuka scanner');
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      // Omit imageQuality: 80 to preserve highest practical source resolution per PDF Section 14
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        croppedImagePath.value = image.path;
        await processImage(image.path);
      }
    } catch (e) {
      developer.log("Error picking image: $e");
      Get.snackbar('Error', 'Gagal memuat gambar');
    }
  }

  Future<void> processImage(String imagePath) async {
    isLoadingOCR.value = true;
    isDataLoaded.value = false;
    readingProgress.value = 0.1;

    try {
      final KtpResult result = await _pipeline.process(imagePath);

      developer.log(result.toString());

      readingProgress.value = 0.5;

      // Fill controllers without overwriting if user already manually edited
      nikController.text = result.nik.value;
      nameController.text = result.name.value;
      birthPlaceController.text = result.birthPlace.value;
      birthDateController.text = result.birthDate.value;
      setGenderFromValue(result.gender.value);
      addressController.text = result.address.value;
      rtController.text = result.rt.value;
      rwController.text = result.rw.value;
      villageController.text = result.village.value;
      districtController.text = result.district.value;
      cityController.text = result.city.value;
      provinceController.text = result.province.value;
      religionController.text = result.religion.value;
      maritalStatusController.text = result.maritalStatus.value;
      maritalStatus.value = result.maritalStatus.value;
      workController.text = result.work.value;
      nationalityController.text = result.nationality.value;

      // Evaluate structural validation & confidence to populate lowConfidenceFields
      lowConfidenceFields.clear();
      final validation = KtpValidator.validate(result);

      result.toMap().forEach((key, field) {
        final bool isInvalid = validation.invalidFields.contains(key);
        final bool isLowConf =
            !field.isHighConfidence || field.isEmpty || isInvalid;

        if (isLowConf) {
          lowConfidenceFields[key] = true;
        }
      });

      await Future.delayed(Duration(milliseconds: 400));

      readingProgress.value = 0.8;
      isDataLoaded.value = true;

      // When processImage method call and isDataLoaded value true:
      // Hit endpoint and call ocr scanocr usecases to send all data to backend
      if (isDataLoaded.value) {
        await _sendOcrDataToBackend(imagePath, result);
      }
    } catch (e) {
      developer.log("Error processing image: $e");
      Get.snackbar('Error', 'Gagal memproses gambar KTP');
    }
  }

  Future<void> _sendOcrDataToBackend(
    String imagePath,
    KtpResult result,
  ) async {
    try {
      final scanOcrUseCase = _scanOcrUseCase ??
          (Get.isRegistered<ScanOcrUseCase>()
              ? Get.find<ScanOcrUseCase>()
              : null);

      if (scanOcrUseCase == null) {
        developer.log('ScanOcrUseCase is not registered');
        isLoadingOCR.value = false;
        return;
      }

      final bool isGenderValid =
          KtpValidator.validateGender(genderController.text);

      final request = ScanOcrRequestModel(
        data: {
          'nik': ScanOcrFieldInput(
            value: nikController.text,
            confidence: result.nik.confidence,
          ),
          'nama': ScanOcrFieldInput(
            value: nameController.text,
            confidence: result.name.confidence,
          ),
          'birthPlace': ScanOcrFieldInput(
            value: birthPlaceController.text,
            confidence: result.birthPlace.confidence,
          ),
          'birthDate': ScanOcrFieldInput(
            value: birthDateController.text,
            confidence: result.birthDate.confidence,
          ),
          if (isGenderValid)
            'gender': ScanOcrFieldInput(
              value: genderController.text,
              confidence: result.gender.confidence,
            ),
        },
        imagePath: imagePath,

        // IMPORTANT:
        // selectedEmployeeIndex biasanya adalah index list,
        // bukan employee ID.
        id: employeeDataList[selectedEmployeeIndex.value].id,
      );

      final res = await scanOcrUseCase.call(request);

      res.fold(
        (failure) {
          developer.log(
            'Error from scanocr backend: '
            '${failure.properties.isNotEmpty ? failure.properties.first : failure}',
          );

          readingProgress.value = 1.0;

          isDataLoadedFromBackend.value = false;
          isLoadingOCR.value = false;
        },
        (response) async {
          developer.log(
            'OCR Backend Response: ${response.toJson()}',
          );

          readingProgress.value = 1.0;

          if (response.data == null || response.data!.dataOcr.success != true) {
            developer.log(
              'OCR backend returned failed response: '
              '${response.message}',
            );

            isDataLoadedFromBackend.value = false;
            isLoadingOCR.value = false;
            return;
          }

          final responseData = response.data!;
          scanOcrResponseData.value = responseData;
          final ocrData = responseData.dataOcr.data;

          if (ocrData == null) {
            developer.log('OCR data field map is null');
            isDataLoadedFromBackend.value = false;
            isLoadingOCR.value = false;
            return;
          }

          isDifferent.value = false;

          // =========================================================
          // UPDATE OCR RESULT
          // =========================================================

          _updateField(
            output: ocrData['nik'],
            controller: nikController,
            field: result.nik,
          );

          _updateField(
            output: ocrData['nama'],
            controller: nameController,
            field: result.name,
          );

          _updateField(
            output: ocrData['tempat_lahir'] ?? ocrData['birthPlace'],
            controller: birthPlaceController,
            field: result.birthPlace,
          );

          _updateField(
            output: ocrData['tanggal_lahir'] ?? ocrData['birthDate'],
            controller: birthDateController,
            field: result.birthDate,
          );

          _updateField(
            output: ocrData['jenis_kelamin'] ?? ocrData['gender'],
            controller: genderController,
            field: result.gender,
          );
          setGenderFromValue(genderController.text);

          _applyOcrData(ocrData);

          // =========================================================
          // LOG QUALITY
          // =========================================================

          final quality = responseData.dataOcr.quality;

          if (quality != null) {
            developer.log(
              'OCR Quality - '
              'Score: ${quality.score}, '
              'Sharpness: ${quality.sharpness}, '
              'Brightness: ${quality.brightness}',
            );
          }

          // =========================================================
          // REFRESH LOW CONFIDENCE
          // =========================================================

          // _refreshLowConfidenceFields(result);
          readingProgress.value = 1.0;
          await Future.delayed(const Duration(milliseconds: 800));

          isDataLoadedFromBackend.value = true;
          isLoadingOCR.value = false;

          // =========================================================
          // DIFFERENT
          // =========================================================

          if (responseData.different) {
            isDifferent.value = true;
            developer.log(
              'OCR data is different from existing OS data',
            );
          }
        },
      );
    } catch (e, stackTrace) {
      readingProgress.value = 1.0;
      isDataLoadedFromBackend.value = false;
      isLoadingOCR.value = false;

      developer.log(
        'Exception when calling scanocr backend: $e',
        stackTrace: stackTrace,
      );
    }
  }

  void _updateField({
    required ScanOcrFieldOutput? output,
    required TextEditingController controller,
    required dynamic field,
  }) {
    final value = output?.value;

    if (output == null || value == null || value.trim().isEmpty) {
      return;
    }

    controller.text = value;
    field.value = value;
    field.confidence = output.confidence;
    field.source = output.source;
  }

  void _setFieldIfNotEmpty(
      ScanOcrFieldOutput? output, TextEditingController controller) {
    final value = output?.value.trim();
    if (value != null && value.isNotEmpty) controller.text = value;
  }

  void _applyOcrData(Map<String, ScanOcrFieldOutput> ocrData) {
    _setFieldIfNotEmpty(ocrData['nik'], nikController);
    _setFieldIfNotEmpty(ocrData['nama'] ?? ocrData['name'], nameController);
    _setFieldIfNotEmpty(
        ocrData['tempat_lahir'] ?? ocrData['birthPlace'], birthPlaceController);
    _setFieldIfNotEmpty(
        ocrData['tanggal_lahir'] ?? ocrData['birthDate'], birthDateController);
    _setFieldIfNotEmpty(
        ocrData['jenis_kelamin'] ?? ocrData['gender'], genderController);
    final gender = ocrData['jenis_kelamin']?.value ?? ocrData['gender']?.value;
    if (gender != null && gender.trim().isNotEmpty) setGenderFromValue(gender);
    _setFieldIfNotEmpty(ocrData['alamat'], addressController);

    final rtRw = ocrData['rt_rw']?.value.trim();
    if (rtRw != null && rtRw.isNotEmpty) {
      final parts = rtRw.split('/');
      _setFieldIfNotEmpty(
          ScanOcrFieldOutput(value: parts.first, confidence: 0, source: ''),
          rtController);
      if (parts.length > 1) {
        _setFieldIfNotEmpty(
            ScanOcrFieldOutput(value: parts[1], confidence: 0, source: ''),
            rwController);
      }
    }
    _setFieldIfNotEmpty(ocrData['kelurahan_desa'], villageController);
    _setFieldIfNotEmpty(ocrData['kecamatan'], districtController);
    _setFieldIfNotEmpty(ocrData['kota_kabupaten'], cityController);
    _setFieldIfNotEmpty(ocrData['provinsi'], provinceController);
    _setFieldIfNotEmpty(ocrData['agama'], religionController);
    final religion = ocrData['agama']?.value.trim();
    if (religion != null && religion.isNotEmpty) setReligionFromValue(religion);
    final bloodType = ocrData['golongan_darah']?.value.trim();
    if (bloodType != null && bloodType.isNotEmpty) {
      setBloodTypeFromValue(bloodType);
    }

    final marital = (ocrData['status_perkawinan'] ?? ocrData['maritalStatus'])
        ?.value
        .trim();
    if (marital != null && marital.isNotEmpty) {
      maritalStatusController.text = marital;
      maritalStatus.value = marital;
    }
    _setFieldIfNotEmpty(ocrData['pekerjaan'], workController);
    _setFieldIfNotEmpty(ocrData['kewarganegaraan'], nationalityController);
  }

  void retake() async {
    isDataLoaded.value = false;
    isDataLoadedFromBackend.value = false;
    isDifferent.value = false;
    scanOcrResponseData.value = null;
    croppedImagePath.value = '';
    selectedReligionId.value = null;
    selectedReligionName.value = null;
    selectedBloodType.value = null;
    selectedGender.value = null;
    selectedMainSkillId.value = null;
    selectedAdditionalSkill1Id.value = null;
    selectedAdditionalSkill2Id.value = null;
    isDirect.value = null;
    isManufacturing.value = null;
    joinDateController.clear();
    religionController.clear();
    bloodTypeController.clear();
    mainSkillsController.clear();
    additionalFirstSkillsController.clear();
    additionalSecondSkillsController.clear();
    lowConfidenceFields.clear();
  }

  void reset() async {
    isDataLoaded.value = false;
    isDataLoadedFromBackend.value = false;
    isDifferent.value = false;
    scanOcrResponseData.value = null;
    croppedImagePath.value = '';
    selectedReligionId.value = null;
    selectedReligionName.value = null;
    selectedBloodType.value = null;
    selectedGender.value = null;
    selectedMainSkillId.value = null;
    selectedAdditionalSkill1Id.value = null;
    selectedAdditionalSkill2Id.value = null;
    isDirect.value = null;
    isManufacturing.value = null;
    joinDateController.clear();
    religionController.clear();
    bloodTypeController.clear();
    mainSkillsController.clear();
    additionalFirstSkillsController.clear();
    additionalSecondSkillsController.clear();
    lowConfidenceFields.clear();
    search.clear();
    valueListener.value = '';
    selectedEmployeeIndex.value = -1;
    currentPage.value = 1;
    hasMoreData.value = true;
    employeeDataList.clear();
    filteredEmployeeDataList.clear();
    await _getEmployeesOS();
  }

  Future<void> submitData() async {
    if (isSubmitting.value) return;
    if (!(formKey.currentState?.validate() ?? false)) return;
    final missing = <String>[];
    if (selectedReligionId.value == null) missing.add('Agama');
    if (selectedBloodType.value == null) missing.add('Golongan Darah');
    if (selectedMainSkillId.value == null) missing.add('Keahlian Utama');
    if (joinDateController.text.trim().isEmpty)
      missing.add('Tanggal Bergabung');
    if (isDirect.value == null) missing.add('Direct');
    if (isManufacturing.value == null) missing.add('Bagian');
    if (selectedEmployeeIndex.value < 0 ||
        selectedEmployeeIndex.value >= employeeDataList.length) {
      missing.add('Employee');
    }
    _clearConflictingSkills();
    if (missing.isNotEmpty) {
      Get.snackbar('Validasi', 'Mohon lengkapi: ${missing.join(', ')}');
      return;
    }

    final usecase = _saveEmployeeOsUsecase ??
        (Get.isRegistered<SaveEmployeeOsUsecase>()
            ? Get.find<SaveEmployeeOsUsecase>()
            : null);
    if (usecase == null) {
      Get.snackbar('Error', 'Use case simpan belum tersedia');
      return;
    }

    final employee = employeeDataList[selectedEmployeeIndex.value];
    final additionalSkills = <int>[
      if (selectedAdditionalSkill1Id.value != null)
        selectedAdditionalSkill1Id.value!,
      if (selectedAdditionalSkill2Id.value != null)
        selectedAdditionalSkill2Id.value!,
    ];
    isSubmitting.value = true;
    try {
      final result = await usecase(SaveEmployeeOsRequestModel(
        id: employee.id,
        idCard: nikController.text.trim(),
        fullName: nameController.text.trim(),
        religionId: selectedReligionId.value!,
        bloodType: selectedBloodType.value!,
        mainSkill: selectedMainSkillId.value!,
        additionalSkill: additionalSkills,
        joinDate: joinDateController.text.trim(),
        isManufacturing: isManufacturing.value!,
        isDirect: isDirect.value!,
      ));
      result.fold(
        (failure) {
          AppDialogImpl().showErrorSnackBar(
              description: failure.properties.isNotEmpty
                  ? failure.properties.first.toString()
                  : 'Gagal menyimpan data');
        },
        (_) {
          AppDialogImpl()
              .showSuccessSnackBar(description: 'Data berhasil disimpan');
          reset();
        },
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
