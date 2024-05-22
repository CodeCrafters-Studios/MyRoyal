import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/help-and-support/entities/popular_questions.dart';

import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/app_divider.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';

import '../controllers/help_and_support_controller.dart';

class HelpAndSupportView extends GetView<HelpAndSupportController> {
  const HelpAndSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return HelpAndSupportViewImpl(controller: controller);
  }
}

class HelpAndSupportViewImpl extends StatelessWidget {
  final HelpAndSupportController controller;

  const HelpAndSupportViewImpl({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'Help & Support',
      child: SingleChildScrollView(
        child: EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppbarSpacer(),
              _buildHeaderText(),
              10.verticalSpace,
              _buildDescriptionText(),
              20.verticalSpace,
              _buildPopularQuestionsTitle(),
              15.verticalSpace,
              _buildPopularQuestionsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Text(
      'Hello! How can we help you today?',
      style: TS.titleLarge,
      textAlign: TextAlign.start,
    );
  }

  Widget _buildDescriptionText() {
    return Text(
      "Do you have any questions? Need an answer? We're here for you.",
      style:
          TS.labelLarge.copyWith(color: greyText, fontWeight: FontWeight.w400),
      textAlign: TextAlign.start,
    );
  }

  Widget _buildPopularQuestionsTitle() {
    return Text(
      'Popular Questions:',
      style: TS.titleLarge,
      textAlign: TextAlign.start,
    );
  }

  Widget _buildPopularQuestionsList() {
    return SizedBox(
      height: 900.h,
      child: ListView.separated(
        separatorBuilder: (_, __) => const IntrinsicHeight(
          child: AppDivider(color: grey),
        ),
        padding: REdgeInsets.only(bottom: 150),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.listPopularQuestions.length,
        itemBuilder: (context, index) {
          final question = controller.listPopularQuestions[index];
          return _buildQuestionTile(context, question);
        },
      ),
    );
  }

  Widget _buildQuestionTile(BuildContext context, PopularQuestions question) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        title: Text(
          question.title,
          style: TS.bodyMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        backgroundColor: white,
        collapsedBackgroundColor: white,
        iconColor: black,
        collapsedIconColor: black,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(question.description, style: TS.bodySmall),
          ),
        ],
      ),
    );
  }
}
