<?php
    session_start();

    if(!isset($_SESSION['username'])){
        header('Location: homepage.php');
        exit;
    }
?>

<html>
    <head>
        <title>My Profile</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=display-width, initial-scale=1">
        <link rel = 'stylesheet' href = 'profile.css'>
        <script src='profile.js' defer></script>
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
                <a href='signup_corso.php'>Iscriviti</a>
                <a href='logout.php'>Esci</a>
            </div>
        </header>
        <div id='anagrafica' class='container'>
            <h2>Dati Anagrafici</h2>
        </div>
        <div id='abbonamenti' class='container'>
            <h2>I miei abbonamenti</h2>
            <table>
                <tr><th>CORSO</th><th>TIPO</th><th>INIZIATO IL</th><th>SCADE IL</th><th>COSTO</th></tr>
            </table>
        </div>
        <div id='schede' class='container'>
            <h2>Le mie schede di pesistica</h2>
            <table id='table_intestazioni'></table>
            <div id='griglia'></div>
        </div>
        <div id='stage' class='container'>
            <h2>Gli Stage a cui ho partecipato/parteciperò</h2>
        </div>
        <footer>
            <div class="info">Power Fitness Gym</div>
            <div class="info">Via Roma, 50 - Catania(CT)</div>
            <div id="firma">Powered by Gerlando Maria Cacciatore, Matricola O46002238</div>
        </footer>
    </body>
</html>