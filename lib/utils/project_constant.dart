import 'dart:math';

class ProjectConstant {
  static String appName = "Food Hunt";
  static String hostUrl = "http://192.168.0.102:8080/";
  static const GOOGLE_API_KEY = "AIzaSyB6WvHs_whX1olbnbqWOxr1XJX8W_k2Rdw";

  static String getRandomString(int length) {
    String _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
