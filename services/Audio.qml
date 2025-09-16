pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string state: "UNKNOWN"
    property int volumePercentage: 0
    property string sinkName: ""
    property string deviceBus: ""
    property string deviceNick: ""
    property string deviceAlias: ""
    property bool muted: false

    Timer {
        id: refreshTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            audioProcess.running = true;
        }
    }

    Process {
        id: audioProcess
        running: true
        command: ['pactl', 'list', 'sinks']

        stdout: StdioCollector {
            onTextChanged: {
                parseAudioSinks(text.trim());
            }
        }
    }

    function parseAudioSinks(text) {
        var sinks = text.split(/Sink #\d+/);
        var activeSink = null;

        for (var i = 1; i < sinks.length; i++) {
            var sinkData = sinks[i];

            var stateMatch = sinkData.match(/State:\s*(\w+)/);
            if (stateMatch && stateMatch[1] === "RUNNING") {
                activeSink = sinkData;
                break;
            }
        }

        if (!activeSink && sinks.length > 1) {
            activeSink = sinks[1];
        }

        if (activeSink) {
            parseSinkData(activeSink);
        }
    }

    function parseSinkData(sinkData) {
        var stateMatch = sinkData.match(/State:\s*(\w+)/);
        if (stateMatch && stateMatch[1]) {
            state = stateMatch[1];
        }

        var volumeMatch = sinkData.match(/Volume:.*?(\d+)%/);
        if (volumeMatch && volumeMatch[1]) {
            volumePercentage = parseInt(volumeMatch[1]);
        }

        var muteMatch = sinkData.match(/Mute:\s*(yes|no)/);
        if (muteMatch && muteMatch[1]) {
            muted = (muteMatch[1] === "yes");
        }

        var nameMatch = sinkData.match(/Name:\s*(.+)/);
        if (nameMatch && nameMatch[1]) {
            sinkName = nameMatch[1].trim();
        }

        var busMatch = sinkData.match(/device\.bus\s*=\s*"([^"]+)"/);
        if (busMatch && busMatch[1]) {
            deviceBus = busMatch[1];
        }

        var nickMatch = sinkData.match(/device\.nick\s*=\s*"([^"]+)"/);
        if (nickMatch && nickMatch[1]) {
            deviceNick = nickMatch[1];
        }

        var aliasMatch = sinkData.match(/device\.alias\s*=\s*"([^"]+)"/);
        if (aliasMatch && aliasMatch[1]) {
            deviceAlias = aliasMatch[1];
        }
    }

    function getVolumeIcon() {
        if (muted || volumePercentage === 0) {
            return "󰸈";
        } else if (volumePercentage <= 33) {
            return "󰕿";
        } else if (volumePercentage <= 66) {
            return "󰖀";
        } else {
            return "󰕾";
        }
    }

    function getDeviceIcon() {
        if (deviceBus === "bluetooth" && sinkName.includes("headphone"))
            return "󰂯";
        if (deviceBus === "bluetooth") {
            return "󰋋󰂯";
        } else if (sinkName.includes("headphone") || deviceNick.toLowerCase().includes("headphone")) {
            return "󰋋";
        } else {
            return "󰓃";
        }
    }

    function setVolume(percentage) {
        if (sinkName) {
            var setVolumeProcess = Quickshell.createProcess();
            setVolumeProcess.command = ['pactl', 'set-sink-volume', sinkName, percentage + '%'];
            setVolumeProcess.running = true;
        }
    }

    function toggleMute() {
        if (sinkName) {
            var toggleMuteProcess = Quickshell.createProcess();
            toggleMuteProcess.command = ['pactl', 'set-sink-mute', sinkName, 'toggle'];
            toggleMuteProcess.running = true;
        }
    }
}
