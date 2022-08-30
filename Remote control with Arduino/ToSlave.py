import RPi.GPIO as GPIO
from time import sleep

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)

class ToSlave():
    def __init__(self,In0,In1,In2,In3):
        self.In0 = In0
        self.In1 = In1
        self.In2 = In2
        self.In3 = In3
        GPIO.setup(self.In0,GPIO.OUT)
        GPIO.setup(self.In1,GPIO.OUT)
        GPIO.setup(self.In2,GPIO.OUT)
        GPIO.setup(self.In3,GPIO.OUT)

    def moveF(self):
        GPIO.output(self.In0,GPIO.LOW)
        GPIO.output(self.In1,GPIO.LOW)
        GPIO.output(self.In2,GPIO.LOW)    #decimal = 0
        GPIO.Output(self.In3,GPIO.LOW)
        print("Forward")

    ##########################################################

    def Stop(self):
        GPIO.output(self.In0,GPIO.HIGH)
        GPIO.output(self.In1,GPIO.LOW)
        GPIO.output(self.In2,GPIO.LOW)   #decimal = 1
        GPIO.Output(self.In3,GPIO.LOW)
        print("Stop")


    ###########################################################

    def moveR1(self):
        GPIO.output(self.In0,GPIO.LOW)
        GPIO.output(self.In1,GPIO.HIGH)
        GPIO.output(self.In2,GPIO.LOW)    #decimal = 2
        GPIO.Output(self.In3,GPIO.LOW)
        print("RIGHT1")


    ###################################
    def moveR2(self):
        GPIO.output(self.In0,GPIO.HIGH)
        GPIO.output(self.In1,GPIO.HIGH)
        GPIO.output(self.In2,GPIO.LOW)    #decimal = 3
        GPIO.Output(self.In3,GPIO.LOW)
        print("RIGHT2")
    ###################################

    def moveR3(self):
        GPIO.output(self.In0,GPIO.LOW)
        GPIO.output(self.In1,GPIO.LOW)
        GPIO.output(self.In2,GPIO.HIGH)    #decimal = 4
        GPIO.Output(self.In3,GPIO.LOW)
        print("RIGHT3")

    ##################################################################

    def moveL1(self):
        GPIO.output(self.In0,GPIO.HIGH)
        GPIO.output(self.In1,GPIO.LOW)
        GPIO.output(self.In2,GPIO.HIGH)    #decimal = 5
        GPIO.Output(self.In3,GPIO.LOW)
        print("LEFT1")
    #########################################
    def moveL2(self):
        GPIO.output(self.In0,GPIO.LOW)
        GPIO.output(self.In1,GPIO.HIGH)
        GPIO.output(self.In2,GPIO.HIGH)    #decimal = 6
        GPIO.Output(self.In3,GPIO.LOW)
        print("LEFT2")
    ########################################
    def moveL3(self):
        GPIO.output(self.In0,GPIO.HIGH)
        GPIO.output(self.In1,GPIO.HIGH)
        GPIO.output(self.In2,GPIO.HIGH)    #decimal = 7
        GPIO.Output(self.In3,GPIO.LOW)
        print("LEFT3")










