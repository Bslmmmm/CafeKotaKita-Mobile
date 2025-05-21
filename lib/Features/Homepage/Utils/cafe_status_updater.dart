// Features/Homepage/Utils/cafe_status_updater.dart

import 'dart:async';
import '../model/cafe_data.dart';
import 'time_service.dart';

class CafeStatusUpdater {
  Timer? _timer;
  final Function(List<CafeData>) onStatusUpdated;
  
  CafeStatusUpdater({required this.onStatusUpdated});
  
  // Start periodic updates
  void startPeriodicUpdates(List<CafeData> cafes) {
    // Do an initial update
    updateCafeStatuses(cafes);
    
    // Schedule periodic updates
    _timer = Timer.periodic(Duration(minutes: 1), (_) {
      updateCafeStatuses(cafes);
    });
  }
  
  // Update cafe open/closed statuses based on current time
  void updateCafeStatuses(List<CafeData> cafes) {
    final currentTimeInMinutes = TimeService.getCurrentTimeInMinutes();
    final updatedCafes = cafes.map((cafe) {
      final isOpen = TimeService.isCafeOpen(cafe.operationalHours, currentTimeInMinutes);
      
      // Only create a new object if the open status has changed
      if (cafe.isOpen != isOpen) {
        return cafe.copyWith(isOpen: isOpen);
      }
      return cafe;
    }).toList();
    
    // Notify listeners only if there were actual changes
    if (!_areListsIdentical(cafes, updatedCafes)) {
      onStatusUpdated(updatedCafes);
    }
  }
  
  // Check if two lists of cafes are identical in terms of their open status
  bool _areListsIdentical(List<CafeData> list1, List<CafeData> list2) {
    if (list1.length != list2.length) return false;
    
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].isOpen != list2[i].isOpen) return false;
    }
    
    return true;
  }
  
  // Clean up timer when no longer needed
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}