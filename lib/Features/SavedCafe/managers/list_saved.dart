import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tugas_flutter/service/api_config.dart';
import '../../Homepage/Utils/cafe_status_updater.dart';
import '../../Homepage/model/model_homepage.dart';
import 'package:http/http.dart'as http;

enum bookmarkliststatus {
  initial,
  loading,
  success,
  error,
}

class CafeListState {
  final bookmarkliststatus status;
  final List<CafeData> cafes;
  final String errorMessage;

  const CafeListState({
    this.status = bookmarkliststatus.initial,
    this.cafes = const [],
    this.errorMessage = '',
  });

  CafeListState copyWith({
    bookmarkliststatus? status,
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

class bookmarklistmanager extends ChangeNotifier {
  CafeListState _state = const CafeListState();
  final Function(CafeListState) onStateChanged;
  late final CafeStatusUpdater _statusUpdater;

  CafeListState get state => _state;

  bookmarklistmanager({required this.onStateChanged}) {
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


Future<void> loadbookmark() async {
  _setState(_state.copyWith(status: bookmarkliststatus.loading));

  try {
    final response = await http.get(Uri.parse(ApiConfig.cardsaveendpoint));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];

      final List<CafeData> cafes = data.map((item) => CafeData.fromJson(item)).toList();

      _setState(_state.copyWith(
        status: bookmarkliststatus.success,
        cafes: cafes,
      ));

      _statusUpdater.startPeriodicUpdates(cafes);
    } else {
      throw Exception('Failed to load cafes: ${response.statusCode}');
    }
  } catch (e) {
    _setState(_state.copyWith(
      status: bookmarkliststatus.error,
      errorMessage: 'Failed to load cafes: ${e}',
    ));
  }
}

  Future<void> refreshCafes() async {
    await loadbookmark();
  }

  @override
  void dispose() {
    _statusUpdater.dispose();
    super.dispose();
  }
}