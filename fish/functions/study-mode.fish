function study-mode --description 'Lock battery at 80%, Balanced CPU, 120Hz 10-bit Display'
    echo 1 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode > /dev/null
    echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x08' | sudo tee /proc/acpi/call > /dev/null
    powerprofilesctl set balanced
    hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "2880x1800@120.00Hz", position = "auto", scale = "1.6", bitdepth = 10, cm = "dcip3" })'
    echo "📚 Study Mode Active (80% Battery Cap, Balanced CPU, Smooth 120Hz 10-bit OLED)."
end
