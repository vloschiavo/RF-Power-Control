/** 
rf_outlet_VL control - Built on Arduino Uno

Used to control RF outlets via 315 MHz RF Transmitter.  Interface is a serial console.
Built to control 12 outlets from the Woods set.  
3x Channel A, 3x Ch.B, 3x Ch.C, and 3x Ch.D.

Usage: Channel+Outlet+State
Channel = a || b || c || d
Outlet = 1 || 2 || 3
State = 0 || 1

Example:
a10 = turns off Channel A, outlet 1.
b31 = turns on Channel b, outlet 3

help = displays usage
save = saves current outlet states to eeprom (UNO only have 1KB eeprom / Pro Mini = 512B)
show = show current outlet states (stored in ram)
show eeprom = show outlet states saved in eeprom (this will be the state at next boot)
load eeprom = loads state from eeprom and applies


use this for eeprom operations: 
http://playground.arduino.cc/Code/EEPROMLoadAndSaveSettings

TO DO:
-Need to add RTC so we can do timed switch controls. - Only if standalone.
-Need to add a set current date/time function - only if standalone

-Need to add on and off date/time blobs & variables for each outlet and store in eeprom

**/

#include "RCSwitch.h"
//#include <EEPROMex.h>

// setup Remote Control Outlet library
RCSwitch mySwitch = RCSwitch();

// Temporary: Set initial Values of outletStatus just in case EEPROM data is invalid.
//Structure = Channel, outlet , Status , Desc
char* outletStatus[12][4] =
{ 
  //                 "----------------"
  {"A" , "1" , "0" , "LED Light       " },
  {"A" , "2" , "0" , "Office Desk     " },
  {"A" , "3" , "1" , "Garage Dehumid  " },
  {"B" , "1" , "0" , "NA              " },
  {"B" , "2" , "0" , "NA              " },
  {"B" , "3" , "0" , "NA              " },
  {"C" , "1" , "0" , "NA              " },
  {"C" , "2" , "0" , "NA              " },
  {"C" , "3" , "0" , "NA              " },
  {"D" , "1" , "0" , "NA              " },
  {"D" , "2" , "0" , "NA              " },
  {"D" , "3" , "0" , "NA              " },
};

/* Convert from the channel/outlet notation into a flat index to address the multidimentional array*/
int getIndexFromChannelOutlet(char channel, int outlet) {
	return ((int(channel) - 65) * 3) + outlet - 1;
/**
Math should work out as follows:
A1 = 0
A2 = 1
A3 = 2
B1 = 3
B2 = 4
B3 = 5
C1 = 6
C2 = 7
C3 = 8
D1 = 9
D2 = 10
D3 = 11

Usage example:
outletStatus[getIndexFromChannelOutlet(channel, outlet)][2] = "0";
**/

}

void outletOFF(char channel, int outlet) {
  Serial.print("Turning off "); Serial.print (channel); Serial.println (outlet);
  // send the RF sequences for off 
  mySwitch.switchOff(channel,outlet);

  // Change status in array
  outletStatus[getIndexFromChannelOutlet(channel, outlet)][2] = "0";
}

void outletON(char channel, int outlet) {
  Serial.print("Turning on "); Serial.print (channel); Serial.println (outlet);
  // send the RF sequences for on
  mySwitch.switchOn(channel,outlet);  

  // Change status in array
  outletStatus[getIndexFromChannelOutlet(channel, outlet)][2] = "1";
}

void help() {
      Serial.println("------------------------------------------------------");
      Serial.println("CLI usage and command format:");
      Serial.println("------------------------------------------------------");
      Serial.println("Outlet Control:  On=1 Off=0");
      Serial.println("Usage: a10 = turn off outlet A1,  a11 = turn on outlet A1.");
      Serial.println();
      Serial.println("Outlet Description usage: 'a3d OutletDescrpt123'");
      Serial.println("Description maximum = 15 Characters - will be truncated @ 15 characters.");
      Serial.println("'save eeprom' = saves current outlet states to eeprom - will be loaded on next boot.");
      Serial.println("'show eeprom' = Reads outlet states from eeprom and displays.");
      Serial.println("'load eeprom' = Reads outlet states from eeprom and implements them in real-time.");
      Serial.println("'show' = shows the current running states.");  
}

void show() {
  Serial.println();
  Serial.println("Current outlet status");
  Serial.println("------------------------------------------------------");
    // Loops through x and y values of 2D array, prints and formats values
    for (int i=0; i < 12; i++ ){
      for (int j=0; j < 4; j++ ){
        Serial.print(outletStatus[i][j]); 
        if (j == 1) {
          Serial.print(" ");
        }
        if (j == 2) {
          Serial.print(" - Description: ");
        }
      }
      Serial.println();
    } 
}

void prompt() {
  //Sets up Command prompt
  Serial.println();
  Serial.println("------------------------------------------------------");
  Serial.print("Enter Command:");
}

void setup()
{   
  
  // Transmitter is connected to Arduino Pin #9 
  mySwitch.enableTransmit(9);
  
  // Adjust pulse length and protocol to match your RF outlets - These settings work for the Woods branded outlets.
  mySwitch.setPulseLength(100);

  // Set Protocol (3 is used for switches without a chassis-mounted method for switching channel)
  mySwitch.setProtocol(3);

  /** Optional set number of transmission repetitions. 
  -For short range operations with a 5VDC source powering your arduino and the RF transmitter, repaets =5 works fine.
  -For longer range or environements with more interference push this higher.  I was able to send through walls over 40 feet (indoors) 
    with repeat = 10 and a 5VDC source (USB powered).  Further range can be achieved with higher voltages.  A 12VDC adapter can work well.
  **/
  mySwitch.setRepeatTransmit(15);

  // Read switchstate from EEPROM and Set switches on boot
  // if eeprom is good, then load eeprom into outlet status, else:
  // use program defaults

  Serial.begin(115200); // Initialize serial port 
  help();  //Display CLI usage info
  // To-Do: add read from eeprom here and if CRC passes write to outletstatus array. !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  show();  // show current state of the outlets.
  prompt();
}  

void loop() {
  //Begin looking for data coming from the serial port.
  String content = "";
  char character;    
  while(Serial.available()) {       
    character = Serial.read();       
    content.concat(character);       
    delay (10);   
  }
  content.concat("\0");  //perhaps we need strlen here to get the length of the string and use that as the char[x]?
  if (content != "") {

    // Echo back what the user typed
    Serial.println(content);
    
    // Begin parsing content
    
    //Are we controlling an outlet (channel+outletnumber+state or description)?
    //Parse first character of input - check if it's a valid channel ID:
    if ( (content[0] == 'A') || (content[0] == 'a') || (content[0] == 'B') || (content[0] == 'b') || (content[0] == 'C') || (content[0] == 'c') || (content[0] == 'D') || (content[0] == 'd') ) {
      //change to uppercase so the ascii/char math works easily
      content[0] = toupper(content[0]);   
      
        //Parse second character - check if it's a valid outlet ID:
        if ( (content[1] == '1') || (content[1] == '2') || (content[1] == '3') ) {
            
            // Convert outlet string to integer (should really be called "outlet" not "chan" 
            int chan = content[1] - '0';
            
            // Are we turning this on or off or setting a description?
            if (content[2] == '1' ) {
              outletON(content[0],chan);
              prompt();
            }
            else if (content[2]  == '0') {
              outletOFF(content[0],chan);
              prompt();
            }
            else if ( (content[2] == 'D') || (content[2] == 'd')) {
              //set description
              Serial.println();
              Serial.println();

              // Reassign to new char array for storage in outletStatus:
              // Parse content[4-18] - put into charDesc[0-15]
              // Extract the Description from the initial serial input - limit to 15 bytes
              
              char charDesc[15];
              for (int i = 4; i < 18; i++ ){
                  int j = (i-4);
                    charDesc[j]=content[i];
              }

              Serial.print("Setting description for "); Serial.print(content[0]);Serial.print(content[1]); 
              Serial.print(" to: "); 
              for (int i = 0; i < 15 ; i++ ){
                Serial.print(charDesc[i]);
              }
              Serial.println();
              // Determine location in the array to store the description
              outletStatus[getIndexFromChannelOutlet(content[0], chan)][3] = charDesc;
              prompt();
            }
        }
    }
    if (content == "save eeprom") {
      Serial.println("Saving Outlet states to EEPROM - Caution: Use sparingly.");
      //call eeprom save function
      prompt();
    }
    if (content == "show eeprom") {
      Serial.println("Current outlet status in eeprom:");
      //call read eeprom subroutine
      prompt();
    }
    if (content == "load eeprom") {
      Serial.println("Loads outlet states from eeprom and applies:");
      //call read eeprom subroutine and apply to current variable - then call write state.
      prompt();
    }
    if (content == "show") {
      show();
      prompt();
    }
    if (content == "help" || content == "?") {
      help();
      show();
      prompt();
    }
  } 
}

