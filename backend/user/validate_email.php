<?php
require_once "../db.php";

$email = $_POST["email"];

$query = $con->query("SELECT * FROM users WHERE user_email='$email' ");

if($query->num_rows > 0){

    echo json_encode(array("emailFound"=> true));

}else{
    echo json_encode(array("emailFound"=> false));
}


?>
