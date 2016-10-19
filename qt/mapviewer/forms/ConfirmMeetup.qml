import QtQuick 2.4


ConfirmMeetupForm {
    id:frmConfirmMeetup
    property string uniqueID

    signal updateID()
    signal closeForm()
    btnMap1 {
        onClicked: closeForm();
    }
    Component.onCompleted: {
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {

            } else if (doc.readyState == XMLHttpRequest.DONE) {
                console.log("\nDone\ndoc.readyState:"+doc.readyState+"XMLHttpRequest.DONE:"+XMLHttpRequest.DONE);
                console.log("response:"+doc.responseText);
                var obj = JSON.parse(doc.responseText);
                txtAreaInroduction.text=obj.introduction;
                txtAreaMeeting_Agreement.text=obj.meeting_agreement;
                lblID.text=map.otherPerson;
            }
         }
        doc.open("GET", "http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=GetProfile&clientID="+map.otherPerson,false);
        doc.send();

        /*
        lblPersonNotInSameQuadrant.visible=false;
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {

            } else if (doc.readyState == XMLHttpRequest.DONE) {
                console.log("\nDone\ndoc.readyState:"+doc.readyState+"XMLHttpRequest.DONE:"+XMLHttpRequest.DONE);
                console.log("response:"+doc.responseText);
                if(doc.responseText=="person not in same quadrant.") {
                   lblPersonNotInSameQuadrant.visible=true;
                    return;
                }
                //var obj = JSON.parse(doc.responseText);
                lblPersonNotInSameQuadrant.visible=true;
                lblPersonNotInSameQuadrant.text=doc.responseText;
                sentRequest=true;
            }
         }
        doc.open("GET", "http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=MeetRequest&FROMclientID="+appWindow.uid2+"&TOclientID="+map.otherPerson+"&lat="+map.positionOfMap.position.coordinate.latitude+"&longi="+map.positionOfMap.position.coordinate.longitude,false);
        doc.send();
        */
    }

    btnAccept {
        onClicked: {
            var doc = new XMLHttpRequest();
            doc.onreadystatechange = function() {
                if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {

                } else if (doc.readyState == XMLHttpRequest.DONE) {
                    console.log("\nDone\ndoc.readyState:"+doc.readyState+"XMLHttpRequest.DONE:"+XMLHttpRequest.DONE);
                    console.log("accept meetup response:"+doc.responseText);
                    //set color of other person to blue
                    for(var ind=0; ind<map.markers.length;ind++){
                        if(map.people[ind].clientID== map.otherPerson) {
                            map.markers[ind].changeMarkerColor(ind);
                        }
                    }
                    closeForm();
                }
             }
            doc.open("GET", "http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=AcceptRequest&MeetupID="+map.meetupID+"&TOclientID="+map.otherPerson+"&token=abc",false);
            doc.send();
        }
    }

    btnDecline {
        onClicked: {
            var doc = new XMLHttpRequest();
            doc.onreadystatechange = function() {
                if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {

                } else if (doc.readyState == XMLHttpRequest.DONE) {
                    console.log("\nDone\ndoc.readyState:"+doc.readyState+"XMLHttpRequest.DONE:"+XMLHttpRequest.DONE);
                    console.log("accept meetup response:"+doc.responseText);
                    closeForm();
                }
             }
            doc.open("GET", "http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=DeclineRequest&MeetupID="+map.meetupID+"&TOclientID="+map.otherPerson+"&token=abc",false);
            doc.send();
        }
    }

    btnPM {
        onClicked: {
            //display other window
            stackView.pop({item:page, immediate: true})
            stackView.push({ item:  Qt.resolvedUrl("../forms/PMs.qml") })
            stackView.currentItem.updateID.connect(function(){
                appWindow.uid2=stackView.currentItem.uniqueID;
                console.log("PM UID!"+stackView.currentItem.uniqueID);
                //stackView.closeForm()//some kind of race condition happens where hte forms is closed before I can get the uniqueID
            });
            stackView.currentItem.closeForm.connect(stackView.closeForm);
        }
    }
}
