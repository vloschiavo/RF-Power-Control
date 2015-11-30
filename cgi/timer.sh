#!/bin/bash

#Turn on the outlet

stty -F /dev/ttyACM0 cs8 115200 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts
tail -f /dev/ttyACM0 &
echo "$!" > /tmp/a2sleep.pid
sleep 2
echo "Turning on outlet $1"
echo "${1}1" > /dev/ttyACM0
kill `cat /tmp/a2sleep.pid`
rm /tmp/a2sleep.pid

echo "Sleeping for $2 seconds..."
sleep $2

stty -F /dev/ttyACM0 cs8 115200 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts
tail -f /dev/ttyACM0 &
echo "$!" > /tmp/a2sleep.pid
sleep 2
echo "Turning off outlet $1"
echo "${1}0" > /dev/ttyACM0
kill `cat /tmp/a2sleep.pid`
rm /tmp/a2sleep.pid

