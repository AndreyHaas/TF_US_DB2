<?php
	class DB {
		private $connection;
		
		public function __construct(){
			$dateiname = "demo_kunde_zugang.php";
			if(file_exists($dateiname)){
				require_once($dateiname);
				try{
					$this->connection = new PDO("mysql:host=$dbhost;dbname=$dbname; charset=utf8", $dbuser, $dbpass);
				} catch (PDOException $e){
					echo "<b>Im Konstruktor ist ein Fehler aufgetreten. Inhalt: " . $e;
				}
			} else{
				echo "<h3>Die Datei $dateiname existiert nicht.</h3>";
			}
		}

		public function SelectAusDB($tabelle){
			$sql = "SELECT * FROM $tabelle";
			$erg = $this->connection->query($sql);
			try{
				return $erg->fetchall(PDO::FETCH_ASSOC);
			} catch (PDOException $e){
				return "Das war nix";
			}
		}

		public function GetKunde($email, $pass){
			$pass = MD5($pass);
			$sql = "SELECT * FROM kunde WHERE Email='$email' AND Passwort='$pass'";
			$erg = $this->connection->query($sql);
			try{
				return $erg->fetchall(PDO::FETCH_ASSOC);
			} catch (PDOException $e) {
				echo "<br>Ein Fehler in GetKunde ist aufgetreten!<br>$e<br>";
			}
		}

		public function AddAbrechnung($k_ID){
			$sql = $this->connection->prepare("INSERT INTO abrechnung(Kunde_ID, Datum)
												VALUES (:k_ID, CURDATE())");
			$sql->bindParam(":k_ID", $k_ID);
			try{
				$erg = $sql->execute();
			} catch (PDOException $e) {
				echo "<br>Ein Fehler in AddAbrechnung ist aufgetreten!<br>$e<br>";
			}
		}

		public function GetAbrechnung($k_ID){
			$sql = "SELECT * FROM abrechnung WHERE Kunde_ID='$k_ID' ORDER BY Abrechnung_ID DESC LIMIT 1";
			$erg = $this->connection->query($sql);
			try{
				return $erg->fetchall(PDO::FETCH_ASSOC);
			} catch (PDOException $e) {
				echo "<br>Ein Fehler in GetAbrechnung ist aufgetreten!<br>$e<br>";
			}
		}

		public function AddKauf($kaufmich, $a_ID){
			$statement = "INSERT INTO abrechnung_produkt(Abrechnung_ID, Produkt_ID)
												VALUES";
			for($index = 0; $index < count($kaufmich); $index++){
				$statement = $statement . " ($a_ID," . $kaufmich[$index] . "),";
			}
			$statement = rtrim($statement, ",");
			$statement = $statement . ";";
			$sql = $this->connection->prepare($statement);
			try{
				$erg = $sql->execute();
			} catch (PDOException $e) {
				echo "<br>Ein Fehler in AddAbrechnung ist aufgetreten!<br>$e<br>";
			}
		}
	}
?>