<?php
    session_start();

    $conn = mysqli_connect('localhost','root','','palestra_sito');

    $username = mysqli_real_escape_string($conn, $_SESSION['username']);

    $query = "SELECT * FROM cliente WHERE username = '".$username."'";
    $res = mysqli_query($conn, $query);

    $row = mysqli_fetch_assoc($res);

    mysqli_free_result($res);
    mysqli_close($conn);

    echo json_encode($row);
?>