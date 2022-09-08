from gpiozero import AngularServo, MCP3008
from time import sleep
import json
import asyncio

class gpioController():
    def __init__(self):
        self.servo = AngularServo(12, min_pulse_width = 0, max_pulse_width = 0.01927, min_angle=0, max_angle=90)
        #channel represents which input the pot (servo output) is connected to (pin 0-7)
        self.servo_input = MCP3008(channel=0)


        self.servo_data = {'target':0, 'current':0}

        self.update_current_angle()

        try:
            self.servo.angle = float(self.servo_data['target'])
        except:
            self.servo.angle = 0
            print('JSON SYSTEM IS BROKEN')
    
    def change_target(self, new_angle):
        print('changing angle to ' + str(new_angle))
        self.servo.angle = float(new_angle)
        self.servo_data['target'] = new_angle
    
    def get_current_angle(self):
        #use this if value is between -1 and 1
        '''inter = float(self.servo_input.value) + 1
        cur_angle = round(inter * 45)'''

        #if value is 0 to 1
        inter = float(self.servo_input.value)
        cur_angle = (inter * 90)
        print(self.servo_input.value)
        
        return(cur_angle)
    
    def update_current_angle(self):
        self.servo_data['current'] = self.get_current_angle()

    #dont use
    def monitor_angle(self):
        cur_angle = self.get_current_angle()
        self.monitoring = True
        i = 0
        while self.monitoring:
            if cur_angle != self.get_current_angle():
                self.update_current_angle()
                cur_angle = self.get_current_angle()
                print('Current angle changed to ' + str(cur_angle))
            elif cur_angle == self.get_current_angle():
                print(str(i) + ' didnt change cur angle is ' + str(cur_angle))
                i+=1
                sleep(0.5)
            else:
                print('ERROR IN MONITOR ANGLE METHOD')
        print("stopped monitoring")
        return
    #dont use
    def close_monitor(self):
        self.monitoring = False
        print('stopping monitoring')
        return
        

'''
cont = gpioController()
cont.change_angle(50)
print('done')
'''