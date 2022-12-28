import 'dart:convert';
import 'dart:developer';

import 'package:clothes/api/api_connect.dart';
import 'package:clothes/users/authentication/login_screen.dart';
import 'package:clothes/users/model/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  validateUserEmail() async {

    try{

      var res = await http.post(
        Uri.parse(API.validate_email),
        body: {
          'email':emailController.text.trim(),
        },
      );

      if(res.statusCode == 200){
        var result = jsonDecode(res.body);

        if(result['emailFound'] == true){
          Fluttertoast.showToast( msg: '"Email already exist, try again"');
        }else{
          // save users to database

          registerUserRecord();
    }
      }
    }catch(e){
     log(e.toString());
      Fluttertoast.showToast( msg: e.toString());
    }
  }
  registerUserRecord() async {

    User userModel = User(
       1,
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim()
    );


   try {
     var res = await http.post(
       Uri.parse(API.signUp),
       body: userModel.toJson(),
     );

     if(res.statusCode == 200){
       var result = jsonDecode(res.body);

       if(result['success']==true){

         Fluttertoast.showToast( msg: 'Create account Successfully');

         setState(() {
           nameController.clear();
           emailController.clear();
           passwordController.clear();
         });
       }

     }else{

       Fluttertoast.showToast( msg: 'Error creating account');
     }
   }catch(e){
      log(e.toString());
      Fluttertoast.showToast( msg: e.toString());
   }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: LayoutBuilder(
          builder: (context, cons) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: cons.maxHeight,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //signup screen header
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 285,
                      child: Image.asset("images/register.jpg"),
                    ),


                    const Text("Kexim Bank",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 26,
                      ),
                    ),

                    //signup screen sign-up form

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.all(
                              Radius.circular(60),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 8,
                                  color: Colors.black26,
                                  offset: Offset(0, -3)),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30,30,30,8),
                            child: Column(
                              children: [

                                //this is our form with email password details
                                Form(
                                  key: formKey,
                                  child: Column(
                                    children: [

                                      //Name
                                      TextFormField(
                                        controller: nameController,
                                        validator: (val) => val == ""
                                            ? "Please Enter Name"
                                            : null,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.person,
                                            color: Colors.black,
                                          ),
                                          hintText: "Name ...",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 6
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                        ),
                                      ),

                                      const SizedBox(height: 18,),

                                      //email
                                      TextFormField(
                                        controller: emailController,
                                        validator: (val) => val == ""
                                            ? "PLease email adddesss"
                                            : null,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.email,
                                            color: Colors.black,
                                          ),
                                          hintText: "Email ...",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 6
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                        ),
                                      ),

                                      const SizedBox(height: 18,),

                                      // for password text field

                                      Obx(() =>
                                          TextFormField(
                                            controller: passwordController,
                                            obscureText: isObsecure.value,
                                            validator: (val) => val == ""
                                                ? "Please enter password"
                                                : null,
                                            decoration: InputDecoration(
                                              prefixIcon: const Icon(
                                                Icons.vpn_key_sharp,
                                                color: Colors.black,
                                              ),
                                              suffixIcon: Obx(
                                                    () => GestureDetector(
                                                  onTap: (){
                                                    isObsecure.value = !isObsecure.value;
                                                  },
                                                  child: Icon(
                                                    isObsecure.value ? Icons.visibility_off : Icons.visibility,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              hintText: "Password ...",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(30),
                                                borderSide: const BorderSide(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(30),
                                                borderSide: const BorderSide(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(30),
                                                borderSide: const BorderSide(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              disabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(30),
                                                borderSide: const BorderSide(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: 14,
                                                  vertical: 6
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                            ),
                                          ),

                                      ),

                                      const SizedBox(height: 18,),

                                      // button input
                                      Material(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(30),
                                        child: InkWell(
                                          onTap: (){
                                            if(formKey.currentState!.validate()){
                                              //validate the email
                                              validateUserEmail();


                                            }

                                          },
                                          borderRadius: BorderRadius.circular(30),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 28,
                                            ),
                                            child: Text(
                                              "Register",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                // Already have account button form here
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    const Text(
                                      "Already have an Account?",
                                    ),
                                    TextButton(
                                      onPressed: () {

                                        Get.to(LoginScreen());

                                      },
                                      child: const Text(
                                        "Login here",
                                        style: TextStyle(
                                          color: Colors.purpleAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
