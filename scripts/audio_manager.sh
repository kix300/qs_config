#!/bin/bash

# Script de gestion audio avec support Bluetooth
# Utilise pactl pour PulseAudio et bluetoothctl pour Bluetooth

get_volume() {
    # Obtenir le volume du sink par défaut
    pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%'
}

get_mute_status() {
    # Vérifier si le son est coupé
    pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes" && echo "true" || echo "false"
}

get_bluetooth_status() {
    # Vérifier si un appareil audio Bluetooth est connecté
    bluetoothctl devices Connected | grep -E "(headset|headphones|speaker|audio)" > /dev/null
    if [ $? -eq 0 ]; then
        echo "true"
    else
        echo "false"
    fi
}

get_bluetooth_device_name() {
    # Obtenir le nom de l'appareil Bluetooth connecté
    bluetoothctl devices Connected | grep -E "(headset|headphones|speaker|audio)" | head -1 | cut -d' ' -f3-
}

get_audio_icon() {
    volume=$(get_volume)
    is_muted=$(get_mute_status)
    is_bluetooth=$(get_bluetooth_status)

    if [ "$is_muted" = "true" ]; then
        echo "audio-volume-muted"
    elif [ "$is_bluetooth" = "true" ]; then
        if [ "$volume" -eq 0 ]; then
            echo "audio-headphones-bluetooth-off"
        elif [ "$volume" -le 33 ]; then
            echo "audio-headphones-bluetooth-low"
        elif [ "$volume" -le 66 ]; then
            echo "audio-headphones-bluetooth-medium"
        else
            echo "audio-headphones-bluetooth-high"
        fi
    else
        if [ "$volume" -eq 0 ]; then
            echo "audio-volume-off"
        elif [ "$volume" -le 33 ]; then
            echo "audio-volume-low"
        elif [ "$volume" -le 66 ]; then
            echo "audio-volume-medium"
        else
            echo "audio-volume-high"
        fi
    fi
}

set_volume() {
    if [ -n "$1" ]; then
        pactl set-sink-volume @DEFAULT_SINK@ "$1%"
    fi
}

toggle_mute() {
    pactl set-sink-mute @DEFAULT_SINK@ toggle
}

volume_up() {
    pactl set-sink-volume @DEFAULT_SINK@ +5%
}

volume_down() {
    pactl set-sink-volume @DEFAULT_SINK@ -5%
}

# Actions selon le paramètre
case "$1" in
    "volume")
        get_volume
        ;;
    "mute")
        get_mute_status
        ;;
    "bluetooth")
        get_bluetooth_status
        ;;
    "bluetooth-name")
        get_bluetooth_device_name
        ;;
    "icon")
        get_audio_icon
        ;;
    "set")
        set_volume "$2"
        ;;
    "toggle")
        toggle_mute
        ;;
    "up")
        volume_up
        ;;
    "down")
        volume_down
        ;;
    "info")
        echo "Volume: $(get_volume)%"
        echo "Muted: $(get_mute_status)"
        echo "Bluetooth: $(get_bluetooth_status)"
        if [ "$(get_bluetooth_status)" = "true" ]; then
            echo "Device: $(get_bluetooth_device_name)"
        fi
        echo "Icon: $(get_audio_icon)"
        ;;
    *)
        echo "Usage: $0 {volume|mute|bluetooth|bluetooth-name|icon|set <volume>|toggle|up|down|info}"
        exit 1
        ;;
esac
