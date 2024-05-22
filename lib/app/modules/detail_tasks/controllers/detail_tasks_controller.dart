import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/detail_tasks/views/components/tabs/tab_subtask_view.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/widgets/others/ticker_provider.dart';

class DetailTasksController extends GetxController {
  List randomImages = [
    'https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg',
    'https://pbs.twimg.com/profile_images/1249432648684109824/J0k1DN1T_400x400.jpg',
    'https://i0.wp.com/thatrandomagency.com/wp-content/uploads/2021/06/headshot.png?resize=618%2C617&ssl=1',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaOjCZSoaBhZyODYeQMDCOTICHfz_tia5ay8I_k3k&s'
  ];

  List<SubTaskCard> listSubTasks = <SubTaskCard>[
    SubTaskCard(
      title: 'Create a user Flow',
      value: false,
      onChanged: (value) {},
    ),
    SubTaskCard(
      title: 'Create a story board',
      value: false,
      onChanged: (value) {},
    ),
    SubTaskCard(
      title: 'Create a user Flow',
      value: false,
      onChanged: (value) {},
    ),
    SubTaskCard(
      title: 'Create a story board',
      value: false,
      onChanged: (value) {},
    ),
    SubTaskCard(
      title: 'Create a user Flow',
      value: false,
      onChanged: (value) {},
    ),
    SubTaskCard(
      title: 'Create a user Flow',
      value: false,
      onChanged: (value) {},
    ),
    SubTaskCard(
      title: 'Create a story board',
      value: false,
      onChanged: (value) {},
    ),
    SubTaskCard(
      title: 'Create a user Flow',
      value: false,
      onChanged: (value) {},
    ),
    SubTaskCard(
      title: 'Create a story board',
      value: false,
      onChanged: (value) {},
    ),
    SubTaskCard(
      title: 'Create a user Flow',
      value: false,
      onChanged: (value) {},
    ),
  ];

  late List<RxBool> checkStates;

  RxBool check = false.obs;
  RxInt currentIndex = 0.obs;

  late final TabController tabController;

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: TicckerProvider());
    checkStates = List.generate(listSubTasks.length, (index) => false.obs);
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void onChangedChecklist(bool value, int index) {
    checkStates[index].value = value;
    currentIndex.value = index;
    AppUtils.logApp('Selected sub task index: ${currentIndex.value}');
    AppUtils.logApp('Check sub task: ${checkStates[index].value}');
  }
}
