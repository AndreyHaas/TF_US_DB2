<?php
	class DB {
		private $connection;
		
		public function __construct(){
			$dateiname = "demo_db_zugang.php";
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

		public function HoleTabellen(){
			$sql = "SHOW TABLES";
			$erg = $this->connection->query($sql);
			return $erg->fetchall(PDO::FETCH_ASSOC);
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

		public function AddKunde($daten){
			$sql = $this->connection->prepare("INSERT INTO kunde(Vorname, Nachname, Email, Passwort)
												VALUES (:vor, :nach, :email, :pass)");
			$sql->bindParam(":vor", $daten[0]);
			$sql->bindParam(":nach", $daten[1]);
			$sql->bindParam(":email", $daten[2]);
			$sql->bindParam(":pass", MD5($daten[3]));
			try{
				$erg = $sql->execute();
			} catch (PDOException $e) {
				echo "<br>Ein Fehler in AddKunde ist aufgetreten!<br>$e<br>";
			}
		}

		public function AddProdukt($daten){
			$sql = $this->connection->prepare("INSERT INTO produkt(Produkt_Name, Euro_Preis, Hersteller_ID)
												VALUES (:name, :preis, :hersteller_ID)");
			$sql->bindParam(":name", $daten[0]);
			$sql->bindParam(":preis", $daten[1]);
			$sql->bindParam(":hersteller_ID", $daten[2]);
			try{
				$erg = $sql->execute();
			} catch (PDOException $e) {
				echo "<br>Ein Fehler in AddProdukt ist aufgetreten!<br>$e<br>";
			}
		}

		public function AddHersteller($daten){
			$sql = $this->connection->prepare("INSERT INTO hersteller(Hersteller_Name, Spedition_ID)
												VALUES (:name, :spedition_ID)");
			$sql->bindParam(":name", $daten[0]);
			$sql->bindParam(":spedition_ID", $daten[1]);
			try{
				$erg = $sql->execute();
			} catch (PDOException $e) {
				echo "<br>Ein Fehler in AddSpedition ist aufgetreten!<br>$e<br>";
			}
		}

		public function AddSpedition($daten){
			$sql = $this->connection->prepare("INSERT INTO spedition(Spedition_Name)
												VALUES (:name)");
			$sql->bindParam(":name", $daten[0]);
			try{
				$erg = $sql->execute();
			} catch (PDOException $e) {
				echo "<br>Ein Fehler in AddSpedition ist aufgetreten!<br>$e<br>";
			}
		}
	}
?>