<?php
    session_start();

    $conn = mysqli_connect('localhost', 'root', '', 'palestra_sito');

    $abbonamenti = array();

    $username = mysqli_real_escape_string($conn,$_SESSION['username']);

    $query = "SELECT * FROM abbonamento a WHERE a.cliente = (SELECT c.ID FROM cliente c WHERE c.username = '".$username."')";
    $res = mysqli_query($conn, $query);

    while($row = mysqli_fetch_assoc($res)){
        $abbonamenti[] = $row;
    }

    mysqli_free_result($res);
    mysqli_close($conn);

    echo json_encode($abbonamenti);
?>