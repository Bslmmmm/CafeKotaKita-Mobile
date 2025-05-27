import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tugas_flutter/service/api_config.dart';
import '../model/model_homepage.dart';
import '../Utils/cafe_status_updater.dart';
// import '../Utils/time_service.dart';
import 'package:http/http.dart'as http;

enum CafeListStatus {
  initial,
  loading,
  success,
  error,
}

class CafeListState {
  final CafeListStatus status;
  final List<CafeData> cafes;
  final String errorMessage;

  const CafeListState({
    this.status = CafeListStatus.initial,
    this.cafes = const [],
    this.errorMessage = '',
  });

  CafeListState copyWith({
    CafeListStatus? status,
    List<CafeData>? cafes,
    String? errorMessage,
  }) {
    return CafeListState(
      status: status ?? this.status,
      cafes: cafes ?? this.cafes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CafeListManager extends ChangeNotifier {
  CafeListState _state = const CafeListState();
  final Function(CafeListState) onStateChanged;
  late final CafeStatusUpdater _statusUpdater;

  CafeListState get state => _state;

  CafeListManager({required this.onStateChanged}) {
    _statusUpdater = CafeStatusUpdater(
      onStatusUpdated: _updateCafeStatuses,
    );
  }


  void _setState(CafeListState newState) {
    _state = newState;
    notifyListeners();
    onStateChanged(_state);
  }


  void _updateCafeStatuses(List<CafeData> updatedCafes) {
    _setState(_state.copyWith(cafes: updatedCafes));
  }


Future<void> loadCafes() async {
  _setState(_state.copyWith(status: CafeListStatus.loading));

  try {
    final response = await http.get(Uri.parse(ApiConfig.cardcafeendpoint));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];

      final List<CafeData> cafes = data.map((item) => CafeData.fromJson(item)).toList();

      _setState(_state.copyWith(
        status: CafeListStatus.success,
        cafes: cafes,
      ));

      _statusUpdater.startPeriodicUpdates(cafes);
    } else {
      throw Exception('Failed to load cafes: ${response.statusCode}');
    }
  } catch (e) {
    _setState(_state.copyWith(
      status: CafeListStatus.error,
      errorMessage: 'Failed to load cafes: ${e}',
    ));
  }
}





  // Search cafes by name or location
  List<CafeData> searchCafes(String query) {
    if (query.isEmpty) return _state.cafes;

    final lowerQuery = query.toLowerCase();
    return _state.cafes.where((cafe) => 
      cafe.cafename.toLowerCase().contains(lowerQuery) || 
      cafe.alamat.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  Future<void> refreshCafes() async {
    await loadCafes();
  }


  @override
  void dispose() {
    _statusUpdater.dispose();
    super.dispose();
  }
}
