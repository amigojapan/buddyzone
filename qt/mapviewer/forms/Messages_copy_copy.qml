import QtQuick 2.4
MessagesForm {    
    property int lastServerTime:0
    Item {
        Timer {
            interval: 5000; running: true; repeat: true
            onTriggered: checkMessages();
        }
    }
    function checkMessages() {
        /*http://www.teria.com/~koseki/memo/javascript/realtime_eval.html
obj=JSON.parse('{"LastFetchTime":1475473870,"Broadcase_Messages":[{"FROMclientID":"test","message_body":"my test message"},{"FROMclientID":"test","message_body":"my test message"},{"FROMclientID":"test","message_body":"my test message"},{"FROMclientID":"test","message_body":"there is a scary earthquake!! ooh no!"},{"FROMclientID":"test","message_body":"my test message"}],"Private_Messages":[{"FROMclientID":"usertest","message_body":"urlencodedmessage"},{"FROMclientID":"usertest","message_body":"hello world"},{"FROMclientID":"usertest","message_body":"urlencodedmessage"},{"FROMclientID":"usertest","message_body":"urlencodedmessage"}]}');


                lastServerTime = obj["LastFetchTime"];
                print("here lastServerTime:"+obj["LastFetchTime"]);

                print("Broadcast messages")
                for(var item in obj["Broadcase_Messages"]) {
                    var From=obj["Broadcase_Messages"][item]["FROMclientID"];
                    var Message=obj["Broadcase_Messages"][item]["message_body"];
                    print("here from:"+From+ " Message:"+Message);
                }
                print("Private_Messages")
                for(var item in obj["Private_Messages"]) {
                    var From=obj["Private_Messages"][item]["FROMclientID"];
                    var Message=obj["Private_Messages"][item]["message_body"];
                    print("here from:"+From+ " Message:"+Message);
                }
"ok"
*/
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {

            } else if (doc.readyState == XMLHttpRequest.DONE) {
                console.log("\nDone\ndoc.readyState:"+doc.readyState+"XMLHttpRequest.DONE:"+XMLHttpRequest.DONE);
                console.log("Messages:"+doc.responseText);
                var obj = JSON.parse(doc.responseText);
                lastServerTime = obj["LastFetchTime"];
                console.log("here lastServerTime:"+lastServerTime);
                console.log("Broadcase_Messages")
                for(var item in obj["Broadcase_Messages"]) {
                    var From=obj["Broadcase_Messages"][item]["FROMclientID"];
                    var Message=obj["Broadcase_Messages"][item]["message_body"];
                    console.log("here from:"+From+ " Message:"+Message);
                    lm1.append({nickname: From, MessageText: Message});
                    lv1.positionViewAtEnd();
                }
                console.log("Private_Messages")
                for(var item in obj["Private_Messages"]) {
                    var From=obj["Private_Messages"][item]["FROMclientID"];
                    var Message=obj["Private_Messages"][item]["message_body"];
                    console.log("here from:"+From+ " Message:"+Message);
                    lm2.append({nickname: From, MessageText: Message});
                    lv2.positionViewAtEnd();
                }
            }
        }
        doc.open("GET", "http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=FetchMessages&LastServerTime="+lastServerTime+"&lat="+map.positionOfMap.position.coordinate.latitude+"&longi="+map.positionOfMap.position.coordinate.longitude+"&TOclientID="+appWindow.uid2,false);
        doc.send();
    }
    btnBoradcast{
       onClicked: {
            console.log("broadcasst botton clicked");
            //lm1.append({nickname: "testuserX", MessageText: "hey everyone whats up!"});
           var doc = new XMLHttpRequest();
           doc.onreadystatechange = function() {
               if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {

               } else if (doc.readyState == XMLHttpRequest.DONE) {
                   console.log("\nDone\ndoc.readyState:"+doc.readyState+"XMLHttpRequest.DONE:"+XMLHttpRequest.DONE);
                   console.log("Response:"+doc.responseText);
               }
           }
           console.log("here2 username:"+appWindow.uid2);
           console.log("here2 latitude:"+map.positionOfMap.position.coordinate.latitude+"here2 longitude:"+map.positionOfMap.position.coordinate.longitude);
           if(appWindow.uid2==""){
               txtMessage.text="Sorry please login first";
               txtMessage.color="red"
               return;
           }
           doc.open("GET", "http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=boradcast&message_body="+txtMessage.text+"&FROMclientID="+appWindow.uid2+"&lat="+map.positionOfMap.position.coordinate.latitude+"&longi="+map.positionOfMap.position.coordinate.longitude,false);
           doc.send();
       }
    }
}


