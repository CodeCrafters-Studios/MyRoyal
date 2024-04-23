import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/my_teams_controller.dart';

class MyTeamsView extends GetView<MyTeamsController> {
  const MyTeamsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyTeamsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MyTeamsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
