import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_tasks_controller.dart';

class DetailTasksView extends GetView<DetailTasksController> {
  const DetailTasksView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailTasksView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DetailTasksView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
