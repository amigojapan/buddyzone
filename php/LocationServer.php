<?php
	//http://amigojapan.duckdns.org/LocationServer/LocationServer.php?clientID="+clientID+"&unixtimestamp="+unix_timestamp()+"&lat="+lat+"&longi="+longi
	//http://amigojapan.duckdns.org/LocationServer/LocationServer.php?clientID=a&unixtimestamp=123&lat=123.456&longi=789.123
	/*
	CREATE TABLE Table_Locations_Quads(clientID TEXT,unixtimestamp TEXT,lat TEXT,longi TEXT,XQuad Long,YQuad Long);
	https://www.digitalocean.com/community/tutorials/how-to-create-a-new-user-and-grant-permissions-in-mysql
	CREATE USER 'LocalUser'@'localhost' IDENTIFIED BY 'mn.,dsajlk398dkjl$dsc';
	GRANT ALL PRIVILEGES ON locations.Table_Locations TO 'LocalUser'@'localhost';
	//DROP USER 'LocalUser'@'localhost';
	FLUSH PRIVILEGES;
	mysql -u LocalUser --password='mn.,dsajlk398dkjl$dsc'
	*/
	
	#require_once("quads1.php");
	$width=1000;//maxmimum of double?1.7976931348623157E+308
	$height=1000;
	$board = new Board();
	$quadsize=100;
	$board->init2($quadsize,$width,$height);
	
	$lat = htmlspecialchars($_GET["lat"]);
	$longi = htmlspecialchars($_GET["longi"]);

	$XQuad=$board->get_quadnumber($longi,$quadsize);
	$YQuad=$board->get_quadnumber($lat,$quadsize);

	function fetch(){
		$dbh = new PDO('mysql:host=localhost;dbname=locations', "LocalUser", "mn.,dsajlk398dkjl\$dsc");// the \$  escapes the dollar ring, not part of the password
		$stmt = $dbh->prepare("SELECT clientID, unixtimestamp, lat, longi FROM Table_Locations WHERE XQuad=:XQuad AND YQuad=:YQuad;");
		$stmt->bindParam(':clientID', $clientID);
		$stmt->bindParam(':unixtimestamp', $unixtimestamp);
		$stmt->bindParam(':lat', $lat);
		$stmt->bindParam(':longi', $longi);
		$stmt->bindParam(':XQuad', $XQuad);
		$stmt->bindParam(':YQuad', $YQuad);
		
		$stmt->execute();
		
		class Data{
			public $clientID = "empty";
			public $unixtimestamp = "empty";
			public $lat = "empty";
			public $longi = "empty";
		}

		$data_array = array();
		while($result = $stmt->fetch(PDO::FETCH_OBJ)) {
			$item = new Data();
			$item->clientID = $result->clientID;
			$item->unixtimestamp = $result->unixtimestamp;
			$item->lat = $result->lat;
			$item->longi = $result->longi;
			array_push($data_array, $item);//$data_array.push($item);
		}
		echo json_encode($data_array);	
	}
	if(htmlspecialchars($_GET["operation"])=="set"){
		if(htmlspecialchars($_GET["clientID"])=="") {
			fetch();
			return;
		}
		//UPDATE Table_Locations set lat=35.8444, longi=139.7272 where clientID='test';
		$dbh = new PDO('mysql:host=localhost;dbname=locations', "LocalUser", "mn.,dsajlk398dkjl\$dsc");// the \$  escapes the dollar ring, not part of the password
		$stmt = $dbh->prepare("UPDATE Table_Locations set lat=:lat, longi=:longi, unixtimestamp=:unixtimestamp, XQuad=:XQuad,YQuad=:YQuad where clientID=:clientID;");
		$stmt->bindParam(':clientID', $clientID);
		$stmt->bindParam(':unixtimestamp', $unixtimestamp);
		$stmt->bindParam(':lat', $lat);
		$stmt->bindParam(':longi', $longi);
		$stmt->bindParam(':XQuad', $XQuad);
		$stmt->bindParam(':YQuad', $YQuad);
	
	
	
		// insert one row
		$clientID = htmlspecialchars($_GET["clientID"]);
		$unixtimestamp = htmlspecialchars($_GET["unixtimestamp"]);
		$lat = htmlspecialchars($_GET["lat"]);
		$longi = htmlspecialchars($_GET["longi"]);
		
		$stmt->execute();
		fetch();
	} else if(htmlspecialchars($_GET["operation"])=="fetch") {
		fetch();
	} else if(htmlspecialchars($_GET["operation"])=="register") {
		$dbh = new PDO('mysql:host=localhost;dbname=locations', "LocalUser", "mn.,dsajlk398dkjl\$dsc");// the \$  escapes the dollar ring, not part of the password
		$stmt = $dbh->prepare("INSERT INTO Table_Locations (clientID, unixtimestamp, lat, longi) VALUES (:clientID, :unixtimestamp, :lat, :longi, :XQuad, :YQuad)");
		$stmt->bindParam(':clientID', $clientID);
		$stmt->bindParam(':unixtimestamp', $unixtimestamp);
		$stmt->bindParam(':lat', $lat);
		$stmt->bindParam(':longi', $longi);
		$stmt->bindParam(':XQuad', $XQuad);
		$stmt->bindParam(':YQuad', $YQuad);
	
	
	
		// insert one row
		$clientID = htmlspecialchars($_GET["clientID"]);
		$unixtimestamp = "Just Registered";
		$lat = "Just Registered";
		$longi = "Just Registered";
		$XQuad=NULL;
		$YQuad=NULL;
		
		$stmt->execute();
		echo "registration complete";
	}
?>
