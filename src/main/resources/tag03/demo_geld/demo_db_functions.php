<?php
	function testen($arr){
		echo "<pre>";
		echo "Anzahl Elemente in arr: " . count($arr) . "<br>";
		print_r($arr);
		echo "</pre>";
	}

	function zeigeInhalt($ergebnis){
		$heads = $ergebnis[0];
		echo "<table border=1>";
		echo "<tr>";
		foreach($heads as $a => $b){
			echo "<th>$a</th>";
		}
		echo "</tr>";
		foreach($ergebnis as $key => $value){
			echo "<tr>";
			foreach($value as $a => $b){
				echo "<td style='text-align:center'>$b</th>";
			}
			echo "</tr>";
		}
		echo "</table>";
	}

	function tabellen($ergebnis, $db){
		echo "<br><form action='demo_db_main.php' method='post'>";
		echo "<label>Wähle eine Tabelle:</label><br>";
		echo "<select name='auswahl' size='5'>";
		foreach($ergebnis as $key => $value){
			echo "<option>" . $value['Tables_in_demo_geld_her'] . "</option>";
		}
		echo "</select><br>";
		echo "<br><input type='submit' value = 'Tabelle holen'>";
		echo "</form>";
		echo "<hr>";
	}				

	function kunde($ergebnis, $db){
		echo "<br><form action='demo_db_main.php' method='post'>";
		echo "<label for='vor'>Vorname: </label>";
		echo "<input id='vor' type='text' name='vorname' maxlength='50'>";
		echo "<br>";
		echo "<label for='nach'>Nachname: </label>";
		echo "<input id='nach' type='text' name='nachname' maxlength='50'>";
		echo "<br>";
		echo "<label for='email'>Email: </label>";
		echo "<input id='email' type='text' name='email' maxlength='50'>";
		echo "<br>";
		echo "<label for='pass'>Passwort: </label>";
		echo "<input id='pass' type='password' name='pass' maxlength='50'>";
		echo "<br><br><input type='submit'>";
		echo "</form>";
	}				
	function produkt($ergebnis, $db){
		$ergebnis = $db->SelectAusDB("hersteller");
		echo "<br><form action='demo_db_main.php' method='post'>";
		echo "<label for='name'>Produkt-Name: </label>";
		echo "<input id='name' type='text' name='name' maxlength='50'>";
		echo "<br>";
		echo "<label for='preis'>Preis in Euro: </label>";
		echo "<input id='preis' type='text' name='preis' maxlength='50'>";
		echo "<br><br>";
		echo "<label for='hersteller'>Wähle einen Hersteller aus:</label><br>";
		echo "<select id='hersteller' name='hersteller' size='5'>";
		foreach($ergebnis as $key => $value){
			$wert = $value["Hersteller_ID"];
			echo "<option value = $wert>" . $value["Hersteller_Name"] . "</option>";
		}
		echo "</select>";
		echo "<br><br><input type='submit'>";
		echo "</form>";
	}				
	function hersteller($ergebnis, $db){
		$ergebnis = $db->SelectAusDB("spedition");
		echo "<br><form action='demo_db_main.php' method='post'>";
		echo "<label for='name'>Hersteller-Name: </label>";
		echo "<input id='name' type='text' name='name' maxlength='50'>";
		echo "<br><br>";
		echo "<label for='spedition'>Wähle eine Spedition aus:</label><br>";
		echo "<select id='spedition' name='spedition' size='5'>";
		foreach($ergebnis as $key => $value){
			$wert = $value["Spedition_ID"];
			echo "<option value = $wert>" . $value["Spedition_Name"] . "</option>";
		}
		echo "</select>";
		echo "<br><br><input type='submit'>";
		echo "</form>";
	}				
	function spedition($ergebnis, $db){
		echo "<br><form action='demo_db_main.php' method='post'>";
		echo "<label for='name'>Spedition-Name: </label>";
		echo "<input id='name' type='text' name='name' maxlength='50'>";
		echo "<br><br><input type='submit'>";
		echo "</form>";
	}
?>