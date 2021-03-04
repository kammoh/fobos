import socket
import time
import pickle
import numpy as np
MSG_LEN_SIZE = 10
MSG_LEN_SIZE = 10
OPCODE_SIZE = 4
STATUS_SIZE = 4
IP = '127.0.0.1'
PORT = 9995

class server():

    def __init__(self, ip, port):
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.bind((ip, port))
        self.socket.listen(5)
    
    def sendResponse(self, status, response):
        ##send cmd
        #msg = f'{len(msg) + OPCODE_SIZE :<{MSG_LEN_SIZE}}' + f'{opcode:<{OPCODE_SIZE}}' + msg
        # response = bytes(f'{len(response):<{MSG_LEN_SIZE}}', 'utf-8') + response
        msg = bytes(f'{len(response) + STATUS_SIZE :<{MSG_LEN_SIZE}}' + f'{status:<{STATUS_SIZE}}', 'utf-8') +response

        # print(response)
        self.clt.send(msg)
    
    def recvMsg(self):
        # print('receiving..')
        full_msg = b''
        new_msg = True
        while True:
            msg = self.clt.recv(16)
            if new_msg:
                # print(f'new msg size is {msg[:MSG_LEN_SIZE]}')
                msg_len = int(msg[:MSG_LEN_SIZE])
                new_msg = False
            full_msg += msg
            if len(full_msg) - MSG_LEN_SIZE ==msg_len:
                # print(full_msg[MSG_LEN_SIZE:])
                a = full_msg[MSG_LEN_SIZE:]
                # print(a)
                opcode = full_msg[MSG_LEN_SIZE : MSG_LEN_SIZE + STATUS_SIZE]
                param = pickle.loads(full_msg[MSG_LEN_SIZE + STATUS_SIZE:])
                # new_msg = True
                # full_msg  = b''
                break
        return opcode, param
    
    def doOperation(self, opcode, param):
        param = int(param)

        if opcode == 10:
            response = f'Square of {param} is {param**2}'
        elif opcode == 20:
            l = [param] * 4
            response = np.array(l)
        else:
            response = 'error'        

        return response
        
    def run(self):
        while True:
            self.clt, addr = self.socket.accept()
            print(f'addr = {addr}=============')
            while True:
                opcode, param = self.recvMsg()
                print(f'msg received : opcode={opcode}, param = {param}')
                time.sleep(5)
                response = self.doOperation(int(opcode), param)
                print(f'sending response: status:')
                self.sendResponse(0, pickle.dumps(response))


s = server(IP, PORT)
s.run()