// Power.qml
// // modules/widgets/BatteryWidget.qml
import QtQuick
import Quickshell
import Quickshell.Services.UPower
import QtQuick.Layouts
import "utils"

Rectangle {
	id: batteryWidget
	width: 200
	height: 30
	radius: 15
	color: "white"

	// Propriétés configurables
	property bool showPercentage: true
	property bool showPath: false
	property bool showStatus: true

	property var battery: UPower?.defaultDevice ?? null
	property bool batteryReady: battery ? battery.ready : false

	// Timer pour vérification périodique
	Timer {
		interval: 2000
		running: true
		repeat: true
		onTriggered: {
			if (battery && !battery.ready) {
				console.log("Battery not ready yet...");
			}
		}
	}

	// Debug
	Component.onCompleted: {
		console.log("BatteryWidget initialized");
		if (battery) {
			console.log("Battery object:", battery);
			console.log("Battery ready:", battery.ready);
		}
	}

	Row {
		anchors.fill: parent
		spacing: 5

		// Texte d'information
		Text {
			id: infoText
			anchors.centerIn: parent
			text: getBatteryText()
			color: "black"
			font.pixelSize: 12
			elide: Text.ElideRight
		}
	}

	// Fonction pour générer le texte
	function getBatteryText() {
		if (!battery) return "❌ Service indisponible";
		if (!battery.ready) return "⏳ Chargement...";
		if (!battery.isPresent) return "🔋 Non détectée";

		const percent = Math.round(battery.percentage);
		const stateStr = getStateString(battery.state);

		var text = "";
		if (showPercentage) text += `${percent}% `;
		if (showStatus) text += `(${stateStr}) `;
		if (showPath && battery.nativePath) text += `- ${battery.nativePath}`;

		return text.trim();
	}

	// Fonction pour traduire l'état
	function getStateString(state) {
		switch (state) {
			case UPowerDeviceState.Charging: return "Chargement";
			case UPowerDeviceState.Discharging: return "Décharge";
			case UPowerDeviceState.FullyCharged: return "Pleine";
			case UPowerDeviceState.Empty: return "Vide";
			default: return "Inconnu";
		}
	}

	// Connexions aux signaux
	Connections {
		target: battery
		enabled: battery !== null

		function onReadyChanged() {
			console.log("Battery ready changed:", battery.ready);
			if (battery.ready) {
				console.log("Battery nativePath:", battery.nativePath);
				console.log("Battery percentage:", battery.percentage);
				console.log("Battery state:", battery.state);
			}
		}

		function onPercentageChanged() {
			console.log("Battery percentage updated:", battery.percentage);
		}

		function onStateChanged() {
			console.log("Battery state changed:", battery.state);
		}
	}
}
