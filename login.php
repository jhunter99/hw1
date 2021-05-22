<?php
    session_start();

    if(isset($_SESSION['username'])){
        header('Location: homepage.php');
        exit;
    }

    if(isset($_POST['username']) && isset($_POST['password'])){
        $conn = mysqli_connect('localhost','root','','palestra_sito');

        $username = mysqli_real_escape_string($conn, $_POST['username']);
        $password = mysqli_real_escape_string($conn, $_POST['password']);

        $query = "SELECT * FROM cliente WHERE username = '".$username."' AND password = '".$password."'";
        $res = mysqli_query($conn, $query);
        
        if(mysqli_num_rows($res) > 0){
            $_SESSION['username'] = $_POST['username'];
            header('Location: homepage.php');
            exit;
        }
        else {
            $error = true;
        }
    }
?>

<html>
    <head>
        <title>Login</title>
        <link rel='stylesheet' href='login.css'>
    </head>
    <body>
        <main>
            <div class='accesso'>
                <form name='nome_form' method='post'>
                    <label>Username <input type='text' name='username'></label>
                    <label>Password <input type='password' name='password'></label>
                    <label>&nbsp; <input type='submit' value='Accedi'></label>
                </form>
                <div class='buttons'>
                    <a href='signup_account_corso.php'>Non hai un account? Registrati.</a>
                    <a href='homepage.php'>Torna alla home</a>
                </div>
            </div>
            <?php 
            if(isset($error)){
                echo "<p class='error'>";
                echo "Credenziali non valide";
                echo "</p>";
            }
        ?>
        <main>
    </body>
</html>