import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3


Item {
    width: 400
    height: 400
    property alias btnMap: btnMap
    property alias btnMap1: btnMap
    property alias txtAreaMeeting_Agreement: txtAreaMeeting_Agreement
    property alias txtAreaInroduction: txtAreaInroduction
    property alias lblID: lblID
    property alias lblIDPrompt: lblIDPrompt
    //http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=register&clientID=test7&lat=100&longi=100&unixtimestamp=100&email=test@test.com&phone_number=09037368364&introduction=hello I am test, nice to meet you&meeting_agreement=I want to meet someone to have a cup of coffee&mac_address=ab:ab:ab:ab&dateable=false&meetup_reffered_from_clientID=test2
    Label {
        id: lblIDPrompt
        width: 13
        height: 16
        font.pixelSize : 25
        text: qsTr("Waiting for reply from:")
    }

    Label {
        id: lblID
        x: 71
        y: 29
        width: 103
        height: 40
        font.pixelSize : 25
        text: qsTr("id here")
    }
    //email=test@test.com
    //phone_number=09037368364

 //meeting_agreement=I want to meet someone over coffee&mac_address=ab:ab:ab:ab&dateable=false&meetup_reffered_from_clientID=test2

    Label {
        id: lblIntroductionPrompt
        x: 8
        y: 84
        width: 13
        height: 16
        text: qsTr("Introduction")
    }

    TextArea {
        id: txtAreaInroduction
        x: 13
        y: 106
        width: 243
        height: 72
        text: qsTr("")
        wrapMode: Text.WordWrap
    }

    Label {
        id: lblMeeting_agreementPrompt
        x: 13
        y: 184
        width: 13
        height: 16
        text: qsTr("Meeting Agreement")
    }

    TextArea {
        id: txtAreaMeeting_Agreement
        x: 13
        y: 197
        width: 243
        height: 41
        text: qsTr("")
        wrapMode: Text.WordWrap
    }

    Image {
        id: image1
        x: 13
        y: 244
        width: 107
        height: 94
        source: "qrc:/qtquickplugin/images/template_image.png"
    }

    Button {
        id: btnMap
        x: 161
        y: 298
        width: 64
        height: 40
        text: qsTr("Map")
    }

}
