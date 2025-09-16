#!/bin/bash

# Script de gestion de la luminosité avec brightnessctl

get_brightness() {
    # Obtenir le pourcentage de luminosité actuel
    brightnessctl get -P
}

get_max_brightness() {
    # Obtenir la luminosité maximale
    brightnessctl max
}

get_current_brightness() {
    # Obtenir la luminosité actuelle (valeur absolue)
    brightnessctl get
}

get_brightness_icon() {
    brightness=$(get_brightness)

    if [ "$brightness" -eq 0 ]; then
        echo "brightness-off"
    elif [ "$brightness" -le 20 ]; then
        echo "brightness-low"
    elif [ "$brightness" -le 40 ]; then
        echo "brightness-medium-low"
    elif [ "$brightness" -le 60 ]; then
        echo "brightness-medium"
    elif [ "$brightness" -le 80 ]; then
        echo "brightness-medium-high"
    else
        echo "brightness-high"
    fi
}

set_brightness() {
    if [ -n "$1" ]; then
        brightnessctl set "$1%"
    fi
}

brightness_up() {
    brightnessctl set +10%
}

brightness_down() {
    brightnessctl set 10%-
}

brightness_max() {
    brightnessctl set 100%
}

brightness_min() {
    brightnessctl set 1%
}

# Actions selon le paramètre
case "$1" in
    "get" | "brightness")
        get_brightness
        ;;
    "max")
        get_max_brightness
        ;;
    "current")
        get_current_brightness
        ;;
    "icon")
        get_brightness_icon
        ;;
    "set")
        set_brightness "$2"
        ;;
    "up" | "increase")
        brightness_up
        ;;
    "down" | "decrease")
        brightness_down
        ;;
    "maximum")
        brightness_max
        ;;
    "minimum")
        brightness_min
        ;;
    "info")
        echo "Brightness: $(get_brightness)%"
        echo "Current: $(get_current_brightness)"
        echo "Max: $(get_max_brightness)"
        echo "Icon: $(get_brightness_icon)"
        ;;
    *)
        echo "Usage: $0 {get|brightness|max|current|icon|set <percentage>|up|down|maximum|minimum|info}"
        exit 1
        ;;
esac
