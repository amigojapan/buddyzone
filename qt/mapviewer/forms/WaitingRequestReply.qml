import QtQuick 2.4


WaitingRequestReplyForm {
    id:frmWaitReply
    property bool sentRequest: false
    property string uniqueID
    property string meetupID: "not set"
    signal updateID()
    signal closeForm()
    Item {
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

            //lblPersonNotInSameQuadrant.visible=false;
            var doc = new XMLHttpRequest();
            doc.onreadystatechange = function() {
                if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {

                } else if (doc.readyState == XMLHttpRequest.DONE) {
                    console.log("\nDone\ndoc.readyState:"+doc.readyState+"XMLHttpRequest.DONE:"+XMLHttpRequest.DONE);
                    console.log("response:"+doc.responseText);
                    console.log("meetupID reached, ID"+doc.responseText)
                    meetupID=doc.responseText;
                    sentRequest=true;
                }
             }
            console.log("here4 http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=MeetRequest&FROMclientID="+appWindow.uid2+"&TOclientID="+map.otherPerson+"&lat="+map.positionOfMap.position.coordinate.latitude+"&longi="+map.positionOfMap.position.coordinate.longitude)
            doc.open("GET", "http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=MeetRequest&FROMclientID="+appWindow.uid2+"&TOclientID="+map.otherPerson+"&lat="+map.positionOfMap.position.coordinate.latitude+"&longi="+map.positionOfMap.position.coordinate.longitude,false);
            doc.send();

        }
        Timer {
            interval: 5000; running: true; repeat: true
            onTriggered: {
                if(sentRequest) {
                    checkingResponse();
                }
            }
        }
    }
    function checkingResponse() {
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {

            } else if (doc.readyState == XMLHttpRequest.DONE) {
                console.log("\nDone\ndoc.readyState:"+doc.readyState+"XMLHttpRequest.DONE:"+XMLHttpRequest.DONE);
                console.log("response:"+doc.responseText);
                //var obj = JSON.parse(doc.responseText)
                lblID.text=lblID.text+doc.responseText;
                if(doc.responseText!="status:Pending") {
                    sentRequest=false;
                }
                if(doc.responseText=="status:Accepted") {
                    lblIDPrompt.text="request accepted!";
                }
            }
         }
        console.log("here3 "+"http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=PollMeetingReply&FROMclientID="+appWindow.uid2+"&MeetupID="+meetupID+"&TOclientID="+map.otherPerson+"&token=abc");
        doc.open("GET", "http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=PollMeetingReply&FROMclientID="+appWindow.uid2+"&MeetupID="+meetupID+"&TOclientID="+map.otherPerson+"&token=abc",false);
        doc.send();
    }

    btnMap1 {
        onClicked: {
            //highlight other person so we can find them easily
            for(var ind=0; ind<map.markers.length;ind++){
                if(map.people[ind].clientID== map.otherPerson) {
                    map.markers[ind].changeMarkerColor(ind);
                }
            }
            closeForm();
        }
    }
    Component.onCompleted: {
        lblID.text=map.otherPerson;
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
    }

}
