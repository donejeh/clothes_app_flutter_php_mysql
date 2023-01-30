<?php
require_once "../db.php";

$search  = $_POST['search'];



$query = $con->query("SELECT * FROM items WHERE name LIKE '%$search%'");

if($query->num_rows > 0){

    $userDetails = array();

    while($row = $query->fetch_assoc()){

        $userDetails[] = $row;
    }

    echo json_encode(array("success"=> true, "userData"=> $userDetails[0]));

}else{
    echo json_encode(array("success"=> false));
}


?>