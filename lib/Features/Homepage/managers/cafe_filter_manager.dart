// Features/Homepage/Managers/cafe_filter_manager.dart

import 'package:flutter/material.dart';
import 'package:tugas_flutter/Features/Homepage/model/filter_cafe.dart';
import 'package:tugas_flutter/Features/Homepage/model/model_homepage.dart';
import '../Utils/time_service.dart';

class CafeFilterManager extends ChangeNotifier {
  FilterState _filterState = const FilterState();
  
  FilterState get filterState => _filterState;
  
  // Apply search filter
  void setSearchQuery(String query) {
    _filterState = _filterState.copyWith(searchQuery: query);
    notifyListeners();
  }
  
  // Toggle filters with exclusivity (turning one on turns others off)
  void toggleFilter(FilterType type) {
    _filterState = _filterState.toggleFilterExclusive(type);
    notifyListeners();
  }
  
  // Reset all filters
  void resetFilters() {
    _filterState = _filterState.resetAll();
    notifyListeners();
  }
  
  // Apply all filters to a list of cafes
  List<CafeData> applyFilters(List<CafeData> cafes) {
    var filteredCafes = cafes;
    
    // Apply search filter if query is not empty
    if (_filterState.searchQuery.isNotEmpty) {
      final query = _filterState.searchQuery.toLowerCase();
      filteredCafes = filteredCafes.where((cafe) => 
        cafe.cafename.toLowerCase().contains(query) || 
        cafe.alamat.toLowerCase().contains(query)
      ).toList();
    }
    

    if (_filterState.showOpenOnly) {
      final currentTimeInMinutes = TimeService.getCurrentTimeInMinutes();
      filteredCafes = filteredCafes.where((cafe) => 
        TimeService.isCafeOpenBySeparateFields(cafe.jambuka, cafe.jamtutup, currentTimeInMinutes)
      ).toList();
    }
    

    if (_filterState.showTopRated) {
      filteredCafes.sort((a, b) => b.rating.compareTo(a.rating));
    }
    

    if (_filterState.showNearest) {
// nanti diubah sesuai dengan lokasi user
      filteredCafes.sort((a, b) => a.alamat.compareTo(b.alamat));
    }
    
    return filteredCafes;
  }
}