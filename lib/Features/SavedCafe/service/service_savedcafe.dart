// lib/Features/SavedCafe/service/saved_cafe_service.dart
import 'package:get_storage/get_storage.dart';
import 'package:KafeKotaKita/Constant/constants.dart';
import 'package:KafeKotaKita/Features/SavedCafe/repository/saved_cafe_repository.dart';
import 'package:KafeKotaKita/Features/SavedCafe/model/model_saved_cafe.dart';
import 'package:KafeKotaKita/Features/SavedCafe/Utils/saved_cafe_utils.dart';
import 'dart:convert';

class SavedCafeService {
  final SavedCafeRepository _repository;
  static const String _tag = 'SavedCafeService';

  SavedCafeService({SavedCafeRepository? repository})
      : _repository = repository ?? SavedCafeRepository();

  Future<List<SavedCafeItem>> loadSavedCafes() async {
    try {
      // Get user ID from storage
      final userId = await _getUserId();
      // print('$_tag: Loading saved cafes for user: $userId');
      
      // Fetch from repository
      final savedCafes = await _repository.fetchSavedCafes(userId);
      
      // print('$_tag: Successfully loaded ${savedCafes.length} saved cafes');
      return savedCafes;
    } catch (e) {
      // print('$_tag: Error loading saved cafes: $e');
      rethrow;
    }
  }

  Future<String> _getUserId() async {
    try {
      final profileRaw = GetStorage().read(profileKey);
      // print('$_tag: Raw profile from storage: $profileRaw');

      if (profileRaw == null) {
        throw Exception('Profile not found in storage');
      }

      final profile = SavedCafeUtils.parseProfile(profileRaw);
      final userId = profile['id']?.toString();
      
      if (userId == null || userId.isEmpty) {
        throw Exception('User ID not found in profile');
      }
      
      return userId;
    } catch (e) {
      // print('$_tag: Error getting user ID: $e');
      throw Exception('Failed to get user ID: $e');
    }
  }
}