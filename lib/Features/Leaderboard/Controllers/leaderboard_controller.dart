import 'dart:convert';
import 'package:KafeKotaKita/Features/Leaderboard/Models/cafe_model.dart';
import 'package:http/http.dart' as http;
import '../models/cafe_model.dart';

class LeaderboardController {
  static const String baseUrl =
      'YOUR_LARAVEL_API_URL'; // Ganti dengan URL API Laravel Anda

  List<CafeModel> _weeklyLeaderboard = [];
  bool _isLoading = false;
  String? _error;

  List<CafeModel> get weeklyLeaderboard => _weeklyLeaderboard;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Mengambil data leaderboard mingguan dari API
  Future<List<CafeModel>> fetchWeeklyLeaderboard() async {
    _isLoading = true;
    _error = null;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/leaderboard/weekly'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          final List<dynamic> cafesJson = data['data'];
          _weeklyLeaderboard =
              cafesJson.map((json) => CafeModel.fromJson(json)).toList();

          // Urutkan berdasarkan ranking
          _weeklyLeaderboard
              .sort((a, b) => a.weeklyRank.compareTo(b.weeklyRank));

          _isLoading = false;
          return _weeklyLeaderboard;
        } else {
          throw Exception(data['message'] ?? 'Failed to load leaderboard');
        }
      } else {
        throw Exception(
            'HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      print('Error fetching weekly leaderboard: $e');
      return [];
    }
  }

  /// Refresh data leaderboard
  Future<void> refreshLeaderboard() async {
    await fetchWeeklyLeaderboard();
  }

  /// Mendapatkan cafe berdasarkan ranking
  CafeModel? getCafeByRank(int rank) {
    try {
      return _weeklyLeaderboard.firstWhere((cafe) => cafe.weeklyRank == rank);
    } catch (e) {
      return null;
    }
  }

  /// Mendapatkan top 3 cafe
  List<CafeModel> getTop3Cafes() {
    return _weeklyLeaderboard.take(3).toList();
  }

  /// Mendapatkan semua cafe kecuali top 3
  List<CafeModel> getOtherCafes() {
    return _weeklyLeaderboard.skip(3).toList();
  }

  /// Clear data
  void clearData() {
    _weeklyLeaderboard.clear();
    _error = null;
    _isLoading = false;
  }

  /// Update ranking secara manual (jika diperlukan)
  Future<bool> updateWeeklyRanking() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/leaderboard/update-weekly'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error updating weekly ranking: $e');
      return false;
    }
  }
}
