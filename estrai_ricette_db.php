<?php    
    session_start();

    $conn = mysqli_connect('localhost','root','','palestra_sito');

    $username = mysqli_real_escape_string($conn, $_SESSION['username']);
    
    $ricette = array();

    $query = "SELECT * FROM ricetta r WHERE r.username = '$username'";
    $res = mysqli_query($conn, $query);

    while($row = mysqli_fetch_assoc($res)){
        $ricette[] = $row;
    }

    mysqli_close($conn);
    echo json_encode($ricette);
?>
