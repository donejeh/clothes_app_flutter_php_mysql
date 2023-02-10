<?php
require_once "../db.php";

$search  = $_POST['typeKeywords'];



$query = $con->query("SELECT * FROM items WHERE name LIKE '%$search%'");

if($query->num_rows > 0){

    $userDetails = array();

    while($row = $query->fetch_assoc()){

        $data[] = $row;
    }

    echo json_encode(array("success"=> true, "data"=> $data));

}else{
    echo json_encode(array("success"=> false));
}


?>