import 'package:shared_preferences/shared_preferences.dart';

class MyPreference {
  static late SharedPreferences pref;

  static saveMode(String mode) async {
    return await pref.setString("mode", mode);
  }

  static String getMode() {
    return pref.getString("mode") ?? "light";
  }
}
