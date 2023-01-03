import 'package:clothes/users/authentication/login_screen.dart';
import 'package:clothes/users/userPreferences/current_user.dart';
import 'package:clothes/users/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileFragmentScreen extends StatelessWidget {

  final CurrentUser _currentUser = Get.put(CurrentUser());
//  const ProfileFragmentScreen({Key? key}) : super(key: key);

  signOurUser() async{
   var resultResponse =  await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey,
        title: const Text(
          "Logout",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Are you sure? \n "
        ),
        actions: [
          TextButton(
              onPressed: (){
                Get.back();
              },
              child: const Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              )
          ),
          TextButton(
              onPressed: (){
                Get.back(result:"loggedOut");
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              )
          ),
        ],
      )
    );

    if(resultResponse=="loggedOut"){
      //remove the user sharedPreference
      // delete user from phone storage
      RememberUserPrefs.removeUserInfo().then((value) {

        Get.off(LoginScreen());
      });
    }
  }


  Widget userInfoItemProfile(IconData iconData, String userData){
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(
            iconData,
          size:30 ,
          color: Colors.black,
          ),
          const SizedBox(width: 16,),
          
          Text(
              userData,
            style: const TextStyle(
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(32),
      children: [
        Center(
          child: Image.asset(
              "images/woman.png",
            width: 240,
          ),
        ),
        
        const SizedBox(height: 20,),
        userInfoItemProfile(Icons.person, _currentUser.user.user_email),
        const SizedBox(height: 20,),
        userInfoItemProfile(Icons.email, _currentUser.user.user_email),
        const SizedBox(height: 20,),
        Center(
          child: Material(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: (){
                signOurUser();
              },
              borderRadius: BorderRadius.circular(32),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                child: Text(
                  "Sign Out",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),


      ],

    );
  }
}
