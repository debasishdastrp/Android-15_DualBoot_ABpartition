#!/sbin/sh
source ./banner.sh
printBanner

slot=$(bootctl get-current-slot)
echo "Setting up tools ......"
cd /tmp
sleep 0.5
mkdir tools
sleep 0.5
mount /dev/block/sda24 tools/
sleep 0.5
cd tools
echo "Done"
echo "Re-writing recovery images......"
dd if=/tmp/tools/recovery_a.img of=/dev/block/by-name/recovery_a
sleep 0.5
dd if=/tmp/tools/recovery_b.img of=/dev/block/by-name/recovery_b
sleep 0.5
echo "Done"
if [ "$slot" -eq 0 ]; then
    echo "Setting up Partitions"
    ./parted /dev/block/sda "name 22 userdata_a"
    sleep 0.5
    ./parted /dev/block/sda "name 23 userdata"
    sleep 0.5 
else
    echo "Setting up Partitions"
    ./parted /dev/block/sda "name 22 userdata_b"
    sleep 0.5
    ./parted /dev/block/sda "name 23 userdata"
    sleep 0.5
fi
sleep 0.5
echo "==================Importent=================="
echo "1> Now reboot to system will take you to secondary os"
echo "2> Next, boot into secondary recovery and run the script: 4_SecondaryBackup.sh"
