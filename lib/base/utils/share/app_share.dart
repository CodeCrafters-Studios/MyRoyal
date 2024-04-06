import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

abstract class AppShare {
  Future<void> share(String path);
  Future<String> pathProvider();
}

class AppShareImpl extends AppShare {
  @override
  Future<void> share(String path) async {
    try {
      final x = XFile(path); //File has to be created first
      await Share.shareXFiles([x]);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> pathProvider() async {
    var directory = '';
    if (Platform.isAndroid) {
      directory = (await getExternalStorageDirectory())!.path;
    } else {
      directory = (await getTemporaryDirectory()).path;
    }

    return directory;
  }
}
