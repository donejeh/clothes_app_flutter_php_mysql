class API{
  static const HOST_PATH = "http://192.168.239.99/clothes_app";

  static const USER_ENDPOINT ="$HOST_PATH/user";
  static const ADMIN_ENDPOINT ="$HOST_PATH/admin";

  //sign up users
  static const signUp = "$USER_ENDPOINT/signup.php";
  static const validate_email = "$USER_ENDPOINT/validate_email.php";

  //sign in users
  static const login = "$USER_ENDPOINT/login.php";
}