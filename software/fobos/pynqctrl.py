#############################################################################
#                                                                           #
#   Copyright 2020 CERG                                                     #
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
# FOBOS PYNQ control board class
# Author: Abubakr Abdulgadir
# GMU
# Feb 25 2020
# This class hides the Control Board hardware and provides easy to use
# methods to configure and run operations on the DUT
# This class will interface to a PYNQ Z-1 board
# The board includes an ARM Cortex A9 processor
# This uses a protocol to talk to the PYNQ board
# The connection used is a gigabit ethernet connection

import socket
import pickle
import numpy as np
from sys import exit
from .fobosctrl import FOBOSCtrl
from .hardware_mgr import HardwareManager

RCV_BYTES = 512

class PYNQCtrl(FOBOSCtrl):
    """
    Class to wrap protocol to interface with PYNQ controller.
    """

    def __init__(self, ip, port= 9999):
        """Init method
        Parameters:
        -----
        ip   : string
            PYNQ ip address.
        port : int
            port where PYNQ server is listening.
        """
        # get hardware
        self.hm = HardwareManager()
        if self.hm.lock():
            print('Acquired hardware lock')
        else:
            print('Hardware is in use by another user, please try agian later. Exitting')
            exit()

        self.magic = '20200225'
        self.outLen = 0
        self.MSG_LEN_SIZE = 10
        self.STATUS_SIZE = 4
        self.OPCODE_SIZE = 4
        self.timeToReset = 0
        # error codes
        # self.OK = bytearray([0x00, 0x00, 0x00, 0x00])
        # self.ERROR = bytearray([0x01, 0x00, 0x00, 0x00])
        # self.TIMEOUT = bytearray([0x02, 0x00, 0x00, 0x00])
        self.model = "PYNQ-Z1"
        try:
            self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.socket.connect((ip, port))
        except Exception as  e:
            print(e)
            # release hw
            self.hm.unlock()

    def detectHardware(self):
        pass

    def sendMsg(self, opcode, param):
        try:
            ##send cmd
            param = pickle.dumps(param)
            msg = bytes(f'{len(param) + self.OPCODE_SIZE :<{self.MSG_LEN_SIZE}}' + f'{opcode:<{self.OPCODE_SIZE}}', 'utf-8') + param
            # print(msg)
            self.socket.send(msg)
        except Exception as e:
            print(e)
            print('Erorr encountered while sending message. Exitting.')
            exit()

    def recvMsg(self):
        # print('receiving..')
        full_msg = b''
        new_msg = True
        while True:
            try:
                msg = self.socket.recv(RCV_BYTES)
                if new_msg:
                    # print(f'new msg size is {msg[:self.MSG_LEN_SIZE]}')
                    msg_len = int(msg[:self.MSG_LEN_SIZE])
                    new_msg = False
                full_msg += msg
                if len(full_msg) - self.MSG_LEN_SIZE ==msg_len:
                    # print(full_msg[self.MSG_LEN_SIZE:])
                    response = pickle.loads(full_msg[self.MSG_LEN_SIZE + self.STATUS_SIZE:])
                    # response = full_msg[MSG_LEN_SIZE + STATUS_SIZE:]
                    # print(f'response = {response}')
                    status = 0
                    break
            except Exception as e:
                print(e)
                print('Error encountered while receiving message. Exiting.')
                exit()
        return status, response

    def processData(self, data, outLen):
        self.sendMsg(FOBOSCtrl.PROCESS, data)
        status, response = self.recvMsg()
        return status, response

    def processData2(self, data, outLen):
        self.sendMsg(FOBOSCtrl.PROCESS_GET_TRACE, data)
        status, response = self.recvMsg()
        # print(response)
        result, trace = response
        trace = np.array(trace, dtype=np.uint16)
        # result = ""
        return status, result, trace

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
        pass

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
        print(f'outlen={outLen}')
        self.sendMsg(opcode=FOBOSCtrl.OUT_LEN, param=outLen)
        status, _ = self.recvMsg()
        return status

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
        self.sendMsg(opcode=FOBOSCtrl.TRIG_WAIT, param=trigWait)
        status, _ = self.recvMsg()
        return status

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
        self.sendMsg(FOBOSCtrl.TRG_LEN, trigLen)
        status, _ = self.recvMsg()
        return status

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
        self.sendMsg(FOBOSCtrl.TRG_MODE, trigType)
        status, _ = self.recvMsg()
        return status

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
        self.sendMsg(FOBOSCtrl.TIME_TO_RST, dutCycles)
        status, _ = self.recvMsg()
        return status

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
        self.sendMsg(FOBOSCtrl.TIMEOUT, seconds)
        status, _ = self.recvMsg()
        return status

    def enableTestMode(self):
        """
        enable test mode. When this mode is enabled, the controller
        sends test-vectors to its internal dummy DUT.

        Returns:
        -----
        int
            Status
        """
        pass

    def disableTestMode(self):
        """
        Disable test mode. In this mode the ctrl board uses the real DUT.
        This is the default mode.

        Returns:
        -----
        int
            status
        """
        pass

    def forceReset(self):
        """
        Reset DUT

        Returns:
        -----
        int
            status
        """
        self.sendMsg(FOBOSCtrl.FORCE_RST, 0)
        status, _ = self.recvMsg()
        return status

    def releaseReset(self):
        """
        Release  DUT reset signal

        Returns:
        -----
        int
            status
        """
        self.sendMsg(FOBOSCtrl.RELEASE_RST, 0)
        status, _ = self.recvMsg()
        return status


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
        # clkFreqMhz = int(clkFreqMhz)
        if clkFreqMhz > 100 or clkFreqMhz < 0.4:
            # print("Error: DUT clock must be between 100MHz and 0.4MHz")
            raise ValueError("Error: DUT clock must be between 0.4 MHz and 100 MHz")
        self.sendMsg(FOBOSCtrl.SET_DUT_CLK, clkFreqMhz * 1000)
        status, _ = self.recvMsg()
        return status
        



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
        self.sendMsg(FOBOSCtrl.SET_KEY, key)
        status, _ = self.recvMsg()
        return status


    def loadData(self, data):
        pass

    def run(self):
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
        self.sendMsg(FOBOSCtrl.POWER_GLITCH_ENABLE, val)
        status, _ = self.recvMsg()
        return status

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
        # print("set glitch wait")
        self.sendMsg(FOBOSCtrl.POWER_GLITCH_WAIT, waitCycles)
        status, _ = self.recvMsg()
        return status


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
        self.sendMsg(FOBOSCtrl.POWER_GLITCH_PATTERN0, pattern0)
        self.sendMsg(FOBOSCtrl.POWER_GLITCH_PATTERN1, pattern1)
        status, _ = self.recvMsg()
        return status

    def disconnect(self):
        self.sendMsg(FOBOSCtrl.DISCONNECT, "")
        status, response = self.recvMsg()
        # print(response)
        self.socket.close()
        #release lock
        self.hm.unlock()
        return status, response

    def setDUTInterface(self, interface):
        self.sendMsg(FOBOSCtrl.SET_DUT_INTERFACE, interface)
        status, _ = self.recvMsg()
        return status

    def setSamplingFrequency(self, freq):
        freq = int(freq)
        if freq > 100 or freq < 1:
            raise ValueError("Error: Sampling frequency must be an integer between 1 MHz and 100 MHz")
        self.sendMsg(FOBOSCtrl.SET_SAMPLING_FREQ, freq)
        status, _ = self.recvMsg()
        return status

    def setADCGain(self, gain):
        gain = int(gain)
        if gain > 78 or gain < 0:
            raise ValueError("Error: ADC gain must be an integer between 0 and 78")
        self.sendMsg(FOBOSCtrl.SET_ADC_GAIN, gain)
        status, _ = self.recvMsg()
        return status

    def setSamplesPerTrace(self, samplesPerTrace):
        if samplesPerTrace > 2**17  or samplesPerTrace < 0:
            raise ValueError("Error: SamplesPerTrace must be between 0 and 2**17")
        self.sendMsg(FOBOSCtrl.SET_SAMPLES_PER_TRACE, samplesPerTrace)
        status, _ = self.recvMsg()
        return status



def main():
    import time
    ctrl = PYNQCtrl('192.168.10.99', 9995)
    status = ctrl.setTriggerWait(5)
    print(status)
    time.sleep(3)
    status = ctrl.setTriggerLen(6)
    print(status)
    status = ctrl.setTimeToReset(10)
    print(status)
    status = ctrl.setPowerGlitchWait(5)
    print(status)
    # data = [1,2,3]
    # status, resp = ctrl.processData(data, 10)
    # print(status)
    # print(resp)
    ctrl.disconnect()
if __name__=='__main__':
    main()