import 'dart:convert';

import 'package:clothes/users/model/Clothes.dart';
import 'package:clothes/users/userPreferences/current_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../api/api_connect.dart';
import '../controllers/cart_list_controller.dart';
import '../model/cart.dart';
import 'package:http/http.dart' as http;

class CartListScreen extends StatefulWidget {
  const CartListScreen({Key? key}) : super(key: key);

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {

  final currentOnlineUser = Get.put(CurrentUser());
  final cartListController = Get.put(CartListController());

  getCurrentUserCartList() async
  {
    List<Cart> cartListOfCurrentUser = [];

    try
    {
      var res = await http.post(
          Uri.parse(API.getCartList),
          body:
          {
            "currentOnlineUserID": currentOnlineUser.user.user_id.toString(),
          }
      );

      if (res.statusCode == 200)
      {
        var responseBodyOfGetCurrentUserCartItems = jsonDecode(res.body);

        if (responseBodyOfGetCurrentUserCartItems['success'] == true)
        {
          (responseBodyOfGetCurrentUserCartItems['data'] as List).forEach((eachCurrentUserCartItemData)
          {
            cartListOfCurrentUser.add(Cart.fromJson(eachCurrentUserCartItemData));
          });
        }
        else
        {
          Fluttertoast.showToast(msg: "Your cart is empty");
        }

        cartListController.setList(cartListOfCurrentUser);

      }
      else
      {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    }
    catch(errorMsg)
    {
      Fluttertoast.showToast(msg: "Error:: " + errorMsg.toString());
    }
    calculateTotalAmount();
  }

  calculateTotalAmount(){
    cartListController.setTotal(0);

    print(cartListController.selectedItemList);
    if(cartListController.selectedItemList.isNotEmpty)
    {
      cartListController.cartList.forEach((itemInCart)
      {

        if(cartListController.selectedItemList.contains(itemInCart.cart_id))
        {
          print(itemInCart.price);

          double eachItemTotalAmount = (itemInCart.price!) * (double.parse(itemInCart.quantity.toString()));

          cartListController.setTotal(cartListController.total + eachItemTotalAmount);
        }
      });
    }

  }

  updateQuantityInUserCart(int cartID , double quantity) async {

    try{
      var res = await http.post(
          Uri.parse(API.updateItemInCartList),
          body: {"cart_id": cartID.toString(),
            "quantity": quantity.toString(),}
      );

      if(res.statusCode ==200){
        var responseBody = jsonDecode(res.body);

        if(responseBody['success']== true){

          getCurrentUserCartList();
        }else{
          Fluttertoast.showToast(msg: responseBody['message']);
        }

      }else{

        Fluttertoast.showToast(msg: "Error from php");
      }

    }catch(e){
      // print('Error: ');
      print("${e.toString()}");
    }

  }
  deleteSelectedItemFromUserCartlist(int cartID) async{
    try{
      var res = await http.post(
        Uri.parse(API.deleteItemFormCartList),
          body: {"cart_id": cartID.toString()}
       // body: {"cart_id": jsonEncode(cartID)}
      );
     // print(res.body);

      if(res.statusCode ==200){
        var responseBody = jsonDecode(res.body);
        if(responseBody['success']== true){
        //  print(responseBody['message']);
         // Fluttertoast.showToast(msg: responseBody['message']);
          getCurrentUserCartList();
        }else{
          Fluttertoast.showToast(msg: responseBody['message']);
        }

      }else{

        Fluttertoast.showToast(msg: "Error from php");
      }

    }catch(e){
     // print('Error: ');
      print("${e.toString()}");
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserCartList();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "My Cart"
        ),
        actions: [
          Obx(() =>

          //select all items on cart
          IconButton(
              onPressed: (){
                cartListController.setIsSelectedAllItems();
                cartListController.clearAllSelectedItems();

                if(cartListController.isSelectedAll){
                  cartListController.cartList.forEach((eachItem) {

                    cartListController.addSelectedItem(eachItem.cart_id!);

                  });

                }
                calculateTotalAmount();

              },
              icon: Icon(
                cartListController.isSelectedAll ? Icons.check_box : Icons.check_box_outline_blank,
                color: cartListController.isSelectedAll ? Colors.white : Colors.grey ,
              ),
          ),),

          //to delete selected item/items
          GetBuilder(
            init: CartListController(),
              builder: (c){

              if(cartListController.selectedItemList.isNotEmpty){
                return IconButton(
                  onPressed: () async{

                  var responseFromDialogBox = await Get.dialog(
                    AlertDialog(
                      backgroundColor: Colors.grey,
                      title: Text("Delete"),
                      content: Text("Are you sure you want to delete selected Item?"),
                      actions: [
                        TextButton(
                            onPressed: (){
                              Get.back();

                            }, child: const Text(
                          "NO",
                          style: TextStyle(
                            color: Colors.black,

                          ),
                        ),

                        ),


                        TextButton(
                          onPressed: (){
                            Get.back(result: "yesDelete");

                          }, child: const Text(
                          "YES",
                          style: TextStyle(
                            color: Colors.black,

                          ),
                        ),

                        ),
                      ],
                    )
                  );
                  if(responseFromDialogBox =="yesDelete"){

                    List id = [];
                    //delete selected items now
                    cartListController.selectedItemList.forEach((eachselectedUserCartID) {

                      deleteSelectedItemFromUserCartlist(eachselectedUserCartID);
                    // id.add(selectedItem);

                    });


                   // print(id);
                   // deleteSelectedItemFromUserCartlist(id);
                    calculateTotalAmount();

                  }else{

                  }

                },
                  icon: const Icon(
                  Icons.delete_sweep,
                  size: 30,
                  color: Colors.redAccent,
                ),
                );
              }else{
                return Container();
              }
              }
              ),
        ],
      ),
      body: Obx(() =>
      cartListController.cartList.isNotEmpty ?
      ListView.builder(
        itemCount: cartListController.cartList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index){
          Cart cartModel = cartListController.cartList[index];
          Clothes clothesModel = Clothes(
            item_id: cartModel.item_id,
            name: cartModel.name,
            rating: cartModel.rating,
            tags: cartModel.tags,
            price: cartModel.price,
            sizes: cartModel.sizes,
            colors: cartModel.colors,
            description: cartModel.description,
            image: cartModel.image
          );

          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [

                //check box
                GetBuilder(
                  init: CartListController(),
                  builder:(c){

                  return IconButton(
                    onPressed: (){
                      if(cartListController.selectedItemList.contains(cartModel.cart_id))
                      {
                        cartListController.deleteSelectedItem(cartModel.cart_id!);
                      }
                      else
                      {
                        cartListController.addSelectedItem(cartModel.cart_id!);
                      }

                      calculateTotalAmount();

                    //  print(cartListController.total);

                    },
                    icon: Icon(
                      cartListController.selectedItemList.contains(cartModel.cart_id)
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: cartListController.isSelectedAll ? Colors.white : Colors.grey,
                    ),

                  );
                },

                ),

                //name . color, size and price
                //+ 2 -
                Expanded(
                    child: GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                            0,
                            index== 0 ? 16 :8,
                            16, index == cartListController.cartList.length -1 ? 16 : 8 ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0,0),
                              blurRadius: 6,
                              color: Colors.white
                            ),
                          ],
                        ),
                        child: Row(
                          children: [

                            //name . color, size and price
                            //+ 2 -
                            Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      //name
                                      Text(
                                        clothesModel.name.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(height: 20,),

                                      //color size and price
                                      Row(
                                        children: [
                                          //color size
                                          Expanded(
                                              child: Text(
                                                "Color: ${cartModel.color!.replaceAll('[', '').replaceAll(']', '')}\nSize: ${cartModel.size!.replaceAll('[', '').replaceAll(']', '')}",
                                                maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.grey
                                                ),
                                              ),

                                          ),

                                          //price
                                           Padding(
                                              padding: const EdgeInsets.only(
                                                left: 12,
                                                right: 12.0,
                                              ),
                                            child: Text(
                                              "\$${clothesModel.price}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.purpleAccent,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20,),

                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [


                                          IconButton(
                                              onPressed: (){
                                                if(cartModel.quantity! -1 >= 1){
                                                  updateQuantityInUserCart(
                                                    cartModel.cart_id!,
                                                    cartModel.quantity! -1,
                                                  );
                                                }

                                              },
                                              icon: const Icon(
                                                Icons.remove_circle_outline,
                                                color:  Colors.grey,
                                                size: 30,
                                              ),),

                                          const SizedBox(width: 20,),

                                          Text(
                                            cartModel.quantity.toString(),
                                            style: const TextStyle(
                                              color: Colors.purpleAccent,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          const SizedBox(width: 20,),

                                          // + button
                                          IconButton(
                                              onPressed: (){

                                                if(cartModel.quantity! + 1 >= 1){
                                                  updateQuantityInUserCart(
                                                    cartModel.cart_id!,
                                                    cartModel.quantity! + 1,
                                                  );
                                                }

                                              },
                                              icon: const Icon(
                                                Icons.add_circle_outline,
                                                color:  Colors.grey,
                                                size: 30,
                                              )),
                                        ],
                                      ),

                                    ],
                                  ),
                                )),
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(22),
                                topRight: Radius.circular(22),
                              ),
                              child: FadeInImage(
                                height: 180,
                                width: 150,
                                fit: BoxFit.cover,
                                placeholder: const AssetImage("images/place_holder.png"),
                                image: NetworkImage(
                                  cartModel.image!,
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
                    ),),
              ],
            ),
          );
        },
      ) : const Center(
        child: Text("Cart is empty",
        style: TextStyle(
          color: Colors.purpleAccent,
          fontSize: 40,
          fontWeight: FontWeight.bold
        ),),
      ),),
      bottomNavigationBar: GetBuilder(
        init: cartListController,
        builder: (c){
          return Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0,1),
                  color: Colors.white24,
                  blurRadius: 6
                )
              ]
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8
            ),
            child: Row(
              children: [
                const Text("Total amount",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white
                ),
                ),

                const SizedBox(width: 4,),

                Obx(() =>

                Text(
                "\$${cartListController.total.toStringAsFixed(2)}",
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.purpleAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                ),),

                const Spacer(),

                Material(
                  color: cartListController.selectedItemList.isNotEmpty ? Colors.purpleAccent : Colors.white24,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: (){
                      print(cartListController.total);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8
                      ),
                      child: Text(
                        "Order Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),

    );
  }
}
