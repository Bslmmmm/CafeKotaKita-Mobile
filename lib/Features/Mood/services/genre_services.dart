import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:KafeKotaKita/Features/Mood/models/genre_model.dart';
import 'package:KafeKotaKita/service/api_config.dart';

class GenreService {
  static Future<GenreResponse> getGenreById(String genreId) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.searchByIdGenreEndpoint(genreId)),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(ApiConfig.timeout);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return GenreResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load genre data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching genre data: $e');
    }
  }

  static Future<List<GenreResponse>> getAllGenres() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.allGenresEndpoint),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<dynamic> genresJson = jsonData['data'];
        return genresJson.map((json) => GenreResponse.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load genres: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching genres: $e');
    }
  }
}