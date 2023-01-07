import 'package:get/get.dart';

class ItemDetailsController extends GetxController{
   RxInt _itemQuanty = 1.obs;
   RxInt _itemSize = 0.obs;
   RxInt _itemColor = 0.obs;
   RxBool _isFavorite = false.obs;

  int get quantity => _itemQuanty.value;
  int get size => _itemSize.value;
  int get color => _itemColor.value;
  bool get isFavorite => _isFavorite.value;

  setQuantity(int quantityOfItem){
    _itemQuanty.value = quantityOfItem;
  }

  setSize(int sizeOfItem){
    _itemSize.value = sizeOfItem;
  }

  setColor(int colorOfItem){
    _itemColor.value = colorOfItem;
  }

  setFavorite(bool favouriteOfItem){
    _isFavorite.value = favouriteOfItem;
  }
}