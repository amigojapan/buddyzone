import QtQuick 2.4
import QtQuick.Controls 2.0


Item {
    width: 400
    height: 400
    property alias btnMap1: btnMap
    property alias btnPM: btnPM
    property alias btnRequestMeetup: btnRequestMeetup
    property alias txtAreaMeeting_Agreement: txtAreaMeeting_Agreement
    property alias txtAreaInroduction: txtAreaInroduction
    property alias lblID: lblID
    property alias updateWarning: updateWarning
    //http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=register&clientID=test7&lat=100&longi=100&unixtimestamp=100&email=test@test.com&phone_number=09037368364&introduction=hello I am test, nice to meet you&meeting_agreement=I want to meet someone to have a cup of coffee&mac_address=ab:ab:ab:ab&dateable=false&meetup_reffered_from_clientID=test2
    Label {
        id: lblIDPrompt
        x: 8
        y: 42
        width: 13
        height: 16
        text: qsTr("ID:")
    }

    Label {
        id: lblID
        x: 27
        y: 42
        width: 103
        height: 40
        text: qsTr("id here")
    }
    //email=test@test.com
    //phone_number=09037368364

 //meeting_agreement=I want to meet someone over coffee&mac_address=ab:ab:ab:ab&dateable=false&meetup_reffered_from_clientID=test2
    Button {
        id: btnRequestMeetup
        x: 13
        y: 352
        text: qsTr("Request Meetup")
    }

    Button {
        id: btnPM
        x: 156
        y: 352
        text: qsTr("Personal Message")
    }
    Label{
        id:updateWarning
        text: "Warning, you need to upgrade to the latest version of this app to continue using it!¥nGo to appsore oh iphone or google play on android and get latest version"
        font.pixelSize: 30
        font.bold: true
        color: "red"
        visible: false
    }

    Label {
        id: lblIntroductionPrompt
        x: 3
        y: 87
        width: 13
        height: 16
        text: qsTr("Introduction")
    }

    TextArea {
        id: txtAreaInroduction
        x: 8
        y: 109
        width: 243
        height: 72
        text: qsTr("")
        wrapMode: Text.WordWrap
    }

    Label {
        id: lblMeeting_agreementPrompt
        x: 8
        y: 187
        width: 13
        height: 16
        text: qsTr("Meeting Agreement")
    }

    TextArea {
        id: txtAreaMeeting_Agreement
        x: 8
        y: 200
        width: 243
        height: 41
        text: qsTr("")
        wrapMode: Text.WordWrap
    }

    Label {
        id: lblPasswordsNoMatchWarning
        x: 92
        y: 87
        color:"red"
        text: qsTr("^Passwords do not match")
        visible: false
        font.bold: true
    }

    Image {
        id: image1
        x: 8
        y: 247
        width: 107
        height: 94
        source: "qrc:/qtquickplugin/images/template_image.png"
    }

    Button {
        id: btnMap
        x: 156
        y: 301
        width: 64
        height: 40
        text: qsTr("Map")
    }

}
