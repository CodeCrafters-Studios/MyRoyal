import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/salary_controller.dart';

class SalaryView extends GetView<SalaryController> {
  const SalaryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SalaryView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SalaryView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
