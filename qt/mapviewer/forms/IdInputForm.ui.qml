import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    width: 400
    height: 400
    property alias btnCloseForm: btnCloseForm
    property alias btnOK: btnOK
    property alias txtID: txtID
    property alias label1: label1
    property alias updateWarning: updateWarning
    GridLayout {
        id: grid
        columns: 2
        Label {
            id: label1
            x: 24
            y: 42
            text: qsTr("ID")
        }

        TextField {
            //Layout.row : 3
            id: txtID
            x: 24
            y: 62
            text: qsTr("Enter ID")
        }

        Label {
            id:updateWarning
            text: "Warning, you need to upgrade to the latest version of this app to continue using it!¥nGo to appsore oh iphone or google play on android and get latest version"
            font.pixelSize: 30
            font.bold: true
            color: "red"
            visible: false
        }

        Label {
            id: label2
            x: 24
            y: 118
            text: qsTr("Passowrd")
        }

        TextField {
            id: txtPassword
            x: 24
            y: 138
        }
        Button {
            id: btnOK
            x: 9
            y: 218
            text: qsTr("Login")
        }

        Button {
            id: btnCloseForm
            x: 172
            y: 218
            text: qsTr("Close Form")
        }
   }
}

