<?php
    $conn = mysqli_connect('localhost','root','','palestra_sito');

    $blocchi = array();

    $query = "SELECT * FROM blocco_homepage";
    $res = mysqli_query($conn, $query);

    while($row = mysqli_fetch_assoc($res)){
        $blocchi[] = $row;
    }

    mysqli_free_result($res);
    mysqli_close($conn);

    echo json_encode($blocchi);

?>