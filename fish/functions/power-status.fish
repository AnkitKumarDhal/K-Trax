function power-status --description 'View complete custom power profile layout'
    set -l cons (cat /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode)
    echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x07' | sudo tee /proc/acpi/call > /dev/null
    set -l rapid (sudo cat /proc/acpi/call)
    set -l active_profile (powerprofilesctl get)
    set -l hz (hyprctl monitors -j | jaq -r '.[] | select(.name == "eDP-1") | .refreshRate' | cut -d'.' -f1)
    
    echo "==============================================="
    echo "⭐ LENOVO PERFORMANCE & BATTERY PANEL ⭐"
    echo "==============================================="
    if test "$cons" = "1"; echo "🔋 Conservation Cap : ENABLED (80% Safety Boundary)"; else; echo "❌ Conservation Cap : DISABLED"; end
    if test "$rapid" = "0x1" -o "$rapid" = "1"; echo "⚡ Rapid Charge      : ENABLED (Maximum Wattage Flow)"; else; echo "❌ Rapid Charge      : DISABLED"; end
    echo "⚙️  Linux CPU Profile : $active_profile"
    echo "🖥️  Monitor Rate     : $hz Hz"
    echo "==============================================="
    
    if test "$cons" = "1" -a "$active_profile" = "balanced"
        echo "🎯 Active Profile   : 📚 STUDY-MODE"
    else if test "$cons" = "1" -a "$active_profile" = "performance"
        echo "🎯 Active Profile   : 🎮 GAME-MODE"
    else if test "$cons" = "0" -a "$active_profile" = "power-saver" -a "$rapid" = "0x1"
        echo "🎯 Active Profile   : ⚡ QUICK-JUICE"
    else if test "$cons" = "0" -a "$active_profile" = "power-saver"
        echo "🎯 Active Profile   : 🍃 ECO-MODE"
    else
        echo "🎯 Active Profile   : ⚠️ CUSTOM/MIXED STATE"
    end
    echo "==============================================="
end
