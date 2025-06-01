import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:KafeKotaKita/Constant/constants.dart';
import '../models/user_model.dart';

class ProfileController extends GetxController {
  final storage = GetStorage();

  // Observable user
  var user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  void loadUser() {
    final userDataRaw = storage.read(profileKey);
    if (userDataRaw == null) {
      user.value = null;
      return;
    }

    try {
      final userData = userDataRaw is String ? jsonDecode(userDataRaw) : userDataRaw;
      if (userData is Map) {
        final Map<String, dynamic> userMap = userData.cast<String, dynamic>();
        user.value = UserModel.fromJson(userMap);
      }
    } catch (_) {
      user.value = null;
    }
  }

  // Method untuk refresh (reload dari GetStorage)
  void refreshUser() {
    loadUser();
  }

  void logout() {
    storage.remove(profileKey);
    user.value = null;
  }
}
