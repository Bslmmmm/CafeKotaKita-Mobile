class ApiConfig {
  static const String devBaseUrl = '192.168.1.31';  
  static const int port = 8000; // Port server
  static const String protocol = 'http'; // http atau https

  static String get baseUrl {
    return '$protocol://$devBaseUrl:$port';
  }

  //auth
  static String get verifyOtpEndpoint => '$baseUrl/api/auth/verifyOtp';
  static String get loginendpoint => '$baseUrl/api/auth/login';
  static String get registerendpoint => '$baseUrl/api/auth/register';
  static String get forgotpasendpoint => '$baseUrl/api/auth/forgotpassword';
  static String get resetpasswordendpoint => '$baseUrl/api/auth/resetpassword';
  
  //homepage
  static String get cardcafeendpoint => '$baseUrl/api/kafe/index';
}