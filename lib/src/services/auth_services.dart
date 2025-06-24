import 'dart:async';
import 'package:dio/dio.dart';
import 'package:echo/src/core/utils/constants/api_constants.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    _initDio();
  }

  late final Dio _dio;
  final String _baseUrl = ApiRoutes.auth; // Replace with your actual API URL

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            print('Request: ${options.method} ${options.uri}');
            print('Headers: ${options.headers}');
            print('Data: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('Response: ${response.statusCode} ${response.data}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            print('Error: ${e.response?.statusCode} ${e.response?.data}');
          }
          return handler.next(e);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  // Login - Request OTP
  Future<String> sendOtp(String email) async {
    try {
      final response = await _dio.post<String>(
        '/login',
        data: {'email': email},
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
        }
        else {
          throw Exception(
            e.response?.data.toString() ?? 'Unexpected error',
          );
        }
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Verify OTP
  Future<String> verifyOtp(String email, String otp) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/verify',
        data: {'email': email, 'otp': otp},
      );
      final token = response.data?['token'] as String?;
      if (token != null) {
        return token;
      } else {
        throw Exception('Token not found in response');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['detail']?.toString() ?? 'Invalid OTP',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
