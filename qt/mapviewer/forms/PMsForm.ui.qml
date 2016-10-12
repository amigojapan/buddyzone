import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    id:item1    
    property alias lm2: listModel2
    property alias lv2: listView2
    property alias btnPtivateMessage: btnPtivateMessage
    property alias btnMap: btnMap
    property alias txtToNickname: txtToNickname
    property alias txtMessage: txtMessage
    GridLayout {
        x: 8
        y: 8
        columns: 1
        Label {
            id: lblBoradcastedMessages1
            text: qsTr("Private messages")
        }

        ListView {
            id: listView2
            width: 332
            height: 248
            model: ListModel {
                id: listModel2
                ListElement {
                    nickname: "testuser"
                    MessageText: "hey everyone whats up!"
                }

                ListElement {
                    nickname: "Red"
                    MessageText: "red"
                }

                ListElement {
                    nickname: "Blue"
                    MessageText: "blue"
                }

                ListElement {
                    nickname: "Green"
                    MessageText: "green"
                }
            }
            delegate: Item {
                x: 5
                width: 80
                height: 40
                Row {
                    id: row2
                    spacing: 10
                    Text {
                        text: nickname
                        anchors.verticalCenter: parent.verticalCenter
                        font.bold: true
                        color:"blue"
                    }
                    Text {
                        text: MessageText
                        anchors.verticalCenter: parent.verticalCenter
                        font.bold: true
                    }
                }
            }
        }
    }

    GridLayout {
        columns: 2
        Label{
            id:lblToNickname
            text:"Private Message To:"
        }

        property alias txtToNickname: txtToNickname
        TextField{
            id: txtToNickname
        }
        Label{
            id:lblMessage
            text:"Message:"
        }

        property alias txtMessage: txtMessage
        TextField{
            id: txtMessage
        }

        property alias btnMap: btnMap
        Button {
            id: btnMap
            text: qsTr("Map")
        }
        property alias btnPtivateMessage: btnPtivateMessage
        x: 12
        y: 283
        Button {
            id: btnPtivateMessage
            text: qsTr("Private Message")
        }
    }

}
