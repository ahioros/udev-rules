#!/bin/sh

# Link
# https://askubuntu.com/questions/112705/how-do-i-make-powertop-changes-permanent

# For systemd
# https://askubuntu.com/questions/919054/how-do-i-run-a-single-command-at-startup-using-systemd
# https://askubuntu.com/questions/913838/writing-systemd-script

if on_ac_power; then
        #-- Start AC powered settings --#
        
        # Disable laptop mode
        echo 0 > /proc/sys/vm/laptop_mode
        
        #NMI watchdog should be turned on
        for foo in /proc/sys/kernel/nmi_watchdog;
        do echo 1 > $foo;
        done

        # Set SATA channel: max performance
        for foo in /sys/class/scsi_host/host*/link_power_management_policy;
        do echo max_performance > $foo;
        done

        # CPU Governor: Performance
        for foo in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor;
        do echo performance > $foo;
        done 

        # Disable USB autosuspend
        for foo in /sys/bus/usb/devices/*/power/level;
        do echo on > $foo;
        done

        # Disable PCI autosuspend
        for foo in /sys/bus/pci/devices/*/power/control;
        do echo on > $foo;
        done       

        # Disable i2c autosuspend
        for foo in /sys/bus/i2c/devices/i2c-*/device/power/control
        do echo on > $foo;
        done

        # Activate PCI ATA autosuspend
        for foo in /sys/bus/pci/devices/*/ata*/power/control;
        do echo on > $foo;
        done

        # Disabile audio_card power saving
        echo 0 > /sys/module/snd_hda_intel/parameters/power_save_controller
        echo 0 > /sys/module/snd_hda_intel/parameters/power_save

        # powersave for sda (windows disk)
        echo 'auto' > /sys/block/sda/device/power/control

        # Enable CPU Turbo Boost
        echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo

        # Disable wifi powersave
        iw dev wlan0 set power_save off

else
        
        #-- Start battery powered settings --#        
        
        # Enable Laptop-Mode disk writing
        echo 5 > /proc/sys/vm/laptop_mode
        
        #NMI watchdog should be turned on
        for foo in /proc/sys/kernel/nmi_watchdog;
        do echo 0 > $foo;
        done     
        
        # Set SATA channel to power saving
        for foo in /sys/class/scsi_host/host*/link_power_management_policy;
        do echo min_power > $foo;
        done

        # Select powersave CPU Governor
        for foo in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor;
        do echo powersave > $foo;
        done        

        # Activate USB autosuspend
        for foo in /sys/bus/usb/devices/*/power/level;
        do echo auto > $foo;
        done

        # Activate PCI autosuspend
        for foo in /sys/bus/pci/devices/*/power/control;
        do echo auto > $foo;
        done

        # Activate i2c autosuspend
        for foo in /sys/bus/i2c/devices/i2c-*/device/power/control;
        do echo auto > $foo;
        done

        # Activate PCI ATA autosuspend
        for foo in /sys/bus/pci/devices/*/ata*/power/control;
        do echo auto > $foo;
        done

        # Activate audio card power saving
        # (sounds shorter than 5 seconds will not be played)
        echo 5 > /sys/module/snd_hda_intel/parameters/power_save
        echo 1 > /sys/module/snd_hda_intel/parameters/power_save_controller

        # powersave for sda (windows disk)
        echo 'auto' > /sys/block/sda/device/power/control

        # Disable CPU Turbo Boost
        echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo

        # Enable wifi powersave
        iw dev wlan0 set power_save on



fi
