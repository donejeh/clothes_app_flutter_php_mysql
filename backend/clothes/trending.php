<?php
require_once "../db.php";

$minRating = 3.4;
$limitClotheItem = 5;

$sqlQuery = "SELECT * FROM items WHERE rating >= '$minRating' ORDER BY rating DESC LIMIT $limitClotheItem";

$result = $con->query($sqlQuery);

if($result->num_rows > 0){

    $itemsDetails = array();

    while($row = $result->fetch_assoc()){

        $itemsDetails[] = $row;
    }

    echo json_encode(array("success"=> true, "clothItemsData"=> $itemsDetails));

}else{
    echo json_encode(array("success"=> false));
}


?>