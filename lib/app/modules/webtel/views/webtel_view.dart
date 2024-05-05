import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/webtel_controller.dart';

class WebtelView extends GetView<WebtelController> {
  const WebtelView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebtelView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'WebtelView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
