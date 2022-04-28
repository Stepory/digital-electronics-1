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

Write your text here.

<a name="top"></a>

## TOP module description and simulations

Write your text here.

<a name="video"></a>

## Video

Write your text here

<a name="references"></a>

## References

1. https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual?redirect=1
