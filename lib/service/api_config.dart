//ini class api_config.dart yang sudah diupdate

class ApiConfig {
  static const String devBaseUrl = '192.168.1.8';
  static const int port = 8000;
  static const String protocol = 'http';

  static var headers;

  static String get baseUrl {
    return '$protocol://$devBaseUrl:$port';
  }

  static const Duration timeout = Duration(seconds: 30);
  
//<====== auth =======>
  static String get verifyOtpEndpoint => '$baseUrl/api/auth/verifyOtp';
  static String get loginendpoint => '$baseUrl/api/auth/login';
  static String get registerendpoint => '$baseUrl/api/auth/register';
  static String get forgotpasendpoint => '$baseUrl/api/auth/forgotpassword';
  static String get resetpasswordendpoint => '$baseUrl/api/auth/resetpassword';
  static String get checkusernameendpoint => '$baseUrl/api/auth/checkusername';
  static String get checkemailendpoint => '$baseUrl/api/auth/checkemail';
  
//<====== homepage =======>
  static String get cardcafeendpoint => '$baseUrl/api/kafe/findAll';
  //savecafe
  static String get cardsaveendpoint =>
      '$baseUrl/api/bookmark/findBookmarkByUser';
  //profile
  static String updateProfileEndpoint(String id) =>'$baseUrl/api/user/update/$id';
  //leaderboard
  static String get leaderboardWeeklyEndpoint =>
      '$baseUrl/api/leaderboard/weekly';
  static String get leaderboardUpdateEndpoint =>
      '$baseUrl/api/leaderboard/update-weekly';
      
  // Detail kafe
static  String get kafeDetail => '$baseUrl/api/kafe/detail/';
static String get findBookmark => '$baseUrl/api/bookmark/findBookmarkByUser';
static String get addBookmark => '$baseUrl/api/bookmark/addBookmark';
static  String get removeBookmark => '$baseUrl/api/bookmark/removeBookmark';
static  String get addRating => '$baseUrl/api/rating/addRate';
static  String get checkBookmark => '$baseUrl/api/bookmark/check';


// Storage (untuk gambar)
static String storageImage(String imagePath) =>
    '$baseUrl/storage/$imagePath';

}
