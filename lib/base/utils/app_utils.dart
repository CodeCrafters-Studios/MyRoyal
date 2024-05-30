import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:convert' as convert;
import 'dart:developer' as d;

import 'package:dog/dog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppUtils {
  static dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static Future<void> delay({int duration = 500}) async {
    await Future.delayed(Duration(milliseconds: duration));
  }

  static Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return 'v${packageInfo.version}';
  }

  static Future<bool> checkIsJailBroken() async {
    if (kReleaseMode) {
      final b = await FlutterJailbreakDetection.jailbroken;
      return b;
    }
    return false;
  }

  // static bool checkTokenValidity(String token) {
  //   try {
  //     return !JwtDecoder.isExpired(token);
  //   } catch (e) {
  //     logApp(e.toString());
  //     return false;
  //   }
  // }

  static getMeccaBearing(double lat, double long) {
    var startLat = lat;
    var startLng = long;

    const latitudeKabah = 21.422487;
    const longitudeKabah = 39.826206;
    startLat = toRadians(startLat);
    startLng = toRadians(startLng);
    final destLat = toRadians(latitudeKabah);
    final destLng = toRadians(longitudeKabah);

    final y = sin(destLng - startLng) * cos(destLat);
    final x = cos(startLat) * sin(destLat) -
        sin(startLat) * cos(destLat) * cos(destLng - startLng);
    var brng = atan2(y, x);
    brng = toDegrees(brng);
    // final v = brng = brng + 360;

    final fraction = modf(brng + 360.0, brng);
    brng += fraction;

    if (brng > 360) {
      brng -= 360;
    }
    return brng;
  }

  static toRadians(degrees) {
    return (degrees * pi) / 180;
  }

  // Converts from radians to degrees.
  static toDegrees(radians) {
    return (radians * 180) / pi;
    // return radians;
  }

  static modf(double orig, ipart) {
    return orig - (orig.floor());
  }

  static String base64Encode(String data) {
    final content = convert.utf8.encode(data);
    final digest = convert.base64Encode(content);
    return digest;
  }

  static String base64Decode(String data) {
    final List<int> bytes = convert.base64Decode(data);
    final result = convert.utf8.decode(bytes);
    return result;
  }

  static Future image2Base64(String path) async {
    final file = File(path);
    final List<int> imageBytes = await file.readAsBytes();
    return convert.base64Encode(imageBytes);
  }

  static Future imageFile2Base64(File file) async {
    final List<int> imageBytes = await file.readAsBytes();
    return convert.base64Encode(imageBytes);
  }

  static Image base642Image(String base64Txt) {
    final decodeTxt = convert.base64.decode(base64Txt);
    return Image.memory(
      decodeTxt,
      // width: 100,
      fit: BoxFit.cover,
      // gaplessPlayback: true, // prevent redrawing
    );
  }

  static bool isJsonSting(String s) {
    if (!s.contains('{')) {
      return false;
    }
    try {
      json.decode(s) as Map<String, dynamic>;
      return true;
    } on FormatException {
      return false;
    }
  }

  static logApp(String v, {bool trim = false}) {
    const splitPattern = '|||';
    if (kDebugMode) {
      try {
        if (v.contains(splitPattern)) {
          final ss = v.split(splitPattern);
          var showLog = '';
          for (final s in ss) {
            var trimString = s;
            //IF String is to large then trim
            if (s.length > 50000) {
              trimString = s.substring(0, 50000);
            }

            //PRETTY PRINT LOG JSON
            if (isJsonSting(trimString)) {
              final prettyJson =
                  prettyJsonString(trimString, isFirst: trimString == ss[0]);
              showLog = '$showLog$prettyJson';
            } else {
              if (trimString == ss[0]) {
                showLog = trimString;
              } else {
                showLog = '$showLog\n$trimString';
              }
            }
          }

          d.log(showLog);

          return;
        }

        var trimString = v;
        //IF String is to large then trim
        if (v.length > 50000) {
          trimString = v.substring(0, 50000);
        }
        if (isJsonSting(trimString)) {
          final prettyJson = prettyJsonString(trimString);
          d.log(prettyJson);
        } else {
          d.log(trimString);
        }
      } catch (e, st) {
        dog.e(e, stackTrace: st);
      }
    }
  }

  static String prettyJsonString(String s, {bool isFirst = false}) {
    final jsonMap = json.decode(s) as Map<String, dynamic>;
    // final newMap = jsonMap;
    // if (trim) {
    //   jsonMap.forEach((key, value) {
    //     if (value.toString().length > 500) {
    //       newMap[key] = '${value.toString().substring(0, 500)}...';
    //     } else {
    //       newMap[key] = value;
    //     }
    //   });
    // }
    const encoder = JsonEncoder.withIndent(' ');
    final prettyString = encoder.convert(jsonMap);
    if (isFirst) {
      return prettyString;
    } else {
      return '\n$prettyString';
    }
  }
}
