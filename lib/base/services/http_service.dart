// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:alice/alice.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/config/app_config.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/data/app_encryption.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/network/network_info.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/show_dialog.dart';

enum Method { POST, GET, PUT, DELETE, PATCH }

class HttpService extends getx.GetxService {
  HttpService({
    required this.alice,
    required this.dio,
    required this.appStorage,
    required this.networkInfo,
    required this.appEncrypt,
    required this.connectivity,
  });

  final Alice alice;
  final Dio dio;
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
          return handler.next(err);
        },
      ),
    );

    connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    final isTest = Platform.environment.containsKey('FLUTTER_TEST');
    if (!isTest) {
      dio.interceptors.add(alice.getDioInterceptor());
    }
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
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
    String enpoint = '',
    Method method = Method.POST,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    bool withToken = false,
    bool showPopUp = false,
  }) async {
    if (!await networkInfo.isConnected) {
      catchError('No Internet Connection!', showPopUp: showPopUp);
      return;
    }

    Response response;
    final newUrl = url.isEmpty ? AppConfig.environment.baseUrl + enpoint : url;

    ///SET Default Headers
    if (headers == null) {
      final defaultHeader = {'Content-Type': 'application/json'};
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
        //
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
          data: params,
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
        alice.addLog(AliceLog(message: jsonEncode(params)));
        return response.data;
      } else if (response.statusCode == 401) {
        catchError('Unauthorized', showPopUp: showPopUp);
        Routes.LOGIN;
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

  static void catchError(String message, {bool showPopUp = true}) {
    if (showPopUp) {
      if (message == "We'll be back soon") {
        showPopUpFailed(
          title: 'System is Under Maintenance',
          description: message,
        );
      } else {
        showPopUpFailed(title: 'Failed', description: message);
      }
    }
    throw ApiException(message);
  }

  static String errorLogin =
      "Incorrect username or password. Please try again.";
  static String errorSystem = "We'll be back soon";
}
