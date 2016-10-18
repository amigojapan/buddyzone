import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3


Item {
    width: 400
    height: 400
    property alias txtRefferedFromID: txtRefferedFromID
    property alias txtAreaMeeting_Agreement: txtAreaMeeting_Agreement
    property alias txtAreaInroduction: txtAreaInroduction
    property alias txtPhone: txtPhone
    property alias txtEmail: txtEmail
    property alias btnCloseForm: btnCloseForm
    property alias btnOK: btnOK
    property alias txtID: txtID
    property alias updateWarning: updateWarning
    //http://amigojapan.duckdns.org/LocationServer/LocationServerQuads.php?operation=register&clientID=test7&lat=100&longi=100&unixtimestamp=100&email=test@test.com&phone_number=09037368364&introduction=hello I am test, nice to meet you&meeting_agreement=I want to meet someone to have a cup of coffee&mac_address=ab:ab:ab:ab&dateable=false&meetup_reffered_from_clientID=test2
    Label{
        id:updateWarning
        x: 8
        y: 0
        text: "Warning, you need to upgrade to the latest version of this app to continue using it!¥nGo to appsore oh iphone or google play on android and get latest version"
        font.pixelSize: 30
        font.bold: true
        color: "red"
        visible: false
    }
    GridLayout {
        x: 0
        y: 5
        columnSpacing: 0
        rowSpacing: 0
        columns: 2
        Label {
            id: lblIDPrompt
            width: 13
            height: 16
            text: qsTr("ID")
        }
        Label {
            id: lblEmailPrompt
            width: 21
            height: 16
            text: qsTr("Email")
        }

        TextField {
            id: txtID
            width: 103
            height: 40
            text: qsTr("")
        }
        //email=test@test.com
        TextField {
            id: txtEmail
            width: 123
            height: 40
            text: qsTr("")
        }
        //phone_number=09037368364
        Label {
            id: lblPhoneNumberPrompt
            width: 13
            height: 16
            text: qsTr("Phone Number")
        }
        Label {
            id: lblPhoneNumberPrompt1
            width: 13
            height: 16
            text: qsTr("did someone reffer you? Enter their ID")
        }

        TextField {
            id: txtPhone
            width: 103
            height: 40
        }



        TextField {
            id: txtRefferedFromID
            width: 103
            height: 40
            text: qsTr("")
        }

        Label {
            id: lblPhoneNumberPrompt3
            width: 13
            height: 16
            text: qsTr("password")
        }
        Label {
            id: lblPhoneNumberPrompt4
            width: 13
            height: 16
            text: qsTr("re-enter password")
        }

        TextField {
            id: txtPassword
            width: 103
            height: 40
            text: qsTr("")
        }


        TextField {
            id: txtPasswordConfirm
            width: 103
            height: 40
            text: qsTr("")
        }

    }
    Label {
        id: lblPasswordsNoMatchWarning
        color:"red"
        text: qsTr("^Passwords do not match")
        visible: false
        font.bold: true
    }

    Label {
        id: lblIntroductionPrompt
        x: 5
        y: 238
        width: 13
        height: 16
        text: qsTr("Introduction")
    }

    TextArea {
        id: txtAreaInroduction
        x: 0
        y: 254
        width: 243
        height: 72
        text: qsTr("Sample intro, Hello I am Jhon, my hobbies are watching Anime and playing chess, I would be very happy to meet you if you want!")
        wrapMode: Text.WordWrap
    }

    Label {
        id: lblMeeting_agreementPrompt
        x: 5
        y: 179
        width: 13
        height: 75
        text: qsTr("Meeting Agreement")
    }

    TextArea {
        id: txtAreaMeeting_Agreement
        x: 0
        y: 196
        width: 243
        height: 41
        text: qsTr("I want to meet someone over coffee")
        wrapMode: Text.WordWrap
    }
    GridLayout {
        x: 0
        y: 332
        columns: 2
        Button {
            id: btnOK
            text: qsTr("Register")
        }

        Button {
            id: btnCloseForm
            text: qsTr("Close Form")
        }
    }
}
