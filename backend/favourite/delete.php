<?php
require_once "../db.php";

$user_id  = $_POST['user_id'];
$item_id  = $_POST['item_id'];


$query = "DELETE FROM favourite WHERE user_id ='$user_id' AND item_id='$item_id'";

$result = $con->query($query);

if($result){
    echo json_encode(array("success"=> true, "message"=>"Deleted successfully"));
}else{
    echo json_encode(array("success"=> false, "message"=>"Error Deleting cart"));
}


?>