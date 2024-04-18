import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/bottomnavbar_controller.dart';

class BottomnavbarView extends GetView<BottomnavbarController> {
  const BottomnavbarView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomnavbarView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BottomnavbarView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
