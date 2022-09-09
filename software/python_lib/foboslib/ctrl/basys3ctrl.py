#############################################################################
#                                                                           #
#   Copyright 2019 CERG                                                     #
#                                                                           #
#   Licensed under the Apache License, Version 2.0 (the "License");         #
#   you may not use this file except in compliance with the License.        #
#   You may obtain a copy of the License at                                 #
#                                                                           #
#       http://www.apache.org/licenses/LICENSE-2.0                          #
#                                                                           #
#   Unless required by applicable law or agreed to in writing, software     #
#   distributed under the License is distributed on an "AS IS" BASIS,       #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.#
#   See the License for the specific language governing permissions and     #
#   limitations under the License.                                          #
#                                                                           #
#############################################################################
# FOBOS Basys3 control board class
# Author: Abubakr Abdulgadir
# GMU
# Aug 7 2018
# This class hides the Control Board hardware and provides easy to use
# methods to configure and run operations on the DUT
# This class will interface to Digilent Basys3 board
# The board includes a Microblaze softcore
# This uses a protocol to talk to Basys3
# The connection used is a UART/USB'

import serial
import binascii
from foboslib.ctrl.fobosctrl import FOBOSCtrl
from foboslib.dummyserial import DummySerial
from foboslib.detectctrl import HardwareDetector


class Basys3Ctrl(FOBOSCtrl):
    """
    Class to wrap protocol to interface with Basys3 controller.
    """

    def __init__(self, port= None, baudRate=115200, dummy=False):
        """Init method
        Parameters:
        -----
        port : string
            The serial port where the Basys3 board is connected
            (e.g /dev/ttyUSB1).
        baudRate : int
            Baud rate. Default is 115200.
        dummy : boolean
            When set to true, no communication with Basys3 is done.
            This is to test the software only.
            Default is False.
        """
        self.magic = '22334455'
        self.baudRate = baudRate
        self.outLen = 0
        self.STATUS_LEN = 4
        self.timeToReset = 0
        # error codes
        self.OK = bytearray([0x00, 0x00, 0x00, 0x00])
        self.ERROR = bytearray([0x01, 0x00, 0x00, 0x00])
        self.TIMEOUT = bytearray([0x02, 0x00, 0x00, 0x00])
        if port is None:
            devFile = self.detectHardware()
        else:
            devFile = port
        # self.getMagicNumber()
        self.model = "Basys3"
        if dummy is True:
            self.ser = DummySerial()
        else:
            self.ser = serial.Serial(devFile, baudRate)


    def detectHardware(self):
        hd = HardwareDetector()
        devFiles = hd.findDevFiles('Digilent')
        #print(devFiles)
        #raw_input()
        for devFile in devFiles:
            status, magic = self.getMagicNumber(devFile)
            if status == self.OK and magic == self.magic:
                print("Detected fobos2 control board! Device file = {}".format(devFile))
                return devFile
        print("Could not detect fobos2 control board.")
        print("please connect the board to usb and make sure it is ready.")
        print("Exiting now ...")
        exit()

    def writeConfig(self, param, value):
        """
        param: the number of the config,
        value: a 32 bit value for the config parameter
        returs: ack code
        """
        """Write config parameter/command to ctrl board
        Parameters:
        -----
        param : int
            The number of the config parameter/command
        value: int
            The value of the parameter.
        Returns:
        -----
        string
        "00000000" OK
        "10000000" ERROR
        """
        #        WR_CONFIG       4 byte message   config number    config value
        cmd = bytearray([0xF0, 0x03] + [0x00, 0x06] +  [0x00, param] + [ (value & 0xFF000000) >> 24, (value & 0x00FF0000) >> 16, (value & 0x0000FF00) >> 8, value & 0x000000FF ])
        print (binascii.hexlify(cmd))
        self.ser.write(cmd)
        status = self.ser.read(self.STATUS_LEN)
        print ("Status= %s" % binascii.hexlify(status))
        return status

    def readConfig(self, param, devFile=None):
        """Reads config parameter from the fobos  control board.
        Parameters:
        -----
        param :
            The number of the config parameter/command
        Returns:
        -----
        string, string
        status
            "00000000" OK
            "10000000" ERROR
        value
            A string that represents 32 bit unsigned integer in hex format.
        """
        if devFile == None:
            ser = self.ser
        else:
            ser = serial.Serial(devFile, self.baudRate)
        #               RD_CONFIG       2 byte message   config number
        value = bytearray([0])
        cmd = bytearray([0xF0, 0x02] + [0x00, 0x02] + [0x00, param])
        print (binascii.hexlify(cmd))
        ser.write(cmd)
        status = ser.read(self.STATUS_LEN)
        if status == self.OK:
            print ("OK.    Status= %s" % binascii.hexlify(status))
            value = ser.read(FOBOSCtrl.PARAM_LEN)
        else:
            print ("ERROR. Status= %s" % binascii.hexlify(status))
        return status, value

    def processData(self, data, outLen):
        """
        Sends data to FOBOS hardware for processing, e.g. encryption
        Parameters:
        -----
        data: string
            The data to be processed. This is a hexadecimal string.
        Returns:
        -----
        status : string
            "00000000" OK
            "20000000" TIMOUT
        result : string
            The result from DUT (i.e. ciphertext)
        """
        result = bytearray([0])
        # hex: two characters = 1 byte
        vectorLen = len(data) / 2
        lenLsb = vectorLen % 256
        lenMsb = vectorLen / 256
        #               PROCESS_DATA    message len         data
        cmd = bytearray([0xF0, 0x01] + [lenMsb, lenLsb]) + bytearray.fromhex(data.strip())
        print (binascii.hexlify(cmd))
        self.ser.write(cmd)
        # Read status
        status = self.ser.read(self.STATUS_LEN)
        result2 = ''
        if status == self.OK and self.timeToReset == 0:
            print ("OK.    Status= %s" % binascii.hexlify(status))
            result = self.ser.read(outLen)
            result = binascii.hexlify(result)
            # get result in correct format
            for i in range(len(result)):
                if (i % 2 == 0 and i != 0):
                    result2 += ' '
                result2 += result[i]
        else:
            print ("TIMEOUT. Status= %s" % binascii.hexlify(status))
        return status, result2

    def getModel(self):
        """
        The model of the control board
        Returns:
        -----
        model: srting
            The model of the control board
        """
        return self.model
    
    def getMagicNumber(self, devFile=None):
        status, magic = self.readConfig(10, devFile)
        print(binascii.hexlify(magic))
        return status, binascii.hexlify(magic)

    def setOutLen(self, outLen):
        """
        set Expected Output Length (outLen)
        parameters:
        -----
        outLen : int
            The number of output bytes to be returned by the DUT
            (e.g 16 for AES-128)
        Returns: int
            Status
        """
        self.outLen = outLen
        return self.writeConfig(FOBOSCtrl.OUT_LEN, outLen)

    def setTriggerWait(self, trigWait):
        """
        set number of trigger wait cycles
        parameters:
        -----
        trigWait : int
            The number of DUT cycles after di_ready geos to 0
            to issue the trigger.
        Returns: int
            Status
        """
        return self.writeConfig(FOBOSCtrl.TRG_WAIT, trigWait)

    def setTriggerLen(self, trigLen):
        """
        set trigger length
        parameters:
        -----
        trigLen : int
            The number of DUT cycles to keep trigger set.
        Returns: int
            Status
        """
        return self.writeConfig(FOBOSCtrl.TRG_LEN, trigLen)

    def setTriggerMode(self, trigType):
        """
        set trigger mode
        parameters:
        -----
        trigType : int
            Possible values
            TRG_NORM      = 0
            TRG_FULL      = 1
            TRG_NORM_CLK  = 2
            TRG_FULL_CLK  = 3
        Returns: int
        -----
            Status
        """
        return self.writeConfig(FOBOSCtrl.TRG_MODE, trigType)

    def setTimeToReset(self, dutCycles):
        """
        set number of clock cycles after di_ready goes to 0
        to reset the DUT.
        parameters:
        -----
        dutCycles : int
            The number of DUT cycles to reset the DUT.
        Returns: int
        """
        self.timeToReset = dutCycles
        return self.writeConfig(FOBOSCtrl.TIME_TO_RST, dutCycles)

    def getTimeToReset(self):
        """
        get number of clock cycles after di_ready goes to 0
        to reset the DUT.
        Returns:
        -----
        int
            The number of clock cycle to reset DUT.
        """
        return self.timeToReset

    def setTimeout(self, seconds):
        """
        set number of seconds to stop waiting for DUT result.
        parameters:
        -----
        seconds : int
            Time in seconds. Range 1-40 seconds.
        Returns: int
        """
        self.timeout = seconds
        return self.writeConfig(FOBOSCtrl.TIMEOUT, seconds)

    def enableTestMode(self):
        """
        enable test mode. When this mode is enabled, the controller
        sends test-vectors to its internal dummy DUT.

        Returns:
        -----
        int
            Status
        """
        return self.writeConfig(FOBOSCtrl.SET_TEST_MODE, FOBOSCtrl.ENABLED)

    def disableTestMode(self):
        """
        Disable test mode. In this mode the ctrl board uses the real DUT.
        This is the default mode.

        Returns:
        -----
        int
            status
        """
        return self.writeConfig(FOBOSCtrl.SET_TEST_MODE, FOBOSCtrl.DISABLED)

    def forceReset(self):
        """
        Reset DUT

        Returns:
        -----
        int
            status
        """
        return self.writeConfig(FOBOSCtrl.FORCE_RST, 0)

    def releaseReset(self):
        """
        Release  DUT reset signal

        Returns:
        -----
        int
            status
        """
        return self.writeConfig(FOBOSCtrl.RELEASE_RST, 0)


    def setDUTClk(self, clkFreqMhz):
        """
        set DUT clock frequency generated by the control board.
        range is between 0.4 MHz - 100 MHz.
        parameters:
        -----
        clkFreqMhz : float
            The DUT clock frequency in Mhz
        Returns:
        -----
        int
            status
        """

        if clkFreqMhz > 100 or clkFreqMhz < 0.4:
            print("Error: DUT clock must be between 50MHz and 0.5MHz")
            print("Limit is because of PMOD connector and CLK wizard.")
            raise
        return self.writeConfig(FOBOSCtrl.SET_DUT_CLK, clkFreqMhz * 1000)

    def loadKey(self, key):
        """
        set the key value in the control board.
        parameters:
        -----
        key : string
            Key to send to ctrl board in hex format
        Returns:
        -----
        int
            status
        """
        return self.writeConfig(FOBOSCtrl.SET_KEY, Key)


    def loadData(self, data):
        pass

    def run():
        pass

    def getResult(self):
        pass

    def setPowerGlitchEnable(self, val):
        """
        set power glithcer enable bit.
        parameters:
        -----
        val : Integer
            1 = enable, 0 = disable
        Returns:
        -----
        int
            status
        """
        print("enable glitch")
        return self.writeConfig(FOBOSCtrl.POWER_GLITCH_ENABLE, val)

    
    def setPowerGlitchWait(self, waitCycles):
        """
        set the power glitcher wait cycles.
        parameters:
        -----
        waitCycles : int
            The cycles to wait before relasing the glicth pattern
        Returns:
        -----
        int
            status
        """
        print("set glitch wait")
        return self.writeConfig(FOBOSCtrl.POWER_GLITCH_WAIT, waitCycles)


    def setPowerGlitchPattern(self, pattern):
        """
        set the power glitch pattern reg
        parameters:
        -----
        pattern : string
            The pattern to set for glitch. The pattern is 64 bits written into 2 registers
        Returns:
        -----
        int
            status
        """
        print("pattern")
        pattern0 = int(pattern[8:16], 16) #lsb
        pattern1 = int(pattern[0:8], 16) #msb
        print('pattern=' + pattern)
        print('pattern0=' + str(pattern0))
        print(pattern[0:7])
        print('pattern1=' + str(pattern1))
        print(pattern[8:15])
        self.writeConfig(FOBOSCtrl.POWER_GLITCH_PATTERN0, pattern0)
        return self.writeConfig(FOBOSCtrl.POWER_GLITCH_PATTERN1, pattern1)

