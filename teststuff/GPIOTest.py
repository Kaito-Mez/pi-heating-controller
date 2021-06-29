from gpiozero import Servo
from gpiozero import AngularServo
from time import sleep
import gpiozero

#Frame width by default is 20ms (0.02s)
#Min pulse is 0 Max pulse is 20

servo = AngularServo(12, min_pulse_width = 0, max_pulse_width =0.019999, min_angle=0, max_angle=90)
print(1)

angle = 90
servo.angle = angle

while True:
    if angle < 90:
        angle += 1
        servo.angle = angle
        print(angle)
        sleep(0.5)
    elif angle == 90:
        angle = 0
        servo.angle = angle
        print(angle)
        sleep(0.5)


'''while True:
    servo.value = 1
    print('max')
    sleep(5)
    servo.value = 0
    print('mid')
    sleep(3)
    servo.value = -1
    print('min')
    sleep(5)'''


