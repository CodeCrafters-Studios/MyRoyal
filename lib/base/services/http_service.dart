import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_request_inspector/dio_request_inspector.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/Get.dart' as getx;
import 'package:get/get_core/src/get_main.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/config/app_config.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/data/app_encryption.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/initialization/firebase_messaging_callbacks.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/utils/get_device_info.dart';
import 'package:iroyal/base/utils/network/network_info.dart';
import 'package:iroyal/base/utils/permission/app_permission.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

enum Method { POST, GET, PUT, DELETE, PATCH }

class HttpService extends getx.GetxService {
  HttpService({
    required this.dio,
    required this.inspector,
    required this.appStorage,
    required this.networkInfo,
    required this.appEncrypt,
    required this.connectivity,
    required this.deviceInfo,
    required this.appPermission,
  });

  final Dio dio;
  final DioRequestInspector inspector;
  final AppStorage appStorage;
  final NetworkInfo networkInfo;
  final AppEncrypt appEncrypt;
  final Connectivity connectivity;
  final getx.RxString connectionStatus = ''.obs;
  final DeviceInfo deviceInfo;
  final AppPermission appPermission;

  @override
  void onReady() {
    initInterceptors();
    _initConnectionStatus();
    super.onReady();
  }

  void initInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (requestOptions, handler) {
          return handler.next(requestOptions);
        },
        onResponse: (response, handler) {
          if (response.requestOptions.responseType != ResponseType.bytes) {
            AppUtils.logApp(
              '[${response.statusCode}] ${response.realUri}|||${response.data}',
            );
          } else {
            AppUtils.logApp(
              '[${response.statusCode}] ${response.realUri}|||<FILE DOWNLOAD>',
            );
          }

          return handler.next(response);
        },
        onError: (err, handler) {
          AppUtils.logApp('Error Status Code[${err.response?.statusCode}]');
          errorSystem = err.response?.data['message'] ?? '';
          AppUtils.logApp("ERROR MESSAGE :::: $errorSystem");
          return handler.next(err);
        },
      ),
    );

    connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    final isTest = Platform.environment.containsKey('FLUTTER_TEST');
    if (!isTest) {
      dio.interceptors.add(inspector.getDioRequestInterceptor());
    }
  }

  Future<void> _initConnectionStatus() async {
    final result = await connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none)) {
      connectionStatus.value = "No connection";
      AppUtils.logApp(connectionStatus.value);
    } else {
      connectionStatus.value = "Connected";
    }
  }

  Future<dynamic> request({
    String url = '',
    String endpoint = '',
    Method method = Method.POST,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    FormData? paramsImg,
    bool withToken = false,
    bool showPopUp = false,
  }) async {
    if (!await networkInfo.isConnected) {
      catchError('No Internet Connection!', showPopUp: showPopUp);
      return {'code': 0, 'message': 'No Internet Connection!'};
    }

    Response response;
    final newUrl = url.isEmpty ? AppConfig.environment.baseUrl + endpoint : url;

    if (headers == null) {
      final defaultHeader = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      dio.options.headers = defaultHeader;

      if (withToken) {
        final token = await appStorage.read(CACHE_ACCESS_TOKEN);
        dio.options.headers = {
          'Authorization': 'Bearer $token',
          ...defaultHeader,
        };
      }
    } else {
      dio.options.headers = headers;
    }

    final isTest = Platform.environment.containsKey('FLUTTER_TEST');
    if (!isTest) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient(context: SecurityContext());
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        },
      );
    }

    try {
      AppUtils.logApp(
          '${jsonEncode(dio.options.headers)}|||${jsonEncode(params)}');
      AppUtils.logApp(newUrl);
    } catch (e) {
      AppUtils.logApp('ERROR ENCODE $e');
    }

    try {
      if (method == Method.POST) {
        response = await dio.post(newUrl, data: paramsImg ?? params);
      } else if (method == Method.DELETE) {
        response = await dio.delete(newUrl);
      } else if (method == Method.PATCH) {
        response = await dio.patch(newUrl, data: params);
      } else if (method == Method.PUT) {
        response = await dio.put(newUrl, data: params);
      } else {
        response = await dio.get(newUrl, queryParameters: params);
      }

      final code = response.statusCode ?? 0;
      final message = _extractServerMessage(response.data);

      if (code == 200) {
        return response.data;
      } else if (code == 401) {
        catchError(message, showPopUp: showPopUp);
      }

      catchError(message, showPopUp: showPopUp);

      return {'code': code, 'message': message};
    } on SocketException catch (e) {
      AppUtils.logApp(e.toString());
      catchError('No Internet Connection', showPopUp: showPopUp);
      return {'code': 0, 'message': 'No Internet Connection'};
    } on FormatException catch (e) {
      AppUtils.logApp(e.toString());
      catchError('Bad response format', showPopUp: showPopUp);
      return {'code': 0, 'message': 'Bad response format'};
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      final message = _extractServerMessage(e.response?.data);

      AppUtils.logApp('Dio exc code: $code, Error message:$message');
      catchError(message, showPopUp: showPopUp);

      return {'code': code, 'message': message};
    } catch (e, s) {
      AppUtils.logApp('Unknown exc $e\n$s');
      catchError(e.toString(), showPopUp: showPopUp);
      return {'code': 0, 'message': e.toString()};
    }
  }

  Future<dynamic> customRequest({
    String url = baseUrlRoyalWiki,
    String endpoint = '',
    Method method = Method.POST,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    FormData? paramsImg,
    bool withToken = false,
    bool showPopUp = false,
  }) async {
    if (!await networkInfo.isConnected) {
      catchError('No Internet Connection!', showPopUp: showPopUp);
      return;
    }

    Response response;
    final newUrl = url + endpoint;

    if (headers == null) {
      final defaultHeader = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };
      dio.options.headers = defaultHeader;
      if (withToken) {
        dio.options.headers = {
          'Authorization': 'Token $tokenID:$tokenSecret',
          ...defaultHeader,
        };
      }
    } else {
      dio.options.headers = headers;
    }

    final isTest = Platform.environment.containsKey('FLUTTER_TEST');
    if (!isTest) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient(context: SecurityContext());
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        },
      );
      try {
        AppUtils.logApp(
          '${jsonEncode(dio.options.headers)}|||${jsonEncode(params)}',
        );
        AppUtils.logApp(
          newUrl,
        );
      } catch (e) {
        AppUtils.logApp('ERROR ENCODE $e');
      }
    }

    try {
      if (method == Method.POST) {
        response = await dio.post(
          newUrl,
          data: paramsImg ?? params,
        );
      } else if (method == Method.DELETE) {
        response = await dio.delete(newUrl);
      } else if (method == Method.PATCH) {
        response = await dio.patch(newUrl, data: params);
      } else if (method == Method.PUT) {
        response = await dio.put(newUrl, data: params);
      } else {
        response = await dio.get(
          newUrl,
          queryParameters: params,
        );
      }

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 401) {
        final message = _extractServerMessage(response.data);
        catchError(message, showPopUp: showPopUp);
      } else if (response.statusCode == 422) {
        catchError('Error System', showPopUp: showPopUp);
      } else if (response.statusCode == 500) {
        catchError('Internal Server Error', showPopUp: showPopUp);
      } else {
        catchError("Something went wrong", showPopUp: showPopUp);
      }
    } on SocketException catch (e) {
      AppUtils.logApp(e.toString());
      catchError('No Internet Connection', showPopUp: showPopUp);
    } on FormatException catch (e) {
      AppUtils.logApp(e.toString());
      catchError('Bad response format', showPopUp: showPopUp);
    } on DioException catch (e) {
      AppUtils.logApp('Dio exc $e ${e.message}');
      if (e.type == DioExceptionType.unknown) {
        catchError(errorSystem, showPopUp: showPopUp);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        catchError('Request timeout', showPopUp: showPopUp);
      } else if (e.error is SocketException) {
        catchError(e.error.toString(), showPopUp: showPopUp);
      } else if (e.response?.statusCode == 400) {
        AppUtils.logApp('LOGIN ERROR HERE');
        catchError(errorLogin, showPopUp: showPopUp);
      } else {
        AppUtils.logApp('ANY ERROR HERE');
        catchError(errorSystem, showPopUp: showPopUp);
      }
    } catch (e) {
      AppUtils.logApp('unknown exc $e');
      catchError(errorSystem, showPopUp: showPopUp);
    }
  }

  bool canCreateFile(String filePath) {
    try {
      final file = File(filePath);
      final raf = file.openSync(mode: FileMode.writeOnlyAppend);
      raf.closeSync();
      file.deleteSync();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<dynamic> downloadFilePost({
    required String endpoint,
    required Map<String, dynamic> body,
    required String fileName,
  }) async {
    try {
      final fullUrl = AppConfig.environment.baseUrl + endpoint;
      final token = await appStorage.read(CACHE_ACCESS_TOKEN);

      final dioDownload = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          followRedirects: false,
        ),
      );

      dioDownload.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

      final response = await dioDownload.post(
        fullUrl,
        data: body,
      );

      AppUtils.logApp("STATUS CODE: ${response.statusCode}");

      if (response.statusCode == 200) {
        final bytes = response.data as List<int>;
        final savedPath =
            await saveToPublicDownload(bytes: bytes, fileName: fileName);
        await showDownloadNotification(fileName, savedPath);
        return savedPath;
      }

      final responseBytes = response.data as List<int>;
      final responseString = utf8.decode(responseBytes);

      Map<String, dynamic>? errorJson;

      try {
        errorJson = jsonDecode(responseString);
      } catch (_) {}

      throw ApiException(
        errorJson?["message"] ?? "Terjadi kesalahan (${response.statusCode})",
      );
    } on ApiException catch (e) {
      AppUtils.logApp("CATCH ERR ::: ${e.message}");
      catchError(e.message.toString(), showPopUp: true);
      rethrow;
    } catch (e) {
      AppUtils.logApp("Download error: $e");
      throw ApiException(e.toString());
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
      'Download selesai',
      '$fileName telah disimpan.',
      platformChannelSpecifics,
      payload: filePath,
    );
  }

  void catchError(String message, {bool showPopUp = true}) {
    if (showPopUp) {
      if (message.isNotEmpty) {
        if (message == "Unauthenticated.") {
          AppDialogImpl().showErrorDialog(
            description: message,
            textButton: 'Back to Login',
            onPress: () async {
              await appStorage.delete(CACHE_ACCESS_TOKEN);
              await appStorage.delete(CACHE_REFRESH_TOKEN);
              Get.offAllNamed(Routes.LOGIN);
            },
          );
        } else {
          AppUtils.logApp('ERR HERE');
          AppDialogImpl().showErrorDialog(
            description: message,
            textButton: 'Close',
          );
        }
      } else {
        AppDialogImpl().showErrorDialog(title: 'Failed', description: message);
      }
    }
  }

  String _extractServerMessage(dynamic data) {
    if (data == null) return 'Unknown error';
    if (data is String) return data;
    if (data is Map<String, dynamic>) {
      if (data['message'] != null) return data['message'].toString();
      if (data['error'] != null) return data['error'].toString();
      if (data['msg'] != null) return data['msg'].toString();
    }
    return 'Unknown error';
  }

  String errorLogin = "Incorrect username or password. Please try again.";
  String errorSystem = "Error System";
}
