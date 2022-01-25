<?php
require_once("back/db_connect.php");
session_start();
if(isset($_GET['id'])){
    $id = $_GET["id"];
    $persoInfos = getPersoInfos($id);
    echo "<pre>".print_r($persoInfos)."</pre><br />";
}else{
    echo 'not set !!!!!!!!!';
}

print_r($_SESSION["cart"]);

?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>AmaTraiteur - Account</title>
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
                <a class="navbar-brand" href=<?="index.php?id=".$id?>>AmaTraiteur</a>
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
                            <?php foreach($persoInfos as $row): ?>
                            <h1 class="mb-5">Compte personnel</h1>
                            <h2 class="mb-5"><?= $row['prénom']." ".$row['nom'] ?></h2>
                            <h4 class="mb-5"><?= $row['adresse'].", ".$row['notelephone'] ?></h4>
                            <h4 class="mb-5"><?= $row['email'] ?></h4>
                            <?php endforeach; ?>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <div class="container">
            <div class="row align-items-start">
                <div class="col">
                    <section class="showcase traiteur-list">
                        <div class="container-fluid p-0">
                            <h3 class="center-text">Historique des commandes</h3>

                            <?php foreach(getOldOrders($_GET['id']) as $order): ?>
                                <div class="row g-0">
                                    <div class="card traiteur-card" style="width: 80%;">
                                        <div class="card-body">
                                            <h5 class="card-title"><?php $traitor = getPersoInfos($order['idpersonne'])[0]; echo $traitor['prénom']." ".$traitor['nom'] ?></h5>
                                            <p class="card-text"><?= $order['dateCommande'].", ".$order['Prix commande']."CHF" ?></p>
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

                        <!-- Client -->
                        <?php if (!isTraitor($id)): ?>
                            <h3 class="center-text">Commande en cours</h3>
                            <?php if(count($_SESSION["cart"]) != 0): ?>
                                <?php foreach($_SESSION["cart"] as $idP): ?>
                                <?php foreach(getProduct($idP) as $product): ?>
                                <div class="row g-0">
                                    <div class="card traiteur-card" style="width: 80%;">
                                        <div class="card-body">
                                            <h5 class="card-title"><?= $product['libellé'] ?></h5>
                                            <p class="card-text"><?= $product['prix'] ?></p>
                                            <form method="post" action="<?= "removeFromCart.php?id=".$id ?>">
                                                <input type="hidden" name="plat-id" value=<?= $product['id'] ?>>
                                                <input type="submit" class="btn btn-primary" value="Supprimer">
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                <?php endforeach; ?>
                                <?php endforeach; ?>
                            
                                <form method="post" action="<?= "sendOrder.php?id=".$id ?>">
                                    <input type="hidden" name="plat-id" value=<?= $id ?>>
                                    <input type="submit" class="btn btn-primary" value="Passer la commande">
                                </form>
                            <?php else: ?>
                                <p class="center-text">Pas de commande en cours</p>
                            <?php endif ?>

                        <!-- Traiteur -->
                        <?php else: ?>

                            <h3 class="Ajouter un produit"></h3>

                            <div class="row g-0">
                                <div class="card traiteur-card" style="width: 80%;">
                                    <div class="card-body">
                                        <h5 class="card-title">Traiteur 1</h5>
                                        <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                                        <a href="#" class="btn btn-primary">Go somewhere</a>
                                    </div>
                                </div>
                            </div>
                        
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
