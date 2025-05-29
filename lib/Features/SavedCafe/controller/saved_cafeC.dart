// lib/Features/SavedCafe/controller/saved_cafe_controller.dart
import 'package:flutter/material.dart';
import 'package:KafeKotaKita/Features/SavedCafe/model/model_saved_cafe.dart';
import 'package:KafeKotaKita/Features/SavedCafe/service/service_savedcafe.dart';

class SavedCafeController extends ChangeNotifier {
  final SavedCafeService _service;
  
  List<SavedCafeItem> _savedCafes = [];
  bool _isLoading = false;
  String? _errorMessage;

  SavedCafeController({SavedCafeService? service})
      : _service = service ?? SavedCafeService();

  // Getters
  List<SavedCafeItem> get savedCafes => _savedCafes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasCafes => _savedCafes.isNotEmpty;
  bool get hasError => _errorMessage != null;

  Future<void> loadSavedCafes() async {
    _setLoading(true);
    _clearError();
    
    try {
      _savedCafes = await _service.loadSavedCafes();
      notifyListeners();
    } catch (e) {
      _setError('Gagal memuat cafe tersimpan: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshSavedCafes() async {
    await loadSavedCafes();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}