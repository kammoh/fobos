import socket
import time
import pickle
from pathlib import Path
import numpy as np
from pynq import Overlay
import os
#from pynq import Xlnk
from pynq import allocate
from foboslib.ctrl.fobosctrl import FOBOSCtrl
from foboslib.pynqlocal import PYNQCtrl
from foboslib.scope import openadc
from foboslib.power import PowerManager
#import numpy as np
MSG_LEN_SIZE = 10
OPCODE_SIZE = 4
STATUS_SIZE = 4
DONE_CMD = 9999
RCV_BYTES = 512
IP = '192.168.2.99'
PORT = 9995
OVERLAY_FILE = "/home/xilinx/fobos/software/pynq_ctrl.bit"
SOCKET_TIMEOUT = 2 * 60
##change these settings. they must be dynamic
TV_SIZE = 48
OUTPUT_SIZE = 16

OUT_LEN         = 16 # default aes-128 output in byes
TRACE_NUM       = 10
SAMPLING_FREQ   = 10
DUT_CLK         = 1
SAMPLE_NUM      = 1000
ADC_GAIN        = 20
ADC_HILO        = 22
TV_SIZE         = 48 #108
OUTPUT_SIZE     = 16 #44
STATUS_FILE = "/tmp/fobos_status.txt"
##end 
class server():
    def __init__(self, ip, port):
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.bind((ip, port))
        self.socket.listen(5)
        self.interface = FOBOSCtrl.INTERFACE_4BIT

    def init(self):
        # instantiate hardware driver
        #my_env = os.environ.copy()
        #os.environ["XILINX_XRT"] = "/usr"
        overlay = Overlay(OVERLAY_FILE)
        self.ctrl = PYNQCtrl(overlay)
        self.fobosAcq = openadc.OpenADCScope(overlay)
        self.powerManager = PowerManager(overlay)
        # self.fobosAcq.setAdcClockFreq(SAMPLING_FREQ)
        # self.fobosAcq.setGain(ADC_GAIN)
        self.samplesPerTrace = 1000
        #self.xlnk = Xlnk()
        #self.outputBuffer = self.xlnk.cma_array(shape=(int(self.samplesPerTrace / 4 + 2),), dtype=np.uint64)
        self.outputBuffer = allocate(shape=(int(self.samplesPerTrace / 4 + 2),), dtype=np.uint64)
        #Configure defaults
        self.ctrl.setDUTClk(DUT_CLK)
        self.ctrl.setOutLen(OUT_LEN)
        self.ctrl.setTriggerMode(FOBOSCtrl.TRG_FULL)
        self.ctrl.setDUTInterface(self.interface)
        self.ctrl.forceReset()
        self.ctrl.releaseReset()
        print("init complete")
    
    def sendResponse(self, status, response):
        ##send cmd
        #msg = f'{len(msg) + OPCODE_SIZE :<{MSG_LEN_SIZE}}' + f'{opcode:<{OPCODE_SIZE}}' + msg
        # response = bytes(f'{len(response):<{MSG_LEN_SIZE}}', 'utf-8') + response
        # print(f"len response = {len(response)}")
        msg = bytes(f'{len(response) + STATUS_SIZE :<{MSG_LEN_SIZE}}' + f'{status:<{STATUS_SIZE}}', 'utf-8') +response
        # print(response)
        try:
            self.clt.send(msg)
            status = 0
        except:
            print("error sending message")
            self.clt.close()
            status = -1
        return status

    def recvMsg(self):
        # print('receiving..')
        full_msg = b''
        new_msg = True
        while True:
            msg = self.clt.recv(RCV_BYTES)
            if new_msg:
                # print(f'new msg size is {msg[:MSG_LEN_SIZE]}')
                try:
                    msg_len = int(msg[:MSG_LEN_SIZE])
                    new_msg = False
                except:
                    print("Illegal message size")
                    opcode = -1
                    param = ""
                    return opcode, param
            full_msg += msg
            if len(full_msg) - MSG_LEN_SIZE ==msg_len:
                try:
                    # a = full_msg[MSG_LEN_SIZE:]
                    opcode = full_msg[MSG_LEN_SIZE : MSG_LEN_SIZE + STATUS_SIZE]
                    param = pickle.loads(full_msg[MSG_LEN_SIZE + STATUS_SIZE:])
                    break
                except:
                    print("Error with message opcode or paramter")
                    opcode  = -1
                    param = ""
                    return opcode, param

        return opcode, param
    
    def acceptConnection(self):
        self.socket.settimeout(SOCKET_TIMEOUT)
        while True:
            try:
                print("PYNQ server ready. Waiting for connection ...")
                self.clt, addr = self.socket.accept()
                print(f'addr = {addr}=============')
                break
            except:
                print('socket accept timeout')
                self.touchStatusFile()
                print('touching status file.')


    def run(self):
        while True:
            print("PYNQ server ready. Waiting for connection ...")
#            self.clt, addr = self.socket.accept()
            #print(f'addr = {addr}=============')
            #self.touchStatusFile()
            #print("status file updated")
            self.acceptConnection()
            #print('connection accepted')
            self.init()

            while True:
                opcode, param = self.recvMsg()
                self.touchStatusFile()
                print(f'msg received : opcode={opcode}, param = {param}')
                #time.sleep(1)
                if int(opcode) == FOBOSCtrl.DISCONNECT:
                    self.fobosAcq.setGain(0) #clear ADC gain
                    self.sendResponse(0, pickle.dumps("Disconnect requested. Bye!"))
                    print('Done. Closing connection ...')
                    self.clt.close()
                    break
                elif int(opcode) == -1:
                    # self.sendResponse(0, pickle.dumps("Illegal message. Bye!"))
                    print('Illegal message. Closing connection ...')
                    self.clt.close()
                    break
                # tic = time.time()
                status, response = self.doOperation(int(opcode), param)
                # toc = time.time()
                # print(f'do op time = {toc-tic}')
                if status == -1:
                    # self.sendResponse(0, pickle.dumps("Operation error. Bye!"))
                    self.clt.close()
                    break
                else:
                    # print(f'sending response: status:')
                    status = self.sendResponse(0, pickle.dumps(response))
                    if status == -1:
                        break

    def touchStatusFile(self):
        Path(STATUS_FILE).touch()


    def doOperation(self, opcode, param):
        try:
        # if True:
            if opcode == FOBOSCtrl.PROCESS:
                print("process")
                result = self.ctrl.processData(param)
                response = result
            elif opcode == FOBOSCtrl.PROCESS_GET_TRACE:
                # print("get trace")
                self.fobosAcq.arm(self.outputBuffer,int(self.samplesPerTrace/4))
                # print(param)
                result = self.ctrl.processData(param)
                # print(result)
                self.fobosAcq.waitForTrace()
                trace = self.outputBuffer.view('uint16').tolist()
                response = (result, trace[:self.samplesPerTrace],)
                # print(response)

            elif opcode == FOBOSCtrl.OUT_LEN:
                print("FOBOSCtrl.OUT_LEN")
                self.ctrl.setOutLen(param)
                print(param)
                print(type(param))
                response = f"Set output len = {param}"
            
            elif opcode == FOBOSCtrl.TRG_MODE:
                print("FOBOSCtrl.TRIG_WAIT")
                self.ctrl.setTriggerMode(param)
                response = f"Set trigger mode = {param}"
            
            elif opcode == FOBOSCtrl.TRG_WAIT:
                print("FOBOSCtrl.TRIG_WAIT")
                self.ctrl.setTriggerWait(param)
                response = f"Set trigger wait = {param}"
                
            elif opcode == FOBOSCtrl.TRG_LEN:
                print("FOBOSCtrl.TRIG_LEN")
                self.ctrl.setTriggerLen(param)
                response = f"Set trigger len = {param}"

            elif opcode == FOBOSCtrl.TIMEOUT:
                print("FOBOSCtrl.TIMEOUT")
                #
                response = "Not implemented"
            
            elif opcode == FOBOSCtrl.TIME_TO_RST:
                print("FOBOSCtrl.TIME_TO_RST")
                #do
                response = "Not implemented"

            elif opcode == FOBOSCtrl.FORCE_RST:
                print("FOBOSCtrl.FORCE_RST")
                self.ctrl.forceReset()
                response = "Reset asserted"

            elif opcode == FOBOSCtrl.RELEASE_RST:
                print("FOBOSCtrl.RELEASE_RST")
                self.ctrl.releaseReset()
                response = "Reset released"

            elif opcode == FOBOSCtrl.SET_DUT_CLK:
                #WARNING: Setting DUT clock resets every module that uses this clock
                #MUST reconfigure all devices or do it first
                print("FOBOSCtrl.SET_DUT_CLK")
                print(param)
                self.ctrl.setDUTClk(param/1000)
                response = f"Set DUT CLK = {param}"
                # DEFAULTS
                self.ctrl.setOutLen(OUT_LEN)
                self.ctrl.setTriggerMode(FOBOSCtrl.TRG_FULL)
                self.ctrl.setDUTInterface(self.interface)
                self.ctrl.forceReset()
                self.ctrl.releaseReset()

            # elif opcode == FOBOSCtrl.SET_KEY:
            #     print("FOBOSCtrl.SET_KEY")
            #     #
            #     response = "Not implemented"

            elif opcode == FOBOSCtrl.POWER_GLITCH_ENABLE:
                print("FOBOSCtrl.POWER_GLITCH_ENABLE")
                #do
                response = "Not implemented"

            elif opcode == FOBOSCtrl.POWER_GLITCH_WAIT:
                print("FOBOSCtrl.POWER_GLITCH_WAIT")
                #do
                response = " power glitch wait done"

            elif opcode == FOBOSCtrl.POWER_GLITCH_PATTERN0:
                print("FOBOSCtrl.POWER_GLITCH_PATTERN0")
                #do
                response = "Not implemented"

            elif opcode == FOBOSCtrl.POWER_GLITCH_PATTERN1:
                print("FOBOSCtrl.POWER_GLITCH_PATTERN1")
                #do
                response = "Not implemented"
            
            elif opcode == FOBOSCtrl.SET_DUT_INTERFACE:
                self.ctrl.setDUTInterface(param)
                self.interface = param
                response = f"Set dut interface = {param}"
                print(f"Set dut interface = {param}")

            elif opcode == FOBOSCtrl.SET_DUT:
                self.ctrl.setDUT(param)
                self.dut = param
                response = f"Set dut = {param}"
                print(f"Set dut = {param}")

            elif opcode == FOBOSCtrl.SET_SAMPLING_FREQ:
                response = f"Set sampling frequency = {param}"
                print(response)
                self.fobosAcq.setAdcClockFreq(param)

            elif opcode == FOBOSCtrl.SET_ADC_GAIN:
                response = f"Set ADC gain  = {param}"
                print(response)
                self.fobosAcq.setGain(param)

            elif opcode == FOBOSCtrl.SET_ADC_HILO:
                response = f"Set ADC HiLo  = {param}"
                print(response)
                self.fobosAcq.setHiLo(param)

            elif opcode == FOBOSCtrl.SET_SAMPLES_PER_TRACE:
                response = f"samples per trace  = {param}"
                print("param:", param)
                print(response)
                self.samplesPerTrace =param
                self.outputBuffer.freebuffer()
                self.outputBuffer = allocate(shape=(int(self.samplesPerTrace / 4 + 2),), dtype=np.uint64)
            elif opcode == FOBOSCtrl.PWMGR_SET_GAIN_VAR:
                response = f"Set var gain  = {param}"
                print(response)
                self.powerManager.GainVarSet(param)
            elif opcode == FOBOSCtrl.PWMGR_GET_GAIN_VAR:
                gain = self.powerManager.GainVarGet()
                response = f"Get var gain = {gain}"
            elif opcode == FOBOSCtrl.PWMGR_GET_VOLT_VAR:
                volt = self.powerManager.MeasVoltVar()
                response = f"Get var gain = {volt}"
            elif opcode == FOBOSCtrl.PWMGR_GET_CURR_VAR:
                curr = self.powerManager.MeasCurrVar()
                response = f"Get var gain = {curr}"
            
            elif opcode == FOBOSCtrl.PWMGR_SET_HW_TRIG:
                self.powerManager.TrigHwEnOn()
                response = f'Set hardware trig enabled'
            elif opcode == FOBOSCtrl.PWMGR_CLEAR_HW_TRIG:
                self.powerManager.TrigHwEnOff()
                response = f'Set hardware trig disabled'            
            elif opcode == FOBOSCtrl.PWMGR_SET_SW_TRIG:       
                self.powerManager.TrigSwEnOn()
                response = f'Set software trig enabled'
            elif opcode == FOBOSCtrl.PWMGR_CLEAR_SW_TRIG:
                self.powerManager.TrigSwEnOff()
                response = f'Set software trig disabled'
            elif opcode == FOBOSCtrl.PWMGR_RESET:
                self.powerManager.Reset()
                response = f'Power manager reset'    
            elif opcode == FOBOSCtrl.PWMGR_CLEAR_MEASUREMENTS:
                self.powerManager.MeasClear()
                response = f'Measurement registers cleared'
            elif opcode == FOBOSCtrl.PWMGR_STAT_HW_TRIG:
                stat = self.powerManager.TrigHwStat()
                response = f"Get var gain = {stat}"
            elif opcode == FOBOSCtrl.PWMGR_GET_COUNT:
                count = self.powerManager.MeasCountValue()
                response = f"Get measure count = {count}"
            elif opcode == FOBOSCtrl.PWMGR_CHECK_OVERFLOW:
                overflow = self.powerManager.MeasCountOverflow()
                response = f"Get var gain = {overflow}"
            elif opcode == FOBOSCtrl.PWMGR_CHECK_BUSY:
                busy = self.powerManager.MeasBusy()
                response = f"Get var gain = {busy}"
            elif opcode == FOBOSCtrl.PWMGR_MAX_VOLT_VAR:
                volt = self.powerManager.MeasMaxVoltVar()
                response = f"Get var gain = {volt}"
            elif opcode == FOBOSCtrl.PWMGR_AVG_VOLT_VAR:
                volt = self.powerManager.MeasAvgVoltVar()
                response = f"Get var gain = {volt}"
            elif opcode == FOBOSCtrl.PWMGR_MAX_CURR_VAR:
                curr = self.powerManager.MeasMaxCurrVar()
                response = f"Get var gain = {curr}"
            elif opcode == FOBOSCtrl.PWMGR_AVG_CURR_VAR:
                curr = self.powerManager.MeasAvgCurrVar()
                response = f"Get var gain = {curr}"
            elif opcode == FOBOSCtrl.PWMGR_GET_DUT_CYCLES:
                cc = self.ctrl.getWorkCount()
                response = f"Get work count = {cc}"
            ### Untested:
            elif opcode == FOBOSCtrl.PWMGR_SET_GAIN_3V3:
                val = self.ctrl.Gain3v3Set(param)
                reponse = f"set 3v3 gain = {param}"
            elif opcode == FOBOSCtrl.PWMGR_GET_GAIN_3V3:
                val = self.ctrl.Gain3v3Get()
                reponse = f"set 3v3 gain = {val}"        
            elif opcode == FOBOSCtrl.PWMGR_GET_VOLT_3V3:
                val = self.ctrl.MeasVolt3v3()
                reponse = f"Get Volt 3v3 = {val}"
            elif opcode == FOBOSCtrl.PWMGR_GET_CURR_3V3:
                val = self.ctrl.MeasCurr3v3()
                reponse = f"Get Curr 3v3 = {val}"
            elif opcode == FOBOSCtrl.PWMGR_MAX_VOLT_3V3:
                val = self.ctrl.MeasMaxVolt3v3()
                reponse = f"Get Max Volt 3v3 = {val}"
            elif opcode == FOBOSCtrl.PWMGR_AVG_VOLT_3V3:
                val = self.ctrl.MeasAvgVolt3v3()
                reponse = f"Get Max Avg 3v3 = {val}"
            elif opcode == FOBOSCtrl.PWMGR_MAX_CURR_3V3:
                val = self.ctrl.MeasMaxCurr3v3()
                reponse = f"Get Max Curr 3v3 = {val}"
            elif opcode == FOBOSCtrl.PWMGR_AVG_CURR_3V3:
                val = self.ctrl.MeasAvgCurr3v3()
                reponse = f"Get Max Curr 3v3 = {val}"
            elif opcode == FOBOSCtrl.PWMGR_SET_GAIN_5V:
                val = self.ctrl.Gain5vSet(param)
                reponse = f"set = {param}"
            elif opcode == FOBOSCtrl.PWMGR_GET_GAIN_5V:
                val = self.ctrl.Gain5vGet()
                reponse = f"set 5v gain = {val}"
            elif opcode == FOBOSCtrl.PWMGR_GET_VOLT_5V:
                val = self.ctrl.MeasVolt5v()
                reponse = f"Get Volt 5v = {val}"
            elif opcode == FOBOSCtrl.PWMGR_GET_CURR_5V:
                val = self.ctrl.MeasCurr5v()
                reponse = f"Get Curr 5v = {val}"
            elif opcode == FOBOSCtrl.PWMGR_MAX_VOLT_5V:
                val = self.ctrl.MeasMaxVolt5v()
                reponse = f"Get Max Volt 5v = {val}"
            elif opcode == FOBOSCtrl.PWMGR_AVG_VOLT_5V:
                val = self.ctrl.MeasAvgVolt5v()
                reponse = f"Get Max Avg 5v = {val}"
            elif opcode == FOBOSCtrl.PWMGR_MAX_CURR_5V:
                val = self.ctrl.MeasMaxCurr5v()
                reponse = f"Get Max Curr 5v = {val}"
            elif opcode == FOBOSCtrl.PWMGR_AVG_CURR_5V:
                val = self.ctrl.MeasAvgCurr5v()
                reponse = f"Get Max Curr 5v = {val}"
            elif opcode == FOBOSCtrl.PWMGR_STAT_SW_TRIG:
                val = self.ctrl.TrigSwStat()
                reponse = f"SW trig stat = {val}"
            elif opcode == FOBOSCtrl.PWMGR_SET_VAR_ON:
                val = self.ctrl.OutVarOn()
                reponse = f"Out var on"
            elif opcode == FOBOSCtrl.PWMGR_SET_VAR_OFF:
                val = self.ctrl.OutVarOff()
                reponse = f"Out var off"


            else:
                response = 'Not implemented'
                status = -1
                return status, response

            status = 0
            return status, response
        except Exception as e:
        # else:
            print(e)
            print("error performing requested operation")
            status = -1
            response = ""
            return status, response

s = server(IP, PORT)
s.run()
