import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CustomInterceptor extends Interceptor {
  String url;

  CustomInterceptor(this.url);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.baseUrl = url;
    options.connectTimeout = const Duration(seconds: 60);
    options.receiveTimeout = const Duration(minutes: 2);
    options.followRedirects = false;

    options.validateStatus = (status) {
      return status! < 500;
    };
    try {
      // LocalStore? localStore = LocalStore();
      // String? token;
      // if (localStore.get('token')!= null) {
      //   options.headers['Authorization'] = 'Bearer ${localStore.get('token')!}';
      // }
      // if (localStore.get('refreshToken')!= null) {
      //   options.headers['refreshToken'] = localStore.get('refreshToken')!;
      // }
    } catch (e) {
      debugPrint(e.toString());
    }

    handler.next(options);
  }
}
