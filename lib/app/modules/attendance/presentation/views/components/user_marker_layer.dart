import 'package:MyRoyal/app/modules/attendance/presentation/controllers/attendance_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

class UserMarkerLayer extends GetView<AttendanceController> {
  const UserMarkerLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pos = controller.currentPosition.value;

      if (pos == null) {
        return const MarkerLayer(markers: []);
      }

      return MarkerLayer(
        markers: [
          Marker(
            point: pos,
            width: 40,
            height: 40,
            child: const Icon(
              Icons.person_pin_circle,
              color: Colors.blue,
              size: 40,
            ),
          ),
        ],
      );
    });
  }
}
