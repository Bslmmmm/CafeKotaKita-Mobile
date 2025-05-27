class ApiConfig {
  static const String devBaseUrl = '10.10.180.145';
  static const int port = 8000; // Port server
  static const String protocol = 'http'; // http atau https

  static String get baseUrl {
    return '$protocol://$devBaseUrl:$port';
  }

  // Contoh endpoint khusus
  static String get verifyOtpEndpoint => '$baseUrl/api/auth/verifyOtp';
  static String get loginendpoint => '$baseUrl/api/auth/login';
  static String get registerendpoint => '$baseUrl/api/auth/register';
  static String get forgotpasendpoint => '$baseUrl/api/auth/forgotpassword';
  static String get resetpasswordendpoint => '$baseUrl/api/auth/resetpassword';
  static String get checkusernameendpoint => '$baseUrl/api/auth/checkusername';
  static String get checkemailendpoint => '$baseUrl/api/auth/checkemail';
}
