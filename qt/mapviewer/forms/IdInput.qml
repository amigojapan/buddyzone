import QtQuick 2.4
import QtPositioning 5.5
import "../usmar_oleg.js" as Our_code


IdInputForm {
    id:uid
    property string uniqueID
    signal updateID()
    signal closeForm()

    btnOK {
        onClicked: {
            uniqueID=txtID.text
            console.log("btnOK clicked");
            var doc = new XMLHttpRequest();
            doc.onreadystatechange = function() {
                if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {

                } else if (doc.readyState == XMLHttpRequest.DONE) {
                    console.log("\nDone\ndoc.readyState:"+doc.readyState+"XMLHttpRequest.DONE:"+XMLHttpRequest.DONE);
                    console.log("version:"+doc.responseText);
                    var CurrentVersion=0.1;
                    var ServerVersion =parseFloat(doc.responseText);
                    console.log(ServerVersion);
                    if(CurrentVersion<ServerVersion){
                        updateWarning.visible=true;
                    }else{
                        appWindow.uid2=txtID.text;
                        firstFetch();
                        //login()
                    }
                }
            }
            doc.open("GET", "http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=CheckVersion",false);
            doc.send();
        }
    }
    function login(){
        //this is all our code, not QT's code Usmar Padow
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {

            } else if (doc.readyState == XMLHttpRequest.DONE) {
                console.log("\nDone\ndoc.readyState:"+doc.readyState+"XMLHttpRequest.DONE:"+XMLHttpRequest.DONE);
                console.log(doc.responseText);
                firstFetch();
            }
            updateID()
            //map.users[txtID]=map.addMarkerAtCenter();
            //closeForm()
        }
        doc.open("GET", "http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=register&clientID="+uniqueID,false);
        doc.send();
        //closeForm()
        //end of our code

    }
    function firstFetch(){
        console.log("first fetch");
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {

            } else if (doc.readyState == XMLHttpRequest.DONE) {
                var message=doc.responseText;
                var obj;
                var markerCounter=0;
                obj = JSON.parse(message);
                for(var item in obj["my_quad"]) {
                    var lat=parseFloat(obj["my_quad"][item]["lat"]).toFixed(4)
                    var longi=parseFloat(obj["my_quad"][item]["longi"]).toFixed(4)
                    var clientID =obj["my_quad"][item]["clientID"]
                    var resp = {};
                    if(isNaN(lat)) {
                        continue;
                    }
                    console.log("Client:"+clientID+" Marker created at lat:"+ lat+"longi:"+longi);
                    resp.clientID=clientID;
                    resp.lat=lat;
                    resp.longi=longi;
                    resp.index = map.addMarkerAtCoordinate(QtPositioning.coordinate(resp.lat, resp.longi));
                    map.people.push(resp);
                    //users[clientID]=resp;
                }

            }
        }

        //made it syncronous with false at the end
        console.log("http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=fetch&lat="+map.positionOfMap.position.coordinate.latitude+"&longi="+map.positionOfMap.position.coordinate.longitude);
        doc.open("GET", "http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=fetch&lat="+map.positionOfMap.position.coordinate.latitude+"&longi="+map.positionOfMap.position.coordinate.longitude,false);
        doc.send();
    }

    btnCloseForm{
        onClicked: closeForm();
    }

}
