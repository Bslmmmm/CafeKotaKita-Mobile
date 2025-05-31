// lib/services/api_service.dart (melanjutkan yang terpotong)
import 'dart:convert';
import 'dart:io';
import 'package:KafeKotaKita/service/api_config.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, String>? additionalHeaders}) async {
    try {
      final headers = <String, String>{
        ...ApiConfig.headers,
        if (additionalHeaders != null) ...additionalHeaders,
      };

      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: headers,
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final headers = <String, String>{
        ...ApiConfig.headers,
        if (additionalHeaders != null) ...additionalHeaders,
      };

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: headers,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final data = json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw ApiException(
        message: data['message'] ?? 'Unknown error occurred',
        statusCode: response.statusCode,
        data: data,
      );
    }
  }

  Exception _handleError(dynamic error) {
    if (error is SocketException) {
      return const ApiException(
        message: 'No internet connection',
        statusCode: 0,
      );
    } else if (error is HttpException) {
      return ApiException(
        message: error.message,
        statusCode: 0,
      );
    } else if (error is FormatException) {
      return const ApiException(
        message: 'Invalid response format',
        statusCode: 0,
      );
    } else {
      return ApiException(
        message: error.toString(),
        statusCode: 0,
      );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? data;

  const ApiException({
    required this.message,
    required this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
