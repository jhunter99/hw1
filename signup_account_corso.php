<?php
/*Mi sono basato sul seguente ragionamento:
una persona possiede un account per accedere al sito della palestra SOlO se quella persona è cliente della palestra,
cioè se si è iscritto ad un corso, o in altri termini, se ha pagato un abbonamento.
Per cui ho previsto due tipi di signup:
1) Se la persona non si è ancora iscritta alla palestra, attraverso la pagina signup_account_corso, tale persona
può creare un account ed,obbligatoriamente, iscriversi ad un corso.

2) Se l'utente già possiede un account, e dunque se già è iscritto ad un corso, l'utente può iscriversi ad
un altro corso(mantenendo però lo stesso account), tramite la pagina signup_corso*/
?>

<?php
    session_start();

    if(isset($_SESSION['username'])){
        header('Location: signup_corso.php');
        exit;
    }
?>

<?php

    if(!empty($_POST['CF']) && !empty($_POST['nome']) && !empty($_POST['cognome']) 
      && !empty($_POST['nascita']) && !empty($_POST['età']) && !empty($_POST['email'])
      && !empty($_POST['username']) && !empty($_POST['password'])
      && !empty($_POST['corso']) && !empty($_POST['tipo_abbonamento']) && !empty($_POST['data_inizio'])){

        $error = array();
        $conn = mysqli_connect('localhost','root','','palestra_sito');

        /*Validazione CF*/ 
        if(strlen($_POST['CF']) !== 16){
            $error['CF'] = "Codice Fiscale non valido!";
        }
        else {
            $CF = mysqli_real_escape_string($conn, $_POST['CF']);
            $queryCF = "SELECT * FROM cliente c WHERE c.CF = '$CF'";
            $resCF = mysqli_query($conn, $queryCF);
            if(mysqli_num_rows($resCF) > 0){
                $error['CF'] = "Esiste già un utente registrato con questo Codice Fiscale!";
            }
        }

        /*Validazione email*/
        $email = mysqli_real_escape_string($conn, $_POST['email']);
        $queryEmail = "SELECT * FROM cliente c WHERE c.email = '$email'";
        $resEmail = mysqli_query($conn, $queryEmail);
        if(mysqli_num_rows($resEmail) > 0){
            $error['email'] = "Esiste già un utente registrato con questa email!";
        }

        /*Validazione username*/
        $username = mysqli_real_escape_string($conn, $_POST['username']);
        $queryUsername = "SELECT * FROM cliente c WHERE c.username = '$username'";
        $resUsername = mysqli_query($conn, $queryUsername);
        if(mysqli_num_rows($resUsername) > 0){
            $error['username'] = "Esiste già un utente registrato con questo username!";
        }

        /*Validazione password*/
	    if(strlen($_POST['password']) < 8 || !preg_match("#[0-9]+#", $_POST['password']) || !preg_match("#[a-z]+#", $_POST['password']) ||
        !preg_match("#[A-Z]+#", $_POST['password']) || !preg_match("/[\'^£$%&*()}{@#~?><>,|=_+!-]/", $_POST['password'])) 
        {
            $error['password'] = "La password deve essere di 8 caratteri e deve contenere almeno una lettera maiuscola,
            una lettera minuscola, un numero ed un carattere speciale";
        }
	
        /*Registrazione dell'account sulla tabella Cliente*/
        if(count($error) == 0){
            $nome = mysqli_real_escape_string($conn, $_POST['nome']);
            $cognome = mysqli_real_escape_string($conn, $_POST['cognome']);
            $date_nascita = date_create($_POST['nascita']);
            /*La salvo come stringa nel formato YYYY-MM-DD*/
            $nascita = date_format($date_nascita, 'Y-m-d');
            $nascita = mysqli_real_escape_string($conn, $nascita);
            $età = mysqli_real_escape_string($conn, $_POST['età']);
            $password = mysqli_real_escape_string($conn, $_POST['password']);

            $queryCliente = "INSERT INTO cliente(CF, nome, cognome, data_di_nascita, età, username, email, password) 
            VALUES ('$CF', '$nome', '$cognome', '$nascita', '$età', '$username', '$email', '$password')";
 
            $resCliente = mysqli_query($conn, $queryCliente);
        }

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

            /*Si accede al sito con l'account appena creato*/
            $_SESSION['username'] = $username;
            header('Location: homepage.php');
            exit;
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
        <div class='description'>Attraverso questo form è possibile creare un account personale ed iscriversi ad uno dei nostri corsi</div>
        <div id='error' class='hidden'>Compila tutti i campi!</div>
        <main>
            <div class='container'>
                <!-- Se il submit non va a buon fine, i dati inseriti restano nel form -->
                <form name='registrazione' method='post'>
                    <label>Codice Fiscale <input type='text' name='CF'<?php if(isset($_POST['CF'])) {echo "value=" . $_POST['CF'];}?>></label>
                    <?php if(isset($error['CF'])) {echo "<div class='errore_p'>" . "<div>" . $error['CF'] . "</div>" . '</div>';}?>
                    <label>Nome <input type='text' name='nome'<?php if(isset($_POST['nome'])) {echo "value=" . $_POST['nome'];}?>></label>
                    <label>Cognome <input type='text' name='cognome'<?php if(isset($_POST['cognome'])) {echo "value=" . $_POST['cognome'];}?>></label>
                    <label>Data di Nascita <input type='text' name='nascita'<?php if(isset($_POST['nascita'])) {echo "value=" . $_POST['nascita'];}?>></label>
                    <label>Età <input type='text' name='età' placeholder='inserire solo il numero' <?php if(isset($_POST['età'])) {echo "value=" . $_POST['età'];}?>></label>
                    <label>Email <input type='text' name='email'<?php if(isset($_POST['email'])) {echo "value=" . $_POST['email'];}?>></label>
                    <?php if(isset($error['email'])) {echo "<div class='errore_p'>" . "<div>" . $error['email'] . "</div>" . '</div>';}?>
                    <label>Username <input type='text' name='username'<?php if(isset($_POST['username'])) {echo "value=" . $_POST['username'];}?>></label>
                    <?php if(isset($error['username'])) {echo "<div class='errore_p'>" . "<div>" . $error['username'] . "</div>" . '</div>';}?>
                    <label>Password <input type='password' name='password'<?php if(isset($_POST['password'])) {echo "value=" . $_POST['password'];}?>></label>
                    <?php if(isset($error['password'])) {echo "<div class='errore_p'>" . "<div>" . $error['password'] . "</div>" . '</div>';}?>
                    <label>Corso <input type='text' name='corso'<?php if(isset($_POST['corso'])) {echo "value=" . $_POST['corso'];}?>></label>
                    <?php if(isset($error['corso'])) {echo "<div class='errore_p'>" . "<div>" . $error['corso'] . "</div>" . '</div>';}?>
                    <label>Tipo di Abbonamento <input type='text' name='tipo_abbonamento'<?php if(isset($_POST['tipo_abbonamento'])) {echo "value=" . $_POST['tipo_abbonamento'];}?>></label>
                    <?php if(isset($error['abb'])) {echo "<div class='errore_p'>" . "<div>" . $error['abb'] . "</div>" . '</div>';}?>
                    <label>Data di inizio <input type='text' name='data_inizio'<?php if(isset($_POST['data_inizio'])) {echo "value=" . $_POST['data_inizio'];}?>></label>
                    <label>&nbsp; <input type='submit' value='Registrazione'></label>
                </form>
                <div class='buttons'>
                    <a href='homepage.php'>Torna alla home</a>
                </div>
            </div>
        <main>
    </body>
</html>