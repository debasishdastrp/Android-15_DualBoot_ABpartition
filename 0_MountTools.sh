#!/sbin/sh
mountTools()
{
local tool=$( mount | grep /tmp/tools )
if [ -z "$tool" ]; then
    echo "Setting up tools ......"
    cd /tmp
    sleep 0.5
    mkdir tools
    sleep 0.5
    mount /dev/block/sda24 tools/
    sleep 0.5
    cd tools
else
    echo "Tools already Mounted"
    cd /tmp/tools
fi
}


putTools()
{
local data=$(mount | grep /data)
if [ -z "$data" ]; then
    echo "Data not mounted. Can not put scripts in /data/tools"
else
    if [ -e "/data/tools" ]; then
        echo "tools directory already exists in /data"
        echo "Cleaning Up..."
        rm -rf /data/tools/*
        sleep 0.5
        echo "Putting scripts in /data/tools/"
        cp ./* /data/tools/
        sleep 0.5
    else
        echo "Putting scripts in /data/tools/"
        mkdir /data/tools
        sleep 0.5
        cp ./* /data/tools/
        sleep 0.5
    fi
fi
}