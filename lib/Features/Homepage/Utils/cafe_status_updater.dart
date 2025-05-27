// Features/Homepage/Utils/cafe_status_updater.dart

import 'dart:async';
import '../model/model_homepage.dart';
import 'time_service.dart';

class CafeStatusUpdater {
  Timer? _timer;
  final Function(List<CafeData>) onStatusUpdated;

  CafeStatusUpdater({required this.onStatusUpdated});

  // Start periodic updates
  void startPeriodicUpdates(List<CafeData> cafes) {
    updateCafeStatuses(cafes); // Initial update
    _timer = Timer.periodic(Duration(minutes: 1), (_) {
      updateCafeStatuses(cafes);
    });
  }

  void updateCafeStatuses(List<CafeData> cafes) {
    final currentTimeInMinutes = TimeService.getCurrentTimeInMinutes();
    final updatedCafes = cafes.map((cafe) {
      final isOpen = TimeService.isCafeOpenBySeparateFields(
        cafe.jambuka,
        cafe.jamtutup,
        currentTimeInMinutes,
      );

      if (cafe.isOpen != isOpen) {
        return cafe.copyWith(isOpen: isOpen);
      }
      return cafe;
    }).toList();

    if (!_areListsIdentical(cafes, updatedCafes)) {
      onStatusUpdated(updatedCafes);
    }
  }

  bool _areListsIdentical(List<CafeData> list1, List<CafeData> list2) {
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      if (list1[i].isOpen != list2[i].isOpen) return false;
    }

    return true;
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
