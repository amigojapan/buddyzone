import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    width: 400
    height: 400
    property alias btnDecline: btnDecline
    property alias btnAccept: btnAccept
    property alias lblPersonNotInSameQuadrant: lblPersonNotInSameQuadrant
    property alias btnMap1: btnMap
    property alias btnPM: btnPM
    property alias txtAreaMeeting_Agreement: txtAreaMeeting_Agreement
    property alias txtAreaInroduction: txtAreaInroduction
    property alias lblID: lblID
    property alias updateWarning: updateWarning
    //http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=register&clientID=test7&lat=100&longi=100&unixtimestamp=100&email=test@test.com&phone_number=09037368364&introduction=hello I am test, nice to meet you&meeting_agreement=I want to meet someone to have a cup of coffee&mac_address=ab:ab:ab:ab&dateable=false&meetup_reffered_from_clientID=test2

    GridLayout {
        x: 9
        y: 0
        columns: 2

        Label {
            id: lblIDPrompt
            width: 13
            height: 16
            text: qsTr("ID:")
        }

        Label {
            id: lblID
            width: 103
            height: 40
            text: qsTr("id here")
        }
    }

    GridLayout {
        x: 9
        y: 31
        columns: 1
        Label {
            id: lblPersonNotInSameQuadrant
            color:"red"
            text: qsTr("Warning, person not in same quadrant!")
            visible: false
        }

        Label{
            id:updateWarning
            text: "Warning, you need to upgrade to the latest version of this app to continue using it!¥nGo to appsore oh iphone or google play on android and get latest version"
            font.pixelSize: 30
            font.bold: true
            color: "red"
            visible: false
        }

    }
    Label {
        id: lblIntroductionPrompt
        x: 9
        y: 15
        width: 13
        height: 16
        text: qsTr("Introduction")
    }

    TextArea {
        id: txtAreaInroduction
        x: 9
        y: 31
        width: 334
        height: 99
        text: qsTr("")
        wrapMode: Text.WordWrap
    }

    Label {
        id: lblMeeting_agreementPrompt
        x: 8
        y: 134
        width: 13
        height: 16
        text: qsTr("Meeting Agreement")
    }

    TextArea {
        id: txtAreaMeeting_Agreement
        x: 8
        y: 148
        width: 334
        height: 90
        text: qsTr("")
        wrapMode: Text.WordWrap
    }
    Image {
        id: image1
        x: 9
        y: 244
        width: 107
        height: 94
        source: "qrc:/qtquickplugin/images/template_image.png"
    }

    GridLayout {
        x: 130
        y: 249
        rowSpacing: 5
        columns: 2

        Button {
            id: btnMap
            width: 64
            height: 40
            text: qsTr("Map")
        }
        Button {
            id: btnPM
            text: qsTr("Private Message")
        }
        Button {
            id: btnAccept
            text: qsTr("Accept")
        }
        Button {
            id: btnDecline
            text: qsTr("Decline")
        }
    }
}
