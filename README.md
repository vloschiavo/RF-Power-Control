## RF-Power-Control
Collection of CGI/Perl and Bash Cron jobs to control RF power outlets

This gives you a web page you can use to Radio Frequency Remote Control outlets.  Additionally, example cron jobs are included for time of day control.

Uses:
I'm currently using this setup for Holiday lights and a timer for a garage filter fan to filter saw dust (https://www.youtube.com/watch?v=kH5APw_SLUU).


####Outlets

Indoor: http://www.amazon.com/Woods-13569-Wireless-Control-Outlets/dp/B003ZTWYXY/
Outdoor: http://www.amazon.com/Utilitech-13-amp-Wireless-Remote-Control/dp/B00HO5M8ZY

These come in different channel sets.
I purchased two of the indoor sets.  That gives me six remotes: A1,A2,A3 & B1,B2,B3.

I purchased two of the dual outlet outdoor outlets.
C2 and D2.

####RF Transmitter
http://www.dx.com/p/tdl-9906a-315mhz-wireless-transmitter-module-green-126105#.VlziASCrTJ8

####Arduino
I used an Arduino Uno - since I had it on hand, but any microcontroller will work.  We'll be using the microcontroller to generate the pulses to emulate/replace the physical remotes you get with the outlets.
http://www.dx.com/p/funduino-uno-r3-atmega328-development-board-for-arduino-384207#.VlziIiCrTJ8

####Modified Arduino Library
I trimmed down the RCSwitch library since it had a ton of stuff I didn't need and I wanted to save memory space on the Arduino since I'm using it for a ton of stuff besides this RF transmitter project at the same time.  32k of Flash and 2k of SRAM doesn't go very far...
https://github.com/sui77/rc-switch

####Linux server
I used an original MK802 - ARM based machine running debian - although any machine would work well, including raspberry pi or any intel pc running any flavor of linux.  I chose the MK802 since I still have it running a different project: (http://hackaday.com/2013/07/25/android-stick-mutates-into-a-home-server/).

https://en.wikipedia.org/wiki/Android_Mini_PC_MK802

Need to make sure Perl is installed and you have a usb cable to connect the server to the microcontroller.
