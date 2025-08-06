// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_request_inspector/dio_request_inspector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/config/app_config.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/data/app_encryption.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/initialization/firebase_messaging_callbacks.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/utils/network/network_info.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';
import 'package:iroyal/base/widgets/padding.dart';
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
  });

  final Dio dio;
  final DioRequestInspector inspector;
  final AppStorage appStorage;
  final NetworkInfo networkInfo;
  final AppEncrypt appEncrypt;
  final Connectivity connectivity;
  final getx.RxString connectionStatus = ''.obs;

  @override
  void onReady() {
    initInterceptors();
    super.onReady();
  }

  void initInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (requestOptions, handler) {
          return handler.next(requestOptions);
        },
        onResponse: (response, handler) {
          AppUtils.logApp(
            '[${response.statusCode}] ${response.realUri}|||${jsonEncode(response.data)}',
          );
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

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    if (connectivityResult.isEmpty) {
      connectionStatus.value = "No connection";
      AppUtils.logApp(connectionStatus.value);
      getx.Get.showSnackbar(
        GetSnackBar(
          duration: null,
          title: "No Internet Connection",
          messageText: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Please check your internet connection',
                style: TS.caption.copyWith(color: white),
              ),
              InkWellTap(
                onTap: () {
                  getx.Get.back();
                },
                child: Text(
                  'Dismiss',
                  style: TS.caption.copyWith(color: white),
                ),
              ),
            ],
          ),
          backgroundColor: red,
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED,
          icon: const EPadding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Icon(
              Icons.wifi_off,
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
      );
    } else {
      if (connectionStatus.value == "No connection") {
        connectionStatus.value = "Connected";
        getx.Get.back();
        getx.Get.showSnackbar(
          GetSnackBar(
            duration: const Duration(seconds: 1),
            title: "Connected!",
            messageText: Text(
              'You are connected to the internet',
              style: TS.caption.copyWith(color: white),
            ),
            backgroundColor: green,
            isDismissible: true,
            margin: EdgeInsets.zero,
            snackStyle: SnackStyle.GROUNDED,
            icon: const EPadding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.wifi,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        );
      }
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
      return;
    }

    Response response;
    final newUrl = url.isEmpty ? AppConfig.environment.baseUrl + endpoint : url;

    ///SET Default Headers
    if (headers == null) {
      final defaultHeader = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };
      dio.options.headers = defaultHeader;
      if (withToken) {
        ///SET headers with TOKEN from CACHE [Authorization : bearer]
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

    // --- Encrypt Params ---

    // final encryptedParams =
    //     params != null ? appEncrypt.encryptParams(params) : null;

    // initInterceptors();
    try {
      // var expToken = await appStorage.read(CACHE_EXPIRES_TOKEN);
      // final expiresIn = DateTime.parse(expToken ?? '');
      // final now = DateTime.now();
      // AppTokenImpl appTokenImpl = AppTokenImpl(
      //   appStorage: appStorage,
      //   http: this,
      // );
      // if (expToken != null && now.compareTo(expiresIn) > 0) {
      //   return appTokenImpl.getToken();
      // }

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
        catchError('Unauthorized', showPopUp: showPopUp);
        Get.offAllNamed(Routes.LOGIN);
      } else if (response.statusCode == 422) {
        catchError(response.data, showPopUp: showPopUp);
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

    ///SET Default Headers
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

    // --- Encrypt Params ---

    // final encryptedParams =
    //     params != null ? appEncrypt.encryptParams(params) : null;

    // initInterceptors();
    try {
      // var expToken = await appStorage.read(CACHE_EXPIRES_TOKEN);
      // final expiresIn = DateTime.parse(expToken ?? '');
      // final now = DateTime.now();
      // AppTokenImpl appTokenImpl = AppTokenImpl(
      //   appStorage: appStorage,
      //   http: this,
      // );
      // if (expToken != null && now.compareTo(expiresIn) > 0) {
      //   return appTokenImpl.getToken();
      // }

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
        catchError('Unauthorized', showPopUp: showPopUp);
        Routes.LOGIN;
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

  // Future<bool> _requestStoragePermission() async {
  //   if (Platform.isAndroid) {
  //     final androidInfo = await DeviceInfoPlugin().androidInfo;
  //     final sdkInt = androidInfo.version.sdkInt;

  //     if (sdkInt >= 33) {
  //       final status = await Permission.photos.request();
  //       return status.isGranted;
  //     } else {
  //       final status = await Permission.storage.request();
  //       return status.isGranted;
  //     }
  //   } else {
  //     final status = await Permission.storage.request();
  //     return status.isGranted;
  //   }
  // }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isIOS) {
      return await getDownloadsDirectory();
    } else {
      var directory = "/storage/emulated/0/Download/";

      var dirDownloadExists = await Directory(directory).exists();
      if (dirDownloadExists) {
        directory = "/storage/emulated/0/Download/";
      } else {
        directory = "/storage/emulated/0/Downloads/";
      }
      return Directory(directory);
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

  Future<String> _getUniqueFilePath(
      String directoryPath, String fileName) async {
    int counter = 1;
    String baseName = path.basenameWithoutExtension(fileName);
    String extension = path.extension(fileName);
    String candidate = path.join(directoryPath, fileName);

    while (!canCreateFile(candidate)) {
      candidate = path.join(directoryPath, '$baseName($counter)$extension');
      counter++;
    }

    return candidate;
  }

  Future<dynamic> downloadFilePost({
    required String endpoint,
    required String fileName,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    bool withToken = false,
    Function(int received, int total)? onReceiveProgress,
  }) async {
    if (!await networkInfo.isConnected) {
      catchError('No Internet Connection!');
      return;
    }

    // final hasPermission = await _requestStoragePermission();
    // if (!hasPermission) {
    //   catchError('Storage permission denied');
    //   return;
    // }

    final url = AppConfig.environment.baseUrl + endpoint;

    // Set headers
    final defaultHeader = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (withToken) {
      final token = await appStorage.read(CACHE_ACCESS_TOKEN);
      dio.options.headers = {
        'Authorization': 'Bearer $token',
        ...?headers,
        ...defaultHeader,
      };
    } else {
      dio.options.headers = {
        ...?headers,
        ...defaultHeader,
      };
    }

    try {
      final directory = await _getDownloadDirectory();
      if (directory == null) {
        catchError('Download directory not found');
        return;
      }

      final uniqueFilePath = await _getUniqueFilePath(directory.path, fileName);

      final response = await dio.post<List<int>>(
        url,
        data: params,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500,
        ),
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode == 200 &&
          response.headers.map['content-type']?.first
                  .contains('application/pdf') ==
              true) {
        try {
          final file = File(uniqueFilePath);
          await file.writeAsBytes(response.data!, flush: true);
          AppUtils.logApp('File downloaded to: $uniqueFilePath');
        } catch (e) {
          AppUtils.logApp('Error saving file: $e');
          catchError('Gagal menyimpan file: $e');
        }
      } else {
        final responseString = utf8.decode(response.data!);
        final decoded = jsonDecode(responseString);
        final message = decoded['errors']['message'][0].toString();

        AppUtils.logApp(
            'Download failed. Server returned non-PDF response: $responseString');
        catchError(
          message,
        );
      }

      await showDownloadNotification(fileName, uniqueFilePath);
    } on DioException catch (e) {
      AppUtils.logApp('Download error: $e');
    } catch (e) {
      AppUtils.logApp('Unexpected error: $e');
    }
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
          AppDialogImpl().showErrorDialog(
            description: message,
            textButton: 'Close',
          );
        }
      } else {
        AppDialogImpl().showErrorDialog(title: 'Failed', description: message);
      }
    }
    throw ApiException(message);
  }

  static String errorLogin =
      "Incorrect username or password. Please try again.";
  static String errorSystem = "Error System";
}
