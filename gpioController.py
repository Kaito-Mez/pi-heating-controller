from gpiozero import AngularServo, MCP3008
from time import sleep

OUTPUT_PIN = 12
INPUT_CHANNEL = 0

MIN_PULSE_WIDTH = 0
MAX_PULSE_WIDTH = 0.01927

MIN_ANGLE = 0
MAX_ANGLE = 90

class gpioController():
    '''Controls the output to the GPIO pins and reads input from GPIO pins'''


    def __init__(self):
        self.servo_output = AngularServo(
            pin = OUTPUT_PIN, 
            min_pulse_width = MIN_PULSE_WIDTH, 
            max_pulse_width = MAX_PULSE_WIDTH, 
            min_angle=MIN_ANGLE, 
            max_angle=MAX_ANGLE
            )

        # Channel represents which input the pot (servo output) is connected to (pin 0-7)
        self.servo_input = MCP3008(channel=INPUT_CHANNEL)

        # Keeps track of the servo's state
        self.servo_data = {'target':0, 'current':0}

        # Get current angle and set servo on init
        self.update_current_angle()
        self.set_target_angle(self.servo_data['target'])
    
    def set_target_angle(self, new_angle):
        '''Sets the angle that the servo should rotate to'''

        #print('changing angle to ' + str(new_angle))
        self.servo_output.angle = float(new_angle)
        self.servo_data['target'] = new_angle
    
    def get_current_angle(self) -> float:
        '''Returns the current angle of the servo'''

        # Angle of the servo is between 0 and 1
        # 0 is fully closed, 1 is fully open
        value = float(self.servo_input.value)
        # Convert to degrees
        cur_angle = (value * 90)
        
        return(cur_angle)
    

    def update_current_angle(self):
        '''Refreshes the current angle in self.servo_data'''
        self.servo_data['current'] = self.get_current_angle()



    '''Deprecated'''

    #DEPRECATED
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

    #DEPRECATED
    def close_monitor(self):
        self.monitoring = False
        print('stopping monitoring')
        return