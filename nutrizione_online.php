<?php
    session_start();

    if(!isset($_SESSION['username'])){
        header('Location: errorpage.php');
        exit;
    }
?>

<html>
<head>
    <meta charset="utf-8">
    <link rel='stylesheet' href='nutrizione_online.css'>
    <script src='nutrizione_online.js' defer></script>
    <title>Nutrizione Online</title>
    <meta name="viewport" content="width=display-width, initial-scale=1">
    <link href="https://fonts.googleapis.com/css2?family=Abel&family=Oxygen&family=Syne+Mono&display=swap" rel="stylesheet">
</head>
<body>
    <header>
        <div id="logo">
            <img src="LOGO.gif">
        </div>
        <div class='nav'>
            <nav>
                <a href="homepage.php">Home</a>
                <a href="powerfitnessgym/chi-siamo">Chi siamo</a>
                <a href="corsi.php">Corsi</a>
                <a href="powerfitnessgym/contattaci">Contattaci</a>
                <?php
                    echo "<span id='account'>";
                    echo $_SESSION['username'];
                    echo "</span>";
                ?>
            </nav>
        </div>
        <div id='menù_account' class='hidden'>
            <a href='profile.php'>My Profile</a>
            <a href='signup_corso.php'>Iscrizione</a>
            <a href='logout.php'>Esci</a>
        </div>
    </header>
    <section class='first'>
        <h1>Benvenuti nel nostro servizio di nutrizione online!</h1>
        <div>Questo servizio permette di calcolare le calorie di singoli alimenti, di ricette ed anche di interi menù.</div>
        <div>Inserisci nell'apposita barra di ricerca il singolo alimento(o il singolo ingrediente), 
             specificando prima la quantità(in grammi) e poi l'alimento.<br>
             Esempio: 100g pollo<br>
             N.B. In caso di errore controlla meglio la sintassi o scrivi in Inglese(seleziona ENG dal menù a tendina).
        </div>
        <div>Clicca 'Aggiungi'(o premi 'Invio') per aggiungere l'alimento alla lista.</div>
        <div>Quando hai terminato la lista degli ingredienti, clicca 'Calcola' per calcolare le calorie
             o 'Rimuovi' per cancellare la lista.
        </div>
        <div>
            Clicca 'Salva nel db' per salvare le tue ricette preferite nel nostro database. Se desideri visualizzare le tue ricette
            preferite clicca 'Vedi ricette salvate',<br> altrimenti clicca 'Elimina' per rimuovere la singola ricetta dal database.
        </div>
    </section>
    <form>Alimento: 
        <input type='text' id='barra'>
        <input type='submit' id='submit' value='Aggiungi'>
        <select name="lingua" id="lingua">
            <option value='ITA'>ITA</option>
            <option value='ENG'>ENG</option>
        </select>
    </form>
    <section class='tabelle'>
        <div class='tab_lista'>
            <div class='lista'>
                <ol>
                </ol>
            </div>
            <div class='buttons_lista'>
                <button id='calculate'>Calcola</button>
                <button id='remove'>Rimuovi</button>
            </div>
        </div>
        <div class='tab_output'>
            <div id='output'>
                <h2>Analisi Nutrizionale</h2>
                <div class='line'></div>
                <div class='contents'></div>
            </div>
            <form id='form_save'>
                <input type='text' id='nome_ricetta' placeholder='Inserisci un nome alla ricetta'>
                <input type='submit' value='Salva nel db'>
            </form>
        </div>
        <div class='tab_ricette'>
            <button id='visualizza'>Vedi ricette salvate</button>
            <div id='ricette' class='hidden'>
                <h2>Ricette salvate</h2>
                <div class='container_r'></div>
            </div>
        </div>
    </section>
    <footer>
        <div class="info">Power Fitness Gym</div>
        <div class="info">Via Roma, 50 - Catania(CT)</div>
        <div id="firma">Powered by Gerlando Maria Cacciatore, Matricola O46002238</div>
    </footer>
</body>
</html>