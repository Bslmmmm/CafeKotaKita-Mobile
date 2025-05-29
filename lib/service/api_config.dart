//ini class api_config.dart

class ApiConfig {
  static const String devBaseUrl = '192.168.1.10';  
  static const int port = 8000; 
  static const String protocol = 'http'; 

  static String get baseUrl {
    return '$protocol://$devBaseUrl:$port';
  }

  //auth
  static String get verifyOtpEndpoint => '$baseUrl/api/auth/verifyOtp';
  static String get loginendpoint => '$baseUrl/api/auth/login';
  static String get registerendpoint => '$baseUrl/api/auth/register';
  static String get forgotpasendpoint => '$baseUrl/api/auth/forgotpassword';
  static String get resetpasswordendpoint => '$baseUrl/api/auth/resetpassword';
  static String get checkusernameendpoint => '$baseUrl/api/auth/checkusername';
  static String get checkemailendpoint => '$baseUrl/api/auth/checkemail';  
  //homepage
  static String get cardcafeendpoint => '$baseUrl/api/kafe/findAll';
  //savecafe
  static String get cardsaveendpoint => '$baseUrl/api/bookmark/findBookmarkByUser';
}
