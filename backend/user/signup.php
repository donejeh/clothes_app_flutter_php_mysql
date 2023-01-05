<?php
require_once "../db.php";

$name  = $_POST['user_name'];
$email  = $_POST['user_email'];
$password = md5($_POST['user_password']);


$query = "INSERT INTO users SET user_name ='$name', user_email ='$email',user_password ='$password' ";

$result = $con->query($query);

if($result){
    echo json_encode(array("success"=> true, "message"=>"User created successfully"));
}else{
    echo json_encode(array("success"=> false, "message"=>"Error creating user"));
}


?>