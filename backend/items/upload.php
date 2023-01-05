<?php 
require_once "../db.php";

$name  = $_POST['name'];
$rating  = $_POST['rating'];
$tags = $_POST['tags'];
$price = $_POST['price'];
$sizes = $_POST['sizes'];
$colors = $_POST['colors'];
$description = $_POST['description'];
$image = $_POST['image'];


$query = "INSERT INTO items SET name ='$name', rating
                    ='$rating', tags ='$tags' , price ='$price' , sizes ='$sizes'
                    , colors ='$colors', description ='$description', image ='$image' ";

$result = $con->query($query);

if($result){
    echo json_encode(array("success"=> true, "message"=>"item created successfully"));
}else{
    echo json_encode(array("success"=> false, "message"=>"Error creating item"));
}


?>