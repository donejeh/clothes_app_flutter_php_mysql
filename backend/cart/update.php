<?php
require_once "../db.php";

$cartID  = $_POST['cart_id'];
$quantity  = $_POST['quantity'];
//$cartID  = json_decode($_POST['cart_id']);

//$ids = implode("','", $cartID);

$query = "UPDATE cart set quantity='$quantity' WHERE cart_id='$cartID'";

$result = $con->query($query);

if($result){
    echo json_encode(array("success"=> true, "message"=>"Deleted successfully"));
}else{
    echo json_encode(array("success"=> false, "message"=>"Error Deleting cart"));
}


?>