import QtQuick 2.4
PMsForm {
    Component.onCompleted: {
       txtToNickname.text=map.otherPerson;
    }
    property int lastServerTime:0
    Item {
        Timer {
            interval: 5000; running: true; repeat: true
            onTriggered: checkMessages();
        }
    }
    function checkMessages() {
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {
            } else if (doc.readyState == XMLHttpRequest.DONE) {
                console.log("\nDone\ndoc.readyState:"+doc.readyState+"XMLHttpRequest.DONE:"+XMLHttpRequest.DONE);
                console.log("Messages:"+doc.responseText);
                var obj = JSON.parse(doc.responseText);
                lastServerTime = obj["LastFetchTime"];
                console.log("here lastServerTime:"+lastServerTime);
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
    btnPtivateMessage {
       onClicked: {
            console.log("broadcasst botton clicked");
            //lm1.append({nickname: "testuserX", MessageText: "hey everyone whats up!"});
           var doc = new XMLHttpRequest();
           doc.onreadystatechange = function() {
               if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {

               } else if (doc.readyState == XMLHttpRequest.DONE) {
                   console.log("\nDone\ndoc.readyState:"+doc.readyState+"XMLHttpRequest.DONE:"+XMLHttpRequest.DONE);
                   console.log("Response:"+doc.responseText);
                   lm2.append({nickname: txtToNickname.text, MessageText: txtMessage.text});
                   lv2.positionViewAtEnd();
               }
           }
           console.log("here2 username:"+appWindow.uid2);
           console.log("here2 latitude:"+map.positionOfMap.position.coordinate.latitude+"here2 longitude:"+map.positionOfMap.position.coordinate.longitude);
           if(appWindow.uid2==""){
               txtMessage.text="Sorry please login first";
               txtMessage.color="red"
               return;
           }
           doc.open("GET", "http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=PM&message_body="+txtMessage.text+"&FROMclientID="+appWindow.uid2+"&TOclientID="+txtToNickname.text,false);
           doc.send();
       }
    }
    btnMap {
        onClicked: closeForm();
    }
}


