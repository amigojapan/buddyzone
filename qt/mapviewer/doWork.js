//definition
WorkerScript {
        id: myWorker
        source: "../doWork.js"// WorkerScript: Cannot find source file "qrc:///map/doWork.js"

        onMessage: {
            addMarkerAtCoordinate(QtPositioning.coordinate(messageObject.lat, messageObject.longi))
        }
    }
//call
myWorker.sendMessage(doc.responseText);
WorkerScript.onMessage = function(message) {
    // ... long-running operations and calculations are done here
    console.log("\nin worker\n message:"+message);
    var obj;
    var markerCounter=0;
    obj = JSON.parse(message);
    for(var item in obj) {
        if(obj[item]["lat"]!="Just Registered") {
            var lat=parseFloat(obj[item]["lat"]).toFixed(4)
            var longi=parseFloat(obj[item]["longi"]).toFixed(4)
            var clientID =obj[item]["clientID"]
            var resp = {};
            console.log("Client:"+clientID+" Marker at lat:"+ lat+"longi:"+longi);
            resp.clientID=clientID;
            resp.lat=lat;
            resp.longi=longi;
            WorkerScript.sendMessage(resp)
        }
    }
}
