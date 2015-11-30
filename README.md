# RF-Power-Control
Collection of CGI/Perl and Bash Cron jobs to control RF power outlets

Requires Arduino with RF transmitter and arduino code

####Outlets

Indoor: http://www.amazon.com/Woods-13569-Wireless-Control-Outlets/dp/B003ZTWYXY/
Outdoor: http://www.amazon.com/Utilitech-13-amp-Wireless-Remote-Control/dp/B00HO5M8ZY

####RF Transmitter
http://www.dx.com/p/tdl-9906a-315mhz-wireless-transmitter-module-green-126105#.VlziASCrTJ8

####Arduino
http://www.dx.com/p/funduino-uno-r3-atmega328-development-board-for-arduino-384207#.VlziIiCrTJ8

####Arduino Library
I trimmed down the RCSwitch library since it had a ton of stuff I didn't need and I wanted to save memory space on the Arduino since I'm using it for a ton of stuff besides this RF transmitter project at the same time.  32k of Flash and 2k of SRAM doesn't go very far...
https://github.com/sui77/rc-switch

####Linux server
I used an original MK802 - ARM based machine running debian
https://en.wikipedia.org/wiki/Android_Mini_PC_MK802

