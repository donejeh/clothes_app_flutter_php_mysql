class API{
  static const HOST_PATH = "http://192.168.3.32/clothes/backend";

  static const USER_ENDPOINT ="$HOST_PATH/user";
  static const ADMIN_ENDPOINT ="$HOST_PATH/admin";
  static const ITEMS_ENDPOINT ="$HOST_PATH/items";
  static const CLOTHES_ENDPOINT ="$HOST_PATH/clothes";
  static const CART_ENDPOINT ="$HOST_PATH/cart";
  static const FAV_ENDPOINT ="$HOST_PATH/favourite";

  //sign up users
  static const signUp = "$USER_ENDPOINT/signup.php";
  static const validate_email = "$USER_ENDPOINT/validate_email.php";
  static const login = "$USER_ENDPOINT/login.php";

  //sign in admin
  static const adminLogin = "$ADMIN_ENDPOINT/login.php";
  //upload items
  static const uploadItems = "$ITEMS_ENDPOINT/upload.php";

  //Clothers
  static const getRatedClothes = "$CLOTHES_ENDPOINT/trending.php";
  static const getAllClothes = "$CLOTHES_ENDPOINT/all.php";

  //cart endpoint
  static const addToCard = "$CART_ENDPOINT/add.php";
  static const getCartList = "$CART_ENDPOINT/read.php";
  static const deleteItemFormCartList = "$CART_ENDPOINT/delete.php";
  static const  updateItemInCartList = "$CART_ENDPOINT/update.php";

  //favourite
  static const  addFavourite = "$FAV_ENDPOINT/add.php";
  static const  readFavourite = "$FAV_ENDPOINT/read.php";
  static const  deleteFavourite = "$FAV_ENDPOINT/delete.php";
  static const  validateFavourite = "$FAV_ENDPOINT/validate_favourite.php";



  static const clientImgurID = "Client-ID "+"b2138d35a146dec";
  static const imgurURL = "https://api.imgur.com/3/image";


  //Client ID:
 // b2138d35a146dec
  //Client secret:
  //36b832aa2f40886e366951ea2cabd4cd6c6f280e

}