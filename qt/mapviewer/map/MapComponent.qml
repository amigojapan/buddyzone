/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.5
import QtQuick.Controls 1.4
import QtLocation 5.6
import QtPositioning 5.5
import "../helper.js" as Helper
import "../usmar_oleg.js" as Our_code

//! [top]
Map {
    id: map
//! [top]
    property string otherPerson: "not set"
    property string meetupID: "not set"
    property variant people
    property alias positionOfMap :positionSource
    property variant users
    property variant markers
    property variant mapItems
    property int markerCounter: 0 // counter for total amount of markers. Resets to 0 when number of markers = 0
    property int currentMarker
    property int lastX : -1
    property int lastY : -1
    property int pressX : -1
    property int pressY : -1
    property int jitterThreshold : 30
    property bool followme: false
    property variant scaleLengths: [5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 1000000, 2000000]
    property alias routeQuery: routeQuery
    property alias routeModel: routeModel
    property alias geocodeModel: geocodeModel

    signal addMarkerSignal(variant cors)
    signal showGeocodeInfo()
    signal geocodeFinished()
    signal routeError()
    signal coordinatesCaptured(double latitude, double longitude)
    signal showMainMenu(variant coordinate)
    signal showMarkerMenu(variant coordinate)
    signal showRouteMenu(variant coordinate)
    signal showPointMenu(variant coordinate)
    signal showRouteList()

    Timer {
        id: timerPollServerMeetupRequests
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            //poll meetup requests
            var doc = new XMLHttpRequest();
            doc.onreadystatechange = function() {
                if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {

                } else if (doc.readyState == XMLHttpRequest.DONE) {
                    console.log("\nDone\ndoc.readyState:"+doc.readyState+"XMLHttpRequest.DONE:"+XMLHttpRequest.DONE);
                    console.log("poll for meetup requests, response:"+doc.responseText);
                    if(doc.responseText=="meetup not awaiting" || doc.responseText=="meetup timeout") {
                        return;
                    } else {
                        var obj = JSON.parse(doc.responseText);
                        timerPollServerMeetupRequests.running=false;
                        map.otherPerson=obj.from_who;
                        map.meetupID=obj.meetupid;
                        //display other window
                        stackView.pop({item:page, immediate: true})
                        stackView.push({ item:  Qt.resolvedUrl("../forms/ConfirmMeetup.qml") })
                        stackView.currentItem.updateID.connect(function(){
                            appWindow.uid2=stackView.currentItem.uniqueID;
                            console.log("PM UID!"+stackView.currentItem.uniqueID);
                            //stackView.closeForm()//some kind of race condition happens where hte forms is closed before I can get the uniqueID
                        });
                        stackView.currentItem.closeForm.connect(stackView.closeForm);
                    }
                    /*
                    var obj = JSON.parse(doc.responseText);
                    txtAreaInroduction.text=obj.introduction;
                    txtAreaMeeting_Agreement.text=obj.meeting_agreement;
                    lblID.text=map.otherPerson;
                    */
                }
             }
            if(appWindow.uid2=="") {
                //not logged in yet
                return;
            }
            console.log("http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=PollMeetingAwaiting&clientID="+encodeURIComponent(appWindow.uid2)+"&token=abc")
            doc.open("GET", "http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=PollMeetingAwaiting&clientID="+encodeURIComponent(appWindow.uid2)+"&token=abc",false);
            doc.send();
        }
    }

    onAddMarkerSignal: addMarkerAtCoordinate(cors);
    function geocodeMessage()
    {
        var street, district, city, county, state, countryCode, country, postalCode, latitude, longitude, text
        latitude = Math.round(geocodeModel.get(0).coordinate.latitude * 10000) / 10000
        longitude =Math.round(geocodeModel.get(0).coordinate.longitude * 10000) / 10000
        street = geocodeModel.get(0).address.street
        district = geocodeModel.get(0).address.district
        city = geocodeModel.get(0).address.city
        county = geocodeModel.get(0).address.county
        state = geocodeModel.get(0).address.state
        countryCode = geocodeModel.get(0).address.countryCode
        country = geocodeModel.get(0).address.country
        postalCode = geocodeModel.get(0).address.postalCode

        text = "<b>Latitude:</b> " + latitude + "<br/>"
        text +="<b>Longitude:</b> " + longitude + "<br/>" + "<br/>"
        if (street) text +="<b>Street: </b>"+ street + " <br/>"
        if (district) text +="<b>District: </b>"+ district +" <br/>"
        if (city) text +="<b>City: </b>"+ city + " <br/>"
        if (county) text +="<b>County: </b>"+ county + " <br/>"
        if (state) text +="<b>State: </b>"+ state + " <br/>"
        if (countryCode) text +="<b>Country code: </b>"+ countryCode + " <br/>"
        if (country) text +="<b>Country: </b>"+ country + " <br/>"
        if (postalCode) text +="<b>PostalCode: </b>"+ postalCode + " <br/>"
        return text
    }

    function calculateScale()
    {
        var coord1, coord2, dist, text, f
        f = 0
        coord1 = map.toCoordinate(Qt.point(0,scale.y))
        coord2 = map.toCoordinate(Qt.point(0+scaleImage.sourceSize.width,scale.y))
        dist = Math.round(coord1.distanceTo(coord2))

        if (dist === 0) {
            // not visible
        } else {
            for (var i = 0; i < scaleLengths.length-1; i++) {
                if (dist < (scaleLengths[i] + scaleLengths[i+1]) / 2 ) {
                    f = scaleLengths[i] / dist
                    dist = scaleLengths[i]
                    break;
                }
            }
            if (f === 0) {
                f = dist / scaleLengths[i]
                dist = scaleLengths[i]
            }
        }

        text = Helper.formatDistance(dist)
        scaleImage.width = (scaleImage.sourceSize.width * f) - 2 * scaleImageLeft.sourceSize.width
        scaleText.text = text
    }

    function deleteMarkers()
    {
        var count = map.markers.length
        for (var i = 0; i<count; i++){
            map.removeMapItem(map.markers[i])
            map.markers[i].destroy()
        }
        map.markers = []
        markerCounter = 0
    }

    function deleteMapItems()
    {
        var count = map.mapItems.length
        for (var i = 0; i<count; i++){
            map.removeMapItem(map.mapItems[i])
            map.mapItems[i].destroy()
        }
        map.mapItems = []
    }

    function addMarker()
    {
        var count = map.markers.length
        markerCounter++
        var marker = Qt.createQmlObject ('Marker {}', map)
        map.addMapItem(marker)
        marker.z = map.z+1
        marker.coordinate = mouseArea.lastCoordinate

        //update list of markers
        var myArray = new Array()
        for (var i = 0; i<count; i++){
            myArray.push(markers[i])
        }
        myArray.push(marker)
        markers = myArray
    }
    function addMarkerAtCoordinate(c)
    {//I need to rewrite this, cause it is slow as is
        var count = map.markers.length
        markerCounter++
        var marker = Qt.createQmlObject ('Marker {}', map)
        map.addMapItem(marker)
        marker.z = map.z+1
        marker.coordinate = c

        //update list of markers
        var myArray = new Array()
        for (var i = 0; i<count; i++){
            myArray.push(markers[i])
        }
        myArray.push(marker)
        markers = myArray
        return map.markers.length
    }


    function addMarkerAtCenter()
    {//I need to rewrite this, cause it is slow as is
        var count = map.markers.length
        markerCounter++
        var marker = Qt.createQmlObject ('Marker {}', map)
        map.addMapItem(marker)
        marker.z = map.z+1
        marker.coordinate = map.center

        //update list of markers
        var myArray = new Array()
        for (var i = 0; i<count; i++){
            myArray.push(markers[i])
        }
        myArray.push(marker)
        markers = myArray
        return map.markers.length
    }

    function addGeoItem(item)
    {
        var count = map.mapItems.length
        var co = Qt.createComponent(item+'.qml')
        if (co.status == Component.Ready) {
            var o = co.createObject(map)
            o.setGeometry(map.markers, currentMarker)
            map.addMapItem(o)
            //update list of items
            var myArray = new Array()
            for (var i = 0; i<count; i++){
                myArray.push(mapItems[i])
            }
            myArray.push(o)
            mapItems = myArray

        } else {
            console.log(item + " is not supported right now, please call us later.")
        }
    }

    function deleteMarker(index)
    {
        //update list of markers
        var myArray = new Array()
        var count = map.markers.length
        for (var i = 0; i<count; i++){
            if (index != i) myArray.push(map.markers[i])
        }

        map.removeMapItem(map.markers[index])
        map.markers[index].destroy()
        map.markers = myArray
        if (markers.length == 0) markerCounter = 0
    }

    function calculateMarkerRoute()
    {
        routeQuery.clearWaypoints();
        for (var i = currentMarker; i< map.markers.length; i++){
            routeQuery.addWaypoint(markers[i].coordinate)
        }
        routeQuery.travelModes = RouteQuery.CarTravel
        routeQuery.routeOptimizations = RouteQuery.ShortestRoute
        routeQuery.setFeatureWeight(0, 0)
        routeModel.update();
    }

    function calculateCoordinateRoute(startCoordinate, endCoordinate)
    {
        //! [routerequest0]
        // clear away any old data in the query
        routeQuery.clearWaypoints();

        // add the start and end coords as waypoints on the route
        routeQuery.addWaypoint(startCoordinate)
        routeQuery.addWaypoint(endCoordinate)
        routeQuery.travelModes = RouteQuery.CarTravel
        routeQuery.routeOptimizations = RouteQuery.FastestRoute

        //! [routerequest0]

        //! [routerequest0 feature weight]
        for (var i=0; i<9; i++) {
            routeQuery.setFeatureWeight(i, 0)
        }
        //for (var i=0; i<routeDialog.features.length; i++) {
        //    map.routeQuery.setFeatureWeight(routeDialog.features[i], RouteQuery.AvoidFeatureWeight)
        //}
        //! [routerequest0 feature weight]

        //! [routerequest1]
        routeModel.update();

        //! [routerequest1]
        //! [routerequest2]
        // center the map on the start coord
        map.center = startCoordinate;
        //! [routerequest2]
    }

    function geocode(fromAddress)
    {
        //! [geocode1]
        // send the geocode request
        geocodeModel.query = fromAddress
        geocodeModel.update()
        //! [geocode1]
    }


//! [coord]
    //zoomLevel: (maximumZoomLevel - minimumZoomLevel)/2
    zoomLevel: maximumZoomLevel
    center {
        // not The Qt Company in Oslo
        //latitude: 59.9485
        //longitude: 10.7686
        //my house
        latitude: 35.8442
        longitude: 139.7183843
    }
//! [coord]

//! [mapnavigation]
    // Enable pan, flick, and pinch gestures to zoom in and out
    gesture.acceptedGestures: MapGestureArea.PanGesture | MapGestureArea.FlickGesture | MapGestureArea.PinchGesture
    gesture.flickDeceleration: 3000
    gesture.enabled: true
//! [mapnavigation]
    focus: true
    onCopyrightLinkActivated: Qt.openUrlExternally(link)

    onCenterChanged:{
        scaleTimer.restart()
        if (map.followme)
            if (map.center != positionSource.position.coordinate) map.followme = false
    }

    onZoomLevelChanged:{
        scaleTimer.restart()
        if (map.followme) map.center = positionSource.position.coordinate
    }

    onWidthChanged:{
        scaleTimer.restart()
    }

    onHeightChanged:{
        scaleTimer.restart()
    }

    Component.onCompleted: {
            //the position is not initialized here, so I am moving it to login
        markers = new Array();
        mapItems = new Array();
        users = new Array();
        people = new Array();

        /*
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
                    console.log("Client:"+clientID+" Marker created at lat:"+ lat+"longi:"+longi);
                    if(isNaN(lat)) {
                        continue;
                    }
                    console.log("Client:"+clientID+" Marker created at lat:"+ lat+"longi:"+longi);
                    resp.clientID=clientID;
                    resp.lat=lat;
                    resp.longi=longi;
                    resp.index = addMarkerAtCoordinate(QtPositioning.coordinate(resp.lat, resp.longi));
                    people.push(resp);
                    users[clientID]=resp;

                }

            }
        }

        //made it syncronous with false at the end
        positionSource.start();
        positionSource.update();
        console.log("http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=fetch&lat="+positionSource.position.coordinate.latitude+"&longi="+positionSource.position.coordinate.longitude);
        doc.open("GET", "http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=fetch&lat="+map.positionOfMap.position.coordinate.latitude+"&longi="+map.positionOfMap.position.coordinate.longitude,false);
        doc.send();
        */
        /*this is just to debug on desktop
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {

            } else if (doc.readyState == XMLHttpRequest.DONE) {
                var message=doc.responseText;
                var obj;
                var markerCounter=0;
                obj = JSON.parse(message);
                for(var item in obj) {
                    if(obj[item]["lat"]!="Just Registered") {
                        var lat=parseFloat(obj[item]["lat"]).toFixed(4)
                        var longi=parseFloat(obj[item]["longi"]).toFixed(4)
                        var clientID =obj[item]["clientID"]
                        var resp = {};
                        if(isNaN(lat)) {
                            continue;
                        }
                        console.log("Client:"+clientID+" Marker at lat:"+ lat+"longi:"+longi);
                        resp.clientID=clientID;
                        resp.lat=lat;
                        resp.longi=longi;
                        if(resp.clientID==""){
                            continue;
                        }
                        if(users[resp.clientID].lat!=resp.lat || users[resp.clientID].longi!=resp.longi) {
                            console.log("Client:"+resp.clientID+" move Marker from lat:"+ users[resp.clientID].lat+"longi:"+users[resp.clientID].longi+" to lat:"+ lat+"longi:"+longi);
                            map.markers[users[resp.clientID].index-1].coordinate=QtPositioning.coordinate(resp.lat, resp.longi)
                        }
                    }
                }
            }
        }
        var lat=500;
        var longi=500;
        //made it syncronous with false at the end,maybe change back http://stackoverflow.com/questions/7373987/javascript-create-new-thread
        doc.open("GET", "http://amigojapan.duckdns.org/LocationServer/LocationServer.php?operation=fetch&lat="+lat+"&longi="+longi,true);
        doc.send();
        */
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Plus) {
            map.zoomLevel++;
        } else if (event.key === Qt.Key_Minus) {
            map.zoomLevel--;
        } else if (event.key === Qt.Key_Left || event.key === Qt.Key_Right ||
                   event.key === Qt.Key_Up   || event.key === Qt.Key_Down) {
            var dx = 0;
            var dy = 0;

            switch (event.key) {

            case Qt.Key_Left: dx = map.width / 4; break;
            case Qt.Key_Right: dx = -map.width / 4; break;
            case Qt.Key_Up: dy = map.height / 4; break;
            case Qt.Key_Down: dy = -map.height / 4; break;

            }

            var mapCenterPoint = Qt.point(map.width / 2.0 - dx, map.height / 2.0 - dy);
            map.center = map.toCoordinate(mapCenterPoint);
        }
    }

    /* @todo
    Binding {
        target: map
        property: 'center'
        value: positionSource.position.coordinate
        when: followme
    }*/


    PositionSource{
        id: positionSource
        active: true
        updateInterval: 20000

        onPositionChanged: {//***look at here, coordinate change on map move, I can get the current position here
            //To-Do optimize by using bins
            //https://en.wikipedia.org/wiki/Bin_(computational_geometry)
            //http://stackoverflow.com/questions/639695/how-to-convert-latitude-or-longitude-to-meters
            //calculate size of bin to be about double the size of the screen, check all adjacent bins too
            //view-source:http://amigojapan.duckdns.org/html5/MutantVM2/ships.html.backup2
            map.center = positionSource.position.coordinate
            var coord = positionSource.position.coordinate;


            //Our_code.update_location_on_server(appWindow.uid2 , coord.latitude, coord.longitude);
            //Our_code.update_people_positions(map,markers);
            //this is all our code, not QT's code Usmar Padow

            var doc = new XMLHttpRequest();
            doc.onreadystatechange = function() {
                if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {

                } else if (doc.readyState == XMLHttpRequest.DONE) {
                    var message=doc.responseText;
                    var obj;
                    var markerCounter=0;
                    console.log("response:"+message);
                    obj = JSON.parse(message);
                    for(var item in obj["my_quad"]) {
                        /*
                        if(obj[item]["lat"]=="Just Registered"||!(users[resp.clientID]==obj[item]["clientID"])) {
                            users[obj[item]["clientID"]] = addMarkerAtCoordinate(map.center)
                        }
                        */
                        var lat=parseFloat(obj["my_quad"][item]["lat"]).toFixed(4)
                        var longi=parseFloat(obj["my_quad"][item]["longi"]).toFixed(4)
                        var clientID =obj["my_quad"][item]["clientID"]
                        var resp = {};
                        if(isNaN(lat)) {
                            continue;
                        }
                        resp.clientID=clientID;
                        resp.lat=lat;
                        resp.longi=longi;
                        if(resp.clientID==""){
                            continue;
                        }
                        /*
                        resp.clientID=clientID;
                        resp.lat=lat;
                        resp.longi=longi;
                        resp.index = map.addMarkerAtCoordinate(QtPositioning.coordinate(resp.lat, resp.longi));
                        */
                        //chceck to see if user had logged in
                        var ind;
                        if(appWindow.uid2!="") {
                            console.log("resp.clientID:"+resp.clientID);
                            for(var person in map.people) {
                                //console.log("map.people[person].clientID:"+map.people[person].clientID+"resp.clientID:"+resp.clientID)

                                if(map.people[person].clientID==resp.clientID){
                                    console.log("map.people[person].clientID:"+map.people[person].clientID)
                                    ind=map.people[person].index;
                                }

                            }

                            console.log("resp.clientID:"+resp.clientID);
                            if(map.people[ind].lat!=resp.lat || map.people[ind].longi!=resp.longi) {
                                console.log("Client:"+resp.clientID+" move Marker from lat:"+ map.people[ind].lat+"longi:"+map.people[ind].longi+" to lat:"+ lat+"longi:"+longi);
                                map.markers[map.people[ind].index-1].coordinate=QtPositioning.coordinate(resp.lat, resp.longi)
                            }

                        }
                        //if(users[resp.clientID].lat!=resp.lat || users[resp.clientID].longi!=resp.longi) {
                            //***fix, first it seems the response is empty, then I need to get rid of users and use people instead, or use both for speed?
                            /*
                            console.log("Client:"+resp.clientID+" move Marker from lat:"+ users[resp.clientID].lat+"longi:"+users[resp.clientID].longi+" to lat:"+ lat+"longi:"+longi);
                            map.markers[users[resp.clientID].index-1].coordinate=QtPositioning.coordinate(resp.lat, resp.longi)
                            */
                            //}

                    }
                }
            }

            var lat=coord.latitude;
            var longi=coord.longitude;
            //made it syncronous with false at the end,maybe change back http://stackoverflow.com/questions/7373987/javascript-create-new-thread
            //if(appWindow.uid2==""){
            //    return;
            //}
            console.log("http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=set&clientID="+ appWindow.uid2 + "&lat="+lat+"&longi="+longi+"&unixtimestamp="+Our_code.unix_timestamp())
            doc.open("GET", "http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=set&clientID="+ appWindow.uid2 + "&lat="+lat+"&longi="+longi+"&unixtimestamp="+Our_code.unix_timestamp(),true);
            doc.send();
            //end of our code
        }
    }

    MapQuickItem {
        id: poiTheQtComapny
        sourceItem: Rectangle { width: 14; height: 14; color: "#e41e25"; border.width: 2; border.color: "white"; smooth: true; radius: 7 }
        coordinate {
            latitude: 59.9485
            longitude: 10.7686
        }
        opacity: 1.0
        anchorPoint: Qt.point(sourceItem.width/2, sourceItem.height/2)
    }

    MapQuickItem {
        sourceItem: Text{
            text: "The Qt Company"
            color:"#242424"
            font.bold: true
            styleColor: "#ECECEC"
            style: Text.Outline
        }
        coordinate: poiTheQtComapny.coordinate
        anchorPoint: Qt.point(-poiTheQtComapny.sourceItem.width * 0.5,poiTheQtComapny.sourceItem.height * 1.5)
    }


    Slider {
        id: zoomSlider;
        z: map.z + 3
        minimumValue: map.minimumZoomLevel;
        maximumValue: map.maximumZoomLevel;
        anchors.margins: 10
        anchors.bottom: scale.top
        anchors.top: parent.top
        anchors.right: parent.right
        orientation : Qt.Vertical
        value: map.zoomLevel
        onValueChanged: {
            map.zoomLevel = value
        }
    }

    Item {
        id: scale
        z: map.z + 3
        visible: scaleText.text != "0 m"
        anchors.bottom: parent.bottom;
        anchors.right: parent.right
        anchors.margins: 20
        height: scaleText.height * 2
        width: scaleImage.width

        Image {
            id: scaleImageLeft
            source: "../resources/scale_end.png"
            anchors.bottom: parent.bottom
            anchors.right: scaleImage.left
        }
        Image {
            id: scaleImage
            source: "../resources/scale.png"
            anchors.bottom: parent.bottom
            anchors.right: scaleImageRight.left
        }
        Image {
            id: scaleImageRight
            source: "../resources/scale_end.png"
            anchors.bottom: parent.bottom
            anchors.right: parent.right
        }
        Label {
            id: scaleText
            color: "#004EAE"
            anchors.centerIn: parent
            text: "0 m"
        }
        Component.onCompleted: {
            map.calculateScale();
        }
    }

    //! [routemodel0]
    RouteModel {
        id: routeModel
        plugin : map.plugin
        query:  RouteQuery {
            id: routeQuery
        }
        onStatusChanged: {
            if (status == RouteModel.Ready) {
                switch (count) {
                case 0:
                    // technically not an error
                    map.routeError()
                    break
                case 1:
                    map.showRouteList()
                    break
                }
            } else if (status == RouteModel.Error) {
                map.routeError()
            }
        }
    }
    //! [routemodel0]

    //! [routedelegate0]
    Component {
        id: routeDelegate

        MapRoute {
            id: route
            route: routeData
            line.color: "#46a2da"
            line.width: 5
            smooth: true
            opacity: 0.8
     //! [routedelegate0]
            MouseArea {
                id: routeMouseArea
                anchors.fill: parent
                hoverEnabled: false
                property variant lastCoordinate

                onPressed : {
                    map.lastX = mouse.x + parent.x
                    map.lastY = mouse.y + parent.y
                    map.pressX = mouse.x + parent.x
                    map.pressY = mouse.y + parent.y
                    lastCoordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                }

                onPositionChanged: {
                    if (mouse.button == Qt.LeftButton) {
                        map.lastX = mouse.x + parent.x
                        map.lastY = mouse.y + parent.y
                    }
                }

                onPressAndHold:{
                    if (Math.abs(map.pressX - parent.x- mouse.x ) < map.jitterThreshold
                            && Math.abs(map.pressY - parent.y - mouse.y ) < map.jitterThreshold) {
                        showRouteMenu(lastCoordinate);
                    }
                }

            }
    //! [routedelegate1]
        }
    }
    //! [routedelegate1]

    //! [geocodemodel0]
    GeocodeModel {
        id: geocodeModel
        plugin: map.plugin
        onStatusChanged: {
            if ((status == GeocodeModel.Ready) || (status == GeocodeModel.Error))
                map.geocodeFinished()
        }
        onLocationsChanged:
        {
            if (count == 1) {
                map.center.latitude = get(0).coordinate.latitude
                map.center.longitude = get(0).coordinate.longitude
            }
        }
    }
    //! [geocodemodel0]

    //! [pointdel0]
    Component {
        id: pointDelegate

        MapCircle {
            id: point
            radius: 1000
            color: "#46a2da"
            border.color: "#190a33"
            border.width: 2
            smooth: true
            opacity: 0.25
            center: locationData.coordinate
            //! [pointdel0]
            MouseArea {
                anchors.fill:parent
                id: circleMouseArea
                hoverEnabled: false
                property variant lastCoordinate

                onPressed : {
                    map.lastX = mouse.x + parent.x
                    map.lastY = mouse.y + parent.y
                    map.pressX = mouse.x + parent.x
                    map.pressY = mouse.y + parent.y
                    lastCoordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                }

                onPositionChanged: {
                    if (Math.abs(map.pressX - parent.x- mouse.x ) > map.jitterThreshold ||
                            Math.abs(map.pressY - parent.y -mouse.y ) > map.jitterThreshold) {
                        if (pressed) parent.radius = parent.center.distanceTo(
                                         map.toCoordinate(Qt.point(mouse.x, mouse.y)))
                    }
                    if (mouse.button == Qt.LeftButton) {
                        map.lastX = mouse.x + parent.x
                        map.lastY = mouse.y + parent.y
                    }
                }

                onPressAndHold:{
                    if (Math.abs(map.pressX - parent.x- mouse.x ) < map.jitterThreshold
                            && Math.abs(map.pressY - parent.y - mouse.y ) < map.jitterThreshold) {
                        showPointMenu(lastCoordinate);
                    }
                }
            }
    //! [pointdel1]
        }
    }
    //! [pointdel1]

    //! [routeview0]
    MapItemView {
        model: routeModel
        delegate: routeDelegate
    //! [routeview0]
        autoFitViewport: true
    //! [routeview1]
    }
    //! [routeview1]

    //! [geocodeview]
    MapItemView {
        model: geocodeModel
        delegate: pointDelegate
    }
    //! [geocodeview]

    Timer {
        id: scaleTimer
        interval: 100
        running: false
        repeat: false
        onTriggered: {
            map.calculateScale()
        }
    }

    MouseArea {
        id: mouseArea
        property variant lastCoordinate
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onPressed : {
            map.lastX = mouse.x
            map.lastY = mouse.y
            map.pressX = mouse.x
            map.pressY = mouse.y
            lastCoordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
        }

        onPositionChanged: {
            if (mouse.button == Qt.LeftButton) {
                map.lastX = mouse.x
                map.lastY = mouse.y
            }
        }

        onDoubleClicked: {
            var mouseGeoPos = map.toCoordinate(Qt.point(mouse.x, mouse.y));
            var preZoomPoint = map.fromCoordinate(mouseGeoPos, false);
            if (mouse.button === Qt.LeftButton) {
                map.zoomLevel++;
            } else if (mouse.button === Qt.RightButton) {
                map.zoomLevel--;
            }
            var postZoomPoint = map.fromCoordinate(mouseGeoPos, false);
            var dx = postZoomPoint.x - preZoomPoint.x;
            var dy = postZoomPoint.y - preZoomPoint.y;

            var mapCenterPoint = Qt.point(map.width / 2.0 + dx, map.height / 2.0 + dy);
            map.center = map.toCoordinate(mapCenterPoint);

            lastX = -1;
            lastY = -1;
        }

        onPressAndHold:{
            if (Math.abs(map.pressX - mouse.x ) < map.jitterThreshold
                    && Math.abs(map.pressY - mouse.y ) < map.jitterThreshold) {
                showMainMenu(lastCoordinate);
            }
        }
    }
//! [end]
}
//! [end]
