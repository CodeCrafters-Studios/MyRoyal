import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';

import '../controllers/tasks_controller.dart';

class TasksView extends GetView<TasksController> {
  const TasksView({super.key});
  @override
  Widget build(BuildContext context) {
    return PageBase(
      title: '',
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppbarSpacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'My Task',
                      style: TS.titleLarge,
                    ),
                    Text(
                      '10 Jan 2024',
                      style: TS.bodyMedium,
                    ),
                  ],
                ),
                ButtonPrimary(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    fullWidth: false,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add,
                          size: 20,
                          color: white,
                        ),
                        5.horizontalSpace,
                        Text(
                          'Add Task',
                          style: TS.bodyMedium.copyWith(
                            color: white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {}),
              ],
            ),
            SizedBox(
              height: 300.h,
              width: Get.width,
              child: GridView.count(
                childAspectRatio: 1.5,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                shrinkWrap: true,
                children: [
                  Container(
                    height: 150,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(14),
                      ),
                      color: Colors.blue.withOpacity(0.8),
                    ),
                    child: EPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.checklist_outlined,
                              size: 25,
                              color: white,
                            ),
                          ),
                          Text(
                            'To-Do',
                            style: TS.bodyLarge.copyWith(
                              color: white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          10.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '3 Tasks',
                                style: TS.bodyMedium.copyWith(color: white),
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                color: white,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 150,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(14),
                      ),
                      color: Colors.orangeAccent.withOpacity(0.8),
                    ),
                    child: EPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.timer_outlined,
                              size: 25,
                              color: white,
                            ),
                          ),
                          Text(
                            'In-Progress',
                            style: TS.bodyLarge.copyWith(
                              color: white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          10.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '6 Tasks',
                                style: TS.bodyMedium.copyWith(color: white),
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                color: white,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 150,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(14),
                      ),
                      color: Colors.green.withOpacity(0.8),
                    ),
                    child: EPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.check_box_outlined,
                              size: 25,
                              color: white,
                            ),
                          ),
                          Text(
                            'Completed',
                            style: TS.bodyLarge.copyWith(
                              color: white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          10.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '12 Tasks',
                                style: TS.bodyMedium.copyWith(color: white),
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                color: white,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 150,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(14),
                      ),
                      color: red.withOpacity(0.8),
                    ),
                    child: EPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.warning_amber_rounded,
                              size: 25,
                              color: white,
                            ),
                          ),
                          Text(
                            'Cancel',
                            style: TS.bodyLarge.copyWith(
                              color: white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          10.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '0 Tasks',
                                style: TS.bodyMedium.copyWith(color: white),
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                color: white,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            10.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My latest task report',
                  style: TS.titleLarge,
                ),
                Text(
                  'View All',
                  style: TS.bodyMedium,
                ),
              ],
            ),
            SizedBox(
              height: 300.h,
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (_, __) {
                  return CardApp(
                    margin: REdgeInsets.only(bottom: 15),
                    borderWidth: 1,
                    isOutlined: true,
                    height: 135,
                    width: Get.width,
                    isShadow: true,
                    shadows: Shadows.small,
                    child: EPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Project Title',
                                style: TS.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                width: 65.w,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(24),
                                  ),
                                  color: Colors.blue.withOpacity(0.3),
                                ),
                                child: Center(
                                  child: Text(
                                    'To-Do',
                                    style: TS.bodyMedium.copyWith(
                                        color: Colors.blue.withOpacity(0.8)),
                                  ),
                                ),
                              )
                            ],
                          ),
                          10.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Progress',
                                style: TS.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '10% complete',
                                style: TS.bodyMedium.copyWith(
                                    color: Colors.red.withOpacity(0.8)),
                              ),
                            ],
                          ),
                          15.verticalSpace,
                          const LinearProgressIndicator(
                            color: Colors.red,
                            backgroundColor: greyHint,
                            value: 0.2,
                          ),
                          15.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Due Date: 17, May 2024',
                                style: TS.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '3 persons',
                                    style: TS.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  5.horizontalSpace,
                                  const Icon(
                                    Icons.people_alt_outlined,
                                    color: Colors.grey,
                                    size: 24,
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
