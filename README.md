rpilcd
======

Tool for writing text to lcd display connected to raspberrypi

Information obtained from: http://www.raspberrypi-spy.co.uk/2012/08/20x4-lcd-module-control-using-python/

20×4 LCD Module Control Using Python
Posted on August 9, 2012 by Matt

This article is based on my previous article 16×2 LCD Module Control Using Python and 16×2 LCD Module Control With Backlight Switch. 20×4 LCD modules are relatively easy and cheap to obtain. They have the same 16 pin interface as the 16×2 modules but still only require 6 GPIO pins on your Pi (an extra pin is required for the backlight switch).

These modules are compatible with the Hitachi HD44780 LCD controller. There are plenty available on eBay with a variety of backlight colours to choose from.
LCD Module Hardware

The pinout of the module is :

    Ground
    VCC (Usually +5V)
    Contrast adjustment (VO)
    Register Select (RS).
    RS=0: Command, RS=1: Data
    Read/Write (R/W).
    R/W=0: Write, R/W=1: Read
    Enable
    Bit 0 (Not required in 4-bit operation)
    Bit 1 (Not required in 4-bit operation)
    Bit 2 (Not required in 4-bit operation)
    Bit 3 (Not required in 4-bit operation)
    Bit 4
    Bit 5
    Bit 6
    Bit 7
    LED Backlight Anode (+)
    LED Backlight Cathode (-)

Usually the device requires 8 data lines to provide data to Bits 0-7. However this LCD can be configured to use a “4 bit” mode which allows you to send data in two chunks (or nibbles) of 4 bits. This reduces the number of GPIO connections you need when interfacing with your Pi.

Here is how I wired up my LCD :
LCD Pin 	Function 	Pi Function 	Pi Pin
01 	GND 	GND 	P1-06
02 	+5V 	+5V 	P1-02
03 	Contrast 		
04 	RS 	GPIO7 	P1-26
05 	RW 	GND 	P1-06
06 	E 	GPIO8 	P1-24
07 	Data 0 		
08 	Data 1 		
09 	Data 2 		
10 	Data 3 		
11 	Data 4 	GPIO25 	P1-22
12 	Data 5 	GPIO24 	P1-18
13 	Data 6 	GPIO23 	P1-16
14 	Data 7 	GPIO18 	P1-12
15 	+5V via 560 ohm 		
16 	GND 		P1-06

NOTE : The RW pin allows the device to be be put into read or write mode. I tied this pin to ground to prevent the module attempting to send data to the Pi as the Pi can not tolerate 5V inputs on its GPIO header.

Pin 3 : In order to control the contrast you can adjust the voltage presented to Pin 3. I used a 10K ohm trimmer to provide a variable voltage of 0-5V to Pin 3 which allows the contrast to be tweaked.

Pin 15 : This provides power to the backlight LED. In order to allow the backlight to be turned on and off I used a transistor (BC547, BC548 or equivalent) to switch this pin. This required an additional GPIO pin to switch the transistor but allowed my Python script to control the backlight.
Wiring Checks

Here are some sanity checks before you power up your circuit for the first time :

    Pin 1 (GND), 3 (Contrast), 5 (RW) and 16 (LED -) ( should be tied to ground.
    Pin 2 should be tied to 5V. Pin 15 should have a resistor inline to 5V to protect the backlight.
    Pin 7-10 are unconnected
    Pin 11-14 are connected to GPIO pins on the Pi

Python

The script below is based heavily on the code presented in my 16×2 LCD Module Control With Backlight Switch article. This allows the backlight to be switched on and off as well as some basic text justification.

As usual I am using the excellent RPi.GPIO library to provide access to the GPIO within Python.

The features of this setup include :

    10k variable resistor to adjust the contrast
    5k variable resistor to adjust the backlight brightness
    A transistor to allow the backlight to be switched on and off
    Left, centred and right justified text

The breadboard circuit looks like this :
Contrast Adjustment

Pin 3 is routed to Ground via a 10kohm trimming pot so that the display contrast can be adjusted.
Backlight Brightness and Switching

Pin 15/16 are in series with a 560 ohm and 2K ohm trimming pot via an NPN transitor which is activated by an additional GPIO connection. The LCD backlight is treated in exactly the same way I switch standard LEDs in my previous Control LED Using GPIO Output Pin article. Using a fixed resistance ensures the resistance can never be adjusted below 560 ohm which protects the backlight if you set the trimming pot to zero ohms. The base of the transistor is wired to an additional GPIO pin via a 27K ohm resistor.

