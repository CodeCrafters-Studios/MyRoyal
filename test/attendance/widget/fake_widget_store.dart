import 'dart:typed_data';

import 'package:MyRoyal/app/modules/attendance/widget/attendance_widget_sync.dart';

/// In-memory replacement for the `home_widget` platform storage.
class FakeWidgetStore implements AttendanceWidgetStore {
  FakeWidgetStore({this.fail = false});

  final bool fail;
  final Map<String, String?> strings = {};
  final Map<String, Uint8List> files = {};
  int refreshes = 0;

  @override
  Future<void> saveString(String key, String? value) async {
    if (fail) throw Exception('platform unavailable');
    strings[key] = value;
  }

  @override
  Future<void> saveFile(String key, Uint8List bytes, String extension) async {
    if (fail) throw Exception('platform unavailable');
    files[key] = bytes;
    strings[key] = '/widget/$key.$extension';
  }

  @override
  Future<void> refreshWidgets() async {
    if (fail) throw Exception('platform unavailable');
    refreshes++;
  }
}
