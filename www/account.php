<?php
require_once("back/db_connect.php");
session_start();

if(!isset($_GET['id'])){
    header("Location: index.php", true, 301);
}

$id = $_GET["id"];
$persoInfos = getPersoInfos($id);

if ($_SESSION["cart"] == null) {
    $_SESSION["cart"]= array();
}

$entrees = getTraitorCourses($id, 'Entrée');
$plats = getTraitorCourses($id, 'Plat');
$desserts = getTraitorCourses($id, 'Dessert');

$stylesCulinaire = getAllStyleCulinaire();

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

                    <!-- Client -->
                    <section class="showcase traiteur-list" style="padding-top: 50px;">
                        <div class="container-fluid p-0">
                            <h3 class="center-text">Historique des commandes</h3>

                            
                            <?php 
                            $orders = getOldOrders($id);
                            if (count($orders) != 0): ?>
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
                                
                            <?php else: ?>
                                <p class="center-text">Vous n'avez pas d'historique de commandes.</p>
                            <?php endif ?>

                        </div>
                    </section>

                    <!-- Traiteur -->
                    <?php if (isTraitor($id)): ?>

                    <section class="showcase traiteur-list" style="padding-top: 50px;">

                        <div class="container-fluid p-0">
                            <h3 class="center-text">Commandes des clients</h3>

                            <?php 
                            $orders = getTraitorOrders($id);
                            if (count($orders) != 0): ?>
                            <?php foreach($orders as $order): ?>
                                <div class="row g-0">
                                    <div class="card traiteur-card" style="width: 80%;">
                                        <div class="card-body">
                                            <h5 class="card-title"><?= $order['prénom']." ".$order['nom'] ?></h5>
                                            <p class="card-text"><?= $order['dateheure'].", ".$order['Prix commande']."CHF" ?></p>
                                            <p class="card-text"><?= 'Statut : '.$order['statut'] ?></p>
                                        </div>
                                    </div>
                                </div>
                            <?php endforeach; ?>

                            <?php else: ?>
                                <p class="center-text">Vous n'avez pas de commandes de clients.</p>
                            <?php endif ?>
                        </div>
                    </section>
                    <?php endif ?>
                </div>


                <div class="col">
                <section class="showcase traiteur-list">
                        <div class="container-fluid p-0">


                        <!-- Traiteur -->
                        <?php if (isTraitor($id)): ?>

                            <div class="row g-0" style="padding-top: 50px;">
                            <h3 class="center-text">Ajouter un plat</h3>

                            
                                <!-- <div class="card traiteur-card" style="width: 80%;"> -->
                                    <form method="post" action="<?= "addCourse.php?id=".$id ?>">
                                        <div class="row g-2" style="padding-top: 0.5rem;">
                                            <div class="col-md">
                                                <div class="form-floating">
                                                <input type="name" class="form-control" id="floatingInputGrid" name="libellé" maxlength="50" required>
                                                <label for="floatingInputGrid">Libellé</label>
                                                </div>
                                            </div>
                                            <div class="col-md">
                                            <div class="form-floating">
                                                <input type="number" class="form-control" id="floatingInputGrid" name="prix" min="0" required>
                                                <label for="floatingInputGrid">Prix</label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row g-2" style="padding-top: 0.5rem;">
                                        <div class="col-md">
                                                <div class="form-floating">
                                                    <select class="form-select" id="floatingSelectGrid" name="catégorie" aria-label="Floating label select example">
                                                        <option selected value="null">Aucun</option>
                                                        <?php foreach($stylesCulinaire as $style): ?>
                                                            <option value="<?= $style['id'] ?>"><?= $style['nom']." - ".$style['régionprovenance'] ?></option>
                                                        <?php endforeach ?>
                                                    </select>
                                                    <label for="floatingSelectGrid">Catégorie</label>
                                                </div>
                                            </div>
                                            <div class="col-md">
                                                <div class="form-floating">
                                                    <select class="form-select" id="floatingSelectGrid" name="catégorie" aria-label="Floating label select example">
                                                        <option selected value="Entrée">Entrée</option>
                                                        <option value="Plat">Plat</option>
                                                        <option value="Dessert">Dessert</option>
                                                    </select>
                                                    <label for="floatingSelectGrid">Catégorie</label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-floating" style="padding-top: 0.5rem;">
                                            <textarea class="form-control" placeholder="" id="floatingTextarea2" name="description" maxlength="200" style="height: 100px"></textarea>
                                            <label for="floatingTextarea2">Description</label>
                                        </div>
                                        <input type="submit" class="btn btn-primary" style="margin-top: 0.5rem;" value="Ajouter">
                                    </form>
                                <!-- </div> -->
                            </div>


                            <div class="row g-0" style="padding-top: 50px;">
                            <h3 class="center-text">Ajouter un menu</h3>

                            
                                <!-- <div class="card traiteur-card" style="width: 80%;"> -->
                                    <form method="post" action="<?= "addMenu.php?id=".$id ?>">
                                        <div class="row g-2" style="padding-top: 0.5rem;">
                                            <div class="col-md">
                                                <div class="form-floating">
                                                <input type="name" class="form-control" id="floatingInputGrid" name="libellé" maxlength="50" required>
                                                <label for="floatingInputGrid">Libellé</label>
                                                </div>
                                            </div>
                                            <div class="col-md">
                                            <div class="form-floating">
                                                <input type="number" class="form-control" id="floatingInputGrid" min="0" name="prix" required>
                                                <label for="floatingInputGrid">Prix</label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row g-2" style="padding-top: 0.5rem;">
                                            <div class="col-md">
                                            <div class="form-floating">
                                                    <select class="form-select" id="floatingSelectGrid" name="nombrepersonnes" aria-label="Floating label select example">
                                                        <option selected value="1">1</option>
                                                        <option value="2">2</option>
                                                        <option value="3">3</option>
                                                        <option value="4">4</option>
                                                        <option value="6">6</option>
                                                        <option value="8">8</option>
                                                        <option value="10">10</option>
                                                    </select>
                                                    <label for="floatingSelectGrid">Nombre de personnes</label>
                                                </div>
                                            </div>
                                        </div>

                                        <div style="padding-top: 0.5rem;">

                                            <div class="form-floating">
                                                <select class="form-select" id="floatingSelect" name="entree" aria-label="Floating label select example" required>
                                                    <?php foreach($entrees as $course): ?>
                                                        <option value="<?= $course['id'] ?>"><?= $course['libellé'] ?></option>
                                                    <?php endforeach ?>
                                                </select>
                                                <label for="floatingSelect">Entrée</label>
                                            </div>
                                            
                                        </div>
                                        
                                        <div style="padding-top: 0.5rem;">
                                        <div class="form-floating">
                                                <select class="form-select" id="floatingSelect" name="plat" aria-label="Floating label select example" required>
                                                    <?php foreach($plats as $course): ?>
                                                        <option value="<?= $course['id'] ?>"><?= $course['libellé'] ?></option>
                                                    <?php endforeach ?>
                                                </select>
                                                <label for="floatingSelect">Plat</label>
                                            </div>
                                        </div>

                                        <div style="padding-top: 0.5rem;">
                                        <div class="form-floating">
                                                <select class="form-select" id="floatingSelect" name="dessert" aria-label="Floating label select example" required>
                                                    <?php foreach($desserts as $course): ?>
                                                        <option value="<?= $course['id'] ?>"><?= $course['libellé'] ?></option>
                                                    <?php endforeach ?>
                                                </select>
                                                <label for="floatingSelect">Dessert</label>
                                            </div>
                                        </div>

                                        <input type="submit" class="btn btn-primary" style="margin-top: 0.5rem;" value="Ajouter">
                                    </form>
                                <!-- </div> -->
                            </div>
                        <?php endif ?>

                            <!-- Client -->
                        <div style="padding-top: 50px;">
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

                        </div>
                        
                        
                        
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
