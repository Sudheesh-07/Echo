import 'package:dio/dio.dart';
import 'package:echo/src/core/utils/constants/api_constants.dart';
import 'package:echo/src/features/authentication/models/user_model.dart';
import 'package:echo/src/services/auth_services.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class UserService {
  /// Singleton constructor
  factory UserService() => _instance;
  UserService._internal() {
    _initDio();
  }
  // Singleton instance
  static final UserService _instance = UserService._internal();
  // Dio instance (Dio is a HTTP client which helps us have more control over
  //the HTTP requests)
  late final Dio _dio;

  /// GetStorage instance (GetStorage is a key-value storage for
  /// Flutter it stores data locally)
  GetStorage storage = GetStorage();
  final String _baseUrl = ApiRoutes.auth;
  AuthService _authService = AuthService();
  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: <String, dynamic>{'Accept': 'application/json'},
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          if (kDebugMode) {
            print('Request: ${options.method} ${options.uri}');
            print('Headers: ${options.headers}');
            print('Data: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (
          Response<dynamic> response,
          ResponseInterceptorHandler handler,
        ) {
          if (kDebugMode) {
            print('Response: ${response.statusCode} ${response.data}');
          }
          return handler.next(response);
        },
        onError: (DioException e, ErrorInterceptorHandler handler) {
          if (kDebugMode) {
            print('Error: ${e.response?.statusCode} ${e.response?.data}');
          }
          return handler.next(e);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  
}
