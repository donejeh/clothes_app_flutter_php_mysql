<?php
require_once "../db.php";


$sqlQuery = "SELECT * FROM items ORDER BY item_id  DESC ";

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