import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/dropdown/dropdown_primary.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'Edit Profile',
      child: SingleChildScrollView(
        child: EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppbarSpacer(),
                Text(
                  'Edit your profile data',
                  style: TS.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                ),
                10.verticalSpace,
                Text(
                  'Customize your profile data. Ensure it match with your data right now.',
                  style: TS.bodyMedium.copyWith(fontWeight: FontWeight.w400),
                ),
                30.verticalSpace,
                InputPrimary(
                  controller: controller.firstNameController,
                  label: 'Firstname',
                  color: white,
                  outlineColor: grey,
                  hint: controller.argumentData.personal.fullName.isNotEmpty
                      ? controller.argumentData.personal.fullName
                      : 'Firstname',
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
                  controller: controller.lastNameController,
                  label: 'Lastname',
                  color: white,
                  outlineColor: grey,
                  hint: controller.argumentData.personal.lastName.isNotEmpty
                      ? controller.argumentData.personal.lastName
                      : 'Lastname',
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
                  label: 'Nickname',
                  color: white,
                  outlineColor: grey,
                  hint: controller.argumentData.personal.nickname.isNotEmpty
                      ? controller.argumentData.personal.nickname
                      : 'Nickname',
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
                  maxLength: 15,
                  label: 'NPWP',
                  color: white,
                  outlineColor: grey,
                  hint: controller.argumentData.personal.npwp.isNotEmpty
                      ? controller.argumentData.personal.npwp
                      : 'Enter your NPWP',
                  hintStyle: TS.bodyMedium.copyWith(
                    color: grey,
                  ),
                  validation: (value) {
                    AppUtils.logApp('HERE ${controller.npwp.value}');
                    if (value!.length < 15) {
                      return 'Password must be at least 15 characters long';
                    }
                    return null;
                  },
                  onChanged: (value) => controller.setEditProfileValue(
                    FormLoginValue.npwp,
                    value,
                  ),
                ),
                20.verticalSpace,
                DropDownPrimary(
                  label: 'NPWP Status',
                  hintText: 'Please choose a NPWP status',
                  items: controller.listNpwpStatus
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
                  icon: controller.npwpStatus.value.isNotEmpty
                      ? IconButton(
                          onPressed: controller.clearNpwpStatus,
                          icon: Icon(
                            Icons.close,
                            size: 20.r,
                          ),
                        )
                      : const Icon(Icons.arrow_drop_down),
                  value: controller.npwpStatus.value.isEmpty
                      ? null
                      : controller.npwpStatus.value,
                  onChanged: (value) => controller.setNpwpStatus(value!),
                ),
                20.verticalSpace,
                InputPrimary(
                  label: 'Personal Email',
                  color: white,
                  outlineColor: grey,
                  hint:
                      controller.argumentData.personal.personalEmail.isNotEmpty
                          ? controller.argumentData.personal.personalEmail
                          : 'Enter your email',
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
                  hint: controller.argumentData.personal.instagram.isNotEmpty
                      ? controller.argumentData.personal.instagram
                      : 'Enter your instagram',
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
                  hint: controller.argumentData.personal.linkedin.isNotEmpty
                      ? controller.argumentData.personal.linkedin
                      : 'Enter your linkedin',
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
                  label: 'Marital Status',
                  hintText: 'Please choose a marital status',
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
                  enable: controller.enableButton.value,
                  fullWidth: true,
                  margin: REdgeInsets.only(left: 16, bottom: 20, right: 16),
                  text: 'Continue',
                  onPressed: () => controller.patchEditProfile(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
