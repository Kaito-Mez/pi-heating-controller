# pi-heating-controller
A webapp that allows the user to control the angle of a servo using the raspberry pi's gpio pins.


A flutter based app connects to flask eventlet backend. The flask program outputs signal to GPIO pins with runs through a DAC, converting it to an analog signal
which is passed as input to a servo motor. The servo reports it's position through another digital connection which is run through a ADC, converting it to
a digital signal which is read by GPIO ports. This data is used to display the cuttent position of the servo in the UI.

My application for this program is as a router for the central heating system of my home. The servo is connected to a vent duct damper and is capable of a
90 degree range of motion. This allows for the damper to completely open and close. As the servo is multipositional it can also be adjusted to any angle between 
0 and 90 allowing a variable amount of air through the vent.
