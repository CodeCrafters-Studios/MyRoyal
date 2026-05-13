import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:MyRoyal/app/routes/app_pages.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_request_inspector/dio_request_inspector.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/Get.dart' as getx;
import 'package:MyRoyal/base/config/app_config.dart';
import 'package:MyRoyal/base/config/app_constants.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/initialization/firebase_messaging_callbacks.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/utils/get_device_info.dart';
import 'package:MyRoyal/base/utils/network/network_info.dart';
import 'package:MyRoyal/base/utils/storage/app_storage.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

enum Method { POST, GET, PUT, DELETE, PATCH }

enum RequestType {
  json,
  download,
  multipart,
}

class HttpService extends getx.GetxService {
  final Dio dio;
  final DioRequestInspector inspector;
  final AppStorage appStorage;
  final DeviceInfo deviceInfo;
  final NetworkInfo networkInfo;
  final Connectivity connectivity;
  final getx.RxString connectionStatus = ''.obs;

  HttpService({
    required this.dio,
    required this.inspector,
    required this.appStorage,
    required this.deviceInfo,
    required this.networkInfo,
    required this.connectivity,
  });

  @override
  void onReady() {
    _initInterceptors();
    _initConnectionStatus();
    super.onReady();
  }

  void _initInterceptors() {
    dio.interceptors.add(inspector.getDioRequestInterceptor());

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.data is FormData) {
            final formData = options.data as FormData;

            AppUtils.logApp("📤 MULTIPART REQUEST:");
            for (var field in formData.fields) {
              AppUtils.logApp("Field: ${field.key} = ${field.value}");
            }
            for (var file in formData.files) {
              AppUtils.logApp("File: ${file.key} = ${file.value.filename}");
            }
          } else {
            AppUtils.logApp("📤 BODY: ${options.data}");
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          AppUtils.logApp(
            "✅ ${response.statusCode} ${response.requestOptions.uri}",
          );
          handler.next(response);
        },
        onError: (e, handler) {
          AppUtils.logApp("❌ ERROR ${e.response?.statusCode} ${e.message}");
          handler.next(e);
        },
      ),
    );
  }

  Future<void> _initConnectionStatus() async {
    final result = await connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none)) {
      connectionStatus.value = "Tidak ada koneksi";
      AppUtils.logApp(connectionStatus.value);
    } else {
      connectionStatus.value = "Terhubung";
    }
  }

  Future<dynamic> _execute({
    required String endpoint,
    Method method = Method.POST,
    dynamic params,
    bool withToken = false,
    bool showPopUp = true,
    RequestType type = RequestType.json,
    String? fileName,
  }) async {
    final url = AppConfig.environment.baseUrl + endpoint;
    final cacheKey =
        "CACHE_$url${(params != null && params is! FormData) ? jsonEncode(params) : ''}";

    if (!await networkInfo.isConnected) {
      if (method == Method.GET) {
        final cachedData = await appStorage.read(cacheKey);
        if (cachedData != null) {
          AppUtils.logApp("📦 RETURNING CACHED DATA FOR: $url");
          return jsonDecode(cachedData);
        }
      }
      throw ApiException('No Internet Connection');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (withToken) {
      final token = await appStorage.read(CACHE_ACCESS_TOKEN);
      headers['Authorization'] = 'Bearer $token';
    }

    try {
      final isMultipart = type == RequestType.multipart;

      final options = Options(
        headers: headers,
        responseType: type == RequestType.download
            ? ResponseType.bytes
            : ResponseType.json,
        contentType: isMultipart ? 'multipart/form-data' : 'application/json',
      );

      Response response;

      switch (method) {
        case Method.GET:
          response =
              await dio.get(url, queryParameters: params, options: options);
          break;
        case Method.POST:
          response = await dio.post(url, data: params, options: options);
          break;
        case Method.PUT:
          response = await dio.put(url, data: params, options: options);
          break;
        case Method.DELETE:
          response = await dio.delete(url, options: options);
          break;
        case Method.PATCH:
          response = await dio.patch(url, data: params, options: options);
          break;
      }

      if (type == RequestType.download) {
        return await _handleDownload(response, fileName ?? "file.pdf");
      }

      final code = response.statusCode ?? 0;
      final message = _extractMessage(response.data);

      if (code == 200) {
        if (method == Method.GET) {
          await appStorage.write(cacheKey, jsonEncode(response.data));
        }
        return response.data;
      }

      _handleError(message, showPopUp, code);
      throw ApiException(message);
    } on DioException catch (e) {
      final message = _extractMessage(e.response?.data);
      _handleError(message, showPopUp, e.response?.statusCode);
      throw ApiException(message);
    } catch (e) {
      final message = e.toString();

      _handleError(message, showPopUp, null);

      throw ApiException(e.toString());
    }
  }

  Future<dynamic> request({
    required String endpoint,
    Method method = Method.POST,
    Map<String, dynamic>? params,
    bool withToken = false,
  }) {
    return _execute(
      endpoint: endpoint,
      method: method,
      params: params,
      withToken: withToken,
      type: RequestType.json,
    );
  }

  Future<String> download({
    required String endpoint,
    required Map<String, dynamic> body,
    required String fileName,
    bool withToken = true,
  }) async {
    final result = await _execute(
      endpoint: endpoint,
      method: Method.POST,
      params: body,
      withToken: withToken,
      type: RequestType.download,
      fileName: fileName,
    );

    return result as String;
  }

  Future<dynamic> multipart({
    required String endpoint,
    required FormData formData,
    bool withToken = true,
  }) {
    return _execute(
      endpoint: endpoint,
      method: Method.POST,
      params: formData,
      withToken: withToken,
      type: RequestType.multipart,
    );
  }

  Future<String> _handleDownload(Response response, String fileName) async {
    if (response.statusCode == 200) {
      final bytes = response.data as List<int>;

      final path = await saveToPublicDownload(
        bytes: bytes,
        fileName: fileName,
      );

      await showDownloadNotification(fileName, path);

      return path;
    }

    final bytes = response.data as List<int>;
    final text = utf8.decode(bytes);

    try {
      final json = jsonDecode(text);
      throw ApiException(json["message"]);
    } catch (_) {
      throw ApiException("Download failed (${response.statusCode})");
    }
  }

  Future<String> saveToPublicDownload({
    required List<int> bytes,
    required String fileName,
  }) async {
    String sanitizedName =
        fileName.replaceAll(RegExp(r'[^\w\s\-]'), '').replaceAll(' ', '_');

    String finalName = sanitizedName.toLowerCase().endsWith(".pdf")
        ? sanitizedName
        : "$sanitizedName.pdf";

    final androidInfo = await deviceInfo.deviceInfoPlugin.androidInfo;
    int sdkInt = androidInfo.version.sdkInt;

    AppUtils.logApp("Saving file: $finalName | SDK: $sdkInt");

    // Request permission for SDK 32 and below (Android 12 and older)
    if (sdkInt <= 32) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (status.isPermanentlyDenied) {
          final openSettings = await AppDialogImpl().showChoiceDialog(
            title: 'Izin Penyimpanan Dibutuhkan',
            description:
                'Mohon aktifkan izin penyimpanan di pengaturan aplikasi untuk dapat mengunduh dan menyimpan file.',
            textYes: 'Buka Pengaturan',
            textNo: 'Batal',
          );
          if (openSettings) {
            await openAppSettings();
          }
        }
      }
    }

    if (sdkInt == 29) {
      Directory? dir = await getExternalStorageDirectory();
      if (dir == null) throw Exception("Cannot access storage");

      final file = File("${dir.path}/$finalName");
      await file.writeAsBytes(bytes);

      return file.path;
    }

    await MediaStore.ensureInitialized();
    MediaStore.appFolder = "MyRoyal";

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = path.join(tempDir.path, finalName);
    File tempFile = await File(tempPath).writeAsBytes(bytes);

    SaveInfo? saveInfo = await MediaStore().saveFile(
      tempFilePath: tempPath,
      dirType: DirType.download,
      dirName: DirName.download,
      relativePath: "Payroll",
    );

    try {
      await tempFile.delete();
    } catch (_) {}

    if (saveInfo == null) {
      throw Exception("Failed to save file to MediaStore.");
    }

    return saveInfo.uri.toString();
  }

  Future<void> showDownloadNotification(
      String fileName, String filePath) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_channel',
      'File Downloads',
      channelDescription: 'Notifies when a file is downloaded',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Unduhan Selesai',
      '$fileName telah disimpan.',
      platformChannelSpecifics,
      payload: filePath,
    );
  }

  String _extractMessage(dynamic data) {
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return 'Unknown error';
  }

  void _handleError(String message, bool showPopUp, int? code) {
    if (!showPopUp) return;

    if (message.isNotEmpty) {
      if (message == "Unauthenticated.") {
        AppDialogImpl().showErrorDialog(
          description: message,
          textButton: 'Kembali ke Halaman Login',
          onPress: () async {
            await appStorage.delete(CACHE_ACCESS_TOKEN);
            await appStorage.delete(CACHE_REFRESH_TOKEN);
            getx.Get.offAllNamed(Routes.LOGIN);
          },
        );
      } else if (code == 451) {
        AppDialogImpl().showErrorDialog(
          title: "User telah dibanned",
          description:
              "Akun Anda telah dinonaktifkan. Silakan hubungi administrator.",
          textButton: "Tutup Aplikasi",
          onPress: () async {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else {
              exit(0);
            }
          },
        );
      } else {
        AppDialogImpl().showErrorDialog(
          description: message,
          textButton: 'Tutup',
        );
      }
    } else {
      AppDialogImpl().showErrorDialog(
        title: 'Failed',
        description: message,
      );
    }
  }
}
