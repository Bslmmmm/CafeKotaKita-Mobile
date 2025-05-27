// Features/Homepage/Utils/time_service.dart

class TimeService {
  static int getCurrentTimeInMinutes() {
    final now = DateTime.now();
    return now.hour * 60 + now.minute;
  }


  static bool isCafeOpenBySeparateFields(
    String jambuka,
    String jamtutup,
    int timeInMinutes,
  ) {
    try {
      final opening = parseTimeHHmmFromFull(jambuka);
      final closing = parseTimeHHmmFromFull(jamtutup);

      if (opening == null || closing == null) return false;

      if (closing < opening) {
        return timeInMinutes >= opening || timeInMinutes <= closing;
      } else {
        return timeInMinutes >= opening && timeInMinutes <= closing;
      }
    } catch (e) {
      print('Error checking open status: $e');
      return false;
    }
  }

  // Ekstrak HH:mm dari string HH:mm:ss
  static int? parseTimeHHmmFromFull(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length < 2) return null;

      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;

      if (hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
        return hour * 60 + minute;
      }
      return null;
    } catch (e) {
      print('Error parsing time string: $e');
      return null;
    }
  }
}
