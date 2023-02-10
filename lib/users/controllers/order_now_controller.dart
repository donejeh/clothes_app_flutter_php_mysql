import 'package:get/get.dart';

class OderNowController extends GetxController{

  RxString _deliverySystem = "FedEx".obs;
  RxString _paymentSystem = "Apple Pay".obs;


  String get deliverySys =>  _deliverySystem.value;
  String get paymentSys =>  _paymentSystem.value;

  setDeliverySystem(String newDeliverySystem){
    _deliverySystem.value = newDeliverySystem;
  }

  setPaymentSystem(String newPaymentSystem){
    _paymentSystem.value = newPaymentSystem;
  }

}