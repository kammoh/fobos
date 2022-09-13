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

from contextlib import AbstractContextManager
from dataclasses import asdict, dataclass
import logging
import os
import pickle
import socket
from typing import Optional, Union
import numpy as np

from .fobosctrl import FOBOSCtrl, InterfaceType, TriggerType
from .hardware_mgr import HardwareManager

log = logging.getLogger(__name__)
log.setLevel(logging.DEBUG)

RCV_BYTES = 4096


class PYNQCtrlException(Exception):
    def __init__(self, *args: object) -> None:
        super().__init__(*args)


@dataclass
class PwMgrFlags:
    CHECK_OVERFLOW: bool = False
    STAT_SW_TRIG: bool = False
    STAT_HW_TRIG: bool = False
    SET_SW_TRIG: bool = False
    SET_HW_TRIG: bool = False
    CLEAR_SW_TRIG: bool = False
    CLEAR_HW_TRIG: bool = False
    RESET: bool = False
    CLEAR_MEASUREMENTS: bool = False
    CHECK_BUSY: bool = False
    GET_COUNT: bool = False
    SET_GAIN_VAR: bool = False
    SET_VAR_ON: bool = False
    SET_VAR_OFF: bool = False
    GET_GAIN_VAR: bool = False
    GET_VOLT_VAR: bool = False
    GET_CURR_VAR: bool = False
    MAX_VOLT_VAR: bool = False
    AVG_VOLT_VAR: bool = False
    MAX_CURR_VAR: bool = False
    AVG_CURR_VAR: bool = False
    SET_GAIN_5V: bool = False
    GET_GAIN_5V: bool = False
    GET_VOLT_5V: bool = False
    GET_CURR_5V: bool = False
    MAX_VOLT_5V: bool = False
    AVG_VOLT_5V: bool = False
    AVG_CURR_5V: bool = False
    MAX_CURR_5V: bool = False
    GET_GAIN_3V3: bool = False
    SET_GAIN_3V3: bool = False
    GET_VOLT_3V3: bool = False
    GET_CURR_3V3: bool = False
    MAX_VOLT_3V3: bool = False
    AVG_VOLT_3V3: bool = False
    AVG_CURR_3V3: bool = False
    SET_VAR_VOLT: bool = False

    def __str__(self) -> str:
        return "\n".join(
            [
                f"{k}\n" if isinstance(v, bool) else f"{k} = {v}\n"
                for k, v in asdict(self).items()
                if not isinstance(v, bool) or v
            ]
        )


@dataclass
class Config:
    ip: str = "localhost"
    port: int = 9995
    # File names and locations
    workspace: str = "fobosworkspace"  # Folder to store projects
    projectName: str = "xoodyak-dom-1st"  # Name of this project. Files will be in workspace/projectName/
    dinFile: Union[
        os.PathLike, str
    ] = "dinFile.txt"  # test vectors in FOBOS format incl. plaintext and key, auto-generated
    
    keyFile: str = ""
    plainFile: str = ""
    cipherSize: int = 0
    keySize: int = 0
    blockSize: int = 0

    fvrFile: Union[os.PathLike, str] = "fvrchoicefile.txt"  #
    cipherFile: Union[
        os.PathLike, str
    ] = "doutFile"  # observed output, result from applying test vectors
    traceFile: Union[
        os.PathLike, str
    ] = "powerTraces.npy"  # Name of file for recording power traces
    # Cipher Specific Information
    bitFile: Union[
        os.PathLike, str
    ] = "aes_cw305.bit"  # Bitstream for programming the DUT, same directory as this notebook
    outLen: int = 88  # size of a block of output in bytes
    # Acquistion configuration
    traceNum: int = 100  # number of traces to run
    samplingFreq: int = (
        50  # sampling frequency of the Oscilloscope in Msps [range: 1 - 100]
    )
    DUTClk: int = 10  # clock frequency of the DUT in MHz [range: 1 - 100]
    samplesPerTrace: int = 5 * 80  # number of ADC samples in one trace
    ADCGain: int = 40  # amplification of ADC input signal [range: 0 - 60]
    ADCHiLo: int = 1  # 0 - low amplification, 1 - high amplification
    # TRG_FULL: Trigger is active during DUT operation
    trigger_mode: TriggerType = TriggerType.TRG_FULL
    dut: int = FOBOSCtrl.CW305  # Adjust Target connector pinout for DUT
    dut_interface: InterfaceType = InterfaceType.INTERFACE_4BIT
    GET_DUT_CYCLES: bool = False
    pwmgr: PwMgrFlags = PwMgrFlags()

    def __str__(self) -> str:
        s = "# Acquisition parameters:\n"
        for k, v in asdict(self).items():
            if isinstance(v, PwMgrFlags):
                s += "\n".join(
                    [
                        "PWMGR_" + (k if isinstance(v, bool) else f"{k} = {v}")
                        for k, v in asdict(self).items()
                        if not isinstance(v, bool) or v
                    ]
                )
            else:
                s += f"{k} = {v}\n"
        return s


class PYNQCtrl(AbstractContextManager):
    """
    Class to wrap protocol to interface with PYNQ controller.
    """

    def __init__(self, config: Config):
        """Init method
        Parameters:
        -----
        config: PYNCCtrl configuration
        """
        # get hardware
        self.hm = HardwareManager()

        self.magic = "20200225"
        self.MSG_LEN_SIZE = 10
        self.STATUS_SIZE = 4
        self.OPCODE_SIZE = 4
        self.timeToReset = 0
        # error codes
        # self.OK = bytearray([0x00, 0x00, 0x00, 0x00])
        # self.ERROR = bytearray([0x01, 0x00, 0x00, 0x00])
        # self.TIMEOUT = bytearray([0x02, 0x00, 0x00, 0x00])
        self.model = "PYNQ-Z1"
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.settimeout(3.0)

        self.config: Config = config

    @property
    def config_str(self):
        return str(self.config)

    def __enter__(self) -> "PYNQCtrl":
        if self.hm.lock():
            log.info("Acquired hardware lock")
        else:
            raise PYNQCtrlException(
                "Hardware is in use by another user, please try again later."
            )
        host = self.config.ip
        port = self.config.port
        log.info("connecting to %s:%s", host, port)
        self.socket.connect((host, port))

        # Apply config to ctrl board ###########################################

        # Apply settings to the Pynq Board
        # setting DUT clock resets all modules using this clock
        self.setDUTClk(self.config.DUTClk)

        # Using Target connector -> INTERFACE_4BIT
        self.setDUTInterface(self.config.dut_interface)
        self.setDUT(self.config.dut)
        self.setTriggerMode(self.config.trigger_mode)

        self.setOutLen(self.config.outLen)
        self.setSamplingFrequency(self.config.samplingFreq)
        self.setSamplesPerTrace(self.config.samplesPerTrace)
        self.setADCGain(self.config.ADCGain)
        self.setADCHiLo(self.config.ADCHiLo)

        ## configure DUT PRNG
        # ctrl.setOutLen(4)
        #     seed = 0xaa11223344556677
        #     num_rand_words = 1000
        #     ctrl.confPrng(seed, num_rand_words)
        ##

        return self

    def __exit__(self, __exc_type, __exc_value, __traceback) -> Optional[bool]:
        self.disconnect()
        return None

    def detectHardware(self):
        pass

    def sendMsg(self, opcode, param: Union[None, int, str] = None):
        if param is None:
            param = ""  # ????
        pickled_param = pickle.dumps(param)
        msg: bytes = (
            bytes(
                f"{len(pickled_param) + self.OPCODE_SIZE :<{self.MSG_LEN_SIZE}}"
                + f"{opcode:<{self.OPCODE_SIZE}}",
                "utf-8",
            )
            + pickled_param
        )
        log.debug("[sendMsg] msg: %s", str(msg))
        self.socket.send(msg)

    def recvMsg(self):
        full_msg = bytearray()
        new_msg = True
        msg_len = -1
        while True:
            msg = self.socket.recv(RCV_BYTES)
            if len(msg) < self.MSG_LEN_SIZE:
                return 1, None
            if new_msg:
                # print(f'new msg size is {msg[:self.MSG_LEN_SIZE]}')
                msg_len = int(msg[: self.MSG_LEN_SIZE])
                new_msg = False
            full_msg += msg
            if len(full_msg) >= self.MSG_LEN_SIZE + msg_len:
                # print(full_msg[self.MSG_LEN_SIZE:])
                resp = full_msg[self.MSG_LEN_SIZE + self.STATUS_SIZE :]
                log.debug("[recvMsg] %s", str(bytes(resp)))
                response = pickle.loads(resp)
                return 0, response

    def processData(self, data, outLen):
        self.sendMsg(FOBOSCtrl.PROCESS, data)
        status, response = self.recvMsg()
        return status, response

    def processData2(self, data, outLen):
        self.sendMsg(FOBOSCtrl.PROCESS_GET_TRACE, data)
        status, response = self.recvMsg()
        # print(response)
        if response is not None:
            result, trace = response
            print(f"trace={trace}")
            trace = np.array(trace, dtype=np.uint16)
            # result = ""
            return status, result, trace
        return status, None, None

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
        # print(f'outlen={outLen}')
        self.config.outLen = outLen
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
        self.sendMsg(opcode=FOBOSCtrl.TRG_WAIT, param=trigWait)
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
        self.sendMsg(FOBOSCtrl.TRG_MODE, int(trigType))
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
        self.config.DUTClk = clkFreqMhz
        self.sendMsg(FOBOSCtrl.SET_DUT_CLK, clkFreqMhz * 1000)
        status, _ = self.recvMsg()
        return status

    # commented as there's no SET_KEY
    # def loadKey(self, key):
    #     """
    #     set the key value in the control board.
    #     parameters:
    #     -----
    #     key : string
    #         Key to send to ctrl board in hex format
    #     Returns:
    #     -----
    #     int
    #         status
    #     """
    #     self.sendMsg(FOBOSCtrl.SET_KEY, key)
    #     status, _ = self.recvMsg()
    #     return status

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
        pattern0 = int(pattern[8:16], 16)  # lsb
        pattern1 = int(pattern[0:8], 16)  # msb
        print("pattern=" + pattern)
        print("pattern0=" + str(pattern0))
        print(pattern[0:7])
        print("pattern1=" + str(pattern1))
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
        # release lock
        self.hm.unlock()
        return status, response

    def setDUTInterface(self, interface):
        self.sendMsg(FOBOSCtrl.SET_DUT_INTERFACE, int(interface))
        status, _ = self.recvMsg()
        return status

    def setDUT(self, dut):
        self.sendMsg(FOBOSCtrl.SET_DUT, dut)
        status, _ = self.recvMsg()
        return status

    def setSamplingFrequency(self, freq):
        freq = int(freq)
        if freq > 100 or freq < 1:
            raise ValueError(
                "Error: Sampling frequency must be an integer between 1 MHz and 100 MHz"
            )
        self.config.samplingFreq = freq
        self.sendMsg(FOBOSCtrl.SET_SAMPLING_FREQ, freq)
        status, _ = self.recvMsg()
        return status

    def setADCGain(self, gain):
        gain = int(gain)
        if gain > 78 or gain < 0:
            raise ValueError("Error: ADC gain must be an integer between 0 and 78")
        self.config.ADCGain = gain
        self.sendMsg(FOBOSCtrl.SET_ADC_GAIN, gain)
        status, _ = self.recvMsg()
        return status

    def setADCHiLo(self, hilo):
        hilo = int(hilo)
        if hilo > 1:
            raise ValueError("Error: ADC HiLo must be either '0' or '1'")
        self.config.ADCHiLo = hilo
        self.sendMsg(FOBOSCtrl.SET_ADC_HILO, hilo)
        status, _ = self.recvMsg()
        return status

    def setSamplesPerTrace(self, samplesPerTrace):
        if samplesPerTrace > 2**17 or samplesPerTrace < 0:
            raise ValueError("Error: SamplesPerTrace must be between 0 and 2**17")
        self.config.samplesPerTrace = samplesPerTrace
        self.sendMsg(FOBOSCtrl.SET_SAMPLES_PER_TRACE, samplesPerTrace)
        status, _ = self.recvMsg()
        return status

    def confPrng(self, seed, num_rand_words):
        # use 64-bit seed and number of 32-bit words to configure the dut prng
        seed_0 = seed & 0xFFFF
        seed = seed >> 16
        seed_1 = seed & 0xFFFF
        seed = seed >> 16
        seed_2 = seed & 0xFFFF
        seed = seed >> 16
        seed_3 = seed & 0xFFFF
        seed = seed >> 16
        cfg = "0082" + hex(num_rand_words)[2:].zfill(4)  # set conf_reg 2
        cfg += "0084" + hex(seed_0)[2:].zfill(4)  # set conf_reg 4
        cfg += "0085" + hex(seed_1)[2:].zfill(4)  # set conf_reg 5
        cfg += "0086" + hex(seed_2)[2:].zfill(4)  # set conf_reg 6
        cfg += "0087" + hex(seed_3)[2:].zfill(4)  # set conf_reg 7
        cfg += "00800002"  # gen_rand command
        print(cfg)
        self.sendMsg(FOBOSCtrl.SET_DUT, cfg)  ## ???
        status, response = self.recvMsg()
        print(response)

    def pwSetHwTrig(self, value):
        if value == 1:
            self.config.pwmgr.SET_HW_TRIG = True
            self.sendMsg(FOBOSCtrl.PWMGR_SET_HW_TRIG, "")
        else:
            self.config.pwmgr.CLEAR_HW_TRIG = True
            self.sendMsg(FOBOSCtrl.PWMGR_CLEAR_HW_TRIG, "")

        status, response = self.recvMsg()
        return status

    def pwSetSwTrig(self, value):
        if value == 1:
            self.config.pwmgr.SET_SW_TRIG = True
            self.sendMsg(FOBOSCtrl.PWMGR_SET_SW_TRIG, "")
        else:
            self.config.pwmgr.CLEAR_SW_TRIG = True
            self.sendMsg(FOBOSCtrl.PWMGR_CLEAR_SW_TRIG, "")

        status, response = self.recvMsg()
        return response

    def pwReset(self):
        self.config.pwmgr.RESET = True
        self.sendMsg(FOBOSCtrl.PWMGR_RESET, "")

        status, response = self.recvMsg()
        return status

    def pwClearMeasurements(self):
        self.config.pwmgr.CLEAR_MEASUREMENTS = True
        self.sendMsg(FOBOSCtrl.PWMGR_CLEAR_MEASUREMENTS, "")

        status, response = self.recvMsg()
        return status

    def pwCheckHwTrigStatus(self):
        self.config.pwmgr.STAT_HW_TRIG = True
        self.sendMsg(FOBOSCtrl.PWMGR_STAT_HW_TRIG, "")

        status, response = self.recvMsg()
        trigstat = int(response.split("=")[-1].replace(" ", ""))
        return trigstat

    def pwCheckSwTrigStatus(self):
        self.config.pwmgr.STAT_SW_TRIG = True
        self.sendMsg(FOBOSCtrl.PWMGR_STAT_SW_TRIG, "")

        status, response = self.recvMsg()
        trigstat = int(response.split("=")[-1].replace(" ", ""))
        return trigstat

    def pwCheckOverflow(self):
        self.config.pwmgr.CHECK_OVERFLOW = True
        self.sendMsg(FOBOSCtrl.PWMGR_CHECK_OVERFLOW, "")

        status, response = self.recvMsg()
        overflowstat = int(response.split("=")[-1].replace(" ", ""))
        return overflowstat

    def pwCheckBusy(self):
        self.config.pwmgr.CHECK_BUSY = True
        self.sendMsg(FOBOSCtrl.PWMGR_CHECK_BUSY, "")

        status, response = self.recvMsg()
        busy = int(response.split("=")[-1].replace(" ", ""))
        return busy

    def pwGetMeasCount(self):
        self.config.pwmgr.GET_COUNT = True
        self.sendMsg(FOBOSCtrl.PWMGR_GET_COUNT, "")

        status, response = self.recvMsg()
        curr = int(response.split("=")[-1].replace(" ", ""))
        return curr

    def getDutCycles(self):
        self.config.GET_DUT_CYCLES = True
        self.sendMsg(FOBOSCtrl.FOBOSCtrl_GET_DUT_CYCLES, "")

        status, response = self.recvMsg()
        curr = int(response.split("=")[-1].replace(" ", ""))
        return curr

    def pwSetGainVar(self, gain):
        valid_gain = [25, 50, 100, 200]
        if gain not in valid_gain:
            print("Invalid gain value, select from {}".format(valid_gain))
            return
        else:
            self.config.pwmgr.SET_GAIN_VAR = gain
            self.sendMsg(FOBOSCtrl.PWMGR_SET_GAIN_VAR, gain)
            status, _ = self.recvMsg()
            return status

    def pwSetVarOn(self):
        self.config.pwmgr.SET_VAR_ON = True
        self.sendMsg(FOBOSCtrl.PWMGR_SET_VAR_ON, "")

        status, response = self.recvMsg()
        return status

    def pwSetVarOff(self):
        self.config.pwmgr.SET_VAR_OFF = True
        self.sendMsg(FOBOSCtrl.PWMGR_SET_VAR_OFF, "")

        status, response = self.recvMsg()
        return status

    def pwGetGainVar(self):
        self.config.pwmgr.GET_GAIN_VAR = True
        self.sendMsg(FOBOSCtrl.PWMGR_GET_GAIN_VAR, "")

        status, response = self.recvMsg()
        gain = int(response.split("=")[-1].replace(" ", ""))
        return gain

    def pwGetVoltVar(self):
        self.config.pwmgr.GET_VOLT_VAR = True
        self.sendMsg(FOBOSCtrl.PWMGR_GET_VOLT_VAR, "")

        status, response = self.recvMsg()
        volt = float(response.split("=")[-1].replace(" ", ""))
        return volt

    def pwGetCurrVar(self):
        self.config.pwmgr.GET_CURR_VAR = True
        self.sendMsg(FOBOSCtrl.PWMGR_GET_CURR_VAR, "")

        status, response = self.recvMsg()
        curr = float(response.split("=")[-1].replace(" ", ""))
        return curr

    def pwGetMaxVoltVar(self):
        self.config.pwmgr.MAX_VOLT_VAR = True
        self.sendMsg(FOBOSCtrl.PWMGR_MAX_VOLT_VAR, "")

        status, response = self.recvMsg()
        volt = float(response.split("=")[-1].replace(" ", ""))
        return volt

    def pwGetAvgVoltVar(self):
        self.config.pwmgr.AVG_VOLT_VAR = True
        self.sendMsg(FOBOSCtrl.PWMGR_AVG_VOLT_VAR, "")

        status, response = self.recvMsg()
        volt = float(response.split("=")[-1].replace(" ", ""))
        return volt

    def pwGetMaxCurrVar(self):
        self.config.pwmgr.MAX_CURR_VAR = True
        self.sendMsg(FOBOSCtrl.PWMGR_MAX_CURR_VAR, "")

        status, response = self.recvMsg()
        curr = float(response.split("=")[-1].replace(" ", ""))
        return curr

    def pwGetAvgCurrVar(self):
        self.config.pwmgr.AVG_CURR_VAR = True
        self.sendMsg(FOBOSCtrl.PWMGR_AVG_CURR_VAR, "")

        status, response = self.recvMsg()
        curr = float(response.split("=")[-1].replace(" ", ""))
        return curr

    def pwSetGain5v(self, gain):
        valid_gain = [25, 50, 100, 200]
        if gain not in valid_gain:
            print("Invalid gain value, select from {}".format(valid_gain))
            return
        else:
            self.config.pwmgr.SET_GAIN_5V = gain
            self.sendMsg(FOBOSCtrl.PWMGR_SET_GAIN_5V, gain)
            status, _ = self.recvMsg()
        return status

    def pwGetGain5v(self):
        self.config.pwmgr.GET_GAIN_5V = True
        self.sendMsg(FOBOSCtrl.PWMGR_GET_GAIN_5V, "")

        status, response = self.recvMsg()
        gain = int(response.split("=")[-1].replace(" ", ""))
        return gain

    def pwGetVolt5v(self):
        self.config.pwmgr.GET_VOLT_5V = True
        self.sendMsg(FOBOSCtrl.PWMGR_GET_VOLT_5V, "")

        status, response = self.recvMsg()
        volt = float(response.split("=")[-1].replace(" ", ""))
        return volt

    def pwGetCurr5v(self):
        self.config.pwmgr.GET_CURR_5V = True
        self.sendMsg(FOBOSCtrl.PWMGR_GET_CURR_5V, "")

        status, response = self.recvMsg()
        curr = float(response.split("=")[-1].replace(" ", ""))
        return curr

    def pwGetMaxVolt5v(self):
        self.config.pwmgr.MAX_VOLT_5V = True
        self.sendMsg(FOBOSCtrl.PWMGR_MAX_VOLT_5V, "")

        status, response = self.recvMsg()
        volt = float(response.split("=")[-1].replace(" ", ""))
        return volt

    def pwGetAvgVolt5v(self):
        self.config.pwmgr.AVG_VOLT_5V = True
        self.sendMsg(FOBOSCtrl.PWMGR_AVG_VOLT_5V, "")

        status, response = self.recvMsg()
        volt = float(response.split("=")[-1].replace(" ", ""))
        return volt

    def pwGetMaxCurr5v(self):
        self.config.pwmgr.MAX_CURR_5V = True
        self.sendMsg(FOBOSCtrl.PWMGR_MAX_CURR_5V, "")

        status, response = self.recvMsg()
        curr = float(response.split("=")[-1].replace(" ", ""))
        return curr

    def pwGetAvgCurr5v(self):
        self.config.pwmgr.AVG_CURR_5V = True
        self.sendMsg(FOBOSCtrl.PWMGR_AVG_CURR_5V, "")

        status, response = self.recvMsg()
        curr = float(response.split("=")[-1].replace(" ", ""))
        return curr

    def pwSetGain3v3(self, gain):
        valid_gain = [25, 50, 100, 200]
        if gain not in valid_gain:
            print("Invalid gain value, select from {}".format(valid_gain))
            return
        else:
            self.config.pwmgr.SET_GAIN_3V3 = gain
            self.sendMsg(FOBOSCtrl.PWMGR_SET_GAIN_3V3, gain)
            status, _ = self.recvMsg()

    def pwGetGain3v3(self):
        self.config.pwmgr.GET_GAIN_3V3 = True
        self.sendMsg(FOBOSCtrl.PWMGR_GET_GAIN_3V3, "")

        status, response = self.recvMsg()
        gain = int(response.split("=")[-1].replace(" ", ""))
        return gain

    def pwGetVolt3v3(self):
        self.config.pwmgr.GET_VOLT_3V3 = True
        self.sendMsg(FOBOSCtrl.PWMGR_GET_VOLT_3V3, "")

        status, response = self.recvMsg()
        volt = float(response.split("=")[-1].replace(" ", ""))
        return volt

    def pwGetCurr3v3(self):
        self.config.pwmgr.GET_CURR_3V3 = True
        self.sendMsg(FOBOSCtrl.PWMGR_GET_CURR_3V3, "")

        status, response = self.recvMsg()
        curr = float(response.split("=")[-1].replace(" ", ""))
        return curr

    def pwGetMaxVolt3v3(self):
        self.config.pwmgr.MAX_VOLT_3V3 = True
        self.sendMsg(FOBOSCtrl.PWMGR_MAX_VOLT_3V3, "")

        status, response = self.recvMsg()
        volt = float(response.split("=")[-1].replace(" ", ""))
        return volt

    def pwGetAvgVolt3v3(self):
        self.config.pwmgr.AVG_VOLT_3V3 = True
        self.sendMsg(FOBOSCtrl.PWMGR_AVG_VOLT_3V3, "")

        status, response = self.recvMsg()
        volt = float(response.split("=")[-1].replace(" ", ""))
        return volt

    def pwGetMaxCurr3v3(self):
        self.config.pwmgr.MAX_CURR_5V = True
        self.sendMsg(FOBOSCtrl.PWMGR_MAX_CURR_5V, "")

        status, response = self.recvMsg()
        curr = float(response.split("=")[-1].replace(" ", ""))
        return curr

    def pwGetAvgCurr3v3(self):
        self.config.pwmgr.AVG_CURR_3V3 = True
        self.sendMsg(FOBOSCtrl.PWMGR_AVG_CURR_3V3, "")

        status, response = self.recvMsg()
        curr = float(response.split("=")[-1].replace(" ", ""))
        return curr

    def pwOutVarSet(self, volt):
        self.config.pwmgr.SET_VAR_VOLT = volt
        self.sendMsg(FOBOSCtrl.PWMGR_SET_VAR_VOLT, volt)
        status, _ = self.recvMsg()
        return status


def main():
    import time

    config = Config(ip="192.168.10.99", port=9995)

    ctrl = PYNQCtrl(config)
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


if __name__ == "__main__":
    main()
