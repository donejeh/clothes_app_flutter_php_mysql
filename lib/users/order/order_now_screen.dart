import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_now_controller.dart';

class OrderNowScreen extends StatelessWidget {

  final List<Map<String, dynamic>>? selectedCartListItemsInfo;
  final double? totalAmount;
  final List<int>? selectedCardIDs;
  //name of delivery
  List<String> deliverySystemNameList = ['FedEx', 'DHL','United Parcel Service','Local Nigeria'];
  List<String> paymentSystemNameList = ['Apple Pay', 'Wire Transfer','Google Pay', 'Paystack'];

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController shipmentAddressController = TextEditingController();
  TextEditingController noteToSellerController = TextEditingController();

  OderNowController oderNowController = Get.put(OderNowController());

  OrderNowScreen({super.key,
    this.selectedCartListItemsInfo,
    this.totalAmount,
    this.selectedCardIDs});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Order Now"),
        titleSpacing: 0,
      ),
      body: ListView(
        children: [
          //selected items from cart list
      //    displaySelectedItemsFromUserCart(),

          const SizedBox(height: 30,),

          //delivery system
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Delivery System",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(18.0),
            child: Column(
              children:  deliverySystemNameList.map((deliverySystemName) {
                return Obx(() =>
                    RadioListTile<String>(
                        tileColor: Colors.white24,
                        dense: true,
                        activeColor: Colors.purpleAccent,
                        title: Text(
                          deliverySystemName,
                          style: const TextStyle(fontSize: 16,color: Colors.white),
                        ),
                        value: deliverySystemName,
                        groupValue: oderNowController.deliverySys,
                        onChanged: (newDeliverySystem){
                          oderNowController.setDeliverySystem(newDeliverySystem!);
                        },
                    )
                );

              }).toList(),
            ),
          ),

          const SizedBox(height: 30,),
          //payment system

           Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Payment System",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 2,),

                Text(
                  "Company Account Number/ID",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white38,
                      fontWeight: FontWeight.bold
                  ),
                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children:  paymentSystemNameList.map((paymentSystemName) {
                return Obx(() =>
                    RadioListTile<String>(
                      tileColor: Colors.white24,
                      dense: true,
                      activeColor: Colors.purpleAccent,
                      title: Text(
                        paymentSystemName,
                        style: const TextStyle(fontSize: 16,color: Colors.white),
                      ),
                      value: paymentSystemName,
                      groupValue: oderNowController.paymentSys,
                      onChanged: (newPaymentSystem){
                        oderNowController.setPaymentSystem(newPaymentSystem!);
                      },
                    )
                );

              }).toList(),
            ),
          ),


          const SizedBox(height: 16,),
          //phone number
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Phone Number",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Padding(padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: TextField(
            style: TextStyle(
              color: Colors.white54
            ),
            controller: phoneNumberController,
            decoration: InputDecoration(
              hintStyle: TextStyle(
                color: Colors.white24,
              ),
              hintText: 'Any Contact Number...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.purpleAccent,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white24,
                  width: 2,
                ),
              ),
            ),
          ) ,
          ),
          const SizedBox(height: 16,),
          //shipping address
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Shipping Address",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Padding(padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: const TextStyle(
                  color: Colors.white54
              ),
              controller: shipmentAddressController,
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                  color: Colors.white24,
                ),
                hintText: 'Your Shippment Address...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.purpleAccent,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.white24,
                    width: 2,
                  ),
                ),
              ),
            ) ,
          ),
          const SizedBox(height: 16,),
          //note to seller
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Note to Seller: ",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Padding(padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: TextStyle(
                  color: Colors.white54
              ),
              controller: noteToSellerController,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Colors.white24,
                ),
                hintText: 'Any note you want to add...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.purpleAccent,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white24,
                    width: 2,
                  ),
                ),
              ),
            ) ,
          ),

          const SizedBox(height: 30,),

          //pay amount now button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16,),
            child: Material(
              color: Colors.purpleAccent,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: (){

                },
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "\$"+ totalAmount!.toStringAsFixed(2),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),

                     Spacer(),

                     const Text(
                        "Pay amount now",
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30,),
        ],
      ),
    );
  }

//    displaySelectedItemsFromUserCart {
//     return Column(
//       children: [
//         List.generate(selectedCartListItemsInfo!.length, (index){
//          Map<String, dynamic> eachSelectedItem =  selectedCartListItemsInfo![index];
//
//          return Container(
//
//   );
//   }),
//   ],
//       );
// }
}
