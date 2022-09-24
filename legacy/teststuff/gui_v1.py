from gpiozero import Servo
from gpiozero import AngularServo
from time import sleep
import gpiozero
from tkinter import *

from gpioController import gpioController
cont = gpioController()

#servo = AngularServo(12, min_pulse_width = 0, max_pulse_width = 0.019999, min_angle=0, max_angle=90)

def set_angle():
    cont.set_target_angle(angle_slider.get())
    '''
    print(angle_slider.get())
    servo.angle = angle_slider.get()
    '''

master = Tk()

angle_slider = Scale(master, length = 600, tickinterval = 5, from_ = 0, to = 90, orient = HORIZONTAL)
angle_slider.set(0)
angle_slider.pack()

Button(master, text = 'Set', command = set_angle).pack()

mainloop()


#Frame width by default is 20ms (0.02s)
#Min pulse is 0 Max pulse is 20

