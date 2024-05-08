import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/tracking_document_controller.dart';

class TrackingDocumentView extends GetView<TrackingDocumentController> {
  const TrackingDocumentView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TrackingDocumentView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TrackingDocumentView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
