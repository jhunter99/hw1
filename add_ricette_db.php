<?php
    session_start();

    $esito = array();

    $conn = mysqli_connect('localhost','root','','palestra_sito');

    $username = mysqli_real_escape_string($conn, $_SESSION['username']);
    $nome = mysqli_real_escape_string($conn, $_GET['nome_ricetta']);
    $ingredienti = mysqli_real_escape_string($conn, $_GET['lista_ingr']);
    $calorie = mysqli_real_escape_string($conn, $_GET['calorie']);
    $grassi = mysqli_real_escape_string($conn, $_GET['grassi']);
    $grassi_saturi = mysqli_real_escape_string($conn, $_GET['grassi_saturi']);
    $carboidrati = mysqli_real_escape_string($conn, $_GET['carboidrati']);
    $zuccheri = mysqli_real_escape_string($conn, $_GET['zuccheri']);
    $proteine = mysqli_real_escape_string($conn, $_GET['proteine']);

    $queryRicetta = "INSERT INTO ricetta(username,nome,ingredienti,calorie,grassi,grassi_saturi,carboidrati,zuccheri,proteine) 
    VALUES ('$username','$nome', '$ingredienti', '$calorie', '$grassi', '$grassi_saturi', '$carboidrati', '$zuccheri', '$proteine')";
        
    $resRicetta = mysqli_query($conn, $queryRicetta);
    
    $esito['conferma'] = $resRicetta;

    mysqli_close($conn);
    echo json_encode($esito);
?>