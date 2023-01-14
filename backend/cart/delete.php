<?php
require_once "../db.php";

$cartID  = $_POST['cart_id'];
//$cartID  = json_decode($_POST['cart_id']);

//$ids = implode("','", $cartID);

$query = "DELETE FROM cart WHERE cart_id='$cartID'";

$result = $con->query($query);

if($result){
    echo json_encode(array("success"=> true, "message"=>"Deleted successfully"));
}else{
    echo json_encode(array("success"=> false, "message"=>"Error Deleting cart"));
}


?>