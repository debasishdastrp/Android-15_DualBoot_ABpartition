#!/sbin/sh
source ./banner.sh
printBanner
echo "Setting up tools ......"
cd /tmp
sleep 0.5
mkdir tools
sleep 0.5
mount /dev/block/sda24 tools/
sleep 0.5
cd tools