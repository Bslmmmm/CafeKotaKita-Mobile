import 'package:share_plus/share_plus.dart';

class ShareUtil {
  static void sharePost(String text) {
    Share.share(text);
  }
}
