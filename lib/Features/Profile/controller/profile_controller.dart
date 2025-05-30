import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:KafeKotaKita/Constant/constants.dart';
import '../models/user_model.dart';

class ProfileController {
  final storage = GetStorage();

  UserModel? getUser() {
    final userDataRaw = storage.read(profileKey);
    if (userDataRaw == null) return null;

    try {
      final userData = userDataRaw is String ? jsonDecode(userDataRaw) : userDataRaw;
      if (userData is Map) {
        // Cast ke Map<String, dynamic> supaya aman
        final Map<String, dynamic> userMap = userData.cast<String, dynamic>();
        return UserModel.fromJson(userMap);
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  void logout() {
    storage.remove(profileKey);
  }
}
