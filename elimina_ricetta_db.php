<?php
    session_start();

    $esito = array();

    $username = $_SESSION['username'];

    $conn = mysqli_connect('localhost','root','','palestra_sito');

    $ricetta = mysqli_real_escape_string($conn,$_GET['r']);

    $query = "DELETE FROM ricetta WHERE username='$username' AND nome='$ricetta'";
    $res = mysqli_query($conn, $query);
    
    $esito['ricetta'] = $ricetta;
    $esito['conferma'] = $res;

    mysqli_close($conn);
    echo json_encode($esito);
?>