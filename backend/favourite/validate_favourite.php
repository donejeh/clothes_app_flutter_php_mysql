<?php
require_once "../db.php";


$user_id  = $_POST['user_id'];
$item_id  = $_POST['item_id'];


$query = $con->query("SELECT * FROM favourite WHERE user_id='$user_id' and item_id='$item_id'");

if($query->num_rows > 0){

    echo json_encode(array("favouriteFound"=> true));

}else{
    echo json_encode(array("favouriteFound"=> false));
}


?>
