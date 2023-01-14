<?php 
require_once "../db.php";

$currentOnlineUserId = $_POST['currentOnlineUserID'];


$query = $con->query("SELECT * FROM items CROSS JOIN cart WHERE items.item_id=cart.item_id AND cart.user_id='$currentOnlineUserId'");
//$query = $con->query("SELECT * FROM items,cart WHERE items.item_id=cart.item_id AND cart.item_id='$currentOnlineUserId'");


if($query->num_rows > 0){

    $userDetails = array();

    while($row = $query->fetch_assoc()){

        $userDetails[] = $row;
    }

    echo json_encode(array("success"=> true, "data"=> $userDetails));

}else{
    echo json_encode(array("success"=> false));
}



?>