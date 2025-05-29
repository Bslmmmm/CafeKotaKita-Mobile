import 'package:KafeKotaKita/Features/SavedCafe/model/model_saved_cafe.dart';

class SavedCafeResponse {
  final String status;
  final List<SavedCafeItem> data;

  SavedCafeResponse({required this.status, required this.data});

  factory SavedCafeResponse.fromJson(Map<String, dynamic> json) {
    return SavedCafeResponse(
      status: json['status'],
      data: (json['data'] as List<dynamic>)
          .map((item) => SavedCafeItem.fromJson(item))
          .toList(),
    );
  }
}
