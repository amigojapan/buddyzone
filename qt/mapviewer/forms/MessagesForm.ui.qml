import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    id:item1
    width: 400
    height: 400
    property alias btnPtivateMessage: btnPtivateMessage
    property alias txtMessage: txtMessage
    property alias txtToNickname: txtToNickname
    property alias btnBoradcast: btnBoradcast

    property alias lm1: listModel1
    property alias lm2: listModel2
    property alias lv1: listView1
    property alias lv2: listView2
    GridLayout {
        columns: 1
        Label {
            id: lblBoradcastedMessages
            x: 86
            y: 29
            text: qsTr("Boradcasted messages")
        }

        ListView {
            id: listView1
            x: 32
            y: 41
            width: 334
            height: 113
            model: ListModel {
                id: listModel1
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
                    id: row1
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
        Label {
            id: lblBoradcastedMessages1
            text: qsTr("Private messages")
        }


        ListView {
            id: listView2
            x: 32
            y: 187
            width: 332
            height: 114
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

        property alias btnBoradcast: btnBoradcast
        Button {
            id: btnBoradcast
            text: qsTr("Broadcast Message")
        }
        property alias btnPtivateMessage: btnPtivateMessage
        x: 0
        y: 262
        Button {
            id: btnPtivateMessage
            text: qsTr("Private Message")
        }
    }
}
