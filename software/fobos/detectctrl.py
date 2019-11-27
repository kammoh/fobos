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

import os
import re
import subprocess

class HardwareDetector():
    """"
    A class to find control board hardware. Can be used to return device file name
    """
    def __init__(self):
        pass

    def findDevFiles(self, matchString):
        """
        seach all usb devices to find the device file in /dev
        """
        cmd = ['find /sys/bus/usb/devices/usb*/ -name dev']
        dirs = subprocess.check_output(cmd, shell=True).split('\n')
        #print(dirs)
        devFiles = []
        for dir in dirs:
            #print("=============================================")
            if dir == '':
                continue
            dir = dir[0:-4] #remove the /dev at the end of dir
            #print('dir=' + dir)
            # get device name
            cmdGetDevName = ['udevadm', 'info', '-q','name', '-p', dir]
            deviceName = subprocess.check_output(cmdGetDevName)
            #print('device name= ' + deviceName)
            # get device properties
            if not deviceName.startswith('bus/'):
                cmdGetProp = ['udevadm', 'info', '-q','property', '-p', dir]
                deviceProperties = subprocess.check_output(cmdGetProp)
                #print(deviceProperties)
                s = re.search('ID_SERIAL=(.*)\n', deviceProperties)
                if s: 
                    idSerial = s.group(1)
                    if idSerial.find(matchString) != -1:
                        #print('********** dev name=' + deviceName)
                        devFiles.append(('/dev/' + deviceName).strip())

        return(devFiles)

def main():
    hd = HardwareDetector()
    files = hd.findCtrlDevFiles(matchString = 'Digilent')
    print(files)

if __name__ == '__main__':
    main()