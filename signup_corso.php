<?php
    session_start();
    
    if(!isset($_SESSION['username'])){
        header('Location: signup_account_corso.php');
        exit;
    }

    if(!empty($_POST['corso']) && !empty($_POST['tipo_abbonamento']) && !empty($_POST['data_inizio'])){

        $username = $_SESSION['username'];
        $error = array();
        $conn = mysqli_connect('localhost','root','','palestra_sito');

        /*Validazione corso*/
        $corsi = array('FUNCTIONAL TRAINING', 'INDOOR CYCLING', 'SALA PESI', 'ZUMBA', 'KARATE', 'GINNASTICA CORRETTIVA');
        $ok1 = false;
        for($i=0;$i<count($corsi);$i++){
            $corso = strtoupper($_POST['corso']);
            if($corso === $corsi[$i]){
                $ok1 = true;
                break;
            }
        }
        if($ok1 === false){
            $error['corso'] = "Corso non valido!";
        }
    
        /*Validazione tipo abbonamento*/
        $tipi = array('MENSILE', 'TRIMESTRALE', 'SEMESTRALE', 'ANNUALE');
        $ok2 = false;
        for($i=0;$i<count($tipi);$i++){
            $tipo_abbonamento = strtoupper($_POST['tipo_abbonamento']);
            if($tipo_abbonamento === $tipi[$i]){
                $ok2 = true;
                break;
            }
        }
        if($ok2 === false){
            $error['abb'] = "Tipo di abbonamento non valido!";
        }
 
        /*Converto la stringa della data di inizio in un oggetto di classe DateTime*/
        $date_scad = date_create($_POST['data_inizio']);
       
        switch($tipo_abbonamento) {
            case 'MENSILE': {
                $quota_abb = 40; 
                date_add($date_scad, date_interval_create_from_date_string('1 month'));
                /*Salvo la scadenza come stringa nel formato YYYY-MM-DD*/
                $scadenza_abb = date_format($date_scad, 'Y-m-d');
                break;
            }
            case 'TRIMESTRALE': {
                $quota_abb = 105; 
                date_add($date_scad, date_interval_create_from_date_string('3 months'));
                $scadenza_abb = date_format($date_scad, 'Y-m-d');
                break;
            }
            case 'SEMESTRALE': {
                $quota_abb = 180; 
                date_add($date_scad, date_interval_create_from_date_string('6 months'));
                $scadenza_abb = date_format($date_scad, 'Y-m-d');
                break;
            }
            case 'ANNUALE': {
                $quota_abb = 300; 
                date_add($date_scad, date_interval_create_from_date_string('1 year'));
                $scadenza_abb = date_format($date_scad, 'Y-m-d');
                break;
            }
        }
        
        /*Registrazione del corso sulla tabella Abbonamento*/
        if(count($error) === 0){
            $corso = mysqli_real_escape_string ($conn, $corso);
            /*Creo un oggetto di classe DateTime con la data di inizio*/
            $date_in = date_create($_POST['data_inizio']);
            /*La salvo come stringa nel formato YYYY-MM-DD*/
            $data_inizio = date_format($date_in, 'Y-m-d');
            $data_inizio = mysqli_real_escape_string($conn, $data_inizio);
            $quota_abb = mysqli_real_escape_string($conn, $quota_abb);
            $scadenza_abb = mysqli_real_escape_string($conn, $scadenza_abb);

            $queryID = "SELECT c.ID FROM cliente c WHERE c.username = '$username'";

            $resID = mysqli_query($conn, $queryID);
            $rowID = mysqli_fetch_assoc($resID);

            $ID = $rowID['ID'];

            $queryAbbonamento = "INSERT INTO abbonamento(cliente, corso, tipo, data_inizio, quota, scadenza) 
            VALUES ('$ID', '$corso', '$tipo_abbonamento', '$data_inizio', '$quota_abb', '$scadenza_abb')";

            $resAbbonamento = mysqli_query($conn, $queryAbbonamento);

            $success = true;
        }
        else{
            /*Poichè il cliente ha sbagliato i dati di iscrizione al corso, e dunque NON ha un abbonamento, RIMUOVO il cliente appena inserito*/
            $queryRimuovi = "DELETE FROM cliente WHERE username = '$username'";
            $resRimuovi = mysqli_query($conn, $queryRimuovi);
        }

        mysqli_close($conn);
    }
?>

<html>
    <head>
        <title>Signup</title>
        <link rel='stylesheet' href='signup.css'>
        <script src='signup.js' defer></script>
    </head>
    <body>
        <section>
            <div class='description'>Attraverso questo form è possibile iscriversi ad uno dei nostri corsi</div>
            <div id='error' class='hidden'>Compila tutti i campi!</div>
            <main>
                <div class='container'>
                    <!-- Se il submit non va a buon fine, i dati inseriti restano nel form -->
                    <form name='registrazione' method='post'>
                        <label>Corso <input type='text' name='corso'<?php if(isset($_POST['corso'])) {echo "value=" . $_POST['corso'];}?>></label>
                        <?php if(isset($error['corso'])) {echo "<div class='errore_p'>" . "<div>" . $error['corso'] . "</div>" . '</div>';}?>
                        <label>Tipo di Abbonamento <input type='text' name='tipo_abbonamento'<?php if(isset($_POST['tipo_abbonamento'])) {echo "value=" . $_POST['tipo_abbonamento'];}?>></label>
                        <?php if(isset($error['abb'])) {echo "<div class='errore_p'>" . "<div>" . $error['abb'] . "</div>" . '</div>';}?>
                        <label>Data di inizio <input type='text' name='data_inizio'<?php if(isset($_POST['data_inizio'])) {echo "value=" . $_POST['data_inizio'];}?>></label>
                        <label>&nbsp; <input type='submit' value='Iscriviti'></label>
                    </form>
                    <div class='buttons'>
                        <a href='homepage.php'>Torna alla home</a>
                    </div>
                </div>
            </main>
            <?php 
                if(isset($success)){
                    echo "<div class='success'>Iscrizione al corso " . $_POST['corso'] . " avvenuta con successo!</div>";
                }
            ?>
        </section>
    </body>
</html>