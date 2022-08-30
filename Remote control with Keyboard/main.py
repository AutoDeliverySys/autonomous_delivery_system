import KeyboardModule as kp
from MotorModule import Motor
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)

motor= Motor(2,3,4,17,22,27)

kp.init()

def main():
    if kp.getKey('UP'):
        motor.move(0.6,0,0.1)
		
		
    elif kp.getKey('DOWN'):
        motor.move(-0.6,0,0.1)
		
    elif kp.getKey('LEFT'):
        motor.move(0.5,0.4,0.1)
		
    elif kp.getKey('RIGHT'):
	
        motor.move(0.5,-0.4,0.1)
		
    else:
            
        motor.stop(0.1)

    #motor.move(0.6,0,2)
    #motor.stop(2)
    #motor.move(-0.5,0.2,2)
    #motor.stop(2)*/

if __name__ == '__main__':
    while True:
        main()