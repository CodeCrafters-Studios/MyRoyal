import 'dart:io';

import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/buttons/button_primary.dart';
import 'package:MyRoyal/base/widgets/dropdown/dropdown_primary.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:MyRoyal/base/widgets/textfield/input_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/ocr_controller.dart';

class OcrView extends GetView<OcrController> {
  const OcrView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OcrView2'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoadingOCR.value) return _buildReadingPage(context);
        if (controller.selectedEmployeeIndex.value >= 0 &&
            controller.isDataLoadedFromBackend.value) {
          return _buildInfoPage(context);
        }
        if (controller.selectedEmployeeIndex.value >= 0) {
          return _buildScanPage();
        }
        return _buildEmployeeList();
      }),
    );
  }

  Widget _buildScanPage() {
    return Container(
      color: const Color(0xFF0F1720),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: controller.reset,
              icon: const Icon(
                Icons.arrow_back,
                color: white,
              ),
              label: Text(
                'Kembali ke list',
                style: TS.bodyMedium.copyWith(color: white),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Scan KTP (Depan)',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 18),
          Expanded(
              child: Obx(() => controller.croppedImagePath.value.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Tips:',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            _buildTip('Jaga jarak kamera sekitar 20–30 cm'),
                            _buildTip('Pastikan seluruh bagian KTP terlihat'),
                            _buildTip('Hindari jari menutupi tepi KTP'),
                          ],
                        ),
                      ))
                  : Image.file(File(controller.croppedImagePath.value),
                      fit: BoxFit.contain))),
          const SizedBox(height: 24),
          ButtonPrimary(
              fullWidth: true,
              text: 'Mulai Scan KTP',
              onPressed: controller.scanDocument),
          const SizedBox(height: 16),
          Center(
              child: GestureDetector(
            onTap: () => controller.pickImage(ImageSource.gallery),
            child: const Text('Pilih dari Galeri',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildEmployeeList() {
    return Obx(() {
      if (controller.isLoading.value) return _buildEmployeeShimmer();

      return SearchTextInheritedWidget(
        searchText: RegExp.escape(controller.search.text),
        child: SingleChildScrollView(
          child: Column(children: [
            _buildSearch(),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: REdgeInsets.only(bottom: 100, top: 15),
              itemCount: controller.filteredEmployeeDataList.length,
              separatorBuilder: (_, __) => 10.verticalSpace,
              itemBuilder: (_, index) {
                final data = controller.filteredEmployeeDataList[index];
                return RPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SearchHighlightText(data.fullName,
                                  style: TS.labelLarge,
                                  highlightStyle: TS.labelLarge.copyWith(
                                      backgroundColor: Colors.yellow)),
                              SearchHighlightText(
                                  '${data.id} / ${data.noRegistration}',
                                  style: TS.bodyMedium,
                                  highlightStyle: TS.bodyMedium.copyWith(
                                      backgroundColor: Colors.yellow)),
                              SearchHighlightText(data.status,
                                  style: TS.bodySmall.copyWith(color: greyText),
                                  highlightStyle: TS.bodySmall.copyWith(
                                      color: greyText,
                                      backgroundColor: Colors.yellow)),
                            ]),
                        ButtonPrimary(
                            text: 'Scan',
                            onPressed: () {
                              final rawIndex = controller.employeeDataList
                                  .indexWhere(
                                      (employee) => employee.id == data.id);
                              controller.selectedEmployeeIndex.value = rawIndex;
                            }),
                      ]),
                );
              },
            ),
          ]),
        ),
      );
    });
  }

  Widget _buildEmployeeShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.separated(
        padding: REdgeInsets.fromLTRB(14, 24, 14, 100),
        itemCount: 10,
        separatorBuilder: (_, __) => 10.verticalSpace,
        itemBuilder: (_, __) {
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 18, width: 180, color: Colors.white),
                    const SizedBox(height: 6),
                    Container(height: 14, width: 130, color: Colors.white),
                    const SizedBox(height: 6),
                    Container(height: 12, width: 80, color: Colors.white),
                  ],
                ),
              ),
              Container(height: 40, width: 80, color: Colors.white),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearch() {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InputPrimary(
        controller: controller.search,
        label: '',
        hint: 'Cari',
        onChanged: controller.onChanged,
        color: white,
        outlineColor: primary,
        prefixIcon: _buildPrefixIcon(),
        suffixIcon: _buildSuffixIcon(),
      ),
    );
  }

  Widget _buildPrefixIcon() {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SvgPicture.asset(
        'assets/icons/ic_search.svg',
        width: 20.w,
        height: 20.w,
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    final valueListener = controller.valueListener.value;
    return valueListener.isNotEmpty
        ? IconButton(
            onPressed: controller.clear,
            icon: const Icon(Icons.clear),
          )
        : null;
  }

  Widget _buildReadingPage(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            const Text('Pembacaan KTP',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.credit_card,
                        size: 56, color: Color(0xFF00AFA6)),
                  ),
                  const SizedBox(height: 24),
                  const Text('Sedang Membaca KTP',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  const Text('Mohon tunggu beberapa saat...',
                      style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 24),
                  Obx(() => LinearProgressIndicator(
                      value: controller.readingProgress.value,
                      color: const Color(0xFF00AFA6),
                      backgroundColor: Colors.grey[200])),
                  const SizedBox(height: 8),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Obx(() => Text(
                          '${(controller.readingProgress.value * 100).round()}%'))),
                ],
              ),
            ),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: const [
                    Icon(Icons.auto_awesome, color: Color(0xFF00AFA6)),
                    SizedBox(width: 12),
                    Expanded(
                        child: Text(
                            'OCR sedang mengekstrak data dari KTP Anda. Jangan tutup aplikasi selama proses berlangsung')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPage(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                        'Data berhasil dibaca. Silakan periksa kembali data Anda',
                        style: TextStyle(color: Colors.black87)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: controller.formKey,
              child: Column(
                children: [
                  _buildInput('NIK', controller.nikController,
                      keyboardType: TextInputType.number),
                  _buildInput('Nama Lengkap', controller.nameController),
                  Row(
                    children: [
                      Expanded(
                          child: _buildInput(
                              'Tempat Lahir', controller.birthPlaceController)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _buildInput(
                              'Tanggal Lahir', controller.birthDateController,
                              readOnly: true, onTap: controller.pickBirthDate)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Obx(() => _buildDropdown(
                        label: 'Jenis Kelamin',
                        hintText: 'Pilih jenis kelamin',
                        value: controller.selectedGender.value,
                        items: const ['Laki-laki', 'Perempuan'],
                        onChanged: (value) {
                          if (value != null) {
                            controller.setGenderFromValue(value);
                          }
                        },
                      )),
                  // const SizedBox(height: 8),
                  // _buildInput('Alamat', controller.addressController,
                  //     maxLines: 2),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                        child: Obx(() => _buildDropdown(
                              label: 'Agama',
                              hintText: 'Pilih agama',
                              value: controller.selectedReligionName.value,
                              items: controller
                                  .dataMasterEmployeeOs.value.religions
                                  .map((item) => item.name)
                                  .toList(),
                              onChanged: (value) {
                                if (value != null)
                                  controller.setReligionFromValue(value);
                              },
                            ))),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Obx(() => _buildDropdown(
                              label: 'Golongan Darah',
                              hintText: 'Pilih golongan darah',
                              value: controller.selectedBloodType.value,
                              items: controller
                                  .dataMasterEmployeeOs.value.bloodTypes.keys
                                  .toList(),
                              itemLabels: controller
                                  .dataMasterEmployeeOs.value.bloodTypes.values
                                  .toList(),
                              onChanged: (value) {
                                if (value != null)
                                  controller.setBloodTypeFromValue(value);
                              },
                            ))),
                  ]),
                  const SizedBox(height: 8),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //         child: _buildInput('RT', controller.rtController)),
                  //     const SizedBox(width: 8),
                  //     Expanded(
                  //         child: _buildInput('RW', controller.rwController)),
                  //   ],
                  // ),
                  // const SizedBox(height: 8),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //         child: _buildInput(
                  //             'Kelurahan/Desa', controller.villageController)),
                  //     const SizedBox(width: 8),
                  //     Expanded(
                  //         child: _buildInput(
                  //             'Kecamatan', controller.districtController)),
                  //   ],
                  // ),
                  // const SizedBox(height: 8),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //         child: _buildInput(
                  //             'Kota/Kabupaten', controller.cityController)),
                  //     const SizedBox(width: 8),
                  //     Expanded(
                  //         child: _buildInput(
                  //             'Provinsi', controller.provinceController)),
                  //   ],
                  // ),

                  const SizedBox(height: 8),
                  Obx(() => _buildSkillDropdown(
                        label: 'Keahlian Utama',
                        value: controller.selectedMainSkillId.value,
                        items: controller.getAvailableSkills(
                            excludeSelectedSkillId:
                                controller.selectedMainSkillId.value),
                        onChanged: controller.selectMainSkill,
                      )),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                        child: Obx(() => _buildSkillDropdown(
                              label: 'Skill Tambahan 1',
                              value:
                                  controller.selectedAdditionalSkill1Id.value,
                              items: controller.getAvailableSkills(
                                  excludeSelectedSkillId: controller
                                      .selectedAdditionalSkill1Id.value),
                              onChanged: controller.selectAdditionalSkill1,
                            ))),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Obx(() => _buildSkillDropdown(
                              label: 'Skill Tambahan 2',
                              value:
                                  controller.selectedAdditionalSkill2Id.value,
                              items: controller.getAvailableSkills(
                                  excludeSelectedSkillId: controller
                                      .selectedAdditionalSkill2Id.value),
                              onChanged: controller.selectAdditionalSkill2,
                            ))),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Obx(() => Expanded(
                          child: _buildDropdown(
                            label: 'Bagian',
                            hintText: 'Pilih bagian',
                            value: controller.isManufacturing.value == null
                                ? null
                                : controller.isManufacturing.value!
                                    ? 'Manufacturing'
                                    : 'Non Manufacturing',
                            items: const ['Manufacturing', 'Non Manufacturing'],
                            onChanged: (value) => controller
                                    .isManufacturing.value =
                                value == null ? null : value == 'Manufacturing',
                          ),
                        )),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Obx(() => _buildDropdown(
                              label: 'Direct',
                              hintText: 'Pilih status direct',
                              value: controller.isDirect.value == null
                                  ? null
                                  : controller.isDirect.value!
                                      ? 'Direct'
                                      : 'in Direct',
                              items: const ['Direct', 'in Direct'],
                              onChanged: (value) => controller.isDirect.value =
                                  value == null ? null : value == 'Direct',
                            ))),
                  ]),
                  const SizedBox(height: 8),
                  _buildDateInput(),

                  // Row(
                  //   children: [
                  //     Expanded(
                  //         child: _buildInput(
                  //             'Pekerjaan', controller.workController)),
                  //     const SizedBox(width: 8),
                  //     Expanded(
                  //         child: _buildInput('Kewarganegaraan',
                  //             controller.nationalityController)),
                  //   ],
                  // ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ButtonPrimary(
                            fullWidth: true,
                            text: 'Retake',
                            textColor: primary,
                            borderSide: BorderSide(color: primary),
                            color: white,
                            onPressed: () => controller.retake()),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ButtonPrimary(
                            fullWidth: true,
                            text: 'Submit',
                            isLoading: controller.isSubmitting.value,
                            enable: !controller.isSubmitting.value,
                            onPressed: () => controller.submitData()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller,
      {int maxLines = 1,
      TextInputType? keyboardType,
      bool readOnly = false,
      VoidCallback? onTap}) {
    return Obx(() {
      final isLowConfidence =
          this.controller.lowConfidenceFields[label] ?? false;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: isLowConfidence
                  ? const BorderSide(color: Colors.orange, width: 2)
                  : BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: isLowConfidence
                  ? const BorderSide(color: Colors.orange, width: 2)
                  : BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: secondary),
              // isLowConfidence
              //     ? const BorderSide(color: Colors.orange, width: 2)
              //     : const BorderSide(color: Color(0xFF00AFA6), width: 2),
            ),
            isDense: true,
          ),
          validator: (v) => (v == null || v.isEmpty) ? 'Mohon diisi' : null,
        ),
      );
    });
  }

  Widget _buildDropdown({
    required String label,
    required String hintText,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    List<String>? itemLabels,
  }) {
    final safeValue = value != null && items.contains(value) ? value : null;
    return DropDownPrimary(
      label: label,
      hintText: hintText,
      value: safeValue,
      items: items.asMap().entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.value,
          child: Text(itemLabels?[entry.key] ?? entry.value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF00AFA6), size: 20),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text, style: const TextStyle(color: Colors.white70))),
        ],
      ),
    );
  }

  Widget _buildSkillDropdown({
    required String label,
    required int? value,
    required List<dynamic> items,
    required ValueChanged<int?> onChanged,
  }) {
    final ids = items.map((item) => item.id as int).toList();
    final safeValue = value != null && ids.contains(value) ? value : null;
    return _buildDropdown(
      label: label,
      hintText: 'Pilih skill',
      value: safeValue?.toString(),
      items: items.map((item) => item.id.toString()).toList(),
      itemLabels: items.map((item) => item.name as String).toList(),
      onChanged: (selected) =>
          onChanged(selected == null ? null : int.tryParse(selected)),
    );
  }

  Widget _buildDateInput() {
    return _buildInput(
      'Tanggal Bergabung',
      controller.joinDateController,
      readOnly: true,
      onTap: controller.pickJoinDate,
    );
  }
}
