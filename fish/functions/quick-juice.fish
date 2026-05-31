function quick-juice --description 'Enable hardware Rapid Charging, Power-Saver CPU, 60Hz 10-bit Display'
    echo 0 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode > /dev/null
    echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x07' | sudo tee /proc/acpi/call > /dev/null
    powerprofilesctl set power-saver
    hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "2880x1800@60.00Hz", position = "auto", scale = "1.6", bitdepth = 10, cm = "dcip3" })'
    echo "⚡ Quick-Juice Active (Prioritizing rapid battery fill over CPU power, 60Hz Display)."
end
