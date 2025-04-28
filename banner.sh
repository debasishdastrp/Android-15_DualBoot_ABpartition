#!/sbin/sh
printBanner()
{
    drawLine
cat<<EOF
  
Clicks and Bits

EOF
drawLine
}

drawLine()
{
line=""
a=0
while [ $a -lt 30 ]
do
line+="="
echo -ne "$line \r"
sleep 0.005
a=`expr $a + 1`
done
echo $line
echo " "
sleep 0.5
}