// faire un widget global
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.services

Rectangle {
    color: "white"
    width: 80
    radius: 50
    height: 25

    RowLayout {
        id: systemtray
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
        spacing: 10
        layoutDirection: Qt.LeftToRight
        Text {
            color: "black"
            text: Power.status
        }
        NetworkWidget {
            id: network
        }
    }
}
