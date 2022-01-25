<?php


$connection = new PDO("pgsql:host=db_server;port=5432;dbname=amaTraiteur", $_ENV["DB_USER"], $_ENV["DB_PASSWORD"]);
if(isset($_POST['forminscription'])) {
    $nom = htmlspecialchars($_POST['nom']);
    $prenom = htmlspecialchars($_POST['prenom']);
    $mail = htmlspecialchars($_POST['mail']);
    $mail2 = htmlspecialchars($_POST['mail2']);
    $adresse = htmlspecialchars('adresse');
    $noTel = htmlspecialchars("noTel");
    if(!empty($_POST['nom']) AND !empty($_POST['prenom']) AND !empty($_POST['mail']) AND !empty($_POST['mail2'])  AND !empty($_POST['adresse']) AND !empty($_POST['noTel']) ) {
        $nomlength = strlen($nom);
        $prenomlength = strlen($prenom);

        if($nomlength <= 30 AND $prenomlength <=30) {
            if($mail == $mail2) {
                if(filter_var($mail, FILTER_VALIDATE_EMAIL)) {
                    $reqmail = $connection->query("SELECT * FROM amaTraiteur.personne  WHERE email = ?");
                    $reqmail->execute(array($mail));
                    $mailexist = $reqmail->rowCount();
                    if($mailexist == 0) {
                        if(1) {
                            $insertmbr = $connection->prepare("INSERT INTO .personne(nom, prenom, adresse, notelephone, email) VALUES(?, ?, ?, ?, ?)");
                            $insertmbr->execute(array($nom, $prenom, $adresse,$noTel,$mail));
                            $erreur = "Votre compte a bien été créé ! <a href=\"connexion.php\">Me connecter</a>";
                        } else {
                            $erreur = "Vos mots de passes ne correspondent pas !";
                        }
                    } else {
                        $erreur = "Adresse mail déjà utilisée !";
                    }
                } else {
                    $erreur = "Votre adresse mail n'est pas valide !";
                }
            } else {
                $erreur = "Vos adresses mail ne correspondent pas !";
            }
        } else {
            $erreur = "Votre pseudo ne doit pas dépasser 255 caractères !";
        }
    } else {
        $erreur = "Tous les champs doivent être complétés !";
    }
}
?>






















<html>
<head>
    <title>Inscription</title>
    <meta charset="utf-8">
</head>
<body>
<div align="center">
    <h2>S'inscrire</h2>
    <br /><br />
    <form method="POST" action="">
        <table>
            <tr>
                <td align="right">
                    <label for="Nom">Nom :</label>
                </td>
                <td>
                    <input type="text" placeholder="Votre Nom" id="nom" name="nom" value="<?php if(isset($Nom)) { echo $Nom; } ?>" />
                </td>
            </tr>
            <tr>
                <td align="right">
                    <label for="pseudo">Prénom :</label>
                </td>
                <td>
                    <input type="text" placeholder="Votre Prénom" id="prenom" name="prenom" value="<?php if(isset($Prénom)) { echo $Prénom; } ?>" />
                </td>
            </tr>
            <tr>
                <td align="right">
                    <label for="mail">Mail :</label>
                </td>
                <td>
                    <input type="email" placeholder="Votre mail" id="mail" name="mail" value="<?php if(isset($mail)) { echo $mail; } ?>" />
                </td>
            </tr>
            <tr>
                <td align="right">
                    <label for="mail2">Confirmation du mail :</label>
                </td>
                <td>
                    <input type="email" placeholder="Confirmez votre mail" id="mail2" name="mail2" value="<?php if(isset($mail2)) { echo $mail2; } ?>" />
                </td>
            </tr>
            <tr>
                <td align="right">
                    <label for="adresse"> Votre adresse :</label>
                </td>
                <td>
                    <input type="adresse" placeholder="Votre adresse" id="adresse" name="adresse" />
                </td>
            </tr>
            <tr>
                <td align="right">
                    <label for="noTel"> No téléphone </label>
                </td>
                <td>
                    <input type="NoTel" placeholder="Votre numére de téléphone" id="Notel" name="NoTel" />
                </td>
            </tr>
            <tr>
                <td></td>
                <td align="center">
                    <br />
                    <input type="submit" name="forminscription" value="Je m'inscris" />
                </td>
            </tr>
        </table>
    </form>
    <?php
    if(isset($erreur)) {
        echo '<font color="red">'.$erreur."</font>";
    }
    ?>
</div>
</body>
</html>