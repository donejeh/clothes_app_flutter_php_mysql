import 'dart:convert';

import 'package:clothes/users/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberUserPrefs{

  //save-remember User-info

  static Future<void> storeUserInfo(User userInfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString("currentUser", userJsonData);
  }

  // get - read User-info
  static Future<User?> readUserInfo() async {

    User? currentUserInfo;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userInfo = preferences.getString("currentUser");

    if(userInfo != null){
      Map<String,dynamic> userDataMap =  jsonDecode(userInfo);
      currentUserInfo = User.fromJson(userDataMap);
    }

    return currentUserInfo;

  }

  static Future<void> removeUserInfo() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
     await preferences.remove('currentUser');
  }

}