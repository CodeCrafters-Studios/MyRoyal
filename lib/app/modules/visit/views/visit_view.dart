import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/visit_controller.dart';

class VisitView extends GetView<VisitController> {
  const VisitView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VisitView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'VisitView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
