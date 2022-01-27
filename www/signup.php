<?php
    require_once("back/db_connect.php");

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
                <a class="navbar-brand" href=<?="index.php"?>>AmaTraiteur</a>
            </div>
        </nav>
        <!-- Masthead-->
        <header class="masthead" style="padding-top: 4rem; padding-bottom: 4rem">
        </header>

        <div class="row g-0 center-item" style="padding-top: 50px; width: 50rem;">
            <h3 class="center-text">Connexion</h3>

            
                <!-- <div class="card traiteur-card" style="width: 80%;"> -->
                    <form method="post" action="<?= "addMember.php" ?>">
                        <div class="form-floating">
                            <select class="form-select" name="type" id="floatingSelect" aria-label="Floating label select example">
                                <option selected value='client'>Client</option>
                                <option value="traiteur">Traiteur</option>
                            </select>
                            <label for="floatingSelect">Vous vous inscrivez en tant que</label>
                        </div>
                        <div class="form-floating" style="padding-top: 0.5rem;">
                            <input type="name" class="form-control" name="nom" id="floatingPassword" required>
                            <label for="floatingPassword">Nom</label>
                        </div>
                        <div class="form-floating" style="padding-top: 0.5rem;">
                            <input type="name" class="form-control" name="prénom" id="floatingPassword" required>
                            <label for="floatingPassword">Prénom</label>
                        </div>
                        <div class="form-floating" style="padding-top: 0.5rem;">
                            <input type="name" class="form-control" name="email" id="floatingPassword" required>
                            <label for="floatingPassword">Adresse mail</label>
                        </div>
                        <div class="form-floating" style="padding-top: 0.5rem;">
                            <input type="name" class="form-control"  name="adresse" id="floatingPassword" required>
                            <label for="floatingPassword">Adresse</label>
                        </div>
                        <div class="form-floating" style="padding-top: 0.5rem;">
                            <input type="name" class="form-control"  name="notel" id="floatingPassword" required>
                            <label for="floatingPassword">No téléphone</label>
                        </div>
                        
                        <input type="submit" class="btn btn-primary" style="margin-top: 0.5rem;" value="S'inscrire">
                    </form>
                <!-- </div> -->
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
