<?php
    $conn = mysqli_connect('localhost','root', '', 'palestra_sito');

    $blocchi = array();

    //Seleziono tutti i corsi della tabella "corso"
    $queryCorso = "SELECT c.nome FROM corso c";
    $resCorso = mysqli_query($conn, $queryCorso);

    //Ad ogni iterazione prendo il nome di un corso e lo uso per la seconda query
    while ($rowCorso = mysqli_fetch_assoc($resCorso)){
        $rowCorso = mysqli_real_escape_string($conn, $rowCorso['nome']);

        $queryBlocco = "SELECT c.nome AS nome_corso, c.num_iscritti, c.image_url, d.nome, d.cognome, ist.formazione
        FROM corso c JOIN insegnamento i ON c.nome = i.corso
        JOIN istruttore ist ON i.istruttore = ist.ID
        JOIN dipendente d ON ist.ID = d.ID
        WHERE c.nome = '".$rowCorso."'";

        $blocco = array();

        $resBlocco = mysqli_query($conn, $queryBlocco);

        while($rowBlocco = mysqli_fetch_assoc($resBlocco)){
            $blocco['nome'] = $rowBlocco['nome_corso'];
            $blocco['num_iscritti'] = $rowBlocco['num_iscritti'];
            $blocco['image_url'] = $rowBlocco['image_url'];
            $info_istr = array();
            $info_istr['nome'] = $rowBlocco['nome'] . " " . $rowBlocco['cognome'];
            $info_istr['formazione'] = $rowBlocco['formazione'];
            $blocco['istruttori'][] = $info_istr;
        }
        $blocchi[] = $blocco;
    }

    mysqli_free_result($resCorso);
    mysqli_free_result($resBlocco);
    mysqli_close($conn);

    echo json_encode($blocchi);
?>