#!/sbin/sh
source ./banner.sh
source ./0_MountTools.sh
printBanner

slot=$(bootctl get-current-slot)
mountTools
echo "Done"
if [ "$slot" -eq 0 ]; then
    echo "Setting up Partitions"
    ./parted /dev/block/sda "name 22 userdata_a"
    sleep 0.5
    ./parted /dev/block/sda "name 23 userdata"
    sleep 0.5
    dd if=metadata_b.img of=/dev/block/by-name/metadata
    echo "Done"
    putTools
    sleep 0.5
    echo "==================Importent=================="
    echo "1> Now reboot into Recovery again."
    echo "2> After reboot switch boot slot and reboot to system"
    
else
    echo "Setting up Partitions"
    ./parted /dev/block/sda "name 22 userdata_b"
    sleep 0.5
    ./parted /dev/block/sda "name 23 userdata"
    sleep 0.5
    dd if=metadata_a.img of=/dev/block/by-name/metadata
    echo "Done"
    putTools
    sleep 0.5
    echo "==================Importent=================="
    echo "1> Now reboot into Recovery again."
    echo "2> After reboot switch boot slot and reboot to system"
fi
