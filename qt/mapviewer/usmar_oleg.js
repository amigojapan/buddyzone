/*
import QtQuick 2.5
import QtQuick.Controls 1.4
import QtLocation 5.6
import QtPositioning 5.5
*/

.pragma library

function make_mapbox_plugin_with_tokens(appWindow) {
    return Qt.createQmlObject ('import QtLocation 5.6; Plugin{ name:"mapbox"; parameters: PluginParameter { name: "mapbox.map_id"; value: "amigojapan.0olhcn7e" } PluginParameter { name: "mapbox.access_token"; value: "pk.eyJ1IjoiYW1pZ29qYXBhbiIsImEiOiJjaXIyNDJzdWswMnprZnFtOHB1Nzd6cDF3In0.Kt-IDXAncN8BiKLP-bKgTQ" }}', appWindow)
    //--plugin.mapbox.access_token pk.eyJ1IjoiYW1pZ29qYXBhbiIsImEiOiJjaXIyNDJzdWswMnprZnFtOHB1Nzd6cDF3In0.Kt-IDXAncN8BiKLP-bKgTQ --plugin.mapbox.map_id amigojapan.0olhcn7e
}

function unix_timestamp(){
        return Date.now() / 1000 | 0
}

function update_location_on_server(clientID,lat,long) {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {

        } else if (doc.readyState == XMLHttpRequest.DONE) {
            //console.log("\nDone\ndoc.readyState:"+doc.readyState+"XMLHttpRequest.DONE:"+XMLHttpRequest.DONE);
            //var a = doc.responseXML.documentElement;//for some reason this element does not exist
            //console.log(doc.responseText);
        }
    }
    doc.open("GET", "http://amigojapan.duckdns.org/LocationServer/LocationServer.php?operation=set&clientID="+clientID+"&unixtimestamp="+unix_timestamp()+"&lat="+lat+"&longi="+long,true);
    doc.send();
}
var map,markers;//global vars
function fetch_locations_from_server() {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {

        } else if (doc.readyState == XMLHttpRequest.DONE) {
            console.log("\nDone\ndoc.readyState:"+doc.readyState+"XMLHttpRequest.DONE:"+XMLHttpRequest.DONE);
            //var a = doc.responseXML.documentElement;//for some reason this element does not exist
            console.log(doc.responseText);
            var obj;
            var markerCounter=0;
            //obj = JSON.parse(doc.responseText);
            obj = JSON.parse("[{\"clientID\":\"test\",\"unixtimestamp\":\"test\",\"lat\":\"139.718383\",\"longi\":\"35.8442108\"}]");
            for(var item in obj) {
                var count = map.markers.length
                markerCounter++
                var marker = Qt.createQmlObject ('import QtQuick 2.0; Marker {}', map)
                map.addMapItem(marker)
                marker.z = map.z+1
                var coordinate = Qt.createQmlObject ('coordinate {}');
                coordinate.latitude=obj[item].latitude;
                coordinate.longitude=obj[item].longitude;
                console.log("ADDING MARKER:"+obj[item].latitude+","+obj[item].longitude);
                marker.coordinate = coordinate

                //update list of markers
                var myArray = new Array()
                for (var i = 0; i<count; i++){
                    myArray.push(markers[i])
                }
                myArray.push(marker)
                markers = myArray
            }
        }
    }
    var lat=500;
    var longi=500;
    doc.open("GET", "http://amigojapan.duckdns.org/LocationServer/LocationServer.php?operation=fetch&lat="+lat+"&longi="+longi,true);
    doc.send();
}

function update_people_positions(mapqml,markersqml) {
    map=mapqml;
    markers=markersqml;
    fetch_locations_from_server();
}
