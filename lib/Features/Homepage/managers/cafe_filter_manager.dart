// Features/Homepage/Managers/cafe_filter_manager.dart

import 'package:flutter/material.dart';
import 'package:tugas_flutter/Features/Homepage/model/filter_cafe.dart';
import 'package:tugas_flutter/Features/Homepage/model/cafe_data.dart';
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
        cafe.cafeName.toLowerCase().contains(query) || 
        cafe.location.toLowerCase().contains(query)
      ).toList();
    }
    
    // Apply open-only filter if enabled
    if (_filterState.showOpenOnly) {
      final currentTimeInMinutes = TimeService.getCurrentTimeInMinutes();
      filteredCafes = filteredCafes.where((cafe) => 
        TimeService.isCafeOpen(cafe.operationalHours, currentTimeInMinutes)
      ).toList();
    }
    
    // Apply top-rated filter if enabled
    if (_filterState.showTopRated) {
      filteredCafes.sort((a, b) => b.rating.compareTo(a.rating));
    }
    
    // Apply nearest filter if enabled (placeholder for future implementation)
    if (_filterState.showNearest) {
      // This would normally use location data to sort by distance
      // For now, just sort alphabetically by location as a placeholder
      filteredCafes.sort((a, b) => a.location.compareTo(b.location));
    }
    
    return filteredCafes;
  }
}