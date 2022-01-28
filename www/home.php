<?php
    require_once("back/db_connect.php");
    session_start();
    
    if(!isset($_GET['id'])){
        header("Location: index.php", true, 301);
    }

    if (!isset($_SESSION["cart"])) {
        $_SESSION["cart"] = array();
    }

    $id = $_GET["id"];
    $traitors;
    $traitorsFaveStyle = getTenBestRankedTraitorsWithFavStyle($id);
    print_r($traitorsFaveStyle);
    
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $traitors = traitorSearchWithWord($_POST['search']);
    } else {
        $traitors = getTenBestRankedTraitors();
    }


?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>AmaTraiteur - Home</title>
        <!-- Favicon-->
        <link rel="icon" type="image/x-icon" href="assets/favicon.ico" />
        <!-- Bootstrap icons-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" type="text/css" />
        <!-- Google fonts-->
        <link href="https://fonts.googleapis.com/css?family=Lato:300,400,700,300italic,400italic,700italic" rel="stylesheet" type="text/css" />
        <!-- Core theme CSS (includes Bootstrap)-->
        <link href="css/styles.css" rel="stylesheet" />
        <link href="css/my_styles.css" rel="stylesheet" />
    </head>
    <body>
        <!-- Navigation-->
        <nav class="navbar navbar-light bg-light static-top">
            <div class="container">
                <a class="navbar-brand" href=<?="home.php?id=".$id?>>AmaTraiteur</a>
                <a class="btn btn-primary" href=<?="account.php?id=".$id?>>Mon compte</a>
            </div>
        </nav>
        <!-- Masthead-->
        <header class="masthead">
            <div class="container position-relative">
                <div class="row justify-content-center">
                    <div class="col-xl-6">
                        <div class="text-center text-white">
                            <!-- Page heading-->
                            <h1 class="mb-5">Recherchez un traiteur</h1>
                            <form method="post" action=<?= "home.php?id=".$id ?>>
                                <div class="row">
                                    <div class="col">
                                        <input class="form-control form-control-lg" name="search" type="name" maxlength="50" placeholder="Barre de recherche"/>
                                    </div>
                                    <div class="col-auto"><button class="btn btn-primary btn-lg" id="submitButton" type="submit">Rechercher</button></div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <div class="container" style="padding-top: 50px;">
        <div class="row align-items-start">
            <div class="col">
                <section class="showcase traiteur-list">
                    <div class="container-fluid p-0">
                        <h3 class="center-text">10 meilleurs traiteurs</h3>
                            <?php foreach($traitors as $row): ?>
                            <div class="row g-0">
                                <div class="card traiteur-card" >
                                    <div class="card-body">
                                        <h5 class="card-title"><?= $row['prénom']." ".$row['nom'] ?></h5>
                                        <p class="card-text"><?= $row['adresse'].", ".$row['notelephone'].", note : ".$row['moyenne']."/5" ?></p>
                                        <?= "<a href='traiteur.php?id=".$id."&idTraitor=".$row['idpersonne']."' class='btn btn-primary'>Voir la page</a>";?>
                                    </div>
                                </div>
                            </div>
                            <?php endforeach; ?>
                        
                    </div>
                </section>
            </div>
            <div class="col">
                <section class="showcase traiteur-list">
                    <div class="container-fluid p-0">
                        <h3 class="center-text">10 meilleurs traiteurs pour votre style</h3>
                        <?php if (count($traitorsFaveStyle) == 0): ?>
                            <div class="row g-0">
                            <p style="text-align: center;">
                                Vous n'avez pas encore passé de commande. De ce fait nous ne pouvons pas vous proposer de traiteurs proposant des plat de votre style préféré.
                            </p>
                            </div>
                        <?php else: ?>
                            <?php foreach($traitorsFaveStyle as $row): ?>
                                    
                                <div class="row g-0">
                                    <div class="card traiteur-card" style="width: 60rem;">
                                        <div class="card-body">
                                            <h5 class="card-title"><?= $row['prénom']." ".$row['nom'] ?></h5>
                                            <p class="card-text"><?= $row['adresse'].", ".$row['notelephone'].", note : ".$row['moyenne']."/5" ?></p>
                                            <?= "<a href='traiteur.php?id=".$id."&idTraitor=".$row['idpersonne']."' class='btn btn-primary'>Voir la page</a>";?>
                                        </div>
                                    </div>
                                </div>
                                
                            <?php endforeach; ?>
                        <?php endif ?>
                    </div>
                </section>
            </div>
        </div>
    </div>


    
        <!-- Bootstrap core JS-->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Core theme JS-->
        <script src="js/scripts.js"></script>
        <!-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *-->
        <!-- * *                               SB Forms JS                               * *-->
        <!-- * * Activate your form at https://startbootstrap.com/solution/contact-forms * *-->
        <!-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *-->
        <script src="https://cdn.startbootstrap.com/sb-forms-latest.js"></script>
    </body>
</html>
