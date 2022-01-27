<?php
require_once("back/db_connect.php");

if (!isset($_GET['id'])) {
    header("Location: index.php", true, 301);
}

$idTraitor = $_GET["idTraitor"];
$id = $_GET["id"];

$traitorInfos = getPersoInfos($idTraitor);
$note = getGradetraitor($idTraitor);

$filter = 'dateevaluation';
// if ($_SERVER["REQUEST_METHOD"] == "POST") {
//     if ($_POST['name'] == 'notes') {
//         $filter = 'note';
//     }
// }

$evaluations = getTraitorEvaluations($idTraitor, $filter);

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
        <header class="masthead" style="padding-bottom: 10%; padding-top: 10%">
            <div class="container position-relative">
                <div class="row justify-content-center">
                    <div class="col-xl-6">
                        <div class="text-center text-white">
                            <!-- Page heading-->
                            <?php foreach($traitorInfos as $row): ?>
                            <h1 class="mb-5"><?= $row['prénom']." ".$row['nom'] ?></h1>
                            <h2 class="mb-5"><?= "Note : ".$note[0]['moyenne']."/5" ?></h2>
                            <h4 class="mb-5"><?= $row['adresse'].", ".$row['notelephone'] ?></h4>
                            <h4 class="mb-5"><?= $row['email'] ?></h4>
                            <?php endforeach ?>
                            <<?= "a href='traiteur.php?id=".$id."&idTraitor=".$idTraitor."' class='btn btn-primary'>Retour sur la page du traiteur</a>" ?>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <section class="showcase traiteur-list">
            <div class="container-fluid p-0">
                <!-- <div classe="center-item">
                    <form method="post" action=">">
                        <div class="dropdow">
                            <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false">
                                Filtre
                            </button>
                            <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                                <li><a class="dropdown-item" name="dates">Date évaluation</a></li>
                                <li><a class="dropdown-item" name="notes">Note</a></li>
                            </ul>
                        </div>
                    </form>
                </div> -->
                
                <?php foreach($evaluations as $evaluation): ?>
                    <div class="row g-0">
                        <div class="card traiteur-card" style="width: 60%;">
                            <div class="card-body">
                                <h5 class="card-title"><?= "Note : ".$evaluation['note']."/5" ?></h5>
                                <p class="card-text"><?= $evaluation['commentaire'] ?></p>
                                <p class="card-text"><?= $evaluation['dateevaluation'] ?></p>
                            </div>
                        </div>
                    </div>
                <?php endforeach ?>
            </div>
        </section>
    
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
