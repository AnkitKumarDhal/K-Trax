function eco-mode --description 'Disable charging caps, Power-Saver CPU, Force 60Hz 10-bit Display'
    echo 0 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode > /dev/null
    echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x08' | sudo tee /proc/acpi/call > /dev/null
    powerprofilesctl set power-saver
    hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "2880x1800@60.00Hz", position = "auto", scale = "1.6", bitdepth = 10, cm = "dcip3" })'
    echo "🍃 Eco Mode Active (Fills to 100%, Power-Saver CPU, Display clamped to 60Hz)."
end
