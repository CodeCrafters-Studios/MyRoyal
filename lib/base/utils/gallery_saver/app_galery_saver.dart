import 'dart:typed_data';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:iroyal/base/config/app_config.dart';

abstract class AppGallerySaver {
  Future<void> save(Uint8List data);
}

class AppGallerySaverImpl implements AppGallerySaver {
  @override
  Future<void> save(Uint8List data) async {
    try {
      await ImageGallerySaver.saveImage(data, name: AppConfig.fileName);
    } catch (e) {
      rethrow;
    }
  }
}
