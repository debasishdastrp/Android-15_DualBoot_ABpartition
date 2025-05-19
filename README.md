

# Android -15 Dual Boot Setup – A/B Devices


# Basic requirement

 - The android device must have / support A/B slot system.
 - The Treble info app can be used to determine that. Download the app
   from [here.](https://f-droid.org/en/packages/tk.hack5.treblecheck/)

## 1.	Initial Steps
1.1.	Unlock Bootloader<br>
1.2.	Flash TWRP<br>
1.3.	Flash Magisk<br>
1.4.	Flash DM verity

## 2.	Create Partitions
2.1.	Boot device in TWRP<br>
2.2.	Push following tools to device /tmp directory using ADB

						
|Tool  |Command  |
|--|--|
|parted  |adb push parted /tmp/  |
|mkfs.ext4 |adb push mkfs.ext4 /tmp/|

2.3.	Open ADB shell on computer: adb shell<br>
2.4.	Run command: cd /tmp<br>
2.5.	Provide executable permission to copied tools<br>
2.6.	Run command: ./parted /dev/block/sda<br>
2.7.	Run following commands (one line at a time) under parted to create partitions

    resizepart 22 100.0GB
    mkpart primary ext4 100.0GB 123.0GB
    mkpart primary ext4 123.0GB 124.0GB
    name 23 userdata_a
    name 24 tools
    ./mkfs.ext4 /dev/block/sda22
    ./mkfs.ext4 /dev/block/sda23
    ./mkfs.ext4 /dev/block/sda24

> Note: check for the current active slot. In my device slot b was
> active and partition 22 was kept for userdata of that slot and
> partition 23 was created for slot a.

## 3.	Tools partition
3.1.	This partition is needed to store earlier mentioned tools and metadata partition backups.<br>
3.2.	Run the following command set to mount partition no. 24, created.

    cd /tmp
    sleep 0.5
    mkdir tools
    sleep 0.5
    mount /dev/block/sda24 tools/
    sleep 0.5
    cd tools

3.3.	Run following commands to store tools in tools partition and provide necessary permissions.

    cp ../parted ./
    cp ../mkfs.ext4 ./
    chmod +x ./*

➡️**Step-1, Step-2 and Step-3 has been implemented in 1_PartitionSetup.sh script**

## 4.	Primary OS Setup
4.1.	Format the data partition in TWRP recovery<br>
4.2.	Reboot to system.<br>
4.3.	Complete Android setup.<br>
4.4.	Reboot into TWRP recovery.<br>
4.5.	Connect the device to computer and open ADB shell on computer.<br>
4.6.	Mount tools partition using steps / commands mentioned earlier in 3.b. <br>
4.7.	Take backup of metadata partition using following command.

    dd if=/dev/block/by-name/metadata of=metadata_b.img 

4.8.	Now take backup of recovery partition’s backup as well using following command

    dd if=/dev/block/by-name/recovery_b of=recovery_b.img 

> Note: It is not necessary to use ADB shell for executing commands. You
> can use the terminal available in TWRP recovery also. I found the ADB
> shell comfortable.

➡️**Step-4 has been implemented in 2_PrimaryBackup.sh script**
## 5.	Secondary OS Setup
5.1.	Flash the secondary OS zip (e.g. Lineage OS) using TWRP recovery<br>
5.2.	Download and copy recovery image of secondary OS to tools partition using following ADB command

    adb push recovery.img /tmp/tools/ 

5.3.	Write secondary OS recovery image to relative recovery slot using following command.

    dd if=/tmp/tools/recovery.img of=/dev/block/by-name/recovery_a 

 
5.4.	Write primary OS recovery backup back to current recovery slot using following command.

    dd if=/tmp/tools/recovery_b.img of=/dev/block/by-name/recovery_b

5.5.	Now reboot the device to system. Secondary OS will boot.<br>
5.6.	After initial Android setup, reboot the device to secondary recovery and enable ADB<br>
5.7.	Connect using adb and mount tools partition using steps / commands mentioned earlier in 3.b.<br>
5.8.	Now take metadata partition backup to tools partition using following command. 

    dd if=/dev/block/by-name/metadata of=metadata_a.img 

> Note: After flashing new OS zip, slots will get switched
> automatically. E.g. if slot a is current active slot then slot b will
> be set active for next boot.

➡️**Step-5 has been implemented in 3_SecondarySetup.sh & 4_SecondaryBackup.sh script**

## 6.	Switching Between Slots
There are few things I need to mention before starting this section. 

 - TWRP recovery provides functionality to switch between slots. This
   makes it very easy to switch slots after running OS switch commands
   or script, that I am going to demonstrate.
 - If recovery doesn't support slot switching such as Lineage OS
   recovery, in that case device need to be booted into bootloader mode
   after executing slot switching commands. Then we have to connect the
   device to a computer and need to run fastboot commands to switch
   slots.
 - If either / both of the OS are rooted, then also slot switching is
   possible from the OS itself, provided the android version is older
   than 12.0
 - In my particular case, Primary OS is Android 11 and Secondary OS is
   Android 15. I will demonstrate the both: recovery and fastboot
   switching methods.

## 6.A. Switching – Primary OS to Secondary OS (Using ADB)
a)	Reboot the device to recovery mode from Secondary OS<br>
b)	Mount tools partition using steps / commands mentioned earlier in 3.b.<br>
c)	Run the following commands to set metadata & userdata partition to boot from alternative slot.

    ./parted /dev/block/sda "name 22 userdata_b"
    sleep 0.5
    ./parted /dev/block/sda "name 23 userdata"
    sleep 0.5
    dd if=metadata_a.img of=/dev/block/by-name/metadata
    
d)	Reboot the device from recovery to recovery again.<br>
e)	Set Secondary OS slot for next boot.<br>
f)	Reboot to system. Secondary OS should boot this time.

> Note: All these commands need to execute to switch OS each time. Its
> pretty painful. To reduce this strain, I will try to build a script
> and place that in the system somewhere.

➡️**This option has been implemented in 5_SwitchP2S.sh script**

 

## 6.B. Switching – Secondary OS to Primary OS (Using Computer)
a)	Reboot the device to recovery mode from Primary OS<br>
b)	Enable ADB and connect computer in ADB mode.<br>
c)	Mount tools partition using steps / commands mentioned earlier in 3.b.<br>
d)	Run the following commands to set metadata & userdata partition to boot from alternative slot.

    ./parted /dev/block/sda "name 23 userdata_a"
    sleep 0.5
    ./parted /dev/block/sda "name 22 userdata"
    sleep 0.5
    dd if=metadata_b.img of=/dev/block/by-name/metadata


e)	Reboot the device from recovery to bootloader mode.<br>
f)	Set Primary OS slot for next boot using following fastboot command.

    fastboot –-set-active=b

g)	Reboot to system. Secondary OS should boot this time.

> Note: All these commands need to execute to switch OS each time. Its
> pretty painful. To reduce this strain, I will try to build a script
> and place that in the system somewhere.

➡️**This option has been implemented in 6_SwitchS2P.sh script**
