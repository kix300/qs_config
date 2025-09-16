// Bar.qml
import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.UPower
import qs.modules.bar.components
import qs.services

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            property real margin: 5
            screen: modelData
            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30
            Item {
                id: bar
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                Workspace {
                    id: workspace
                    anchors.left: bar.left
                    anchors.verticalCenter: bar.verticalCenter
                    anchors.leftMargin: 10
                }
                ClockWidget {
                    id: clockWidget
                    anchors.horizontalCenter: bar.horizontalCenter
                    anchors.verticalCenter: bar.verticalCenter
                }
                //widget a part a creer apres
                SystemWidget {
                    id: systemtray
                    anchors.right: bar.right
                    anchors.verticalCenter: bar.verticalCenter
                    anchors.rightMargin: 10
                }
            }
        }
    }
}
