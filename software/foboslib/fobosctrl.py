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
# FOBOS control board class
# Author: Abubakr Abdulgadir
# GMU
# Aug 7 2018
# This class provide constants used by fobos contoller protocol


class FOBOSCtrl:

    # General Constants
    ACK_LEN = 4    # acknowledgement length in bytes
    PARAM_LEN = 4  # config prarameter length in bytes
    # config parameters numbers. Each number can serve as register number
    # or array index. These parameters must be sent to the hardware board.
    OUT_LEN = 0
    TRG_WAIT = 1
    TRG_LEN = 2
    TRG_MODE = 3
    TIME_TO_RST = 4
    FORCE_RST = 5
    RELEASE_RST = 6
    TIMEOUT = 7
    SET_DUT_CLK = 8
    SET_TEST_MODE = 9
    #power glitch
    POWER_GLITCH_WAIT = 11
    POWER_GLITCH_ENABLE = 12
    POWER_GLITCH_PATTERN0 = 13
    POWER_GLITCH_PATTERN1 = 14
    POWER_GLITCH_PATTERN2 = 15 #reserved
    POWER_GLITCH_PATTERN3 = 16 #reserved
    SET_DUT_INTERFACE = 17
    DISCONNECT = 18
    ####ADC
    SET_SAMPLING_FREQ = 19
    SET_ADC_GAIN = 20
    SET_SAMPLES_PER_TRACE = 21
    
    PROCESS = 100
    PROCESS_GET_TRACE = 101

    # Trigger parameters
    TRG_NORM = 0
    TRG_FULL = 1
    TRG_NORM_CLK = 2
    TRG_FULL_CLK = 3
    # test mode parameters
    ENABLED = 1
    DISABLED = 0

    ###interface types - 4bit interface is default
    INTERFACE_4BIT      = 0x00
    INTERFACE_8BIT      = 0x01
    ##########################

    
