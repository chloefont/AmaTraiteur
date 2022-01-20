<!-- <?php
require_once("db_connect.php");
echo "<pre>".print_r($users)."</pre><br />";

?> -->
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
                <a class="navbar-brand" href="#!">AmaTraiteur</a>
                <a class="btn btn-primary" href="#signup">Mon compte</a>
            </div>
        </nav>
        <!-- Masthead-->
        <header class="masthead" style="padding-bottom: 10%; padding-top: 10%">
            <div class="container position-relative">
                <div class="row justify-content-center">
                    <div class="col-xl-6">
                        <div class="text-center text-white">
                            <!-- Page heading-->
                            <h1 class="mb-5">Jean Didier le traiteur</h1>
                            <h2 class="mb-5">note/5</h2>
                            <h4 class="mb-5">Adresse, numéro téléphone</h4>
                            <h4 class="mb-5">Adresse mail</h4>
                            <<?= "a href='evaluations.php?id=1' class='btn btn-primary'>Evaluation</a>" ?>
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
                            <h3 class="center-text">Entrées</h3>

                            <div class="row g-0">
                                <div class="card traiteur-card" style="width: 80%;">
                                    <div class="card-body">
                                        <h5 class="card-title">Entrée</h5>
                                        <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                                        <a href="#" class="btn btn-primary">Commander</a>
                                    </div>
                                </div>
                            </div>
                            <h3 class="center-text">Plats</h3>

                            <div class="row g-0">
                                <div class="card traiteur-card" style="width: 80%;">
                                    <div class="card-body">
                                        <h5 class="card-title">Traiteur 2</h5>
                                        <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                                        <a href="#" class="btn btn-primary">Go somewhere</a>
                                    </div>
                                </div>
                            </div>
                            <h3 class="center-text">Desserts</h3>

                            <div class="row g-0">
                                <div class="card traiteur-card" style="width: 80%;">
                                    <div class="card-body">
                                        <h5 class="card-title">Traiteur 3</h5>
                                        <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                                        <a href="#" class="btn btn-primary">Go somewhere</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
                <div class="col">
                <section class="showcase traiteur-list">
                        <div class="container-fluid p-0">
                            <h3 class="center-text">Menus</h3>

                            <div class="row g-0">
                                <div class="card traiteur-card" style="width: 80%;">
                                    <div class="card-body">
                                        <h5 class="card-title">Traiteur 1</h5>
                                        <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                                        <a href="#" class="btn btn-primary">Go somewhere</a>
                                    </div>
                                </div>
                            </div>
                            <div class="row g-0">
                                <div class="card traiteur-card" style="width: 80%;">
                                    <div class="card-body">
                                        <h5 class="card-title">Traiteur 2</h5>
                                        <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                                        <a href="#" class="btn btn-primary">Go somewhere</a>
                                    </div>
                                </div>
                            </div>
                            <div class="row g-0">
                                <div class="card traiteur-card" style="width: 80%;">
                                    <div class="card-body">
                                        <h5 class="card-title">Traiteur 3</h5>
                                        <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                                        <a href="#" class="btn btn-primary">Go somewhere</a>
                                    </div>
                                </div>
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
