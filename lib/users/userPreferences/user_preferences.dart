import 'dart:convert';

import 'package:clothes/users/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberUserPrefs{

  //save-remember User-info

  static Future<void> saveRememberUser(User userInfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString("currentUser", userJsonData);


  }
}