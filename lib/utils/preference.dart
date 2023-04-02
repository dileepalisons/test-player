import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDataProvider {
  static const User? user = null;

  static const String id = 'user_id';

  static const String name = 'user_name';
  static const String phone = 'user_mobile';
  static const String userLastName = 'user_last_name';
  static const String mail = 'user_mail';

  Future<bool> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  Future<bool> saveUser(User user) async {
    var a = await saveId(user);
    var b = await saveName(user);
    var c = await savePhone(user);
    var d = await saveMail(user);
    return a && b && c && d ? false : true;
  }

  Future<bool> saveId(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var a = prefs.setString(id, user.uid);
    print(prefs.getString(id));
    return a;
  }

  Future<bool> saveName(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(name, user.displayName ?? '');
  }

  Future<bool> savePhone(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(phone, user.phoneNumber ?? '');
  }

  Future<bool> saveMail(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(mail, user.email ?? "");
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(id);
  }

  Future<String?> getuserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(name);
  }

  Future<String?> getUserPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(phone);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(mail);
  }
}
