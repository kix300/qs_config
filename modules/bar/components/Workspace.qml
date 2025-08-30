import QtQuick
import QtQuick.Controls
import Quickshell.Hyprland
import QtQuick.Effects

// Hyprland workspace indicator
Rectangle {
	id: container
	color: "white"
	radius: 50
	height: 25

	Behavior on width {
		NumberAnimation { duration: 400; easing.type: Easing.InOutCubic }
	}

	Row {
		id: root
		anchors.centerIn: parent
		property var shell
		spacing: 5

		// Garder une référence au workspace actif précédent pour l'animation
		property var previousActiveWorkspace: null

		Repeater {
			model: Hyprland.workspaces

			delegate: Rectangle {
				id: workspace
				width: modelData.active ? 25 : 15
				height: 15
				radius: 50
				border.width: 0
				//faire en sorte que la couleur change en fonction du screen
				color: modelData.active ? "#00FF00" : "#FF00FF"
				opacity: modelData.active ? 1 : 0.3

				// Propriété pour suivre l'état précédent
				property bool wasActive: modelData.active

				// Animation de transition croisée
				states: [
					State {
						name: "becomingActive"
						when: modelData.active && !wasActive
						PropertyChanges { target: workspace; scale: 1 }
					},
					State {
						name: "becomingInactive"
						when: !modelData.active && wasActive
						PropertyChanges { target: workspace; scale: 1 }
					}
				]

				transitions: [
					Transition {
						from: "*"; to: "becomingActive"
						SequentialAnimation {
							// Étape 1: Réduction et augmentation d'opacité
							ParallelAnimation {
								NumberAnimation { target: workspace; property: "scale"; to: 1; duration: 200 }
								NumberAnimation { target: workspace; property: "opacity"; to: 0.8; duration: 200 }
							}
							// Étape 2: Retour à la taille normale
							ParallelAnimation {
								NumberAnimation { target: workspace; property: "scale"; to: 1.0; duration: 200 }
								NumberAnimation { target: workspace; property: "opacity"; to: 1.0; duration: 200 }
							}
						}
					},
					Transition {
						from: "*"; to: "becomingInactive"
						SequentialAnimation {
							// Étape 1: Agrandissement léger
							ParallelAnimation {
								NumberAnimation { target: workspace; property: "scale"; to: 1.0; duration: 200 }
								NumberAnimation { target: workspace; property: "opacity"; to: 0.5; duration: 200 }
							}
							// Étape 2: Retour à la taille inactive
							ParallelAnimation {
								NumberAnimation { target: workspace; property: "scale"; to: 1.0; duration: 200 }
								NumberAnimation { target: workspace; property: "opacity"; to: 0.3; duration: 200 }
							}
						}
					}
				]

				Behavior on width {
					NumberAnimation { duration: 400; easing.type: Easing.InOutCubic }
				}

				MouseArea {
					anchors.fill: parent
					onClicked: {
						// Animation de clic
						clickAnimation.start()
						modelData.activate()
					}
				}

				// Animation lors du clic
				SequentialAnimation {
					id: clickAnimation
					NumberAnimation { target: workspace; property: "scale"; to: 1.0; duration: 100 }
					NumberAnimation { target: workspace; property: "scale"; to: 1.0; duration: 200 }
				}

				// Mettre à jour wasActive quand l'état change
				onWasActiveChanged: {
					wasActive = modelData.active
				}

				Component.onCompleted: {
					wasActive = modelData.active
				}
			}
		}

		// Workspace synchronization
		Connections {
			target: Hyprland
			function onFocusedWorkspaceChanged() {
				Hyprland.refreshWorkspaces();
			}
		}
		onWidthChanged: {
			container.width = root.width + 25
		}

		Component.onCompleted:{
			Hyprland.refreshWorkspaces()
			container.width = root.width + 25
		}
	}
}
