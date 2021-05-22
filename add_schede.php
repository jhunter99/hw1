<?php
    session_start();

    $conn = mysqli_connect('localhost','root','','palestra_sito');

    $schede = array();

    $username = mysqli_real_escape_string($conn, $_SESSION['username']);

    $query_intestazione = "SELECT d.nome AS nome_istruttore, d.cognome AS cognome_istruttore, s.data, s.obiettivo, s.durata, s.COD
    FROM scheda s JOIN dipendente d ON s.istruttore = d.ID 
    WHERE s.cliente = (SELECT c.ID FROM cliente c WHERE c.username = '".$username."')";

    $res_intestazione = mysqli_query($conn, $query_intestazione);

    while($row_intestazione = mysqli_fetch_assoc($res_intestazione)){
        $query_composizione = "SELECT c.esercizio, c.peso, c.serie, c.ripetizioni 
        FROM composizione c 
        WHERE c.scheda = '".$row_intestazione['COD']."'";

        $res_composizione = mysqli_query($conn, $query_composizione);

        $scheda = array('intestazione' => $row_intestazione, 'composizione' => array());

        while($row_composizione = mysqli_fetch_assoc($res_composizione)){
            $scheda['composizione'][] = $row_composizione;
        }
        
        $schede[] = $scheda;
    }

    echo json_encode($schede);
?>