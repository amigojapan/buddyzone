import QtQuick 2.4
import QtQuick.Controls 2.0


Item {
    width: 400
    height: 400
    property alias txtAreaMeeting_Agreement: txtAreaMeeting_Agreement
    property alias txtAreaInroduction: txtAreaInroduction
    property alias txtPhone1: txtPhone1
    property alias txtPhone: txtPhone
    property alias txtEmail: txtEmail
    property alias btnCloseForm: btnCloseForm
    property alias btnOK: btnOK
    property alias txtID: txtID
    property alias updateWarning: updateWarning
    //http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=register&clientID=test7&lat=100&longi=100&unixtimestamp=100&email=test@test.com&phone_number=09037368364&introduction=hello I am test, nice to meet you&meeting_agreement=I want to meet someone to have a cup of coffee&mac_address=ab:ab:ab:ab&dateable=false&meetup_reffered_from_clientID=test2
    Label {
        id: lblIDPrompt
        x: 8
        y: 42
        width: 13
        height: 16
        text: qsTr("ID")
    }

    TextField {
        id: txtID
        x: 8
        y: 58
        width: 103
        height: 40
        text: qsTr("")
    }
    //email=test@test.com
    Label {
        id: lblEmailPrompt
        x: 115
        y: 42
        width: 21
        height: 16
        text: qsTr("Email")
    }
    TextField {
        id: txtEmail
        x: 115
        y: 58
        width: 123
        height: 40
        text: qsTr("")
    }
    //phone_number=09037368364
    Label {
        id: lblPhoneNumberPrompt
        x: 8
        y: 99
        width: 13
        height: 16
        text: qsTr("Phone Number")
    }
    TextField {
        id: txtPhone
        x: 11
        y: 104
        width: 103
        height: 40
    }

 //meeting_agreement=I want to meet someone over coffee&mac_address=ab:ab:ab:ab&dateable=false&meetup_reffered_from_clientID=test2
    Button {
        id: btnOK
        x: 13
        y: 352
        text: qsTr("Register")
    }

    Button {
        id: btnCloseForm
        x: 156
        y: 352
        text: qsTr("Close Form")
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
        x: 0
        y: 192
        width: 13
        height: 16
        text: qsTr("Introduction")
    }

    TextArea {
        id: txtAreaInroduction
        x: 5
        y: 214
        width: 243
        height: 72
        text: qsTr("Sample intro, Hello I am Jhon, my hobbies are watching Anime and playing chess, I would be very happy to meet you if you want!")
        wrapMode: Text.WordWrap
    }

    Label {
        id: lblMeeting_agreementPrompt
        x: 5
        y: 292
        width: 13
        height: 16
        text: qsTr("Meeting Agreement")
    }

    TextArea {
        id: txtAreaMeeting_Agreement
        x: 5
        y: 305
        width: 243
        height: 41
        text: qsTr("I want to meet someone over coffee")
        wrapMode: Text.WordWrap
    }

    Label {
        id: lblPhoneNumberPrompt1
        x: 123
        y: 99
        width: 13
        height: 16
        text: qsTr("did someone reffer you?")
    }

    TextField {
        id: txtPhone1
        x: 125
        y: 93
        width: 103
        height: 40
        text: qsTr("")
    }

    Label {
        id: lblPhoneNumberPrompt2
        x: 123
        y: 109
        width: 13
        height: 16
        text: qsTr("if so, enter his ID here")
    }

    Label {
        id: lblPhoneNumberPrompt3
        x: 5
        y: 139
        width: 13
        height: 16
        text: qsTr("password")
    }

    TextField {
        id: txtPassword
        x: 5
        y: 155
        width: 103
        height: 40
        text: qsTr("")
    }

    Label {
        id: lblPhoneNumberPrompt4
        x: 120
        y: 139
        width: 13
        height: 16
        text: qsTr("re-enter password")
    }

    TextField {
        id: txtPasswordConfirm
        x: 125
        y: 155
        width: 103
        height: 40
        text: qsTr("")
    }

    Label {
        id: lblPasswordsNoMatchWarning
        x: 89
        y: 192
        color:"red"
        text: qsTr("^Passwords do not match")
        visible: false
        font.bold: true
    }

}
