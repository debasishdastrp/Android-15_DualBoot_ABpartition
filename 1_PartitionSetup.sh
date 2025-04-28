#!/sbin/sh
slot=$(bootctl get-current-slot)
echo "Unmounting Data Partition ......."
umount /data
sleep 0.5
umount /metadata
sleep 0.5
echo "Done"
echo "Setting Up Partitions....."
echo "Current Partitions:"
./parted /dev/block/sda "print"
echo -n "Enter end postition followed by GB/MB for cureent/primary userdata partiion: "
read oldend
./parted /dev/block/sda "resizepart 22 $oldend"
sleep 0.5
echo -n "Enter end postition followed by GB/MB for secondary userdata partiion: "
read newend
./parted /dev/block/sda "mkpart primary ext4 $oldend $newend"
sleep 0.5
echo -n "Enter end postition followed by GB/MB for tools partiion: "
read toolsend
./parted /dev/block/sda "mkpart primary ext4 $newend $toolsend"
sleep 0.5
if [ "$slot" -eq 0 ]; then
    echo "Current boot slot is: A"
    ./parted /dev/block/sda "name 23 userdata_b"
else
    echo "Current boot slot is: B"
    ./parted /dev/block/sda "name 23 userdata_a"
fi
sleep 0.5
./parted /dev/block/sda "name 24 tools"
sleep 0.5
./mkfs.ext4 /dev/block/sda22
sleep 0.5
./mkfs.ext4 /dev/block/sda23
sleep 0.5
./mkfs.ext4 /dev/block/sda24
sleep 0.5
echo "Done"
sleep 0.5
echo "Setting up tools ......"
mkdir /tmp/tools
sleep 0.5
mount /dev/block/sda24 /tmp/tools/
sleep 0.5
cp ./parted /tmp/tools/
cp ./mkfs.ext4 /tmp/tools/
cp *.sh /tmp/tools/
sleep 0.5
chmod +x /tmp/tools/*
sleep 0.5
echo "Done"
sleep 0.5
echo "==================Importent=================="
echo "1> Now format the data partition and reboot into system"
echo "2> After intial android setup reboot into recovery"
echo "3> After reboot run the 2_PrimaryBackup.sh script"