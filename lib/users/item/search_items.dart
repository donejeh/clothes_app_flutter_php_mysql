import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../api/api_connect.dart';
import '../cart/cart_list_screen.dart';
import '../model/Clothes.dart';
import '../model/item.dart';
import 'item_details_screen.dart';

class SearchItems extends StatefulWidget {

  final String? typeKeywords;
  const SearchItems({Key? key, this.typeKeywords}) : super(key: key);


  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {

  final TextEditingController searchController = TextEditingController();


  Future<List<Clothes>> readSearchRecordsFound() async {

    List<Clothes> clothesSearchList = [];

    if(searchController.text != ""){


      try{
        var res = await http.post(
            Uri.parse(API.searchItems),
            body: {
              "typeKeywords" : searchController.text.toString()
            }
        );

        if (res.statusCode == 200)
        {

          var responseBodyOfGetCurrentUserFavoriteItems = jsonDecode(res.body);

          if (responseBodyOfGetCurrentUserFavoriteItems['success'] == true)
          {
            (responseBodyOfGetCurrentUserFavoriteItems['data'] as List).forEach((eachCurrentFavoriteItemData)
            {
              clothesSearchList.add(Clothes.fromJson(eachCurrentFavoriteItemData));
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

    }

    return clothesSearchList;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    searchController.text = widget.typeKeywords!;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white24,
        title: showSearchBarWidget(),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.purpleAccent,
          ),
        ),
      ),
      body: searchItemsWidget(context),
    );
  }

  //search bar
  Widget showSearchBarWidget(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: (){

              setState(() {

              });

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
            searchController.clear();

            setState(() {

            });
            },
            icon: const Icon(
              Icons.close,
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

  Widget searchItemsWidget(context){

    return FutureBuilder(
        future: readSearchRecordsFound(),
        builder: (context, AsyncSnapshot<List<Clothes>> dataSnapShot) {
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
                  "No item found"
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
                Clothes eachClothItemRecord = dataSnapShot.data![index];

                return GestureDetector(
                  onTap: (){
                    Get.to(ItemDetailsScreen(itemInfo: eachClothItemRecord));
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
                                        eachClothItemRecord.name!,
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
                                        "₦"+eachClothItemRecord.price.toString(),
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
                                  "Tags: \n "+eachClothItemRecord.tags.toString().replaceAll("[", "").replaceAll("]", ""),
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
                              eachClothItemRecord.image!,
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
