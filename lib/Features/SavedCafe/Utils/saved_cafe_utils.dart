// lib/Features/SavedCafe/utils/saved_cafe_utils.dart
import 'dart:convert';

class SavedCafeUtils {
  static const String _tag = 'SavedCafeUtils';

  /// Parse profile data from storage (handles both String and Map formats)
  static Map<String, dynamic> parseProfile(dynamic profileRaw) {
    try {
      if (profileRaw is String) {
        // print('$_tag: Parsing profile from JSON string');
        return jsonDecode(profileRaw);
      } else if (profileRaw is Map<String, dynamic>) {
        // print('$_tag: Profile already in Map format');
        return profileRaw;
      } else {
        throw Exception('Invalid profile data type: ${profileRaw.runtimeType}');
      }
    } catch (e) {
      // print('$_tag: Error parsing profile: $e');
      throw Exception('Failed to parse profile data: $e');
    }
  }

  /// Validate if cafe data is complete
  static bool isValidCafeData(Map<String, dynamic> cafeData) {
    final requiredFields = ['id', 'cafename', 'alamat'];
    return requiredFields.every((field) => 
      cafeData.containsKey(field) && cafeData[field] != null);
  }

  /// Format cafe opening hours for display
  static String formatOpeningHours(String? jamBuka, String? jamTutup) {
    if (jamBuka == null || jamTutup == null) return 'Jam tidak tersedia';
    return '$jamBuka - $jamTutup';
  }
}