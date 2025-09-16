import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.services

Item {
    id: root
    width: 20
    height: 20

    Text {
        id: networkIcon
        anchors.centerIn: parent
        text: Network.icon
        color: Network.isEthernetConnected ? "#00aa00" : Network.connected ? "black" : "#666666"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton
            onClicked: {
                nmtuiProcess.running = true;
            }
        }
    }
    Process {
        id: nmtuiProcess
        command: ["ghostty", "-e", "nmtui"]
    }
}
