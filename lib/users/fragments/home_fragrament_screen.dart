import 'dart:convert';

import 'package:clothes/users/model/Clothes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../api/api_connect.dart';

class HomeFragmentScreen extends StatelessWidget {
  HomeFragmentScreen({Key? key}) : super(key: key);

  final TextEditingController searchController = TextEditingController();

  Future<List<Clothes>> getTrendingClothItems() async{

    List<Clothes> trendingClothItemList = [];

    try{
      
     var res = await http.post(
        Uri.parse(API.getRatedClothes),
      );

     if(res.statusCode == 200){
       var responseBodyOfTrendingItems = jsonDecode(res.body);


       if(responseBodyOfTrendingItems["success"]==true){
         (responseBodyOfTrendingItems["clothItemsData"] as List).forEach((eachRecord) { 
           trendingClothItemList.add(Clothes.fromJson(eachRecord));
         });
       }

     }else{
       Fluttertoast.showToast(msg: "Error on the server");
     }

    }catch(e){
      print("Error::"+ e.toString());
    }
    return trendingClothItemList;
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16,),
          //search bar widget
          showSearchBarWidget(),
          const SizedBox(height: 16,),
          //tending-popular items
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              "Trending",
              style: TextStyle(
                color: Colors.purpleAccent,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          trendingMostPopularClothesItemWidget(context),

          const SizedBox(height: 16,),
          //all new Colloection Items
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              "New Collections",
              style: TextStyle(
                color: Colors.purpleAccent,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          )
        ],
      ),
    );
  }


  //search bar
  showSearchBarWidget(){
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: (){

            },
            icon: const Icon(
              Icons.search,
              color: Colors.purpleAccent,
            ),
          ),
          hintText: "Search best clothes here....",
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          suffixIcon: IconButton(
            onPressed: (){

            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.purpleAccent,
            ),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.purpleAccent,
            )
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Colors.purpleAccent,
              )
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Colors.green,
              )
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10
          ),
          //filled: true,
          //fillColor: Colors.grey
        ),
      ),
    );
  }

  Widget trendingMostPopularClothesItemWidget(context){
    return FutureBuilder(
        future: getTrendingClothItems(),
        builder: (context, AsyncSnapshot<List<Clothes>> dataSnapShot){
          //check of we have network
          if(dataSnapShot.connectionState ==ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
          
          print(dataSnapShot.data);

          //check if data is empty
          if(dataSnapShot.data == null){
            return const Center(
              child: Text(
                "No Trending item found"
              ),
            );
          }

          //check if the legnth of data
          if(dataSnapShot.data!.length > 0 ){
            return Container(
              height: 260,
              child: ListView.builder(
                itemCount: dataSnapShot.data!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index){
                    Clothes eachClothItemData =  dataSnapShot.data![index];

                    return GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        width: 200,
                        margin: EdgeInsets.fromLTRB(
                            index==0 ? 16 : 8,
                            10,
                            index == dataSnapShot.data!.length -1 ? 16 : 8,
                            10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black,
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0,3),
                              blurRadius: 6,
                              color: Colors.grey,
                            ),
                          ]

                        ),
                        child: Column(
                          children: [
                            //clothes images
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(22),
                                topRight: Radius.circular(22),
                              ),
                              child: FadeInImage(
                                  height: 150,
                                  width: 200,
                                  fit: BoxFit.cover,
                                  placeholder: const AssetImage("images/place_holder.png"),
                                  image: NetworkImage(
                                    eachClothItemData.image!,
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

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //name and price of items
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          eachClothItemData.name!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        eachClothItemData.price.toString(),
                                        style: const TextStyle(
                                          color: Colors.purpleAccent,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 8,),

                                  Row(
                                    children: [
                                      //rating star and rating number
                                      RatingBar.builder(
                                          initialRating: eachClothItemData.rating!,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemBuilder: (BuildContext context, int index) =>
                                           const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                        onRatingUpdate: (updatingRating){
                                        },
                                        ignoreGestures: true,
                                        unratedColor: Colors.grey,
                                        itemSize: 20,
                                      ),
                                        SizedBox(width: 8,),
                                      Text(
                                        "("+ eachClothItemData.rating.toString()+")",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),

                                    ],
                                  ),

                                ],

                              ),
                            ),
                          ],
                        ),
                      ) ,

                    );

                  }),
            );


          }else{
            return const Center(
              child: Text("Empty, No data"),
            );
          }
        },
    );
  }
}
