import socket
import time
import pickle
import numpy as np
from pynq import Overlay
from pynq import Xlnk
from fobos.fobosctrl import FOBOSCtrl
from fobos.pynqctrl import PYNQCtrl
from fobos import openadc
#import numpy as np
MSG_LEN_SIZE = 10
MSG_LEN_SIZE = 10
OPCODE_SIZE = 4
STATUS_SIZE = 4
DONE_CMD = 9999
RCV_BYTES = 512
IP = '192.168.10.99'
PORT = 9995
##change these settings. they must be dynamic
TV_SIZE = 48
OUTPUT_SIZE = 16

OUT_LEN         = 4 #11# in 32-bit words
TRACE_NUM       = 10
SAMPLING_FREQ   = 10
DUT_CLK         = 1
SAMPLE_NUM      = 1000
ADC_GAIN        = 20
TV_SIZE         = 48 #108
OUTPUT_SIZE     = 16 #44
##end 
class server():
    def __init__(self, ip, port):
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.bind((ip, port))
        self.socket.listen(5)
        # instantiate hardware driver
        overlay = Overlay("ctrl_top_wrapper_rising.bit")
        self.ctrl = PYNQCtrl(overlay, inputSize = TV_SIZE, outputSize = OUTPUT_SIZE)
        self.fobosAcq = openadc.OpenADCScope(overlay)
        # self.fobosAcq.setAdcClockFreq(SAMPLING_FREQ)
        # self.fobosAcq.setGain(ADC_GAIN)
        self.samplesPerTrace = 1000
        self.xlnk = Xlnk()
        self.outputBuffer = self.xlnk.cma_array(shape=(int(self.samplesPerTrace / 4 + 2),), dtype=np.uint64)
        #Configure defaults
        self.ctrl.setDUTClk(DUT_CLK)
        self.ctrl.setOutLen(OUT_LEN)
        self.ctrl.setTriggerMode(FOBOSCtrl.TRG_FULL)
        self.ctrl.setDUTInterface(FOBOSCtrl.INTERFACE_8BIT)
        self.ctrl.forceReset()
        self.ctrl.releaseReset()
    
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
    
    def run(self):
        while True:
            self.clt, addr = self.socket.accept()
            print(f'addr = {addr}=============')
            while True:
                opcode, param = self.recvMsg()
                # print(f'msg received : opcode={opcode}, param = {param}')
                # time.sleep(1)
                if int(opcode) == FOBOSCtrl.DISCONNECT:
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

    def doOperation(self, opcode, param):
        if True:

            if opcode == FOBOSCtrl.PROCESS:
                result = self.ctrl.processData(param)
                response = result
            elif opcode == FOBOSCtrl.PROCESS_GET_TRACE:
                self.fobosAcq.arm(self.outputBuffer,int(self.samplesPerTrace/4))
                print(param)
                result = self.ctrl.processData(param)
                self.fobosAcq.waitForTrace()
                trace = self.outputBuffer.view('uint16').tolist()
                response = (result, trace,)
                print(response)

            elif opcode == FOBOSCtrl.OUT_LEN:
                print("FOBOSCtrl.OUT_LEN")
                self.ctrl.setOutLen(param)
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
                self.ctrl.setDUTInterface(FOBOSCtrl.INTERFACE_8BIT)
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
                response = f"Set dut interface = {param}"

            elif opcode == FOBOSCtrl.SET_SAMPLING_FREQ:
                response = f"Set sampling frequency = {param}"
                print(response)
                self.fobosAcq.setAdcClockFreq(param)

            elif opcode == FOBOSCtrl.SET_ADC_GAIN:
                response = f"Set ADC gain  = {param}"
                print(response)
                self.fobosAcq.setGain(param)

            elif opcode == FOBOSCtrl.SET_SAMPLES_PER_TRACE:
                response = f"samples per trace  = {param}"
                print(response)
                self.samplesPerTrace =param
                self.outputBuffer.freebuffer()
                self.outputBuffer = self.xlnk.cma_array(shape=(int(self.samplesPerTrace / 4 + 2),), dtype=np.uint64)

            else:
                response = 'Not implemented'        
            status = 0
            return status, response
        #except:

            print("error performing requested operation")
            status = -1
            response = ""
            return status, response

s = server(IP, PORT)
s.run()
