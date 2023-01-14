import 'package:get/get.dart';

import '../model/cart.dart';

class CartListController extends GetxController{

  final RxList<Cart> _cartList = <Cart>[].obs; //all user items in the cart //6
  final RxList<int> _selectedItemList = <int>[].obs; //select items to checkout by user
  final RxBool _isSelectedAll = false.obs;
  final RxDouble _total = 0.0.obs;

  List<Cart> get cartList => _cartList.value;
  List<int> get selectedItemList => _selectedItemList.value;
  bool get isSelectedAll => _isSelectedAll.value;
  double get total => _total.value;

  setList(List<Cart> list){
    _cartList.value = list;
  }

  addSelectedItem(int itemSelectedItemCartID){
    _selectedItemList.value.add(itemSelectedItemCartID);
    update();
  }

  deleteSelectedItem(int itemSelectedID){
    _selectedItemList.value.remove(itemSelectedID);
    update();
  }

  setIsSelectedAllItems(){
    _isSelectedAll.value = !_isSelectedAll.value;
  }

  clearAllSelectedItems(){
    _selectedItemList.value.clear();
    update();
  }

  setTotal(double overAllTotal){
    _total.value = overAllTotal;
  }


}