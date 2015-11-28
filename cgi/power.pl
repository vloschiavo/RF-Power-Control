#!/usr/bin/perl -W
#
# Author: Vince Loschiavo
# Date: 16APR2014
# Version: 1.0
# Modified: 11/28/2015 - Added count-down timer functions to support shop fan (turn off after x minutes)

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

#######################################################
#
# Define Variables
#
#######################################################

my $cgi = new CGI();
my $output; # Add HTML to this scalar and print

#
# If we're invoked directly, there's no form data yet.  display the form and halt.
#

my $action = "none";

if (! $cgi->param("FormSubmit") ) {
	DisplayForm();
	exit;
}

# grep for other actions
my @actions = grep s/^([a-eA-E][1-3][0-1])\z/$1/, $cgi->param;
($action) = @actions;

if ( $action eq "e11" ) {
	# bash to turn on the thing, sleep for 1800 seconds, and turn off.
	system ("/var/www/cgi-bin/a2timer.sh > /dev/null 2>&1 &");
	&DisplayForm($action);
	exit;
}

# Prepare the Serial Port
use Device::SerialPort;
my $port = Device::SerialPort->new("/dev/ttyACM0");
$port->baudrate(115200); # you may change this value
$port->databits(8); # but not this and the two following
$port->parity("none");
$port->stopbits(1);

# now catch gremlins at start
my $tEnd = time()+2; # 2 seconds in future
while (time()< $tEnd) { # end latest after 2 seconds
  my $c = $port->lookfor(); # char or nothing
  next if $c eq ""; # restart if noting
  # print $c; # uncomment if you want to see the gremlin
  last;
}
while (1) { # and all the rest of the gremlins as they come in one piece
  my $c = $port->lookfor(); # get the next one
  last if $c eq ""; # or we're done
  #print $c; # uncomment if you want to see the gremlin
}

#while (1) {
#    # Poll to see if any data is coming in
#    my $char = $port->lookfor();
# 
    # If we get data, then print it
    # Send a number to the arduino
#    if ($char) {
#        print "Received character: $char \n";
#    }
    # Uncomment the following lines, for slower reading,
    # but lower CPU usage, and to avoid
    # buffer overflow due to sleep function.

    # $port->lookclear;
    # sleep (1);
#}
sleep (2);


# Turn on/off port
$port->write("$action");
#my $channel = substr $action, 0,2;
#my $state = substr $action, 2,1;
#print "Turned outlet: $channel ";
#if ($state == 1) {
#	print "on.<br>";
#}else{
#	print "off.<br>";
#}
#print ("\n</body></html>");

&DisplayForm($action);
exit;


##############################################
# Subroutines
##############################################


##############################################################################################
# DisplayForm - spits out HTML to display the Event Detail Submission Form
#
sub DisplayForm {

print "Content-type: text/html\n\n";

print <<"HTMLpage";

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />

<title>Power Control</title>

</head>
<body>
<form action="/cgi-bin/power.pl" method="post" enctype="multipart/form-data">

<input type="hidden" name="FormSubmit" value="PowerData">

<h3>Vince Loschiavo <br> Powered Outlet Control</h3>

<table border="0" width="100%" cellpadding="10">

<tr>

<td width="50%" valign="top">

Previous command was $action<br><br>

<b>Instructions:</b><br>
1) Choose outlet state<br>
<br>
 <table style="width:100%">
  <tr>
    <th><center>Device</center></th>
    <th>On</th>
    <th>Off</th>
  </tr>
  <tr>
    <td><center>Christmas Tree</center></td>
    <td><center><input type="submit" name="a11" value="a1 on"></center></td>
    <td><center><input type="submit" name="a10" value="a1 off"></center></td>
  </tr>
  <tr>
    <td><center>Garage Filtered Fan</center></td>
    <td><center><input type="submit" name="a21" value="a2 on"></center></td>
    <td><center><input type="submit" name="a20" value="a2 off"></center></td>
  </tr>
  <tr>
    <td><center>Garage Filtered Fan 30 Minute Timer for Outlet A2</center></td>
    <td><center><input type="submit" name="e11" value="30 min"</center></td>
  </tr>
  <tr>
    <td><center>External Christmas Lights</center></td>
    <td><center><input type="submit" name="c21" value="c2 on"></center></td>
    <td><center><input type="submit" name="c20" value="c2 off"></center></td>
  </tr>
  <tr>
    <td><center>External Outlet D2</center></td>
    <td><center><input type="submit" name="d21" value="d2 on"></center></td>
    <td><center><input type="submit" name="d20" value="d2 off"></center></td>
  </tr>
</table> 
<br><br><br>
<input type="submit" name="a11" value="a1 on">
<input type="submit" name="a10" value="a1 off">
<br><br>
<input type="submit" name="a21" value="a2 on">
<input type="submit" name="a20" value="a2 off">
<br><br>
<input type="submit" name="a31" value="a3 on">
<input type="submit" name="a30" value="a3 off">
<br><br>
<input type="submit" name="b11" value="b1 on">
<input type="submit" name="b10" value="b1 off">
<br><br>
<input type="submit" name="b21" value="b2 on">
<input type="submit" name="b20" value="b2 off">
<br><br>
<input type="submit" name="b31" value="b3 on">
<input type="submit" name="b30" value="b3 off">
<br><br>
<input type="submit" name="c11" value="c1 on">
<input type="submit" name="c10" value="c1 off">
<br><br>
External Christmas Lights
<input type="submit" name="c21" value="c2 on">
<input type="submit" name="c20" value="c2 off">
<br><br>
<input type="submit" name="c31" value="c3 on">
<input type="submit" name="c30" value="c3 off">
<br><br>
<input type="submit" name="d11" value="d1 on">
<input type="submit" name="d10" value="d1 off">
<br><br>
External Outlet D2
<input type="submit" name="d21" value="d2 on">
<input type="submit" name="d20" value="d2 off">
<br><br>
<input type="submit" name="d31" value="d3 on">
<input type="submit" name="d30" value="d3 off">
<br><br>

<br><br>
</form>
</body>
</html>

HTMLpage
}	# End DisplayForm subroutine
################################################################################################
