import time
import socket
import pickle
import numpy as np

MSG_LEN_SIZE = 10
OPCODE_SIZE = 4
STATUS_SIZE = 4
IP = '127.0.0.1'  # The server's hostname or IP address
PORT = 9995
# msg_size  opcode param
class Client():
    def __init__(self, ip, port):
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.connect((ip, port))
    
    def sendMsg(self, opcode, param):
        ##send cmd
        param = pickle.dumps(param)
        msg = bytes(f'{len(param) + OPCODE_SIZE :<{MSG_LEN_SIZE}}' + f'{opcode:<{OPCODE_SIZE}}', 'utf-8') + param
        # print(msg)
        self.socket.send(msg)
    
    def recvMsg(self):
        # print('receiving..')
        full_msg = b''
        new_msg = True
        while True:
            msg = self.socket.recv(16)
            if new_msg:
                print(f'new msg size is {msg[:MSG_LEN_SIZE]}')
                msg_len = int(msg[:MSG_LEN_SIZE])
                new_msg = False
            full_msg += msg
            if len(full_msg) - MSG_LEN_SIZE ==msg_len:
                # print(full_msg[MSG_LEN_SIZE:])
                response = pickle.loads(full_msg[MSG_LEN_SIZE + STATUS_SIZE:])
                # response = full_msg[MSG_LEN_SIZE + STATUS_SIZE:]

                # print(f'response = {response}')
                break
        return response


c = Client(IP, PORT)
while True:
    ##send
    
   
    opcode = 10
    param = '100'
    print('Sening message ..')
    print(f'opcode ={opcode}, param={param}')
    c.sendMsg(opcode, param)
    ###recv
    print('Receiving response ..')
    response = c.recvMsg()
    print(f"response = {response}")

    opcode = 20
    param = '2'
    print('Sening message ..')
    print(f'opcode ={opcode}, param={param}')
    c.sendMsg(opcode, param)
    ###recv
    print('Receiving response ..')
    response = c.recvMsg()
    print(f"response = {response}")