// Features/Homepage/Utils/time_service.dart

class TimeService {
  // Get current time in minutes since midnight
  static int getCurrentTimeInMinutes() {
    final now = DateTime.now();
    return now.hour * 60 + now.minute;
  }

  // Check if cafe is currently open based on operational hours
  static bool isCafeOpenNow(String operationalHours) {
    final currentTimeInMinutes = getCurrentTimeInMinutes();
    return isCafeOpen(operationalHours, currentTimeInMinutes);
  }

  // Helper method to check if a cafe is open at a specific time (in minutes since midnight)
  static bool isCafeOpen(String operationalHours, int timeInMinutes) {
    // Parse operational hours like "05:00 - 22:00" (format 24 jam)
    try {
      final parts = operationalHours.split(' - ');
      if (parts.length != 2) return false;
      
      final openingTime = parseTimeString(parts[0]);
      final closingTime = parseTimeString(parts[1]);
      
      if (openingTime == null || closingTime == null) return false;
      
      // Handle cases where closing time is on the next day (e.g., 22:00 - 02:00)
      if (closingTime < openingTime) {
        // If current time is after opening or before closing, cafe is open
        return timeInMinutes >= openingTime || timeInMinutes <= closingTime;
      } else {
        // Normal case: if current time is between opening and closing, cafe is open
        return timeInMinutes >= openingTime && timeInMinutes <= closingTime;
      }
    } catch (e) {
      print('Error parsing operational hours: $e');
      return false;
    }
  }
  
  // Helper method to parse time strings like "05:00" to minutes since midnight (format 24 jam)
  static int? parseTimeString(String timeStr) {
    try {
      // Extract hour and minute from 24-hour format (HH:MM)
      final regex = RegExp(r'(\d+):(\d+)');
      final match = regex.firstMatch(timeStr);
      
      if (match != null) {
        final hour = int.parse(match.group(1)!);
        final minute = int.parse(match.group(2)!);
        
        // Validasi format waktu
        if (hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
          return hour * 60 + minute;
        }
      }
      return null;
    } catch (e) {
      print('Error parsing time string: $e');
      return null;
    }
  }
}