// Features/Homepage/Managers/cafe_list_manager.dart

import 'package:flutter/foundation.dart';
import 'package:tugas_flutter/service/api_config.dart';
import '../model/cafe_data.dart';
import '../Utils/cafe_status_updater.dart';
import '../Utils/time_service.dart';

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

  // Update state and notify listeners
  void _setState(CafeListState newState) {
    _state = newState;
    notifyListeners();
    onStateChanged(_state);
  }

  // Callback for the CafeStatusUpdater
  void _updateCafeStatuses(List<CafeData> updatedCafes) {
    _setState(_state.copyWith(cafes: updatedCafes));
  }

  // Load cafes from API (to be implemented)
  Future<void> loadCafes() async {
    _setState(_state.copyWith(status: CafeListStatus.loading));

    try {
      // For now, use mock data
      await Future.delayed(Duration(seconds: 2)); // Simulate network delay
      loadMockCafes();
    } catch (e) {
      _setState(_state.copyWith(
        status: CafeListStatus.error,
        errorMessage: 'Failed to load cafes: ${e.toString()}',
      ));
    }
  }

  // Load mock cafe data for testing
  void loadMockCafes() {
    final mockCafes = [
      CafeData(
        id: '1',
        imageUrl: 'https://example.com/cafe1.jpg',
        cafeName: 'Coffee Haven',
        location: 'Central District',
        operationalHours: '08:00 - 22:00',
        rating: 4.5,
        isOpen: false, // Will be updated by the status updater
      ),
      CafeData(
        id: '2',
        imageUrl: 'https://example.com/cafe2.jpg',
        cafeName: 'Brew & Beans',
        location: 'North Village',
        operationalHours: '07:00 - 20:00',
        rating: 4.2,
        isOpen: false, // Will be updated by the status updater
      ),
      CafeData(
        id: '3',
        imageUrl: 'https://example.com/cafe3.jpg',
        cafeName: 'Late Night Espresso',
        location: 'Downtown',
        operationalHours: '14:00 - 02:00',
        rating: 4.8,
        isOpen: false, // Will be updated by the status updater
      ),
      CafeData(
        id: '3',
        imageUrl: 'https://example.com/cafe3.jpg',
        cafeName: 'Omahkokop',
        location: 'RPPH+JFW, Lingkungan Krajan Timur, Tegalgede, Kec. Sumbersari, Kabupaten Jember, Jawa Timur 68124',
        operationalHours: '17:00 - 02:00',
        rating: 4.8,
        isOpen: false, 
      ),
      // Add more mock cafes as needed
    ];
    
    _setState(_state.copyWith(
      status: CafeListStatus.success,
      cafes: mockCafes,
    ));
    
    // Start the status updater to keep cafe open/closed status updated
    _statusUpdater.startPeriodicUpdates(mockCafes);
  }

  // Search cafes by name or location
  List<CafeData> searchCafes(String query) {
    if (query.isEmpty) return _state.cafes;
    
    final lowerQuery = query.toLowerCase();
    return _state.cafes.where((cafe) => 
      cafe.cafeName.toLowerCase().contains(lowerQuery) || 
      cafe.location.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  // Refresh cafe data
  Future<void> refreshCafes() async {
    await loadCafes();
  }

  // Clean up resources
  @override
  void dispose() {
    _statusUpdater.dispose();
    super.dispose();
  }
}