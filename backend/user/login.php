<?php
require_once "../db.php";

//$name  = $_POST['user_name'];
$email  = $_POST['user_email'];
$password = md5($_POST['user_password']);


$query = $con->query("SELECT * FROM users WHERE user_email='$email' AND user_password='$password' ");

if($query->num_rows > 0){

    $userDetails = array();

    while($row = $query->fetch_assoc()){

        $userDetails[] = $row;
    }

    echo json_encode(array("success"=> true, "userData"=> $userDetails[0]));

}else{
    echo json_encode(array("success"=> false));
}


?>