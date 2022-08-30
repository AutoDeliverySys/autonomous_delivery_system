import KeyboardModule as kp
import ToSlave as TS
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)


kp.init()
ToSlave(2,3,4,17)

def main():
    if kp.getKey('UP'):
        moveF()
		
		
    elif kp.getKey('DOWN'):
        moveB()
		
    elif kp.getKey('LEFT'):
		moveL1()
		
    elif kp.getKey('RIGHT'):
	    moveR1()
		
    else:
	    Stop()
            

    

if __name__ == '__main__':
    while True:
        main()