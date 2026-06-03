<?php
	function testen($arr){
		echo "<pre>";
		echo "Anzahl Elemente in arr: " . count($arr) . "<br>";
		print_r($arr);
		echo "</pre>";
	}

	function zeigeProdukte($ergebnis){
		echo "<br><form action='demo_kunde_main.php' method='post'>";
		echo "<label for='produkt'>Wähle ein oder mehrere Produkte aus:</label><br>";
		echo "<select id='produkt' name='produkt[]' size='5' multiple>";
		foreach($ergebnis as $key => $value){
			$wert = $value["Produkt_ID"];
			echo "<option value = $wert>" . $value["Produkt_Name"] . " -> " . $value["Euro_Preis"] . " Euro" . "</option>";
		}
		echo "</select>";
		echo "<br><br><input type='submit'>";
		echo "</form>";
	}

	function zeigeLogin(){
		echo "<h3>Log Dich im Shop ein. JETZT!</h3>";
		echo "<form action='demo_kunde_main.php' method='post'>";
		echo "<label for='email'>Email: </label>";
		echo "<input id='email' type='text' name='email' maxlength='50'>";
		echo "<br>";
		echo "<label for='pass'>Passwort: </label>";
		echo "<input id='pass' type='password' name='pass' maxlength='50'>";
		echo "<br>";
		echo "<br><input type='submit' value = 'Log In'>";
		echo "</form>";
		echo "<hr>";
	}							
?>