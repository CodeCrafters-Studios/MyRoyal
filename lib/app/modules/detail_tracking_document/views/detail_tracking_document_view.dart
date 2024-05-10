import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_tracking_document_controller.dart';

class DetailTrackingDocumentView
    extends GetView<DetailTrackingDocumentController> {
  const DetailTrackingDocumentView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailTrackingDocumentView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DetailTrackingDocumentView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
