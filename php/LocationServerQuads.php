<?php
	//http://amigojapan.duckdns.org/LocationServer/LocationServer.php?clientID="+clientID+"&unixtimestamp="+unix_timestamp()+"&lat="+lat+"&longi="+longi
	//http://amigojapan.duckdns.org/LocationServer/LocationServer.php?clientID=a&unixtimestamp=123&lat=123.456&longi=789.123
	/*

	CREATE USER 'LocalUser'@'localhost' IDENTIFIED BY 'mn.,dsajlk398dkjl$dsc';
	mysql -u LocalUser --password='mn.,dsajlk398dkjl$dsc'
	
	CREATE TABLE Table_Locations_Quads(clientID TEXT,unixtimestamp TEXT,lat TEXT,longi TEXT, XQuad Long, YQuad Long);
	CREATE TABLE Table_Broadcast_messages(FROMclientID TEXT, message_body TEXT,unixtimestamp TEXT, XQuad Long, YQuad Long);
	CREATE TABLE Table_Private_messages(FROMclientID TEXT, TOclientID TEXT, message_body TEXT,unixtimestamp TEXT);	
	CREATE TABLE Table_Profile(clientID TEXT, email TEXT, phone_number TEXT, introduction TEXT, meeting_agreement TEXT, mac_address TEXT, broken_agreements INTEGER,upheld_agreements INTEGER, dateable BOOLEAN, meetup_credits INTEGER, meetup_reffered_from_clientID TEXT);
	CREATE TABLE Table_Meetups(MeetupID TEXT, FROMclientID TEXT, TOclientID TEXT, meeting_agreement TEXT, meeting_accepted TEXT, agreepent_broken BOOLEAN,agreement_upheld BOOLEAN);
	
	GRANT ALL PRIVILEGES ON locations.Table_Locations_Quads, locations.Table_Broadcast_messages  TO 'LocalUser'@'localhost';
	GRANT ALL PRIVILEGES ON locations.Table_Broadcast_messages  TO 'LocalUser'@'localhost';
	GRANT ALL PRIVILEGES ON locations.Table_Private_messages TO 'LocalUser'@'localhost';
	GRANT ALL PRIVILEGES ON locations.Table_Profile TO 'LocalUser'@'localhost';
	GRANT ALL PRIVILEGES ON locations.Table_Meetups TO 'LocalUser'@'localhost';
	
	//DROP USER 'LocalUser'@'localhost';
	FLUSH PRIVILEGES;
	

	//(done)modify register to add profine
	//(done)modify fetch to return 3 arrays, one with the people in the same quad, another with the people on the surrounding quads, and one more with the outer quads
	//(done)fetch server time //http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=FetchServerTime
	//(done)broacast message http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=boradcast&message=urlencodedmessage&clientID=usertest&lat=123.456&longi=789.123
	//(done)private message http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=PM&message=urlencodedmessage&FROMclientID=usertest&TOclientID=usertest
	//(done)fetch messages http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=FetchMessages&&clientID=usertest
	//(done)update profile http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=UpdateProfile&contract=urlencodedmessage
	//(done)send meet request(check to see if in same quadrant) http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=MeetRequest&FROMclientID=usertest&TOclientID=usertest&contract=urlencodedmessage&lat=123.456&longi=789.123
	//accept meet request http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=AcceptRequest&RequestID=000001
	//decline meet request http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=DeclineRequest&RequestID=000001
	//poll for meeting accepted or rejected http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=PollMeetingReply&ClientID=user1&RequestID=000001
	//contact broken http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=ContractBroken&ClientID=user1&RequestID=000001
	//contract upheld http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=ContractUpheld&ClientID=user1&RequestID=000001
	//in operation register make the points of the person who reffered him go up by a certain ammount
	//(semi done, not tested yet) verify if macaddress matches the one in profile, by clientID
	//modify all functions that pass clientID to use the verify function
	//(maybe token would be easier for me to implement,provide token when registering?)add password to registration, sotre in profile? hasshing and salt and all that? confirm by email?
	//not mac_address imei http://askubuntu.com/questions/568921/get-unique-device-id-in-qml
	I pretty much have the structure of the Database I need
	now.... next I will implement the REST API, and then the painful part of modifying
	the app will happen, cause modifying hte client takes really long compile-run
	cycles, so it is very slow)
	https://www.digitalocean.com/community/tutorials/how-to-create-a-new-user-and-grant-permissions-in-mysql

	*/
	
	$pdo = new PDO('mysql:host=localhost;dbname=locations', "LocalUser", "mn.,dsajlk398dkjl\$dsc");// the \$  escapes the dollar ring, not part of the password
	$pdo->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
	$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	$quadsize=0.0008;//100;//0.0008;//139.7189-139.7181=0.0007999999999981355 so rounr up to 0.0008(this is about the size of my tablet screen's hight
	function get_quadnumber($xoryval,$quadsize) {
		return floor($xoryval/$quadsize);
	}	
	if(isset($_GET["lat"]) && isset($_GET["longi"])) {
		$lat = htmlspecialchars($_GET["lat"]);
		$longi = htmlspecialchars($_GET["longi"]);

		$XQuad=get_quadnumber($longi,$quadsize);
		$YQuad=get_quadnumber($lat,$quadsize);
		if(isset($_GET["showquad"])) {
			echo("XQuad:$XQuad YQuad:$YQuad");
		}
	}
	class Data{
		public $clientID = "empty";
		public $unixtimestamp = "empty";
		public $lat = "empty";
		public $longi = "empty";
	}

	function verify_if_mac_address_matches($clientID,$mac_address_gotten){
		//verify if macaddress matches the one in profile, by clientID
		$stmt = $GLOBALS['pdo']->prepare("SELECT mac_address FROM Table_Profile WHERE clientID=:clientID;");
		$stmt->bindParam(':clientID', $clientID);

		$stmt->execute();
		

		$result = $stmt->fetch(PDO::FETCH_OBJ);
		
		if($mac_address_gotten==$result->mac_address) {
			return true;
		} else {
			return false;
		}
	}

	function fetch_one_quad($XQ,$YQ){
		//http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=fetch&clientID=test&lat=200&longi=100&unixtimestamp=100
		$stmt = $GLOBALS['pdo']->prepare("SELECT clientID, unixtimestamp, lat, longi FROM Table_Locations_Quads WHERE XQuad=:XQuad AND YQuad=:YQuad;");
		//$stmt->bindParam(':clientID', $clientID);
		//$stmt->bindParam(':unixtimestamp', $unixtimestamp);
		//$stmt->bindParam(':lat', $lat);
		//$stmt->bindParam(':longi', $longi);
		$XQuad2=$XQ;
		$YQuad2=$YQ;
		$stmt->bindValue(':XQuad', $XQuad2);
		$stmt->bindValue(':YQuad', $YQuad2);

		$stmt->execute();
		

		$data_array = array();
		while($result = $stmt->fetch(PDO::FETCH_OBJ)) {
			$item = new Data();
			$item->clientID = $result->clientID;
			$item->unixtimestamp = $result->unixtimestamp;
			$item->lat = $result->lat;
			$item->longi = $result->longi;
			array_push($data_array, $item);//$data_array.push($item);
		}
		return $data_array;
		echo json_encode($data_array);	
	}
	function fetch(){
		class All_Quads{
			public $my_quad = "empty";
			public $surrounding_quads = "empty";
			public $outer_quads = "empty";
		}
		$all_quads = new All_Quads();
		$XQuad2=$GLOBALS['XQuad'];
		$YQuad2=$GLOBALS['YQuad'];
		$all_quads->my_quad = fetch_one_quad($XQuad2,$YQuad2);
		
		$all_quads->surrounding_quads = array();
		$all_quads->outer_quads = array();
		
		//top
		$XQuad2=$GLOBALS['XQuad'];
		$YQuad2=$GLOBALS['YQuad']-1;
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->surrounding_quads, $item);
		
		//bottom
		$XQuad2=$GLOBALS['XQuad'];
		$YQuad2=$GLOBALS['YQuad']+1;
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->surrounding_quads, $item);
	
		//right
		$XQuad2=$GLOBALS['XQuad']+1;
		$YQuad2=$GLOBALS['YQuad'];
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->surrounding_quads, $item);

		//left
		$XQuad2=$GLOBALS['XQuad']-1;
		$YQuad2=$GLOBALS['YQuad'];
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->surrounding_quads, $item);

		//top right
		$XQuad2=$GLOBALS['XQuad']+1;
		$YQuad2=$GLOBALS['YQuad']-1;
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->surrounding_quads, $item);

		//top left
		$XQuad2=$GLOBALS['XQuad']-1;
		$YQuad2=$GLOBALS['YQuad']-1;
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->surrounding_quads, $item);

		//bottom right
		$XQuad2=$GLOBALS['XQuad']+1;
		$YQuad2=$GLOBALS['YQuad']+1;
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->surrounding_quads, $item);

		//bottom left
		$XQuad2=$GLOBALS['XQuad']-1;
		$YQuad2=$GLOBALS['YQuad']+1;
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->surrounding_quads, $item);
		
		/*
		ABCDE
		QSSSF
		PSMSG
		OSSSH
		NLKJI
		*/
		
		//A
		$XQuad2=$GLOBALS['XQuad']-2;
		$YQuad2=$GLOBALS['YQuad']-2;
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->outer_quads, $item);
		
		//B
		$XQuad2=$GLOBALS['XQuad']-1;
		$YQuad2=$GLOBALS['YQuad']-2;
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->outer_quads, $item);
	
		//C
		$XQuad2=$GLOBALS['XQuad'];
		$YQuad2=$GLOBALS['YQuad']-2;
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->outer_quads, $item);

		//D
		$XQuad2=$GLOBALS['XQuad']+1;
		$YQuad2=$GLOBALS['YQuad']-2;
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->outer_quads, $item);

		//E
		$XQuad2=$GLOBALS['XQuad']+2;
		$YQuad2=$GLOBALS['YQuad']-2;
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->outer_quads, $item);

		//I
		$XQuad2=$GLOBALS['XQuad']+2;
		$YQuad2=$GLOBALS['YQuad']+2;
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->outer_quads, $item);
		
		//J
		$XQuad2=$GLOBALS['XQuad']+1;
		$YQuad2=$GLOBALS['YQuad']+2;
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->outer_quads, $item);
	
		//K
		$XQuad2=$GLOBALS['XQuad'];
		$YQuad2=$GLOBALS['YQuad']+2;
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->outer_quads, $item);

		//L
		$XQuad2=$GLOBALS['XQuad']-1;
		$YQuad2=$GLOBALS['YQuad']+2;
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->outer_quads, $item);

		//N
		$XQuad2=$GLOBALS['XQuad']-2;
		$YQuad2=$GLOBALS['YQuad']+2;
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->outer_quads, $item);

		//F
		$XQuad2=$GLOBALS['XQuad']+2;
		$YQuad2=$GLOBALS['YQuad']-1;
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->outer_quads, $item);

		//G
		$XQuad2=$GLOBALS['XQuad']+2;
		$YQuad2=$GLOBALS['YQuad'];
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->outer_quads, $item);

		//H
		$XQuad2=$GLOBALS['XQuad']+2;
		$YQuad2=$GLOBALS['YQuad']+1;
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->outer_quads, $item);

		//Q
		$XQuad2=$GLOBALS['XQuad']-2;
		$YQuad2=$GLOBALS['YQuad']-1;
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->outer_quads, $item);

		//P
		$XQuad2=$GLOBALS['XQuad']-2;
		$YQuad2=$GLOBALS['YQuad'];
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->outer_quads, $item);

		//O
		$XQuad2=$GLOBALS['XQuad']-2;
		$YQuad2=$GLOBALS['YQuad']+1;
		$item = fetch_one_quad($XQuad2,$YQuad2);		
		array_push($all_quads->outer_quads, $item);

		echo json_encode($all_quads);
	}
	if(htmlspecialchars($_GET["operation"])=="set"){
		//http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=set&clientID=test2&lat=200&longi=200&unixtimestamp=100
		if(htmlspecialchars($_GET["clientID"])=="") {
			fetch();
			return;
		}
		//UPDATE Table_Locations_Quads set lat=35.8444, longi=139.7272 where clientID='test';
		$stmt = $GLOBALS['pdo']->prepare("UPDATE Table_Locations_Quads set lat=:lat, longi=:longi, unixtimestamp=:unixtimestamp, XQuad=:XQuad,YQuad=:YQuad where clientID=:clientID;");
		$stmt->bindParam(':clientID', $clientID);
		$stmt->bindParam(':unixtimestamp', $unixtimestamp);
		$stmt->bindParam(':lat', $lat);
		$stmt->bindParam(':longi', $longi);
		$stmt->bindParam(':XQuad', $XQuad);
		$stmt->bindParam(':YQuad', $YQuad);
	
	
	
		$clientID = htmlspecialchars($_GET["clientID"]);
		$unixtimestamp = htmlspecialchars($_GET["unixtimestamp"]);
		$lat = htmlspecialchars($_GET["lat"]);
		$longi = htmlspecialchars($_GET["longi"]);
		
		$stmt->execute();
		fetch();
	} else if(htmlspecialchars($_GET["operation"])=="fetch") {
		fetch();
	} else if(htmlspecialchars($_GET["operation"])=="register") {
		//regisater http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=register&clientID=test7&lat=100&longi=100&unixtimestamp=100&email=test@test.com&phone_number=09037368364&introduction=hello I am test, nice to meet you&meeting_agreement=I want to meet someone to have a cup of coffee&mac_address=ab:ab:ab:ab&dateable=false&meetup_reffered_from_clientID=test2
		$stmt = $GLOBALS['pdo']->prepare("INSERT INTO Table_Locations_Quads (clientID, unixtimestamp, lat, longi, XQuad ,YQuad) VALUES (:clientID, :unixtimestamp, :lat, :longi, :XQuad, :YQuad);");
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
		
		$result=$stmt->execute();
		if(!$result){
			die("<BR>statement failed");
		}
		//CREATE TABLE Table_Profile(clientID TEXT, email TEXT, phone_number TEXT, introduction TEXT, meeting_agreement TEXT, mac_address TEXT, broken_agreements INTEGER,upheld_agreements INTEGER, dateable BOOLEAN, meetup_credits INTEGER, meetup_reffered_from_clientID TEXT);
		$stmt = $GLOBALS['pdo']->prepare("INSERT INTO Table_Profile set clientID=:clientID, email=:email, phone_number=:phone_number, introduction=:introduction, meeting_agreement=:meeting_agreement, mac_address=:mac_address, broken_agreements=0, upheld_agreements=0, dateable=:dateable, meetup_credits=5, meetup_reffered_from_clientID=:meetup_reffered_from_clientID;");
		$stmt->bindParam(':clientID', $clientID);
		$stmt->bindParam(':email', $email);
		$stmt->bindParam(':phone_number', $phone_number);
		$stmt->bindParam(':introduction', $introduction);
		$stmt->bindParam(':meeting_agreement', $meeting_agreement);
		$stmt->bindParam(':mac_address', $mac_address);	
		$stmt->bindParam(':dateable', $dateable);	
		$stmt->bindParam(':meetup_reffered_from_clientID', $meetup_reffered_from_clientID);	
	
	
		// insert one row
		$clientID = htmlspecialchars($_GET["clientID"]);		
		$email = htmlspecialchars($_GET["email"]);
		$phone_number = htmlspecialchars($_GET["phone_number"]);
		$introduction = htmlspecialchars($_GET["introduction"]);
		$meeting_agreement = htmlspecialchars($_GET["meeting_agreement"]);
		$mac_address = htmlspecialchars($_GET["mac_address"]);
		$dateable = htmlspecialchars($_GET["dateable"]);
		$meetup_reffered_from_clientID = htmlspecialchars($_GET["meetup_reffered_from_clientID"]);

		$result=$stmt->execute();
		if(!$result){
			die("<BR>statement failed");
		}

		echo "<BR>registration complete $result";
	} else if(htmlspecialchars($_GET["operation"])=="FetchServerTime") {
		//http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=FetchServerTime
		echo time(); 
	} else if(htmlspecialchars($_GET["operation"])=="boradcast") {
		//http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=boradcast&message_body=my%20test%20message&unixtimestamp=100&FROMclientID=test&lat=100&longi=100
		//CREATE TABLE Table_Broadcast_messages(FROMclientID TEXT, message_body TEXT,unixtimestamp TEXT, XQuad Long, YQuad Long);
		$stmt = $GLOBALS['pdo']->prepare("INSERT INTO Table_Broadcast_messages set FROMclientID=:FROMclientID, message_body=:message_body,unixtimestamp=UNIX_TIMESTAMP(), XQuad=:XQuad, YQuad=:YQuad;");
		$stmt->bindParam(':FROMclientID', $FROMclientID);
		$stmt->bindParam(':message_body', $message_body);		
		//$stmt->bindParam(':unixtimestamp', $unixtimestamp);
		$stmt->bindParam(':XQuad', $XQuad);
		$stmt->bindParam(':YQuad', $YQuad);
	
	
	
		$FROMclientID = htmlspecialchars($_GET["FROMclientID"]);
		$message_body = htmlspecialchars($_GET["message_body"]);
		//$unixtimestamp = htmlspecialchars($_GET["unixtimestamp"]);
		
		$stmt->execute();
		echo "broadcast complete";
	} else if(htmlspecialchars($_GET["operation"])=="FetchMessages") {		
		//http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=FetchMessages&LastServerTime=1472716560&lat=100&longi=100&TOclientID=usertest
		$stmt = $GLOBALS['pdo']->prepare("SELECT FROMclientID, message_body FROM Table_Broadcast_messages WHERE unixtimestamp>=:LastServerTime AND XQuad=:XQuad AND YQuad=:YQuad");
		$stmt->bindParam(':LastServerTime', $LastServerTime);
		$XQuad2=$GLOBALS['XQuad'];
		$YQuad2=$GLOBALS['YQuad'];
		$stmt->bindValue(':XQuad', $XQuad2);
		$stmt->bindValue(':YQuad', $YQuad2);
		
		$LastServerTime=$_GET["LastServerTime"];
		$stmt->execute();
		class All_Messages{
			public $LastFetchTime = 0;
			public $Broadcase_Messages = "empty";
			public $Private_Messages = "empty";
		}		
		class Message{
			public $FROMclientID = "empty";
			public $message_body = "empty";
		}
		
		$all_messages = new All_Messages();
		$all_messages->LastFetchTime= time();
		$data_array = array();
		while($result = $stmt->fetch(PDO::FETCH_OBJ)) {
			$item = new Message();
			$item->FROMclientID=$result->FROMclientID;
			$item->message_body=$result->message_body;
			array_push($data_array, $item);
		}
		$all_messages->Broadcase_Messages = $data_array;
		
		
		$stmt = $GLOBALS['pdo']->prepare("SELECT FROMclientID, message_body FROM Table_Private_messages WHERE unixtimestamp>=:LastServerTime AND TOclientID=:TOclientID");
		$stmt->bindParam(':LastServerTime', $LastServerTime);
		$stmt->bindParam(':TOclientID', $TOclientID);		
		
		$LastServerTime=$_GET["LastServerTime"];
		$TOclientID=$_GET["TOclientID"];
		
		$stmt->execute();
		
		$data_array = array();		
		while($result = $stmt->fetch(PDO::FETCH_OBJ)) {
			$item = new Message();
			$item->FROMclientID=$result->FROMclientID;
			$item->message_body=$result->message_body;
			array_push($data_array, $item);
		}
		$all_messages->Private_Messages = $data_array;
		echo json_encode($all_messages);	
	} else if(htmlspecialchars($_GET["operation"])=="PM") {
		//private message http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=PM&message_body=urlencodedmessage&FROMclientID=usertest&TOclientID=usertest
		//CREATE TABLE Table_Private_messages (FROMclientID TEXT, TOclientID TEXT, message_body TEXT,unixtimestamp TEXT);
		$stmt = $GLOBALS['pdo']->prepare("INSERT INTO Table_Private_messages set FROMclientID=:FROMclientID,TOclientID=:TOclientID, message_body=:message_body,unixtimestamp=UNIX_TIMESTAMP();");
		$stmt->bindParam(':FROMclientID', $FROMclientID);
		$stmt->bindParam(':TOclientID', $TOclientID);
		$stmt->bindParam(':message_body', $message_body);		
	
		$FROMclientID = htmlspecialchars($_GET["FROMclientID"]);
		$TOclientID = htmlspecialchars($_GET["TOclientID"]);
		$message_body = htmlspecialchars($_GET["message_body"]);

		$stmt->execute();
		echo "message sent";
	} else if(htmlspecialchars($_GET["operation"])=="UpdateProfile") {
		//update profile http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=UpdateProfile&clientID=test8&email=test@test.com&phone_number=09037368364&introduction=hello I am test, nice to meet you&meeting_agreement=I want to meet someone to have a cup of coffee test hey&&dateable=false	
		$stmt = $GLOBALS['pdo']->prepare("UPDATE Table_Profile set clientID=:clientID, email=:email, phone_number=:phone_number, introduction=:introduction, meeting_agreement=:meeting_agreement, dateable=:dateable;");
		$stmt->bindParam(':clientID', $clientID);
		$stmt->bindParam(':email', $email);
		$stmt->bindParam(':phone_number', $phone_number);
		$stmt->bindParam(':introduction', $introduction);
		$stmt->bindParam(':meeting_agreement', $meeting_agreement);
		$stmt->bindParam(':dateable', $dateable);	
	
	
		// insert one row
		$clientID = htmlspecialchars($_GET["clientID"]);		
		$email = htmlspecialchars($_GET["email"]);
		$phone_number = htmlspecialchars($_GET["phone_number"]);
		$introduction = htmlspecialchars($_GET["introduction"]);
		$meeting_agreement = htmlspecialchars($_GET["meeting_agreement"]);
		$dateable = htmlspecialchars($_GET["dateable"]);
				
		$stmt->execute();
		echo "profile updated.";	
	} else if(htmlspecialchars($_GET["operation"])=="MeetRequest") {
		//send meet request http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=MeetRequest&FROMclientID=usertest&TOclientID=test8&contract=urlencodedmessage&lat=123.456&longi=189.123
		//(check to see if other user is in same quadrant)
		$stmt = $GLOBALS['pdo']->prepare("SELECT XQuad, YQuad FROM Table_Locations_Quads WHERE (XQuad=:XQuad AND YQuad=:YQuad) AND clientID=:TOclientID;");
		$stmt->bindParam(':TOclientID', $TOclientID);
		$XQuad2=$GLOBALS['XQuad'];
		$YQuad2=$GLOBALS['YQuad'];
		$stmt->bindValue(':XQuad', $XQuad2);
		$stmt->bindValue(':YQuad', $YQuad2);
		
		$TOclientID = htmlspecialchars($_GET["TOclientID"]);
		
		$stmt->execute();
		

		$result = $stmt->fetch(PDO::FETCH_OBJ);
		
		if($result) {
			//CREATE TABLE Table_Meetups (MeetupID TEXT, FROMclientID TEXT, TOclientID TEXT, meeting_agreement TEXT, meeting_accepted TEXT, agreepent_broken BOOLEAN,agreement_upheld BOOLEAN);
			//fetch TOclientID's meeting agreement from his profile SELECT meeting_agreement FROM Table_Profile WHERE clientID='test8';
			echo "person in same quadrant.";
			$stmt = $GLOBALS['pdo']->prepare("SELECT meeting_agreement FROM Table_Profile WHERE clientID=:TOclientID;");
			$stmt->bindParam(':TOclientID', $TOclientID);
			
			$TOclientID = htmlspecialchars($_GET["TOclientID"]);
			
			$stmt->execute();
			

			$result = $stmt->fetch(PDO::FETCH_OBJ);
			
			$meeting_agreement=$result->meeting_agreement;
			
			$meetingID=uniqid();
			
			$stmt = $GLOBALS['pdo']->prepare("INSERT INTO Table_Meetups set MeetupID='".$meetingID."', FROMclientID=:FROMclientID, TOclientID=:TOclientID, meeting_agreement=:meeting_agreement, meeting_accepted='Pending', agreepent_broken=FALSE,agreement_upheld=FALSE;");
			$stmt->bindParam(':FROMclientID', $FROMclientID);
			$stmt->bindParam(':TOclientID', $TOclientID);
			$stmt->bindParam(':meeting_agreement', $meeting_agreement);
		
		
			// insert one row
			$FROMclientID = htmlspecialchars($_GET["FROMclientID"]);
			$TOclientID = htmlspecialchars($_GET["TOclientID"]);
			
			$result=$stmt->execute();
			if(!$result){
				die("<BR>statement failed");
			} else {
				echo "meetingID=$meetingID";
			}
		} else {
			echo "person not in same quadrant.";
		}
	} else if(htmlspecialchars($_GET["operation"])=="AcceptRequest") {
		//accept meet request http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=AcceptRequest&MeetupID=57d11a6b6a8c1&TOclientID=test8&token=abc
		//check to see if the stuff exists
		$stmt = $GLOBALS['pdo']->prepare("SELECT MeetupID FROM Table_Meetups WHERE MeetupID=:MeetupID AND TOclientID=:TOclientID;");
		$stmt->bindParam(':MeetupID', $MeetupID);
		$stmt->bindParam(':TOclientID', $TOclientID);
	
		$MeetupID = htmlspecialchars($_GET["MeetupID"]);
		$TOclientID = htmlspecialchars($_GET["TOclientID"]);
		
		$stmt->execute();
		
		$result = $stmt->fetch(PDO::FETCH_OBJ);
		if(!$result){
			die("MeetupID or ToClientID or token error!");
		} else {
			echo "meetup accepted! ID=$result->MeetupID";
			$stmt = $GLOBALS['pdo']->prepare("UPDATE Table_Meetups SET meeting_accepted='Accepted' WHERE MeetupID=:MeetupID AND TOclientID=:TOclientID;");
			$stmt->bindParam(':MeetupID', $MeetupID);
			$stmt->bindParam(':TOclientID', $TOclientID);
		
			$MeetupID = htmlspecialchars($_GET["MeetupID"]);
			$TOclientID = htmlspecialchars($_GET["TOclientID"]);
			
			$result=$stmt->execute();
			if(!$result){
				die("<BR>statement failed");
			} else {
				echo "Updated!";
			}

		}
	} else if(htmlspecialchars($_GET["operation"])=="DeclineRequest") {
		//decline meet request http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=DeclineRequest&MeetupID=57d11a6b6a8c1&TOclientID=test8&token=abc
		//check to see if the stuff exists
		$stmt = $GLOBALS['pdo']->prepare("SELECT MeetupID FROM Table_Meetups WHERE MeetupID=:MeetupID AND TOclientID=:TOclientID;");
		$stmt->bindParam(':MeetupID', $MeetupID);
		$stmt->bindParam(':TOclientID', $TOclientID);
	
		$MeetupID = htmlspecialchars($_GET["MeetupID"]);
		$TOclientID = htmlspecialchars($_GET["TOclientID"]);
		
		$stmt->execute();
		
		$result = $stmt->fetch(PDO::FETCH_OBJ);
		if(!$result){
			die("MeetupID or ToClientID or token error!");
		} else {
			echo "meetup declined :( ID=$result->MeetupID";
			$stmt = $GLOBALS['pdo']->prepare("UPDATE Table_Meetups SET meeting_accepted='Declined' WHERE MeetupID=:MeetupID AND TOclientID=:TOclientID;");
			$stmt->bindParam(':MeetupID', $MeetupID);
			$stmt->bindParam(':TOclientID', $TOclientID);
		
			$MeetupID = htmlspecialchars($_GET["MeetupID"]);
			$TOclientID = htmlspecialchars($_GET["TOclientID"]);
			
			$result=$stmt->execute();
			if(!$result){
				die("<BR>statement failed");
			} else {
				echo "Updated!";
			}

		}

	} else if(htmlspecialchars($_GET["operation"])=="PollMeetingReply") {
		//poll for meeting accepted or rejected http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=PollMeetingReply&ClientID=user1&MeetupID=57d11a6b6a8c1&TOclientID=test8&token=abc
		//check to see if the stuff exists
		$stmt = $GLOBALS['pdo']->prepare("SELECT meeting_accepted FROM Table_Meetups WHERE MeetupID=:MeetupID AND TOclientID=:TOclientID;");
		$stmt->bindParam(':MeetupID', $MeetupID);
		$stmt->bindParam(':TOclientID', $TOclientID);
	
		$MeetupID = htmlspecialchars($_GET["MeetupID"]);
		$TOclientID = htmlspecialchars($_GET["TOclientID"]);
		
		$stmt->execute();
		
		$result = $stmt->fetch(PDO::FETCH_OBJ);
		if(!$result){
			die("MeetupID or ToClientID or token error!");
		} else {
			echo "status:$result->meeting_accepted";
		}

	} else if(htmlspecialchars($_GET["operation"])=="ContractBroken") {
		//contact broken http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=ContractBroken&MeetupID=57d11a6b6a8c1&TOclientID=test8&token=abc
		//check to see if the stuff exists
		$stmt = $GLOBALS['pdo']->prepare("SELECT FROMclientID FROM Table_Meetups WHERE MeetupID=:MeetupID AND TOclientID=:TOclientID;");
		$stmt->bindParam(':MeetupID', $MeetupID);
		$stmt->bindParam(':TOclientID', $TOclientID);
	
		$MeetupID = htmlspecialchars($_GET["MeetupID"]);
		$TOclientID = htmlspecialchars($_GET["TOclientID"]);
		
		$stmt->execute();
		
		$result = $stmt->fetch(PDO::FETCH_OBJ);
		if(!$result){
			die("MeetupID or ToClientID or token error!");
		} else {
			$stmt = $GLOBALS['pdo']->prepare("UPDATE Table_Profile SET broken_agreements=CONVERT(broken_agreements,DECIMAL)+1 WHERE clientID=:FROMclientID;");
			$stmt->bindParam(':FROMclientID', $FROMclientID);
		
			$FROMclientID = $result->FROMclientID; 
			echo "FROMclientID:$FROMclientID";
			$result=$stmt->execute();
			if(!$result){
				die("<BR>statement failed");
			} else {
				echo "Updated!";
			}

		}
	} else if(htmlspecialchars($_GET["operation"])=="ContractUpheld") {
		//contract upheld http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=ContractUpheld&MeetupID=57d11a6b6a8c1&TOclientID=test8&token=abc
		//check to see if the stuff exists
		$stmt = $GLOBALS['pdo']->prepare("SELECT FROMclientID FROM Table_Meetups WHERE MeetupID=:MeetupID AND TOclientID=:TOclientID;");
		$stmt->bindParam(':MeetupID', $MeetupID);
		$stmt->bindParam(':TOclientID', $TOclientID);
	
		$MeetupID = htmlspecialchars($_GET["MeetupID"]);
		$TOclientID = htmlspecialchars($_GET["TOclientID"]);
		
		$stmt->execute();
		
		$result = $stmt->fetch(PDO::FETCH_OBJ);
		if(!$result){
			die("MeetupID or ToClientID or token error!");
		} else {
			$stmt = $GLOBALS['pdo']->prepare("UPDATE Table_Profile SET upheld_agreements=CONVERT(upheld_agreements,DECIMAL)+1 WHERE clientID=:FROMclientID;");
			$stmt->bindParam(':FROMclientID', $FROMclientID);
		
			$FROMclientID = $result->FROMclientID; 
			echo "FROMclientID:$FROMclientID";
			$result=$stmt->execute();
			if(!$result){
				die("<BR>statement failed");
			} else {
				echo "Updated!";
			}

		}
	} else if(htmlspecialchars($_GET["operation"])=="CheckVersion") {
		echo "0.1";
	} else {
		die("opperation not supported.");
	}
?>
