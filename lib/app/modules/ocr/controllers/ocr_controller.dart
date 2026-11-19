import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:MyRoyal/app/modules/ocr/data/models/scan_ocr_response_model.dart';
import 'package:MyRoyal/app/modules/ocr/domain/entities/data_master_employee_os_entity.dart';
import 'package:MyRoyal/app/modules/ocr/domain/entities/employee_os_entity.dart';
import 'package:MyRoyal/app/modules/ocr/domain/usecases/get_data_master_employee_os_usecase.dart';
import 'package:MyRoyal/app/modules/ocr/domain/usecases/get_employee_os_usecase.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';
import 'package:MyRoyal/base/utils/storage/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      SaveEmployeeOsUsecase? saveEmployeeOsUsecase,
      required AppStorage appStorage})
      : _scanOcrUseCase = scanOcrUseCase,
        _saveEmployeeOsUsecase = saveEmployeeOsUsecase,
        _appStorage = appStorage;

  final AppStorage _appStorage;
  int _employeeRequestId = 0;
  RxBool isLoadingOCR = false.obs;
  RxBool isDataLoaded = false.obs;
  RxBool isDataLoadedFromBackend = false.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;
  RxBool isRefreshing = false.obs;
  RxBool hasMoreData = true.obs;

  RxDouble readingProgress = 0.0.obs;
  RxString valueListener = ''.obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxInt selectedEmployeeIndex = (-1).obs;
  RxString selectedEmployeeStatus = 'waiting'.obs;
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
  KtpResult? _lastKtpResult;
  bool _needsManualFallback = false;

  // Track which fields were auto-corrected or inferred with low confidence
  RxMap<String, bool> lowConfidenceFields = <String, bool>{}.obs;
  final RxMap<String, bool> fieldEnabled = <String, bool>{}.obs;

  RxString croppedImagePath = ''.obs;
  final ScrollController employeeListScrollController = ScrollController();

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

    employeeListScrollController.addListener(_onEmployeeListScroll);
    final restored =
        await _restoreEmployeeStatusCache(selectedEmployeeStatus.value);
    await _getEmployeesOS(showLoading: !restored);
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
    employeeListScrollController
      ..removeListener(_onEmployeeListScroll)
      ..dispose();

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

    Future.delayed(const Duration(milliseconds: 300), () {
      if (isClosed ||
          Get.isDialogOpen == true ||
          !isDifferent.value ||
          scanOcrResponseData.value == null ||
          scanOcrResponseData.value != responseData) {
        return;
      }

      final currentResponse = scanOcrResponseData.value;
      if (currentResponse == null) return;

      final hrData = currentResponse.dataInputOsModel;
      final ocrData = currentResponse.dataOcr.data;

      Get.dialog(
        barrierDismissible: false,
        PopScope(
          canPop: false,
          child: Dialog(
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
        ),
      );
    });
  }

  Widget _buildComparisonTable(
    DataInputOsModel? hrData,
    Map<String, ScanOcrFieldOutput>? ocrData,
  ) {
    final hrNIK = hrData != null ? "${hrData.idCard}" : "";
    final ocrNIK = (ocrData?['nik'] ?? ocrData?['nik'])?.value ?? '';
    final hrName = hrData == null
        ? ''
        : _capitalizeName("${hrData.firstName} ${hrData.lastName}".trim());
    final ocrName = _capitalizeName(
      (ocrData?['nama'] ?? ocrData?['name'])?.value ?? '',
    );

    final hrBirthDate = hrData?.dateOfBirth == null
        ? ''
        : _formatBirthDate(hrData!.dateOfBirth!.toIso8601String());
    final ocrBirthDate = _formatBirthDate(
      (ocrData?['tanggal_lahir'] ?? ocrData?['birthDate'])?.value ?? '',
    );

    final hrBirthPlace = hrData?.birthplace ?? '';
    final ocrBirthPlace =
        (ocrData?['tempat_lahir'] ?? ocrData?['birthPlace'])?.value ?? '';

    final hrGender = _formatGender(hrData?.gender ?? '');
    final ocrGender = _formatGender(
      (ocrData?['jenis_kelamin'] ?? ocrData?['gender'])?.value ?? '',
    );

    final rows = [
      {'label': 'NIK *', 'hr': hrNIK, 'ocr': ocrNIK},
      {'label': 'Nama Lengkap *', 'hr': hrName, 'ocr': ocrName},
      {'label': 'Tanggal Lahir', 'hr': hrBirthDate, 'ocr': ocrBirthDate},
      {'label': 'Tempat Lahir', 'hr': hrBirthPlace, 'ocr': ocrBirthPlace},
      {'label': 'Jenis Kelamin', 'hr': hrGender, 'ocr': ocrGender},
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
            child: IntrinsicHeight(
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
                  SizedBox(width: 1, child: ColoredBox(color: Colors.black26)),
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
                  SizedBox(width: 1, child: ColoredBox(color: Colors.black26)),
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
              child: IntrinsicHeight(
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
                    const SizedBox(
                      width: 1,
                      child: ColoredBox(color: Colors.black12),
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
                    const SizedBox(
                      width: 1,
                      child: ColoredBox(color: Colors.black12),
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

  String _formatGender(String value) {
    switch (value.trim().toLowerCase()) {
      case '1':
      case 'laki-laki':
      case 'lakilaki':
      case 'male':
        return 'Laki-laki';
      case '0':
      case 'perempuan':
      case 'female':
        return 'Perempuan';
      default:
        return value.trim();
    }
  }

  String _formatBirthDate(String value) {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) return '';

    final isoDate = DateTime.tryParse(trimmedValue);
    if (isoDate != null) {
      return DateFormat('dd/MM/yyyy').format(isoDate);
    }

    for (final format in ['dd/MM/yyyy', 'dd-MM-yyyy', 'yyyy-MM-dd']) {
      try {
        return DateFormat('dd/MM/yyyy')
            .format(DateFormat(format).parseStrict(trimmedValue));
      } catch (_) {}
    }

    return trimmedValue;
  }

  String _capitalizeName(String value) {
    return value
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map(
      (part) {
        return part
            .split('-')
            .map((namePart) => namePart.isEmpty
                ? namePart
                : '${namePart[0].toUpperCase()}${namePart.substring(1).toLowerCase()}')
            .join('-');
      },
    ).join(' ');
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
    if (hrData.dateOfBirth != null) {
      birthDateController.text =
          "${hrData.dateOfBirth!.day.toString().padLeft(2, '0')}/${hrData.dateOfBirth!.month.toString().padLeft(2, '0')}/${hrData.dateOfBirth!.year}";
    }
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
    if (normalized == '1' || normalized == 'lakilaki' || normalized == 'male') {
      selectedGender.value = 'Laki-laki';
      genderController.text = 'Laki-laki';
    } else if (normalized == '0' ||
        normalized == 'perempuan' ||
        normalized == 'female') {
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
    _applyEmployeeSearch(value);
  }

  void _applyEmployeeSearch([String? value]) {
    final query = (value ?? search.text).trim().toLowerCase();
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

  Future<void> setEmployeeStatus(String status) async {
    if (selectedEmployeeStatus.value == status) return;

    final selectionRequestId = ++_employeeRequestId;
    selectedEmployeeStatus.value = status;
    if (employeeListScrollController.hasClients) {
      employeeListScrollController.jumpTo(0);
    }
    isLoading.value = false;
    isLoadMore.value = false;
    isRefreshing.value = false;

    // 1. Instantly display cached data if available (Stale)
    final restored = await _restoreEmployeeStatusCache(status);
    if (selectionRequestId != _employeeRequestId) return;

    // If no cache was restored, clear previous list
    if (!restored) {
      employeeDataList.clear();
      filteredEmployeeDataList.clear();
      currentPage.value = 1;
      totalPages.value = 1;
      hasMoreData.value = true;
    }

    // 2. Fetch fresh data from API (Revalidate)
    // If cache was restored, fetch silently in the background (showLoading: false)
    // If no cache was restored, show shimmer loader (showLoading: true)
    await _fetchEmployeePage(
      1,
      replace: true,
      showLoading: !restored,
    );
  }

  void clear() {
    search.clear();
    valueListener.value = '';
    filteredEmployeeDataList.assignAll(employeeDataList);
  }

  Future<void> onRefreshEmployees() async {
    await _fetchEmployeePage(1, replace: true, showLoading: false);
  }

  void _onEmployeeListScroll() {
    if (!employeeListScrollController.hasClients ||
        employeeListScrollController.position.extentAfter > 300) {
      return;
    }
    loadMoreEmployeeData();
  }

  Future<void> loadMoreEmployeeData() async {
    if (isLoading.value ||
        isLoadMore.value ||
        isRefreshing.value ||
        !hasMoreData.value) {
      return;
    }
    await _fetchEmployeePage(currentPage.value + 1, replace: false);
  }

  Future<void> _getEmployeesOS({bool showLoading = true}) async {
    await _fetchEmployeePage(1, replace: true, showLoading: showLoading);
  }

  Future<void> _fetchEmployeePage(
    int page, {
    required bool replace,
    bool showLoading = true,
  }) async {
    final requestId = ++_employeeRequestId;
    final status = selectedEmployeeStatus.value;
    if (replace && showLoading) {
      isLoading.value = true;
    } else if (replace) {
      isRefreshing.value = true;
    } else if (!replace) {
      isLoadMore.value = true;
    }

    final result = await _getEmployeeOsUsecase({
      'page': page,
      'status': status,
    });

    await result.fold<Future<void>>(
      (l) async {
        if (requestId != _employeeRequestId) return;
        isLoading.value = false;
        isLoadMore.value = false;
        isRefreshing.value = false;
        AppDialogImpl().showErrorSnackBar(
          description: l.properties.firstOrNull?.toString() ??
              'Gagal memuat data Employee OS',
        );
      },
      (r) async {
        if (requestId != _employeeRequestId) return;
        isLoading.value = false;
        isLoadMore.value = false;
        isRefreshing.value = false;
        employeeData.value = r;
        final pageData = employeeData.value.data
            .map(
              (e) => EmployeeOsDataEntity(
                id: e.id,
                noRegistration: e.noRegistration,
                idCard: e.idCard,
                fullName: e.fullName,
                status: e.status,
                userCreatedPtk: e.userCreatedPtk,
                section: e.section,
                unit: e.unit,
              ),
            )
            .toList();
        if (replace) {
          employeeDataList.assignAll(pageData);
        } else {
          employeeDataList.addAll(pageData);
        }
        _applyEmployeeSearch();

        currentPage.value = page;
        totalPages.value = employeeData().totalPage;
        hasMoreData.value = currentPage.value < totalPages.value;
        await _persistEmployeeStatusCache(status);
      },
    );
  }

  String _employeeCacheKey(String status) => 'employee_os_list_$status';

  Future<bool> _restoreEmployeeStatusCache(String status) async {
    final cached = await _appStorage.read(_employeeCacheKey(status));
    if (cached == null) return false;
    if (selectedEmployeeStatus.value != status) return false;

    try {
      final json = jsonDecode(cached) as Map<String, dynamic>;
      final rows = (json['data'] as List<dynamic>).map((item) {
        final row = item as Map<String, dynamic>;
        return EmployeeOsDataEntity(
          id: row['id'] as int,
          noRegistration: row['no_registration'] as String,
          idCard: row['id_card'] as String,
          fullName: row['full_name'] as String,
          status: row['status'] as String,
          userCreatedPtk: row['user_created_ptk'],
          section: row['section'],
          unit: row['unit'],
        );
      }).toList();

      employeeDataList.assignAll(rows);
      currentPage.value = json['current_page'] as int;
      totalPages.value = json['total_page'] as int;
      hasMoreData.value = currentPage.value < totalPages.value;
      _applyEmployeeSearch();
      isLoading.value = false;
      isLoadMore.value = false;
      isRefreshing.value = false;
      return true;
    } on FormatException catch (error, stackTrace) {
      developer.log('Invalid cached Employee OS data for $status',
          error: error, stackTrace: stackTrace);
      await _appStorage.delete(_employeeCacheKey(status));
      return false;
    } on TypeError catch (error, stackTrace) {
      developer.log('Invalid cached Employee OS data for $status',
          error: error, stackTrace: stackTrace);
      await _appStorage.delete(_employeeCacheKey(status));
      return false;
    }
  }

  Future<void> _persistEmployeeStatusCache(String status) async {
    final cache = {
      'current_page': currentPage.value,
      'total_page': totalPages.value,
      'data': employeeDataList
          .map((employee) => {
                'id': employee.id,
                'no_registration': employee.noRegistration,
                'id_card': employee.idCard,
                'full_name': employee.fullName,
                'status': employee.status,
                'user_created_ptk': employee.userCreatedPtk,
                'section': employee.section,
                'unit': employee.unit,
              })
          .toList(),
    };
    try {
      await _appStorage.write(
        _employeeCacheKey(status),
        jsonEncode(cache),
      );
    } catch (error, stackTrace) {
      developer.log('Failed to cache Employee OS data',
          error: error, stackTrace: stackTrace);
      AppDialogImpl().showErrorSnackBar(
        description: 'Gagal menyimpan cache data Employee OS',
      );
    }
  }

  Future<void> _getDataMasterEmployeeOs() async {
    final result = await _getDataMasterEmployeeOsUsecase();

    result.fold(
      (l) => AppDialogImpl().showErrorSnackBar(
        description: l.properties.firstOrNull?.toString() ??
            'Gagal memuat data master Employee OS',
      ),
      (r) {
        dataMasterEmployeeOs.value = r;
      },
    );
  }

  Future<void> scanDocument() async {
    if (_needsManualFallback) {
      await AppDialogImpl().showInfoDialog(
        title: 'KTP tidak dapat terbaca',
        description:
            'KTP hasil scan sebelumnya tidak dapat terbaca karena buram atau rusak, sehingga tidak dapat diproses. Proses selanjutnya akan menampilkan data sesuai HRMS. Pastikan untuk memeriksa kembali data tersebut.',
        textButton: 'Lanjutkan',
        onPress: () {
          Get.back();
          final result = _lastKtpResult;
          if (result == null || croppedImagePath.value.isEmpty) {
            AppDialogImpl().showErrorSnackBar(
              description: 'Data scan KTP sebelumnya tidak tersedia',
            );
            return;
          }

          isLoadingOCR.value = true;
          readingProgress.value = 0.8;
          _sendOcrDataToBackend(
            croppedImagePath.value,
            result,
            type: 'manual',
          );
        },
      );
      return;
    }

    try {
      if (_documentScanner == null) return;

      final DocumentScanningResult? result =
          await _documentScanner!.scanDocument();

      if (result == null) {
        AppDialogImpl().showErrorSnackBar(
            description: 'Pemindaian dibatalkan, dokumen dibuang.');
        return;
      }

      if (result.images != null && result.images!.isNotEmpty) {
        String scannedPath = result.images!.first;
        croppedImagePath.value = scannedPath;
        await processImage(scannedPath);
      }
    } catch (e) {
      developer.log("Error scanning document: $e");

      if (e is PlatformException && e.message?.contains('cancelled') == true) {
        AppDialogImpl().showErrorSnackBar(
            description: 'Pemindaian dibatalkan, dokumen dibuang.');
      } else {
        AppDialogImpl().showErrorSnackBar(
            description: 'Gagal memindai dokumen. Silakan coba lagi.');
      }
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
      AppDialogImpl().showErrorSnackBar(description: 'Gagal memuat gambar');
    }
  }

  Future<void> processImage(String imagePath) async {
    _needsManualFallback = false;
    _lastKtpResult = null;
    isLoadingOCR.value = true;
    isDataLoaded.value = false;
    readingProgress.value = 0.1;

    try {
      final KtpResult result = await _pipeline.process(imagePath);
      _lastKtpResult = result;

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
      if (isDataLoaded.value && croppedImagePath.value.isNotEmpty) {
        await _sendOcrDataToBackend(imagePath, result);
      }
    } catch (e) {
      isLoadingOCR.value = false;
      readingProgress.value = 0.0;
      isDataLoaded.value = false;
      isDataLoadedFromBackend.value = false;
      developer.log("Error processing image: $e");
      AppDialogImpl()
          .showErrorSnackBar(description: 'Gagal memproses gambar KTP');
    }
  }

  Future<void> scanOrRetry() async {
    if (croppedImagePath.value.isNotEmpty &&
        isDataLoaded.value &&
        _lastKtpResult != null) {
      isLoadingOCR.value = true;
      readingProgress.value = 0.8;
      await _sendOcrDataToBackend(croppedImagePath.value, _lastKtpResult!);
      return;
    }

    await scanDocument();
  }

  Future<void> _sendOcrDataToBackend(String imagePath, KtpResult result,
      {String type = 'scan'}) async {
    try {
      final scanOcrUseCase = _scanOcrUseCase ??
          (Get.isRegistered<ScanOcrUseCase>()
              ? Get.find<ScanOcrUseCase>()
              : null);

      if (scanOcrUseCase == null) {
        developer.log('ScanOcrUseCase is not registered');
        AppDialogImpl()
            .showErrorSnackBar(description: 'Layanan OCR belum tersedia');
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
        type: type,
      );

      final res = await scanOcrUseCase.call(request);

      res.fold(
        (failure) {
          final message = failure.properties.isNotEmpty
              ? failure.properties.first.toString()
              : 'Gagal mengirim data OCR';
          developer.log(
            'Error from scanocr backend: '
            '${failure.properties.isNotEmpty ? failure.properties.first : failure}',
          );
          AppDialogImpl().showErrorDialog(description: message);

          readingProgress.value = 1.0;

          isDataLoadedFromBackend.value = false;
          isLoadingOCR.value = false;
        },
        (response) async {
          developer.log(
            'OCR Backend Response: ${response.toJson()}',
          );

          readingProgress.value = 1.0;

          if (response.code == 422 &&
              _isUnreadableKtpMessage(response.message)) {
            _needsManualFallback = true;
            AppDialogImpl().showErrorDialog(
              description: response.message,
            );
            isDataLoadedFromBackend.value = false;
            isLoadingOCR.value = false;
            return;
          }

          if (response.data == null) {
            developer.log(
              'OCR backend returned failed response: '
              '${response.message}',
            );
            AppDialogImpl().showErrorSnackBar(
                description: response.message.isNotEmpty
                    ? response.message
                    : 'Gagal memproses data OCR');

            isDataLoadedFromBackend.value = false;
            isLoadingOCR.value = false;
            return;
          }

          final responseData = response.data!;
          final hrData = responseData.dataInputOsModel;
          final ocrData = responseData.dataOcr.data;
          final isHrmsFallback = ocrData == null && hrData != null;
          if (responseData.dataOcr.success != true && !isHrmsFallback) {
            developer.log('OCR extraction failed: data_ocr.success is false');
            AppDialogImpl().showErrorSnackBar(
                description: 'OCR gagal mengekstrak data dari KTP');
            isDataLoadedFromBackend.value = false;
            isLoadingOCR.value = false;
            return;
          }

          scanOcrResponseData.value = responseData;
          isDirect.value = responseData.dataOcr.isDirect ?? hrData?.isDirect;
          isManufacturing.value =
              responseData.dataOcr.isManufacturing ?? hrData?.isManufacturing;
          if (ocrData == null && !isHrmsFallback) {
            developer.log('OCR data field map is null');
            AppDialogImpl().showErrorSnackBar(
                description: 'Data OCR dari server tidak tersedia');
            scanOcrResponseData.value = null;
            isDifferent.value = false;
            isDataLoadedFromBackend.value = false;
            isLoadingOCR.value = false;
            return;
          }

          isDifferent.value = false;

          if (isHrmsFallback) {
            _applyBackendData(hrData);
          } else {
            final ocrFields = ocrData!;
            _updateField(
              output: ocrFields['nik'],
              controller: nikController,
              field: result.nik,
            );
            _updateField(
              output: ocrFields['nama'],
              controller: nameController,
              field: result.name,
            );
            _updateField(
              output: ocrFields['tempat_lahir'] ?? ocrFields['birthPlace'],
              controller: birthPlaceController,
              field: result.birthPlace,
            );
            _updateField(
              output: ocrFields['tanggal_lahir'] ?? ocrFields['birthDate'],
              controller: birthDateController,
              field: result.birthDate,
            );
            _updateField(
              output: ocrFields['jenis_kelamin'] ?? ocrFields['gender'],
              controller: genderController,
              field: result.gender,
            );
            setGenderFromValue(genderController.text);
            _applyOcrData(ocrFields);
            _applyBackendData(hrData);
          }

          _needsManualFallback = false;

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
      readingProgress.value = 0.0;
      isDataLoadedFromBackend.value = false;
      isLoadingOCR.value = false;
      isDifferent.value = false;
      scanOcrResponseData.value = null;

      developer.log(
        'Exception when calling scanocr backend: $e',
        stackTrace: stackTrace,
      );
      AppDialogImpl()
          .showErrorSnackBar(description: 'Gagal terhubung ke server OCR');
    }
    developer.log('BACKEND STATUS ${isDataLoadedFromBackend.value}');
  }

  bool _isUnreadableKtpMessage(String message) =>
      message.toLowerCase().contains('kualitas gambar ktp kurang jelas');

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

  void _applyBackendData(DataInputOsModel? data) {
    fieldEnabled.clear();
    fieldEnabled['NIK'] = true;
    fieldEnabled['Nama Lengkap'] = true;
    fieldEnabled['Tempat Lahir'] = true;
    fieldEnabled['Tanggal Lahir'] = true;
    fieldEnabled['Jenis Kelamin'] = true;
    fieldEnabled['Agama'] = true;
    fieldEnabled['Golongan Darah'] = true;
    fieldEnabled['Keahlian Utama'] = true;
    fieldEnabled['Skill Tambahan 1'] = true;
    fieldEnabled['Skill Tambahan 2'] = true;
    if (data == null) return;

    _setBackendField(
      'NIK',
      nikController,
      data.idCard,
    );
    _setBackendField(
      'Nama Lengkap',
      nameController,
      '${data.firstName} ${data.lastName}'.trim(),
    );
    maritalStatusController.text = data.maritalStatus;
    maritalStatus.value = data.maritalStatus;
    _setBackendField('Tempat Lahir', birthPlaceController, data.birthplace);
    _setBackendField(
        'Tanggal Lahir',
        birthDateController,
        data.dateOfBirth == null
            ? ''
            : '${data.dateOfBirth!.day.toString().padLeft(2, '0')}-${data.dateOfBirth!.month.toString().padLeft(2, '0')}-${data.dateOfBirth!.year}');
    _setBackendField('Jenis Kelamin', genderController, data.gender);
    if (data.gender.trim().isNotEmpty) setGenderFromValue(data.gender);
    _setBackendField('Agama', religionController, data.religionId);
    if (data.religionId.trim().isNotEmpty) {
      setReligionFromValue(data.religionId);
    }
    _setBackendField('Golongan Darah', bloodTypeController, data.bloodType);
    if (data.bloodType.trim().isNotEmpty) {
      setBloodTypeFromValue(data.bloodType);
    }

    selectMainSkill(_skillId(data.mainSkill));

    final additionalSkills = data.additionalSkill is List
        ? (data.additionalSkill as List)
        : <dynamic>[];
    final additionalSkillIds = additionalSkills.map(_skillId).toList();
    selectAdditionalSkill1(
        additionalSkillIds.isNotEmpty ? additionalSkillIds.first : null);
    selectAdditionalSkill2(
        additionalSkillIds.length > 1 ? additionalSkillIds[1] : null);
  }

  void _setBackendField(
      String label, TextEditingController controller, dynamic value) {
    final text = value?.toString().trim() ?? '';
    if (text.isNotEmpty) controller.text = text;
    fieldEnabled[label] = true;
  }

  int? _skillId(dynamic value) {
    final id =
        value is num ? value.toInt() : int.tryParse(value?.toString() ?? '');
    return id != null &&
            dataMasterEmployeeOs.value.skills.any((skill) => skill.id == id)
        ? id
        : null;
  }

  bool isFieldEnabled(String label) => fieldEnabled[label] ?? true;

  void retake() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }

    isLoadingOCR.value = false;
    isDataLoaded.value = false;
    isDataLoadedFromBackend.value = false;
    isSubmitting.value = false;
    readingProgress.value = 0.0;
    isDifferent.value = false;
    scanOcrResponseData.value = null;
    croppedImagePath.value = '';
    _lastKtpResult = null;

    nikController.clear();
    nameController.clear();
    birthPlaceController.clear();
    birthDateController.clear();
    genderController.clear();
    addressController.clear();
    rtController.clear();
    rwController.clear();
    villageController.clear();
    districtController.clear();
    cityController.clear();
    provinceController.clear();
    religionController.clear();
    maritalStatusController.clear();
    bloodTypeController.clear();
    mainSkillsController.clear();
    additionalFirstSkillsController.clear();
    additionalSecondSkillsController.clear();
    workController.clear();
    nationalityController.clear();
    phoneController.clear();
    joinDateController.clear();

    selectedReligionId.value = null;
    selectedReligionName.value = null;
    selectedBloodType.value = null;
    selectedGender.value = null;
    selectedMainSkillId.value = null;
    selectedAdditionalSkill1Id.value = null;
    selectedAdditionalSkill2Id.value = null;
    maritalStatus.value = '';
    isDirect.value = null;
    isManufacturing.value = null;

    lowConfidenceFields.clear();
    fieldEnabled.clear();
    _needsManualFallback = false;
    formKey.currentState?.reset();
  }

  void reset() async {
    retake();
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
    if (genderController.text.trim().isEmpty) missing.add('Jenis Kelamin');
    if (birthPlaceController.text.trim().isEmpty) missing.add('Tempat Lahir');
    if (birthDateController.text.trim().isEmpty) missing.add('Tanggal Lahir');
    if (selectedReligionId.value == null) missing.add('Agama');
    if (selectedBloodType.value == null) missing.add('Golongan Darah');
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
      AppDialogImpl().showErrorSnackBar(
          description: 'Mohon lengkapi: ${missing.join(', ')}');
      return;
    }

    final usecase = _saveEmployeeOsUsecase ??
        (Get.isRegistered<SaveEmployeeOsUsecase>()
            ? Get.find<SaveEmployeeOsUsecase>()
            : null);
    if (usecase == null) {
      AppDialogImpl()
          .showErrorSnackBar(description: 'Use case simpan belum tersedia');
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
        mainSkill: selectedMainSkillId.value,
        additionalSkill: additionalSkills,
        joinDate: joinDateController.text.trim(),
        isManufacturing: isManufacturing.value ?? true,
        isDirect: isDirect.value ?? false,
        fileKtp: await _getKtpImageBase64(),
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

  Future<String?> _getKtpImageBase64() async {
    if (_needsManualFallback ||
        _lastKtpResult == null ||
        croppedImagePath.value.isEmpty) {
      return null;
    }

    try {
      return base64Encode(await File(croppedImagePath.value).readAsBytes());
    } on FileSystemException catch (error, stackTrace) {
      developer.log(
        'Failed to read scanned KTP image',
        error: error,
        stackTrace: stackTrace,
      );
      AppDialogImpl().showErrorSnackBar(
        description: 'Gagal membaca gambar KTP',
      );
      return null;
    }
  }
}
