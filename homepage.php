<?php
    session_start();

    if(isset($_SESSION['username'])){
        $welcome = true;
    }
?>

<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=display-width, initial-scale=1">
        <link rel="stylesheet" href="homepage.css">
        <script src="homepage.js" defer></script>
        <link href="https://fonts.googleapis.com/css2?family=Abel&family=Oxygen&family=Syne+Mono&display=swap" rel="stylesheet">
        <title>Power Fitness Gym</title>
    </head>
    <body>
        <header>
            <div id="overlay"></div>
            <div id="logo">
                <img src="LOGO.gif">
            </div>
            <nav>
                <a href="homepage.php">Home</a>
                <a href="powerfitnessgym/chi-siamo">Chi siamo</a>
                <a href="corsi.php">Corsi</a>
                <a href="powerfitnessgym/contattaci">Contattaci</a>
                <?php
                    if(isset($welcome)){
                        echo "<span id='account'>";
                        echo $_SESSION['username'];
                        echo "</span>";
                    }
                    else {
                        echo "<a href='login.php'>Accedi</a>";
                    }
                ?>
            </nav>
            <?php
                if(isset($welcome)){
                    echo "<div id='menù_account' class='hidden'>";
                    echo "<a href='profile.php'>";
                    echo "My Profile";
                    echo "</a>";
                    echo "<a href='signup_corso.php'>";
                    echo "Iscrizione";
                    echo "</a>";
                    echo "<a href='logout.php'>";
                    echo "Esci";
                    echo "</a>";
                    echo "</div>";
                }
            ?>
            <div id="menu">
                <div></div>
                <div></div>
                <div></div>
            </div>
            <?php
                if(isset($welcome)){
                    echo "<div id='welcome'>";
                    echo "Benvenuto " . $_SESSION['username'];
                    echo "</div>";
                }
            ?>
            <h1>Power Fitness Gym</h1>
        </header>
        <div class="intestazione hidden">Preferiti</div>
        <section id="preferences" class="hidden"></section>
        <div id='cerca'>Cerca per Titolo <input type='text'></div>
        <section>
            <div class='banner' id='container'></div>
            <div class="griglia"></div>
            <div class='banner' id='nutrition'>
                Per massimizzare i risultati ottenibili dall'allenamento è fondamentale seguire una scrupolosa alimentazione. 
                Un' alimentazione con un adeguato apporto calorico, povera di grassi e ricca di carboidrati complessi e proteine è
                imprescindibile per il mantenimento di un' ottima forma fisica, nonchè indispensabile per la prevenzione di numerose patologie.<br>
                Il nostro obiettivo è quello di fornire agli abbonati benessere a 360 gradi. Ecco perchè abbiamo riservato solo per voi un 
                esclusivo servizio di nutrizione online.
                <div>Clicca <a href='nutrizione_online.php'>qui</a> per maggiori dettagli</div>
            </div>
        </section>
        <footer>
            <div class="info">Power Fitness Gym</div>
            <div class="info">Via Roma, 50 - Catania(CT)</div>
            <div id="firma">Powered by Gerlando Maria Cacciatore, Matricola O46002238</div>
        </footer>
    </body>
</html>