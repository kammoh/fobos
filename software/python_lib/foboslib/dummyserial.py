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
"""FOBOS Dummy serial port
Used to creat a dummy serial port to debug the software 
without a need for real hardware connection
"""
import random
import binascii


class DummySerial():

    def randBytes(self, len):
        """
        returns a random list of bytes
        len is the number of bytes
        """
        r = []
        for i in range(0, len):
            r.append(random.randint(0, 255))
        return r

    def read(self, len):
        """
        returns a random string of bytes in hex string
        len is the number of bytes
        """
        data = self.randBytes(len)
        return binascii.hexlify(bytearray(data))

    def write(self, data):
        pass
