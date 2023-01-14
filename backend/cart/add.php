<?php 
require_once "../db.php";

$user_id  = $_POST['user_id'];
$item_id  = $_POST['item_id'];
$size = $_POST['size'];
$color = $_POST['color'];
$quantity = $_POST['quantity'];



$query = "INSERT INTO cart SET user_id ='$user_id', item_id='$item_id', size ='$size', color ='$color', quantity ='$quantity'";

$result = $con->query($query);

if($result){
    echo json_encode(array("success"=> true, "message"=>"cart added successfully"));
}else{
    echo json_encode(array("success"=> false, "message"=>$quantity));
}


?>