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
if [ "$slot" -eq 0 ]; then
    echo "Current boot slot is: A"
    sleep 0.5
    echo "Taking Backup image of partition: metadata,recovery_a"
    if [ -e "./metadata_a.img" ]; then
        echo "Removing old backup"
        rm -f ./metadata_a.img
        sleep 0.5
        echo "Done"
    fi
    dd if=/dev/block/by-name/metadata of=metadata_a.img 
    sleep 0.5
    if [ -e "./recovery_a.img" ]; then
        echo "Removing old backup"
        rm -f ./recovery_a.img
        sleep 0.5
        echo "Done"
    fi
    dd if=/dev/block/by-name/recovery_a of=recovery_a.img
    sleep 0.5
else
    echo "Current boot slot is: B"
    sleep 0.5
    echo "Taking Backup image of partition: metadata,recovery_b"
    if [ -e "./metadata_b.img" ]; then
        echo "Removing old backup"
        rm -f ./metadata_b.img
        sleep 0.5
        echo "Done"
    fi
    dd if=/dev/block/by-name/metadata of=metadata_b.img 
    sleep 0.5
    if [ -e "./recovery_b.img" ]; then
        echo "Removing old backup"
        rm -f ./recovery_b.img
        sleep 0.5
        echo "Done"
    fi
    dd if=/dev/block/by-name/recovery_b of=recovery_b.img
    sleep 0.5
fi
echo "==================Importent=================="
echo "1> Now flash secondary OS zip"
if [ "$slot" -eq 0 ]; then
echo "2> Rename secondary recovery image as rocovery_b.img and place it in /tmp/tools/"
else
echo "2> Rename secondary recovery image as rocovery_a.img and place it in /tmp/tools/"
fi
echo "3> After that, run the script: 3_SecondarySetup.sh"