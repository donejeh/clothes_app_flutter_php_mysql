<?php 
require_once "../db.php";

$currentOnlineUserId = $_POST['user_id'];


$query = $con->query("SELECT * FROM favourite CROSS JOIN items WHERE favourite.item_id=items.item_id AND favourite.user_id='$currentOnlineUserId'");
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