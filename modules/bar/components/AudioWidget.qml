import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.services

Item {
    id: root
    width: 20
    height: 20

    Text {
        id: audiIcon
        anchors.centerIn: parent
        color: Colors.text
        text: Audio.getVolumeIcon() + " " + Audio.getDeviceIcon()

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton
            onClicked: {
                pavucontrolProcess.running = true;
            }
        }
    }
    Process {
        id: pavucontrolProcess
        command: ["pavucontrol"]
    }
}
