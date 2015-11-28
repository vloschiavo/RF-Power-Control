#!/bin/bash

#Turn on the outlet

stty -F /dev/ttyACM0 cs8 115200 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts
tail -f /dev/ttyACM0 &
echo "$!" > /tmp/a2sleep.pid
sleep 2
echo "Turning on outlet a2"
echo "a21" > /dev/ttyACM0
kill `cat /tmp/a2sleep.pid`
rm /tmp/a2sleep.pid

echo "sleeping for 30 minutes..."
sleep 10

stty -F /dev/ttyACM0 cs8 115200 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts
tail -f /dev/ttyACM0 &
echo "$!" > /tmp/a2sleep.pid
sleep 2
echo "Turning off outlet a2"
echo "a20" > /dev/ttyACM0
kill `cat /tmp/a2sleep.pid`
rm /tmp/a2sleep.pid

