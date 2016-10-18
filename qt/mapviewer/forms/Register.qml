import QtQuick 2.4


RegisterForm {
    id:frmRegister
    property string uniqueID
    signal updateID()
    signal closeForm()

    btnOK {
        onClicked: {
            uniqueID=txtID.text
            //console.log("btnOK clicked");
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
                        login()
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
            }
            updateID()
            //map.users[txtID]=map.addMarkerAtCenter();
            //closeForm()
        }
        doc.open("GET", "http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=register&clientID="+uniqueID+"&lat="+map.positionOfMap.position.coordinate.latitude+"&longi="+map.positionOfMap.position.coordinate.longitude+"&email="+txtEmail.text+"&phone_number="+txtPhone.text+"&introduction="+txtAreaInroduction.text+"&meeting_agreement="+txtAreaMeeting_Agreement.text+"&mac_address=ab:ab:ab:ab&dateable=false&meetup_reffered_from_clientID="+txtRefferedFromID.text,false);
        doc.send();
        //closeForm()
        //end of our code

    }

    btnCloseForm{
        onClicked: closeForm();
    }

}
