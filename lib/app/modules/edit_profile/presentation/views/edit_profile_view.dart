import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/appbar_spacer.dart';
import 'package:MyRoyal/base/widgets/buttons/button_primary.dart';
import 'package:MyRoyal/base/widgets/dropdown/dropdown_primary.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';
import 'package:MyRoyal/base/widgets/textfield/input_primary.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'Ubah Profil',
      child: SingleChildScrollView(
        child: EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppbarSpacer(),
                10.verticalSpace,
                Center(
                  child: Stack(
                    children: [
                      Obx(() => CircleAvatar(
                            backgroundColor: primary,
                            radius: 40,
                            child: controller.selectedImage.value != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.file(
                                      controller.selectedImage.value!,
                                      fit: BoxFit.cover,
                                      width: 80.w,
                                      height: 80.h,
                                    ),
                                  )
                                : controller.argumentData.data.personal
                                        .profilePicture.isNotEmpty
                                    ? ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: controller.argumentData.data
                                              .personal.profilePicture,
                                          width: 80.r,
                                          height: 80.r,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Center(
                                            child: Text(
                                              controller.userData.initialName,
                                              style: TS.titleLarge
                                                  .copyWith(color: white),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          controller.userData.initialName,
                                          style: TS.titleLarge
                                              .copyWith(color: white),
                                        ),
                                      ),
                          )),
                      Positioned(
                        left: 48.w,
                        top: 48.h,
                        child: CircleAvatar(
                          backgroundColor: secondary,
                          radius: 15,
                          child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  scrollControlDisabledMaxHeightRatio: 0.2,
                                  context: context,
                                  builder: (_) {
                                    return EPadding(
                                      padding: const EdgeInsets.all(10),
                                      child: ListTile(
                                        leading:
                                            const Icon(Icons.photo_library),
                                        title: const Text('Pilih dari galeri'),
                                        onTap: () {
                                          controller
                                              .pickImage(ImageSource.gallery);
                                          Get.back();
                                        },
                                      ),
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 15,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                20.verticalSpace,
                InputPrimary(
                  label: 'Nama Depan',
                  color: white,
                  outlineColor: grey,
                  initialValue: controller.argumentData.data.personal.firstName,
                  textStyle: TS.bodyMedium,
                  hint: controller.firstName.value.isEmpty
                      ? 'Masukkan Nama Depan'
                      : '',
                  hintStyle: TS.bodyMedium.copyWith(
                    color: grey,
                  ),
                  onChanged: (value) => controller.setEditProfileValue(
                    FormLoginValue.firstName,
                    value,
                  ),
                ),
                20.verticalSpace,
                InputPrimary(
                  label: 'Nama Belakang',
                  color: white,
                  outlineColor: grey,
                  initialValue: controller.argumentData.data.personal.lastName,
                  textStyle: TS.bodyMedium,
                  hint: controller.lastName.value.isEmpty
                      ? 'Masukkan Nama Belakang'
                      : '',
                  hintStyle: TS.bodyMedium.copyWith(
                    color: grey,
                  ),
                  onChanged: (value) => controller.setEditProfileValue(
                    FormLoginValue.lastName,
                    value,
                  ),
                ),
                20.verticalSpace,
                InputPrimary(
                  label: 'Nama Panggilan',
                  color: white,
                  outlineColor: grey,
                  initialValue: controller.argumentData.data.personal.nickname,
                  textStyle: TS.bodyMedium,
                  hint: controller.nickname.value.isEmpty
                      ? 'Masukkan Nama Panggilan'
                      : '',
                  hintStyle: TS.bodyMedium.copyWith(
                    color: grey,
                  ),
                  onChanged: (value) => controller.setEditProfileValue(
                    FormLoginValue.nickname,
                    value,
                  ),
                ),
                20.verticalSpace,
                InputPrimary(
                  label: 'Email Pribadi',
                  color: white,
                  outlineColor: grey,
                  initialValue:
                      controller.argumentData.data.personal.personalEmail,
                  textStyle: TS.bodyMedium,
                  hint: controller.email.value.isEmpty
                      ? 'Masukkan Email Pribadi'
                      : '',
                  hintStyle: TS.bodyMedium.copyWith(
                    color: grey,
                  ),
                  onChanged: (value) => controller.setEditProfileValue(
                    FormLoginValue.email,
                    value,
                  ),
                ),
                20.verticalSpace,
                InputPrimary(
                  label: 'Instagram',
                  color: white,
                  outlineColor: grey,
                  initialValue: controller.argumentData.data.personal.instagram,
                  textStyle: TS.bodyMedium,
                  hint: controller.instagram.value.isEmpty
                      ? 'Masukkan Instagram'
                      : '',
                  hintStyle: TS.bodyMedium.copyWith(
                    color: grey,
                  ),
                  onChanged: (value) => controller.setEditProfileValue(
                    FormLoginValue.instagram,
                    value,
                  ),
                ),
                20.verticalSpace,
                InputPrimary(
                  label: 'LinkedIn',
                  color: white,
                  outlineColor: grey,
                  initialValue: controller.argumentData.data.personal.linkedin,
                  textStyle: TS.bodyMedium,
                  hint: controller.linkedIn.value.isEmpty
                      ? 'Masukkan LinkedIn'
                      : '',
                  hintStyle: TS.bodyMedium.copyWith(
                    color: grey,
                  ),
                  onChanged: (value) => controller.setEditProfileValue(
                    FormLoginValue.linkedin,
                    value,
                  ),
                ),
                20.verticalSpace,
                DropDownPrimary(
                  label: 'Status Pernikahan',
                  hintText: 'Silahkan pilih status pernikahan',
                  items: controller.listMaritalStatus
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      alignment: Alignment.centerLeft,
                      value: value,
                      child: Text(
                        value,
                        style: TS.bodyMedium,
                      ),
                    );
                  }).toList(),
                  icon: controller.maritalStatus.value.isNotEmpty
                      ? IconButton(
                          onPressed: controller.clearMaritalStatus,
                          icon: Icon(
                            Icons.close,
                            size: 20.r,
                          ),
                        )
                      : const Icon(Icons.arrow_drop_down),
                  value: controller.maritalStatus.value.isEmpty
                      ? null
                      : controller.maritalStatus.value,
                  onChanged: (value) => controller.setMaritalStatus(value!),
                ),
                50.verticalSpace,
                ButtonPrimary(
                  isLoading: controller.isLoading.value,
                  enable: controller.enableButton.value,
                  fullWidth: true,
                  margin: REdgeInsets.only(bottom: 25),
                  text: 'Simpan',
                  onPressed: () => controller.saveProfile(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
