import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pin_controller.dart';

class PinView extends GetView<PinController> {
  const PinView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PinView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PinView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
