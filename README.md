# Project_2
CPSC 334 Second Project Repo

This project focuses on Digital I/O, given a joystick, momentary button, and STDP switch

https://youtu.be/X_zdx3sej-k

Using those above listed items, two handles with buttons attached to them were linked directly to the ESP32, housed in the center of the device. The switches were also linked to the ESP32. The ESP32 was then mounted on top of a Raspberry Pi 3b+. A SuperCollider script running on the arduino took input from the ESP32 serially, translating each of the signals to values understandable to the arduino. Within SuperCollider, those values were then scaled to make sense for each parameter that they affected. 

One of the switches inside the unit functions as a "mute" or "off" switch for the instrument; the other switches the tonality of the instrument, almost enough that it could be considered a separate instrument entirely. 

When the "instrument" switch is in the primary position, its control scheme is as follows (all described from the perspective of the person playing each handle): 

Orange Handle             -> x & y: Overall Blend of 4 synths
Orange Handle With Button -> x: Low-Pass Filter     y: High-Pass Filter
Black Handle              -> x: Pitch               y: Volume
Black Handle With Button  -> x: Reverb              y: Phaser Rate

For the second instrument, the controls are: 

Orange Handle             -> x: Rate                y: Gain Size
Orange Handle With Button -> x: Low-Pass Filter     y: High-Pass Filter
Black Handle              -> x: Pitch               y: Volume
Black Handle With Button  -> x: Sub-bass frequency  y: Pitch Deviation

The proogram was written using the Arduino IDE and the SuperCollider IDE. The musical a
