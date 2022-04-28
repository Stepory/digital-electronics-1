# DIGITAL CLOCK

### Team members

* Member 1 (responsible for xxx)
* Member 2 (responsible for xxx)
* Member 3 (responsible for xxx)
* ...

### Table of contents

* [Project objectives](#objectives)
* [Hardware description](#hardware)
* [VHDL modules description and simulations](#modules)
* [TOP module description and simulations](#top)
* [Video](#video)
* [References](#references)

<a name="objectives"></a>

## Project objectives

* Displaying the alarm clock on board Nexys A7.
* Detecting inputs (alarm and reset) from the user.
* Setting the alarm time from the input.
* An audible warning when an alarm operation occurs.

## Hardware description

The Nexys A7 card can be powered from the Digilent USB-JTAG port (J6) or from an external power source. Jumper JP3 (next to the power jack) determines which source is used. The Nexys A7 board includes two four-digit common anode seven-segment LED displays configured to act as a single eight-digit display. Each of the eight digits consists of seven segments arranged in a “figure 8” pattern with an LED embedded in each segment. Segment LEDs can be illuminated individually. Any of the 128 models can be displayed on a figure by illuminating the LED segments and leaving the others dark.
A scan screen control circuit can be used to display an eight-digit number on the board. If the update or "refresh" rate is reduced to about 45 Hz, a flicker may be noticeable on the board.

## VHDL modules description and simulations

The Clock.vhd module is the clock itself. It changes the 6 digits H1, H2, M1, M2, S1, S2, which are the hours, tens of hours, minutes, tens of minutes, seconds and tens of seconds accordingly . In order to achieve that we are using the clk signal and if statements. Digits are shown using the integrated 7-segment displays of the Nexys A7 board.
In the alarm.vhd module we are using the integrated buttons on the given board. The position of the digit, which we are changing is changed with buttons BTNL for left and BTNR for right. The actual digit is changed with buttons BTNU for +1 and BTND for -1. We also have an accord LED of the board light up to indicate the position of the digit, which we are changing. For the alarm we only use hours and minutes, since using seconds seems redundant.
The alarmcompare.vhd compares the time of the clock with the time set by the alarm. When clock time is the same as the time set by the alarm it changes the color of the RGB LED from red to blue.
Dposition.vhd is used for the BTNL and BTNR buttons to actually change a position, which is saved in a variable pst.
setClock.vhd is used to change the current time of the clock. By using the same buttons as we used for the alarm we change the time. We specify that we are changing the time of clock by flipping the switch SW[0]. For setting time we only use hours and minutes, since using seconds seems redundant.
We also use a few of the modules from professor's Fryza GitHub depository, clock_enable, driver_7seg_6digits, cnt_up_down. They've helped us all of the previously mentioned modules to work.


<a name="top"></a>

## TOP module description and simulations

cnt_up_down and driver_7seg_6digits are used to run the 6 7-segment displays. Data, or in our case time, is sent to the displays through the Clock.vhd. Clock.vhd uses clock_enable to get a signal, which is observable by human eye and it also has the setClock.vhd connected to it. setClock.vhd uses the Dposition.vhd so that we can change the digits and we also use clock_enable.vhd so that the buttons would be usable by humans. Dposition is also used in the alarm.vhd for the same purpose as in the setClock.vhd. From the alarm.vhd we send 4 LED signals, which indicate the position, and the set alarm times to the alarmcompare.vhd. This modules also gets the current time from Clock.vhd, so it can compare the times and send out the alarm signal in the from of an RGB LED.

<a name="video"></a>

## Video

Write your text here

<a name="references"></a>

## References

1. https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual?redirect=1
