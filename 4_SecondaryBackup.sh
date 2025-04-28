#!/sbin/sh
source ./banner.sh
printBanner

echo -n "What is the current boot slot (a/b): "
read currentslot
echo "Setting up tools ......"
cd /tmp
sleep 0.5
mkdir tools
sleep 0.5
mount /dev/block/sda24 tools/
sleep 0.5
cd tools
echo "Done"
if [ -e "./metadata_$currentslot.img" ]; then
        echo "Removing old backup"
        rm -f ./metadata_$currentslot.img
        sleep 0.5
        echo "Done"
fi
dd if=/dev/block/by-name/metadata of=metadata_$currentslot.img
sleep 0.5