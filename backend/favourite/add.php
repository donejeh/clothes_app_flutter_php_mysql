<?php 
require_once "../db.php";

$user_id  = $_POST['user_id'];
$item_id  = $_POST['item_id'];



$query = "INSERT INTO favourite SET user_id ='$user_id', item_id='$item_id'";

$result = $con->query($query);

if($result){
    echo json_encode(array("success"=> true, "message"=>"favourite added successfully"));
}else{
    echo json_encode(array("success"=> false, "message"=>$quantity));
}


?>