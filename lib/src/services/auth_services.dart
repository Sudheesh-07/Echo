import 'dart:async';
import 'package:dio/dio.dart';
import 'package:echo/src/core/utils/constants/api_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

/// This Class is for the services of Authentication Like login signup etc
class AuthService {
  /// Singleton constructor
  factory AuthService() => _instance;
  AuthService._internal() {
    _initDio();
  }
  // Singleton instance
  static final AuthService _instance = AuthService._internal();
  // Dio instance (Dio is a HTTP client which helps us have more control over
  //the HTTP requests)
  late final Dio _dio;

  /// GetStorage instance (GetStorage is a key-value storage for
  /// Flutter it stores data locally)
  GetStorage storage = GetStorage();
  final String _baseUrl = ApiRoutes.auth;

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
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

  /// Login - Request OTP
  Future<String> sendOtp(String email) async {
    try {
      final Response<String> response = await _dio.post<String>(
        '/send-otp',
        data: <String, String>{'email': email},
      );
      if (response.data != null && response.data!.contains('OTP sent')) {
        return 'Otp Sent';
      } else if (response.data != null &&
          response.data!.contains('Too many requests')) {
        return 'Too many requests.';
      } else {
        throw Exception('Unexpected response format');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 429) {
          return 'Error: Too many requests.';
        } else {
          throw Exception(e.response?.data.toString() ?? 'Unexpected error');
        }
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Verify OTP that the user entered
  Future<String> verifyOtp(String email, String otp) async {
    try {
      final Response<Map<String, dynamic>> response = await _dio
          .post<Map<String, dynamic>>(
            '/verify',
            data: <String, String>{'email': email, 'otp': otp},
          );
      if (response.data?['message'] as String == 'OTP verified') {
        final String? accessToken = response.data?['access_token'] as String?;
        final String? refreshToken = response.data?['refresh_token'] as String?;
        if (accessToken != null && refreshToken != null) {
          await storage.write('access_token', accessToken);
          await storage.write('refresh_token', refreshToken);
          //return 'Token saved Success';
        }
        return 'Success';
      } else {
        throw Exception('Invalid OTP');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          (e.response?.data as Map<String, dynamic>)['detail']?.toString() ??
              'Invalid OTP',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<String> getUserName() async {
    try {
      final Response<Map<String, dynamic>> response = await _dio.get<Map<String, dynamic>>('/random_username');
      if (response.data?['username'] != null) {
        return response.data?['username'] as String;
      } else {
        throw Exception('User name not found');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          (e.response?.data as Map<String, dynamic>)['detail']?.toString() ??
              'User name not found',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
