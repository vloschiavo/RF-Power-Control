#!/bin/bash
stty -F /dev/ttyACM0 cs8 115200 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts
tail -f /dev/ttyACM0 &
echo "$!" > /tmp/a2sleep.pid
sleep 2
echo "Issuing $1"
echo "$1" > /dev/ttyACM0
kill `cat /tmp/a2sleep.pid` > /dev/null
rm /tmp/a2sleep.pid
