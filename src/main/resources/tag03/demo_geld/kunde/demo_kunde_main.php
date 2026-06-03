<html>
	<head>
		<style>
			html{ background: #999999; }
			body{ width:60%; margin-left:auto; margin-right:auto; background: #CCCCCC;}
		</style>
	</head>
	<body>
		<?php
		// http://www.rither.de/a/informatik/php-beispiele/strings/hash-eines-strings-bilden/
		// https://crackstation.net/
		// https://crackstation.net/crackstation-wordlist-password-cracking-dictionary.htm
		// https://github.com/defuse/crackstation-hashdb
			session_start();
			require "demo_kunde_class.php";
			require "demo_kunde_functions.php";
			$db = new DB();
			
			//session_unset();
			//session_destroy();
			if(!ISSET($_POST["email"]) || !ISSET($_SESSION["k_ID"])){
				zeigeLogin();
			}
			
			if(ISSET($_POST["email"]) && !empty($_POST["email"])){
				$email = $_POST["email"];
				$pass = $_POST["pass"];
				$kunde = $db->GetKunde($email, $pass);
//testen($kunde);
				if(count($kunde) >0){
					$k_ID = $kunde[0]["Kunde_ID"];
					$_SESSION["k_ID"] = $k_ID;
					$db->AddAbrechnung($k_ID);
					$ergebnis = $db->GetAbrechnung($k_ID);
					if(count($ergebnis) >0){
						$a_ID = $ergebnis[0]["Abrechnung_ID"];
						$_SESSION["a_ID"] = $a_ID;
//echo "<h1>$a_ID</h1>";
					}
					$ergebnis = $db->SelectAusDB("Produkt");
					zeigeProdukte($ergebnis);
				}else{
					echo "<h1>DU KOMMST .. HIER NICHT .. VORBEIIIII!!!!</h1>";
				}
			}
			if(ISSET($_SESSION["a_ID"]) && ISSET($_POST["produkt"])){
				$db->AddKauf($_POST["produkt"], $_SESSION["a_ID"]);
				$ergebnis = $db->SelectAusDB("Produkt");
				zeigeProdukte($ergebnis);
			}
		?>
	</body>
</html>
