<html>
	<head>
		<style>
			html{ background: #999999; }
			body{ width:60%; margin-left:auto; margin-right:auto; background: #CCCCCC;}
		</style>
	</head>
	<body>
<?php
	session_start();
	require "demo_db_class.php";
	require "demo_db_functions.php";
	$db = new DB();
	
	if(ISSET($_POST["auswahl"]) && !empty($_POST["auswahl"])){
		$_SESSION["action"] = $_POST["auswahl"];
	}
	else{
		$anz = count($_POST);
		//$_SESSION["action"] = null;
		if($anz > 0){
			$index = 0;
			foreach($_POST as $key => $value){
				$daten[$index] = $value;
				$index++;
			}
			testen($daten);
			switch($_SESSION["action"]){
				case "kunde":
					$db->AddKunde($daten);
					break;
				case "produkt":
					$db->AddProdukt($daten);
					break;
				case "hersteller":
					$db->AddHersteller($daten);
					break;
				case "spedition":
					$db->AddSpedition($daten);
					break;
			}
		}
	}

	$ergebnis = $db->HoleTabellen();
	tabellen($ergebnis, $db);

	switch($_SESSION["action"]){
		case "kunde":
			$ergebnis = $db->SelectAusDB("kunde");
			zeigeInhalt($ergebnis);
			kunde($ergebnis, $db);
			break;
		case "produkt":
			$ergebnis = $db->SelectAusDB("produkt");
			zeigeInhalt($ergebnis);
			produkt($ergebnis, $db);
			break;
		case "hersteller":
			$ergebnis = $db->SelectAusDB("hersteller");
			zeigeInhalt($ergebnis);
			hersteller($ergebnis, $db);
			break;
		case "spedition":
			$ergebnis = $db->SelectAusDB("spedition");
			zeigeInhalt($ergebnis);
			spedition($ergebnis, $db);
			break;
		case "abrechnung":
			$ergebnis = $db->SelectAusDB("abrechnung");
			zeigeInhalt($ergebnis);
			break;
		case "abrechnung_produkt":
			$ergebnis = $db->SelectAusDB("abrechnung_produkt");
			zeigeInhalt($ergebnis);
			break;
	}
?>

	</body>
</html>
