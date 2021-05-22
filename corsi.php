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
        <title>Corsi</title>
        <link rel='stylesheet' href='corsi.css'>
        <script src='corsi.js' defer></script>
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
            </div>
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
        </header>
        <section>
            <div id='title'>Scopri tutti i nostri corsi</div>
            <div class='griglia'></div>
        </section>
        <footer>
            <div class="info">Power Fitness Gym</div>
            <div class="info">Via Roma, 50 - Catania(CT)</div>
            <div id="firma">Powered by Gerlando Maria Cacciatore, Matricola O46002238</div>
        </footer>
    </body>
</html>