#!/sbin/sh
source ./banner.sh
source ./0_MountTools.sh
printBanner

echo -n "What is the current boot slot (a/b): "
read currentslot
mountTools
echo "Setting up Partitions"
./parted /dev/block/sda "name 22 userdata"
sleep 0.5
./parted /dev/block/sda "name 23 userdata_$currentslot"
sleep 0.5
echo "Done"

sleep 0.5
if [ "$currentslot" = "a" ]; then
    echo "reWriting Slot: B metadata partition"
    dd if=metadata_b.img of=/dev/block/by-name/metadata
    sleep 0.5
    echo "Done"
    putTools
    sleep 0.5
    echo "==================Importent=================="
    echo "1> Now reboot into bootloader mode."
    echo "2> Connect the device to computer and execute fastboot --set-active=b"
fi
if [ "$currentslot" = "b" ]; then
    echo "reWriting Slot: A metadata partition"
    dd if=metadata_a.img of=/dev/block/by-name/metadata
    sleep 0.5
    echo "Done"
    putTools
    sleep 0.5
    echo "==================Importent=================="
    echo "1> Now reboot into bootloader mode."
    echo "2> Connect the device to computer and execute fastboot --set-active=a"
fi
