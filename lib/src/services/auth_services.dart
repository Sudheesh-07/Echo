import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:echo/src/core/utils/constants/api_constants.dart';
import 'package:echo/src/features/authentication/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

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
          return 'Token saved Success';
        }
        return 'Token not saved';
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
      final Response<Map<String, dynamic>> response = await _dio
          .get<Map<String, dynamic>>('/random_username');
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
  Future<UserModel?> getUser() async {
    final accessToken = storage.read('access_token');
    try {
      final Response<Map<String, dynamic>> response = await _dio.get(
        '/get-user',
        options: Options(headers: <String, dynamic>{'Authorization': 'Bearer $accessToken'}),
      );
      if (response.data == null) {
        throw Exception('No user data received');
      }
      return UserModel.fromJson(response.data!);
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

  /// Save/Update user details (username, gender, profile pic)
  Future<UserModel?> saveUser({
    required String username,
    required String gender,
    required XFile profileImage,
  }) async {
    try {
      final accessToken = storage.read('access_token');
      if (accessToken == null) {
        throw Exception("No access token found, please login again.");
      }

      // Prepare form data
      final FormData formData = FormData.fromMap(<String, dynamic>{
        "token": accessToken, // backend expects token in form
        "username": username,
        "gender": gender,
        "profile_image": await MultipartFile.fromFile(
          profileImage.path,
          filename: profileImage.name,
          contentType: MediaType(
            "image",
            profileImage.path.split('.').last.toLowerCase(), // jpeg/png/webp
          ),
        ),
      });

      final Response<Map<String, dynamic>> response = await _dio.put(
        '/save-user',
        data: formData,
        options: Options(headers: <String, dynamic>{"Content-Type": "multipart/form-data"}),
      );
       final data = response.data;
      if (data == null) {
        throw Exception("No response from server.");
      }

      if (response.statusCode == 200 && data.containsKey("message")) {
        if (kDebugMode) {
          log("Save User Success: ${data['message']}");
          log("New Profile Pic: ${data['profile_pic_url']}");
          log("Compression: ${data['compressed_ratio']}");
        }

        // Fetch updated user from backend
        final UserModel? updatedUser = await getUser();
        return updatedUser;
      } else {
        throw Exception(data['detail'] ?? 'Unexpected server response');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          (e.response?.data as Map<String, dynamic>)['detail']?.toString() ??
              'Failed to save user',
        );
      } else {
        throw Exception("Network error: ${e.message}");
      }
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
