// Core/Services/api_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tugas_flutter/Features/Homepage/model/cafe_data.dart';

class ApiService {
  // Base URL for API - replace with your actual API endpoint
  final String baseUrl = 'https://your-cafe-api.com/api';

  // Timeout duration for requests
  final Duration timeout = const Duration(seconds: 30);

  // API endpoints
  static const String _cafesEndpoint = '/cafes';
  static const String _cafeDetailsEndpoint = '/cafes/';

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  // Generic GET request method
  Future<Map<String, dynamic>> _get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('No internet connection');
    } on HttpException {
      throw ApiException('Server error');
    } on FormatException {
      throw ApiException('Invalid response format');
    } on TimeoutException {
      throw ApiException('Request timeout');
    } catch (e) {
      throw ApiException('An unexpected error occurred: $e');
    }
  }

  // Generic POST request method
  Future<Map<String, dynamic>> _post(String endpoint, dynamic data) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('No internet connection');
    } on HttpException {
      throw ApiException('Server error');
    } on FormatException {
      throw ApiException('Invalid response format');
    } on TimeoutException {
      throw ApiException('Request timeout');
    } catch (e) {
      throw ApiException('An unexpected error occurred: $e');
    }
  }

  // Response handler
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Successful response - try to parse JSON
      try {
        return jsonDecode(response.body);
      } catch (e) {
        throw ApiException('Failed to parse response: $e');
      }
    } else {
      // Error response
      switch (response.statusCode) {
        case 401:
          throw ApiException('Unauthorized access');
        case 403:
          throw ApiException('Forbidden resource');
        case 404:
          throw ApiException('Resource not found');
        case 500:
          throw ApiException('Server error');
        default:
          throw ApiException('HTTP error ${response.statusCode}');
      }
    }
  }

  // Get all cafes
  Future<List<CafeData>> getCafes() async {
    try {
      final jsonResponse = await _get(_cafesEndpoint);
      final List<dynamic> cafeList = jsonResponse['data'] ?? [];

      return cafeList.map((cafeJson) => _parseCafeData(cafeJson)).toList();
    } catch (e) {
      throw ApiException('Failed to get cafes: $e');
    }
  }

  // Get single cafe by ID
  Future<CafeData> getCafeById(String id) async {
    try {
      final jsonResponse = await _get('$_cafeDetailsEndpoint$id');
      return _parseCafeData(jsonResponse['data']);
    } catch (e) {
      throw ApiException('Failed to get cafe details: $e');
    }
  }

  // Search cafes by keyword
  Future<List<CafeData>> searchCafes(String keyword) async {
    try {
      final jsonResponse = await _get('$_cafesEndpoint?search=$keyword');
      final List<dynamic> cafeList = jsonResponse['data'] ?? [];

      return cafeList.map((cafeJson) => _parseCafeData(cafeJson)).toList();
    } catch (e) {
      throw ApiException('Failed to search cafes: $e');
    }
  }

  // Get cafes filtered by criteria
  Future<List<CafeData>> getFilteredCafes({
    bool? openOnly,
    bool? topRated,
  }) async {
    try {
      String endpoint = _cafesEndpoint;

      // Add query parameters
      List<String> queryParams = [];
      if (openOnly == true) queryParams.add('open=true');
      if (topRated == true) queryParams.add('sort=rating');

      // Append query parameters to endpoint
      if (queryParams.isNotEmpty) {
        endpoint += '?${queryParams.join('&')}';
      }

      final jsonResponse = await _get(endpoint);
      final List<dynamic> cafeList = jsonResponse['data'] ?? [];

      return cafeList.map((cafeJson) => _parseCafeData(cafeJson)).toList();
    } catch (e) {
      throw ApiException('Failed to get filtered cafes: $e');
    }
  }

  // Submit cafe review
  Future<void> submitCafeReview(
      String cafeId, double rating, String comment) async {
    try {
      await _post('$_cafeDetailsEndpoint$cafeId/reviews', {
        'rating': rating,
        'comment': comment,
      });
    } catch (e) {
      throw ApiException('Failed to submit review: $e');
    }
  }

  // Helper method to parse cafe JSON data into CafeData
  CafeData _parseCafeData(Map<String, dynamic> json) {
    return CafeData(
      id: json['id']?.toString() ?? '',
      imageUrl: json['image_url'] ?? '',
      cafeName: json['name'] ?? '',
      location: json['location'] ?? '',
      operationalHours: json['hours'] ?? '',
      rating: (json['rating'] is num) ? json['rating'].toDouble() : 0.0,
      isOpen: json['is_open'] ?? false,
    );
  }
}

// Custom exception class for API errors
class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
