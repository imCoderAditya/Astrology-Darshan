// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unnecessary_new, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:io';

import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart' show IOHttpClientAdapter;

import 'package:flutter/material.dart';

import 'CustomInterceptor.dart';
import 'app_exceptions.dart';

class BaseClient {
  static late String baseUrl;
  static Dio dio = Dio();

  // Initialize with base URL and load the auth token from storage
  // static Future<void> initialize(String url) async {
  //   baseUrl = url;
  //   dio = Dio();
  //   dio.interceptors.add(CustomInterceptor(url));
  // }

   // Initialize with base URL and load the auth token from storage
  static Future<void> initialize(String url, {bool allowBadCert = false}) async {
    baseUrl = url;

    // Add your custom interceptor
    dio.interceptors.add(CustomInterceptor(baseUrl));

    // ✅ Allow self-signed / invalid SSL certificates in dev mode
    if (allowBadCert) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
          () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
  }
  

  // GET request
  static Future<Response<dynamic>?> get({
    String? api,
    Map<String, dynamic>? queryParams,
    FormData? formData,
    Map<String, dynamic>? payloadObj,
  }) async {
    try {
      var response = await dio.get(
        api ?? "",
        data: payloadObj ?? formData ?? {}, // Use either payloadObj or formData
        queryParameters: queryParams ?? {},
      );
      final requestLog = {
        "method": "GET",
        "url": "${dio.options.baseUrl}${api ?? ""}",
        "headers": dio.options.headers,
        "queryParams": queryParams ?? {},
        "data": payloadObj ?? formData ?? {},
      };
      logApiRequestResponse(
        method: "GET",
        url: api ?? '',
        query: queryParams,
        body: payloadObj ?? formData ?? {},
        statusCode: response.statusCode,
        response: response.data,
      );
      debugPrint("📦 Dio Request Log: ${json.encode(requestLog)}");
      return response;
    } on DioException catch (e) {
      if (e.type == DioException.connectionTimeout) {
        throw ApiNotRespondingException("Connection Timeout");
      } else if (e.type == DioException.receiveTimeout) {
        throw ApiNotRespondingException("Connection Timeout");
      } else if (e.type == DioException.connectionError) {
        throw ApiNotRespondingException("No Internet Connection");
      } else if (e.response != null) {
        debugPrint(e.response!.data);
        debugPrint(e.response!.headers.toString());
      } else {
        debugPrint(e.requestOptions.headers.toString());
        debugPrint(e.toString());
      }
    } catch (e) {
      throw ApiNotRespondingException(e.toString());
    }
    return null;
  }

  static Future<Response<dynamic>?> getById({String? api, String? id}) async {
    try {
      var response = await dio.get(
        api ?? "",
        options: Options(headers: {"x-business-id": id ?? ""}),
      );
      logApiRequestResponse(
        method: "GET",
        url: api ?? '',
        statusCode: response.statusCode,
        response: response.data,
      );
      return response;
    } on DioException catch (e) {
      if (e.type == DioException.connectionTimeout) {
        throw ApiNotRespondingException("Connection Timeout");
      } else if (e.type == DioException.receiveTimeout) {
        throw ApiNotRespondingException("Connection Timeout");
      } else if (e.type == DioException.connectionError) {
        throw ApiNotRespondingException("No Internet Connection");
      } else if (e.response != null) {
        debugPrint(e.response!.data);
        debugPrint(e.response!.headers.toString());
      } else {
        debugPrint(e.requestOptions.headers.toString());
        debugPrint(e.toString());
      }
    } catch (e) {
      throw ApiNotRespondingException(e.toString());
    }
    return null;
  }

  // POST request
  static Future<dynamic> post({
    String? api,
    Object? data,
    Map<String, dynamic>? payloadObj,
    FormData? formData,
    Map<String, dynamic>? queryParams,
  }) async {
    // Make the request
    try {
      var response = await dio.post(
        api ?? "",
        data: payloadObj ?? formData ?? data ?? {},
        // Use either payloadObj or formData
        queryParameters: queryParams ?? {}, // Add query parameters if provided
      );
      logApiRequestResponse(
        method: "POST",
        url: api ?? '',
        query: queryParams,
        body: payloadObj ?? formData ?? data ?? {},
        statusCode: response.statusCode,
        response: response.data,
      );
      // debugPrint("Post statusCode ======>${response.statusCode}");
      // debugPrint("Post statusCode ======>${response.data}");
      return response;
    } on DioException catch (e) {
      if (e.type == DioException.connectionTimeout) {
        ApiNotRespondingException("Connection Timeout");
      } else if (e.type == DioException.receiveTimeout) {
        ApiNotRespondingException("Connection Timeout");
      } else if (e.type == DioException.connectionError) {
        ApiNotRespondingException("No Internet Connection");
      } else if (e.response != null) {
        debugPrint(e.response!.data);
        debugPrint(e.response!.headers.toString());
      } else {
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
      }
    }
  }

  // PUT request
  static Future<dynamic> put({
    String? api,
    dynamic payloadObj,
    FormData? formData,
    Map<String, dynamic>? queryParams,
  }) async {
    var uri = baseUrl + (api ?? "");
    debugPrint("PUT Url============> $uri");
    try {
      var response = await dio.put(
        uri,
        data: payloadObj ?? formData ?? {}, // Use either payloadObj or formData
        queryParameters: queryParams ?? {}, // Add query parameters if provided
      );
      logApiRequestResponse(
        method: "PUT",
        url: api ?? '',
        query: queryParams,
        body: payloadObj ?? formData ?? {},
        statusCode: response.statusCode,
        response: response.data,
      );
      return response;
    } on DioException catch (e) {
      if (e.type == DioException.connectionTimeout) {
        ApiNotRespondingException("Connection Timeout");
      } else if (e.type == DioException.receiveTimeout) {
        ApiNotRespondingException("Connection Timeout");
      } else if (e.type == DioException.connectionError) {
        ApiNotRespondingException("No Internet Connection");
      } else if (e.response != null) {
        debugPrint(e.response!.data);
        debugPrint(e.response!.headers.toString());
      } else {
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
      }
    }
    return null;
  }

  // DELETE request
  static Future<dynamic> delete({
    String? api,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      var response = await dio.delete(api ?? "", queryParameters: queryParams);

      logApiRequestResponse(
        method: "DELETE",
        url: api ?? '',
        query: queryParams,
        statusCode: response.statusCode,
        response: response.data,
      );
      return response;
    } on DioException catch (e) {
      if (e.type == DioException.connectionTimeout) {
        ApiNotRespondingException("Connection Timeout");
      } else if (e.type == DioException.receiveTimeout) {
        ApiNotRespondingException("Connection Timeout");
      } else if (e.type == DioException.connectionError) {
        ApiNotRespondingException("No Internet Connection");
      } else if (e.response != null) {
        debugPrint(e.response!.data);
        debugPrint(e.response!.headers.toString());
      } else {
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
      }
    }
    return null;
  }

  static Future<bool> isAuthenticated() async {
    final isLongin = LocalStorageService.isLoggedIn();
    debugPrint("=========>$isLongin");
    if (isLongin) {
      return true;
    }
    return false;
  }

  /// 🔍 API Request/Response Logger
  static void logApiRequestResponse({
    required String method,
    required String url,
    Map<String, dynamic>? query,
    dynamic body,
    int? statusCode,
    dynamic response,
    bool isError = false,
  }) {
    final log =
        '$method $url'
        ' | Query: ${query ?? {}}'
        ' | Body: ${body is FormData ? body.fields : body}'
        '${statusCode != null ? ' | Status: $statusCode\n' : ''}'
        '${response != null ? ' | Response: $response\n' : ''}';

    isError
        ? LoggerUtils.error(log, tag: "BaseClient")
        : LoggerUtils.debug(log, tag: "BaseClient");
  }
}
