import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
    
    class AdminUploadItemsScreen extends StatefulWidget {
       const AdminUploadItemsScreen({Key? key}) : super(key: key);
      //
      @override
      State<AdminUploadItemsScreen> createState() => _AdminUploadItemsScreenState();
    }
    
    class _AdminUploadItemsScreenState extends State<AdminUploadItemsScreen> {

      ImagePicker _picker = ImagePicker();
      XFile? pickedImageXFile;

      var formKey = GlobalKey<FormState>();

      var nameController = TextEditingController();
      var colorController = TextEditingController();
      var ratingController = TextEditingController();
      var tagsController = TextEditingController();
      var priceController = TextEditingController();
      var sizeController = TextEditingController();
      var descriptionController = TextEditingController();
      var imageLink = "";

      //default screen method here
      caputureImageWithPhoneCamera() async{
       pickedImageXFile = await _picker.pickImage(
            source: ImageSource.camera);
       Get.back();

       setState(() => pickedImageXFile);
      }

      pickImageFromPhoneGallery() async{
        pickedImageXFile = await _picker.pickImage(
            source: ImageSource.gallery);
        Get.back();

        setState(() => pickedImageXFile);
      }

      showDialogBoxForImagePick(){

        return showDialog(
            context: context,
            builder: (context){
              return SimpleDialog(
                backgroundColor: Colors.black,
                title: const Text(
                  "Item Image",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  SimpleDialogOption(
                    onPressed: (){
                      caputureImageWithPhoneCamera();
                    },
                    child: const Text(
                      "Capture with Phone Camera",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: (){
                      pickImageFromPhoneGallery();
                    },
                    child: const Text(
                      "Pick image from Phone Gallery",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: (){
                      Get.back();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              );
            });
      }

      Widget defaultScreen(){
      return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black54,
                  Colors.deepPurple
                ],
              ),
            ),

          ),
          automaticallyImplyLeading: false,
          title: Text(
            "Welcome Admin",
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black54,
                Colors.deepPurple
              ],
            ),
          ),
          child:  Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                Icon(
                  Icons.add_photo_alternate,
                  color: Colors.white54,
                  size: 200,
                ),

                // button input
                Material(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: (){
                      showDialogBoxForImagePick();

                    },
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 28,
                      ),
                      child: Text(
                        "Add New Item",
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
        ),
      );
    }

    Widget uploadItemFormScreen(){
        return Scaffold(
          backgroundColor: Colors.black,
          body: ListView(
            children: [

              //image
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(
                      File(pickedImageXFile!.path),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              //upload item form
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
                                //items name
                                TextFormField(
                                  controller: nameController,
                                  validator: (val) => val == ""
                                      ? "Items title here"
                                      : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.title,
                                      color: Colors.black,
                                    ),
                                    hintText: "Items name ...",
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


                              //items rating
                                TextFormField(
                                  controller: ratingController,
                                  validator: (val) => val == ""
                                      ? "Items rating here"
                                      : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.rate_review,
                                      color: Colors.black,
                                    ),
                                    hintText: "Items rating ...",
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

                                //items tags

                                TextFormField(
                                  controller: tagsController,
                                  validator: (val) => val == ""
                                      ? "Items tags here"
                                      : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.tag_sharp,
                                      color: Colors.black,
                                    ),
                                    hintText: "Items tags ...",
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

                                //items price

                                TextFormField(
                                  controller: priceController,
                                  validator: (val) => val == ""
                                      ? "Items price here"
                                      : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.money,
                                      color: Colors.black,
                                    ),
                                    hintText: "Items price ...",
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

                                //items size
                                TextFormField(
                                  controller: sizeController,
                                  validator: (val) => val == ""
                                      ? "Items size here"
                                      : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.picture_in_picture,
                                      color: Colors.black,
                                    ),
                                    hintText: "Items size ...",
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

                                //items color
                                TextFormField(
                                  controller: colorController,
                                  validator: (val) => val == ""
                                      ? "Items color here"
                                      : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.color_lens,
                                      color: Colors.black,
                                    ),
                                    hintText: "Items color ...",
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

                                //items description
                                TextFormField(
                                  controller: descriptionController,
                                  validator: (val) => val == ""
                                      ? "Items description here"
                                      : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.description,
                                      color: Colors.black,
                                    ),
                                    hintText: "Items description ...",
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

                                // button input
                                Material(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(30),
                                  child: InkWell(
                                    onTap: (){

                                      if(formKey.currentState!.validate()){

                                      }

                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 28,
                                      ),
                                      child: Text(
                                        "Upload now",
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

                        ],
                      ),
                    )),
              ),
            ],
          ),
        );
    }

      @override
      Widget build(BuildContext context) {

        return pickedImageXFile == null ? defaultScreen() : uploadItemFormScreen() ;
      }
    }
    