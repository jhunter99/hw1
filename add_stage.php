<?php
    session_start();

    $stage = array();

    $conn = mysqli_connect('localhost','root','','palestra_sito');

    $username = mysqli_real_escape_string($conn, $_SESSION['username']);

    $query = "SELECT * FROM stage_organizzato so JOIN partecipa p
    ON so.nome = p.stage AND so.data = p.data AND so.istruttore_esterno = p.istruttore_esterno
    WHERE p.cliente = (SELECT c.ID FROM cliente c WHERE c.username = '".$username."')";
    $res = mysqli_query($conn, $query);

    while($row = mysqli_fetch_assoc($res)){
        $stage[] = $row;
    }

    mysqli_free_result($res);
    mysqli_close($conn);

    echo json_encode($stage);
?>