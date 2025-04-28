#!/sbin/sh
source ./banner.sh
source ./0_MountTools.sh
printBanner

echo -n "What is the current boot slot (a/b): "
read currentslot
mountTools
echo "Done"
if [ -e "./metadata_$currentslot.img" ]; then
        echo "Removing old backup"
        rm -f ./metadata_$currentslot.img
        sleep 0.5
        echo "Done"
fi
dd if=/dev/block/by-name/metadata of=metadata_$currentslot.img
sleep 0.5
putTools