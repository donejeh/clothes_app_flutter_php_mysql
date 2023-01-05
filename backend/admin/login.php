<?php
require_once "../db.php";

//$name  = $_POST['user_name'];
$email  = $_POST['admin_email'];
$password = $_POST['admin_password'];


$query = $con->query("SELECT * FROM admin WHERE admin_email='$email' AND admin_password='$password' ");

if($query->num_rows > 0){

    $adminDetails = array();

    while($row = $query->fetch_assoc()){

        $adminDetails[] = $row;
    }

    echo json_encode(array("success"=> true, "adminData"=> $adminDetails[0]));

}else{
    echo json_encode(array("success"=> false));
}


?>