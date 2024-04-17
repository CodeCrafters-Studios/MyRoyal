// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:alice/alice.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get/get.dart' as getx;
import 'package:iroyal/base/config/app_config.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/data/app_encryption.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/network/network_info.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';
import 'package:iroyal/base/widgets/show_dialog.dart';

enum Method { POST, GET, PUT, DELETE, PATCH }

class HttpService extends getx.GetxService {
  HttpService({
    required this.alice,
    required this.dio,
    required this.appStorage,
    required this.networkInfo,
    required this.appEncrypt,
  });

  final Alice alice;
  final Dio dio;
  final AppStorage appStorage;
  final NetworkInfo networkInfo;
  final AppEncrypt appEncrypt;

  @override
  void onReady() {
    initInterceptors();
    super.onReady();
  }

  void initInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (requestOptions, handler) {
          // try {
          //   AppUtils.logApp(
          //     '[${requestOptions.method}] ${requestOptions.path}|||${jsonEncode(requestOptions.headers)}|||${jsonEncode(requestOptions.data)}',
          //   );
          // } catch (e) {
          //   //
          // }

          return handler.next(requestOptions);
        },
        onResponse: (response, handler) {
          AppUtils.logApp(
            '[${response.statusCode}] ${response.realUri}|||${jsonEncode(response.data)}',
          );
          return handler.next(response);
        },
        onError: (err, handler) {
          AppUtils.logApp('Error[${err.response?.statusCode}]');
          return handler.next(err);
        },
      ),
    );
    final isTest = Platform.environment.containsKey('FLUTTER_TEST');
    if (!isTest) {
      dio.interceptors.add(alice.getDioInterceptor());
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
    // bool isEncrypted = true,
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
          'Authorization': 'bearer $token',
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
          // Don't trust any certificate just because their root cert is trusted.
          final client = HttpClient(context: SecurityContext());
          // You can test the intermediate / root cert here. We just ignore it.
          // ignore: cascade_invocations
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
      if (method == Method.POST) {
        response = await dio.post(
          newUrl,
          data: params,
        );
      } else if (method == Method.DELETE) {
        response = await dio.delete(newUrl);
      } else if (method == Method.PATCH) {
        response = await dio.patch(newUrl);
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
      } else if (response.statusCode == 500) {
        catchError('Internal Server Error', showPopUp: showPopUp);
      } else {
        catchError("Something does wen't wrong", showPopUp: showPopUp);
      }
    } on SocketException catch (e) {
      AppUtils.logApp(e.toString());
      catchError('Not Internet Connection', showPopUp: showPopUp);
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
        catchError('No Internet Connection!', showPopUp: showPopUp);
      } else {
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

  static String errorSystem = "We'll be back soon";
}
