<?php
require_once "../db.php";

$favourite_id   = $_POST['favourite_id'];
//$cartID  = json_decode($_POST['cart_id']);

//$ids = implode("','", $cartID);

$query = "DELETE FROM favourite WHERE favourite_id ='$favourite_id'";

$result = $con->query($query);

if($result){
    echo json_encode(array("success"=> true, "message"=>"Deleted successfully"));
}else{
    echo json_encode(array("success"=> false, "message"=>"Error Deleting cart"));
}


?>