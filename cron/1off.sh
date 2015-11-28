#!/bin/bash
stty -F /dev/ttyACM0 cs8 115200 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts
tail -f /dev/ttyACM0 &
sleep 2
echo "Turning off outlet 1"
echo "a10" > /dev/ttyACM0
killall -9 tail
