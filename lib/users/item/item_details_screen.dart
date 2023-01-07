import 'package:clothes/users/model/Clothes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../controllers/item_details_controller.dart';

class ItemDetailsScreen extends StatefulWidget {

  final Clothes? itemInfo;

  const ItemDetailsScreen({this.itemInfo,});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  
  final itemDetailsController = Get.put(ItemDetailsController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          //items images
          FadeInImage(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder: const AssetImage("images/place_holder.png"),
            image: NetworkImage(
              widget.itemInfo!.image!,
            ),
            imageErrorBuilder: (context,error,stackTraceError){
              return const Center(
                child: Icon(
                  Icons.broken_image_outlined,
                ),
              );
            },
          ),

          //items infomation
          Align(
            alignment: Alignment.bottomCenter,
            child: itemInfoWidget(),
          ),
        ],
      ),
    );
  }

  itemInfoWidget(){
    return Container(
      height: MediaQuery.of(Get.context!).size.height * 0.6,
      width:MediaQuery.of(Get.context!).size.height,
      decoration:const BoxDecoration(
        color: Colors.black,
        borderRadius:  BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
          offset: Offset(0, -3),
            blurRadius: 6,
            color: Colors.purpleAccent,
      ),
        ]
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18,),
            Center(
              child: Container(
                height: 8,
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.circular(30),

                ),
              ),
            ),
            const SizedBox(height: 30,),

            //name
            Text(
              widget.itemInfo!.name!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.purpleAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10,),

            // items counter
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //items rating + number of rating
                // tags
                // price
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //rating + raating num
                      Row(
                        children: [
                          //rating bar
                          RatingBar.builder(
                            initialRating: widget.itemInfo!.rating!,
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

                          //rating number

                          SizedBox(width: 8,),
                          Text(
                            "("+ widget.itemInfo!.rating.toString()+")",
                            style: TextStyle(
                              color: Colors.purpleAccent,
                            ),
                          ),

                        ],
                      ),

                      //tags
                      const SizedBox(height: 10,),

                      Text(
                        widget.itemInfo!.tags!.toString().replaceAll("[", "").replaceAll("]", ""),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16,),
                      //price
                      Text(
                        "₦"+widget.itemInfo!.price.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.purpleAccent,
                        ),
                      ),
                    ],
                    ),
                ),

                //items counter
                Obx(() =>
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // + button
                        IconButton(
                          onPressed: (){
                            itemDetailsController.setQuantity(itemDetailsController.quantity + 1);

                          },
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,),
                        ),

                        Text(
                          itemDetailsController.quantity.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.bold,
                          ),
                          // - button

                        ),

                        IconButton(
                          onPressed: (){
                            if(itemDetailsController.quantity - 1 >= 1){
                              itemDetailsController.setQuantity(itemDetailsController.quantity - 1);
                            }else{
                              Fluttertoast.showToast(msg: "Quantity must be 1 or greater than 1");
                            }
                          },
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.white,),
                        ),
                      ],
                    ),
                ),

              ],
            ),

            //size of the items
            Text("Size",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.purpleAccent,
              fontSize: 18,
            ),
            ),

            const SizedBox(height: 8,),

          Wrap(
            runSpacing: 8,
            spacing: 8,
            children: List.generate(widget.itemInfo!.sizes!.length, (index) {

              return Obx(() => GestureDetector(
                onTap: (){


              },
                child: Container(
                  height: 35,
                    width: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: itemDetailsController.size == index
                          ? Colors.transparent
                          : Colors.grey,
                    ),
                    color: itemDetailsController.size == index
                      ? Colors.purpleAccent.withOpacity(0.2)
                        : Colors.white,
                  ),
                ),
              ),
              );
            }),
          ),

          ],
        ),
      ),
    );
  }
}
