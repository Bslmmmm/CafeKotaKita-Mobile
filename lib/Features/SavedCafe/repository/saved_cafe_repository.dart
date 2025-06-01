// lib/Features/SavedCafe/repository/saved_cafe_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:KafeKotaKita/Features/SavedCafe/model/model_saved_cafe.dart';
import 'package:KafeKotaKita/service/api_config.dart';

class SavedCafeRepository {
  static const String _tag = 'SavedCafeRepository';

  Future<List<SavedCafeItem>> fetchSavedCafes(String userId) async {
    try {
      print('$_tag: Fetching saved cafes for user: $userId');
      final response = await http.get(
        Uri.parse('${ApiConfig.cardsaveendpoint}/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('$_tag: Response status: ${response.statusCode}');
      print('$_tag: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json['data'] ?? [];
        
        return data.map((item) => SavedCafeItem.fromJson(item)).toList();
      } else {
        throw SavedCafeException(
          'Failed to fetch saved cafes: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      print('$_tag: Error fetching saved cafes: $e');
      if (e is SavedCafeException) rethrow;
      throw SavedCafeException('Network error: $e', 0);
    }
  }
}

class SavedCafeException implements Exception {
  final String message;
  final int statusCode;
  
  SavedCafeException(this.message, this.statusCode);
  
  @override
  String toString() => 'SavedCafeException: $message (Status: $statusCode)';
}