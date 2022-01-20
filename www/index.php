<?php
require_once("db_connect.php");
echo "<pre>".print_r($users)."</pre><br />";

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Home</title>
    <link rel="stylesheet" href="./css/style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
</head>
<body>
    <h1>
        <?php
        $coucou = "coucou";
        echo $coucou;
        ?>
    </h1>
    <div class="mb-3 center">
        <input type="search" class="form-control" id="search" placeholder="Barre de recherche">
    </div>
    <div class="center">
        <button type="button" class="btn btn-outline-primary">Coucou</button>
    </div>
</body>
</html>