import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String sharedPreferencesUserLoggedInKey = 'IsLoggedIn';
  static String sharedPreferencesUserNameKey = 'UserNameKey';

  // saving data to Shared Preferences



  static Future<bool> saveUserNameSharedPreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesUserNameKey, userName);
  }

  // getting data from Shared Preferences



  static Future<String?> getUserNameSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencesUserNameKey);
  }

}
