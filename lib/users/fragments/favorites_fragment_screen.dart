import 'dart:convert';

import 'package:clothes/api/api_connect.dart';
import 'package:clothes/users/model/favorite.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../item/item_details_screen.dart';
import '../userPreferences/current_user.dart';

class FavoritesFragmentScreen extends StatelessWidget {
   FavoritesFragmentScreen({Key? key}) : super(key: key);
   final currentUserOnline = Get.put(CurrentUser());

   Future<List<Favorite>> readFavourite() async{

    List<Favorite>  favoriteList = [];

     try{
       var res = await http.post(
         Uri.parse(API.readFavourite),
         body: {
           "user_id" : currentUserOnline.user.user_id.toString()
         }
       );

       if (res.statusCode == 200)
       {

         var responseBodyOfGetCurrentUserFavoriteItems = jsonDecode(res.body);

         if (responseBodyOfGetCurrentUserFavoriteItems['success'] == true)
         {
           (responseBodyOfGetCurrentUserFavoriteItems['data'] as List).forEach((eachCurrentFavoriteItemData)
           {
             favoriteList.add(Favorite.fromJson(eachCurrentFavoriteItemData));
           });
         }
         else
         {
           Fluttertoast.showToast(msg: "Error Occurred while executing query");
         }
       }
       else
       {
         Fluttertoast.showToast(msg: "Status Code is not 200");
       }

     }catch(e){
       debugPrint(e.toString());
     }

     return favoriteList;
   }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
              padding:EdgeInsets.fromLTRB(16, 24, 8, 8) ,
            child: Text(
              "My favorite List:",
              style: TextStyle(
                color: Colors.purpleAccent,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Padding(
            padding:EdgeInsets.fromLTRB(16, 24, 8, 8) ,
            child: Text(
              "Order this best clothes for yourself now",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
         const  SizedBox(height: 24,),

          //displaying favourite
          allFavoriteItemsWidget(context),

        ],
      ),
    );
  }

  Widget allFavoriteItemsWidget(context){

     return FutureBuilder(
         future: readFavourite(),
         builder: (context, AsyncSnapshot<List<Favorite>> dataSnapShot) {
           //check of we have network
           if (dataSnapShot.connectionState == ConnectionState.waiting) {
             return const Center(
               child: CircularProgressIndicator(),
             );
           }

           //check if data is empty
           if (dataSnapShot.data == null) {
             return const Center(
               child: Text(
                 "No favorite found",
                 style: TextStyle(
                   color: Colors.grey,
                 ),
               ),
             );
           }

           if(dataSnapShot.data!.length > 0){

             return ListView.builder(
               itemCount: dataSnapShot.data!.length,
               shrinkWrap: true,
               physics: const NeverScrollableScrollPhysics(),
               scrollDirection: Axis.vertical,
               itemBuilder: (context,index){
                 Favorite eachFavoriteItemRecord = dataSnapShot.data![index];

                 return GestureDetector(
                   onTap: (){
                     // Get.to(ItemDetailsScreen(itemInfo: eachFavoriteItemRecord));
                   },
                   child: Container(
                     margin: EdgeInsets.fromLTRB(
                       16,
                       index == 0 ? 16 : 8 ,
                       16,
                       index == dataSnapShot.data!.length - 1 ? 16 : 8 ,
                     ),
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(20),
                         color: Colors.black,
                         boxShadow: const [
                           BoxShadow(
                             offset: Offset(0,0),
                             blurRadius: 6,
                             color: Colors.grey,
                           ),
                         ]

                     ),
                     child: Row(
                       children: [
                         //name + price + tags
                         Expanded(
                           child: Padding(
                             padding: const EdgeInsets.only(left: 15),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 //name and price
                                 Row(
                                   children: [
                                     //name
                                     Expanded(
                                       child: Text(
                                         eachFavoriteItemRecord.name!,
                                         maxLines: 2,
                                         overflow: TextOverflow.ellipsis,
                                         style: const TextStyle(
                                           fontWeight: FontWeight.bold,
                                           fontSize: 16,
                                           color: Colors.grey,
                                         ),
                                       ),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.only(left:12,right: 12),
                                       child: Text(
                                         "₦"+eachFavoriteItemRecord.price.toString(),
                                         maxLines: 2,
                                         overflow: TextOverflow.ellipsis,
                                         style: const TextStyle(
                                           fontWeight: FontWeight.bold,
                                           fontSize: 16,
                                           color: Colors.purpleAccent,
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),
                                 const SizedBox(height: 16,),
                                 Text(
                                   "Tags: \n "+eachFavoriteItemRecord.tags.toString().replaceAll("[", "").replaceAll("]", ""),
                                   maxLines: 2,
                                   overflow: TextOverflow.ellipsis,
                                   style: const TextStyle(
                                     fontWeight: FontWeight.bold,
                                     fontSize: 12,
                                     color: Colors.grey,
                                   ),
                                 ),

                               ],
                             ),

                           ),
                         ),

                         //images clothes
                         ClipRRect(
                           borderRadius: const BorderRadius.only(
                             bottomRight: Radius.circular(20),
                             topRight: Radius.circular(20),
                           ),
                           child: FadeInImage(
                             height: 130,
                             width: 130,
                             fit: BoxFit.cover,
                             placeholder: const AssetImage("images/place_holder.png"),
                             image: NetworkImage(
                               eachFavoriteItemRecord.image!,
                             ),
                             imageErrorBuilder: (context,error,stackTraceError){
                               return const Center(
                                 child: Icon(
                                   Icons.broken_image_outlined,
                                 ),
                               );
                             },
                           ),
                         ),
                       ],
                     ),
                   ),
                 );
               },
             );
           }
           else {
             return const Center(
               child: Text("Empty, No data"),
             );
           }
         }
     );
   }

}

