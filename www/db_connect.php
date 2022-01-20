<?php
$connection = new PDO("pgsql:host=db_server;port=5432;dbname=amaTraiteur", $_ENV["DB_USER"], $_ENV["DB_PASSWORD"]);

// test
$users = $connection->query('SELECT * FROM personne')->fetchAll(PDO::FETCH_ASSOC);
