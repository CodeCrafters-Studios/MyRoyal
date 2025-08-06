import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_trace_serial/data/models/trace_serial_model.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_trace_serial/data/models/trace_serial_params_model.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_trace_serial/domain/usecases/get_trace_serial_usecase.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/widgets/animations/animated_scanner_overlay.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CamAppTraceSerialController extends GetxController {
  CamAppTraceSerialController({required this.getTraceSerialUsecase});

  RxBool isExpand = false.obs;
  RxBool isExpandStatus = false.obs;
  RxBool isLoading = false.obs;
  RxBool isScanning = false.obs;

  final MobileScannerController cameraController = MobileScannerController();
  final TextEditingController textEditingController = TextEditingController();

  final GetTraceSerialUsecase getTraceSerialUsecase;

  final Rx<TraceSerialModel> traceSerialData = TraceSerialModel.empty().obs;

  @override
  void onClose() {
    _stopScanner();
    cameraController.dispose();
    super.onClose();
  }

  Future<void> getTraceSerial() async {
    isLoading.value = true;

    final result = await getTraceSerialUsecase(TraceSerialParamsModel(
      serial: textEditingController.text,
      // serial: '03438654020',
      company: 'CAM',
    ));

    result.fold(
      (l) {
        isLoading.value = false;
        AppUtils.logApp('ERROR $l');
      },
      (r) {
        isLoading.value = false;
        traceSerialData.value = r;
      },
    );
  }

  Future<void> openScanner() async {
    try {
      if (isScanning.value) {
        await _stopScanner();
        return;
      }

      if (Get.isBottomSheetOpen ?? false) return;

      isScanning.value = true;

      final completer = Completer<void>();

      final scannerBottomSheet = Get.bottomSheet(
        WillPopScope(
          onWillPop: () async {
            await Future.delayed(Duration(milliseconds: 50));
            await _stopScanner();
            completer.complete();
            return true;
          },
          child: Container(
            height: Get.height * 0.7,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      MobileScanner(
                        controller: cameraController,
                        onDetect: handleBarcode,
                      ),
                      Positioned.fill(
                        child: AnimatedScannerOverlay(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: _stopScanner,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: grey),
                    ),
                    child: Center(
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        isScrollControlled: true,
        enableDrag: false,
      );

      scannerBottomSheet.then((_) {
        if (!completer.isCompleted) {
          _stopScanner();
        }
      });

      await Future.delayed(Duration(milliseconds: 300));
      if (isScanning.value && !(Get.isBottomSheetOpen ?? false)) {
        await cameraController.start();
      }
    } catch (e) {
      await _stopScanner();
      Get.snackbar(
        'Error',
        'Failed to start scanner: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> handleBarcode(BarcodeCapture capture) async {
    try {
      final barcodes = capture.barcodes;
      if (barcodes.isEmpty) return;

      final String? barcode = barcodes.first.rawValue;
      if (barcode == null) return;

      await _stopScanner();

      textEditingController.text = barcode;

      Get.snackbar(
        'Scan Successful',
        'Scanned: $barcode',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    } catch (e) {
      await _stopScanner();
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        'Error',
        'Failed to process barcode: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _stopScanner() async {
    try {
      if (isScanning.value) {
        isScanning.value = false;
        await cameraController.stop();
        if (Get.isBottomSheetOpen ?? false) {
          await Future.delayed(Duration(milliseconds: 100));
          Get.back();
        }
      }
    } catch (e) {
      isScanning.value = false;
    }
  }
}
